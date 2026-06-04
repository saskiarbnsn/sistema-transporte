import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["customerSelect", "fieldSelect"]
  static values  = { fields: Array }

  connect() {
    this._isRebuilding = false
    this._savedFieldId = this.fieldSelectTarget.value || null
    this._rebuildFieldOptions()
  }

  onCustomerChange() {
    this._rebuildFieldOptions()
  }

  onFieldChange() {
    if (this._isRebuilding) return
    this._savedFieldId = this.fieldSelectTarget.value || null
    const fieldId = parseInt(this._savedFieldId)
    const field   = this.fieldsValue.find(f => f.id === fieldId)
    if (field?.customer_id) {
      this.customerSelectTarget.value = String(field.customer_id)
      this._rebuildFieldOptions()
    }
  }

  _rebuildFieldOptions() {
    this._isRebuilding = true
    const select     = this.fieldSelectTarget
    const customerId = parseInt(this.customerSelectTarget.value) || null
    const fields     = customerId
      ? this.fieldsValue.filter(f => f.customer_id === customerId)
      : this.fieldsValue

    select.innerHTML = '<option value="">Seleccionar...</option>'
    fields
      .slice()
      .sort((a, b) => a.name.localeCompare(b.name, "es"))
      .forEach(f => {
        const opt = document.createElement("option")
        opt.value       = f.id
        opt.textContent = f.name
        select.appendChild(opt)
      })

    if (this._savedFieldId && fields.some(f => String(f.id) === this._savedFieldId)) {
      select.value = this._savedFieldId
    } else {
      this._savedFieldId = null
    }

    // Notify trip-map while _isRebuilding is still true so onFieldChange guard fires
    select.dispatchEvent(new Event("change", { bubbles: true }))
    this._isRebuilding = false
  }
}
