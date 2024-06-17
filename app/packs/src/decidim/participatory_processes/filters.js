$(() => {
  const $processesListing = $("#process-listing");
  const $loading = $processesListing.find(".loading");
  const $form = $(".order-by form");

  $form.on("change", () => {
    $loading.removeClass("hide");
    window.Rails.fire($form[0], "submit");
  });
});
