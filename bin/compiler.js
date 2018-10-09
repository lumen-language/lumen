getenv = function (k, p) {
  if (string63(k)) {
    var __i = edge(environment);
    while (__i >= 0) {
      var __b = environment[__i][k];
      if (is63(__b)) {
        var __e21 = undefined;
        if (p) {
          __e21 = __b[p];
        } else {
          __e21 = __b;
        }
        return __e21;
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
var stash42 = function (args) {
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
  if (number63(k) && !( target === "js")) {
    if (target === "js") {
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
      var __e22 = undefined;
      if (__k1 === "rest") {
        __e22 = ["cut", __id, _35(lh)];
      } else {
        __e22 = ["get", __id, ["quote", bias(__k1)]];
      }
      var __x5 = __e22;
      if (is63(__k1)) {
        var __e23 = undefined;
        if (__v1 === true) {
          __e23 = __k1;
        } else {
          __e23 = __v1;
        }
        var __k2 = __e23;
        __bs = join(__bs, bind(__k2, __x5));
      }
    }
    return __bs;
  }
};
bind42 = function (args, body) {
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
    var __k3 = undefined;
    for (__k3 of pairs(____o2)) {
      var __v2 = ____o2[__k3];
      if (number63(__k3)) {
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
  return ["%local", __name, macroexpand(__value)];
};
var expand_function = function (__x25) {
  var ____id2 = __x25;
  var __x26 = ____id2[0];
  var __args = ____id2[1];
  var __body = cut(____id2, 2);
  add(environment, {});
  var ____o3 = __args;
  var ____i5 = undefined;
  for (____i5 of pairs(____o3)) {
    var ____x27 = ____o3[____i5];
    setenv(____x27, {_stash: true, variable: true});
  }
  var ____x28 = join(["%function", __args], macroexpand(__body));
  drop(environment);
  return ____x28;
};
var expand_definition = function (__x30) {
  var ____id3 = __x30;
  var __x31 = ____id3[0];
  var __name1 = ____id3[1];
  var __args11 = ____id3[2];
  var __body1 = cut(____id3, 3);
  add(environment, {});
  var ____o4 = __args11;
  var ____i6 = undefined;
  for (____i6 of pairs(____o4)) {
    var ____x32 = ____o4[____i6];
    setenv(____x32, {_stash: true, variable: true});
  }
  var ____x33 = join([__x31, __name1, __args11], macroexpand(__body1));
  drop(environment);
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
  var __k4 = undefined;
  for (__k4 of pairs(____o5)) {
    var __v4 = ____o5[__k4];
    if (! number63(__k4)) {
      var __e24 = undefined;
      if (quasisplice63(__v4, depth)) {
        __e24 = quasiexpand(__v4[1]);
      } else {
        __e24 = quasiexpand(__v4, depth);
      }
      var __v5 = __e24;
      last(__xs)[__k4] = __v5;
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
indent_level = 0;
indentation = function () {
  var __s = "";
  var __i9 = 0;
  while (__i9 < indent_level) {
    __s = __s + "  ";
    __i9 = __i9 + 1;
  }
  return __s;
};
var reserved = {js: {["="]: true, ["=="]: true, ["+"]: true, ["-"]: true, ["%"]: true, ["*"]: true, ["/"]: true, ["<"]: true, [">"]: true, ["<="]: true, [">="]: true, ["break"]: true, ["case"]: true, ["catch"]: true, ["class"]: true, ["const"]: true, ["continue"]: true, ["debugger"]: true, ["default"]: true, ["delete"]: true, ["do"]: true, ["else"]: true, ["eval"]: true, ["finally"]: true, ["for"]: true, ["function"]: true, ["if"]: true, ["import"]: true, ["in"]: true, ["instanceof"]: true, ["let"]: true, ["new"]: true, ["return"]: true, ["switch"]: true, ["throw"]: true, ["try"]: true, ["typeof"]: true, ["var"]: true, ["void"]: true, ["with"]: true}, lua: {["="]: true, ["=="]: true, ["+"]: true, ["-"]: true, ["%"]: true, ["*"]: true, ["/"]: true, ["<"]: true, [">"]: true, ["<="]: true, [">="]: true, and: true, end: true, ["in"]: true, load: true, repeat: true, while: true, ["break"]: true, false: true, local: true, ["return"]: true, ["do"]: true, ["for"]: true, nil: true, then: true, ["else"]: true, ["function"]: true, not: true, true: true, elseif: true, ["if"]: true, or: true, until: true}};
reserved63 = function (x) {
  return has63(reserved[target], x);
};
var valid_code63 = function (n) {
  return number_code63(n) || n > 64 && n < 91 || n > 96 && n < 123 || n === 95;
};
compile_id = function (id, escape_reserved63) {
  var __e25 = undefined;
  if (number_code63(code(id, 0))) {
    __e25 = "_";
  } else {
    __e25 = "";
  }
  var __id11 = __e25;
  var __i10 = 0;
  while (__i10 < _35(id)) {
    var __c1 = char(id, __i10);
    var __n7 = code(__c1);
    var __e26 = undefined;
    if (__c1 === "-" && !( id === "-")) {
      __e26 = "_";
    } else {
      var __e27 = undefined;
      if (valid_code63(__n7)) {
        __e27 = __c1;
      } else {
        var __e28 = undefined;
        if (__i10 === 0) {
          __e28 = "_" + __n7;
        } else {
          __e28 = __n7;
        }
        __e27 = __e28;
      }
      __e26 = __e27;
    }
    var __c11 = __e26;
    __id11 = __id11 + __c11;
    __i10 = __i10 + 1;
  }
  if (either(escape_reserved63, true) && reserved63(__id11)) {
    return "_" + __id11;
  } else {
    return __id11;
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
  var __k5 = undefined;
  for (__k5 of pairs(____o7)) {
    var __v6 = ____o7[__k5];
    var __x50 = f(__v6);
    if (is63(__x50)) {
      add(__o6, literal(__k5));
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
____x54["*"] = true;
____x54["/"] = true;
____x54["%"] = true;
var ____x55 = [];
var ____x56 = [];
____x56.js = "+";
____x56.lua = "..";
____x55.cat = ____x56;
var ____x57 = [];
____x57["+"] = true;
____x57["-"] = true;
var ____x58 = [];
____x58["<"] = true;
____x58[">"] = true;
____x58["<="] = true;
____x58[">="] = true;
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
    var __k6 = undefined;
    for (__k6 of pairs(____o8)) {
      var __v7 = ____o8[__k6];
      if (__v7[hd(form)]) {
        return index(__k6);
      }
    }
  }
  return 0;
};
var getop = function (op) {
  return find(function (level) {
    var __x66 = level[op];
    if (__x66 === true) {
      return op;
    } else {
      if (is63(__x66)) {
        return __x66[target];
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
    var __e29 = undefined;
    if (__c3 === "\n") {
      __e29 = "\\n";
    } else {
      var __e30 = undefined;
      if (__c3 === "\r") {
        __e30 = "\\r";
      } else {
        __e30 = __c3;
      }
      __e29 = __e30;
    }
    __s11 = __s11 + __e29;
    __i16 = __i16 + 1;
  }
  return __s11;
};
compile_atom = function (x, escape_reserved63) {
  if (x === "nil" && target === "lua") {
    return x;
  } else {
    if (x === "nil") {
      return "undefined";
    } else {
      if (x === "...") {
        var __e31 = undefined;
        if (target === "js") {
          __e31 = compile("*args");
        } else {
          __e31 = "";
        }
        return "..." + __e31;
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
    if (target === "js") {
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
        var __e32 = undefined;
        if (target === "lua") {
          __e32 = ":";
        } else {
          __e32 = ".";
        }
        return compile_method(f + __e32 + accessor_literal(hd(__x70)) + compile_args(tl(__x70)), tl(args), true);
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
  var __args3 = compile_method("", stash42(tl(form)));
  if (parenthesize_call63(__f)) {
    return "(" + __f1 + ")" + __args3;
  } else {
    return __f1 + __args3;
  }
};
var op_delims = function (parent, child, ..._42args) {
  var ____r59 = unstash([..._42args]);
  var __parent = destash33(parent, ____r59);
  var __child = destash33(child, ____r59);
  var ____id8 = ____r59;
  var __right = ____id8.right;
  var __e33 = undefined;
  if (__right) {
    __e33 = _6261;
  } else {
    __e33 = _62;
  }
  if (__e33(precedence(__child), precedence(__parent))) {
    return ["(", ")"];
  } else {
    return ["", ""];
  }
};
var compile_infix = function (form) {
  var ____id9 = form;
  var __op = ____id9[0];
  var ____id10 = cut(____id9, 1);
  var __a1 = ____id10[0];
  var __b2 = ____id10[1];
  var ____id111 = op_delims(form, __a1);
  var __ao = ____id111[0];
  var __ac = ____id111[1];
  var ____id12 = op_delims(form, __b2, {_stash: true, right: true});
  var __bo = ____id12[0];
  var __bc = ____id12[1];
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
  var ____r61 = unstash([..._42args]);
  var __args4 = destash33(args, ____r61);
  var __body3 = destash33(body, ____r61);
  var ____id13 = ____r61;
  var __name3 = ____id13.name;
  var __prefix = ____id13.prefix;
  var __e34 = undefined;
  if (__name3) {
    __e34 = compile(__name3);
  } else {
    __e34 = "";
  }
  var __id14 = __e34;
  var __e35 = undefined;
  if (__args4.rest) {
    __e35 = join(__args4, ["..."]);
  } else {
    __e35 = __args4;
  }
  var __args12 = __e35;
  var __args5 = compile_args(__args12);
  indent_level = indent_level + 1;
  var ____x76 = compile(__body3, {_stash: true, stmt: true});
  indent_level = indent_level - 1;
  var __body4 = ____x76;
  var __ind = indentation();
  var __e36 = undefined;
  if (__prefix) {
    __e36 = __prefix + " ";
  } else {
    __e36 = "";
  }
  var __p = __e36;
  var __e37 = undefined;
  if (target === "js") {
    __e37 = "";
  } else {
    __e37 = "end";
  }
  var __tr1 = __e37;
  if (__name3) {
    __tr1 = __tr1 + "\n";
  }
  if (target === "js") {
    return "function " + __id14 + __args5 + " {\n" + __body4 + __ind + "}" + __tr1;
  } else {
    return __p + "function " + __id14 + __args5 + "\n" + __body4 + __ind + __tr1;
  }
};
var can_return63 = function (form) {
  return is63(form) && (atom63(form) || !( hd(form) === "return") && ! statement63(hd(form)));
};
compile = function (form, ..._42args) {
  var ____r63 = unstash([..._42args]);
  var __form = destash33(form, ____r63);
  var ____id15 = ____r63;
  var __stmt1 = ____id15.stmt;
  var __escape_reserved = ____id15["escape-reserved"];
  if (nil63(__form)) {
    return "";
  } else {
    if (special_form63(__form)) {
      return compile_special(__form, __stmt1);
    } else {
      var __tr2 = terminator(__stmt1);
      var __e38 = undefined;
      if (__stmt1) {
        __e38 = indentation();
      } else {
        __e38 = "";
      }
      var __ind1 = __e38;
      var __e39 = undefined;
      if (atom63(__form)) {
        __e39 = compile_atom(__form, either(__escape_reserved, true));
      } else {
        var __e40 = undefined;
        if (infix63(hd(__form))) {
          __e40 = compile_infix(__form);
        } else {
          __e40 = compile_call(__form);
        }
        __e39 = __e40;
      }
      var __form1 = __e39;
      return __ind1 + __form1 + __tr2;
    }
  }
};
var lower_statement = function (form, tail63) {
  var __hoist = [];
  var __e = lower(form, __hoist, true, tail63);
  var __e41 = undefined;
  if (some63(__hoist) && is63(__e)) {
    __e41 = join(["do"], __hoist, [__e]);
  } else {
    var __e42 = undefined;
    if (is63(__e)) {
      __e42 = __e;
    } else {
      var __e43 = undefined;
      if (_35(__hoist) > 1) {
        __e43 = join(["do"], __hoist);
      } else {
        __e43 = hd(__hoist);
      }
      __e42 = __e43;
    }
    __e41 = __e42;
  }
  return either(__e41, ["do"]);
};
var lower_body = function (body, tail63) {
  return lower_statement(join(["do"], body), tail63);
};
var literal63 = function (form) {
  return atom63(form) || hd(form) === "%array" || hd(form) === "%object";
};
var standalone63 = function (form) {
  return ! atom63(form) && ! infix63(hd(form)) && ! literal63(form) && !( "get" === hd(form)) || id_literal63(form);
};
var lower_do = function (args, hoist, stmt63, tail63) {
  var ____x83 = almost(args);
  var ____i17 = 0;
  while (____i17 < _35(____x83)) {
    var __x84 = ____x83[____i17];
    var ____y = lower(__x84, hoist, stmt63);
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
  var ____id16 = args;
  var __lh = ____id16[0];
  var __rh = ____id16[1];
  var __lh1 = lower(__lh, hoist);
  var __rh1 = lower(__rh, hoist);
  add(hoist, ["%set", __lh1, __rh1]);
  if (!( stmt63 && ! tail63)) {
    return __lh1;
  }
};
var lower_if = function (args, hoist, stmt63, tail63) {
  var ____id17 = args;
  var __cond = ____id17[0];
  var __then = ____id17[1];
  var ___else = ____id17[2];
  if (stmt63) {
    var __e45 = undefined;
    if (is63(___else)) {
      __e45 = [lower_body([___else], tail63)];
    }
    return add(hoist, join(["%if", lower(__cond, hoist), lower_body([__then], tail63)], __e45));
  } else {
    var __e3 = unique("e");
    add(hoist, ["%local", __e3, "nil"]);
    var __e44 = undefined;
    if (is63(___else)) {
      __e44 = [lower(["%set", __e3, ___else])];
    }
    add(hoist, join(["%if", lower(__cond, hoist), lower(["%set", __e3, __then])], __e44));
    return __e3;
  }
};
var lower_short = function (x, args, hoist) {
  var ____id18 = args;
  var __a3 = ____id18[0];
  var __b4 = ____id18[1];
  var __hoist1 = [];
  var __b11 = lower(__b4, __hoist1);
  if (some63(__hoist1)) {
    var __id19 = unique("id");
    var __e46 = undefined;
    if (x === "and") {
      __e46 = ["%if", __id19, __b4, __id19];
    } else {
      __e46 = ["%if", __id19, __id19, __b4];
    }
    return lower(["do", ["%local", __id19, __a3], __e46], hoist);
  } else {
    return [x, lower(__a3, hoist), __b11];
  }
};
var lower_try = function (args, hoist, tail63) {
  return add(hoist, ["%try", lower_body(args, tail63)]);
};
var lower_while = function (args, hoist) {
  var ____id20 = args;
  var __c4 = ____id20[0];
  var __body5 = cut(____id20, 1);
  var __pre = [];
  var __c5 = lower(__c4, __pre);
  var __e47 = undefined;
  if (none63(__pre)) {
    __e47 = ["while", __c5, lower_body(__body5)];
  } else {
    __e47 = ["while", true, join(["do"], __pre, [["%if", ["not", __c5], ["break"]], lower_body(__body5)])];
  }
  return add(hoist, __e47);
};
var lower_for = function (args, hoist) {
  var ____id21 = args;
  var __t = ____id21[0];
  var __k7 = ____id21[1];
  var __body6 = cut(____id21, 2);
  return add(hoist, ["%for", lower(__t, hoist), __k7, lower_body(__body6)]);
};
var lower_function = function (args) {
  var ____id22 = args;
  var __a4 = ____id22[0];
  var __body7 = cut(____id22, 1);
  return ["%function", __a4, lower_body(__body7, true)];
};
var lower_definition = function (kind, args, hoist) {
  var ____id23 = args;
  var __name4 = ____id23[0];
  var __args6 = ____id23[1];
  var __body8 = cut(____id23, 2);
  return add(hoist, [kind, __name4, __args6, lower_body(__body8, true)]);
};
var lower_call = function (form, hoist) {
  var __form2 = map(function (x) {
    return lower(x, hoist);
  }, form);
  if (some63(__form2)) {
    return __form2;
  }
};
var pairwise63 = function (form) {
  return in63(hd(form), ["<", "<=", "=", ">=", ">"]);
};
var lower_pairwise = function (form) {
  if (pairwise63(form)) {
    var __e4 = [];
    var ____id24 = form;
    var __x113 = ____id24[0];
    var __args7 = cut(____id24, 1);
    reduce(function (a, b) {
      add(__e4, [__x113, a, b]);
      return a;
    }, __args7);
    return join(["and"], reverse(__e4));
  } else {
    return form;
  }
};
var lower_infix63 = function (form) {
  return infix63(hd(form)) && _35(form) > 3;
};
var lower_infix = function (form, hoist) {
  var __form3 = lower_pairwise(form);
  var ____id25 = __form3;
  var __x116 = ____id25[0];
  var __args8 = cut(____id25, 1);
  return lower(reduce(function (a, b) {
    return [__x116, b, a];
  }, reverse(__args8)), hoist);
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
        if (lower_infix63(form)) {
          return lower_infix(form, hoist);
        } else {
          var ____id26 = form;
          var __x119 = ____id26[0];
          var __args9 = cut(____id26, 1);
          if (__x119 === "do") {
            return lower_do(__args9, hoist, stmt63, tail63);
          } else {
            if (__x119 === "%call") {
              return lower(__args9, hoist, stmt63, tail63);
            } else {
              if (__x119 === "%set") {
                return lower_set(__args9, hoist, stmt63, tail63);
              } else {
                if (__x119 === "%if") {
                  return lower_if(__args9, hoist, stmt63, tail63);
                } else {
                  if (__x119 === "%try") {
                    return lower_try(__args9, hoist, tail63);
                  } else {
                    if (__x119 === "while") {
                      return lower_while(__args9, hoist);
                    } else {
                      if (__x119 === "%for") {
                        return lower_for(__args9, hoist);
                      } else {
                        if (__x119 === "%function") {
                          return lower_function(__args9);
                        } else {
                          if (__x119 === "%local-function" || __x119 === "%global-function") {
                            return lower_definition(__x119, __args9, hoist);
                          } else {
                            if (in63(__x119, ["and", "or"])) {
                              return lower_short(__x119, __args9, hoist);
                            } else {
                              if (statement63(__x119)) {
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
};
expand = function (form) {
  return lower(macroexpand(form));
};
var run = eval;
_37result = undefined;
_eval = function (form) {
  var __previous = target;
  target = "js";
  var __code = compile(expand(["set", "%result", form]));
  target = __previous;
  run(__code);
  return _37result;
};
immediate_call63 = function (x) {
  return obj63(x) && obj63(hd(x)) && hd(hd(x)) === "%function";
};
setenv("do", {_stash: true, special: function (..._42args) {
  var __forms1 = unstash([..._42args]);
  var __s3 = "";
  var ____x126 = __forms1;
  var ____i19 = 0;
  while (____i19 < _35(____x126)) {
    var __x127 = ____x126[____i19];
    if (target === "lua" && immediate_call63(__x127) && "\n" === char(__s3, edge(__s3))) {
      __s3 = clip(__s3, 0, edge(__s3)) + ";\n";
    }
    __s3 = __s3 + compile(__x127, {_stash: true, stmt: true});
    if (! atom63(__x127)) {
      if (hd(__x127) === "return" || hd(__x127) === "break") {
        break;
      }
    }
    ____i19 = ____i19 + 1;
  }
  return __s3;
}, stmt: true, tr: true});
setenv("%if", {_stash: true, special: function (cond, cons, alt) {
  var __cond2 = compile(cond);
  indent_level = indent_level + 1;
  var ____x130 = compile(cons, {_stash: true, stmt: true});
  indent_level = indent_level - 1;
  var __cons1 = ____x130;
  var __e48 = undefined;
  if (alt) {
    indent_level = indent_level + 1;
    var ____x131 = compile(alt, {_stash: true, stmt: true});
    indent_level = indent_level - 1;
    __e48 = ____x131;
  }
  var __alt1 = __e48;
  var __ind3 = indentation();
  var __s5 = "";
  if (target === "js") {
    __s5 = __s5 + __ind3 + "if (" + __cond2 + ") {\n" + __cons1 + __ind3 + "}";
  } else {
    __s5 = __s5 + __ind3 + "if " + __cond2 + " then\n" + __cons1;
  }
  if (__alt1 && target === "js") {
    __s5 = __s5 + " else {\n" + __alt1 + __ind3 + "}";
  } else {
    if (__alt1) {
      __s5 = __s5 + __ind3 + "else\n" + __alt1;
    }
  }
  if (target === "lua") {
    return __s5 + __ind3 + "end\n";
  } else {
    return __s5 + "\n";
  }
}, stmt: true, tr: true});
setenv("while", {_stash: true, special: function (cond, form) {
  var __cond4 = compile(cond);
  indent_level = indent_level + 1;
  var ____x133 = compile(form, {_stash: true, stmt: true});
  indent_level = indent_level - 1;
  var __body10 = ____x133;
  var __ind5 = indentation();
  if (target === "js") {
    return __ind5 + "while (" + __cond4 + ") {\n" + __body10 + __ind5 + "}\n";
  } else {
    return __ind5 + "while " + __cond4 + " do\n" + __body10 + __ind5 + "end\n";
  }
}, stmt: true, tr: true});
setenv("%names", {_stash: true, special: function (..._42args) {
  var __args111 = unstash([..._42args]);
  if (one63(__args111)) {
    return compile(hd(__args111));
  } else {
    var __e49 = undefined;
    if (target === "js") {
      __e49 = "[";
    } else {
      __e49 = "";
    }
    var __s7 = __e49;
    var __c7 = "";
    var ____x138 = __args111;
    var ____i21 = 0;
    while (____i21 < _35(____x138)) {
      var __x139 = ____x138[____i21];
      __s7 = __s7 + __c7 + compile(__x139);
      __c7 = ", ";
      ____i21 = ____i21 + 1;
    }
    var __e50 = undefined;
    if (target === "js") {
      __e50 = "]";
    } else {
      __e50 = "";
    }
    return __s7 + __e50;
  }
}});
setenv("%for", {_stash: true, special: function (t, k, form) {
  var __t2 = compile(t);
  var __k9 = compile(k);
  var __ind7 = indentation();
  indent_level = indent_level + 1;
  var ____x141 = compile(form, {_stash: true, stmt: true});
  indent_level = indent_level - 1;
  var __body12 = ____x141;
  if (target === "lua") {
    return __ind7 + "for " + __k9 + " in " + __t2 + " do\n" + __body12 + __ind7 + "end\n";
  } else {
    return __ind7 + "for (" + __k9 + " of " + __t2 + ") {\n" + __body12 + __ind7 + "}\n";
  }
}, stmt: true, tr: true});
setenv("%try", {_stash: true, special: function (form) {
  var __e10 = unique("e");
  var __ind9 = indentation();
  indent_level = indent_level + 1;
  var ____x146 = compile(form, {_stash: true, stmt: true});
  indent_level = indent_level - 1;
  var __body14 = ____x146;
  var __hf1 = ["return", ["%array", false, __e10]];
  indent_level = indent_level + 1;
  var ____x149 = compile(__hf1, {_stash: true, stmt: true});
  indent_level = indent_level - 1;
  var __h1 = ____x149;
  return __ind9 + "try {\n" + __body14 + __ind9 + "}\n" + __ind9 + "catch (" + __e10 + ") {\n" + __h1 + __ind9 + "}\n";
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
  if (target === "lua") {
    var __x153 = compile_function(args, body, {_stash: true, name: name});
    return indentation() + __x153;
  } else {
    return compile(["%set", name, ["%function", args, body]], {_stash: true, stmt: true});
  }
}, stmt: true, tr: true});
setenv("%local-function", {_stash: true, special: function (name, args, body) {
  if (target === "lua") {
    var __x159 = compile_function(args, body, {_stash: true, name: name, prefix: "local"});
    return indentation() + __x159;
  } else {
    return compile(["%local", name, ["%function", args, body]], {_stash: true, stmt: true});
  }
}, stmt: true, tr: true});
setenv("return", {_stash: true, special: function (x) {
  var __e51 = undefined;
  if (nil63(x)) {
    __e51 = "return";
  } else {
    __e51 = "return " + compile(x);
  }
  var __x163 = __e51;
  return indentation() + __x163;
}, stmt: true});
setenv("new", {_stash: true, special: function (x) {
  return "new " + compile(x);
}});
setenv("typeof", {_stash: true, special: function (x) {
  return "typeof(" + compile(x) + ")";
}});
setenv("throw", {_stash: true, special: function (x) {
  var __e52 = undefined;
  if (target === "js") {
    __e52 = "throw " + compile(x);
  } else {
    __e52 = "error(" + compile(x) + ")";
  }
  var __e14 = __e52;
  return indentation() + __e14;
}, stmt: true});
setenv("%local", {_stash: true, special: function (name, value) {
  var __id28 = compile(name);
  var __value11 = compile(value);
  var __e53 = undefined;
  if (is63(value)) {
    __e53 = " = " + __value11;
  } else {
    __e53 = "";
  }
  var __rh2 = __e53;
  var __e54 = undefined;
  if (target === "js") {
    __e54 = "var ";
  } else {
    __e54 = "local ";
  }
  var __keyword1 = __e54;
  var __ind11 = indentation();
  return __ind11 + __keyword1 + __id28 + __rh2;
}, stmt: true});
setenv("%set", {_stash: true, special: function (lh, rh) {
  var __lh2 = compile(lh);
  var __e55 = undefined;
  if (nil63(rh)) {
    __e55 = "nil";
  } else {
    __e55 = rh;
  }
  var __rh4 = compile(__e55);
  return indentation() + __lh2 + " = " + __rh4;
}, stmt: true});
setenv("get", {_stash: true, special: function (t, k) {
  var __t12 = compile(t);
  var __k12 = compile(k, {_stash: true, ["escape-reserved"]: false});
  if (target === "lua" && char(__t12, 0) === "{" || infix_operator63(t)) {
    __t12 = "(" + __t12 + ")";
  }
  if (string_literal63(k) && valid_id63(inner(k))) {
    return __t12 + "." + inner(k);
  } else {
    return __t12 + "[" + __k12 + "]";
  }
}});
setenv("%array", {_stash: true, special: function (..._42args) {
  var __forms3 = unstash([..._42args]);
  var __e56 = undefined;
  if (target === "lua") {
    __e56 = "{";
  } else {
    __e56 = "[";
  }
  var __open1 = __e56;
  var __e57 = undefined;
  if (target === "lua") {
    __e57 = "}";
  } else {
    __e57 = "]";
  }
  var __close1 = __e57;
  var __s9 = "";
  var __c9 = "";
  var ____o10 = __forms3;
  var __k111 = undefined;
  for (__k111 of pairs(____o10)) {
    var __v9 = ____o10[__k111];
    if (number63(__k111)) {
      __s9 = __s9 + __c9 + compile(__v9);
      __c9 = ", ";
    }
  }
  return __open1 + __s9 + __close1;
}});
setenv("%object", {_stash: true, special: function (..._42args) {
  var __forms5 = unstash([..._42args]);
  var __s111 = "{";
  var __c111 = "";
  var __e58 = undefined;
  if (target === "lua") {
    __e58 = " = ";
  } else {
    __e58 = ": ";
  }
  var __sep1 = __e58;
  var ____o12 = pair(__forms5);
  var __k14 = undefined;
  for (__k14 of pairs(____o12)) {
    var __v12 = ____o12[__k14];
    if (number63(__k14)) {
      var ____id30 = __v12;
      var __k15 = ____id30[0];
      var __v13 = ____id30[1];
      __s111 = __s111 + __c111 + key(__k15) + __sep1 + compile(__v13);
      __c111 = ", ";
    }
  }
  return __s111 + "}";
}});
setenv("%literal", {_stash: true, special: function (..._42args) {
  var __args13 = unstash([..._42args]);
  return apply(cat, map(unquoted, __args13));
}});
var __e59 = undefined;
if (typeof(exports) === "undefined") {
  __e59 = {};
} else {
  __e59 = exports;
}
var __exports = __e59;
__exports.run = run;
__exports.eval = _eval;
__exports.expand = expand;
__exports.compile = compile;
__exports;
