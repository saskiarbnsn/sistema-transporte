import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["aptoWrap", "aptoVencimiento"]

  connect() {
    this.toggleApto()
  }

  toggleApto() {
    const checked = this.element.querySelector('input[name$="[aptofisico]"]:checked')
    const isApto = checked?.value === "true"

    if (this.hasAptoWrapTarget) {
      this.aptoWrapTarget.style.opacity = isApto ? "1" : "0.4"
      this.aptoWrapTarget.style.pointerEvents = isApto ? "" : "none"
    }

    if (this.hasAptoVencimientoTarget) {
      this.aptoVencimientoTarget.disabled = !isApto
    }
  }
}
