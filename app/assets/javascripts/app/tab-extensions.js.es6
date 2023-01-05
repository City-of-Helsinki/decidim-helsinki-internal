((exports) => {
  const $ = exports.$; // eslint-disable-line id-length

  $.fn.tabExtensions = function() {
    return $(this).each((_i, element) => {
      const $tabs = $(element);

      // If the location hash is present, change to that tab
      if (location.hash) {
        const $currentLink = $(`.tabs-title > a[href="${location.hash}"]`, $tabs);
        if ($currentLink.length > 0) {
          $tabs.foundation("selectTab", location.hash, true);
        }
      }

      $(".tabs-title > a", $tabs).on("click", (ev) => {
        let $link = $(ev.target);
        if (!$link.is("a")) {
          $link = $link.parents("a");
        }
        if (!$link.attr("href")) {
          return;
        }

        if (!$link.attr("href").match(/^#/)) {
          return;
        }

        const anchor = $link.attr("href");
        history.pushState(null, null, anchor);
      })
    });
  };
})(window);
