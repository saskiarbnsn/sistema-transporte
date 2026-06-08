import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "badge"]

  connect() {
    this._tipEl = this._buildTip()
    this._boundEnter = this._showTip.bind(this)
    this._boundLeave = this._hideTip.bind(this)
    this._attachListeners()
  }

  disconnect() {
    this._tipEl?.remove()
    this._detachListeners()
  }

  toggle() {
    this.element.classList.toggle("is-expanded")
    this._hideTip()
  }

  clearBadge() {
    if (!this.hasBadgeTarget) return
    this.badgeTarget.remove()
  }

  _buildTip() {
    const el = document.createElement("div")
    el.style.cssText = [
      "position:fixed",
      "display:none",
      "background:#1e293b",
      "color:#fff",
      "font-size:0.78rem",
      "font-weight:500",
      "padding:4px 10px",
      "border-radius:6px",
      "white-space:nowrap",
      "pointer-events:none",
      "z-index:1090",
      "box-shadow:0 2px 8px rgba(0,0,0,.22)",
      "transform:translateY(-50%)",
    ].join(";")
    document.body.appendChild(el)
    return el
  }

  _attachListeners() {
    this.element.querySelectorAll("[data-bs-title]").forEach(el => {
      el.addEventListener("mouseenter", this._boundEnter)
      el.addEventListener("mouseleave", this._boundLeave)
    })
  }

  _detachListeners() {
    this.element.querySelectorAll("[data-bs-title]").forEach(el => {
      el.removeEventListener("mouseenter", this._boundEnter)
      el.removeEventListener("mouseleave", this._boundLeave)
    })
  }

  _showTip(e) {
    if (this.element.classList.contains("is-expanded")) return
    const title = e.currentTarget.dataset.bsTitle
    if (!title) return
    const rect = e.currentTarget.getBoundingClientRect()
    this._tipEl.textContent = title
    this._tipEl.style.top  = Math.round(rect.top + rect.height / 2) + "px"
    this._tipEl.style.left = Math.round(rect.right + 10) + "px"
    this._tipEl.style.display = "block"
  }

  _hideTip() {
    if (this._tipEl) this._tipEl.style.display = "none"
  }
}
