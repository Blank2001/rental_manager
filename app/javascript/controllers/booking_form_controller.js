import { Controller } from "@hotwired/stimulus"
import Litepicker from "litepicker"

export default class extends Controller {
  static targets = [ "bookingCollectionWrapper", "bookingReturnWrapper" ]
  connect() {
    const firstInput = document.getElementById('booking_collection_date_input')
    const secondInput = document.getElementById('booking_return_date_input')

    if (!firstInput || !secondInput) return

    const todayMidnight = new Date()
    todayMidnight.setHours(0, 0, 0, 0)

    this.picker = new Litepicker({
      element: this.bookingCollectionWrapperTarget,
      elementEnd: this.bookingReturnWrapperTarget,
      singleMode: false,
      numberOfMonths: 2,
      numberOfColumns: 2,
      minDate: todayMidnight,
      tooltip: true,
      switchingMonths: true,
      selectForward: true,
      autoApply: true,
      setup: (picker) => {
        picker.on('selected', (date1, date2) => {
          firstInput.value = date1.format('YYYY-MM-DD')
          secondInput.value = date2.format('YYYY-MM-DD')
          firstInput.form.requestSubmit()
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