// Removes target="_blank" from internal links

((exports) => {
  const Link = Quill.import("formats/link");

  class MyLink extends Link {
    static create(value) {
      const url = value === Object(value) ? this.sanitize(value.href) : this.sanitize(value);

      let node = super.create(url);
      node.setAttribute("href", url);
      if (value.className) {
        node.setAttribute("class", value.className);
      }
      if (value.target) {
        node.setAttribute("target", value.target)
      } else {
        this.formatLink(node)
      }

      return node;
    }

    static formatLink(domNode) {
      const re = new RegExp('^(https?://)');
      const value = domNode.getAttribute("href")
      if (re.test(value)) {
        domNode.setAttribute("target", "_blank");
      } else {
        domNode.removeAttribute("target");
      }
    }

    format(name, value) {
      super.format(name, value);

      if (name !== this.statics.blotName || !value) {
        return;
      }

      MyLink.formatLink(this.domNode)
    }

    static formats(domNode) {
      const href = domNode.getAttribute("href");
      const className = domNode.getAttribute("class");
      const target = domNode.getAttribute("target");
      return { href: href, className: className, target: target }
    }
  }

  exports.DecidimEditor = exports.DecidimEditor || {};
  exports.DecidimEditor.MyLink = MyLink
})(window)

