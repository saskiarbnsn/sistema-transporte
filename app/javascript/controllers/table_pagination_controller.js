import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { perPage: { type: Number, default: 20 } }
  static targets = ["row", "nav"]

  connect() {
    this._page = 1
    this._render()
  }

  prev() {
    if (this._page > 1) { this._page--; this._render() }
  }

  next() {
    if (this._page < this._totalPages) { this._page++; this._render() }
  }

  toPage(e) {
    this._page = parseInt(e.currentTarget.dataset.page, 10)
    this._render()
  }

  resetPage() {
    this._page = 1
    this._render()
  }

  get _activeRows() {
    return this.rowTargets.filter(r => !r.dataset.filterHidden)
  }

  get _totalPages() {
    return Math.max(1, Math.ceil(this._activeRows.length / this.perPageValue))
  }

  _render() {
    if (this._page > this._totalPages) this._page = this._totalPages

    const active = this._activeRows
    const start = (this._page - 1) * this.perPageValue
    const end = start + this.perPageValue

    this.rowTargets.forEach(r => {
      if (r.dataset.filterHidden) return
      const idx = active.indexOf(r)
      r.style.display = (idx >= start && idx < end) ? "" : "none"
    })

    if (this.hasNavTarget) this._renderNav(active.length)
  }

  _renderNav(total) {
    if (this._totalPages <= 1) { this.navTarget.innerHTML = ""; return }

    const cur = this._page
    const pages = this._totalPages
    const start = (cur - 1) * this.perPageValue + 1
    const end = Math.min(cur * this.perPageValue, total)

    this.navTarget.innerHTML = `
      <div class="table-pagination">
        <span class="table-pagination__info">${start}–${end} de ${total}</span>
        <div class="table-pagination__controls">
          <button class="table-pagination__btn" ${cur === 1 ? "disabled" : ""}
                  data-action="click->table-pagination#prev">
            <i class="bi bi-chevron-left"></i>
          </button>
          ${this._pageButtons(pages, cur)}
          <button class="table-pagination__btn" ${cur === pages ? "disabled" : ""}
                  data-action="click->table-pagination#next">
            <i class="bi bi-chevron-right"></i>
          </button>
        </div>
      </div>
    `
  }

  _pageButtons(total, current) {
    let pages = []
    if (total <= 7) {
      pages = Array.from({ length: total }, (_, i) => i + 1)
    } else {
      pages = [1]
      if (current > 3) pages.push("…")
      for (let i = Math.max(2, current - 1); i <= Math.min(total - 1, current + 1); i++) pages.push(i)
      if (current < total - 2) pages.push("…")
      pages.push(total)
    }

    return pages.map(p =>
      p === "…"
        ? `<span class="table-pagination__ellipsis">…</span>`
        : `<button class="table-pagination__btn ${p === current ? "table-pagination__btn--active" : ""}"
                   data-action="click->table-pagination#toPage"
                   data-page="${p}">${p}</button>`
    ).join("")
  }
}
