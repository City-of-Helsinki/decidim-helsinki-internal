// = require decidim/editor/link_dropdown
// = require decidim/editor/buttonizer

((exports) => {
  exports.DecidimEditor = exports.DecidimEditor || {};

  const { linkDropdown, buttonizer } = exports.DecidimEditor;

  const showDropdown = (dropdown, quill) => {
    dropdown.attach(quill);
    const index = quill.getSelection().index;
    let domNode = quill.getLeaf(index)[0].domNode;
    Object.entries(dropdown.dropDownItems).forEach(e => {
      if (e[1] == domNode.parentNode.target) {
        dropdown.dropDownEl.firstChild.dataset.label = e[0]
        dropdown.currentSelectionLabel = e[0]
      }
    })
  }

  const hideDropdown = (dropdown, quill) => {
    if (dropdown.toolbarEl && dropdown.toolbarEl.hasChildNodes()) {
      dropdown.toolbarEl.childNodes.forEach(e => {
        if (e.firstChild && e.firstChild.firstChild.dataset.label === dropdown.currentSelectionLabel) {
          dropdown.detach(quill);
        }
      })
    }
  }

  const linkDropdowns = (quill, range) => {
    const format = quill.getFormat(range);

    if (format.link) {
      showDropdown(linkDropdown, quill);
      showDropdown(buttonizer, quill);
    } else {
      hideDropdown(linkDropdown, quill);
      hideDropdown(buttonizer, quill);
    }
  }

  exports.DecidimEditor.linkDropdowns = linkDropdowns;
})(window);
