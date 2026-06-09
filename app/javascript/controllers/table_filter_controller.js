import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "row"]

  filter() {
    const q = normalize(this.inputTarget.value)
    this.rowTargets.forEach(row => {
      const text = normalize(Array.from(row.cells).map(c => c.textContent).join(" "))
      if (q === "" || text.includes(q)) {
        delete row.dataset.filterHidden
      } else {
        row.dataset.filterHidden = "1"
      }
    })
    this.dispatch("filtered")
  }
}

function normalize(s) {
  return s
    .normalize("NFD").replace(/[̀-ͯ]/g, "")
    .toLowerCase()
    .replace(/[-_]+/g, " ")
    .replace(/\s+/g, " ")
    .trim()
}
