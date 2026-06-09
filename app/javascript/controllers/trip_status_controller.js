import { Controller } from "@hotwired/stimulus"
import { Modal } from "bootstrap"

export default class extends Controller {
  static targets = ["tripId", "dateInput", "error"]

  connect() {
    const el = document.getElementById("trip-finalize-modal")
    if (el) this.modal = new Modal(el)
  }

  open(event) {
    event.stopPropagation()
    const btn = event.currentTarget
    this.tripIdTarget.value  = btn.dataset.tripId
    this.dateInputTarget.min = btn.dataset.tripStart || ""
    this.dateInputTarget.value = ""
    this.errorTarget.style.display = "none"
    this.modal?.show()
  }

  confirm() {
    const dateEnd   = this.dateInputTarget.value
    const minDate   = this.dateInputTarget.min

    if (!dateEnd) {
      this.showError("Seleccioná una fecha antes de continuar.")
      return
    }

    if (minDate && dateEnd < minDate) {
      this.showError("La fecha de finalización no puede ser anterior a la de inicio.")
      return
    }

    const tripId    = this.tripIdTarget.value
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

    this.modal?.hide()

    fetch(`/trips/${tripId}/update_status`, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken,
        "Accept": "text/vnd.turbo-stream.html",
      },
      body: JSON.stringify({ date_end: dateEnd }),
    })
      .then((r) => {
        if (!r.ok) return r.json().then(j => { throw new Error(j.error) })
        return r.text()
      })
      .then((html) => window.Turbo.renderStreamMessage(html))
      .catch((err) => {
        this.modal?.show()
        this.showError(err.message || "Error al guardar la fecha.")
      })
  }

  showError(msg) {
    this.errorTarget.textContent = msg
    this.errorTarget.style.display = "block"
  }
}
