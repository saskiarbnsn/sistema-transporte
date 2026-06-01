import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "frame",
    "placeholder",
    "placeholderMsg",
    "mapsLink",
    "openLinkWrap",
    "openLink",
    "fieldSelect",
    "destinationSelect"
  ]
  static values = { apiKey: String, fields: Array, destinations: Array }

  connect() { this.update() }

  update() {
    if (!this.hasFieldSelectTarget || !this.hasDestinationSelectTarget) return

    const field = this.fieldsValue.find(f => f.id === parseInt(this.fieldSelectTarget.value))
    const dest  = this.destinationsValue.find(d => d.id === parseInt(this.destinationSelectTarget.value))

    if (!field || !dest) {
      this._showPlaceholder("Seleccioná un campo de origen y un destino para ver la ruta.")
      this._hideMapsLink()
      return
    }

    const originParam = (field.latitude && field.longitude)
      ? `${field.latitude},${field.longitude}`
      : encodeURIComponent([field.name, field.province].filter(Boolean).join(", "))

    const destParam = (dest.latitude && dest.longitude)
      ? `${dest.latitude},${dest.longitude}`
      : encodeURIComponent([dest.name, dest.location].filter(Boolean).join(", "))

    const mapsUrl = `https://www.google.com/maps/dir/?api=1&origin=${originParam}&destination=${destParam}&travelmode=driving`

    if (this.hasMapsLinkTarget)  this.mapsLinkTarget.href  = mapsUrl
    if (this.hasOpenLinkTarget)  this.openLinkTarget.href  = mapsUrl

    if (this.apiKeyValue) {
      const src = `https://www.google.com/maps/embed/v1/directions?key=${this.apiKeyValue}&origin=${originParam}&destination=${destParam}&mode=driving&language=es`
      this.frameTarget.src          = src
      this.frameTarget.style.display = "block"
      this.placeholderTarget.style.display = "none"
      if (this.hasOpenLinkWrapTarget) this.openLinkWrapTarget.style.display = "block"
    } else {
      this._showPlaceholder("Configurá GOOGLE_MAPS_API_KEY en .env para ver la ruta embebida.")
      if (this.hasMapsLinkTarget) this.mapsLinkTarget.style.display = ""
      if (this.hasOpenLinkWrapTarget) this.openLinkWrapTarget.style.display = "none"
      this.frameTarget.style.display = "none"
      this.frameTarget.src = "about:blank"
    }
  }

  _showPlaceholder(msg) {
    if (this.hasPlaceholderMsgTarget) this.placeholderMsgTarget.textContent = msg
    this.placeholderTarget.style.display = "flex"
    this.frameTarget.style.display = "none"
    this.frameTarget.src = "about:blank"
  }

  _hideMapsLink() {
    if (this.hasMapsLinkTarget) this.mapsLinkTarget.style.display = "none"
    if (this.hasOpenLinkWrapTarget) this.openLinkWrapTarget.style.display = "none"
  }
}
