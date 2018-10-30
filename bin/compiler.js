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
var transformer_function = function (k) {
  return getenv(k, "transformer");
};
var transformer63 = function (k) {
  return is63(transformer_function(k));
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
bind_optional = function (lh, rh) {
  if (hd63(lh, "o") || hd63(lh, "or") || hd63(lh, "&optional")) {
    var ____id = lh;
    var ___ = ____id[0];
    var ___var = ____id[1];
    var __val = ____id[2];
    return bind(___var, ["%if", ["==", rh, "nil"], either(__val, "nil"), rh]);
  }
};
bind_dotted = function (args) {
  if (_35(args) >= 2 && args[_35(args) - 2] === ".") {
    return join(cut(args, 0, _35(args) - 2), {rest: last(args)});
  } else {
    return args;
  }
};
bind_destructuring = function (lh, rh) {
  var __lh = bind_dotted(lh);
  var __id1 = unique("id");
  var __bs = [__id1, rh];
  var ____o1 = __lh;
  var __k1 = undefined;
  for (__k1 of pairs(____o1)) {
    var __v1 = ____o1[__k1];
    var __e9 = undefined;
    if (__k1 === "rest") {
      __e9 = ["cut", __id1, _35(__lh)];
    } else {
      __e9 = ["get", __id1, ["quote", bias(__k1)]];
    }
    var __x6 = __e9;
    __bs = join(__bs, bind(__v1, __x6));
  }
  return __bs;
};
bind = function (lh, rh) {
  if (atom63(lh)) {
    return [lh, rh];
  } else {
    return bind_optional(lh, rh) || bind_destructuring(lh, rh);
  }
};
bind_function = function (args, body) {
  var __args = bind_dotted(args);
  var __args1 = [];
  var rest = function () {
    __args1.rest = true;
    return ["unstash", ["list", "..."]];
  };
  if (atom63(__args)) {
    return [__args1, join(["let", [__args, rest()]], body)];
  } else {
    var __bs1 = [];
    var __ks = {};
    var __r23 = unique("r");
    var ____o2 = __args;
    var __k2 = undefined;
    for (__k2 of pairs(____o2)) {
      var __v2 = ____o2[__k2];
      if (number63(__k2)) {
        if (atom63(__v2)) {
          add(__args1, __v2);
        } else {
          var __x16 = unique("x");
          add(__args1, __x16);
          __bs1 = join(__bs1, [__v2, __x16]);
        }
      } else {
        __ks[__k2] = __v2;
      }
    }
    if (keys63(__args)) {
      __bs1 = join(__bs1, [__r23, rest()]);
      var __n3 = _35(__args1);
      var __i4 = 0;
      while (__i4 < __n3) {
        var __v3 = __args1[__i4];
        __bs1 = join(__bs1, [__v3, ["destash!", __v3, __r23]]);
        __i4 = __i4 + 1;
      }
      __bs1 = join(__bs1, [__ks, __r23]);
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
var expand_local = function (__x24) {
  var ____id2 = __x24;
  var __x25 = ____id2[0];
  var __name = ____id2[1];
  var __value = ____id2[2];
  setenv(__name, {_stash: true, variable: true});
  return ["%local", macroexpand(__name), macroexpand(__value)];
};
var expand_function = function (__x27) {
  var ____id3 = __x27;
  var __x28 = ____id3[0];
  var __args11 = ____id3[1];
  var __body = cut(____id3, 2);
  add(_G.environment, {});
  var ____o3 = __args11;
  var ____i5 = undefined;
  for (____i5 of pairs(____o3)) {
    var ____x29 = ____o3[____i5];
    setenv(____x29, {_stash: true, variable: true});
  }
  var ____x30 = join(["%function", __args11], map(macroexpand, __body));
  drop(_G.environment);
  return ____x30;
};
var expand_definition = function (__x32) {
  var ____id4 = __x32;
  var __x33 = ____id4[0];
  var __name1 = ____id4[1];
  var __args2 = ____id4[2];
  var __body1 = cut(____id4, 3);
  add(_G.environment, {});
  var ____o4 = __args2;
  var ____i6 = undefined;
  for (____i6 of pairs(____o4)) {
    var ____x34 = ____o4[____i6];
    setenv(____x34, {_stash: true, variable: true});
  }
  var ____x35 = join([__x33, macroexpand(__name1), __args2], map(macroexpand, __body1));
  drop(_G.environment);
  return ____x35;
};
var expand_macro = function (form) {
  return macroexpand(expand1(form));
};
expand1 = function (__x37) {
  var ____id5 = __x37;
  var __name2 = ____id5[0];
  var __body2 = cut(____id5, 1);
  return apply(macro_function(__name2), __body2);
};
var expand_transformer = function (form) {
  return transformer_function(hd(hd(form)))(form);
};
identifier63 = function (x) {
  return string63(x) && ! string_literal63(x) && ! id_literal63(x) && ! accessor_literal63(x);
};
expand_compose = function (form) {
  if (identifier63(form)) {
    if (_35(form) >= 3) {
      var ____y = search(form, ":");
      if (yes(____y)) {
        var __i7 = ____y;
        var __parts = split(form, ":");
        if (! find(none63, __parts)) {
          return join(["compose"], map(expand_atom, map(read_string, __parts)));
        }
      }
    }
  }
};
orf = function (f, ..._42args) {
  if (none63([..._42args])) {
    return function (..._42args) {
      return f(..._42args);
    };
  } else {
    var __g = orf(..._42args);
    return function (..._42args) {
      var __x40 = f(..._42args);
      if (yes(__x40)) {
        return __x40;
      } else {
        return __g(..._42args);
      }
    };
  }
};
andf = function (f, ..._42args) {
  if (none63([..._42args])) {
    return function (..._42args) {
      return f(..._42args);
    };
  } else {
    var __g1 = andf(..._42args);
    return function (..._42args) {
      return f(..._42args) && __g1(..._42args);
    };
  }
};
expand_and = function (form) {
  if (identifier63(form)) {
    if (_35(form) >= 3) {
      var ____y1 = search(form, "&");
      if (yes(____y1)) {
        var __i8 = ____y1;
        var __parts1 = split(form, "&");
        if (! find(none63, __parts1)) {
          return join(["andf"], map(expand_atom, map(read_string, __parts1)));
        }
      }
    }
  }
};
ref = function (l, k) {
  if (! nil63(l)) {
    if (function63(l)) {
      return l(k);
    } else {
      return l[k];
    }
  }
};
set_ref = function (l, k, v) {
  if (nil63(l)) {
    return v;
  } else {
    if (function63(l)) {
      set_ref(l(), k, v);
      return l;
    } else {
      l[k] = v;
      return l;
    }
  }
};
expand_ref = function (form) {
  if (identifier63(form)) {
    if (char(form, 0) === "!" && !( char(form, 1) === "!") && _35(form) >= 2) {
      return [["%brackets"], "do", "_" + form];
    } else {
      if (_35(form) >= 3) {
        var ____y2 = search(form, "!");
        if (yes(____y2)) {
          var __i9 = ____y2;
          var __parts2 = split(form, "!");
          if (! find(none63, __parts2)) {
            var __x45 = expand_atom(read_string(hd(__parts2)));
            var ____x46 = map(expand_atom, map(read_string, tl(__parts2)));
            var ____i10 = 0;
            while (____i10 < _35(____x46)) {
              var __k3 = ____x46[____i10];
              __x45 = ["ref", __x45, quoted(__k3)];
              ____i10 = ____i10 + 1;
            }
            return __x45;
          }
        }
      }
    }
  }
};
expand_jsx = function (form) {
  if (identifier63(form) && char(form, 0) === "<" && char(form, edge(form)) === ">") {
    return ["jsx", inner(form)];
  }
};
_G.expand_atom_functions = [];
add(_G.expand_atom_functions, expand_jsx);
expand_atom = function (form) {
  var ____x49 = _G.expand_atom_functions;
  var ____i11 = 0;
  while (____i11 < _35(____x49)) {
    var __f = ____x49[____i11];
    var __x50 = __f(form);
    if (!( __x50 === undefined)) {
      return __x50;
    }
    ____i11 = ____i11 + 1;
  }
  return form;
};
macroexpand_atom = function (form) {
  if (symbol63(form)) {
    return macroexpand(symbol_expansion(form));
  } else {
    var __expr = expand_atom(form);
    if (__expr === form) {
      return __expr;
    } else {
      return macroexpand(__expr);
    }
  }
};
macroexpand = function (form) {
  if (atom63(form)) {
    return macroexpand_atom(form);
  } else {
    if (none63(form)) {
      return map(macroexpand, form);
    } else {
      var __x51 = macroexpand(hd(form));
      var __args3 = tl(form);
      var __form = join([__x51], __args3);
      if (__x51 === undefined) {
        return macroexpand(__args3);
      } else {
        if (__x51 === "%local") {
          return expand_local(__form);
        } else {
          if (__x51 === "%function") {
            return expand_function(__form);
          } else {
            if (__x51 === "%global-function") {
              return expand_definition(__form);
            } else {
              if (__x51 === "%local-function") {
                return expand_definition(__form);
              } else {
                if (macro63(__x51)) {
                  return expand_macro(__form);
                } else {
                  if (hd63(__x51, transformer63)) {
                    return expand_transformer(__form);
                  } else {
                    return join([__x51], map(macroexpand, __args3));
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
var quasiquote_list = function (form, depth) {
  var __xs = [["list"]];
  var ____o5 = form;
  var __k4 = undefined;
  for (__k4 of pairs(____o5)) {
    var __v4 = ____o5[__k4];
    if (! number63(__k4)) {
      var __e10 = undefined;
      if (quasisplice63(__v4, depth)) {
        __e10 = quasiexpand(__v4[1]);
      } else {
        __e10 = quasiexpand(__v4, depth);
      }
      var __v5 = __e10;
      last(__xs)[__k4] = __v5;
    }
  }
  var ____x56 = form;
  var ____i13 = 0;
  while (____i13 < _35(____x56)) {
    var __x57 = ____x56[____i13];
    if (quasisplice63(__x57, depth)) {
      var __x58 = quasiexpand(__x57[1]);
      add(__xs, __x58);
      add(__xs, ["list"]);
    } else {
      add(last(__xs), quasiexpand(__x57, depth));
    }
    ____i13 = ____i13 + 1;
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
expand_if = function (__x62) {
  var ____id6 = __x62;
  var __a = ____id6[0];
  var __b1 = ____id6[1];
  var __c = cut(____id6, 2);
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
  var __i14 = 0;
  while (__i14 < _G.indent_level) {
    __s = __s + "  ";
    __i14 = __i14 + 1;
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
    var __i15 = 0;
    while (__i15 < _35(id)) {
      var __c1 = char(id, __i15);
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
          if (__i15 === 0) {
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
      __i15 = __i15 + 1;
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
  var __x66 = compile_id(x, true);
  if (has63(__names, __x66)) {
    var __i16 = __names[__x66];
    __names[__x66] = __names[__x66] + 1;
    return unique(__x66 + __i16);
  } else {
    __names[__x66] = 1;
    return "__" + __x66;
  }
};
key = function (k) {
  if (string_literal63(k)) {
    var __i17 = inner(k);
    if (valid_id63(__i17)) {
      return __i17;
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
    var __x67 = f(__v6);
    if (is63(__x67)) {
      add(__o6, literal(__k5));
      add(__o6, __x67);
    }
  }
  return __o6;
};
var ____x69 = [];
var ____x70 = [];
____x70.js = "!";
____x70.lua = "not";
____x69.not = ____x70;
var ____x71 = [];
____x71["*"] = "*";
____x71["/"] = "/";
____x71["%"] = "%";
var ____x72 = [];
var ____x73 = [];
____x73.js = "+";
____x73.lua = "..";
____x72.cat = ____x73;
var ____x74 = [];
____x74["+"] = "+";
____x74["-"] = "-";
var ____x75 = [];
____x75["<"] = "<";
____x75[">"] = ">";
____x75["<="] = "<=";
____x75[">="] = ">=";
var ____x76 = [];
var ____x77 = [];
____x77.js = "===";
____x77.lua = "==";
____x76["=="] = ____x77;
var ____x78 = [];
var ____x79 = [];
____x79.js = "&&";
____x79.lua = "and";
____x78.and = ____x79;
var ____x80 = [];
var ____x81 = [];
____x81.js = "||";
____x81.lua = "or";
____x80.or = ____x81;
var infix = [____x69, ____x71, ____x72, ____x74, ____x75, ____x76, ____x78, ____x80];
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
    var __x83 = level[op];
    if (obj63(__x83)) {
      return __x83[_G.target];
    } else {
      if (string63(__x83)) {
        return __x83;
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
  var ____x84 = args;
  var ____i20 = 0;
  while (____i20 < _35(____x84)) {
    var __x85 = ____x84[____i20];
    __s1 = __s1 + __c2 + compile(__x85);
    __c2 = ", ";
    ____i20 = ____i20 + 1;
  }
  return __s1 + ")";
};
var escape_newlines = function (s) {
  var __s11 = "";
  var __i21 = 0;
  while (__i21 < _35(s)) {
    var __c3 = char(s, __i21);
    var __e15 = undefined;
    if (__c3 === "\n") {
      __e15 = "\\n";
    } else {
      var __e16 = undefined;
      if (__c3 === "\r") {
        __e16 = "";
      } else {
        __e16 = __c3;
      }
      __e15 = __e16;
    }
    __s11 = __s11 + __e15;
    __i21 = __i21 + 1;
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
  var ____id7 = form;
  var __x86 = ____id7[0];
  var __args4 = cut(____id7, 1);
  var ____id8 = getenv(__x86);
  var __special = ____id8.special;
  var __stmt = ____id8.stmt;
  var __self_tr63 = ____id8.tr;
  var __tr = terminator(stmt63 && ! __self_tr63);
  return apply(__special, __args4) + __tr;
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
    var __x87 = hd(args);
    if (accessor_literal63(__x87)) {
      return compile_method(f + "." + accessor_literal(__x87), tl(args), true);
    } else {
      if (hd63(__x87, accessor_literal63)) {
        var __e18 = undefined;
        if (_G.target === "lua") {
          __e18 = ":";
        } else {
          __e18 = ".";
        }
        return compile_method(f + __e18 + accessor_literal(hd(__x87)) + compile_args(tl(__x87)), tl(args), true);
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
  var __f1 = hd(form);
  var __f11 = compile(__f1);
  var __args5 = compile_method("", stash_function(tl(form)));
  if (parenthesize_call63(__f1)) {
    return "(" + __f11 + ")" + __args5;
  } else {
    return __f11 + __args5;
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
  var ____id9 = form;
  var __op = ____id9[0];
  var ____id10 = cut(____id9, 1);
  var __a1 = ____id10[0];
  var __b2 = ____id10[1];
  var ____id111 = op_delims(form, __a1, false);
  var __ao = ____id111[0];
  var __ac = ____id111[1];
  var ____id12 = op_delims(form, __b2, true);
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
  var ____r84 = unstash([..._42args]);
  var __args6 = destash33(args, ____r84);
  var __body3 = destash33(body, ____r84);
  var ____id13 = ____r84;
  var __name3 = ____id13.name;
  var __prefix = ____id13.prefix;
  var __global63 = ____id13.global;
  var __async63 = ____id13.async;
  var __generator63 = ____id13.generator;
  var __e20 = undefined;
  if (__name3) {
    __e20 = compile(__name3);
  } else {
    __e20 = "";
  }
  var __id14 = __e20;
  var __e21 = undefined;
  if (__global63) {
    __e21 = "_G." + __id14;
  } else {
    __e21 = __id14;
  }
  var __id15 = __e21;
  var __e22 = undefined;
  if (__args6.rest) {
    __e22 = join(__args6, ["..."]);
  } else {
    __e22 = __args6;
  }
  var __args12 = __e22;
  var __args7 = compile_args(__args12);
  _G.indent_level = _G.indent_level + 1;
  var ____x92 = compile(__body3, {_stash: true, stmt: true});
  _G.indent_level = _G.indent_level - 1;
  var __body4 = ____x92;
  var __ind = indentation();
  var __e23 = undefined;
  if (__prefix) {
    __e23 = __prefix + " ";
  } else {
    __e23 = "";
  }
  var __p = __e23;
  var __e24 = undefined;
  if (_G.target === "js") {
    __e24 = "";
  } else {
    __e24 = "end";
  }
  var __tr1 = __e24;
  var __e25 = undefined;
  if (__async63) {
    __e25 = "async ";
  } else {
    __e25 = "";
  }
  var __async1 = __e25;
  var __e26 = undefined;
  if (__generator63) {
    __e26 = "function* ";
  } else {
    __e26 = "function ";
  }
  var __func = __e26;
  if (__name3) {
    __tr1 = __tr1 + "\n";
  }
  if (_G.target === "js") {
    return __async1 + __func + __id15 + __args7 + " {\n" + __body4 + __ind + "}" + __tr1;
  } else {
    return __p + "function " + __id15 + __args7 + "\n" + __body4 + __ind + __tr1;
  }
};
var can_return63 = function (form) {
  return is63(form) && (atom63(form) || !( hd(form) === "return") && ! statement63(hd(form)));
};
compile = function (form, ..._42args) {
  var ____r86 = unstash([..._42args]);
  var __form1 = destash33(form, ____r86);
  var ____id16 = ____r86;
  var __stmt1 = ____id16.stmt;
  var __esc63 = ____id16["escape-reserved"];
  if (nil63(__form1)) {
    return "";
  } else {
    if (special_form63(__form1)) {
      return compile_special(__form1, __stmt1);
    } else {
      var __tr2 = terminator(__stmt1);
      var __e27 = undefined;
      if (__stmt1) {
        __e27 = indentation();
      } else {
        __e27 = "";
      }
      var __ind1 = __e27;
      var __e28 = undefined;
      if (atom63(__form1)) {
        __e28 = compile_atom(__form1, either(__esc63, true));
      } else {
        var __e29 = undefined;
        if (infix63(hd(__form1))) {
          __e29 = compile_infix(__form1);
        } else {
          __e29 = compile_call(__form1);
        }
        __e28 = __e29;
      }
      var __form2 = __e28;
      return __ind1 + __form2 + __tr2;
    }
  }
};
var lower_statement = function (form, tail63) {
  var __hoist = [];
  var __e = lower(form, __hoist, true, tail63);
  var __e30 = undefined;
  if (some63(__hoist) && is63(__e)) {
    __e30 = join(["%do"], __hoist, [__e]);
  } else {
    var __e31 = undefined;
    if (is63(__e)) {
      __e31 = __e;
    } else {
      var __e32 = undefined;
      if (_35(__hoist) > 1) {
        __e32 = join(["%do"], __hoist);
      } else {
        __e32 = hd(__hoist);
      }
      __e31 = __e32;
    }
    __e30 = __e31;
  }
  return either(__e30, ["%do"]);
};
var lower_body = function (body, tail63) {
  return lower_statement(join(["%do"], body), tail63);
};
var literal63 = function (form) {
  return atom63(form) || hd(form) === "%array" || hd(form) === "%object";
};
var standalone63 = function (form) {
  return ! atom63(form) && ! infix63(hd(form)) && ! literal63(form) && !( "get" === hd(form)) && ! accessor_form63(form) || id_literal63(form);
};
var lower_do = function (args, hoist, stmt63, tail63) {
  var ____x99 = almost(args);
  var ____i22 = 0;
  while (____i22 < _35(____x99)) {
    var __x100 = ____x99[____i22];
    var ____y3 = lower(__x100, hoist, stmt63);
    if (yes(____y3)) {
      var __e1 = ____y3;
      if (standalone63(__e1)) {
        add(hoist, __e1);
      }
    }
    ____i22 = ____i22 + 1;
  }
  var __e2 = lower(last(args), hoist, stmt63, tail63);
  if (tail63 && can_return63(__e2)) {
    return ["return", __e2];
  } else {
    return __e2;
  }
};
var lower_set = function (args, hoist, stmt63, tail63) {
  var ____id17 = args;
  var __lh1 = ____id17[0];
  var __rh = ____id17[1];
  var __lh11 = lower(__lh1, hoist);
  var __rh1 = lower(__rh, hoist);
  add(hoist, ["%set", __lh11, __rh1]);
  if (!( stmt63 && ! tail63)) {
    return __lh11;
  }
};
var lower_if = function (args, hoist, stmt63, tail63) {
  var ____id18 = args;
  var __cond = ____id18[0];
  var __then = ____id18[1];
  var ___else = ____id18[2];
  if (stmt63) {
    var __e34 = undefined;
    if (is63(___else)) {
      __e34 = [lower_body([___else], tail63)];
    }
    return add(hoist, join(["%if", lower(__cond, hoist), lower_body([__then], tail63)], __e34));
  } else {
    var __e3 = unique("e");
    add(hoist, ["%local", __e3, "nil"]);
    var __e33 = undefined;
    if (is63(___else)) {
      __e33 = [lower(["%set", __e3, ___else])];
    }
    add(hoist, join(["%if", lower(__cond, hoist), lower(["%set", __e3, __then])], __e33));
    return __e3;
  }
};
var lower_short = function (x, args, hoist) {
  var ____id19 = args;
  var __a3 = ____id19[0];
  var __b4 = ____id19[1];
  var __hoist1 = [];
  var __b11 = lower(__b4, __hoist1);
  if (some63(__hoist1)) {
    var __id20 = unique("id");
    var __e35 = undefined;
    if (x === "and") {
      __e35 = ["%if", __id20, __b4, __id20];
    } else {
      __e35 = ["%if", __id20, __id20, __b4];
    }
    return lower(["%do", ["%local", __id20, __a3], __e35], hoist);
  } else {
    return [x, lower(__a3, hoist), __b11];
  }
};
var lower_try = function (args, hoist, tail63) {
  return add(hoist, ["%try", lower_body(args, tail63)]);
};
var lower_while = function (args, hoist) {
  var ____id21 = args;
  var __c4 = ____id21[0];
  var __body5 = cut(____id21, 1);
  var __pre = [];
  var __c5 = lower(__c4, __pre);
  var __e36 = undefined;
  if (none63(__pre)) {
    __e36 = ["%while", __c5, lower_body(__body5)];
  } else {
    __e36 = ["%while", true, join(["%do"], __pre, [["%if", ["not", __c5], ["break"]], lower_body(__body5)])];
  }
  return add(hoist, __e36);
};
var lower_for = function (args, hoist) {
  var ____id22 = args;
  var __t = ____id22[0];
  var __k7 = ____id22[1];
  var __body6 = cut(____id22, 2);
  return add(hoist, join(["%for", lower(__t, hoist), __k7, lower_body(__body6)], props(__body6)));
};
var lower_function = function (args) {
  var ____id23 = args;
  var __a4 = ____id23[0];
  var __body7 = cut(____id23, 1);
  return join(["%function", __a4, lower_body(__body7, true)], props(__body7));
};
var lower_definition = function (kind, args, hoist, stmt63, tail63) {
  var ____id24 = args;
  var __name4 = ____id24[0];
  var __args8 = ____id24[1];
  var __body8 = cut(____id24, 2);
  var __name11 = lower(__name4, hoist);
  add(hoist, join([kind, __name11, __args8, lower_body(__body8, true)], props(__body8)));
  if (!( stmt63 && ! tail63)) {
    return __name11;
  }
};
var lower_call = function (form, hoist) {
  var __form3 = map(function (x) {
    return lower(x, hoist);
  }, form);
  if (some63(__form3)) {
    return __form3;
  }
};
var lower_infix63 = function (form) {
  return _35(form) > 3 && infix63(hd(form));
};
var infix_form = function (__x128) {
  var ____id25 = __x128;
  var __x129 = ____id25[0];
  var __a5 = ____id25[1];
  var __bs2 = cut(____id25, 2);
  var ____x130 = __bs2;
  var ____i23 = 0;
  while (____i23 < _35(____x130)) {
    var __b5 = ____x130[____i23];
    __a5 = [__x129, __a5, __b5];
    ____i23 = ____i23 + 1;
  }
  return __a5;
};
var lower_pairwise63 = function (form) {
  return _35(form) > 3 && in63(hd(form), ["<", "<=", "==", ">=", ">"]);
};
var pairwise_form = function (__x133) {
  var ____id26 = __x133;
  var __x134 = ____id26[0];
  var __a6 = ____id26[1];
  var __bs3 = cut(____id26, 2);
  var __e4 = ["and"];
  var ____x136 = __bs3;
  var ____i24 = 0;
  while (____i24 < _35(____x136)) {
    var __b6 = ____x136[____i24];
    add(__e4, [__x134, __a6, __b6]);
    __a6 = __b6;
    ____i24 = ____i24 + 1;
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
            var ____id27 = form;
            var __x139 = ____id27[0];
            var __args9 = cut(____id27, 1);
            if (__x139 === "%do") {
              return lower_do(__args9, hoist, stmt63, tail63);
            } else {
              if (__x139 === "%call") {
                return lower(__args9, hoist, stmt63, tail63);
              } else {
                if (__x139 === "%set") {
                  return lower_set(__args9, hoist, stmt63, tail63);
                } else {
                  if (__x139 === "%if") {
                    return lower_if(__args9, hoist, stmt63, tail63);
                  } else {
                    if (__x139 === "%try") {
                      return lower_try(__args9, hoist, tail63);
                    } else {
                      if (__x139 === "%while") {
                        return lower_while(__args9, hoist);
                      } else {
                        if (__x139 === "%for") {
                          return lower_for(__args9, hoist);
                        } else {
                          if (__x139 === "%function") {
                            return lower_function(__args9);
                          } else {
                            if (__x139 === "%local-function" || __x139 === "%global-function") {
                              return lower_definition(__x139, __args9, hoist, stmt63, tail63);
                            } else {
                              if (in63(__x139, ["and", "or"])) {
                                return lower_short(__x139, __args9, hoist);
                              } else {
                                if (statement63(__x139)) {
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
_G._37result = undefined;
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
setenv("%do", {_stash: true, special: function (..._42args) {
  var __forms = unstash([..._42args]);
  var __s2 = "";
  var ____x143 = __forms;
  var ____i25 = 0;
  while (____i25 < _35(____x143)) {
    var __x144 = ____x143[____i25];
    if (_G.target === "lua" && immediate_call63(__x144) && "\n" === char(__s2, edge(__s2))) {
      __s2 = clip(__s2, 0, edge(__s2)) + ";\n";
    }
    __s2 = __s2 + compile(__x144, {_stash: true, stmt: true});
    if (! atom63(__x144)) {
      if (hd(__x144) === "return" || hd(__x144) === "break") {
        break;
      }
    }
    ____i25 = ____i25 + 1;
  }
  return __s2;
}, stmt: true, tr: true});
setenv("%if", {_stash: true, special: function (cond, cons, alt) {
  var __cond1 = compile(cond);
  _G.indent_level = _G.indent_level + 1;
  var ____x145 = compile(cons, {_stash: true, stmt: true});
  _G.indent_level = _G.indent_level - 1;
  var __cons = ____x145;
  var __e37 = undefined;
  if (alt) {
    _G.indent_level = _G.indent_level + 1;
    var ____x146 = compile(alt, {_stash: true, stmt: true});
    _G.indent_level = _G.indent_level - 1;
    __e37 = ____x146;
  }
  var __alt = __e37;
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
setenv("%while", {_stash: true, special: function (cond, form) {
  var __cond2 = compile(cond);
  _G.indent_level = _G.indent_level + 1;
  var ____x147 = compile(form, {_stash: true, stmt: true});
  _G.indent_level = _G.indent_level - 1;
  var __body9 = ____x147;
  var __ind3 = indentation();
  if (_G.target === "js") {
    return __ind3 + "while (" + __cond2 + ") {\n" + __body9 + __ind3 + "}\n";
  } else {
    return __ind3 + "while " + __cond2 + " do\n" + __body9 + __ind3 + "end\n";
  }
}, stmt: true, tr: true});
setenv("%names", {_stash: true, special: function (..._42args) {
  var __args10 = unstash([..._42args]);
  if (one63(__args10)) {
    return compile(hd(__args10));
  } else {
    var __e38 = undefined;
    if (_G.target === "js") {
      __e38 = "[";
    } else {
      __e38 = "";
    }
    var __s4 = __e38;
    var __c6 = "";
    var ____x149 = __args10;
    var ____i26 = 0;
    while (____i26 < _35(____x149)) {
      var __x150 = ____x149[____i26];
      __s4 = __s4 + __c6 + compile(__x150);
      __c6 = ", ";
      ____i26 = ____i26 + 1;
    }
    var __e39 = undefined;
    if (_G.target === "js") {
      __e39 = "]";
    } else {
      __e39 = "";
    }
    return __s4 + __e39;
  }
}});
setenv("%for", {_stash: true, special: function (t, k, form, ..._42args) {
  var ____r113 = unstash([..._42args]);
  var __t1 = destash33(t, ____r113);
  var __k8 = destash33(k, ____r113);
  var __form4 = destash33(form, ____r113);
  var ____id28 = ____r113;
  var __await63 = ____id28.await;
  var __t2 = compile(__t1);
  var __k9 = compile(__k8);
  var __ind4 = indentation();
  _G.indent_level = _G.indent_level + 1;
  var ____x152 = compile(__form4, {_stash: true, stmt: true});
  _G.indent_level = _G.indent_level - 1;
  var __body10 = ____x152;
  var __e40 = undefined;
  if (__await63) {
    __e40 = "await ";
  } else {
    __e40 = "";
  }
  var __a7 = __e40;
  if (_G.target === "lua") {
    return __ind4 + "for " + __k9 + " in " + __t2 + " do\n" + __body10 + __ind4 + "end\n";
  } else {
    return __ind4 + "for " + __a7 + "(" + __k9 + " of " + __t2 + ") {\n" + __body10 + __ind4 + "}\n";
  }
}, stmt: true, tr: true});
setenv("%try", {_stash: true, special: function (form) {
  var __e6 = unique("e");
  var __ind5 = indentation();
  _G.indent_level = _G.indent_level + 1;
  var ____x153 = compile(form, {_stash: true, stmt: true});
  _G.indent_level = _G.indent_level - 1;
  var __body11 = ____x153;
  var __hf = ["return", ["%array", false, __e6]];
  _G.indent_level = _G.indent_level + 1;
  var ____x156 = compile(__hf, {_stash: true, stmt: true});
  _G.indent_level = _G.indent_level - 1;
  var __h = ____x156;
  return __ind5 + "try {\n" + __body11 + __ind5 + "}\n" + __ind5 + "catch (" + __e6 + ") {\n" + __h + __ind5 + "}\n";
}, stmt: true, tr: true});
setenv("%delete", {_stash: true, special: function (place) {
  return indentation() + "delete " + compile(place);
}, stmt: true});
setenv("break", {_stash: true, special: function () {
  return indentation() + "break";
}, stmt: true});
setenv("%function", {_stash: true, special: function (args, ..._42args) {
  var ____r117 = unstash([..._42args]);
  var __args111 = destash33(args, ____r117);
  var ____id29 = ____r117;
  var __body12 = cut(____id29, 0);
  return apply(compile_function, join([__args111], __body12));
}});
setenv("%global-function", {_stash: true, special: function (name, args, ..._42args) {
  var ____r118 = unstash([..._42args]);
  var __name5 = destash33(name, ____r118);
  var __args121 = destash33(args, ____r118);
  var ____id30 = ____r118;
  var __body13 = cut(____id30, 0);
  if (_G.target === "lua") {
    var ____x161 = [__args121];
    ____x161.name = __name5;
    ____x161.global = true;
    var __x160 = apply(compile_function, join(____x161, __body13));
    return indentation() + __x160;
  } else {
    return compile(["%set", __name5, join(["%function", __args121], __body13)], {_stash: true, stmt: true});
  }
}, stmt: true, tr: true});
setenv("%local-function", {_stash: true, special: function (name, args, ..._42args) {
  var ____r119 = unstash([..._42args]);
  var __name6 = destash33(name, ____r119);
  var __args13 = destash33(args, ____r119);
  var ____id31 = ____r119;
  var __body14 = cut(____id31, 0);
  if (_G.target === "lua") {
    var ____x166 = [__args13];
    ____x166.name = __name6;
    ____x166.prefix = "local";
    var __x165 = apply(compile_function, join(____x166, __body14));
    return indentation() + __x165;
  } else {
    return compile(["%local", __name6, join(["%function", __args13], __body14)], {_stash: true, stmt: true});
  }
}, stmt: true, tr: true});
setenv("return", {_stash: true, special: function (x) {
  var __e41 = undefined;
  if (nil63(x)) {
    __e41 = "return";
  } else {
    __e41 = "return " + compile(x);
  }
  var __x169 = __e41;
  return indentation() + __x169;
}, stmt: true});
setenv("new", {_stash: true, special: function (x) {
  return "new " + compile(x);
}});
setenv("typeof", {_stash: true, special: function (x) {
  return "typeof(" + compile(x) + ")";
}});
setenv("throw", {_stash: true, special: function (x) {
  var __e42 = undefined;
  if (_G.target === "js") {
    __e42 = "throw " + compile(x);
  } else {
    __e42 = "error(" + compile(x) + ")";
  }
  var __e7 = __e42;
  return indentation() + __e7;
}, stmt: true});
setenv("%local", {_stash: true, special: function (name, value) {
  var __id32 = compile(name);
  var __value1 = compile(value);
  var __e43 = undefined;
  if (is63(value)) {
    __e43 = " = " + __value1;
  } else {
    __e43 = "";
  }
  var __rh11 = __e43;
  var __e44 = undefined;
  if (_G.target === "js") {
    __e44 = "var ";
  } else {
    __e44 = "local ";
  }
  var __keyword = __e44;
  var __ind6 = indentation();
  return __ind6 + __keyword + __id32 + __rh11;
}, stmt: true});
setenv("%set", {_stash: true, special: function (lh, rh) {
  var __lh2 = compile(lh);
  var __e45 = undefined;
  if (nil63(rh)) {
    __e45 = "nil";
  } else {
    __e45 = rh;
  }
  var __rh2 = compile(__e45);
  return indentation() + __lh2 + " = " + __rh2;
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
  var __e46 = undefined;
  if (_G.target === "lua") {
    __e46 = "{";
  } else {
    __e46 = "[";
  }
  var __open = __e46;
  var __e47 = undefined;
  if (_G.target === "lua") {
    __e47 = "}";
  } else {
    __e47 = "]";
  }
  var __close = __e47;
  var __s5 = "";
  var __c7 = "";
  var ____o9 = __forms1;
  var __k10 = undefined;
  for (__k10 of pairs(____o9)) {
    var __v8 = ____o9[__k10];
    if (number63(__k10)) {
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
  var __e48 = undefined;
  if (_G.target === "lua") {
    __e48 = " = ";
  } else {
    __e48 = ": ";
  }
  var __sep = __e48;
  var ____o10 = pair(__forms2);
  var __k111 = undefined;
  for (__k111 of pairs(____o10)) {
    var __v9 = ____o10[__k111];
    if (number63(__k111)) {
      var ____id33 = __v9;
      var __k12 = ____id33[0];
      var __v10 = ____id33[1];
      __s6 = __s6 + __c8 + key(__k12) + __sep + compile(__v10);
      __c8 = ", ";
    }
  }
  return __s6 + "}";
}});
setenv("%literal", {_stash: true, special: function (..._42args) {
  var __args14 = unstash([..._42args]);
  return apply(cat, map(unquoted, __args14));
}});
setenv("unpack", {_stash: true, special: function (x) {
  if (_G.target === "lua") {
    return "(unpack or table.unpack)(" + compile(x) + ")";
  } else {
    return "..." + compile(x);
  }
}});
var __e49 = undefined;
if (typeof(exports) === "undefined") {
  __e49 = {};
} else {
  __e49 = exports;
}
var __exports = __e49;
__exports.run = run;
__exports.eval = _eval;
__exports.expand = expand;
__exports.compile = compile;
__exports;
