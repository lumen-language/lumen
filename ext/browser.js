setenv("whitepage", {_stash: true, macro: function (..._42args) {
  var __body31 = unstash([..._42args]);
  var ____x105 = ["<body>"];
  ____x105.alink = "\"blue\"";
  ____x105.bgcolor = "\"white\"";
  return ["<html>", join(____x105, __body31)];
}});
setenv("center", {_stash: true, macro: function (..._42args) {
  var __body33 = unstash([..._42args]);
  return join(["<center>"], __body33);
}});
setenv("tab", {_stash: true, macro: function (..._42args) {
  var __body35 = unstash([..._42args]);
  return join(["<table>", join(["<tbody>"], vals(__body35))], props(__body35));
}});
setenv("tr", {_stash: true, macro: function (..._42args) {
  var __body37 = unstash([..._42args]);
  return join(["<tr>"], __body37);
}});
setenv("td", {_stash: true, macro: function (..._42args) {
  var __body39 = unstash([..._42args]);
  return join(["<td>"], __body39);
}});
setenv("tdr", {_stash: true, macro: function (..._42args) {
  var __body41 = unstash([..._42args]);
  var ____x128 = ["<td>"];
  ____x128.align = ["quote", "right"];
  return join(____x128, __body41);
}});
setenv("trtd", {_stash: true, macro: function (..._42args) {
  var __body43 = unstash([..._42args]);
  return ["tr", join(["td"], __body43)];
}});
setenv("row", {_stash: true, macro: function (..._42args) {
  var __args3 = unstash([..._42args]);
  return join(["tr"], map(function (x) {
    return ["td", x];
  }, __args3));
}});
setenv("br", {_stash: true, macro: function (n) {
  var __form3 = ["<span>"];
  var __i3 = 0;
  while (__i3 < (n || 1)) {
    add(__form3, ["<br>"]);
    __i3 = __i3 + 1;
  }
  return __form3;
}});
setenv("br2", {_stash: true, macro: function () {
  return ["br", 2];
}});
setenv("bold", {_stash: true, macro: function (..._42args) {
  var __body45 = unstash([..._42args]);
  return join(["<b>"], __body45);
}});
blank_url = function () {
  return "ext/s.gif";
};
hspace = function (n) {
  return React.createElement("img", {height: 1, src: blank_url(), width: n});
};
vspace = function (n) {
  return React.createElement("img", {height: n, src: blank_url(), width: 0});
};
vhspace = function (h, w) {
  return React.createElement("img", {height: h, src: blank_url(), width: w});
};
setenv("px", {_stash: true, special: function (n) {
  return compile(n) + "px";
}});
style = function (k, v) {
  return k + ": " + compile(v);
};
setenv("new-hspace", {_stash: true, macro: function (n) {
  var ____x154 = ["<span>"];
  ____x154.style = ["style", "\"padding-left\"", n];
  return ____x154;
}});
spacerow = function (h) {
  return React.createElement("tr", {style: style("height", hpx)});
};
setenv("sptab", {_stash: true, macro: function (..._42args) {
  var __body47 = unstash([..._42args]);
  var ____x159 = ["<table>"];
  ____x159.style = "\"border-spacing: 7px 0px;\"";
  return join(____x159, __body47);
}});
setenv("widtable", {_stash: true, macro: function (w, ..._42args) {
  var ____r71 = unstash([..._42args]);
  var __w3 = destash33(w, ____r71);
  var ____id15 = ____r71;
  var __body49 = cut(____id15, 0);
  var ____x165 = ["<table>", ["tr", join(["td"], __body49)]];
  ____x165.width = __w3;
  return ____x165;
}});
cellpr = function (x) {
  return either(x, "&nbsp;");
};
but = function (text, name) {
  var __text3 = either(text, "submit");
  return React.createElement("input", {value: __text3, name: name, type: "submit"});
};
submit = function (val) {
  var __val3 = either(val, "submit");
  return React.createElement("input", {value: __val3, type: "submit"});
};
setenv("spanrow", {_stash: true, macro: function (n, ..._42args) {
  var ____r79 = unstash([..._42args]);
  var __n3 = destash33(n, ____r79);
  var ____id17 = ____r79;
  var __body51 = cut(____id17, 0);
  var ____x173 = ["td"];
  ____x173.colspan = __n3;
  return ["tr", join(____x173, __body51)];
}});
setenv("form", {_stash: true, macro: function (action, ..._42args) {
  var ____r81 = unstash([..._42args]);
  var __action3 = destash33(action, ____r81);
  var ____id19 = ____r81;
  var __body53 = cut(____id19, 0);
  var ____x178 = ["<form>"];
  ____x178.action = __action3;
  ____x178.method = ["quote", "post"];
  return join(____x178, __body53);
}});
setenv("textarea", {_stash: true, macro: function (name, rows, cols, ..._42args) {
  var ____r83 = unstash([..._42args]);
  var __name7 = destash33(name, ____r83);
  var __rows3 = destash33(rows, ____r83);
  var __cols3 = destash33(cols, ____r83);
  var ____id21 = ____r83;
  var __body55 = cut(____id21, 0);
  var ____x183 = ["<textarea>"];
  ____x183.name = __name7;
  ____x183.rows = __rows3;
  ____x183.cols = __cols3;
  return join(____x183, __body55);
}});
input = function (name, val, size) {
  return React.createElement("input", {value: either(val, ""), name: name, size: either(size, 10), type: "text"});
};
single_input = function (label, name, chars, btext, ..._42args) {
  var ____r87 = unstash([..._42args]);
  var __label3 = destash33(label, ____r87);
  var __name9 = destash33(name, ____r87);
  var __chars3 = destash33(chars, ____r87);
  var __btext3 = destash33(btext, ____r87);
  var ____id23 = ____r87;
  var __pwd633 = ____id23.pwd;
  var __e3 = undefined;
  if (__pwd633) {
    __e3 = "password";
  } else {
    __e3 = "text";
  }
  return React.createElement("div", {}, __label3, React.createElement("input", {name: __name9, size: __chars3, type: __e3}), " ", submit(__btext3));
};
link = function (text, dest, color) {
  return React.createElement("a", {href: either(dest, text)}, text);
};
setenv("line", {_stash: true, macro: function (..._42args) {
  var ____r91 = unstash([..._42args]);
  var ____id25 = ____r91;
  var __body57 = cut(____id25, 0);
  return join(["<span>"], __body57, [["br2"], "\"zz\""]);
}});
setenv("spanclass", {_stash: true, macro: function (name, ..._42args) {
  var ____r93 = unstash([..._42args]);
  var __name11 = destash33(name, ____r93);
  var ____id27 = ____r93;
  var __body59 = cut(____id27, 0);
  var ____x198 = ["<span>"];
  ____x198["class"] = ["quote", __name11];
  return join(____x198, __body59);
}});
pagemessage = function (text) {
  if (string63(text) && some63(text)) {
    return React.createElement("span", {}, text, React.createElement("span", {}, React.createElement("br", {}), React.createElement("br", {})), "zz");
  }
};
var render = function () {
  return React.createElement("div", {}, React.createElement("a", {href: "ext/react.js"}, "ext/react.js"));
};
var render = function () {
  return React.createElement("table", {}, React.createElement("tbody", {}, React.createElement("tr", {}, React.createElement("td", {}, link("foo", "ext/react.js"))), React.createElement("tr", {}, React.createElement("td", {}, "zz"), React.createElement("td", {}, "foo")), React.createElement("tr", {}, React.createElement("td", {}, single_input("Foo", "afoo", 20, "Submit!"))), React.createElement("tr", {}, React.createElement("td", {}, pagemessage("msg")))));
};
_G.render = render;
