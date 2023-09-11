import { Controller } from "stimulus";
import $ from "jquery";
import "select2";

export default class extends Controller {

  static targets = ["field"];

  connect() {
    this.initializeSelect2();
    console.log("select user controller connected");
  }

  initializeSelect2() {
    $(this.element).select2({
      ajax: {
        url: "/users/index",
        dataType: "json",
        processResults: function (data) {
          return {
            results: data,
          };
        },
        cache: true,
      },
      placeholder: "Search for users",
      minimumInputLength: 2, // Adjust as needed
    });
  }
}
