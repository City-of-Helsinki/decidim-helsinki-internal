// = require tribute

/**
 * Overridden because of an accessibility bug for the close modal.
 */
$(() => {
  const $multipleMentionContainer = $(".js-multiple-mentions");
  const $multipleMentionRecipientsContainer = $(".js-multiple-mentions-recipients");
  const nodatafound = $multipleMentionContainer.attr("data-noresults");
  const directMessageDisabled = $multipleMentionContainer.attr("data-direct-messages-disabled");

  const $emptyFocusTarget = $('<div tabindex="-1"></div>')
  $multipleMentionRecipientsContainer.before($emptyFocusTarget);

  const allMessages = window.Decidim.config.get("messages");
  const messages = allMessages.mentionsModal || {};
  const removeLabel = messages.remove || "Remove";

  const maxRecipients = 9;
  let mentionsCount = 0;

  /* eslint no-unused-vars: 0 */
  let deleteRecipient = function(element) {
    let $focusTarget = $(element).next();
    if ($focusTarget.length < 1) {
      $focusTarget = $(element).prev();
    }
    if ($focusTarget.length < 1) {
      $focusTarget = $emptyFocusTarget;
    }

    // Remove recipient
    element.remove();

    mentionsCount -= 1;
    // In case mentions container disable, enable again
    if ($multipleMentionContainer.prop("disabled")) {
      $multipleMentionContainer.prop("disabled", false);
    }

    // Prevent some screen readers (NVDA) from exiting back to the previously
    // focused button element which was the new conversation button behind the
    // modal.
    $focusTarget.focus();
  };

  let noMatchTemplate = null
  if (nodatafound) {
    noMatchTemplate = () => `<li>${nodatafound}</li>`;
  }

  // Returns a function, that, as long as it continues to be invoked, will not
  // be triggered. The function will be called after it stops being called for
  // N milliseconds
  /* eslint no-invalid-this: 0 */
  /* eslint consistent-this: 0 */
  /* eslint prefer-reflect: 0 */
  const debounce = function(callback, wait) {
    let timeout = null;
    return (...args) => {
      const context = this;
      clearTimeout(timeout);
      timeout = setTimeout(() => callback.apply(context, args), wait);
    };
  }

  /* eslint no-use-before-define: ["error", { "variables": false }]*/
  /* eslint no-unused-expressions: 0 */
  let remoteSearch = function(text, cb) {
    let exclusionIds = [];
    $multipleMentionRecipientsContainer.find("input[name^='recipient_id']").each(function(index) {
      exclusionIds.push($(this).val());
    });
    let query = `{users(filter:{wildcard:"${text}",excludeIds:[${exclusionIds}]}){id,nickname,name,avatarUrl,__typename,...on UserGroup{membersCount},...on User{directMessagesEnabled}}}`;
    $.post("/api", {query: query}).
      then((response) => {
        let data = response.data.users || {};
        cb(data)
      }).fail(function() {
        cb([])
      }).always(() => {
      // This function runs Tribute every single time you type something
      // So we must evalute DOM properties after each
        const $parent = $(tribute.current.element).parent();
        $parent.addClass("is-active");

        // We need to move the container to the wrapper selected
        const $tribute = $parent.find(".tribute-container");
        // Remove the inline styles, relative to absolute positioning
        $tribute.removeAttr("style");
      })
  };

  // tribute.js docs - http://github.com/zurb/tribute
  /* global Tribute*/
  /* eslint multiline-ternary: 0 */
  /* eslint no-ternary: 0 */
  let tribute = new Tribute({
    autocompleteMode: true,
    // avoid overloading the API if the user types too fast
    values: debounce(function (text, cb) {
      remoteSearch(text, (users) => cb(users));
    }, 250),
    positionMenu: true,
    menuContainer: null,
    menuItemLimit: 10,
    fillAttr: "nickname",
    noMatchTemplate: noMatchTemplate,
    lookup: (item) => item.nickname + item.name,
    selectTemplate: function(item) {
      const id = `message_recipient_${item.original.id}`;
      mentionsCount += 1;
      if (mentionsCount >= maxRecipients) {
        $multipleMentionContainer.prop("disabled", true);
      }
      if (typeof item === "undefined") {
        return null;
      }
      // Set recipient profile view
      let recipientLabel = `
        <div style="padding: 0 0 10px 0" id="${id}" class="message-recipient" tabindex="-1">
          <img src="${item.original.avatarUrl}" alt="${item.original.name}" height="35" width="35" style="border-radius: 50%;" aria-label="${item.original.name}">&nbsp;
          <b>${item.original.name}</b>
          <input type="hidden" name="recipient_id[]" value="${item.original.id}">
          <button type="button" aria-controls="${id}" class="float-right" aria-label="${removeLabel}">&times;</button>
        </div>
      `;

      // Append new recipient to DOM
      if (item.original.__typename === "UserGroup" || item.original.directMessagesEnabled === "true") {
        $multipleMentionRecipientsContainer.append($(recipientLabel));
        $multipleMentionContainer.val("");
      }

      // In order to add tabindex accessibility control to each recipient in list
      // $multipleMentionRecipientsContainer.find("label").each(function(index) {
      //   $(this).find("button").attr("tabIndex", 0).attr("aria-controls", 0).attr("aria-label", removeLabel).attr("role", "button");
      // });

      // Clean input
      return "";
    },
    menuItemTemplate: function(item) {
      let svg = "";
      let enabled = item.original.directMessagesEnabled === "true";
      if (window.Decidim && item.original.__typename === "UserGroup") {
        enabled = true;
        let icons = window.Decidim.assets["icons.svg"];
        svg = `<span class="is-group">${item.original.membersCount}x <svg class="icon--members icon"><use xlink:href="${icons}#icon-members"/></svg></span>`;
      }
      let disabledElementClass = enabled ? "" : "disabled-tribute-element";
      let disabledElementMessage = enabled ? "" : `&nbsp;<span class="disabled-tribute-element-info">${directMessageDisabled}</span>`;
      return `<div class="tribute-item ${item.original.__typename} ${disabledElementClass}">
      <span class="author__avatar"><img src="${item.original.avatarUrl}" alt="author-avatar"></span>
        <strong>${item.original.nickname}</strong>
        <small>${item.original.name}</small>
        ${svg}
        ${disabledElementMessage}
      </div>`;
    }
  });

  let setupEvents = function($element) {
    let focusActive = false;

    // DOM manipulation
    $element.on("focusin", (event) => {
      focusActive = true;

      // Set the parent container relative to the current element
      tribute.menuContainer = event.target.parentNode;
    });
    $element.on("focusout", (event) => {
      focusActive = false;
      let $parent = $(event.target).parent();

      if ($parent.hasClass("is-active")) {
        $parent.removeClass("is-active");
      }
    });
    $element.on("input", (event) => {
      let $parent = $(event.target).parent();

      if (tribute.isActive) {
        // We need to move the container to the wrapper selected
        let $tribute = $(".tribute-container");
        $tribute.appendTo($parent);
        // Remove the inline styles, relative to absolute positioning
        $tribute.removeAttr("style");
        // Parent adaptation
        $parent.addClass("is-active");
      } else {
        $parent.removeClass("is-active");
      }
    });

    // Prevent the overlay closing when a user is selected at the bottom of the
    // list (selection happens and the click proceeds to the overlay element
    // which causes the window to close). Give a bit of time for the reveal to
    // initialize the overlay before we bind these events on the overlay.
    setTimeout(() => {
      const $overlay = $element.parents(".reveal-overlay");
      if ($overlay.length > 0) {
        // The Foundation listeners are registered first which is why we need
        // to disable them first.
        $overlay.off("click.zf.dropdown tap.zf.dropdown").on("click tap", () => {
          if (focusActive || tribute.isActive) {
            return;
          }

          // Close the reveal only when we don't have focus and tribute is
          // inactive.
          $(".reveal", $overlay).foundation("close");
        });
      }
    }, 500);
  };

  let setupRecipientEvents = function($element) {
    // Allow delete with click on element in recipients list
    $element.on("click", (event) => {
      let $target = event.target.parentNode;
      if ($target.tagName === "DIV" && $target.className === "message-recipient") {
        deleteRecipient($target);
      }
    });
    // Allow delete with keypress on element in recipients list
    $element.on("keypress", (event) => {
      let $target = event.target.parentNode;
      if ($target.tagName === "DIV" && $target.className === "message-recipient") {
        deleteRecipient($target);
      }
    });
  };

  // Call only if we have containter to bind events to
  if ($multipleMentionContainer.length) {
    setupEvents($multipleMentionContainer);
    tribute.attach($multipleMentionContainer);
  }

  // Call only if we have containter to bind events to
  if ($multipleMentionRecipientsContainer.length) {
    setupRecipientEvents($multipleMentionRecipientsContainer);
  }
});
