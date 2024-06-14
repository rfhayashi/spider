for (const e of document.getElementsByTagName("a")) {
    var r = e.getBoundingClientRect();
    var div = document.createElement("div");
    div.style.position = "absolute";
    div.style.left = r.left + "px";
    div.style.top = r.top + "px";
    div.style['z-index'] = 9999;
    div.style['font-size'] = '8pt';
    div.style['font-weight'] = 'bold';
    div.style['padding'] = '0px 2px 0px 2px';
    div.style['background'] = '-webkit-gradient(linear, left top, left bottom, color-stop(0%,#FFF785), color-stop(100%,#FFC542))'; 
    div.style['color'] = '#000';
    div.style['border'] = 'solid 1px #C38A22';
    div.style['boder-radius'] = '3px';
    div.style['box-shadow'] = '0px 3px 7px 0px rgba(0, 0, 0, 0.3)';
    div.style.width = 'auto';
    var text = document.createTextNode("a");
    div.appendChild(text);
    document.body.appendChild(div);
}
