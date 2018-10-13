_G.environment = [{}];
_G.target = "js";
var __v = undefined;
values = function (..._42args) {
  __v = [..._42args];
  return __v[0];
};
results = function (x, ..._42args) {
  var r = __v || [x, ..._42args];
  __v = undefined;
  return r;
};
select = function (n, ..._42args) {
  if (n === "#") {
    return values(results(..._42args).length);
  } else {
    return values(...cut(results(..._42args), n - 1));
  }
};
pairs = function (l) {
  return Object.keys(l).map(function (k) {
    if (numeric63(k)) {
      return parseInt(k);
    } else {
      return k;
    }
  });
};
ipairs = function (l) {
  return pairs(l).filter(number63);
};
pcall = function (f, ..._42args) {
  var ____id = (function () {
    try {
      return [true, results(f(..._42args))];
    }
    catch (__e11) {
      return [false, __e11];
    }
  })();
  var __ok = ____id[0];
  var __v1 = ____id[1];
  return values(__ok, ...__v1);
};
nil63 = function (x) {
  return x === undefined || x === null;
};
is63 = function (x) {
  return ! nil63(x);
};
no = function (x) {
  return nil63(x) || x === false;
};
yes = function (x) {
  return ! no(x);
};
either = function (x, y) {
  if (is63(x)) {
    return x;
  } else {
    return y;
  }
};
has63 = function (l, k) {
  return l.hasOwnProperty(k);
};
_35 = function (x) {
  return x.length || 0;
};
none63 = function (x) {
  return _35(x) === 0;
};
some63 = function (x) {
  return _35(x) > 0;
};
one63 = function (x) {
  return _35(x) === 1;
};
two63 = function (x) {
  return _35(x) === 2;
};
hd = function (l) {
  return l[0];
};
type = function (x) {
  return typeof(x);
};
string63 = function (x) {
  return type(x) === "string";
};
number63 = function (x) {
  return type(x) === "number";
};
boolean63 = function (x) {
  return type(x) === "boolean";
};
function63 = function (x) {
  return type(x) === "function";
};
obj63 = function (x) {
  return is63(x) && type(x) === "object";
};
atom63 = function (x) {
  return nil63(x) || string63(x) || number63(x) || boolean63(x);
};
hd63 = function (l, x) {
  var __id2 = obj63(l);
  var __e1 = undefined;
  if (__id2) {
    var __e2 = undefined;
    if (function63(x)) {
      __e2 = x(hd(l));
    } else {
      __e2 = hd(l) === x;
    }
    __e1 = __e2;
  } else {
    __e1 = __id2;
  }
  return __e1;
};
_G.nan = 0 / 0;
_G.inf = 1 / 0;
_G._inf = - inf;
nan63 = function (n) {
  return !( n === n);
};
inf63 = function (n) {
  return n === inf || n === _inf;
};
clip = function (s, from, upto) {
  return s.substring(from, upto);
};
natural63 = function (i) {
  return number63(i) && i > 0 && i % 1 === 0;
};
index63 = function (i) {
  return number63(i);
};
iterate = function (o, f, l, r) {
  var __from = inf;
  var __upto = _inf;
  var ____o = l;
  var __k = undefined;
  for (__k of pairs(____o)) {
    var __v2 = ____o[__k];
    if (index63(__k)) {
      if (__k < __from) {
        __from = __k;
      }
      if (__k > __upto) {
        __upto = __k;
      }
    } else {
      r = f(r, __v2, __k, undefined);
    }
  }
  __upto = __upto + 1;
  var __i1 = __from;
  while (__i1 < __upto) {
    var __v3 = l[__i1];
    r = f(r, __v3, undefined, __i1);
    __i1 = __i1 + 1;
  }
  var __o1 = o || {};
  __o1.result = r;
  __o1.from = __from;
  __o1.upto = __upto;
  return __o1;
};
var __o2 = {};
reduce = function (f, l, r) {
  return iterate(__o2, f, l, r).result;
};
cut = function (x, from, upto) {
  var __l = [];
  var __j = 0;
  var __e3 = undefined;
  if (nil63(from) || from < 0) {
    __e3 = 0;
  } else {
    __e3 = from;
  }
  var __i2 = __e3;
  var __n1 = _35(x);
  var __e4 = undefined;
  if (nil63(upto) || upto > __n1) {
    __e4 = __n1;
  } else {
    __e4 = upto;
  }
  var __upto1 = __e4;
  while (__i2 < __upto1) {
    __l[__j] = x[__i2];
    __i2 = __i2 + 1;
    __j = __j + 1;
  }
  var ____o3 = x;
  var __k1 = undefined;
  for (__k1 of pairs(____o3)) {
    var __v4 = ____o3[__k1];
    if (! number63(__k1)) {
      __l[__k1] = __v4;
    }
  }
  return __l;
};
keys = function (x) {
  var __t = [];
  var ____o4 = x;
  var __k2 = undefined;
  for (__k2 of pairs(____o4)) {
    var __v5 = ____o4[__k2];
    if (! number63(__k2)) {
      __t[__k2] = __v5;
    }
  }
  return __t;
};
edge = function (x) {
  return _35(x) - 1;
};
inner = function (x) {
  return clip(x, 1, edge(x));
};
tl = function (l) {
  return cut(l, 1);
};
char = function (s, n) {
  return s.charAt(n);
};
code = function (s, n) {
  return s.charCodeAt(n);
};
from_code = function (n) {
  return String.fromCharCode(n);
};
string_literal63 = function (x) {
  return string63(x) && char(x, 0) === "\"";
};
id_literal63 = function (x) {
  return string63(x) && char(x, 0) === "|";
};
add = function (l, x) {
  l.push(x);
  return undefined;
};
drop = function (l) {
  return l.pop();
};
last = function (l) {
  return l[edge(l)];
};
almost = function (l) {
  return cut(l, 0, edge(l));
};
reverse = function (l) {
  var __l1 = keys(l);
  var __i5 = edge(l);
  while (__i5 >= 0) {
    add(__l1, l[__i5]);
    __i5 = __i5 - 1;
  }
  return __l1;
};
join = function (..._42args) {
  var __ls = unstash([..._42args]);
  var __r50 = [];
  var ____x5 = __ls;
  var ____i6 = 0;
  while (____i6 < _35(____x5)) {
    var __l11 = ____x5[____i6];
    if (__l11) {
      var __n4 = _35(__r50);
      var ____o5 = __l11;
      var __k3 = undefined;
      for (__k3 of pairs(____o5)) {
        var __v6 = ____o5[__k3];
        if (number63(__k3)) {
          __k3 = __k3 + __n4;
        }
        __r50[__k3] = __v6;
      }
    }
    ____i6 = ____i6 + 1;
  }
  return __r50;
};
testify = function (x, test) {
  if (function63(x)) {
    return x;
  } else {
    if (test) {
      return function (y) {
        return test(y, x);
      };
    } else {
      return function (y) {
        return x === y;
      };
    }
  }
};
find = function (x, t) {
  var __f = testify(x);
  var ____o6 = t;
  var ____i8 = undefined;
  for (____i8 of pairs(____o6)) {
    var __x6 = ____o6[____i8];
    var __y = __f(__x6);
    if (__y) {
      return __y;
    }
  }
};
first = function (x, l, pos) {
  var __f1 = testify(x);
  var __i9 = either(pos, 0);
  var __n7 = -1;
  var ____o7 = l;
  var __k4 = undefined;
  for (__k4 of pairs(____o7)) {
    var __v7 = ____o7[__k4];
    if (number63(__k4)) {
      __n7 = max(__n7, __k4);
    }
  }
  __n7 = __n7 + 1;
  while (__i9 < __n7) {
    var __v8 = l[__i9];
    var ____y1 = __f1(__v8);
    if (yes(____y1)) {
      var __y2 = ____y1;
      return __i9;
    }
    __i9 = __i9 + 1;
  }
};
in63 = function (x, t) {
  return find(testify(x), t);
};
pair = function (l) {
  var __l12 = [];
  var __i11 = 0;
  while (__i11 < _35(l)) {
    add(__l12, [l[__i11], l[__i11 + 1]]);
    __i11 = __i11 + 1;
    __i11 = __i11 + 1;
  }
  return __l12;
};
sort = function (l, f) {
  var __e5 = undefined;
  if (f) {
    __e5 = function (a, b) {
      if (f(a, b)) {
        return -1;
      } else {
        return 1;
      }
    };
  }
  return l.sort(__e5);
};
map = function (f, x) {
  var __t1 = [];
  var ____x8 = x;
  var ____i12 = 0;
  while (____i12 < _35(____x8)) {
    var __v9 = ____x8[____i12];
    var __y3 = f(__v9);
    if (is63(__y3)) {
      add(__t1, __y3);
    }
    ____i12 = ____i12 + 1;
  }
  var ____o8 = x;
  var __k5 = undefined;
  for (__k5 of pairs(____o8)) {
    var __v10 = ____o8[__k5];
    if (! number63(__k5)) {
      var __y4 = f(__v10);
      if (is63(__y4)) {
        __t1[__k5] = __y4;
      }
    }
  }
  return __t1;
};
keep = function (v, x) {
  var __f2 = testify(v);
  return map(function (v) {
    if (yes(__f2(v))) {
      return v;
    }
  }, x);
};
keys63 = function (t) {
  var ____o9 = t;
  var __k6 = undefined;
  for (__k6 of pairs(____o9)) {
    var __v11 = ____o9[__k6];
    if (! number63(__k6)) {
      return true;
    }
  }
  return false;
};
empty63 = function (t) {
  var ____o10 = t;
  var ____i15 = undefined;
  for (____i15 of pairs(____o10)) {
    var __x9 = ____o10[____i15];
    return false;
  }
  return true;
};
stash = function (args) {
  if (keys63(args)) {
    var __p = [];
    var ____o11 = args;
    var __k7 = undefined;
    for (__k7 of pairs(____o11)) {
      var __v12 = ____o11[__k7];
      if (! number63(__k7)) {
        __p[__k7] = __v12;
      }
    }
    __p._stash = true;
    add(args, __p);
  }
  return args;
};
unstash = function (args) {
  if (none63(args)) {
    return [];
  } else {
    var __l2 = last(args);
    if (obj63(__l2) && __l2._stash) {
      var __args1 = almost(args);
      var ____o12 = __l2;
      var __k8 = undefined;
      for (__k8 of pairs(____o12)) {
        var __v13 = ____o12[__k8];
        if (!( __k8 === "_stash")) {
          __args1[__k8] = __v13;
        }
      }
      return __args1;
    } else {
      return args;
    }
  }
};
destash33 = function (l, args1) {
  if (obj63(l) && l._stash) {
    var ____o13 = l;
    var __k9 = undefined;
    for (__k9 of pairs(____o13)) {
      var __v14 = ____o13[__k9];
      if (!( __k9 === "_stash")) {
        args1[__k9] = __v14;
      }
    }
  } else {
    return l;
  }
};
search = function (s, pattern, start) {
  var __i19 = s.indexOf(pattern, start);
  if (__i19 >= 0) {
    return __i19;
  }
};
split = function (s, sep) {
  if (s === "" || sep === "") {
    return [];
  } else {
    var __l3 = [];
    var __n15 = _35(sep);
    while (true) {
      var __i20 = search(s, sep);
      if (nil63(__i20)) {
        break;
      } else {
        add(__l3, clip(s, 0, __i20));
        s = clip(s, __i20 + __n15);
      }
    }
    add(__l3, s);
    return __l3;
  }
};
cat = function (s, ..._42args) {
  return reduce(function (a, b) {
    return a + b;
  }, [..._42args], s || "");
};
_43 = function (n, ..._42args) {
  return reduce(function (a, b) {
    return a + b;
  }, [..._42args], n || 0);
};
_45 = function (n, ..._42args) {
  return reduce(function (a, b) {
    return a - b;
  }, [..._42args], n || 0);
};
_42 = function (n, ..._42args) {
  return reduce(function (a, b) {
    return a * b;
  }, [..._42args], either(n, 1));
};
_47 = function (n, ..._42args) {
  return reduce(function (a, b) {
    return a / b;
  }, [..._42args], either(n, 1));
};
_37 = function (n, ..._42args) {
  return reduce(function (a, b) {
    return a % b;
  }, [..._42args], either(n, 1));
};
var pairwise = function (f, xs) {
  var __i21 = 0;
  while (__i21 < edge(xs)) {
    var __a = xs[__i21];
    var __b = xs[__i21 + 1];
    if (! f(__a, __b)) {
      return false;
    }
    __i21 = __i21 + 1;
  }
  return true;
};
_60 = function (..._42args) {
  var __xs = unstash([..._42args]);
  return pairwise(function (a, b) {
    return a < b;
  }, __xs);
};
_62 = function (..._42args) {
  var __xs1 = unstash([..._42args]);
  return pairwise(function (a, b) {
    return a > b;
  }, __xs1);
};
_61 = function (..._42args) {
  var __xs2 = unstash([..._42args]);
  return pairwise(function (a, b) {
    return a === b;
  }, __xs2);
};
_6061 = function (..._42args) {
  var __xs3 = unstash([..._42args]);
  return pairwise(function (a, b) {
    return a <= b;
  }, __xs3);
};
_6261 = function (..._42args) {
  var __xs4 = unstash([..._42args]);
  return pairwise(function (a, b) {
    return a >= b;
  }, __xs4);
};
number = function (s) {
  var __n16 = parseFloat(s);
  if (! isNaN(__n16)) {
    return __n16;
  }
};
number_code63 = function (n) {
  return n > 47 && n < 58;
};
numeric63 = function (s) {
  var __n17 = _35(s);
  var __i22 = 0;
  while (__i22 < __n17) {
    if (! number_code63(code(s, __i22))) {
      return false;
    }
    __i22 = __i22 + 1;
  }
  return some63(s);
};
lowercase_code63 = function (n) {
  return n > 96 && n < 123;
};
camel_case = function (str) {
  var __s = "";
  var __n18 = _35(str);
  var __i23 = 0;
  while (__i23 < __n18) {
    var __c = code(str, __i23);
    if (__c === 45 && lowercase_code63(code(str, __i23 - 1) || 0) && lowercase_code63(code(str, __i23 + 1) || 0)) {
      __i23 = __i23 + 1;
      __c = code(str, __i23) - 32;
    }
    __s = __s + from_code(__c);
    __i23 = __i23 + 1;
  }
  return __s;
};
tostring = function (x) {
  if (string63(x)) {
    return x;
  } else {
    if (nil63(x)) {
      return "nil";
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
            if (boolean63(x)) {
              if (x) {
                return "true";
              } else {
                return "false";
              }
            } else {
              return x.toString();
            }
          }
        }
      }
    }
  }
};
escape = function (s) {
  var __s1 = "\"";
  var __i24 = 0;
  while (__i24 < _35(s)) {
    var __c1 = char(s, __i24);
    var __e6 = undefined;
    if (__c1 === "\n") {
      __e6 = "\\n";
    } else {
      var __e7 = undefined;
      if (__c1 === "\r") {
        __e7 = "\\r";
      } else {
        var __e8 = undefined;
        if (__c1 === "\"") {
          __e8 = "\\\"";
        } else {
          var __e9 = undefined;
          if (__c1 === "\\") {
            __e9 = "\\\\";
          } else {
            __e9 = __c1;
          }
          __e8 = __e9;
        }
        __e7 = __e8;
      }
      __e6 = __e7;
    }
    var __c11 = __e6;
    __s1 = __s1 + __c11;
    __i24 = __i24 + 1;
  }
  return __s1 + "\"";
};
str = function (x, stack) {
  if (string63(x)) {
    return escape(x);
  } else {
    if (atom63(x)) {
      return tostring(x);
    } else {
      if (function63(x)) {
        return "function";
      } else {
        if (stack && in63(x, stack)) {
          return "circular";
        } else {
          if (false) {
            return escape(tostring(x));
          } else {
            var __s11 = "(";
            var __sp = "";
            var __xs5 = [];
            var __ks = [];
            var __l4 = stack || [];
            add(__l4, x);
            var ____o14 = x;
            var __k10 = undefined;
            for (__k10 of pairs(____o14)) {
              var __v15 = ____o14[__k10];
              if (number63(__k10)) {
                __xs5[__k10] = str(__v15, __l4);
              } else {
                add(__ks, __k10 + ":");
                add(__ks, str(__v15, __l4));
              }
            }
            drop(__l4);
            var ____o15 = join(__xs5, __ks);
            var ____i26 = undefined;
            for (____i26 of pairs(____o15)) {
              var __v16 = ____o15[____i26];
              __s11 = __s11 + __sp + __v16;
              __sp = " ";
            }
            return __s11 + ")";
          }
        }
      }
    }
  }
};
apply = function (f, args) {
  return f(...stash(args));
};
call = function (f, ..._42args) {
  return f(..._42args);
};
setenv = function (k, ..._42args) {
  var ____r98 = unstash([..._42args]);
  var __k11 = destash33(k, ____r98);
  var ____id1 = ____r98;
  var __keys = cut(____id1, 0);
  if (string63(__k11)) {
    var __e10 = undefined;
    if (__keys.toplevel) {
      __e10 = hd(_G.environment);
    } else {
      __e10 = last(_G.environment);
    }
    var __frame = __e10;
    var __entry = __frame[__k11] || {};
    var ____o16 = __keys;
    var __k12 = undefined;
    for (__k12 of pairs(____o16)) {
      var __v17 = ____o16[__k12];
      __entry[__k12] = __v17;
    }
    __frame[__k11] = __entry;
    return __frame[__k11];
  }
};
print = function (x) {
  return console.log(x);
};
error = function (x) {
  throw new Error(x);
};
var math = Math;
_G.abs = math.abs;
_G.acos = math.acos;
_G.asin = math.asin;
_G.atan = math.atan;
_G.atan2 = math.atan2;
_G.ceil = math.ceil;
_G.cos = math.cos;
_G.floor = math.floor;
_G.log = math.log;
_G.log10 = math.log10;
_G.max = math.max;
_G.min = math.min;
_G.pow = math.pow;
_G.random = math.random;
_G.sin = math.sin;
_G.sinh = math.sinh;
_G.sqrt = math.sqrt;
_G.tan = math.tan;
_G.tanh = math.tanh;
_G.trunc = math.floor;
setenv("quote", {_stash: true, macro: function (form) {
  return quoted(form);
}});
setenv("quasiquote", {_stash: true, macro: function (form) {
  return quasiexpand(form, 1);
}});
get_place = function (place, setfn) {
  var __place = macroexpand(place);
  if (atom63(__place) || hd(__place) === "get" && nil63(getenv("get", "expander")) || accessor_literal63(hd(tl(__place)))) {
    return setfn(__place, function (v) {
      return ["%set", __place, v];
    });
  } else {
    var __head = hd(__place);
    var __gf = getenv(__head, "expander");
    if (__gf) {
      return apply(__gf, join([setfn], tl(__place)));
    } else {
      return error(str(__place) + " is not a valid place expression");
    }
  }
};
setenv("let-place", {_stash: true, macro: function (vars, place, ..._42args) {
  var ____r4 = unstash([..._42args]);
  var __vars = destash33(vars, ____r4);
  var __place1 = destash33(place, ____r4);
  var ____id = ____r4;
  var __body = cut(____id, 0);
  return ["get-place", __place1, join(["fn", __vars], __body)];
}});
setenv("define-expander", {_stash: true, macro: function (name, handler) {
  var ____x5 = ["setenv", ["quote", name]];
  ____x5.expander = handler;
  var __form = ____x5;
  _eval(__form);
  return __form;
}});
define_setter = function (name, setter, setfn, args, vars) {
  if (none63(args)) {
    var __vars1 = reverse(vars);
    return setfn(join([name], __vars1), function (v) {
      return apply(setter, join([v], __vars1));
    });
  } else {
    var __v = hd(args);
    return define_setter(name, setter, setfn, tl(args), join([__v], vars));
  }
};
setenv("define-setter", {_stash: true, macro: function (name, arglist, ..._42args) {
  var ____r8 = unstash([..._42args]);
  var __name = destash33(name, ____r8);
  var __arglist = destash33(arglist, ____r8);
  var ____id1 = ____r8;
  var __body1 = cut(____id1, 0);
  var ____x13 = ["setfn"];
  ____x13.rest = "args";
  return ["define-expander", __name, ["fn", ____x13, ["%call", "define-setter", ["quote", __name], join(["fn", __arglist], __body1), "setfn", "args"]]];
}});
setenv("set", {_stash: true, macro: function (..._42args) {
  var __args = unstash([..._42args]);
  return join(["do"], map(function (__x19) {
    var ____id2 = __x19;
    var __lh = ____id2[0];
    var __rh = ____id2[1];
    return get_place(__lh, function (getter, setter) {
      return setter(__rh);
    });
  }, pair(__args)));
}});
setenv("at", {_stash: true, macro: function (l, i) {
  if (_G.target === "lua" && number63(i)) {
    i = i + 1;
  } else {
    if (_G.target === "lua") {
      i = ["+", i, 1];
    }
  }
  return ["get", l, i];
}});
setenv("wipe", {_stash: true, macro: function (place) {
  if (_G.target === "lua") {
    return ["set", place, "nil"];
  } else {
    return ["%delete", place];
  }
}});
setenv("list", {_stash: true, macro: function (..._42args) {
  var __body2 = unstash([..._42args]);
  var __x25 = unique("x");
  var __l = [];
  var __forms = [];
  var ____o = __body2;
  var __k = undefined;
  for (__k of pairs(____o)) {
    var __v1 = ____o[__k];
    if (number63(__k)) {
      __l[__k] = __v1;
    } else {
      add(__forms, ["set", ["get", __x25, ["quote", __k]], __v1]);
    }
  }
  if (some63(__forms)) {
    return join(["let", __x25, join(["%array"], __l)], __forms, [__x25]);
  } else {
    return join(["%array"], __l);
  }
}});
setenv("if", {_stash: true, macro: function (..._42args) {
  var __branches = unstash([..._42args]);
  return hd(expand_if(__branches));
}});
setenv("case", {_stash: true, macro: function (expr, ..._42args) {
  var ____r13 = unstash([..._42args]);
  var __expr = destash33(expr, ____r13);
  var ____id3 = ____r13;
  var __clauses = cut(____id3, 0);
  var __x35 = unique("x");
  var __eq = function (_) {
    return ["=", ["quote", _], __x35];
  };
  var __cl = function (__x38) {
    var ____id4 = __x38;
    var __a = ____id4[0];
    var __b = ____id4[1];
    if (nil63(__b)) {
      return [__a];
    } else {
      if (string63(__a) || number63(__a)) {
        return [__eq(__a), __b];
      } else {
        if (one63(__a)) {
          return [__eq(hd(__a)), __b];
        } else {
          if (_35(__a) > 1) {
            return [join(["or"], map(__eq, __a)), __b];
          }
        }
      }
    }
  };
  return ["let", __x35, __expr, join(["if"], apply(join, map(__cl, pair(__clauses))))];
}});
setenv("when", {_stash: true, macro: function (cond, ..._42args) {
  var ____r16 = unstash([..._42args]);
  var __cond = destash33(cond, ____r16);
  var ____id5 = ____r16;
  var __body3 = cut(____id5, 0);
  return ["if", __cond, join(["do"], __body3)];
}});
setenv("unless", {_stash: true, macro: function (cond, ..._42args) {
  var ____r17 = unstash([..._42args]);
  var __cond1 = destash33(cond, ____r17);
  var ____id6 = ____r17;
  var __body4 = cut(____id6, 0);
  return ["if", ["not", __cond1], join(["do"], __body4)];
}});
setenv("obj", {_stash: true, macro: function (..._42args) {
  var __body5 = unstash([..._42args]);
  return join(["%object"], mapo(function (x) {
    return x;
  }, __body5));
}});
setenv("let", {_stash: true, macro: function (bs, ..._42args) {
  var ____r19 = unstash([..._42args]);
  var __bs = destash33(bs, ____r19);
  var ____id7 = ____r19;
  var __body6 = cut(____id7, 0);
  if (atom63(__bs)) {
    return join(["let", [__bs, hd(__body6)]], tl(__body6));
  } else {
    if (none63(__bs)) {
      return join(["do"], __body6);
    } else {
      var ____id8 = __bs;
      var __lh1 = ____id8[0];
      var __rh1 = ____id8[1];
      var __bs2 = cut(____id8, 2);
      var ____id9 = bind(__lh1, __rh1);
      var __id10 = ____id9[0];
      var __val = ____id9[1];
      var __bs1 = cut(____id9, 2);
      var __id11 = unique(__id10);
      return ["do", ["%local", __id11, __val], ["let-symbol", [__id10, __id11], join(["let", join(__bs1, __bs2)], __body6)]];
    }
  }
}});
setenv("with", {_stash: true, macro: function (x, v, ..._42args) {
  var ____r20 = unstash([..._42args]);
  var __x65 = destash33(x, ____r20);
  var __v2 = destash33(v, ____r20);
  var ____id111 = ____r20;
  var __body7 = cut(____id111, 0);
  return join(["let", [__x65, __v2]], __body7, [__x65]);
}});
setenv("let-when", {_stash: true, macro: function (x, v, ..._42args) {
  var ____r21 = unstash([..._42args]);
  var __x70 = destash33(x, ____r21);
  var __v3 = destash33(v, ____r21);
  var ____id12 = ____r21;
  var __body8 = cut(____id12, 0);
  var __y = unique("y");
  return ["let", __y, __v3, ["when", ["yes", __y], join(["let", [__x70, __y]], __body8)]];
}});
setenv("define-macro", {_stash: true, macro: function (name, args, ..._42args) {
  var ____r22 = unstash([..._42args]);
  var __name1 = destash33(name, ____r22);
  var __args1 = destash33(args, ____r22);
  var ____id13 = ____r22;
  var __body9 = cut(____id13, 0);
  var ____x77 = ["setenv", ["quote", __name1]];
  ____x77.macro = join(["fn", __args1], __body9);
  return join(____x77, keys(__body9));
}});
setenv("define-special", {_stash: true, macro: function (name, args, ..._42args) {
  var ____r23 = unstash([..._42args]);
  var __name2 = destash33(name, ____r23);
  var __args2 = destash33(args, ____r23);
  var ____id14 = ____r23;
  var __body10 = cut(____id14, 0);
  var ____x81 = ["setenv", ["quote", __name2]];
  ____x81.special = join(["fn", __args2], __body10);
  return join(____x81, keys(__body10));
}});
setenv("define-symbol", {_stash: true, macro: function (name, expansion) {
  var ____x84 = ["setenv", ["quote", name]];
  ____x84.symbol = ["quote", expansion];
  return ____x84;
}});
setenv("define-reader", {_stash: true, macro: function (__x87, ..._42args) {
  var ____id15 = __x87;
  var __char = ____id15[0];
  var __s = ____id15[1];
  var ____r25 = unstash([..._42args]);
  var ____x87 = destash33(__x87, ____r25);
  var ____id16 = ____r25;
  var __body11 = cut(____id16, 0);
  return ["set", ["get", "read-table", __char], join(["fn", [__s]], __body11)];
}});
setenv("define", {_stash: true, macro: function (name, x, ..._42args) {
  var ____r26 = unstash([..._42args]);
  var __name3 = destash33(name, ____r26);
  var __x94 = destash33(x, ____r26);
  var ____id17 = ____r26;
  var __body12 = cut(____id17, 0);
  if (some63(__body12)) {
    return join(["%local-function", __name3], bind_function(__x94, __body12));
  } else {
    return ["%local", __name3, __x94];
  }
}});
setenv("define-global", {_stash: true, macro: function (name, x, ..._42args) {
  var ____r27 = unstash([..._42args]);
  var __name4 = destash33(name, ____r27);
  var __x98 = destash33(x, ____r27);
  var ____id18 = ____r27;
  var __body13 = cut(____id18, 0);
  if (some63(__body13)) {
    return join(["%global-function", __name4], bind_function(__x98, __body13));
  } else {
    if (global_id63(__name4)) {
      return ["set", __name4, __x98];
    } else {
      return ["set", ["get", "_G", ["quote", compile(__name4)]], __x98];
    }
  }
}});
setenv("with-frame", {_stash: true, macro: function (..._42args) {
  var __body14 = unstash([..._42args]);
  var __x105 = unique("x");
  return ["do", ["add", "environment*", ["obj"]], ["with", __x105, join(["do"], __body14), ["drop", "environment*"]]];
}});
setenv("with-bindings", {_stash: true, macro: function (__x112, ..._42args) {
  var ____id19 = __x112;
  var __names = ____id19[0];
  var ____r28 = unstash([..._42args]);
  var ____x112 = destash33(__x112, ____r28);
  var ____id20 = ____r28;
  var __body15 = cut(____id20, 0);
  var __x114 = unique("x");
  var ____x117 = ["setenv", __x114];
  ____x117.variable = true;
  return join(["with-frame", ["each", __x114, __names, ____x117]], __body15);
}});
setenv("let-macro", {_stash: true, macro: function (definitions, ..._42args) {
  var ____r29 = unstash([..._42args]);
  var __definitions = destash33(definitions, ____r29);
  var ____id21 = ____r29;
  var __body16 = cut(____id21, 0);
  add(_G.environment, {});
  var ____x120 = __definitions;
  var ____i1 = 0;
  while (____i1 < _35(____x120)) {
    var __m = ____x120[____i1];
    _eval(join(["define-macro"], __m));
    ____i1 = ____i1 + 1;
  }
  var ____x119 = join(["do"], macroexpand(__body16));
  drop(_G.environment);
  return ____x119;
}});
setenv("let-symbol", {_stash: true, macro: function (expansions, ..._42args) {
  var ____r30 = unstash([..._42args]);
  var __expansions = destash33(expansions, ____r30);
  var ____id22 = ____r30;
  var __body17 = cut(____id22, 0);
  add(_G.environment, {});
  var ____x125 = pair(__expansions);
  var ____i2 = 0;
  while (____i2 < _35(____x125)) {
    var ____id23 = ____x125[____i2];
    var __name5 = ____id23[0];
    var __exp = ____id23[1];
    _eval(["define-symbol", __name5, __exp]);
    ____i2 = ____i2 + 1;
  }
  var ____x124 = join(["do"], macroexpand(__body17));
  drop(_G.environment);
  return ____x124;
}});
setenv("let-unique", {_stash: true, macro: function (names, ..._42args) {
  var ____r31 = unstash([..._42args]);
  var __names1 = destash33(names, ____r31);
  var ____id24 = ____r31;
  var __body18 = cut(____id24, 0);
  var __bs11 = map(function (n) {
    return [n, ["unique", ["quote", n]]];
  }, __names1);
  return join(["let", apply(join, __bs11)], __body18);
}});
setenv("fn", {_stash: true, macro: function (args, ..._42args) {
  var ____r33 = unstash([..._42args]);
  var __args3 = destash33(args, ____r33);
  var ____id25 = ____r33;
  var __body19 = cut(____id25, 0);
  return join(["%function"], bind_function(__args3, __body19));
}});
setenv("apply", {_stash: true, macro: function (f, ..._42args) {
  var ____r34 = unstash([..._42args]);
  var __f = destash33(f, ____r34);
  var ____id26 = ____r34;
  var __args4 = cut(____id26, 0);
  if (_35(__args4) > 1) {
    return ["%call", "apply", __f, ["join", join(["list"], almost(__args4)), last(__args4)]];
  } else {
    return join(["%call", "apply", __f], __args4);
  }
}});
setenv("guard", {_stash: true, macro: function (expr) {
  if (_G.target === "js") {
    return [["fn", join(), ["%try", ["list", true, expr]]]];
  } else {
    var ____x151 = ["obj"];
    ____x151.stack = [["get", "debug", ["quote", "traceback"]]];
    ____x151.message = ["if", ["string?", "m"], ["clip", "m", ["+", ["or", ["search", "m", "\": \""], -2], 2]], ["nil?", "m"], "\"\"", ["str", "m"]];
    return ["list", ["xpcall", ["fn", join(), expr], ["fn", ["m"], ["if", ["obj?", "m"], "m", ____x151]]]];
  }
}});
setenv("each", {_stash: true, macro: function (x, t, ..._42args) {
  var ____r36 = unstash([..._42args]);
  var __x164 = destash33(x, ____r36);
  var __t = destash33(t, ____r36);
  var ____id27 = ____r36;
  var __body20 = cut(____id27, 0);
  var __o1 = unique("o");
  var __n1 = unique("n");
  var __i3 = unique("i");
  var __e = undefined;
  if (atom63(__x164)) {
    __e = [__i3, __x164];
  } else {
    var __e1 = undefined;
    if (_35(__x164) > 1) {
      __e1 = __x164;
    } else {
      __e1 = [__i3, hd(__x164)];
    }
    __e = __e1;
  }
  var ____id28 = __e;
  var __k1 = ____id28[0];
  var __v4 = ____id28[1];
  return ["let", [__o1, __t], ["for", [__k1], ["pairs", __o1], join(["let", [__v4, ["get", __o1, __k1]]], __body20)]];
}});
setenv("for", {_stash: true, macro: function (i, to, ..._42args) {
  var ____r37 = unstash([..._42args]);
  var __i4 = destash33(i, ____r37);
  var __to = destash33(to, ____r37);
  var ____id29 = ____r37;
  var __body21 = cut(____id29, 0);
  if (obj63(__i4)) {
    return ["let", apply(join, map(function (x) {
      return [x, "nil"];
    }, __i4)), ["%for", __to, join(["%names"], __i4), join(["do"], __body21)]];
  } else {
    return ["let", __i4, 0, join(["while", ["<", __i4, __to]], __body21, [["inc", __i4]])];
  }
}});
setenv("step", {_stash: true, macro: function (v, t, ..._42args) {
  var ____r39 = unstash([..._42args]);
  var __v5 = destash33(v, ____r39);
  var __t1 = destash33(t, ____r39);
  var ____id30 = ____r39;
  var __body22 = cut(____id30, 0);
  var __x187 = unique("x");
  var __i5 = unique("i");
  return ["let", [__x187, __t1], ["for", __i5, ["#", __x187], join(["let", [__v5, ["at", __x187, __i5]]], __body22)]];
}});
setenv("set-of", {_stash: true, macro: function (..._42args) {
  var __xs = unstash([..._42args]);
  var __l1 = [];
  var ____o2 = __xs;
  var ____i6 = undefined;
  for (____i6 of pairs(____o2)) {
    var __x196 = ____o2[____i6];
    __l1[__x196] = true;
  }
  return join(["obj"], __l1);
}});
setenv("language", {_stash: true, macro: function () {
  return ["quote", _G.target];
}});
setenv("target", {_stash: true, macro: function (..._42args) {
  var __clauses1 = unstash([..._42args]);
  return __clauses1[_G.target];
}});
setenv("join!", {_stash: true, macro: function (a, ..._42args) {
  var ____r41 = unstash([..._42args]);
  var __a1 = destash33(a, ____r41);
  var ____id31 = ____r41;
  var __bs21 = cut(____id31, 0);
  return ["set", __a1, join(["join", __a1], __bs21)];
}});
setenv("cat!", {_stash: true, macro: function (a, ..._42args) {
  var ____r42 = unstash([..._42args]);
  var __a2 = destash33(a, ____r42);
  var ____id32 = ____r42;
  var __bs3 = cut(____id32, 0);
  return ["set", __a2, join(["cat", __a2], __bs3)];
}});
setenv("inc", {_stash: true, macro: function (n, by) {
  var __e2 = undefined;
  if (nil63(by)) {
    __e2 = 1;
  } else {
    __e2 = by;
  }
  return ["set", n, ["+", n, __e2]];
}});
setenv("dec", {_stash: true, macro: function (n, by) {
  var __e3 = undefined;
  if (nil63(by)) {
    __e3 = 1;
  } else {
    __e3 = by;
  }
  return ["set", n, ["-", n, __e3]];
}});
setenv("with-indent", {_stash: true, macro: function (form) {
  var __x210 = unique("x");
  return ["do", ["inc", "indent-level*"], ["with", __x210, form, ["dec", "indent-level*"]]];
}});
setenv("undefined?", {_stash: true, macro: function (x) {
  var ____x215 = ["target"];
  ____x215.lua = ["=", x, "nil"];
  ____x215.js = ["=", ["typeof", x], "\"undefined\""];
  return ____x215;
}});
setenv("export", {_stash: true, macro: function (..._42args) {
  var __names2 = unstash([..._42args]);
  var ____x227 = ["target"];
  ____x227.lua = ["return", "exports"];
  return join(["with", "exports", ["if", ["undefined?", "exports"], ["obj"], "exports"]], map(function (k) {
    return ["set", ["exports", "." + k], k];
  }, __names2), [____x227]);
}});
setenv("when-compiling", {_stash: true, macro: function (..._42args) {
  var __body23 = unstash([..._42args]);
  return _eval(join(["do"], __body23));
}});
setenv("during-compilation", {_stash: true, macro: function (..._42args) {
  var __body24 = unstash([..._42args]);
  var __form1 = join(["do"], __body24, [["do"]]);
  _eval(__form1);
  return __form1;
}});
setenv("hd", {_stash: true, expander: function (setfn, ..._42args) {
  var ____r50 = unstash([..._42args]);
  var __setfn1 = destash33(setfn, ____r50);
  var ____id34 = ____r50;
  var __args6 = cut(____id34, 0);
  return define_setter("hd", function (v, l) {
    return ["set", ["at", l, 0], v];
  }, __setfn1, __args6);
}});
var reader = require("./reader");
var compiler = require("./compiler");
var system = require("./system");
var eval_print = function (form) {
  var ____id = (function () {
    try {
      return [true, compiler.eval(["results", form])];
    }
    catch (__e2) {
      return [false, __e2];
    }
  })();
  var __ok = ____id[0];
  var __v = ____id[1];
  if (! __ok) {
    return print(__v.stack);
  } else {
    var ____x2 = __v;
    var ____i = 0;
    while (____i < _35(____x2)) {
      var __x3 = ____x2[____i];
      if (is63(__x3) || _35(__v) > 1) {
        print(str(__x3));
      }
      ____i = ____i + 1;
    }
  }
};
var rep = function (s) {
  return eval_print(reader.readString(s));
};
var repl = function () {
  var __buf = "";
  var rep1 = function (s) {
    __buf = __buf + s;
    var __more = [];
    var __form = reader.readString(__buf, __more);
    if (!( __form === __more)) {
      eval_print(__form);
      __buf = "";
      return system.write("> ");
    }
  };
  system.write("> ");
  if (process) {
    process.stdin.removeAllListeners();
    process.stdin.setEncoding("utf8");
    return process.stdin.on("data", rep1);
  }
};
read_file = function (path) {
  return system.readFile(path);
};
write_file = function (path, data) {
  return system.writeFile(path, data);
};
read_from_file = function (path) {
  var __s = reader.stream(system.readFile(path));
  var __body = reader.readAll(__s);
  return join(["do"], __body);
};
expand_file = function (path) {
  return compiler.expand(read_from_file(path));
};
compile_file = function (path) {
  var __form1 = expand_file(path);
  return compiler.compile(__form1, {_stash: true, stmt: true});
};
load = function (path) {
  var __previous = _G.target;
  _G.target = "js";
  var __code = compile_file(path);
  _G.target = __previous;
  return compiler.run(__code);
};
script_file63 = function (path) {
  return string63(path) && !( "-" === char(path, 0) || ".js" === clip(path, _35(path) - 3) || ".lua" === clip(path, _35(path) - 4));
};
run_file = function (path) {
  if (script_file63(path)) {
    return load(path);
  } else {
    return compiler.run(read_file(path));
  }
};
read_from_string = function (str, start, end) {
  var __s1 = reader.stream(str);
  __s1.pos = either(start, __s1.pos);
  __s1.len = either(end, __s1.len);
  var __form2 = reader.read(__s1);
  if (nil63(__form2)) {
    return error("End of string during parsing");
  } else {
    var ____x5 = [__form2];
    ____x5.rest = __s1.pos;
    return ____x5;
  }
};
readable_string63 = function (str) {
  var __id4 = string63(str);
  var __e = undefined;
  if (__id4) {
    var ____id1 = (function () {
      try {
        return [true, read_from_string(str)];
      }
      catch (__e3) {
        return [false, __e3];
      }
    })();
    var __ok1 = ____id1[0];
    var __v1 = ____id1[1];
    __e = __ok1 && hd(__v1) === str;
  } else {
    __e = __id4;
  }
  return __e;
};
pp_to_string = function (x, stack) {
  if (nil63(x)) {
    return "nil";
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
          if (boolean63(x)) {
            if (x) {
              return "true";
            } else {
              return "false";
            }
          } else {
            if (string63(x)) {
              if (readable_string63(x)) {
                return x;
              } else {
                return escape(x);
              }
            } else {
              if (function63(x)) {
                return "function";
              } else {
                if (atom63(x)) {
                  return tostring(x);
                } else {
                  if (stack && in63(x, stack)) {
                    return "circular";
                  } else {
                    if (false) {
                      return escape(tostring(x));
                    } else {
                      var __s2 = "(";
                      var __sp = "";
                      var __xs = [];
                      var __ks = [];
                      var __l = stack || [];
                      add(__l, x);
                      var ____o = x;
                      var __k = undefined;
                      for (__k of pairs(____o)) {
                        var __v2 = ____o[__k];
                        if (number63(__k)) {
                          __xs[__k] = pp_to_string(__v2, __l);
                        } else {
                          add(__ks, __k + ":");
                          add(__ks, pp_to_string(__v2, __l));
                        }
                      }
                      drop(__l);
                      var ____o1 = join(__xs, __ks);
                      var ____i2 = undefined;
                      for (____i2 of pairs(____o1)) {
                        var __v3 = ____o1[____i2];
                        __s2 = __s2 + __sp + __v3;
                        __sp = " ";
                      }
                      return __s2 + ")";
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
var usage = function () {
  return "\nUsage:\n  lumen <file> [<args>...]\n  lumen [options] [<object-files>...]\n\n  <file>          Program read from script file\n  <object-files>  Loaded before compiling <input>\n\nOptions:\n  -c <input>...   Compile input files\n  -o <output>     Write compiler output to <output>\n  -t <target>     Set target language (default: lua)\n  -e <expr>...    Expressions to evaluate\n";
};
var main = function (argv) {
  var __arg = hd(argv);
  if (script_file63(__arg)) {
    set_argv(tl(argv));
    return load(__arg);
  }
  var __args = parse_arguments({c: "compile", o: "output", t: "target", e: "eval", h: "help", r: "repl"}, argv);
  if (script_file63(hd(__args))) {
    return load(hd(__args));
  } else {
    if (__args.help) {
      return print(usage());
    } else {
      var __pre = keep(string63, __args);
      var __cmds = keep(obj63, __args);
      var __input = "";
      var __enter_repl = true;
      var ____x7 = __pre;
      var ____i3 = 0;
      while (____i3 < _35(____x7)) {
        var __file = ____x7[____i3];
        run_file(__file);
        ____i3 = ____i3 + 1;
      }
      var ____x8 = __cmds;
      var ____i4 = 0;
      while (____i4 < _35(____x8)) {
        var ____id2 = ____x8[____i4];
        var __a = ____id2[0];
        var __val = ____id2[1];
        if (__a === "target") {
          _G.target = hd(__val);
          break;
        }
        ____i4 = ____i4 + 1;
      }
      var ____x9 = __cmds;
      var ____i5 = 0;
      while (____i5 < _35(____x9)) {
        var ____id3 = ____x9[____i5];
        var __a1 = ____id3[0];
        var __val1 = ____id3[1];
        if (__a1 === "help") {
          print(usage());
        } else {
          if (__a1 === "repl") {
            __enter_repl = true;
          } else {
            if (boolean63(__val1) || none63(__val1)) {
              print("missing argument for " + __a1);
            } else {
              if (__a1 === "compile") {
                var ____x10 = __val1;
                var ____i6 = 0;
                while (____i6 < _35(____x10)) {
                  var __x11 = ____x10[____i6];
                  __input = __input + compile_file(__x11);
                  ____i6 = ____i6 + 1;
                }
                __enter_repl = false;
              } else {
                if (__a1 === "output") {
                  write_file(hd(__val1), __input);
                  __input = "";
                } else {
                  if (__a1 === "target") {
                    _G.target = hd(__val1);
                  } else {
                    if (__a1 === "eval") {
                      var ____x12 = __val1;
                      var ____i7 = 0;
                      while (____i7 < _35(____x12)) {
                        var __x13 = ____x12[____i7];
                        rep(__x13);
                        ____i7 = ____i7 + 1;
                      }
                      __enter_repl = false;
                    }
                  }
                }
              }
            }
          }
        }
        ____i5 = ____i5 + 1;
      }
      if (some63(__input)) {
        print(__input);
      }
      if (__enter_repl || __args.repl) {
        return repl();
      }
    }
  }
};
var __e1 = undefined;
if (typeof(exports) === "undefined") {
  __e1 = {};
} else {
  __e1 = exports;
}
var __exports = __e1;
__exports.reader = reader;
__exports.compiler = compiler;
__exports.system = system;
__exports.main = main;
__exports;
