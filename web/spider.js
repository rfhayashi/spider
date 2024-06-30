(() => {
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
    "reload-page": () => location.reload()
  }

  let ws = new WebSocket("ws://localhost:9999");
  ws.onmessage = function(e) {
    let data = JSON.parse(e.data);
    let command = commands[data.command];
    command(data.params);
  }; 
})()
