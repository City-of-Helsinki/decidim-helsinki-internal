((exports) => {
  const $ = exports.$; // eslint-disable-line id-length

  // This is called every time the modal is opened
  $.fn.modalAccessibility = function() {
    return $(this).each((_i, element) => {
      const $modal = $(element);
      const $title = $(".reveal__title:first", $modal);

      if ($title.length > 0) {
        // Focus on the title to make the screen reader to start reading the
        // content within the modal.
        $title.attr("tabindex", $title.attr("tabindex") || -1);
        $title.trigger("focus");
      }

      // Once the final modal closes, disable the focus guarding
      $modal.off("closed.zf.reveal.focusguard").on("closed.zf.reveal.focusguard", () => {
        $modal.off("closed.zf.reveal.focusguard");

        const $visibleReveal = $(".reveal:visible:last");
        if ($visibleReveal.length > 0) {
          exports.focusGuard.trap($visibleReveal[0]);
        } else {
          exports.focusGuard.disable();
        }
      });

      exports.focusGuard.trap($modal[0]);
    });
  };
})(window);
