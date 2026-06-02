import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tariff", "weight", "tariffDisplay", "netDisplay", "ivaDisplay"]

  connect() {
    this.calculate()
  }

  calculate() {
    const tariff = parseFloat(this.tariffTarget.value)  || 0
    const weight = parseFloat(this.weightTarget.value)  || 0
    const net    = tariff * weight / 1000
    const iva    = net * 1.21

    const fmt = v => v > 0
      ? "$ " + v.toLocaleString("es-AR", { minimumFractionDigits: 2, maximumFractionDigits: 2 })
      : "—"

    if (this.hasTariffDisplayTarget)
      this.tariffDisplayTarget.textContent = tariff > 0
        ? tariff.toLocaleString("es-AR") + " $/t"
        : "—"

    this.netDisplayTarget.textContent = fmt(net)
    this.ivaDisplayTarget.textContent = fmt(iva)
  }

  fileChosen(event) {
    const input = event.target
    const label = input.closest("label")
    if (!label) return
    const name = input.files[0]?.name ?? ""
    const span = label.querySelector("[data-filename]")
    if (span) span.textContent = name ? name : label.dataset.defaultLabel
    label.classList.toggle("file-upload-btn--chosen", !!name)
  }
}
