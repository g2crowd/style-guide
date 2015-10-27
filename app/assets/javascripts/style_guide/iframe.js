;(function (window) {
  function createMutationObserver(element) {
    var observer = new MutationObserver(setHeight);

    observer.observe(element.contentDocument.body, {
      attributes: true,
      childList: true,
      characterData: true,
      subtree: true
    });

    setHeight();

    function setHeight() {
      var currentHeight = element.height
        , newHeight = element.contentDocument.body.offsetHeight + 'px'
        ;

      if (parseInt(currentHeight, 10) !== parseInt(newHeight, 10)) {
        element.height = 0;
        element.height = newHeight;
      }
    }
  }

  window.createMutationObserver = createMutationObserver;
}(window));
