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

  // ── Helpers ──────────────────────────────────────────────────

  parseCoord(val) {
    return parseFloat(String(val).replace(',', '.')) || null
  }

  // ── Map initialisation ───────────────────────────────────────

  initMap() {
    const lat = this.parseCoord(this.hasLatitudeTarget  ? this.latitudeTarget.value  : '')
    const lng = this.parseCoord(this.hasLongitudeTarget ? this.longitudeTarget.value : '')
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
      this.initCoordInputs()
      this.map.addListener('click', (e) => {
        const pos = e.latLng.toJSON()
        this.placeMarker(pos)
        this.reverseGeocode(e.latLng)
      })
    }

    const defaultMsg = hasCoords
      ? "Ubicación guardada."
      : this.hasSearchTarget
        ? "Buscá o hacé click en el mapa para fijar la ubicación."
        : "Escribí el domicilio o hacé click en el mapa para fijar la ubicación."
    this.showStatus(defaultMsg)
  }

  // ── Search / Autocomplete ────────────────────────────────────

  initSearch() {
    if (this.hasSearchTarget) {
      // Buscador separado (campos, destinos)
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
    } else if (this.hasLocationTarget && this.locationTarget.tagName === 'INPUT') {
      // Autocomplete directo sobre el campo domicilio (choferes)
      const autocomplete = new google.maps.places.Autocomplete(this.locationTarget, {
        fields: ['geometry', 'formatted_address'],
      })
      autocomplete.addListener('place_changed', () => {
        const place = autocomplete.getPlace()
        if (!place.geometry?.location) return
        const pos = place.geometry.location.toJSON()
        this.placeMarker(pos)
        this.map.panTo(place.geometry.location)
        this.map.setZoom(15)
        if (this.hasLatitudeTarget)  this.latitudeTarget.value  = pos.lat
        if (this.hasLongitudeTarget) this.longitudeTarget.value = pos.lng
        this.locationTarget.value = place.formatted_address
        this.showStatus("Ubicación seleccionada.")
      })
    }
  }

  // ── Coord inputs → map ──────────────────────────────────────

  initCoordInputs() {
    if (!this.hasLatitudeTarget || !this.hasLongitudeTarget) return
    const update = () => {
      const lat = this.parseCoord(this.latitudeTarget.value)
      const lng = this.parseCoord(this.longitudeTarget.value)
      if (!lat || !lng) return
      if (lat < -90 || lat > 90 || lng < -180 || lng > 180) return
      const pos = { lat, lng }
      this.placeMarker(pos)
      this.map.panTo(pos)
      this.map.setZoom(14)
      this.showStatus("Ubicación actualizada.")
    }
    this.latitudeTarget.addEventListener('input',  update)
    this.longitudeTarget.addEventListener('input', update)
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
    if (this.hasLatitudeTarget)  this.latitudeTarget.value  = String(latLng.lat).replace(',', '.')
    if (this.hasLongitudeTarget) this.longitudeTarget.value = String(latLng.lng).replace(',', '.')
    if (this.hasLocationTarget) {
      const el = this.locationTarget
      el.tagName === 'INPUT' ? (el.value = address) : (el.textContent = address)
    }
  }

  showStatus(msg) {
    if (this.hasStatusTarget) this.statusTarget.textContent = msg
  }
}
