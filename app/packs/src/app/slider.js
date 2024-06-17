import "src/vendor/slick";

const prevArrow = (label = "Previous") => {
  return `<button class="slick-prev slick-arrow" aria-label="${label}" type="button">&#8249;</button>`;
}
const nextArrow = (label = "Next") => {
  return `<button class="slick-next slick-arrow" aria-label="${label}" type="button">&#8250;</button>`;
}
const arrows = ($el) => {
  return {
    prev: `<div class="slick-change slick-change-prev">${prevArrow($el.data("label-prev"))}</div>`,
    next: `<div class="slick-change slick-change-next">${nextArrow($el.data("label-next"))}</div>`
  };
};

$.fn.cardSlider = function() {
  return $(this).each((_i, element) => {
    const $slider = $(element);
    const arr = arrows($slider);

    $slider.slick({
      centerMode: true,
      dots: true,
      adaptiveHeight: true,
      centerPadding: 0,
      slidesToShow: 3,
      prevArrow: arr.prev,
      nextArrow: arr.next,
      responsive: [
        {
          breakpoint: 1024,
          settings: {
            centerMode: false,
            centerPadding: "40px",
            slidesToShow: 2
          }
        },
        {
          breakpoint: 768,
          settings: {
            centerMode: false,
            centerPadding: "40px",
            slidesToShow: 1
          }
        }
      ]
    });
  });
};

$.fn.slider = function() {
  return $(this).each((_i, element) => {
    const $slider = $(element);
    const arr = arrows($slider);

    $slider.slick({
      prevArrow: arr.prev,
      nextArrow: arr.next
    });
  });
};
