import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["total", "gravado", "iva"]

  connect() {
    this.calculate()
  }

  calculate() {
    const total   = parseFloat(this.totalTarget.value) || 0
    const gravado = total / 1.21
    const iva     = total - gravado

    if (this.hasGravadoTarget) this.gravadoTarget.value = gravado.toFixed(2)
    if (this.hasIvaTarget)     this.ivaTarget.value     = iva.toFixed(2)
  }
}
