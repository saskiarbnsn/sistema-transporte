import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "total", "netoDisplay", "ivaDisplay", "gravadoDisplay",
    "truckSelect", "truckWrap", "adelantosInput", "adelantosWrap",
    "imputacionSelect", "litrosWrap", "litrosInput"
  ]

  connect() {
    this._refreshFromState()
    this._toggleLitros()
    this.calculate()
  }

  propiosChange() {
    this._refreshFromState()
  }

  imputacionChange() {
    this._refreshFromState()
    this._toggleLitros()
    this.calculate()
  }

  calculate() {
    const total = parseFloat(this.totalTarget.value) || 0
    const imp   = this._impNombre()

    let gravado, net, iva
    if (imp === "Combustible") {
      gravado = total * 0.134
      net     = (total - gravado) / 1.21
      iva     = net * 0.21
    } else {
      gravado = 0
      net     = total / 1.21
      iva     = total - net
    }

    const fmt = n => "$ " + n.toLocaleString("es-AR", { minimumFractionDigits: 2, maximumFractionDigits: 2 })

    if (this.hasNetoDisplayTarget)    this.netoDisplayTarget.textContent    = fmt(net)
    if (this.hasIvaDisplayTarget)     this.ivaDisplayTarget.textContent     = fmt(iva)
    if (this.hasGravadoDisplayTarget) this.gravadoDisplayTarget.textContent = fmt(gravado)
  }

  _impNombre() {
    if (!this.hasImputacionSelectTarget) return ""
    return this.imputacionSelectTarget.selectedOptions[0]?.text ?? ""
  }

  _refreshFromState() {
    const checked = this.element.querySelector("input[name='gasto[truck_disabled]']:checked")
    const esPropios = checked?.value === "true"
    const imputacion = this._impNombre()

    console.log("refreshFromState:", { esPropios, imputacion })

    this._setTruck(!esPropios)
    this._setAdelantos(esPropios && imputacion === "Adelantos")
  }

  _setTruck(enabled) {
    if (!this.hasTruckSelectTarget) return
    this.truckSelectTarget.disabled = !enabled
    if (!enabled) this.truckSelectTarget.value = ""

    console.log("_setTruck:", { enabled, hasWrap: this.hasTruckWrapTarget })

    if (this.hasTruckWrapTarget) {
      this.truckWrapTarget.style.opacity = enabled ? "1" : "0.4"
      this.truckWrapTarget.style.pointerEvents = enabled ? "" : "none"
    }
  }

  _setAdelantos(enabled) {
    if (!this.hasAdelantosInputTarget) return
    this.adelantosInputTarget.disabled = !enabled
    if (!enabled) this.adelantosInputTarget.value = ""

    if (this.hasAdelantosWrapTarget) {
      this.adelantosWrapTarget.style.opacity = enabled ? "1" : "0.4"
      this.adelantosWrapTarget.style.pointerEvents = enabled ? "" : "none"
    }
  }

  _toggleLitros() {
    if (!this.hasLitrosWrapTarget) return
    const show = this._impNombre() === "Combustible"
    this.litrosWrapTarget.classList.toggle("d-none", !show)
    if (!show && this.hasLitrosInputTarget) this.litrosInputTarget.value = ""
  }
}