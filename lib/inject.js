/*
js code to inject into ttu reader
TODO: 
implement pointer down and pointer up event handlers instead of relying on clicks
 */

// tap to select and console.log
// TODO change this with some more reliable punctuation setting
skipMarks = [" ", ".", ","];

function tapToSelect(e) {
  // console.log("Tap detected!!");

  const selectionText = document.getSelection().toString();

  if (document.caretPositionFromPoint) {
    range = document.caretPositionFromPoint(e.clientX, e.clientY);
    textNode = range.offsetNode;
    offset = range.offset;
  } else { return; }

  // check if text node and if so, do the selection
  if (!textNode || textNode.nodeType != 3) { return; }
  let newRange = document.createRange();
  let start = offset;
  // if user clicks a space, select the word after
  if (skipMarks.includes(textNode.data[start])) { start++; }
  let end = offset;
  while (start >= 0 && !skipMarks.includes(textNode.data[start])) {
    start--;
  }
  if (start != 0) { start++; }
  while (end < textNode.data.length && !skipMarks.includes(textNode.data[end])) {
    end++;
  }

  // console.log(start, end);

  newRange.setStart(textNode, start);
  newRange.setEnd(textNode, end);
  console.log(textNode.data.slice(start, end));


  const selection = window.getSelection();
  selection.removeAllRanges();
  selection.addRange(newRange);
}

function getSelectedText() {
  return document.getSelection().toString().trim();
}

let selectionTimer = null;
function onSelectionChange() {
  clearTimeout(selectionTimer);

  selectionTimer = setTimeout(() => {
    const selectedText = getSelectedText();

    if (selectedText) {
      console.log(selectedText);
      return;
    }
  },
    50);


}

document.addEventListener("selectionChange", onSelectionChange);


var reader = document.getElementsByClassName('book-content');
if (reader.length != 0) {
  reader[0].addEventListener('click', tapToSelect, true);
}