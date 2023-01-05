// Add a custom DropDown Menu to the Quill Editor's toolbar:

((exports) => {
  const Quill = exports.Quill;

  const Link = Quill.import("formats/link");
  const dropDownItems = {
    "Link": "",
    "New tab": "_blank"
  }

  const linkDropdown = new QuillToolbarDropDown({
      label: "Link target",
      rememberSelection: false
  })

  linkDropdown.setItems(dropDownItems)

  linkDropdown.currentSelectionLabel = "Link target"
  linkDropdown.dropDownItems = dropDownItems

  linkDropdown.onSelect = (_label, value, quill) => {
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
          linkNode.setAttribute("target", value);
        } else {
          linkNode.removeAttribute("target");
        }
      }

      quill.setSelection(index, length);
      // quill.setContents(quill.getContents());
  }
  // dropdown = linkDropdown;

  exports.DecidimEditor = exports.DecidimEditor || {};
  exports.DecidimEditor.linkDropdown = linkDropdown;
})(window);
