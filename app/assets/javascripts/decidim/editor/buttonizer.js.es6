// Add a link class dropdown to the Quill Editor's toolbar:

((exports) => {
  const Quill = exports.Quill;

  const Link = Quill.import("formats/link");
  const dropDownItems = {
    "Class": "",
    "Small button": "button primary small",
    "Small button (hollow)": "button primary hollow small",
    "Standard button": "button primary",
    "Standard button (hollow)": "button primary hollow",
    "Large button": "button primary large",
    "Large button (hollow)": "button primary hollow large"
  }

  const buttonizer = new QuillToolbarDropDown({
      label: "Link class",
      rememberSelection: false
  })

  buttonizer.setItems(dropDownItems)

  buttonizer.currentSelectionLabel = "Link class"
  buttonizer.dropDownItems = dropDownItems

  buttonizer.onSelect = (_label, value, quill) => {
      // Do whatever you want with the new dropdown selection here
      const { index, length } = quill.selection.savedRange;
      const leaf = quill.getLeaf(index);
      if (!leaf || !leaf[0]) {
        quill.setSelection(index, length);
        return;
      }

      const textBlot = leaf[0];
      const link = textBlot.parent;
      if (link instanceof Link) {
        const linkNode = link.domNode;

        if (value.length > 0) {
          linkNode.setAttribute("class", value);
        } else {
          linkNode.removeAttribute("class");
        }
      }

      // quill.setContents(quill.getContents());
      quill.setSelection(index, length);
  }

  exports.DecidimEditor = exports.DecidimEditor || {};
  exports.DecidimEditor.buttonizer = buttonizer;
})(window);
