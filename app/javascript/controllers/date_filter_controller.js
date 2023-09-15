import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="date-filter"
export default class extends Controller {

  static targets = ["from", "until", "jobs", "numberJobs", "totalPrice", "month","jobsGrid"]

  connect() {

    this.setToday();
    this.filterJobs();
  }

  setToday(){
    const today = new Date();

    const from = new Date(today.getFullYear(), today.getMonth(), 1);
    const formattedFrom = from.toISOString().split('T')[0];
    this.fromTarget.value = formattedFrom

    const until = new Date(today.getFullYear(), today.getMonth() + 1, 0);
    const formattedUntil = until.toISOString().split('T')[0];
    this.untilTarget.value = formattedUntil

    const monthName = new Intl.DateTimeFormat('en-US', { month: 'long' }).format(today);
    this.monthTarget.innerHTML = `${monthName}`;
  }

  filterJobs(){

    console.log("FilterJobs action clicked");

    const from = this.fromTarget.value;
    const until = this.untilTarget.value;

    console.log(from);
    console.log(until);

    // Make an AJAX request to your Rails controller
    fetch(`/dashboards/filter?from_date=${from}&until_date=${until}`)
    .then(response => response.text())
    .then(html => {
      console.log(html);
      this.jobsGridTarget.innerHTML = html;
    })
    .catch(error => console.error("Error:", error));

      this.updateMonthName(from,until);
  }

  updateJobs(data){
    console.log("Update Jobs Called");
    console.log(data.jobs);
    this.jobsTarget.innerHTML = '';

    this.numberJobsTarget.innerHTML = ''
    this.numberJobsTarget.innerHTML = `Total jobs for the period: ${data.jobs.length}`

    let newTotal = 0
    data.jobs.forEach(job => {
      this.jobsTarget.innerHTML += `
      <p>Cleaning job on ${job.date_of_job}: ${job.price}</p>
      `

      newTotal += job.price
    })

    this.totalPriceTarget.innerHTML = ''
    this.totalPriceTarget.innerHTML = `Total price for the period: R$ ${newTotal}`

    // this.jobsGridTarget.innerHTML = 'TEST';

  }

  previous(){
    console.log("button clicked");

    const from_date = new Date(this.fromTarget.value);
    const until_date = new Date(this.untilTarget.value);

    from_date.setUTCMonth(from_date.getUTCMonth() - 1);
    until_date.setUTCMonth(until_date.getUTCMonth() - 1);

    this.fromTarget.value = from_date.toISOString().split('T')[0];
    this.untilTarget.value = until_date.toISOString().split('T')[0];

    this.filterJobs();
  }

  next(){
    console.log("button clicked");

    const from_date = new Date(this.fromTarget.value);
    const until_date = new Date(this.untilTarget.value);

    from_date.setUTCMonth(from_date.getUTCMonth() + 1);
    until_date.setUTCMonth(until_date.getUTCMonth() + 1);

    this.fromTarget.value = from_date.toISOString().split('T')[0];
    this.untilTarget.value = until_date.toISOString().split('T')[0];

    this.filterJobs();
  }

  updateMonthName(from,until){


    const fromMonthString = from.charAt(5) + from.charAt(6);
    const untilMonthString = until.charAt(5) + until.charAt(6);


    if (fromMonthString === untilMonthString){
      // const monthName = new Intl.DateTimeFormat('en-US', { month: 'long' }).format(today);
      this.monthTarget.innerHTML = `${this.convertMonthNumberToName(fromMonthString)}`;

    } else{
      this.monthTarget.innerHTML = ``;
    }
  }

  convertMonthNumberToName(month){

    const months = [
      "January", "February", "March", "April",
      "May", "June", "July", "August",
      "September", "October", "November", "December"
    ];

    // Subtract 1 from the month number since array is 0-indexed
    const monthIndex = parseInt(month, 10) - 1;

    return months[monthIndex];

  }
}
