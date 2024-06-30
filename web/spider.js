let ws = new WebSocket("ws://localhost:9999");

var hints = {};

function sendHints() {
}

function getHintElement(hint) {
}

let characters = "asdfgqwertzxcvb";

// borrowed from SurfingKeys
function genHints(total) {
  var ch, hint, hints, i, len, offset;
  hints = [""];
  offset = 0;
  while (hints.length - offset < total || hints.length === 1) {
    hint = hints[offset++];
    for (i = 0, len = characters.length; i < len; i++) {
      ch = characters[i];
      hints.push(ch + hint);
    }
  }

  hints = hints.slice(offset, offset + total);
  return hints.map(function(str) {
    return str.split('').reverse().join('');
  });
}

function addHint(keybinding, element) {
  var div = document.createElement('div');
  div.style.position = 'absolute';
  let rect = element.getBoundingClientRect();
  div.style.left = `${rect.left}px`;
  div.style.top = `${rect.top}px`;
  div.style['z-index'] = 9999;
  div.style['font-size'] = '8pt';
  div.style['font-weight'] = 'bold';
  div.style['padding'] = '0px 2px 0px 2px';
  div.style['background'] = '-webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFF785), color-stop(100%,#FFC542))';
  div.style['color'] = '#000';
  div.style['border'] = 'solid 1px #C38A22';
  div.style['border-radius'] = '3px';
  div.style['box-shadow'] = '0px 3px 7px 0px rgba(0, 0, 0, 0.3)';
  div.style.width = 'auto';
  var text = document.createTextNode(keybinding.toUpperCase());
  div.appendChild(text);
  var hints = document.getElementById("spider-hints");
  hints.appendChild(div);

}

function addHints(elements) { 
  let hintsDiv = document.createElement('div');
  hintsDiv.id = 'spider-hints';
  document.body.appendChild(hintsDiv);
  let keybindings = genHints(elements.length);
  for (i = 0; i < elements.length; i++) {
    let keybinding = keybindings[i];
    let element = elements[i];
    hints[keybinding] = element;
    addHint(keybinding, element);
  }
  sendHints();
}

function clickableElements() {
  return document.getElementsByTagName("a");
}


function showLinkHints() {
  addHints(clickableElements())
}

function hideLinkHints() {
  document.body.removeChild(document.getElementById('spider-hints'));
  hints = {};
}

function followLink(params) {
  let {hint} = params;
  let element = getHintElement(hint);
  hideLinkHints();
  element.click();
}

let commands = {
  "goto-url": (params) => {
    let {url} = params;
    window.location = url;
  },
  "scroll-down": () => window.scrollByLines(1),
  "scroll-up": () => window.scrollByLines(-1),
  "scroll-top": () => window.scroll(0, 0),
  "scroll-bottom": () => window.scroll(0, document.body.scrollHeight),
  "go-back": () => history.back(),
  "go-forward": () => history.forward(),
  "reload-page": () => location.reload(),
  "show-link-hints": showLinkHints,
  "hide-link-hints": hideLinkHints,
  "follow-link": followLink
}

ws.onmessage = function(e) {
  let data = JSON.parse(e.data);
  let command = commands[data.command];
  command(data.params);
};
