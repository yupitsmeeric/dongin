/*
js code to inject into ttu reader
TODO: 
implement pointer down and pointer up event handlers instead of relying on clicks
 */

// TODO: wrap everything in a function to give it internal scope


// TODO change this with some more reliable punctuation setting
skipMarks = [" ", ".", ","];

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
  if (skipMarks.includes(textNode.data[start])) { start++; }
  let end = offset;
  while (start >= 0 && !skipMarks.includes(textNode.data[start])) {
    start--;
  }
  if (start != 0) { start++; }
  while (end < textNode.data.length && !skipMarks.includes(textNode.data[end])) {
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

  /*
skipMarks = [" ", ".", ","];

function getTappedWord(x, y) {
  // console.log("Tap detected!!");

  const selectionText = document.getSelection().toString();

  if (document.caretPositionFromPoint) {
    // range = document.caretPositionFromPoint(e.clientX, e.clientY);
    range = document.caretPositionFromPoint(x, y);
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

let pointerDownTime = 0;
let pointerDownX = 0;
let pointerDownY = 0;

function onPointerDownHandler(e){
  // on pointer down, set the vars
  pointerDownTime = performance.now();
  pointerDownX = e.clientX;
  pointerDownY = e.clientY;
}

function onPointerUpHandler(e){
  // when the pointer goes up, 
  // measure time elapsed
  // if short, then it's a tap; return tapped word
  // if long, then its a selection change (probably)
  const elapsed = performance.now()-pointerDownTime;
  // if (elapsed > 500)

  // use setTimeout to make sure 
  setTimeout(()=>{
    const selectedText = getSelectedText();

    if (selectedText) {
      console.log(selectedText);
      return;
    }

    // check for elapsed time
    if (elapsed > 500){
      const word = getTappedWord(pointerDownX, pointerDownY);
      console.log(word);
      }
  }, 0);
}


var reader = document.getElementsByClassName('book-content');
if (reader.length != 0) {
  // reader[0].addEventListener('click', selectTappedWord, true);
  reader[0].addEventListener('pointerdown',onPointerDownHandler, true);
  reader[0].addEventListener('pointerup', onPointerUpHandler, true);
}
*/