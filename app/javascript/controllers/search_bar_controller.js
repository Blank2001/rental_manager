// app/javascript/controllers/search_bar_controller.js
import { Controller } from "@hotwired/stimulus"
import Litepicker from "litepicker"

export default class extends Controller {
  static targets = [ "collectionWrapper", "returnWrapper" ]

  connect() {
    const firstInput = document.getElementById('collection_date_input')
    const secondInput = document.getElementById('return_date_input')

    if (!firstInput || !secondInput) return

    this.picker = new Litepicker({
      element: this.collectionWrapperTarget,
      elementEnd: this.returnWrapperTarget,
      singleMode: false,
      numberOfMonths: 2,
      numberOfColumns: 2,
      minDate: new Date(),
      tooltip: true,
      switchingMonths: true,
      selectForward: true,
      autoApply: true,
      setup: (picker) => {
        picker.on('selected', (date1, date2) => {
          firstInput.value = date1.format('YYYY-MM-DD')
          secondInput.value = date2.format('YYYY-MM-DD')
        })
      }
    })
  }

  openCalendar(event) {
    event.preventDefault()
    event.stopPropagation()
    this.picker.show()
  }
}
