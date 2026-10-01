/*
js code to inject into ttu reader
TODO: 
implement pointer down and pointer up event handlers instead of relying on clicks
 */


function isPunctuation(c){
  return /\p{P}|\s/u.test(c);
}

function getTappedWord(e) {
  // console.log("Tap detected!!");

  let range;
  let textNode;
  let offset;

  const selectionText = document.getSelection().toString();

  if (document.caretPositionFromPoint) {
    range = document.caretPositionFromPoint(e.clientX, e.clientY);
    // range = document.caretPositionFromPoint(x, y);
    textNode = range.offsetNode;
    offset = range.offset;
  } else { return; }

  // check if text node and if so, do the selection
  if (!textNode || textNode.nodeType != 3) { return; }
  let newRange = document.createRange();
  let start = offset;
  // if user clicks a space, select the word after
  if (isPunctuation(textNode.data[start])) { start++; }
  let end = offset;
  while (start >= 0 && !isPunctuation(textNode.data[start])) {
    start--;
  }
  if (start != 0) { start++; }
  while (end < textNode.data.length && !isPunctuation(textNode.data[end])) {
    end++;
  }

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

function onSelectionChange(){
  setTimeout(()=>{
    const text = getSelectedText();
    if (text) {
        console.log(text);
    }
  }, 0)
}

var reader = document.getElementsByClassName('book-content');
if (reader.length != 0) {
  reader[0].addEventListener('click',getTappedWord, true);
  document.addEventListener('selectionchange', onSelectionChange, true);
}

// inject selection style
var style = document.createElement("style");
style.textContent = `
    ::selection {
      color: orange;
      background-color: transparent;
    }
`;
document.head.append(style);
