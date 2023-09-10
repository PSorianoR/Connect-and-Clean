import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="job-form"
export default class extends Controller {

  static targets = ["propertySelect","propertyPrice", "propertyFrom", "propertyUntil", "cleaners", "myTeam"];

  connect() {

    this.propertyInfo()
    console.log("Controller Connected");
  }

  propertyInfo() {

    const propertyId = this.propertySelectTarget.value
    console.log(this.propertySelectTarget.value);

    if (propertyId) {
      fetch(`/properties/${propertyId}.json`)
        .then(response => response.json())
        .then(data => {
          console.log(data.property)
          console.log(data.cleaners)
          this.updateForm(data);
          this.selectedData = data;

          localStorage.setItem("cleaners", data.cleaners)
      })
      .catch(error => console.error("Error:", error))
    }


  }

  updateForm(data) {
    this.propertyPriceTarget.value = data.property.default_job_price;
    this.propertyFromTarget.value = data.property.default_cleaning_from;
    this.propertyUntilTarget.value = data.property.default_cleaning_until;

  }

  selectCleaners(event) {
    event.preventDefault()

    console.log("Function triggered");
    const cleaners = localStorage.getItem("cleaners")
    console.log(cleaners);
    this.cleanersTarget.innerHTML = ''


    cleaners.forEach(cleaner => {
      console.log(cleaner);
      this.cleanersTarget.innerHTML += `
        <div>
          <input type="hidden" name="job[cleaner_ids][]" value="${cleaner.id}">
          ${cleaner.first_name}
        </div>
      `;
    });


  }
}
