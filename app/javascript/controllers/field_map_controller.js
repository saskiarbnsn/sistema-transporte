import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas", "latitude", "longitude", "location", "status", "search"]
  static values  = { apiKey: String, readonly: Boolean }

  connect() {
    if (!this.apiKeyValue) {
      this.showStatus("Configure GOOGLE_MAPS_API_KEY en el .env para ver el mapa.")
      return
    }
    this.loadMapsApi()
  }

  disconnect() {
    if (this.marker) this.marker.setMap(null)
  }

  // ── API loading ──────────────────────────────────────────────

  loadMapsApi() {
    if (window.google?.maps) { this.initMap(); return }

    // Another controller may already be loading the script
    if (document.querySelector('script[data-maps-loading]')) {
      window.addEventListener('maps:ready', () => this.initMap(), { once: true })
      return
    }

    const script = document.createElement('script')
    script.setAttribute('data-maps-loading', 'true')
    script.async = true
    script.defer = true
    script.src = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&libraries=places&callback=__gmapsReady`

    window.__gmapsReady = () => {
      window.dispatchEvent(new Event('maps:ready'))
      this.initMap()
    }

    document.head.appendChild(script)
    window.addEventListener('maps:ready', () => this.initMap(), { once: true })
  }

  // ── Map initialisation ───────────────────────────────────────

  initMap() {
    const lat = parseFloat(this.hasLatitudeTarget  ? this.latitudeTarget.value  : '') || null
    const lng = parseFloat(this.hasLongitudeTarget ? this.longitudeTarget.value : '') || null
    const hasCoords = lat && lng

    const center = hasCoords ? { lat, lng } : { lat: -33.0, lng: -64.0 }

    this.map = new google.maps.Map(this.canvasTarget, {
      center,
      zoom: hasCoords ? 14 : 6,
      mapTypeControl: false,
      streetViewControl: false,
      fullscreenControl: false,
    })

    if (hasCoords) this.placeMarker({ lat, lng })

    if (!this.readonlyValue) {
      this.initSearch()
      this.map.addListener('click', (e) => {
        const pos = e.latLng.toJSON()
        this.placeMarker(pos)
        this.reverseGeocode(e.latLng)
      })
    }

    this.showStatus(hasCoords ? "Ubicación guardada." : "Buscá o hacé click en el mapa para fijar la ubicación.")
  }

  // ── Search box ───────────────────────────────────────────────

  initSearch() {
    if (!this.hasSearchTarget) return

    const searchBox = new google.maps.places.SearchBox(this.searchTarget)

    searchBox.addListener('places_changed', () => {
      const places = searchBox.getPlaces()
      if (!places?.length) return

      const place = places[0]
      if (!place.geometry?.location) return

      const pos = place.geometry.location.toJSON()
      this.placeMarker(pos)
      this.map.panTo(place.geometry.location)
      this.map.setZoom(15)
      this.updateFields(pos, place.formatted_address)
      this.showStatus("Ubicación seleccionada.")
    })
  }

  // ── Marker ───────────────────────────────────────────────────

  placeMarker(position) {
    if (this.marker) {
      this.marker.setPosition(position)
    } else {
      this.marker = new google.maps.Marker({
        position,
        map: this.map,
        draggable: !this.readonlyValue,
        animation: google.maps.Animation.DROP,
      })

      if (!this.readonlyValue) {
        this.marker.addListener('dragend', (e) => {
          this.reverseGeocode(e.latLng)
        })
      }
    }
  }

  // ── Geocoding ─────────────────────────────────────────────────

  reverseGeocode(latLng) {
    const geocoder = new google.maps.Geocoder()
    geocoder.geocode({ location: latLng }, (results, status) => {
      if (status === 'OK' && results[0]) {
        this.updateFields(latLng.toJSON(), results[0].formatted_address)
        this.showStatus("Ubicación seleccionada.")
      }
    })
  }

  // ── Field updates ────────────────────────────────────────────

  updateFields(latLng, address) {
    if (this.hasLatitudeTarget)  this.latitudeTarget.value  = latLng.lat
    if (this.hasLongitudeTarget) this.longitudeTarget.value = latLng.lng
    if (this.hasLocationTarget) {
      const el = this.locationTarget
      el.tagName === 'INPUT' ? (el.value = address) : (el.textContent = address)
    }
  }

  showStatus(msg) {
    if (this.hasStatusTarget) this.statusTarget.textContent = msg
  }
}
