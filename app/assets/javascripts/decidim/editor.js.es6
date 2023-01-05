// = require quill.min
// = require dynamicquilltools
// = require decidim/editor/mylink
// = require decidim/editor/dropdowns
// = require decidim/editor/mylinkhandler
// = require_self

((exports) => {
  const { MyLink, linkDropdowns, myLinkHandler } = exports.DecidimEditor;

  Quill.debug("error"); // do not show overwrite warnings
  Quill.register(MyLink);

  const quillFormats = ["bold", "italic", "link", "underline", "header", "list", "indent", "image", "alt", "video"];

  const createQuillEditor = (container) => {
    const toolbar = $(container).data("toolbar");
    const disabled = $(container).data("disabled");

    let quill = null;

    let quillToolbar = [
      ["bold", "italic", "underline"],
      [{ list: "ordered" }, { list: "bullet" }],
      ["link", "clean"]
    ];

    if (toolbar === "full") {
      quillToolbar = [
        [{ header: [1, 2, 3, 4, 5, 6, false] }],
        ...quillToolbar,
        ["image", "video"]
      ];
    } else if (toolbar === "basic") {
      quillToolbar = [
        ...quillToolbar,
        ["image", "video"]
      ];
    }

    const $input = $(container).siblings('input[type="hidden"]');
    container.innerHTML = $input.val() || "";
    quill = new Quill(container, {
      modules: {
        toolbar: {
          container: quillToolbar,
          handlers: {
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

      if (text === "\n") {
        $input.val("");
      } else {
        $input.val(quill.root.innerHTML);
      }
    });

    quill.on("selection-change", (range) => {
      if (!range) return

      linkDropdowns(quill, range);
    });
  };

  const quillEditor = () => {
    $(".editor-container").each((_idx, container) => {
      createQuillEditor(container);
    });
  };

  exports.Decidim = exports.Decidim || {};
  exports.Decidim.quillEditor = quillEditor;
  exports.Decidim.createQuillEditor = createQuillEditor;
})(window);
