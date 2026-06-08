import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "row"]

  filter() {
    const q = normalize(this.inputTarget.value)
    this.rowTargets.forEach(row => {
      const text = normalize(Array.from(row.cells).map(c => c.textContent).join(" "))
      row.style.display = q === "" || text.includes(q) ? "" : "none"
    })
  }
}

function normalize(s) {
  return s.toLowerCase().replace(/[-_]+/g, " ").replace(/\s+/g, " ").trim()
}
