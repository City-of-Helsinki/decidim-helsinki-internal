/**
 * Custom module for quilljs to allow user to drag images from their file system into the editor
 * and paste images from clipboard (Works on Chrome, Firefox, Edge, not on Safari)
 * @see https://quilljs.com/blog/building-a-custom-module/
 *
 * Origin: https://github.com/Platoniq/quill-image-upload
 *
 * This is customized to fix the following bugs with the file upload handling:
 *
 * 1. Dropping or pasting files in the very beginning of the editor content
 *    would move the file to the end of the content.
 * 2. Pasting files from the clipboard did not work with the core
 *    implementation.
 * 3. When files were pasted, the empty paragraph node was removed causing the
 *    pasted file to appear inline within the following paragraph.
 */
export default class ImageUpload {
  /**
   * Instantiate the module given a quill instance and any options
   * @param {Quill} quill
   * @param {Object} options
   */
  constructor(quill, options = {}) {
    // save the quill reference
    this.quill = quill;
    // save options
    this.options = options;
    // listen for drop and paste events
    this.quill
      .getModule("toolbar")
      .addHandler("image", this.selectLocalImage.bind(this));
    // bind handlers to this instance
    this.handleDrop = this.handleDrop.bind(this);
    this.handlePaste = this.handlePaste.bind(this);
    // listen for drop and paste events
    this.quill.root.addEventListener("drop", this.handleDrop, false);
    this.quill.root.addEventListener("paste", this.handlePaste, false);
  }

  /**
   * Select local image
   */
  selectLocalImage() {
    const input = document.createElement("input");
    input.setAttribute("type", "file");
    input.click();

    // Listen upload local image and save to server
    input.onchange = () => {
      const file = input.files[0];

      // file type is only image.
      if (/^image\//.test(file.type)) {
        const checkBeforeSend =
          this.options.checkBeforeSend || this.checkBeforeSend.bind(this);
        checkBeforeSend(file, this.sendToServer.bind(this));
      } else {
        console.warn("You could only upload images.");
      }
    };
  }

  /**
   * Check file before sending to the server
   * @param {File} file
   * @param {Function} next
   */
  checkBeforeSend(file, next) {
    next(file);
  }

  /**
   * Send to server
   * @param {File} file
   */
  sendToServer(file) {
    // Handle custom upload
    if (this.options.customUploader) {
      this.options.customUploader(file, dataUrl => {
        this.insert(dataUrl);
      });
    } else {
      const url = this.options.url,
        method = this.options.method || "POST",
        name = this.options.name || "image",
        headers = this.options.headers || {},
        callbackOK =
          this.options.callbackOK || this.uploadImageCallbackOK.bind(this),
        callbackKO =
          this.options.callbackKO || this.uploadImageCallbackKO.bind(this);

      if (url) {
        const fd = new FormData();

        fd.append(name, file);

        if (this.options.csrf) {
          // add CSRF
          fd.append(this.options.csrf.token, this.options.csrf.hash);
        }

        const xhr = new XMLHttpRequest();
        // init http query
        xhr.open(method, url, true);
        // add custom headers
        for (var index in headers) {
          xhr.setRequestHeader(index, headers[index]);
        }

        // listen callback
        xhr.onload = () => {
          if (xhr.status === 200) {
            callbackOK(JSON.parse(xhr.responseText), this.insert.bind(this));
          } else {
            callbackKO({
              code: xhr.status,
              type: xhr.statusText,
              body: xhr.responseText
            });
          }
        };

        if (this.options.withCredentials) {
          xhr.withCredentials = true;
        }
        xhr.send(fd);
      } else {
        const reader = new FileReader();

        reader.onload = event => {
          callbackOK(event.target.result, this.insert.bind(this));
        };
        reader.readAsDataURL(file);
      }
    }
  }

  /**
   * Handler for drop event to read dropped files from evt.dataTransfer
   * @param {Event} evt
   */
  handleDrop(evt) {
    evt.preventDefault();
    if (evt.dataTransfer && evt.dataTransfer.files && evt.dataTransfer.files.length) {
      // This is in the original implementation using a deprecated,
      // non-standard, JS API (unsure why it would be needed):
      //
      // if (document.caretRangeFromPoint) {
      //   const selection = document.getSelection();
      //   const range = document.caretRangeFromPoint(evt.clientX, evt.clientY);
      //   if (selection && range) {
      //     selection.setBaseAndExtent(range.startContainer, range.startOffset, range.startContainer, range.startOffset);
      //   }
      // }

      this.readFiles(evt.dataTransfer.files, this.sendToServer.bind(this));
    }
  }

  /**
   * Handler for paste event to read pasted files from evt.clipboardData
   * @param {Event} evt
  //  */
  handlePaste(evt) {
    const Delta = Quill.import("delta");
    if (evt.clipboardData && evt.clipboardData.items && evt.clipboardData.items.length) {
      this.readFiles(evt.clipboardData.items, fileBlob => {
        // This node removal would cause the file to appear inline within the
        // following node. Disabling this code keeps the file in correct
        // position without removing the empty paragraph node from the editor.
        //
        // const selection = this.quill.getSelection();
        // if (selection) {
        //   // we must be in a browser that supports pasting (like Firefox)
        //   // so it has already been placed into the editor, let's remove the node
        //   this.quill.updateContents(new Delta()
        //     .retain(selection.index - 1)
        //     .delete(1));
        // }
        // otherwise we wait until after the paste when this.quill.getSelection()
        // will return a valid index
        // setTimeout(() => this.insert(dataUrl), 0);
        setTimeout(() => this.sendToServer(fileBlob), 0);
      });
    }
  }

  /**
   * Extract image URIs a list of files from evt.dataTransfer or evt.clipboardData
   * @param {File[]} files  One or more File objects
   * @param {Function} callback  A function to send each data URI to
   */
  readFiles(files, callback) {
    // check each file for an image
    [].forEach.call(files, file => {
      if (!/^image\//.test(file.type)) {
        // file is not an image
        // Note that some file formats such as psd start with image/* but are not readable
        return;
      }

      const blob = file.getAsFile ? file.getAsFile() : file;

      // set up file reader
      const reader = new FileReader();
      reader.onload = (evt) => {
        const checkBeforeSend =
          this.options.checkBeforeSend || this.checkBeforeSend.bind(this);
        checkBeforeSend(blob, callback);
        // checkBeforeSend(evt.target.result, callback);
      };
      // read the clipboard item or file
      if (blob instanceof Blob) {
        reader.readAsDataURL(blob);
      }
    });
  }

  /**
   * Insert the image into the document at the current cursor position
   * @param {String} dataUrl  The base64-encoded image URI
   */
  insert(dataUrl) {
    let index = this.quill.getSelection()?.index;
    if (typeof index !== "number") {
      index = this.quill.getLength();
    }
    console.log(index);
    console.log(dataUrl);

    this.quill.insertEmbed(index, "image", dataUrl, "user");
  }

  /**
   * callback on image upload succesfull
   * @param {Any} response http response
   */
  uploadImageCallbackOK(response, next) {
    next(response);
  }

  /**
   * callback on image upload failed
   * @param {Any} error http error
   */
  uploadImageCallbackKO(error) {
    alert(error);
  }
}
