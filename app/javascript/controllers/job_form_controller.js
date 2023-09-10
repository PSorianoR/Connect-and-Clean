import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="job-form"
export default class extends Controller {

  static targets = ["propertySelect","propertyPrice", "propertyFrom",
                    "propertyUntil", "cleaners", "myTeam", "cleanersButton",
                    "everyoneButton", "postAll"];

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

          localStorage.setItem("cleaners", JSON.stringify(data.cleaners));
          this.selectCleaners();
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
    if (event){
      event.preventDefault()
    }

    console.log("Function triggered");
    const cleaners = JSON.parse(localStorage.getItem("cleaners"));
    console.log(cleaners);
    this.cleanersTarget.innerHTML = ''


    cleaners.forEach(cleaner => {
      console.log(cleaner);
      this.cleanersTarget.innerHTML += `
        <div class="list-group-item">
          <input type="hidden" name="job[cleaner_ids][]" value="${cleaner.id}">
          ${cleaner.first_name}
        </div>
      `;
    });

    this.cleanersButtonTarget.classList.add("btn-success");
    this.everyoneButtonTarget.classList.remove("btn-success");

    this.postAllTarget.value = "false";
  }
  eraseCleaners(event) {
    event.preventDefault()

    console.log("Function triggered");
    this.cleanersTarget.innerHTML = ''
    this.cleanersTarget.innerHTML = 'The job will be posted to all cleaners on the platform. They can then apply for the job.'

    this.cleanersButtonTarget.classList.remove("btn-success");
    this.everyoneButtonTarget.classList.add("btn-success");

    this.postAllTarget.value = "true";
  }

}
