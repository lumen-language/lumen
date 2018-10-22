var __dirname = "/code/ref/lumen-language/2018-10-21/lumen3";
var __dirname = "/code/ref/lumen-language/2018-10-21/lumen3";
setenv("tag-if", {_stash: true, macro: function (test, spec, ..._42args) {
  var ____r1 = unstash([..._42args]);
  var __test1 = destash33(test, ____r1);
  var __spec1 = destash33(spec, ____r1);
  var ____id1 = ____r1;
  var __body1 = cut(____id1, 0);
  return ["if", __test1, join([__spec1], __body1), join(["do"], __body1)];
}});
setenv("whitepage", {_stash: true, macro: function (..._42args) {
  var __body3 = unstash([..._42args]);
  var ____x14 = ["<body>"];
  ____x14.bgcolor = "\"white\"";
  ____x14.alink = "\"blue\"";
  return ["<html>", join(____x14, __body3)];
}});
setenv("center", {_stash: true, macro: function (..._42args) {
  var __body5 = unstash([..._42args]);
  return join(["<center>"], __body5);
}});
setenv("tab", {_stash: true, macro: function (..._42args) {
  var __body7 = unstash([..._42args]);
  return join(["<table>", join(["<tbody>"], vals(__body7))], props(__body7));
}});
setenv("tr", {_stash: true, macro: function (..._42args) {
  var __body9 = unstash([..._42args]);
  return join(["<tr>"], __body9);
}});
setenv("td", {_stash: true, macro: function (..._42args) {
  var __body11 = unstash([..._42args]);
  return join(["<td>"], __body11);
}});
setenv("tdr", {_stash: true, macro: function (..._42args) {
  var __body13 = unstash([..._42args]);
  var ____x37 = ["<td>"];
  ____x37.align = ["quote", "right"];
  return join(____x37, __body13);
}});
setenv("trtd", {_stash: true, macro: function (..._42args) {
  var __body15 = unstash([..._42args]);
  return ["tr", join(["td"], __body15)];
}});
setenv("row", {_stash: true, macro: function (..._42args) {
  var __args1 = unstash([..._42args]);
  return join(["tr"], map(function (x) {
    return ["td", x];
  }, __args1));
}});
setenv("br", {_stash: true, macro: function (n) {
  var __form1 = ["<span>"];
  var __i1 = 0;
  while (__i1 < (n || 1)) {
    add(__form1, ["<br>"]);
    __i1 = __i1 + 1;
  }
  return __form1;
}});
setenv("br2", {_stash: true, macro: function () {
  return ["br", 2];
}});
setenv("prbold", {_stash: true, macro: function (..._42args) {
  var __body17 = unstash([..._42args]);
  return join(["<b>"], __body17);
}});
blank_url = function () {
  return "ext/s.gif";
};
hspace = function (n) {
  return React.createElement("img", {width: n, height: 1, src: blank_url()});
};
vspace = function (n) {
  return React.createElement("img", {width: 0, height: n, src: blank_url()});
};
vhspace = function (h, w) {
  return React.createElement("img", {width: w, height: h, src: blank_url()});
};
setenv("px", {_stash: true, special: function (n) {
  return compile(n) + "px";
}});
style = function (k, v) {
  return k + ": " + compile(v);
};
setenv("new-hspace", {_stash: true, macro: function (n) {
  var ____x63 = ["<span>"];
  ____x63.style = ["style", "\"padding-left\"", n];
  return ____x63;
}});
spacerow = function (h) {
  return React.createElement("tr", {style: style("height", hpx)});
};
setenv("sptab", {_stash: true, macro: function (..._42args) {
  var __body19 = unstash([..._42args]);
  var ____x68 = ["<table>"];
  ____x68.style = "\"border-spacing: 7px 0px;\"";
  return join(____x68, __body19);
}});
setenv("widtable", {_stash: true, macro: function (w, ..._42args) {
  var ____r25 = unstash([..._42args]);
  var __w1 = destash33(w, ____r25);
  var ____id3 = ____r25;
  var __body21 = cut(____id3, 0);
  var ____x74 = ["<table>", ["tr", join(["td"], __body21)]];
  ____x74.width = __w1;
  return ____x74;
}});
cellpr = function (x) {
  return either(x, "&nbsp;");
};
but = function (text, name) {
  var __text1 = either(text, "submit");
  return React.createElement("input", {name: name, value: __text1, type: "submit"});
};
submit = function (val) {
  var __val1 = either(val, "submit");
  return React.createElement("input", {value: __val1, type: "submit"});
};
setenv("spanrow", {_stash: true, macro: function (n, ..._42args) {
  var ____r33 = unstash([..._42args]);
  var __n1 = destash33(n, ____r33);
  var ____id5 = ____r33;
  var __body23 = cut(____id5, 0);
  var ____x82 = ["td"];
  ____x82.colspan = __n1;
  return ["tr", join(____x82, __body23)];
}});
setenv("form", {_stash: true, macro: function (action, ..._42args) {
  var ____r35 = unstash([..._42args]);
  var __action1 = destash33(action, ____r35);
  var ____id7 = ____r35;
  var __body25 = cut(____id7, 0);
  var ____x87 = ["<form>"];
  ____x87.method = ["quote", "post"];
  ____x87.action = __action1;
  return join(____x87, __body25);
}});
setenv("textarea", {_stash: true, macro: function (name, rows, cols, ..._42args) {
  var ____r37 = unstash([..._42args]);
  var __name1 = destash33(name, ____r37);
  var __rows1 = destash33(rows, ____r37);
  var __cols1 = destash33(cols, ____r37);
  var ____id9 = ____r37;
  var __body27 = cut(____id9, 0);
  var ____x92 = ["<textarea>"];
  ____x92.rows = __rows1;
  ____x92.name = __name1;
  ____x92.cols = __cols1;
  return join(____x92, __body27);
}});
input = function (name, val, size) {
  return React.createElement("input", {name: name, size: either(size, 10), value: either(val, ""), type: "text"});
};
tuples = function (l, k) {
  init(k, 2);
  var __i3 = 0;
  var __n3 = _35(l);
  while (__i3 < __n3) {
    var __r43 = [];
    var __j1 = 0;
    while (__j1 < k) {
      add(__r43, l[__i3 + __j1]);
      __j1 = __j1 + 1;
    }
    a(__r43);
    __i3 = __i3 + k;
  }
  return accum(a);
};
setenv("span", {_stash: true, macro: function (..._42args) {
  var __args3 = unstash([..._42args]);
  return join(["<span>"], __args3);
}});
setenv("inputs", {_stash: true, macro: function (..._42args) {
  var __args5 = unstash([..._42args]);
  return join(["tab"], map(function (__x118) {
    var ____id11 = __x118;
    var __name3 = ____id11[0];
    var __label1 = ____id11[1];
    var __len1 = ____id11[2];
    var __text3 = ____id11[3];
    var __gl1 = unique("gl");
    var __gt1 = unique("gt");
    var ____x132 = ["<input>"];
    ____x132.name = ["quote", __name3];
    var __e23 = undefined;
    if (__label1 === "password") {
      __e23 = "password";
    } else {
      __e23 = "text";
    }
    ____x132.type = ["quote", __e23];
    ____x132.value = __text3;
    ____x132.size = __len1;
    return ["let", __gl1, __len1, ["tr", ["td", ["cat", ["quote", __label1], "\":\""]], ["if", ["obj?", __gl1], ["td", ["textarea", ["quote", __name3], ["hd", __gl1], ["at", __gl1, 1], __text3]], ["td", ____x132]]]];
  }, tuples(__args5, 4)));
}});
single_input = function (label, name, chars, btext, ..._42args) {
  var ____r47 = unstash([..._42args]);
  var __label3 = destash33(label, ____r47);
  var __name5 = destash33(name, ____r47);
  var __chars1 = destash33(chars, ____r47);
  var __btext1 = destash33(btext, ____r47);
  var ____id13 = ____r47;
  var __pwd631 = ____id13.pwd;
  var __e24 = undefined;
  if (__pwd631) {
    __e24 = "password";
  } else {
    __e24 = "text";
  }
  return React.createElement("div", {}, __label3, React.createElement("input", {name: __name5, size: __chars1, type: __e24}), " ", submit(__btext1));
};
link = function (text, dest, color) {
  return React.createElement("a", {href: either(dest, text)}, text);
};
setenv("line", {_stash: true, macro: function (..._42args) {
  var ____r51 = unstash([..._42args]);
  var ____id15 = ____r51;
  var __body29 = cut(____id15, 0);
  return join(["<span>"], __body29, [["br2"], "\"zz\""]);
}});
setenv("spanclass", {_stash: true, macro: function (name, ..._42args) {
  var ____r53 = unstash([..._42args]);
  var __name7 = destash33(name, ____r53);
  var ____id17 = ____r53;
  var __body31 = cut(____id17, 0);
  var ____x149 = ["<span>"];
  ____x149["class"] = ["quote", __name7];
  return join(____x149, __body31);
}});
pagemessage = function (text) {
  if (string63(text) && some63(text)) {
    return React.createElement("span", {}, text, React.createElement("span", {}, React.createElement("br", {}), React.createElement("br", {})), "zz");
  }
};
React.createElement("Button", {});
React.createElement("a", {href: "google.com"}, "Google!");
var __dirname = "/code/ref/lumen-language/2018-10-21/lumen3";
load("lib.l");
sym = function (x) {
  return pp_to_string(x);
};
arg = function (req, k) {
  return either(req.query[k], req.body[k]);
};
if (typeof(_G.srvops) === "undefined") {
  _G.srvops = {};
}
if (typeof(_G.redirector) === "undefined") {
  _G.redirector = {};
}
if (typeof(_G.optimes) === "undefined") {
  _G.optimes = {};
}
if (typeof(_G.opcounts) === "undefined") {
  _G.opcounts = {};
}
save_optime = function (name, elapsed) {
  if (typeof(_G.opcounts[name]) === "undefined") {
    _G.opcounts[name] = 0;
  }
  _G.opcounts[name] = _G.opcounts[name] + 1;
  return _G.opcounts[name];
};
setenv("defop-raw", {_stash: true, macro: function (name, parms, ..._42args) {
  var ____r237 = unstash([..._42args]);
  var __name13 = destash33(name, ____r237);
  var __parms1 = destash33(parms, ____r237);
  var ____id45 = ____r237;
  var __body37 = cut(____id45, 0);
  return ["set", ["get", "srvops*", ["quote", __name13]], ["fn", __parms1, ["with", "x", join(["do"], __body37), ["save-optime", ["quote", __name13], 0]]]];
}});
setenv("defopr-raw", {_stash: true, macro: function (name, parms, ..._42args) {
  var ____r239 = unstash([..._42args]);
  var __name15 = destash33(name, ____r239);
  var __parms3 = destash33(parms, ____r239);
  var ____id47 = ____r239;
  var __body39 = cut(____id47, 0);
  return ["set", ["get", "redirector*", ["quote", __name15]], true, ["get", "srvops*", ["quote", __name15]], join(["fn", __parms3], __body39)];
}});
setenv("defop", {_stash: true, macro: function (name, parms, ..._42args) {
  var ____r241 = unstash([..._42args]);
  var __name17 = destash33(name, ____r241);
  var __parms5 = destash33(parms, ____r241);
  var ____id49 = ____r241;
  var __body41 = cut(____id49, 0);
  return ["do", ["wipe", ["get", "redirector*", ["quote", __name17]]], join(["defop-raw", __name17, __parms5], __body41)];
}});
setenv("defopr", {_stash: true, macro: function (name, parms, ..._42args) {
  var ____r243 = unstash([..._42args]);
  var __name19 = destash33(name, ____r243);
  var __parms7 = destash33(parms, ____r243);
  var ____id51 = ____r243;
  var __body43 = cut(____id51, 0);
  return ["do", ["set", ["get", "redirector*", ["quote", __name19]], true], join(["defop-raw", __name19, __parms7], __body43)];
}});
if (typeof(_G.unknown_msg) === "undefined") {
  _G.unknown_msg = "Unknown.";
}
if (typeof(_G.max_age) === "undefined") {
  _G.max_age = {};
}
if (typeof(_G.static_max_age) === "undefined") {
  _G.static_max_age = undefined;
}
server_render = function (x) {
  if (obj63(x)) {
    return ReactDOM.renderToString(x);
  } else {
    return either(x, "");
  }
};
respond = function (op, req, res, next) {
  print(_G.srvops);
  var ____y9 = _G.srvops[op];
  if (yes(____y9)) {
    var __f9 = ____y9;
    if (_G.redirector[op]) {
      res.location(__f9(req, res, next));
    } else {
      res.send(server_render(__f9(req, res, next)));
    }
    return true;
  }
  if (require("system").fileExists63(op)) {
    res.sendFile(__dirname + "/" + op);
    return true;
  }
};
if (typeof(_G.fns) === "undefined") {
  _G.fns = {};
}
new_fnid = function () {
  var __x425 = rand_string(10);
  if (has63(_G.fns, __x425)) {
    return new_fnid();
  } else {
    return __x425;
  }
};
fnid = function (f) {
  var __k17 = new_fnid();
  _G.fns[__k17] = f;
  return __k17;
};
if (typeof(_G.fnurl) === "undefined") {
  _G.fnurl = "/x";
}
if (typeof(_G.rfnurl) === "undefined") {
  _G.rfnurl = "/r";
}
if (typeof(_G.rfnurl2) === "undefined") {
  _G.rfnurl2 = "/y";
}
if (typeof(_G.jfnurl) === "undefined") {
  _G.jfnurl = "/a";
}
if (typeof(_G.dead_msg) === "undefined") {
  _G.dead_msg = "\nUnknown or expired link.";
}
_G.srvops.x = function (req, res, next) {
  var __it = _G.fns[sym(arg(req, "fnid"))];
  var __e25 = undefined;
  if (!( __it === undefined)) {
    __e25 = __it(req, res, next);
  } else {
    __e25 = _G.dead_msg;
  }
  var __x426 = __e25;
  save_optime("x", 0);
  return __x426;
};
_G.srvops.y = function (req, res, next) {
  var __it1 = _G.fns[sym(arg(req, "fnid"))];
  var __e26 = undefined;
  if (!( __it1 === undefined)) {
    __e26 = __it1(req, res, next);
  } else {
    __e26 = "deadlink";
  }
  var __x427 = __e26;
  save_optime("y", 0);
  return __x427;
};
_G.srvops.a = function (req, res, next) {
  var __it2 = _G.fns[sym(arg(req, "fnid"))];
  var __e27 = undefined;
  if (!( __it2 === undefined)) {
    __it2(req, res, next);
    __e27 = undefined;
  } else {
    __e27 = undefined;
  }
  var __x428 = __e27;
  save_optime("a", 0);
  return __x428;
};
_G.redirector.r = true;
_G.srvops.r = function (req, res, next) {
  var __it3 = _G.fns[sym(arg(req, "fnid"))];
  var __e28 = undefined;
  if (!( __it3 === undefined)) {
    __e28 = __it3(req, res, next);
  } else {
    __e28 = "deadlink";
  }
  var __x429 = __e28;
  save_optime("r", 0);
  return __x429;
};
delete _G.redirector.deadlink;
_G.srvops.deadlink = function (req, res, next) {
  var __x430 = _G.dead_msg;
  save_optime("deadlink", 0);
  return __x430;
};
url_for = function (fnid) {
  return _G.fnurl + "?fnid=" + fnid;
};
flink = function (f) {
  return _G.fnurl + "?fnid=" + fnid(f);
};
rflink = function (f) {
  return _G.rfnurl + "?fnid=" + fnid(f);
};
setenv("w/link", {_stash: true, macro: function (expr, ..._42args) {
  var ____r264 = unstash([..._42args]);
  var __expr3 = destash33(expr, ____r264);
  var ____id53 = ____r264;
  var __body45 = cut(____id53, 0);
  var ____x436 = ["<a>"];
  ____x436.href = ["flink", ["fn", join(), __expr3]];
  return join(____x436, __body45);
}});
setenv("w/rlink", {_stash: true, macro: function (expr, ..._42args) {
  var ____r266 = unstash([..._42args]);
  var __expr5 = destash33(expr, ____r266);
  var ____id55 = ____r266;
  var __body47 = cut(____id55, 0);
  var ____x444 = ["<a>"];
  ____x444.href = ["rflink", ["fn", join(), __expr5]];
  return join(____x444, __body47);
}});
setenv("onlink", {_stash: true, macro: function (text, ..._42args) {
  var ____r268 = unstash([..._42args]);
  var __text5 = destash33(text, ____r268);
  var ____id57 = ____r268;
  var __body49 = cut(____id57, 0);
  return ["w/link", join(["do"], __body49), __text5];
}});
setenv("onrlink", {_stash: true, macro: function (text, ..._42args) {
  var ____r270 = unstash([..._42args]);
  var __text7 = destash33(text, ____r270);
  var ____id59 = ____r270;
  var __body51 = cut(____id59, 0);
  return ["w/rlink", join(["do"], __body51), __text7];
}});
setenv("linkf", {_stash: true, macro: function (text, parms, ..._42args) {
  var ____r272 = unstash([..._42args]);
  var __text9 = destash33(text, ____r272);
  var __parms9 = destash33(parms, ____r272);
  var ____id61 = ____r272;
  var __body53 = cut(____id61, 0);
  var ____x464 = ["<a>", __text9];
  ____x464.href = ["flink", join(["fn", __parms9], __body53)];
  return ____x464;
}});
setenv("rlinkf", {_stash: true, macro: function (text, parms, ..._42args) {
  var ____r274 = unstash([..._42args]);
  var __text11 = destash33(text, ____r274);
  var __parms11 = destash33(parms, ____r274);
  var ____id63 = ____r274;
  var __body55 = cut(____id63, 0);
  var ____x472 = ["<a>", __text11];
  ____x472.href = ["rflink", join(["fn", __parms11], __body55)];
  return ____x472;
}});
setenv("whitepage", {_stash: true, macro: function (..._42args) {
  var __body57 = unstash([..._42args]);
  var ____x486 = ["<script>"];
  ____x486.src = "\"ext/react.js\"";
  var ____x487 = ["<script>"];
  ____x487.src = "\"ext/react-dom.js\"";
  var ____x488 = ["<script>"];
  ____x488.src = "\"ext/lumen.js\"";
  var ____x489 = ["<script>"];
  ____x489.src = "\"ext/browser.js\"";
  var ____x490 = ["<body>"];
  ____x490.bgcolor = "\"white\"";
  ____x490.alink = "\"blue\"";
  return ["<html>", ["<head>", ____x486, ____x487, ____x488, ____x489], join(____x490, __body57)];
}});
delete _G.redirector.hello;
_G.srvops.hello = function (req, res, next) {
  var __x491 = React.createElement("html", {}, React.createElement("head", {}, React.createElement("script", {src: "ext/react.js"}), React.createElement("script", {src: "ext/react-dom.js"}), React.createElement("script", {src: "ext/lumen.js"}), React.createElement("script", {src: "ext/browser.js"})), React.createElement("body", {bgcolor: "white", alink: "blue"}, React.createElement("a", {href: flink(function (req, res, next) {
    return React.createElement("html", {}, React.createElement("head", {}, React.createElement("script", {src: "ext/react.js"}), React.createElement("script", {src: "ext/react-dom.js"}), React.createElement("script", {src: "ext/lumen.js"}), React.createElement("script", {src: "ext/browser.js"})), React.createElement("body", {bgcolor: "white", alink: "blue"}, "asdf"));
  })}, "Woo")));
  save_optime("hello", 0);
  return __x491;
};
setenv("w/link-if", {_stash: true, macro: function (test, expr, ..._42args) {
  var ____r278 = unstash([..._42args]);
  var __test3 = destash33(test, ____r278);
  var __expr7 = destash33(expr, ____r278);
  var ____id65 = ____r278;
  var __body59 = cut(____id65, 0);
  var ____x500 = ["<a>"];
  ____x500.href = ["flink", ["fn", join(), __expr7]];
  return ["if", __test3, join(____x500, __body59), join(["do"], __body59)];
}});
fnid_field = function (id) {
  return React.createElement("input", {name: "fnid", value: id, type: "hidden"});
};
fnform = function (f, bodyfn, redir) {
  var __e29 = undefined;
  if (!( redir === undefined)) {
    __e29 = _G.rfnurl2;
  } else {
    __e29 = _G.fnurl;
  }
  return React.createElement("form", {method: "post", action: __e29}, fnid_field(fnid(f)), bodyfn());
};
setenv("aform", {_stash: true, macro: function (f, ..._42args) {
  var ____r284 = unstash([..._42args]);
  var __f11 = destash33(f, ____r284);
  var ____id67 = ____r284;
  var __body61 = cut(____id67, 0);
  var ____x510 = ["<form>", ["fnid-field", ["fnid", __f11]]];
  ____x510.method = ["quote", "post"];
  ____x510.action = "fnurl*";
  return join(____x510, __body61);
}});
if (typeof(_G.unique_ids) === "undefined") {
  _G.unique_ids = {};
}
unique_id = function (len) {
  var __id69 = rand_string(max(5, len));
  if (_G.unique_ids[__id69]) {
    return unique_id(len);
  } else {
    _G.unique_ids[__id69] = __id69;
    return _G.unique_ids[__id69];
  }
};
