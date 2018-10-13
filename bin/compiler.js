getenv = function (k, p) {
  if (string63(k)) {
    var __i = edge(_G.environment);
    while (__i >= 0) {
      var __b = _G.environment[__i][k];
      if (is63(__b)) {
        var __e8 = undefined;
        if (p) {
          __e8 = __b[p];
        } else {
          __e8 = __b;
        }
        return __e8;
      } else {
        __i = __i - 1;
      }
    }
  }
};
var macro_function = function (k) {
  return getenv(k, "macro");
};
var macro63 = function (k) {
  return is63(macro_function(k));
};
var special63 = function (k) {
  return is63(getenv(k, "special"));
};
var special_form63 = function (form) {
  return ! atom63(form) && special63(hd(form));
};
var statement63 = function (k) {
  return special63(k) && getenv(k, "stmt");
};
var symbol_expansion = function (k) {
  return getenv(k, "symbol");
};
var symbol63 = function (k) {
  return is63(symbol_expansion(k));
};
var variable63 = function (k) {
  return is63(getenv(k, "variable"));
};
bound63 = function (x) {
  return macro63(x) || special63(x) || symbol63(x) || variable63(x);
};
quoted = function (form) {
  if (string63(form)) {
    return escape(form);
  } else {
    if (atom63(form)) {
      return form;
    } else {
      return join(["list"], map(quoted, form));
    }
  }
};
unquoted = function (form) {
  if (string_literal63(form)) {
    if (read_string(form) === form) {
      return _eval(form);
    } else {
      return error("unquoted: bad string-literal");
    }
  } else {
    if (hd63(form, "quote")) {
      return form[1];
    } else {
      return compile(form);
    }
  }
};
var literal = function (s) {
  if (string_literal63(s)) {
    return s;
  } else {
    return quoted(s);
  }
};
var stash_function = function (args) {
  if (keys63(args)) {
    var __l = ["%object", "\"_stash\"", true];
    var ____o = args;
    var __k = undefined;
    for (__k of pairs(____o)) {
      var __v = ____o[__k];
      if (! number63(__k)) {
        add(__l, literal(__k));
        add(__l, __v);
      }
    }
    return join(args, [__l]);
  } else {
    return args;
  }
};
var bias = function (k) {
  if (number63(k) && !( _G.target === "js")) {
    if (_G.target === "js") {
      k = k - 1;
    } else {
      k = k + 1;
    }
  }
  return k;
};
bind = function (lh, rh) {
  if (atom63(lh)) {
    return [lh, rh];
  } else {
    var __id = unique("id");
    var __bs = [__id, rh];
    var ____o1 = lh;
    var __k1 = undefined;
    for (__k1 of pairs(____o1)) {
      var __v1 = ____o1[__k1];
      var __e9 = undefined;
      if (__k1 === "rest") {
        __e9 = ["cut", __id, _35(lh)];
      } else {
        __e9 = ["get", __id, ["quote", bias(__k1)]];
      }
      var __x5 = __e9;
      __bs = join(__bs, bind(__v1, __x5));
    }
    return __bs;
  }
};
bind_function = function (args, body) {
  var __args1 = [];
  var rest = function () {
    __args1.rest = true;
    return ["unstash", ["list", "..."]];
  };
  if (atom63(args)) {
    return [__args1, join(["let", [args, rest()]], body)];
  } else {
    var __bs1 = [];
    var __r18 = unique("r");
    var ____o2 = args;
    var __k2 = undefined;
    for (__k2 of pairs(____o2)) {
      var __v2 = ____o2[__k2];
      if (number63(__k2)) {
        if (atom63(__v2)) {
          add(__args1, __v2);
        } else {
          var __x14 = unique("x");
          add(__args1, __x14);
          __bs1 = join(__bs1, [__v2, __x14]);
        }
      }
    }
    if (keys63(args)) {
      __bs1 = join(__bs1, [__r18, rest()]);
      var __n3 = _35(__args1);
      var __i4 = 0;
      while (__i4 < __n3) {
        var __v3 = __args1[__i4];
        __bs1 = join(__bs1, [__v3, ["destash!", __v3, __r18]]);
        __i4 = __i4 + 1;
      }
      __bs1 = join(__bs1, [keys(args), __r18]);
    }
    return [__args1, join(["let", __bs1], body)];
  }
};
var quoting63 = function (depth) {
  return number63(depth);
};
var quasiquoting63 = function (depth) {
  return quoting63(depth) && depth > 0;
};
var can_unquote63 = function (depth) {
  return quoting63(depth) && depth === 1;
};
var quasisplice63 = function (x, depth) {
  return can_unquote63(depth) && ! atom63(x) && hd(x) === "unquote-splicing";
};
var expand_local = function (__x22) {
  var ____id1 = __x22;
  var __x23 = ____id1[0];
  var __name = ____id1[1];
  var __value = ____id1[2];
  setenv(__name, {_stash: true, variable: true});
  return ["%local", macroexpand(__name), macroexpand(__value)];
};
var expand_function = function (__x25) {
  var ____id2 = __x25;
  var __x26 = ____id2[0];
  var __args = ____id2[1];
  var __body = cut(____id2, 2);
  add(_G.environment, {});
  var ____o3 = __args;
  var ____i5 = undefined;
  for (____i5 of pairs(____o3)) {
    var ____x27 = ____o3[____i5];
    setenv(____x27, {_stash: true, variable: true});
  }
  var ____x28 = join(["%function", __args], macroexpand(__body));
  drop(_G.environment);
  return ____x28;
};
var expand_definition = function (__x30) {
  var ____id3 = __x30;
  var __x31 = ____id3[0];
  var __name1 = ____id3[1];
  var __args11 = ____id3[2];
  var __body1 = cut(____id3, 3);
  add(_G.environment, {});
  var ____o4 = __args11;
  var ____i6 = undefined;
  for (____i6 of pairs(____o4)) {
    var ____x32 = ____o4[____i6];
    setenv(____x32, {_stash: true, variable: true});
  }
  var ____x33 = join([__x31, macroexpand(__name1), __args11], macroexpand(__body1));
  drop(_G.environment);
  return ____x33;
};
var expand_macro = function (form) {
  return macroexpand(expand1(form));
};
expand1 = function (__x35) {
  var ____id4 = __x35;
  var __name2 = ____id4[0];
  var __body2 = cut(____id4, 1);
  return apply(macro_function(__name2), __body2);
};
macroexpand = function (form) {
  if (symbol63(form)) {
    return macroexpand(symbol_expansion(form));
  } else {
    if (atom63(form)) {
      return form;
    } else {
      var __x36 = hd(form);
      if (__x36 === "%local") {
        return expand_local(form);
      } else {
        if (__x36 === "%function") {
          return expand_function(form);
        } else {
          if (__x36 === "%global-function") {
            return expand_definition(form);
          } else {
            if (__x36 === "%local-function") {
              return expand_definition(form);
            } else {
              if (macro63(__x36)) {
                return expand_macro(form);
              } else {
                return map(macroexpand, form);
              }
            }
          }
        }
      }
    }
  }
};
var quasiquote_list = function (form, depth) {
  var __xs = [["list"]];
  var ____o5 = form;
  var __k3 = undefined;
  for (__k3 of pairs(____o5)) {
    var __v4 = ____o5[__k3];
    if (! number63(__k3)) {
      var __e10 = undefined;
      if (quasisplice63(__v4, depth)) {
        __e10 = quasiexpand(__v4[1]);
      } else {
        __e10 = quasiexpand(__v4, depth);
      }
      var __v5 = __e10;
      last(__xs)[__k3] = __v5;
    }
  }
  var ____x39 = form;
  var ____i8 = 0;
  while (____i8 < _35(____x39)) {
    var __x40 = ____x39[____i8];
    if (quasisplice63(__x40, depth)) {
      var __x41 = quasiexpand(__x40[1]);
      add(__xs, __x41);
      add(__xs, ["list"]);
    } else {
      add(last(__xs), quasiexpand(__x40, depth));
    }
    ____i8 = ____i8 + 1;
  }
  var __pruned = keep(function (x) {
    return _35(x) > 1 || !( hd(x) === "list") || keys63(x);
  }, __xs);
  if (one63(__pruned)) {
    return hd(__pruned);
  } else {
    return join(["join"], __pruned);
  }
};
quasiexpand = function (form, depth) {
  if (quasiquoting63(depth)) {
    if (atom63(form)) {
      return ["quote", form];
    } else {
      if (can_unquote63(depth) && hd(form) === "unquote") {
        return quasiexpand(form[1]);
      } else {
        if (hd(form) === "unquote" || hd(form) === "unquote-splicing") {
          return quasiquote_list(form, depth - 1);
        } else {
          if (hd(form) === "quasiquote") {
            return quasiquote_list(form, depth + 1);
          } else {
            return quasiquote_list(form, depth);
          }
        }
      }
    }
  } else {
    if (atom63(form)) {
      return form;
    } else {
      if (hd(form) === "quote") {
        return form;
      } else {
        if (hd(form) === "quasiquote") {
          return quasiexpand(form[1], 1);
        } else {
          return map(function (x) {
            return quasiexpand(x, depth);
          }, form);
        }
      }
    }
  }
};
expand_if = function (__x45) {
  var ____id5 = __x45;
  var __a = ____id5[0];
  var __b1 = ____id5[1];
  var __c = cut(____id5, 2);
  if (is63(__b1)) {
    return [join(["%if", __a, __b1], expand_if(__c))];
  } else {
    if (is63(__a)) {
      return [__a];
    }
  }
};
_G.indent_level = 0;
indentation = function () {
  var __s = "";
  var __i9 = 0;
  while (__i9 < _G.indent_level) {
    __s = __s + "  ";
    __i9 = __i9 + 1;
  }
  return __s;
};
var reserved = {js: {["="]: true, ["=="]: true, ["+"]: true, ["-"]: true, ["%"]: true, ["*"]: true, ["/"]: true, ["<"]: true, [">"]: true, ["<="]: true, [">="]: true, ["break"]: true, ["case"]: true, ["catch"]: true, ["class"]: true, ["const"]: true, ["continue"]: true, ["debugger"]: true, ["default"]: true, ["delete"]: true, ["do"]: true, ["else"]: true, ["eval"]: true, ["finally"]: true, ["for"]: true, ["function"]: true, ["if"]: true, ["import"]: true, ["in"]: true, ["instanceof"]: true, ["let"]: true, ["new"]: true, ["return"]: true, ["switch"]: true, ["throw"]: true, ["try"]: true, ["typeof"]: true, ["var"]: true, ["void"]: true, ["with"]: true}, lua: {["="]: true, ["=="]: true, ["+"]: true, ["-"]: true, ["%"]: true, ["*"]: true, ["/"]: true, ["<"]: true, [">"]: true, ["<="]: true, [">="]: true, and: true, end: true, ["in"]: true, load: true, repeat: true, while: true, ["break"]: true, false: true, local: true, ["return"]: true, ["do"]: true, ["for"]: true, nil: true, then: true, ["else"]: true, ["function"]: true, not: true, true: true, elseif: true, ["if"]: true, or: true, until: true}};
reserved63 = function (x) {
  return has63(reserved[_G.target], x);
};
var valid_code63 = function (n) {
  return number_code63(n) || n > 64 && n < 91 || n > 96 && n < 123 || n === 95;
};
global_id63 = function (id) {
  var __n7 = _35(id);
  return __n7 > 1 && char(id, __n7 - 1) === "*" && valid_code63(code(id, __n7 - 2));
};
compile_id = function (id, escape_reserved63) {
  if (global_id63(id)) {
    return "_G." + compile_id(clip(id, 0, edge(id)), escape_reserved63);
  } else {
    var __e11 = undefined;
    if (number_code63(code(id, 0))) {
      __e11 = "_";
    } else {
      __e11 = "";
    }
    var __id11 = __e11;
    var __i10 = 0;
    while (__i10 < _35(id)) {
      var __c1 = char(id, __i10);
      var __n8 = code(__c1);
      var __e12 = undefined;
      if (__c1 === "-" && !( id === "-")) {
        __e12 = "_";
      } else {
        var __e13 = undefined;
        if (valid_code63(__n8)) {
          __e13 = __c1;
        } else {
          var __e14 = undefined;
          if (__i10 === 0) {
            __e14 = "_" + __n8;
          } else {
            __e14 = __n8;
          }
          __e13 = __e14;
        }
        __e12 = __e13;
      }
      var __c11 = __e12;
      __id11 = __id11 + __c11;
      __i10 = __i10 + 1;
    }
    if (either(escape_reserved63, true) && reserved63(__id11)) {
      return "_" + __id11;
    } else {
      return __id11;
    }
  }
};
valid_id63 = function (x, escape_reserved63) {
  return some63(x) && x === compile_id(x, escape_reserved63);
};
var __names = {};
unique = function (x) {
  var __x49 = compile_id(x, true);
  if (has63(__names, __x49)) {
    var __i11 = __names[__x49];
    __names[__x49] = __names[__x49] + 1;
    return unique(__x49 + __i11);
  } else {
    __names[__x49] = 1;
    return "__" + __x49;
  }
};
key = function (k) {
  if (string_literal63(k)) {
    var __i12 = inner(k);
    if (valid_id63(__i12)) {
      return __i12;
    } else {
      return "[" + k + "]";
    }
  } else {
    return "[" + tostring(k) + "]";
  }
};
mapo = function (f, t) {
  var __o6 = [];
  var ____o7 = t;
  var __k4 = undefined;
  for (__k4 of pairs(____o7)) {
    var __v6 = ____o7[__k4];
    var __x50 = f(__v6);
    if (is63(__x50)) {
      add(__o6, literal(__k4));
      add(__o6, __x50);
    }
  }
  return __o6;
};
var ____x52 = [];
var ____x53 = [];
____x53.js = "!";
____x53.lua = "not";
____x52.not = ____x53;
var ____x54 = [];
____x54["*"] = "*";
____x54["/"] = "/";
____x54["%"] = "%";
var ____x55 = [];
var ____x56 = [];
____x56.js = "+";
____x56.lua = "..";
____x55.cat = ____x56;
var ____x57 = [];
____x57["+"] = "+";
____x57["-"] = "-";
var ____x58 = [];
____x58["<"] = "<";
____x58[">"] = ">";
____x58["<="] = "<=";
____x58[">="] = ">=";
var ____x59 = [];
var ____x60 = [];
____x60.js = "===";
____x60.lua = "==";
____x59["="] = ____x60;
var ____x61 = [];
var ____x62 = [];
____x62.js = "&&";
____x62.lua = "and";
____x61.and = ____x62;
var ____x63 = [];
var ____x64 = [];
____x64.js = "||";
____x64.lua = "or";
____x63.or = ____x64;
var infix = [____x52, ____x54, ____x55, ____x57, ____x58, ____x59, ____x61, ____x63];
var unary63 = function (form) {
  return two63(form) && in63(hd(form), ["not", "-"]);
};
var index = function (k) {
  return k;
};
var precedence = function (form) {
  if (!( atom63(form) || unary63(form))) {
    var ____o8 = infix;
    var __k5 = undefined;
    for (__k5 of pairs(____o8)) {
      var __v7 = ____o8[__k5];
      if (__v7[hd(form)]) {
        return index(__k5);
      }
    }
  }
  return 0;
};
var getop = function (op) {
  return find(function (level) {
    var __x66 = level[op];
    if (obj63(__x66)) {
      return __x66[_G.target];
    } else {
      if (string63(__x66)) {
        return __x66;
      }
    }
  }, infix);
};
var infix63 = function (x) {
  return is63(getop(x));
};
infix_operator63 = function (x) {
  return obj63(x) && infix63(hd(x));
};
var compile_args = function (args) {
  var __s1 = "(";
  var __c2 = "";
  var ____x67 = args;
  var ____i15 = 0;
  while (____i15 < _35(____x67)) {
    var __x68 = ____x67[____i15];
    __s1 = __s1 + __c2 + compile(__x68);
    __c2 = ", ";
    ____i15 = ____i15 + 1;
  }
  return __s1 + ")";
};
var escape_newlines = function (s) {
  var __s11 = "";
  var __i16 = 0;
  while (__i16 < _35(s)) {
    var __c3 = char(s, __i16);
    var __e15 = undefined;
    if (__c3 === "\n") {
      __e15 = "\\n";
    } else {
      var __e16 = undefined;
      if (__c3 === "\r") {
        __e16 = "\\r";
      } else {
        __e16 = __c3;
      }
      __e15 = __e16;
    }
    __s11 = __s11 + __e15;
    __i16 = __i16 + 1;
  }
  return __s11;
};
compile_atom = function (x, escape_reserved63) {
  if (x === "nil" && _G.target === "lua") {
    return x;
  } else {
    if (x === "nil") {
      return "undefined";
    } else {
      if (x === "...") {
        var __e17 = undefined;
        if (_G.target === "js") {
          __e17 = compile("*args");
        } else {
          __e17 = "";
        }
        return "..." + __e17;
      } else {
        if (id_literal63(x)) {
          return inner(x);
        } else {
          if (string_literal63(x)) {
            return escape_newlines(x);
          } else {
            if (string63(x)) {
              return compile_id(x, either(escape_reserved63, true));
            } else {
              if (boolean63(x)) {
                if (x) {
                  return "true";
                } else {
                  return "false";
                }
              } else {
                if (nan63(x)) {
                  return "nan";
                } else {
                  if (x === inf) {
                    return "inf";
                  } else {
                    if (x === _inf) {
                      return "-inf";
                    } else {
                      if (number63(x)) {
                        return x + "";
                      } else {
                        return error("Cannot compile atom: " + str(x));
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
};
var terminator = function (stmt63) {
  if (! stmt63) {
    return "";
  } else {
    if (_G.target === "js") {
      return ";\n";
    } else {
      return "\n";
    }
  }
};
var compile_special = function (form, stmt63) {
  var ____id6 = form;
  var __x69 = ____id6[0];
  var __args2 = cut(____id6, 1);
  var ____id7 = getenv(__x69);
  var __special = ____id7.special;
  var __stmt = ____id7.stmt;
  var __self_tr63 = ____id7.tr;
  var __tr = terminator(stmt63 && ! __self_tr63);
  return apply(__special, __args2) + __tr;
};
accessor_literal63 = function (x) {
  return string63(x) && char(x, 0) === "." && !( char(x, 1) === ".") && some63(char(x, 1));
};
accessor_form63 = function (x) {
  return obj63(x) && accessor_literal63(last(x));
};
accessor_literal = function (x) {
  return compile(camel_case(clip(x, 1)), {_stash: true, ["escape-reserved"]: false});
};
compile_method = function (f, args, chain63) {
  if (chain63 && none63(args)) {
    return f;
  } else {
    var __x70 = hd(args);
    if (accessor_literal63(__x70)) {
      return compile_method(f + "." + accessor_literal(__x70), tl(args), true);
    } else {
      if (hd63(__x70, accessor_literal63)) {
        var __e18 = undefined;
        if (_G.target === "lua") {
          __e18 = ":";
        } else {
          __e18 = ".";
        }
        return compile_method(f + __e18 + accessor_literal(hd(__x70)) + compile_args(tl(__x70)), tl(args), true);
      } else {
        return f + compile_args(args);
      }
    }
  }
};
var parenthesize_call63 = function (x) {
  return ! atom63(x) && hd(x) === "%function" || precedence(x) > 0;
};
var compile_call = function (form) {
  var __f = hd(form);
  var __f1 = compile(__f);
  var __args3 = compile_method("", stash_function(tl(form)));
  if (parenthesize_call63(__f)) {
    return "(" + __f1 + ")" + __args3;
  } else {
    return __f1 + __args3;
  }
};
var op_delims = function (parent, child, right63) {
  var __e19 = undefined;
  if (right63) {
    __e19 = _6261;
  } else {
    __e19 = _62;
  }
  if (__e19(precedence(child), precedence(parent))) {
    return ["(", ")"];
  } else {
    return ["", ""];
  }
};
var compile_infix = function (form) {
  var ____id8 = form;
  var __op = ____id8[0];
  var ____id9 = cut(____id8, 1);
  var __a1 = ____id9[0];
  var __b2 = ____id9[1];
  var ____id10 = op_delims(form, __a1, false);
  var __ao = ____id10[0];
  var __ac = ____id10[1];
  var ____id111 = op_delims(form, __b2, true);
  var __bo = ____id111[0];
  var __bc = ____id111[1];
  var __a2 = compile(__a1);
  var __b3 = compile(__b2);
  var __op1 = getop(__op);
  if (unary63(form)) {
    return __op1 + __ao + " " + __a2 + __ac;
  } else {
    return __ao + __a2 + __ac + " " + __op1 + " " + __bo + __b3 + __bc;
  }
};
compile_function = function (args, body, ..._42args) {
  var ____r63 = unstash([..._42args]);
  var __args4 = destash33(args, ____r63);
  var __body3 = destash33(body, ____r63);
  var ____id12 = ____r63;
  var __name3 = ____id12.name;
  var __prefix = ____id12.prefix;
  var __e20 = undefined;
  if (__name3) {
    __e20 = compile(__name3);
  } else {
    __e20 = "";
  }
  var __id13 = __e20;
  var __e21 = undefined;
  if (__args4.rest) {
    __e21 = join(__args4, ["..."]);
  } else {
    __e21 = __args4;
  }
  var __args12 = __e21;
  var __args5 = compile_args(__args12);
  _G.indent_level = _G.indent_level + 1;
  var ____x75 = compile(__body3, {_stash: true, stmt: true});
  _G.indent_level = _G.indent_level - 1;
  var __body4 = ____x75;
  var __ind = indentation();
  var __e22 = undefined;
  if (__prefix) {
    __e22 = __prefix + " ";
  } else {
    __e22 = "";
  }
  var __p = __e22;
  var __e23 = undefined;
  if (_G.target === "js") {
    __e23 = "";
  } else {
    __e23 = "end";
  }
  var __tr1 = __e23;
  if (__name3) {
    __tr1 = __tr1 + "\n";
  }
  if (_G.target === "js") {
    return "function " + __id13 + __args5 + " {\n" + __body4 + __ind + "}" + __tr1;
  } else {
    return __p + "function " + __id13 + __args5 + "\n" + __body4 + __ind + __tr1;
  }
};
var can_return63 = function (form) {
  return is63(form) && (atom63(form) || !( hd(form) === "return") && ! statement63(hd(form)));
};
compile = function (form, ..._42args) {
  var ____r65 = unstash([..._42args]);
  var __form = destash33(form, ____r65);
  var ____id14 = ____r65;
  var __stmt1 = ____id14.stmt;
  var __esc63 = ____id14["escape-reserved"];
  if (nil63(__form)) {
    return "";
  } else {
    if (special_form63(__form)) {
      return compile_special(__form, __stmt1);
    } else {
      var __tr2 = terminator(__stmt1);
      var __e24 = undefined;
      if (__stmt1) {
        __e24 = indentation();
      } else {
        __e24 = "";
      }
      var __ind1 = __e24;
      var __e25 = undefined;
      if (atom63(__form)) {
        __e25 = compile_atom(__form, either(__esc63, true));
      } else {
        var __e26 = undefined;
        if (infix63(hd(__form))) {
          __e26 = compile_infix(__form);
        } else {
          __e26 = compile_call(__form);
        }
        __e25 = __e26;
      }
      var __form1 = __e25;
      return __ind1 + __form1 + __tr2;
    }
  }
};
var lower_statement = function (form, tail63) {
  var __hoist = [];
  var __e = lower(form, __hoist, true, tail63);
  var __e27 = undefined;
  if (some63(__hoist) && is63(__e)) {
    __e27 = join(["do"], __hoist, [__e]);
  } else {
    var __e28 = undefined;
    if (is63(__e)) {
      __e28 = __e;
    } else {
      var __e29 = undefined;
      if (_35(__hoist) > 1) {
        __e29 = join(["do"], __hoist);
      } else {
        __e29 = hd(__hoist);
      }
      __e28 = __e29;
    }
    __e27 = __e28;
  }
  return either(__e27, ["do"]);
};
var lower_body = function (body, tail63) {
  return lower_statement(join(["do"], body), tail63);
};
var literal63 = function (form) {
  return atom63(form) || hd(form) === "%array" || hd(form) === "%object";
};
var standalone63 = function (form) {
  return ! atom63(form) && ! infix63(hd(form)) && ! literal63(form) && !( "get" === hd(form)) && ! accessor_form63(form) || id_literal63(form);
};
var lower_do = function (args, hoist, stmt63, tail63) {
  var ____x82 = almost(args);
  var ____i17 = 0;
  while (____i17 < _35(____x82)) {
    var __x83 = ____x82[____i17];
    var ____y = lower(__x83, hoist, stmt63);
    if (yes(____y)) {
      var __e1 = ____y;
      if (standalone63(__e1)) {
        add(hoist, __e1);
      }
    }
    ____i17 = ____i17 + 1;
  }
  var __e2 = lower(last(args), hoist, stmt63, tail63);
  if (tail63 && can_return63(__e2)) {
    return ["return", __e2];
  } else {
    return __e2;
  }
};
var lower_set = function (args, hoist, stmt63, tail63) {
  var ____id15 = args;
  var __lh = ____id15[0];
  var __rh = ____id15[1];
  var __lh1 = lower(__lh, hoist);
  var __rh1 = lower(__rh, hoist);
  add(hoist, ["%set", __lh1, __rh1]);
  if (!( stmt63 && ! tail63)) {
    return __lh1;
  }
};
var lower_if = function (args, hoist, stmt63, tail63) {
  var ____id16 = args;
  var __cond = ____id16[0];
  var __then = ____id16[1];
  var ___else = ____id16[2];
  if (stmt63) {
    var __e31 = undefined;
    if (is63(___else)) {
      __e31 = [lower_body([___else], tail63)];
    }
    return add(hoist, join(["%if", lower(__cond, hoist), lower_body([__then], tail63)], __e31));
  } else {
    var __e3 = unique("e");
    add(hoist, ["%local", __e3, "nil"]);
    var __e30 = undefined;
    if (is63(___else)) {
      __e30 = [lower(["%set", __e3, ___else])];
    }
    add(hoist, join(["%if", lower(__cond, hoist), lower(["%set", __e3, __then])], __e30));
    return __e3;
  }
};
var lower_short = function (x, args, hoist) {
  var ____id17 = args;
  var __a3 = ____id17[0];
  var __b4 = ____id17[1];
  var __hoist1 = [];
  var __b11 = lower(__b4, __hoist1);
  if (some63(__hoist1)) {
    var __id18 = unique("id");
    var __e32 = undefined;
    if (x === "and") {
      __e32 = ["%if", __id18, __b4, __id18];
    } else {
      __e32 = ["%if", __id18, __id18, __b4];
    }
    return lower(["do", ["%local", __id18, __a3], __e32], hoist);
  } else {
    return [x, lower(__a3, hoist), __b11];
  }
};
var lower_try = function (args, hoist, tail63) {
  return add(hoist, ["%try", lower_body(args, tail63)]);
};
var lower_while = function (args, hoist) {
  var ____id19 = args;
  var __c4 = ____id19[0];
  var __body5 = cut(____id19, 1);
  var __pre = [];
  var __c5 = lower(__c4, __pre);
  var __e33 = undefined;
  if (none63(__pre)) {
    __e33 = ["while", __c5, lower_body(__body5)];
  } else {
    __e33 = ["while", true, join(["do"], __pre, [["%if", ["not", __c5], ["break"]], lower_body(__body5)])];
  }
  return add(hoist, __e33);
};
var lower_for = function (args, hoist) {
  var ____id20 = args;
  var __t = ____id20[0];
  var __k6 = ____id20[1];
  var __body6 = cut(____id20, 2);
  return add(hoist, ["%for", lower(__t, hoist), __k6, lower_body(__body6)]);
};
var lower_function = function (args) {
  var ____id21 = args;
  var __a4 = ____id21[0];
  var __body7 = cut(____id21, 1);
  return ["%function", __a4, lower_body(__body7, true)];
};
var lower_definition = function (kind, args, hoist, stmt63, tail63) {
  var ____id22 = args;
  var __name4 = ____id22[0];
  var __args6 = ____id22[1];
  var __body8 = cut(____id22, 2);
  var __name11 = lower(__name4, hoist);
  add(hoist, [kind, __name11, __args6, lower_body(__body8, true)]);
  if (!( stmt63 && ! tail63)) {
    return __name11;
  }
};
var lower_call = function (form, hoist) {
  var __form2 = map(function (x) {
    return lower(x, hoist);
  }, form);
  if (some63(__form2)) {
    return __form2;
  }
};
var lower_infix63 = function (form) {
  return _35(form) > 3 && infix63(hd(form));
};
var infix_form = function (__x111) {
  var ____id23 = __x111;
  var __x112 = ____id23[0];
  var __a5 = ____id23[1];
  var __bs2 = cut(____id23, 2);
  var ____x113 = __bs2;
  var ____i18 = 0;
  while (____i18 < _35(____x113)) {
    var __b5 = ____x113[____i18];
    __a5 = [__x112, __a5, __b5];
    ____i18 = ____i18 + 1;
  }
  return __a5;
};
var lower_pairwise63 = function (form) {
  return _35(form) > 3 && in63(hd(form), ["<", "<=", "=", ">=", ">"]);
};
var pairwise_form = function (__x116) {
  var ____id24 = __x116;
  var __x117 = ____id24[0];
  var __a6 = ____id24[1];
  var __bs3 = cut(____id24, 2);
  var __e4 = ["and"];
  var ____x119 = __bs3;
  var ____i19 = 0;
  while (____i19 < _35(____x119)) {
    var __b6 = ____x119[____i19];
    add(__e4, [__x117, __a6, __b6]);
    __a6 = __b6;
    ____i19 = ____i19 + 1;
  }
  return __e4;
};
var lower_special = function (form, hoist) {
  var __e5 = lower_call(form, hoist);
  if (__e5) {
    return add(hoist, __e5);
  }
};
lower = function (form, hoist, stmt63, tail63) {
  if (atom63(form)) {
    return form;
  } else {
    if (empty63(form)) {
      return ["%array"];
    } else {
      if (nil63(hoist)) {
        return lower_statement(form);
      } else {
        if (lower_pairwise63(form)) {
          return lower(pairwise_form(form), hoist, stmt63, tail63);
        } else {
          if (lower_infix63(form)) {
            return lower(infix_form(form), hoist, stmt63, tail63);
          } else {
            var ____id25 = form;
            var __x122 = ____id25[0];
            var __args7 = cut(____id25, 1);
            if (__x122 === "do") {
              return lower_do(__args7, hoist, stmt63, tail63);
            } else {
              if (__x122 === "%call") {
                return lower(__args7, hoist, stmt63, tail63);
              } else {
                if (__x122 === "%set") {
                  return lower_set(__args7, hoist, stmt63, tail63);
                } else {
                  if (__x122 === "%if") {
                    return lower_if(__args7, hoist, stmt63, tail63);
                  } else {
                    if (__x122 === "%try") {
                      return lower_try(__args7, hoist, tail63);
                    } else {
                      if (__x122 === "while") {
                        return lower_while(__args7, hoist);
                      } else {
                        if (__x122 === "%for") {
                          return lower_for(__args7, hoist);
                        } else {
                          if (__x122 === "%function") {
                            return lower_function(__args7);
                          } else {
                            if (__x122 === "%local-function" || __x122 === "%global-function") {
                              return lower_definition(__x122, __args7, hoist, stmt63, tail63);
                            } else {
                              if (in63(__x122, ["and", "or"])) {
                                return lower_short(__x122, __args7, hoist);
                              } else {
                                if (statement63(__x122)) {
                                  return lower_special(form, hoist);
                                } else {
                                  return lower_call(form, hoist);
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
};
expand = function (form) {
  return lower(macroexpand(form));
};
var run = eval;
_37result = undefined;
_eval = function (form) {
  var __previous = _G.target;
  _G.target = "js";
  var __code = compile(expand(["set", "%result", form]));
  _G.target = __previous;
  run(__code);
  return _37result;
};
immediate_call63 = function (x) {
  return obj63(x) && obj63(hd(x)) && hd(hd(x)) === "%function";
};
setenv("do", {_stash: true, special: function (..._42args) {
  var __forms = unstash([..._42args]);
  var __s2 = "";
  var ____x126 = __forms;
  var ____i20 = 0;
  while (____i20 < _35(____x126)) {
    var __x127 = ____x126[____i20];
    if (_G.target === "lua" && immediate_call63(__x127) && "\n" === char(__s2, edge(__s2))) {
      __s2 = clip(__s2, 0, edge(__s2)) + ";\n";
    }
    __s2 = __s2 + compile(__x127, {_stash: true, stmt: true});
    if (! atom63(__x127)) {
      if (hd(__x127) === "return" || hd(__x127) === "break") {
        break;
      }
    }
    ____i20 = ____i20 + 1;
  }
  return __s2;
}, stmt: true, tr: true});
setenv("%if", {_stash: true, special: function (cond, cons, alt) {
  var __cond1 = compile(cond);
  _G.indent_level = _G.indent_level + 1;
  var ____x128 = compile(cons, {_stash: true, stmt: true});
  _G.indent_level = _G.indent_level - 1;
  var __cons = ____x128;
  var __e34 = undefined;
  if (alt) {
    _G.indent_level = _G.indent_level + 1;
    var ____x129 = compile(alt, {_stash: true, stmt: true});
    _G.indent_level = _G.indent_level - 1;
    __e34 = ____x129;
  }
  var __alt = __e34;
  var __ind2 = indentation();
  var __s3 = "";
  if (_G.target === "js") {
    __s3 = __s3 + __ind2 + "if (" + __cond1 + ") {\n" + __cons + __ind2 + "}";
  } else {
    __s3 = __s3 + __ind2 + "if " + __cond1 + " then\n" + __cons;
  }
  if (__alt && _G.target === "js") {
    __s3 = __s3 + " else {\n" + __alt + __ind2 + "}";
  } else {
    if (__alt) {
      __s3 = __s3 + __ind2 + "else\n" + __alt;
    }
  }
  if (_G.target === "lua") {
    return __s3 + __ind2 + "end\n";
  } else {
    return __s3 + "\n";
  }
}, stmt: true, tr: true});
setenv("while", {_stash: true, special: function (cond, form) {
  var __cond2 = compile(cond);
  _G.indent_level = _G.indent_level + 1;
  var ____x130 = compile(form, {_stash: true, stmt: true});
  _G.indent_level = _G.indent_level - 1;
  var __body9 = ____x130;
  var __ind3 = indentation();
  if (_G.target === "js") {
    return __ind3 + "while (" + __cond2 + ") {\n" + __body9 + __ind3 + "}\n";
  } else {
    return __ind3 + "while " + __cond2 + " do\n" + __body9 + __ind3 + "end\n";
  }
}, stmt: true, tr: true});
setenv("%names", {_stash: true, special: function (..._42args) {
  var __args8 = unstash([..._42args]);
  if (one63(__args8)) {
    return compile(hd(__args8));
  } else {
    var __e35 = undefined;
    if (_G.target === "js") {
      __e35 = "[";
    } else {
      __e35 = "";
    }
    var __s4 = __e35;
    var __c6 = "";
    var ____x132 = __args8;
    var ____i21 = 0;
    while (____i21 < _35(____x132)) {
      var __x133 = ____x132[____i21];
      __s4 = __s4 + __c6 + compile(__x133);
      __c6 = ", ";
      ____i21 = ____i21 + 1;
    }
    var __e36 = undefined;
    if (_G.target === "js") {
      __e36 = "]";
    } else {
      __e36 = "";
    }
    return __s4 + __e36;
  }
}});
setenv("%for", {_stash: true, special: function (t, k, form) {
  var __t1 = compile(t);
  var __k7 = compile(k);
  var __ind4 = indentation();
  _G.indent_level = _G.indent_level + 1;
  var ____x134 = compile(form, {_stash: true, stmt: true});
  _G.indent_level = _G.indent_level - 1;
  var __body10 = ____x134;
  if (_G.target === "lua") {
    return __ind4 + "for " + __k7 + " in " + __t1 + " do\n" + __body10 + __ind4 + "end\n";
  } else {
    return __ind4 + "for (" + __k7 + " of " + __t1 + ") {\n" + __body10 + __ind4 + "}\n";
  }
}, stmt: true, tr: true});
setenv("%try", {_stash: true, special: function (form) {
  var __e6 = unique("e");
  var __ind5 = indentation();
  _G.indent_level = _G.indent_level + 1;
  var ____x135 = compile(form, {_stash: true, stmt: true});
  _G.indent_level = _G.indent_level - 1;
  var __body11 = ____x135;
  var __hf = ["return", ["%array", false, __e6]];
  _G.indent_level = _G.indent_level + 1;
  var ____x138 = compile(__hf, {_stash: true, stmt: true});
  _G.indent_level = _G.indent_level - 1;
  var __h = ____x138;
  return __ind5 + "try {\n" + __body11 + __ind5 + "}\n" + __ind5 + "catch (" + __e6 + ") {\n" + __h + __ind5 + "}\n";
}, stmt: true, tr: true});
setenv("%delete", {_stash: true, special: function (place) {
  return indentation() + "delete " + compile(place);
}, stmt: true});
setenv("break", {_stash: true, special: function () {
  return indentation() + "break";
}, stmt: true});
setenv("%function", {_stash: true, special: function (args, body) {
  return compile_function(args, body);
}});
setenv("%global-function", {_stash: true, special: function (name, args, body) {
  if (_G.target === "lua") {
    var __x139 = compile_function(args, body, {_stash: true, name: name});
    return indentation() + __x139;
  } else {
    return compile(["%set", name, ["%function", args, body]], {_stash: true, stmt: true});
  }
}, stmt: true, tr: true});
setenv("%local-function", {_stash: true, special: function (name, args, body) {
  if (_G.target === "lua") {
    var __x142 = compile_function(args, body, {_stash: true, name: name, prefix: "local"});
    return indentation() + __x142;
  } else {
    return compile(["%local", name, ["%function", args, body]], {_stash: true, stmt: true});
  }
}, stmt: true, tr: true});
setenv("return", {_stash: true, special: function (x) {
  var __e37 = undefined;
  if (nil63(x)) {
    __e37 = "return";
  } else {
    __e37 = "return " + compile(x);
  }
  var __x145 = __e37;
  return indentation() + __x145;
}, stmt: true});
setenv("new", {_stash: true, special: function (x) {
  return "new " + compile(x);
}});
setenv("typeof", {_stash: true, special: function (x) {
  return "typeof(" + compile(x) + ")";
}});
setenv("throw", {_stash: true, special: function (x) {
  var __e38 = undefined;
  if (_G.target === "js") {
    __e38 = "throw " + compile(x);
  } else {
    __e38 = "error(" + compile(x) + ")";
  }
  var __e7 = __e38;
  return indentation() + __e7;
}, stmt: true});
setenv("%local", {_stash: true, special: function (name, value) {
  var __id26 = compile(name);
  var __value1 = compile(value);
  var __e39 = undefined;
  if (is63(value)) {
    __e39 = " = " + __value1;
  } else {
    __e39 = "";
  }
  var __rh11 = __e39;
  var __e40 = undefined;
  if (_G.target === "js") {
    __e40 = "var ";
  } else {
    __e40 = "local ";
  }
  var __keyword = __e40;
  var __ind6 = indentation();
  return __ind6 + __keyword + __id26 + __rh11;
}, stmt: true});
setenv("%set", {_stash: true, special: function (lh, rh) {
  var __lh11 = compile(lh);
  var __e41 = undefined;
  if (nil63(rh)) {
    __e41 = "nil";
  } else {
    __e41 = rh;
  }
  var __rh2 = compile(__e41);
  return indentation() + __lh11 + " = " + __rh2;
}, stmt: true});
setenv("get", {_stash: true, special: function (t, k) {
  var __t11 = compile(t);
  var __k11 = compile(k, {_stash: true, ["escape-reserved"]: false});
  if (_G.target === "lua" && char(__t11, 0) === "{" || infix_operator63(t)) {
    __t11 = "(" + __t11 + ")";
  }
  if (string_literal63(k) && valid_id63(inner(k))) {
    return __t11 + "." + inner(k);
  } else {
    return __t11 + "[" + __k11 + "]";
  }
}});
setenv("%array", {_stash: true, special: function (..._42args) {
  var __forms1 = unstash([..._42args]);
  var __e42 = undefined;
  if (_G.target === "lua") {
    __e42 = "{";
  } else {
    __e42 = "[";
  }
  var __open = __e42;
  var __e43 = undefined;
  if (_G.target === "lua") {
    __e43 = "}";
  } else {
    __e43 = "]";
  }
  var __close = __e43;
  var __s5 = "";
  var __c7 = "";
  var ____o9 = __forms1;
  var __k8 = undefined;
  for (__k8 of pairs(____o9)) {
    var __v8 = ____o9[__k8];
    if (number63(__k8)) {
      __s5 = __s5 + __c7 + compile(__v8);
      __c7 = ", ";
    }
  }
  return __open + __s5 + __close;
}});
setenv("%object", {_stash: true, special: function (..._42args) {
  var __forms2 = unstash([..._42args]);
  var __s6 = "{";
  var __c8 = "";
  var __e44 = undefined;
  if (_G.target === "lua") {
    __e44 = " = ";
  } else {
    __e44 = ": ";
  }
  var __sep = __e44;
  var ____o10 = pair(__forms2);
  var __k9 = undefined;
  for (__k9 of pairs(____o10)) {
    var __v9 = ____o10[__k9];
    if (number63(__k9)) {
      var ____id27 = __v9;
      var __k10 = ____id27[0];
      var __v10 = ____id27[1];
      __s6 = __s6 + __c8 + key(__k10) + __sep + compile(__v10);
      __c8 = ", ";
    }
  }
  return __s6 + "}";
}});
setenv("%literal", {_stash: true, special: function (..._42args) {
  var __args9 = unstash([..._42args]);
  return apply(cat, map(unquoted, __args9));
}});
setenv("unpack", {_stash: true, special: function (x) {
  if (_G.target === "lua") {
    return "(unpack or table.unpack)(" + compile(x) + ")";
  } else {
    return "..." + compile(x);
  }
}});
var __e45 = undefined;
if (typeof(exports) === "undefined") {
  __e45 = {};
} else {
  __e45 = exports;
}
var __exports = __e45;
__exports.run = run;
__exports.eval = _eval;
__exports.expand = expand;
__exports.compile = compile;
__exports;
