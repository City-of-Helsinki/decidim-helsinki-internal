// This file is compiled inside Decidim core pack. Code can be added here and will be executed
// as part of that pack

import "src/app/toggle-checkbox";
import "src/app/slider";
import "src/app/tab-extensions";

((exports) => {
  // eslint-disable-next-line id-length
  const $ = exports.$;

  $(() => {
    $("[data-toggle-checkbox]").toggleCheckbox();
    $(".card-slider").cardSlider();
    $(".full-slider").slider();
    $("a[data-open]").on("click", (ev) => {
      ev.preventDefault();
    });
    $(".tabs").tabExtensions();

    $(".hide-on-load").removeClass("hide-on-load");

    // Event to determine when the application scripts have finished their setup
    $(document).trigger("app-ready");
  });
})(window);
