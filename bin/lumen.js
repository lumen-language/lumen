_G.environment = [{}];
_G.target = "js";
var __v = undefined;
values = function(..._42args) {
  __v = [..._42args];
  return __v[0];
};
results = function(x, ..._42args) {
  var r = __v || [x, ..._42args];
  __v = undefined;
  return r;
};
select = function(n, ..._42args) {
  if (n === "#") {
    return values(results(..._42args).length);
  } else {
    return values(...cut(results(..._42args), n - 1));
  }
};
pairs = function(l) {
  return Object.keys(l).map(function(k) {
    if (numeric63(k)) {
      return parseInt(k);
    } else {
      return k;
    }
  });
};
ipairs = function(l) {
  return pairs(l).filter(number63);
};
pcall = function(f, ..._42args) {
  var __id = (function() {
    try {
      return [true, results(f(..._42args))];
    }
    catch (__e13) {
      return [false, __e13];
    }
  })();
  var ok = __id[0];
  var v = __id[1];
  return values(ok, ...v);
};
nil63 = function(x) {
  return x === undefined || x === null;
};
is63 = function(x) {
  return ! nil63(x);
};
no = function(x) {
  return nil63(x) || x === false;
};
yes = function(x) {
  return ! no(x);
};
either = function(x, y) {
  if (is63(x)) {
    return x;
  } else {
    return y;
  }
};
has63 = function(l, k) {
  return l.hasOwnProperty(k);
};
_35 = function(x) {
  return x.length || 0;
};
none63 = function(x) {
  return _35(x) === 0;
};
some63 = function(x) {
  return _35(x) > 0;
};
one63 = function(x) {
  return _35(x) === 1;
};
two63 = function(x) {
  return _35(x) === 2;
};
hd = function(l) {
  return l[0];
};
type = function(x) {
  return typeof(x);
};
string63 = function(x) {
  return type(x) === "string";
};
number63 = function(x) {
  return type(x) === "number";
};
boolean63 = function(x) {
  return type(x) === "boolean";
};
function63 = function(x) {
  return type(x) === "function";
};
obj63 = function(x) {
  return is63(x) && type(x) === "object";
};
atom63 = function(x) {
  return nil63(x) || string63(x) || number63(x) || boolean63(x);
};
hd63 = function(l, x) {
  var __id2 = obj63(l);
  var __e2 = undefined;
  if (__id2) {
    var __e3 = undefined;
    if (function63(x)) {
      __e3 = x(hd(l));
    } else {
      var __e4 = undefined;
      if (nil63(x)) {
        __e4 = hd(l);
      } else {
        __e4 = hd(l) === x;
      }
      __e3 = __e4;
    }
    __e2 = __e3;
  } else {
    __e2 = __id2;
  }
  return __e2;
};
_G.nan = 0 / 0;
_G.inf = 1 / 0;
_G._inf = - inf;
nan63 = function(n) {
  return !( n === n);
};
inf63 = function(n) {
  return n === inf || n === _inf;
};
clip = function(s, from, upto) {
  return s.substring(from, upto);
};
natural63 = function(i) {
  return number63(i) && i > 0 && i % 1 === 0;
};
index63 = function(i) {
  return number63(i);
};
iterate = function(o, f, l, r) {
  var from = inf;
  var upto = _inf;
  var ____o = l;
  var __k = undefined;
  for (__k of pairs(____o)) {
    var __v1 = ____o[__k];
    if (index63(__k)) {
      if (__k < from) {
        from = __k;
      }
      if (__k > upto) {
        upto = __k;
      }
    } else {
      r = f(r, __v1, __k, undefined);
    }
  }
  upto = upto + 1;
  var i = from;
  while (i < upto) {
    var v = l[i];
    r = f(r, v, undefined, i);
    i = i + 1;
  }
  var __o1 = o || {};
  __o1.result = r;
  __o1.from = from;
  __o1.upto = upto;
  return __o1;
};
var __o2 = {};
reduce = function(f, l, r) {
  return iterate(__o2, f, l, r).result;
};
cut = function(x, from, upto) {
  var __l = [];
  var j = 0;
  var __e5 = undefined;
  if (nil63(from) || from < 0) {
    __e5 = 0;
  } else {
    __e5 = from;
  }
  var i = __e5;
  var n = _35(x);
  var __e6 = undefined;
  if (nil63(upto) || upto > n) {
    __e6 = n;
  } else {
    __e6 = upto;
  }
  var upto = __e6;
  while (i < upto) {
    __l[j] = x[i];
    i = i + 1;
    j = j + 1;
  }
  var ____o3 = x;
  var __k1 = undefined;
  for (__k1 of pairs(____o3)) {
    var __v2 = ____o3[__k1];
    if (! number63(__k1)) {
      __l[__k1] = __v2;
    }
  }
  return __l;
};
props = function(x) {
  var __t = [];
  var ____o4 = x;
  var __k2 = undefined;
  for (__k2 of pairs(____o4)) {
    var __v3 = ____o4[__k2];
    if (! number63(__k2)) {
      __t[__k2] = __v3;
    }
  }
  return __t;
};
edge = function(x) {
  return _35(x) - 1;
};
inner = function(x) {
  return clip(x, 1, edge(x));
};
tl = function(l) {
  return cut(l, 1);
};
char = function(s, n) {
  return s.charAt(n);
};
code = function(s, n) {
  return s.charCodeAt(n);
};
from_code = function(n) {
  return String.fromCharCode(n);
};
string_literal63 = function(x) {
  return string63(x) && char(x, 0) === "\"";
};
id_literal63 = function(x) {
  return string63(x) && char(x, 0) === "|";
};
add = function(l, x) {
  l.push(x);
  return undefined;
};
drop = function(l) {
  return l.pop();
};
last = function(l) {
  return l[edge(l)];
};
almost = function(l) {
  return cut(l, 0, edge(l));
};
reverse = function(l) {
  var __l1 = props(l);
  var __i3 = edge(l);
  while (__i3 >= 0) {
    add(__l1, l[__i3]);
    __i3 = __i3 - 1;
  }
  return __l1;
};
join = function(..._42args) {
  var __ls = unstash([..._42args]);
  var __r50 = [];
  var ____x5 = __ls;
  var ____i4 = 0;
  while (____i4 < _35(____x5)) {
    var __l11 = ____x5[____i4];
    if (__l11) {
      var __n3 = _35(__r50);
      var ____o5 = __l11;
      var __k3 = undefined;
      for (__k3 of pairs(____o5)) {
        var __v4 = ____o5[__k3];
        if (number63(__k3)) {
          __k3 = __k3 + __n3;
        }
        __r50[__k3] = __v4;
      }
    }
    ____i4 = ____i4 + 1;
  }
  return __r50;
};
testify = function(x, test) {
  if (function63(x)) {
    return x;
  } else {
    if (test) {
      return function(y) {
        return test(y, x);
      };
    } else {
      return function(y) {
        return x === y;
      };
    }
  }
};
find = function(x, t) {
  var __f = testify(x);
  var ____o6 = t;
  var ____i6 = undefined;
  for (____i6 of pairs(____o6)) {
    var __x6 = ____o6[____i6];
    var __y = __f(__x6);
    if (__y) {
      return __y;
    }
  }
};
first = function(x, l, pos) {
  var __f1 = testify(x);
  var __i7 = either(pos, 0);
  var __n6 = -1;
  var ____o7 = l;
  var __k4 = undefined;
  for (__k4 of pairs(____o7)) {
    var __v5 = ____o7[__k4];
    if (number63(__k4)) {
      __n6 = max(__n6, __k4);
    }
  }
  __n6 = __n6 + 1;
  while (__i7 < __n6) {
    var __v6 = l[__i7];
    var ____y1 = __f1(__v6);
    if (yes(____y1)) {
      var __y2 = ____y1;
      return __i7;
    }
    __i7 = __i7 + 1;
  }
};
in63 = function(x, t) {
  return find(testify(x), t);
};
pair = function(l) {
  var __l12 = [];
  var __i9 = 0;
  while (__i9 < _35(l)) {
    add(__l12, [l[__i9], l[__i9 + 1]]);
    __i9 = __i9 + 1;
    __i9 = __i9 + 1;
  }
  return __l12;
};
sort = function(l, f) {
  var __e7 = undefined;
  if (f) {
    __e7 = function(a, b) {
      if (f(a, b)) {
        return -1;
      } else {
        return 1;
      }
    };
  }
  return l.sort(__e7);
};
map = function(f, x) {
  var __t1 = [];
  var ____x8 = x;
  var ____i10 = 0;
  while (____i10 < _35(____x8)) {
    var __v7 = ____x8[____i10];
    var __y3 = f(__v7);
    if (is63(__y3)) {
      add(__t1, __y3);
    }
    ____i10 = ____i10 + 1;
  }
  var ____o8 = x;
  var __k5 = undefined;
  for (__k5 of pairs(____o8)) {
    var __v8 = ____o8[__k5];
    if (! number63(__k5)) {
      var __y4 = f(__v8);
      if (is63(__y4)) {
        __t1[__k5] = __y4;
      }
    }
  }
  return __t1;
};
keep = function(v, x) {
  var __f2 = testify(v);
  return map(function(v) {
    if (yes(__f2(v))) {
      return v;
    }
  }, x);
};
keys63 = function(t) {
  var ____o9 = t;
  var __k6 = undefined;
  for (__k6 of pairs(____o9)) {
    var __v9 = ____o9[__k6];
    if (! number63(__k6)) {
      return true;
    }
  }
  return false;
};
empty63 = function(t) {
  var ____o10 = t;
  var ____i13 = undefined;
  for (____i13 of pairs(____o10)) {
    var __x9 = ____o10[____i13];
    return false;
  }
  return true;
};
stash = function(args) {
  if (keys63(args)) {
    var __p = [];
    var ____o11 = args;
    var __k7 = undefined;
    for (__k7 of pairs(____o11)) {
      var __v10 = ____o11[__k7];
      if (! number63(__k7)) {
        __p[__k7] = __v10;
      }
    }
    __p._stash = true;
    add(args, __p);
  }
  return args;
};
unstash = function(args) {
  if (none63(args)) {
    return [];
  } else {
    var __l2 = last(args);
    if (obj63(__l2) && __l2._stash) {
      var __args1 = almost(args);
      var ____o12 = __l2;
      var __k8 = undefined;
      for (__k8 of pairs(____o12)) {
        var __v11 = ____o12[__k8];
        if (!( __k8 === "_stash")) {
          __args1[__k8] = __v11;
        }
      }
      return __args1;
    } else {
      return args;
    }
  }
};
destash33 = function(l, args1) {
  if (obj63(l) && l._stash) {
    var ____o13 = l;
    var __k9 = undefined;
    for (__k9 of pairs(____o13)) {
      var __v12 = ____o13[__k9];
      if (!( __k9 === "_stash")) {
        args1[__k9] = __v12;
      }
    }
  } else {
    return l;
  }
};
search = function(s, pattern, start) {
  var __i17 = s.indexOf(pattern, start);
  if (__i17 >= 0) {
    return __i17;
  }
};
split = function(s, sep) {
  if (s === "" || sep === "") {
    return [];
  } else {
    var __l3 = [];
    var __n14 = _35(sep);
    while (true) {
      var __i18 = search(s, sep);
      if (nil63(__i18)) {
        break;
      } else {
        add(__l3, clip(s, 0, __i18));
        s = clip(s, __i18 + __n14);
      }
    }
    add(__l3, s);
    return __l3;
  }
};
cat = function(s, ..._42args) {
  return reduce(function(a, b) {
    return a + b;
  }, [..._42args], s || "");
};
_43 = function(n, ..._42args) {
  return reduce(function(a, b) {
    return a + b;
  }, [..._42args], n || 0);
};
_45 = function(n, ..._42args) {
  return reduce(function(a, b) {
    return a - b;
  }, [..._42args], n || 0);
};
_42 = function(n, ..._42args) {
  return reduce(function(a, b) {
    return a * b;
  }, [..._42args], either(n, 1));
};
_47 = function(n, ..._42args) {
  return reduce(function(a, b) {
    return a / b;
  }, [..._42args], either(n, 1));
};
_37 = function(n, ..._42args) {
  return reduce(function(a, b) {
    return a % b;
  }, [..._42args], either(n, 1));
};
var pairwise = function(f, xs) {
  var __i19 = 0;
  while (__i19 < edge(xs)) {
    var __a = xs[__i19];
    var __b = xs[__i19 + 1];
    if (! f(__a, __b)) {
      return false;
    }
    __i19 = __i19 + 1;
  }
  return true;
};
_60 = function(..._42args) {
  var __xs = unstash([..._42args]);
  return pairwise(function(a, b) {
    return a < b;
  }, __xs);
};
_62 = function(..._42args) {
  var __xs1 = unstash([..._42args]);
  return pairwise(function(a, b) {
    return a > b;
  }, __xs1);
};
_61 = function(..._42args) {
  var __xs2 = unstash([..._42args]);
  return pairwise(function(a, b) {
    return a === b;
  }, __xs2);
};
_6061 = function(..._42args) {
  var __xs3 = unstash([..._42args]);
  return pairwise(function(a, b) {
    return a <= b;
  }, __xs3);
};
_6261 = function(..._42args) {
  var __xs4 = unstash([..._42args]);
  return pairwise(function(a, b) {
    return a >= b;
  }, __xs4);
};
number = function(s) {
  var __n15 = parseFloat(s);
  if (! isNaN(__n15)) {
    return __n15;
  }
};
number_code63 = function(n) {
  return n > 47 && n < 58;
};
numeric63 = function(s) {
  var __n16 = _35(s);
  var __i20 = 0;
  while (__i20 < __n16) {
    if (! number_code63(code(s, __i20))) {
      return false;
    }
    __i20 = __i20 + 1;
  }
  return some63(s);
};
lowercase_code63 = function(n) {
  return n > 96 && n < 123;
};
camel_case = function(str) {
  var __s = "";
  var __n17 = _35(str);
  var __i21 = 0;
  while (__i21 < __n17) {
    var __c = code(str, __i21);
    if (__c === 45 && lowercase_code63(code(str, __i21 - 1) || 0) && lowercase_code63(code(str, __i21 + 1) || 0)) {
      __i21 = __i21 + 1;
      __c = code(str, __i21) - 32;
    }
    __s = __s + from_code(__c);
    __i21 = __i21 + 1;
  }
  return __s;
};
tostring = function(x) {
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
escape = function(s) {
  var __s1 = "\"";
  var __i22 = 0;
  while (__i22 < _35(s)) {
    var __c1 = char(s, __i22);
    var __e8 = undefined;
    if (__c1 === "\n") {
      __e8 = "\\n";
    } else {
      var __e9 = undefined;
      if (__c1 === "\r") {
        __e9 = "\\r";
      } else {
        var __e10 = undefined;
        if (__c1 === "\"") {
          __e10 = "\\\"";
        } else {
          var __e11 = undefined;
          if (__c1 === "\\") {
            __e11 = "\\\\";
          } else {
            __e11 = __c1;
          }
          __e10 = __e11;
        }
        __e9 = __e10;
      }
      __e8 = __e9;
    }
    var __c11 = __e8;
    __s1 = __s1 + __c11;
    __i22 = __i22 + 1;
  }
  return __s1 + "\"";
};
str = function(x, stack) {
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
              var __v13 = ____o14[__k10];
              if (number63(__k10)) {
                __xs5[__k10] = str(__v13, __l4);
              } else {
                add(__ks, __k10 + ":");
                add(__ks, str(__v13, __l4));
              }
            }
            drop(__l4);
            var ____o15 = join(__xs5, __ks);
            var ____i24 = undefined;
            for (____i24 of pairs(____o15)) {
              var __v14 = ____o15[____i24];
              __s11 = __s11 + __sp + __v14;
              __sp = " ";
            }
            return __s11 + ")";
          }
        }
      }
    }
  }
};
apply = function(f, args) {
  return f(...stash(args));
};
call = function(f, ..._42args) {
  return f(..._42args);
};
setenv = function(k, ..._42args) {
  var ____r98 = unstash([..._42args]);
  var __k11 = destash33(k, ____r98);
  var ____id1 = ____r98;
  var __keys = cut(____id1, 0);
  if (string63(__k11)) {
    var __e12 = undefined;
    if (__keys.toplevel) {
      __e12 = hd(_G.environment);
    } else {
      __e12 = last(_G.environment);
    }
    var __frame = __e12;
    var __entry = __frame[__k11] || {};
    var ____o16 = __keys;
    var __k12 = undefined;
    for (__k12 of pairs(____o16)) {
      var __v15 = ____o16[__k12];
      __entry[__k12] = __v15;
    }
    __frame[__k11] = __entry;
    return __frame[__k11];
  }
};
print = function(x) {
  return console.log(x);
};
error = function(x) {
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
setenv("%brackets", {_stash: true, macro: function(..._42args) {
  var __body = unstash([..._42args]);
  return join(["%array"], __body);
}});
setenv("%braces", {_stash: true, macro: function(..._42args) {
  var __body1 = unstash([..._42args]);
  return join(["%object"], __body1);
}});
setenv("quote", {_stash: true, macro: function(form) {
  return quoted(form);
}});
setenv("quasiquote", {_stash: true, macro: function(form) {
  return quasiexpand(form, 1);
}});
setenv("do", {_stash: true, macro: function(..._42args) {
  var __body2 = unstash([..._42args]);
  return join(["%do"], __body2);
}});
setenv("while", {_stash: true, macro: function(test, ..._42args) {
  var ____r2 = unstash([..._42args]);
  var __test = destash33(test, ____r2);
  var ____id = ____r2;
  var __body3 = cut(____id, 0);
  return join(["%while", __test, join(["%do"], __body3)], props(__body3));
}});
get_place = function(place, setfn) {
  var __place = macroexpand(place);
  if (atom63(__place) || hd(__place) === "get" && nil63(getenv("get", "expander")) || accessor_literal63(hd(tl(__place)))) {
    return setfn(__place, function(v) {
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
setenv("let-place", {_stash: true, macro: function(vars, place, ..._42args) {
  var ____r5 = unstash([..._42args]);
  var __vars = destash33(vars, ____r5);
  var __place1 = destash33(place, ____r5);
  var ____id1 = ____r5;
  var __body4 = cut(____id1, 0);
  return ["get-place", __place1, join(["fn", __vars], __body4)];
}});
setenv("define-expander", {_stash: true, macro: function(name, handler) {
  var ____x14 = ["setenv", ["quote", name]];
  ____x14.expander = handler;
  var __form = ____x14;
  _eval(__form);
  return __form;
}});
define_setter = function(name, setter, setfn, args, vars) {
  if (none63(args)) {
    var __vars1 = reverse(vars || []);
    return setfn(join([name], __vars1), function(v) {
      return apply(setter, join([v], __vars1));
    });
  } else {
    var __v = hd(args);
    return define_setter(name, setter, setfn, tl(args), join([__v], vars));
  }
};
setenv("define-setter", {_stash: true, macro: function(name, arglist, ..._42args) {
  var ____r9 = unstash([..._42args]);
  var __name = destash33(name, ____r9);
  var __arglist = destash33(arglist, ____r9);
  var ____id2 = ____r9;
  var __body5 = cut(____id2, 0);
  var ____x22 = ["setfn"];
  ____x22.rest = "args";
  return ["define-expander", __name, ["fn", ____x22, ["%call", "define-setter", ["quote", __name], join(["fn", __arglist], __body5), "setfn", "args"]]];
}});
setenv("set", {_stash: true, macro: function(..._42args) {
  var __args = unstash([..._42args]);
  return join(["%do"], map(function(__x28) {
    var ____id3 = __x28;
    var __lh = ____id3[0];
    var __rh = ____id3[1];
    return get_place(__lh, function(getter, setter) {
      return setter(__rh);
    });
  }, pair(__args)));
}});
setenv("at", {_stash: true, macro: function(l, i) {
  if (_G.target === "lua" && number63(i)) {
    i = i + 1;
  } else {
    if (_G.target === "lua") {
      i = ["+", i, 1];
    }
  }
  return ["get", l, i];
}});
setenv("wipe", {_stash: true, macro: function(place) {
  if (_G.target === "lua") {
    return ["set", place, "nil"];
  } else {
    return ["%delete", place];
  }
}});
setenv("list", {_stash: true, macro: function(..._42args) {
  var __body6 = unstash([..._42args]);
  var __x34 = unique("x");
  var __l = [];
  var __forms = [];
  var ____o = __body6;
  var __k = undefined;
  for (__k of pairs(____o)) {
    var __v1 = ____o[__k];
    if (number63(__k)) {
      __l[__k] = __v1;
    } else {
      add(__forms, ["set", ["get", __x34, ["quote", __k]], __v1]);
    }
  }
  if (some63(__forms)) {
    return join(["let", __x34, join(["%array"], __l)], __forms, [__x34]);
  } else {
    return join(["%array"], __l);
  }
}});
setenv("if", {_stash: true, macro: function(..._42args) {
  var __branches = unstash([..._42args]);
  return hd(expand_if(__branches));
}});
setenv("case", {_stash: true, macro: function(expr, ..._42args) {
  var ____r14 = unstash([..._42args]);
  var __expr = destash33(expr, ____r14);
  var ____id4 = ____r14;
  var __clauses = cut(____id4, 0);
  var __x44 = unique("x");
  var __eq = function(_) {
    return ["=", ["quote", _], __x44];
  };
  var __cl = function(__x47) {
    var ____id5 = __x47;
    var __a = ____id5[0];
    var __b = ____id5[1];
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
  return ["let", __x44, __expr, join(["if"], apply(join, map(__cl, pair(__clauses))))];
}});
setenv("when", {_stash: true, macro: function(cond, ..._42args) {
  var ____r17 = unstash([..._42args]);
  var __cond = destash33(cond, ____r17);
  var ____id6 = ____r17;
  var __body7 = cut(____id6, 0);
  return ["if", __cond, join(["%do"], __body7)];
}});
setenv("unless", {_stash: true, macro: function(cond, ..._42args) {
  var ____r18 = unstash([..._42args]);
  var __cond1 = destash33(cond, ____r18);
  var ____id7 = ____r18;
  var __body8 = cut(____id7, 0);
  return ["if", ["not", __cond1], join(["%do"], __body8)];
}});
setenv("obj", {_stash: true, macro: function(..._42args) {
  var __body9 = unstash([..._42args]);
  return join(["%object"], mapo(function(x) {
    return x;
  }, __body9));
}});
setenv("var", {_stash: true, macro: function(bs, ..._42args) {
  var ____r20 = unstash([..._42args]);
  var __bs = destash33(bs, ____r20);
  var ____id8 = ____r20;
  var __body10 = cut(____id8, 0);
  if (atom63(__bs)) {
    return ["var", join([__bs], __body10)];
  } else {
    if (none63(__bs)) {
      return ["%do"];
    } else {
      if (brackets63(__bs)) {
        return join(["var", tl(__bs)], __body10);
      } else {
        var ____id9 = __bs;
        var __lh1 = ____id9[0];
        var __rh1 = ____id9[1];
        var __bs2 = cut(____id9, 2);
        var ____id10 = bind(__lh1, __rh1);
        var __id11 = ____id10[0];
        var __val = ____id10[1];
        var __bs1 = cut(____id10, 2);
        return ["%do", ["%local", __id11, __val], join(["var", join(__bs1, __bs2)], __body10)];
      }
    }
  }
}});
setenv("let", {_stash: true, macro: function(bs, ..._42args) {
  var ____r21 = unstash([..._42args]);
  var __bs11 = destash33(bs, ____r21);
  var ____id12 = ____r21;
  var __body11 = cut(____id12, 0);
  if (atom63(__bs11)) {
    return join(["let", [__bs11, hd(__body11)]], tl(__body11));
  } else {
    if (none63(__bs11)) {
      return join(["%do"], __body11);
    } else {
      if (brackets63(__bs11)) {
        var __e = undefined;
        if (empty63(__body11)) {
          __e = "var";
        } else {
          __e = "let";
        }
        return join([__e, tl(__bs11)], __body11);
      } else {
        var ____id13 = __bs11;
        var __lh2 = ____id13[0];
        var __rh2 = ____id13[1];
        var __bs21 = cut(____id13, 2);
        var ____id14 = bind(__lh2, __rh2);
        var __id15 = ____id14[0];
        var __val1 = ____id14[1];
        var __bs12 = cut(____id14, 2);
        var __id111 = unique(__id15);
        return ["%do", ["%local", __id111, __val1], ["let-symbol", [__id15, __id111], join(["let", join(__bs12, __bs21)], __body11)]];
      }
    }
  }
}});
setenv("with", {_stash: true, macro: function(x, v, ..._42args) {
  var ____r22 = unstash([..._42args]);
  var __x83 = destash33(x, ____r22);
  var __v2 = destash33(v, ____r22);
  var ____id16 = ____r22;
  var __body12 = cut(____id16, 0);
  return join(["let", [__x83, __v2]], __body12, [__x83]);
}});
setenv("let-when", {_stash: true, macro: function(x, v, ..._42args) {
  var ____r23 = unstash([..._42args]);
  var __x88 = destash33(x, ____r23);
  var __v3 = destash33(v, ____r23);
  var ____id17 = ____r23;
  var __body13 = cut(____id17, 0);
  var __y = unique("y");
  return ["let", __y, __v3, ["when", ["yes", __y], join(["let", [__x88, __y]], __body13)]];
}});
setenv("define-transformer", {_stash: true, macro: function(name, form, ..._42args) {
  var ____r24 = unstash([..._42args]);
  var __name1 = destash33(name, ____r24);
  var __form1 = destash33(form, ____r24);
  var ____id18 = ____r24;
  var __body14 = cut(____id18, 0);
  var ____x95 = ["setenv", ["quote", __name1]];
  ____x95.transformer = join(["fn", [__form1]], __body14);
  return join(____x95, props(__body14));
}});
setenv("define-macro", {_stash: true, macro: function(name, args, ..._42args) {
  var ____r25 = unstash([..._42args]);
  var __name2 = destash33(name, ____r25);
  var __args1 = destash33(args, ____r25);
  var ____id19 = ____r25;
  var __body15 = cut(____id19, 0);
  var ____x100 = ["setenv", ["quote", __name2]];
  ____x100.macro = join(["fn", __args1], __body15);
  return join(____x100, props(__body15));
}});
setenv("define-special", {_stash: true, macro: function(name, args, ..._42args) {
  var ____r26 = unstash([..._42args]);
  var __name3 = destash33(name, ____r26);
  var __args2 = destash33(args, ____r26);
  var ____id20 = ____r26;
  var __body16 = cut(____id20, 0);
  var ____x104 = ["setenv", ["quote", __name3]];
  ____x104.special = join(["fn", __args2], __body16);
  return join(____x104, props(__body16));
}});
setenv("define-symbol", {_stash: true, macro: function(name, expansion) {
  var ____x107 = ["setenv", ["quote", name]];
  ____x107.symbol = ["quote", expansion];
  return ____x107;
}});
setenv("define-reader", {_stash: true, macro: function(__x110, ..._42args) {
  var ____id21 = __x110;
  var __char = ____id21[0];
  var __s = ____id21[1];
  var ____r28 = unstash([..._42args]);
  var ____x110 = destash33(__x110, ____r28);
  var ____id22 = ____r28;
  var __body17 = cut(____id22, 0);
  return ["set", ["get", "read-table", __char], join(["fn", [__s]], __body17)];
}});
setenv("define", {_stash: true, macro: function(name, x, ..._42args) {
  var ____r29 = unstash([..._42args]);
  var __name4 = destash33(name, ____r29);
  var __x117 = destash33(x, ____r29);
  var ____id23 = ____r29;
  var __body18 = cut(____id23, 0);
  if (some63(__body18)) {
    return join(["%local-function", __name4], bind_function(__x117, __body18), props(__body18));
  } else {
    return ["%local", __name4, __x117];
  }
}});
setenv("define-global", {_stash: true, macro: function(name, x, ..._42args) {
  var ____r30 = unstash([..._42args]);
  var __name5 = destash33(name, ____r30);
  var __x121 = destash33(x, ____r30);
  var ____id24 = ____r30;
  var __body19 = cut(____id24, 0);
  if (some63(__body19)) {
    return join(["%global-function", __name5], bind_function(__x121, __body19), props(__body19));
  } else {
    if (global_id63(__name5)) {
      return ["set", __name5, __x121];
    } else {
      return ["set", ["get", "_G", ["quote", compile(__name5)]], __x121];
    }
  }
}});
setenv("with-frame", {_stash: true, macro: function(..._42args) {
  var __body20 = unstash([..._42args]);
  var __x128 = unique("x");
  return ["%do", ["add", "environment*", ["obj"]], ["with", __x128, join(["%do"], __body20), ["drop", "environment*"]]];
}});
setenv("with-bindings", {_stash: true, macro: function(__x135, ..._42args) {
  var ____id25 = __x135;
  var __names = ____id25[0];
  var ____r31 = unstash([..._42args]);
  var ____x135 = destash33(__x135, ____r31);
  var ____id26 = ____r31;
  var __body21 = cut(____id26, 0);
  var __x137 = unique("x");
  var ____x140 = ["setenv", __x137];
  ____x140.variable = true;
  return join(["with-frame", ["each", __x137, __names, ____x140]], __body21);
}});
setenv("let-macro", {_stash: true, macro: function(definitions, ..._42args) {
  var ____r32 = unstash([..._42args]);
  var __definitions = destash33(definitions, ____r32);
  var ____id27 = ____r32;
  var __body22 = cut(____id27, 0);
  add(_G.environment, {});
  var ____x143 = __definitions;
  var ____i1 = 0;
  while (____i1 < _35(____x143)) {
    var __m = ____x143[____i1];
    _eval(join(["define-macro"], __m));
    ____i1 = ____i1 + 1;
  }
  var ____x142 = join(["%do"], macroexpand(__body22));
  drop(_G.environment);
  return ____x142;
}});
setenv("let-symbol", {_stash: true, macro: function(expansions, ..._42args) {
  var ____r33 = unstash([..._42args]);
  var __expansions = destash33(expansions, ____r33);
  var ____id28 = ____r33;
  var __body23 = cut(____id28, 0);
  add(_G.environment, {});
  var ____x148 = pair(__expansions);
  var ____i2 = 0;
  while (____i2 < _35(____x148)) {
    var ____id29 = ____x148[____i2];
    var __name6 = ____id29[0];
    var __exp = ____id29[1];
    _eval(["define-symbol", __name6, __exp]);
    ____i2 = ____i2 + 1;
  }
  var ____x147 = join(["%do"], macroexpand(__body23));
  drop(_G.environment);
  return ____x147;
}});
setenv("let-unique", {_stash: true, macro: function(names, ..._42args) {
  var ____r34 = unstash([..._42args]);
  var __names1 = destash33(names, ____r34);
  var ____id30 = ____r34;
  var __body24 = cut(____id30, 0);
  var __bs22 = map(function(n) {
    return [n, ["unique", ["quote", n]]];
  }, __names1);
  return join(["let", apply(join, __bs22)], __body24);
}});
setenv("fn", {_stash: true, macro: function(args, ..._42args) {
  var ____r36 = unstash([..._42args]);
  var __args3 = destash33(args, ____r36);
  var ____id31 = ____r36;
  var __body25 = cut(____id31, 0);
  return join(["%function"], bind_function(__args3, __body25), props(__body25));
}});
setenv("apply", {_stash: true, macro: function(f, ..._42args) {
  var ____r37 = unstash([..._42args]);
  var __f = destash33(f, ____r37);
  var ____id32 = ____r37;
  var __args4 = cut(____id32, 0);
  if (_35(__args4) > 1) {
    return ["%call", "apply", __f, ["join", join(["list"], almost(__args4)), last(__args4)]];
  } else {
    return join(["%call", "apply", __f], __args4);
  }
}});
setenv("guard", {_stash: true, macro: function(expr) {
  if (_G.target === "js") {
    return [["fn", join(), ["%try", ["list", true, expr]]]];
  } else {
    var ____x174 = ["obj"];
    ____x174.stack = [["get", "debug", ["quote", "traceback"]]];
    ____x174.message = ["if", ["string?", "m"], ["clip", "m", ["+", ["or", ["search", "m", "\": \""], -2], 2]], ["nil?", "m"], "\"\"", ["str", "m"]];
    return ["list", ["xpcall", ["fn", join(), expr], ["fn", ["m"], ["if", ["obj?", "m"], "m", ____x174]]]];
  }
}});
setenv("each", {_stash: true, macro: function(x, t, ..._42args) {
  var ____r39 = unstash([..._42args]);
  var __x187 = destash33(x, ____r39);
  var __t = destash33(t, ____r39);
  var ____id33 = ____r39;
  var __body26 = cut(____id33, 0);
  var __o1 = unique("o");
  var __n1 = unique("n");
  var __i3 = unique("i");
  var __e1 = undefined;
  if (atom63(__x187)) {
    __e1 = [__i3, __x187];
  } else {
    var __e2 = undefined;
    if (_35(__x187) > 1) {
      __e2 = __x187;
    } else {
      __e2 = [__i3, hd(__x187)];
    }
    __e1 = __e2;
  }
  var ____id34 = __e1;
  var __k1 = ____id34[0];
  var __v4 = ____id34[1];
  return ["let", [__o1, __t], ["for", [__k1], ["pairs", __o1], join(["let", [__v4, ["get", __o1, __k1]]], __body26)]];
}});
setenv("for", {_stash: true, macro: function(i, to, ..._42args) {
  var ____r40 = unstash([..._42args]);
  var __i4 = destash33(i, ____r40);
  var __to = destash33(to, ____r40);
  var ____id35 = ____r40;
  var __body27 = cut(____id35, 0);
  if (obj63(__i4)) {
    return ["let", apply(join, map(function(x) {
      return [x, "nil"];
    }, __i4)), join(["%for", __to, join(["%names"], __i4), join(["%do"], __body27)], props(__body27))];
  } else {
    return ["let", __i4, 0, join(["while", ["<", __i4, __to]], __body27, [["inc", __i4]])];
  }
}});
setenv("step", {_stash: true, macro: function(v, t, ..._42args) {
  var ____r42 = unstash([..._42args]);
  var __v5 = destash33(v, ____r42);
  var __t1 = destash33(t, ____r42);
  var ____id36 = ____r42;
  var __body28 = cut(____id36, 0);
  var __x210 = unique("x");
  var __i5 = unique("i");
  return ["let", [__x210, __t1], ["for", __i5, ["#", __x210], join(["let", [__v5, ["at", __x210, __i5]]], __body28)]];
}});
setenv("set-of", {_stash: true, macro: function(..._42args) {
  var __xs = unstash([..._42args]);
  var __l1 = [];
  var ____o2 = __xs;
  var ____i6 = undefined;
  for (____i6 of pairs(____o2)) {
    var __x219 = ____o2[____i6];
    __l1[__x219] = true;
  }
  return join(["obj"], __l1);
}});
setenv("language", {_stash: true, macro: function() {
  return ["quote", _G.target];
}});
setenv("target", {_stash: true, macro: function(..._42args) {
  var __clauses1 = unstash([..._42args]);
  return __clauses1[_G.target];
}});
setenv("join!", {_stash: true, macro: function(a, ..._42args) {
  var ____r44 = unstash([..._42args]);
  var __a1 = destash33(a, ____r44);
  var ____id37 = ____r44;
  var __bs3 = cut(____id37, 0);
  return ["set", __a1, join(["join", __a1], __bs3)];
}});
setenv("cat!", {_stash: true, macro: function(a, ..._42args) {
  var ____r45 = unstash([..._42args]);
  var __a2 = destash33(a, ____r45);
  var ____id38 = ____r45;
  var __bs4 = cut(____id38, 0);
  return ["set", __a2, join(["cat", __a2], __bs4)];
}});
setenv("inc", {_stash: true, macro: function(n, by) {
  var __e3 = undefined;
  if (nil63(by)) {
    __e3 = 1;
  } else {
    __e3 = by;
  }
  return ["set", n, ["+", n, __e3]];
}});
setenv("dec", {_stash: true, macro: function(n, by) {
  var __e4 = undefined;
  if (nil63(by)) {
    __e4 = 1;
  } else {
    __e4 = by;
  }
  return ["set", n, ["-", n, __e4]];
}});
setenv("with-indent", {_stash: true, macro: function(form) {
  var __x233 = unique("x");
  return ["%do", ["inc", "indent-level*"], ["with", __x233, form, ["dec", "indent-level*"]]];
}});
setenv("undefined?", {_stash: true, macro: function(x) {
  var ____x238 = ["target"];
  ____x238.lua = ["=", x, "nil"];
  ____x238.js = ["=", ["typeof", x], "\"undefined\""];
  return ____x238;
}});
setenv("export", {_stash: true, macro: function(..._42args) {
  var __names2 = unstash([..._42args]);
  var ____x250 = ["target"];
  ____x250.lua = ["return", "exports"];
  return join(["with", "exports", ["if", ["undefined?", "exports"], ["obj"], "exports"]], map(function(k) {
    return ["set", ["exports", "." + k], k];
  }, __names2), [____x250]);
}});
setenv("when-compiling", {_stash: true, macro: function(..._42args) {
  var __body29 = unstash([..._42args]);
  return _eval(join(["%do"], __body29));
}});
setenv("during-compilation", {_stash: true, macro: function(..._42args) {
  var __body30 = unstash([..._42args]);
  var __form2 = join(["%do"], __body30, [["%do"]]);
  _eval(__form2);
  return __form2;
}});
setenv("compose", {_stash: true, transformer: function(__x258) {
  var ____id39 = __x258;
  var ____id40 = ____id39[0];
  var __compose = ____id40[0];
  var __fns = cut(____id40, 1);
  var __body31 = cut(____id39, 1);
  if (none63(__fns)) {
    return macroexpand(join(["do"], __body31));
  } else {
    if (one63(__fns)) {
      return macroexpand(join(__fns, __body31));
    } else {
      return macroexpand([join([__compose], almost(__fns)), join([last(__fns)], __body31)]);
    }
  }
}});
setenv("complement", {_stash: true, transformer: function(__x263) {
  var ____id41 = __x263;
  var ____id42 = ____id41[0];
  var __complement = ____id42[0];
  var __form3 = ____id42[1];
  var __body32 = cut(____id41, 1);
  if (hd63(__form3, "complement")) {
    return macroexpand(join([__form3[1]], __body32));
  } else {
    return macroexpand(["no", join([__form3], __body32)]);
  }
}});
setenv("expansion", {_stash: true, transformer: function(__x267) {
  var ____id43 = __x267;
  var ____id44 = ____id43[0];
  var __expansion = ____id44[0];
  var __form4 = ____id43[1];
  return __form4;
}});
setenv("hd", {_stash: true, expander: function(setfn, ..._42args) {
  var ____r56 = unstash([..._42args]);
  var __setfn1 = destash33(setfn, ____r56);
  var ____id46 = ____r56;
  var __args6 = cut(____id46, 0);
  return define_setter("hd", function(v, l) {
    return ["set", ["at", l, 0], v];
  }, __setfn1, __args6);
}});
var reader = require("./reader");
var compiler = require("./compiler");
var system = require("./system");
var eval_print = function(form) {
  var ____id = (function() {
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
var rep = function(s) {
  return eval_print(reader.readString(s));
};
var repl = function() {
  var __buf = "";
  var rep1 = function(s) {
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
read_file = function(path) {
  return system.readFile(path);
};
write_file = function(path, data) {
  return system.writeFile(path, data);
};
read_from_file = function(path) {
  var __s = reader.stream(system.readFile(path));
  var __body = reader.readAll(__s);
  return join(["do"], __body);
};
expand_file = function(path) {
  return compiler.expand(read_from_file(path));
};
compile_file = function(path) {
  var __form1 = expand_file(path);
  return compiler.compile(__form1, {_stash: true, stmt: true});
};
load = function(path) {
  var __previous = _G.target;
  _G.target = "js";
  var __code = compile_file(path);
  _G.target = __previous;
  return compiler.run(__code);
};
script_file63 = function(path) {
  return string63(path) && !( "-" === char(path, 0) || ".js" === clip(path, _35(path) - 3) || ".lua" === clip(path, _35(path) - 4));
};
run_file = function(path) {
  if (script_file63(path)) {
    return load(path);
  } else {
    return compiler.run(read_file(path));
  }
};
run_script = function(file, argv) {
  set_argv(argv);
  var ____id1 = run_file(file);
  var __main = ____id1.main;
  if (nil63(__main)) {
    return error("main not exported for script file " + str(file));
  } else {
    return __main(argv);
  }
};
read_from_string = function(str, start, end) {
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
readable_string63 = function(str) {
  var __id5 = string63(str);
  var __e = undefined;
  if (__id5) {
    var ____id2 = (function() {
      try {
        return [true, read_from_string(str)];
      }
      catch (__e3) {
        return [false, __e3];
      }
    })();
    var __ok1 = ____id2[0];
    var __v1 = ____id2[1];
    __e = __ok1 && hd(__v1) === str;
  } else {
    __e = __id5;
  }
  return __e;
};
pp_to_string = function(x, stack) {
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
var usage = function() {
  return "\nUsage:\n  lumen <file> [<args>...]\n  lumen [options] [<object-files>...]\n\n  <file>          Program read from script file\n  <object-files>  Loaded before compiling <input>\n\nOptions:\n  -c <input>...   Compile input files\n  -o <output>     Write compiler output to <output>\n  -t <target>     Set target language (default: lua)\n  -e <expr>...    Expressions to evaluate\n";
};
var main = function(argv) {
  if (script_file63(hd(argv))) {
    return run_script(hd(argv), tl(argv));
  } else {
    var __args = parse_arguments({c: "compile", o: "output", t: "target", e: "eval", h: "help", r: "repl"}, argv);
    if (script_file63(hd(__args))) {
      return run_script(hd(__args), tl(__args));
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
          var ____id3 = ____x8[____i4];
          var __a = ____id3[0];
          var __val = ____id3[1];
          if (__a === "target") {
            _G.target = hd(__val);
            break;
          }
          ____i4 = ____i4 + 1;
        }
        var ____x9 = __cmds;
        var ____i5 = 0;
        while (____i5 < _35(____x9)) {
          var ____id4 = ____x9[____i5];
          var __a1 = ____id4[0];
          var __val1 = ____id4[1];
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
__exports.usage = usage;
__exports.main = main;
__exports;
