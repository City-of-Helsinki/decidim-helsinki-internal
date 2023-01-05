((exports) => {
  // eslint-disable-next-line id-length
  const $ = exports.$;

  const COUNT_KEY = "%count%";
  const SR_ANNOUNCE_THRESHOLD = 0.1; // how often the screen reader announces changes in reference to the maximum characters

  $.fn.remainingCharacters = function() {
    return $(this).each((_i, element) => {
      const $input = $(element);
      const $target = $($input.data("remaining-characters"));
      const maxCharacters = parseInt($(element).attr("maxlength"), 10);
      let announcedAt = null;

      if ($target.length > 0 && maxCharacters > 0) {
        const $srTarget = $(
          `<div role="status" aria-live="polite" id="sr-characters-remaining-${Math.random().toString(16).slice(2)}" class="show-for-sr"></div>`
        );
        $target.before($srTarget);
        $target.attr("aria-hidden", "true");
        $input.attr("aria-describedby", $srTarget.attr("id"));

        const messagesJson = $input.data("remaining-characters-messages");
        const messages = $.extend({
          one: `${COUNT_KEY} character left`,
          many: `${COUNT_KEY} characters left`
        }, messagesJson);

        const getMessage = (remaining) => {
          if (remaining === 1) {
            return messages.one;
          }

          return messages.many;
        };
        const getRemaining = () => {
          return $input.val().length - numCharacters;
        };
        const updateStatus = () => {
          const remaining = getRemaining();
          let message = getMessage(remaining);

          $target.text(message.replace(COUNT_KEY, remaining));

          if (announcedAt === null || ((announcedAt - remaining) / maxCharacters) >= SR_ANNOUNCE_THRESHOLD) {
            updateSrStatus();
          }
        };
        const updateSrStatus = () => {
          announcedAt = getRemaining();
          $srTarget.text($target.text());
        };

        $input.on("keyup", () => {
          updateStatus();
        });
        $input.on("focus blur", () => {
          updateSrStatus();
        });
        updateStatus();
      }
    });
  };

})(window);
