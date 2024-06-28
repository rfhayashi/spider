(() => {
  function gotoUrl(params) {
    let {url} = params;
    window.location = url;
  }

  function scrollDown() {
    window.scrollByLines(1);
  }

  function scrollUp() {
    window.scrollByLines(-1);
  }

  function scrollTop() {
    window.scroll(0, 0);
  }

  function scrollBottom() {
    window.scroll(0, document.body.scrollHeight);
  }

  function goBack() {
    history.back();
  }

  function goForward() {
    history.forward();
  }

  function reloadPage() {
    location.reload();
  }

  let commands = {
    "goto-url": gotoUrl,
    "scroll-down": scrollDown,
    "scroll-up": scrollUp,
    "scroll-top": scrollTop,
    "scroll-bottom": scrollBottom,
    "go-back": goBack,
    "go-forward": goForward,
    "reload-page": reloadPage
  }

  let ws = new WebSocket("ws://localhost:9999");
  ws.onmessage = function(e) {
    let data = JSON.parse(e.data);
    let command = commands[data.command];
    command(data.params);
  }; 
})()
