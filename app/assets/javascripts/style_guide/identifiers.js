;(function(){
  var $identifiers = document.querySelectorAll(".style-guide-partial-identifiers span.identifier");
  var highlightPattern = new RegExp('(\\s|^)style-guide-identifier-highlight(\\s|$)');

  function addHighlight(elements) {
    for (var i = 0, element; element = elements[i]; i++) {
      element.className += " style-guide-identifier-highlight";
    }
  }

  function removeHighlight(elements) {
    for (var i = 0, element; element = elements[i]; i++) {
      element.className = element.className.replace(highlightPattern, ' ');
    }
  }

  function identifierHighlighter(event) {
    var element = event.target
      , parent = element.closest('.style-guide-partial')
      , iframe = parent.querySelector('iframe.style-guide-iframe')
      , selected = iframe.contentDocument.querySelectorAll(element.innerHTML)
      ;

    addHighlight(selected);
  }

  function identifierHighlightRemover(event) {
    var parent = event.target.closest('.style-guide-partial')
      , iframe = parent.querySelector('iframe.style-guide-iframe')
      , highlighted = iframe.contentDocument.querySelectorAll(".style-guide-identifier-highlight")
      ;

    removeHighlight(highlighted);
  }

  function highlightOnHover(elements) {
    for (var i = 0, element; element = elements[i]; i++) {
      element.onmouseover = identifierHighlighter;
      element.onmouseout = identifierHighlightRemover;
    }
  }

  highlightOnHover($identifiers);
})();
