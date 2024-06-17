export default function myLinkHandler(value) {
  if (value) {
    const range = this.quill.getSelection();
    if (range == null || range.length == 0) return;
    let preview = this.quill.getText(range);
    if (/^\S+@\S+\.\S+$/.test(preview) && preview.indexOf('mailto:') !== 0) {
      preview = 'mailto:' + preview;
    }
    let tooltip = this.quill.theme.tooltip;
    tooltip.edit('link', preview);
  } else {
    const range = this.quill.getSelection();
    if (range.length > 0) {
      this.quill.format('link', false);
    }
  }
}
