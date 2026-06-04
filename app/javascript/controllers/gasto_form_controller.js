import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["total", "netoDisplay", "ivaDisplay"]

  connect() {
    this.calculate()
  }

  calculate() {
    const total   = parseFloat(this.totalTarget.value) || 0
    const gravado = total / 1.21
    const iva     = total - gravado

    const fmt = n => '$ ' + n.toLocaleString('es-AR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })

    if (this.hasNetoDisplayTarget) this.netoDisplayTarget.textContent = fmt(gravado)
    if (this.hasIvaDisplayTarget)  this.ivaDisplayTarget.textContent  = fmt(iva)
  }
}
