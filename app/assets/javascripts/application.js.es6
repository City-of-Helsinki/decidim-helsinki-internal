// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
// = require jquery
// = require rails-ujs
// = require activestorage
// = require cable
// = require decidim
// = require ie-polyfills
// = require app/toggle-checkbox
// = require app/fix-map-toggle
// = require app/focus-guard
// = require app/modal-accessibility
// = require app/youtube-modal
// = require app/slider
// = require app/tab-extensions
// = require_self

((exports) => {
  // eslint-disable-next-line id-length
  const $ = exports.$;

  $(() => {
    exports.focusGuard = new FocusGuard(document.querySelector("body"));

    $("[data-toggle-checkbox]").toggleCheckbox();
    $("[data-open-youtube]").youtubeModal();
    $(".card-slider").cardSlider();
    $(".full-slider").slider();
    $("a[data-open]").on("click", (ev) => {
      ev.preventDefault();
    });
    $(".tabs").tabExtensions();

    $(".hide-on-load").removeClass("hide-on-load");

    $(document).on("open.zf.reveal", (ev) => {
      $(ev.target).modalAccessibility();
    });

    $("#offCanvas").on("openedEnd.zf.offCanvas", (ev) => {
      ev.target.querySelector(".main-nav a").focus();
      exports.focusGuard.trap(ev.target);
    }).on("closed.zf.offCanvas", () => {
      exports.focusGuard.disable();
    });

    // Event to determine when the application scripts have finished their setup
    $(document).trigger("app-ready");
  });
})(window);
