import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "tariff", "weight",
    "netDisplay", "ivaDisplay", "totalDisplay",
    "netInput", "ivaInput"
  ]

  connect() { this.calculate() }

  calculate() {
    const tariff = this.parseNum(this.tariffTarget?.value)
    const weight = this.parseNum(this.weightTarget?.value)
    const net    = tariff * weight
    const iva    = net * 0.21
    const total  = net + iva

    if (this.hasNetDisplayTarget)   this.netDisplayTarget.textContent   = this.fmt(net)
    if (this.hasIvaDisplayTarget)   this.ivaDisplayTarget.textContent   = this.fmt(iva)
    if (this.hasTotalDisplayTarget) this.totalDisplayTarget.textContent = this.fmt(total)

    if (this.hasNetInputTarget)  this.netInputTarget.value  = net.toFixed(2)
    if (this.hasIvaInputTarget)  this.ivaInputTarget.value  = total.toFixed(2)
  }

  parseNum(val) {
    return parseFloat(String(val || 0).replace(',', '.')) || 0
  }

  fmt(num) {
    return '$ ' + num.toLocaleString('es-AR', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
  }
}
