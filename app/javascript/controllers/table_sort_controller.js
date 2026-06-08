import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  sort(event) {
    const th = event.currentTarget
    const colIndex = Array.from(th.parentElement.children).indexOf(th)
    const tbody = this.element.querySelector("tbody")
    const rows = Array.from(tbody.querySelectorAll("tr.dash-table__row"))
    const isAsc = th.dataset.sortDir !== "asc"

    th.closest("tr").querySelectorAll("th[data-sortable]").forEach(h => {
      delete h.dataset.sortDir
      const c = h.querySelector(".sort-caret")
      if (c) { c.className = "sort-caret bi bi-caret-down-fill"; c.style.opacity = "0.3" }
    })

    th.dataset.sortDir = isAsc ? "asc" : "desc"
    const caret = th.querySelector(".sort-caret")
    if (caret) { caret.className = `sort-caret bi bi-caret-${isAsc ? "up" : "down"}-fill`; caret.style.opacity = "1" }

    rows.sort((a, b) => {
      const at = (a.cells[colIndex]?.textContent ?? "").trim()
      const bt = (b.cells[colIndex]?.textContent ?? "").trim()
      return isAsc ? compare(at, bt) : compare(bt, at)
    })

    rows.forEach(row => tbody.appendChild(row))
  }
}

function parseDate(s) {
  const m = s.match(/^(\d{2})\/(\d{2})\/(\d{4})$/)
  return m ? new Date(`${m[3]}-${m[2]}-${m[1]}`).getTime() : null
}

function parseNum(s) {
  const n = parseFloat(s.replace(/\./g, "").replace(",", ".").replace(/[^\d.-]/g, ""))
  return isNaN(n) ? null : n
}

function compare(a, b) {
  const da = parseDate(a), db = parseDate(b)
  if (da !== null && db !== null) return da - db
  const na = parseNum(a), nb = parseNum(b)
  if (na !== null && nb !== null) return na - nb
  return a.localeCompare(b, "es", { sensitivity: "base" })
}
