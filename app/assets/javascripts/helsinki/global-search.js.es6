// = require decidim/filters
// = require decidim/results_listing

((exports) => {
  // eslint-disable-next-line id-length
  const { $, delayed } = exports;
  const { History } = exports.Decidim;

  $.fn.globalSearchResults = function() {
    return $(this).each((_i, element) => {
      const $results = $(element);
      const $tab = $results.parents(".tabs-panel");
      const $pagination = $(".pagination", $results);
      const tabId = $tab.attr("id");

      $("a", $pagination).each((_j, link) => {
        const $link = $(link);
        const href = $link.attr("href").replace(/#.*$/, "");

        $link.attr("href", `${href}#${tabId}`);
      });
    });
  };

  const getLocation = () => {
    const state = History.state();
    if (state && state._path) {
      return state._path;
    }

    return location.pathname + location.search;
  }

  // This has to be delayed because the change listeners on the form are delayed
  // as well. Without being delayed, the form filters component would override
  // the history location after the form submission.
  const formSubmit = delayed(null, () => {
    const currentTab = $("#search-tabs .is-active a").attr("href");
    const path = `${getLocation()}${currentTab}`;
    History.replaceState(path, History.state());
  });

  $(() => {
    const $formWrapper = $("#search-form");
    const $tabs = $("#search-tabs");

    const updateSearchForm = () => {
      const activeSearchType = $(".tabs-title.is-active a", $tabs).data("search-type");

      $("[data-search-type]", $formWrapper).addClass("hide");
      $(`[data-search-type="${activeSearchType}"]`, $formWrapper).removeClass("hide");
    }

    updateSearchForm();
    $tabs.on("change.zf.tabs", () => {
      updateSearchForm();
    });

    $(".search-results").globalSearchResults();

    // The form filters component loses the location hash from the URL when the
    // search filters are updated. This adds the current tab as the location
    // hash, so that the tab is not lost if people copy the URL or refresh the
    // page.
    $("form", $formWrapper).on("submit", formSubmit);
  });
})(window);
