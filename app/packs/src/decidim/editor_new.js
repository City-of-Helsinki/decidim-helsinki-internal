/* eslint-disable require-jsdoc */

import lineBreakButtonHandler from "src/decidim/editor/linebreak_module"

import MyLink from "src/decidim/editor/mylink";
import linkDropdowns from "src/decidim/editor/dropdowns";
import myLinkHandler from "src/decidim/editor/mylinkhandler";

Quill.debug("error"); // do not show overwrite warnings
Quill.register(MyLink);

const quillFormats = ["bold", "italic", "link", "underline", "header", "list", "video", "image", "alt", "break"];

export default function createQuillEditor(container) {
  const toolbar = $(container).data("toolbar");
  const disabled = $(container).data("disabled");

  let quillToolbar = [
    ["bold", "italic", "underline", "linebreak"],
    [{ list: "ordered" }, { list: "bullet" }],
    ["link", "clean"]
  ];

  if (toolbar === "full") {
    quillToolbar = [
      [{ header: [1, 2, 3, 4, 5, 6, false] }],
      ...quillToolbar,
      ["video"]
    ];
  } else if (toolbar === "basic") {
    quillToolbar = [
      ...quillToolbar,
      ["video"]
    ];
  }

  const $input = $(container).siblings('input[type="hidden"]');
  container.innerHTML = $input.val() || "";

  const quill = new Quill(container, {
    modules: {
      linebreak: {},
      toolbar: {
        container: quillToolbar,
        handlers: {
          linebreak: lineBreakButtonHandler,
          link: myLinkHandler
        }
      }
    },
    formats: quillFormats,
    theme: "snow"
  });

  if (disabled) {
    quill.disable();
  }

  quill.on("text-change", () => {
    const text = quill.getText();

    // Triggers CustomEvent with the cursor position
    // It is required in input_mentions.js
    let event = new CustomEvent("quill-position", {
      detail: quill.getSelection()
    });
    container.dispatchEvent(event);

    if (text === "\n" || text === "\n\n") {
      $input.val("");
    } else {
      $input.val(quill.root.innerHTML);
    }
  });
  quill.on("selection-change", (range) => {
    if (!range) return

    linkDropdowns(quill, range);
  });

  // After editor is ready, linebreak_module deletes two extraneous new lines
  quill.emitter.emit("editor-ready");

  return quill;
}

