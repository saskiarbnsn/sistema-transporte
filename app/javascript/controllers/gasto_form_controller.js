import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "total", "netoDisplay", "ivaDisplay", "gravadoDisplay",
    "truckSelect", "truckWrap", "adelantosInput", "adelantosWrap",
    "imputacionSelect", "litrosWrap", "litrosInput",
    "confirmModal", "changeList", "impactMsg",
    "submitBtn"
  ]

  connect() {
    this._confirmed = false
    if (this.hasSubmitBtnTarget) {
      this._boundClick = this._onSubmitClick.bind(this)
      this.submitBtnTarget.addEventListener("click", this._boundClick)
    }
    this._refreshFromState()
    this._toggleLitros()
    this.calculate()
  }

  disconnect() {
    if (this._boundClick && this.hasSubmitBtnTarget) {
      this.submitBtnTarget.removeEventListener("click", this._boundClick)
    }
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

  doConfirm() {
    bootstrap.Modal.getInstance(this.confirmModalTarget)?.hide()
    this._confirmed = true
    this.submitBtnTarget.click()
  }

  // ── Private ──────────────────────────────────────────────────

  _onSubmitClick(event) {
    if (this._confirmed) { this._confirmed = false; return }

    const hasService = this.element.dataset.hasService === "true"
    if (!hasService) return

    const origTruckId    = this.element.dataset.originalTruckId    || ""
    const origTruckPlate = this.element.dataset.originalTruckPlate || "—"
    const origImpId      = this.element.dataset.originalImputationId   || ""
    const origImpName    = this.element.dataset.originalImputationName || ""

    const currentTruckId = this.hasTruckSelectTarget ? this.truckSelectTarget.value : origTruckId
    const currentImpId   = this.hasImputacionSelectTarget ? this.imputacionSelectTarget.value : origImpId

    const truckChanged      = currentTruckId !== origTruckId
    const imputationChanged = currentImpId   !== origImpId

    if (!truckChanged && !imputationChanged) return

    event.preventDefault()

    const items = []
    if (truckChanged) {
      const newPlate = this.hasTruckSelectTarget
        ? (this.truckSelectTarget.selectedOptions[0]?.text || "Sin asignar")
        : "—"
      items.push(`<li><strong>Camión:</strong> ${origTruckPlate} → ${newPlate}</li>`)
    }
    if (imputationChanged) {
      const newImpName = this.hasImputacionSelectTarget
        ? (this.imputacionSelectTarget.selectedOptions[0]?.text || "—")
        : "—"
      items.push(`<li><strong>Imputación:</strong> ${origImpName} → ${newImpName}</li>`)
    }
    this.changeListTarget.innerHTML = items.join("")

    this.impactMsgTarget.innerHTML =
      '<i class="bi bi-trash me-1"></i>Esta acción <strong>eliminará</strong> el servicio técnico asociado (el camión vuelve a su estado previo).'

    bootstrap.Modal.getOrCreateInstance(this.confirmModalTarget).show()
  }

  _impNombre() {
    if (!this.hasImputacionSelectTarget) return ""
    return this.imputacionSelectTarget.selectedOptions[0]?.text ?? ""
  }

  _refreshFromState() {
    const checked = this.element.querySelector("input[name='gasto[truck_disabled]']:checked")
    const esPropios = checked?.value === "true"
    const imputacion = this._impNombre()

    this._setTruck(!esPropios)
    this._setAdelantos(esPropios && imputacion === "Adelantos")
  }

  _setTruck(enabled) {
    if (!this.hasTruckSelectTarget) return
    this.truckSelectTarget.disabled = !enabled
    if (!enabled) this.truckSelectTarget.value = ""

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
