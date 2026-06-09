import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dateEnd"]

  updateMin(event) {
    const startVal = event.target.value
    this.dateEndTarget.min = startVal || ""
    if (startVal && this.dateEndTarget.value && this.dateEndTarget.value < startVal) {
      this.dateEndTarget.value = startVal
    }
  }
}
