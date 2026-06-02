import { Controller } from "@hotwired/stimulus"
import Chart from "chart.js/auto"

export default class extends Controller {
  static values = { labels: Array, ingresos: Array, gastos: Array }

  connect() {
    const canvas = this.element.querySelector("canvas")
    if (!canvas) return

    new Chart(canvas, {
      type: "bar",
      data: {
        labels: this.labelsValue,
        datasets: [
          {
            label: "Ingresos",
            data: this.ingresosValue,
            backgroundColor: "rgba(59,91,219,0.75)",
            borderRadius: 5,
            borderSkipped: false,
          },
          {
            label: "Gastos",
            data: this.gastosValue,
            backgroundColor: "rgba(224,49,49,0.70)",
            borderRadius: 5,
            borderSkipped: false,
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        interaction: { mode: "index" },
        plugins: {
          legend: { position: "top", labels: { font: { size: 12 } } },
          tooltip: {
            callbacks: {
              label: ctx => ` $${ctx.parsed.y.toLocaleString("es-AR")}`
            }
          }
        },
        scales: {
          y: {
            beginAtZero: true,
            ticks: {
              callback: v => "$" + Number(v).toLocaleString("es-AR", { maximumFractionDigits: 0 })
            }
          },
          x: { grid: { display: false } }
        }
      }
    })
  }
}
