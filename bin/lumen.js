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
  var ____id = (function() {
    try {
      return [true, results(f(..._42args))];
    }
    catch (__e19) {
      return [false, __e19];
    }
  })();
  var __ok = ____id[0];
  var __v1 = ____id[1];
  return values(__ok, ...__v1);
};
nil63 = function(x) {
  return x === undefined || x === null;
};
is63 = function(x) {
  return !nil63(x);
};
no = function(x) {
  return nil63(x) || x === false;
};
yes = function(x) {
  return !no(x);
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
get63 = function(l, k, _default) {
  if (has63(l, k)) {
    return l[k];
  } else {
    return _default;
  }
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
  var __id3 = obj63(l);
  var __e2 = undefined;
  if (__id3) {
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
    __e2 = __id3;
  }
  return __e2;
};
_G.nan = 0 / 0;
_G.inf = 1 / 0;
_G._inf = - inf;
nan63 = function(n) {
  return !(n === n);
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
reduce = function(f, l, r) {
  return iterate(__o2, f, l, r).result;
};
cut = function(x, from, upto) {
  if (string63(x)) {
    return clip(x, from, upto);
  } else {
    var __l = [];
    var __j = 0;
    var __e5 = undefined;
    if (nil63(from) || from < 0) {
      __e5 = 0;
    } else {
      __e5 = from;
    }
    var __i2 = __e5;
    var __n1 = _35(x);
    var __e6 = undefined;
    if (nil63(upto) || upto > __n1) {
      __e6 = __n1;
    } else {
      __e6 = upto;
    }
    var __upto1 = __e6;
    while (__i2 < __upto1) {
      __l[__j] = x[__i2];
      __i2 = __i2 + 1;
      __j = __j + 1;
    }
    var ____o3 = x;
    var __k1 = undefined;
    for (__k1 of pairs(____o3)) {
      var __v4 = ____o3[__k1];
      if (!number63(__k1)) {
        __l[__k1] = __v4;
      }
    }
    return __l;
  }
};
props = function(x) {
  var __t = [];
  var ____o4 = x;
  var __k2 = undefined;
  for (__k2 of pairs(____o4)) {
    var __v5 = ____o4[__k2];
    if (!number63(__k2)) {
      __t[__k2] = __v5;
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
  if (string63(l)) {
    return char(l, edge(l));
  } else {
    return l[edge(l)];
  }
};
almost = function(l) {
  return cut(l, 0, edge(l));
};
reverse = function(l) {
  var __l1 = props(l);
  var __i5 = edge(l);
  while (__i5 >= 0) {
    add(__l1, l[__i5]);
    __i5 = __i5 - 1;
  }
  return __l1;
};
join = function(..._42args) {
  var __ls = unstash([..._42args]);
  var __r51 = [];
  var ____x5 = __ls;
  var ____i6 = 0;
  while (____i6 < _35(____x5)) {
    var __l11 = ____x5[____i6];
    if (__l11) {
      var __n4 = _35(__r51);
      var ____o5 = __l11;
      var __k3 = undefined;
      for (__k3 of pairs(____o5)) {
        var __v6 = ____o5[__k3];
        if (number63(__k3)) {
          __k3 = __k3 + __n4;
        }
        __r51[__k3] = __v6;
      }
    }
    ____i6 = ____i6 + 1;
  }
  return __r51;
};
testify = function(x, test) {
  if (function63(x)) {
    return x;
  } else {
    if (test) {
      return function(y) {
        return test(x, y);
      };
    } else {
      return function(y) {
        return x === y;
      };
    }
  }
};
testify_of = function(x) {
  return testify(x, get63);
};
find = function(x, t) {
  var __f = testify(x);
  var ____o6 = t;
  var ____i8 = undefined;
  for (____i8 of pairs(____o6)) {
    var __x6 = ____o6[____i8];
    var __y = __f(__x6);
    if (yes(__y)) {
      return __y;
    }
  }
};
first = function(x, l, pos) {
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
in63 = function(x, t) {
  return find(testify(x), t);
};
_G.whitespace = {[" "]: true, ["\n"]: true, ["\t"]: true, ["\r"]: true};
whitec = function(c) {
  return get63(_G.whitespace, c);
};
nonwhite = function(c) {
  return !whitec(c);
};
blank = function(s) {
  return nil63(s) || (function(..._42args) {
    return !find(..._42args);
  })(function(..._42args) {
  return !whitec(..._42args);
}, s);
};
nonblank = function(s) {
  if (!blank(s)) {
    return s;
  }
};
trim = function(s, __x7, ..._42args) {
  var __e7 = undefined;
  if (__x7 === undefined) {
    __e7 = whitec;
  } else {
    __e7 = __x7;
  }
  var __test = __e7;
  var ____r65 = unstash([..._42args]);
  var __s = destash33(s, ____r65);
  var ____x7 = destash33(__x7, ____r65);
  var ____id1 = ____r65;
  var __e8 = undefined;
  if (____id1.where === undefined) {
    __e8 = "both";
  } else {
    __e8 = ____id1.where;
  }
  var __where = __e8;
  var __f2 = testify(__test);
  var __p1 = first(function(..._42args) {
  return !__f2(..._42args);
}, __s);
  if (is63(__p1)) {
    var __e9 = undefined;
    if (__where === "front" || __where === "both") {
      __e9 = __p1;
    } else {
      __e9 = 0;
    }
    var __e10 = undefined;
    if (__where === "end" || __where === "both") {
      var __i11 = _35(__s) - 1;
      while (__i11 > __p1 && __f2(__s[__i11])) {
        __i11 = __i11 - 1;
      }
      __e10 = __i11 + 1;
    }
    return cut(__s, __e9, __e10);
  } else {
    return "";
  }
};
ltrim = function(s, __x9) {
  var __e11 = undefined;
  if (__x9 === undefined) {
    __e11 = whitec;
  } else {
    __e11 = __x9;
  }
  var __test1 = __e11;
  return trim(s, __test1, {_stash: true, where: "front"});
};
rtrim = function(s, __x10) {
  var __e12 = undefined;
  if (__x10 === undefined) {
    __e12 = whitec;
  } else {
    __e12 = __x10;
  }
  var __test2 = __e12;
  return trim(s, __test2, {_stash: true, where: "end"});
};
pair = function(l) {
  var __l12 = [];
  var __i12 = 0;
  while (__i12 < _35(l)) {
    add(__l12, [l[__i12], l[__i12 + 1]]);
    __i12 = __i12 + 1;
    __i12 = __i12 + 1;
  }
  return __l12;
};
sort = function(l, f) {
  var __e13 = undefined;
  if (f) {
    __e13 = function(a, b) {
      if (f(a, b)) {
        return -1;
      } else {
        return 1;
      }
    };
  }
  return l.sort(__e13);
};
map = function(f, x) {
  var __t1 = [];
  var ____x12 = x;
  var ____i13 = 0;
  while (____i13 < _35(____x12)) {
    var __v9 = ____x12[____i13];
    var __y3 = f(__v9);
    if (is63(__y3)) {
      add(__t1, __y3);
    }
    ____i13 = ____i13 + 1;
  }
  var ____o8 = x;
  var __k5 = undefined;
  for (__k5 of pairs(____o8)) {
    var __v10 = ____o8[__k5];
    if (!number63(__k5)) {
      var __y4 = f(__v10);
      if (is63(__y4)) {
        __t1[__k5] = __y4;
      }
    }
  }
  return __t1;
};
keep = function(v, x) {
  var __f3 = testify(v);
  return map(function(v) {
  if (yes(__f3(v))) {
    return v;
  }
}, x);
};
keys63 = function(t) {
  var ____o9 = t;
  var __k6 = undefined;
  for (__k6 of pairs(____o9)) {
    var __v11 = ____o9[__k6];
    if (!number63(__k6)) {
      return true;
    }
  }
  return false;
};
empty63 = function(t) {
  var ____o10 = t;
  var ____i16 = undefined;
  for (____i16 of pairs(____o10)) {
    var __x13 = ____o10[____i16];
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
      var __v12 = ____o11[__k7];
      if (!number63(__k7)) {
        __p[__k7] = __v12;
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
        var __v13 = ____o12[__k8];
        if (!(__k8 === "_stash")) {
          __args1[__k8] = __v13;
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
      var __v14 = ____o13[__k9];
      if (!(__k9 === "_stash")) {
        args1[__k9] = __v14;
      }
    }
  } else {
    return l;
  }
};
search = function(s, pattern, start) {
  var __i20 = s.indexOf(pattern, start);
  if (__i20 >= 0) {
    return __i20;
  }
};
split = function(s, sep) {
  if (s === "" || sep === "") {
    return [];
  } else {
    var __l3 = [];
    var __n15 = _35(sep);
    while (true) {
      var __i21 = search(s, sep);
      if (nil63(__i21)) {
        break;
      } else {
        add(__l3, clip(s, 0, __i21));
        s = clip(s, __i21 + __n15);
      }
    }
    add(__l3, s);
    return __l3;
  }
};
concat = function(sep, s, ..._42args) {
  return reduce(function(a, b) {
  return a + sep + b;
}, [..._42args], s || "");
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
  var __i22 = 0;
  while (__i22 < edge(xs)) {
    var __a = xs[__i22];
    var __b = xs[__i22 + 1];
    if (!f(__a, __b)) {
      return false;
    }
    __i22 = __i22 + 1;
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
  var __n16 = parseFloat(s);
  if (!isNaN(__n16)) {
    return __n16;
  }
};
number_code63 = function(n) {
  return n > 47 && n < 58;
};
numeric63 = function(s) {
  var __n17 = _35(s);
  var __i23 = 0;
  while (__i23 < __n17) {
    if (!number_code63(code(s, __i23))) {
      return false;
    }
    __i23 = __i23 + 1;
  }
  return some63(s);
};
lowercase_code63 = function(n) {
  return n >= 97 && n <= 122;
};
uppercase_code63 = function(n) {
  return n >= 65 && n <= 90;
};
camel_case = function(str) {
  var __s1 = "";
  var __n18 = _35(str);
  var __i24 = 0;
  while (__i24 < __n18) {
    var __c = code(str, __i24);
    if (__c === 45 && lowercase_code63(code(str, __i24 - 1) || 0) && lowercase_code63(code(str, __i24 + 1) || 0)) {
      __i24 = __i24 + 1;
      __c = code(str, __i24) - 32;
    }
    __s1 = __s1 + from_code(__c);
    __i24 = __i24 + 1;
  }
  return __s1;
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
  var __s11 = "\"";
  var __i25 = 0;
  while (__i25 < _35(s)) {
    var __c1 = char(s, __i25);
    var __e14 = undefined;
    if (__c1 === "\n") {
      __e14 = "\\n";
    } else {
      var __e15 = undefined;
      if (__c1 === "\r") {
        __e15 = "\\r";
      } else {
        var __e16 = undefined;
        if (__c1 === "\"") {
          __e16 = "\\\"";
        } else {
          var __e17 = undefined;
          if (__c1 === "\\") {
            __e17 = "\\\\";
          } else {
            __e17 = __c1;
          }
          __e16 = __e17;
        }
        __e15 = __e16;
      }
      __e14 = __e15;
    }
    var __c11 = __e14;
    __s11 = __s11 + __c11;
    __i25 = __i25 + 1;
  }
  return __s11 + "\"";
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
            var __s2 = "(";
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
            var ____i27 = undefined;
            for (____i27 of pairs(____o15)) {
              var __v16 = ____o15[____i27];
              __s2 = __s2 + __sp + __v16;
              __sp = " ";
            }
            return __s2 + ")";
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
  var ____r113 = unstash([..._42args]);
  var __k11 = destash33(k, ____r113);
  var ____id2 = ____r113;
  var __keys = cut(____id2, 0);
  if (string63(__k11)) {
    var __e18 = undefined;
    if (__keys.toplevel) {
      __e18 = hd(_G.environment);
    } else {
      __e18 = last(_G.environment);
    }
    var __frame = __e18;
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
setenv("do", {_stash: true, macro: function(..._42args) {
  var __body = unstash([..._42args]);
  return join(["%do"], __body);
}});
setenv("quote", {_stash: true, macro: function(form) {
  return quoted(form);
}});
setenv("quasiquote", {_stash: true, macro: function(form) {
  return quasiexpand(form, 1);
}});
setenv("while", {_stash: true, macro: function(test, ..._42args) {
  var ____r2 = unstash([..._42args]);
  var __test = destash33(test, ____r2);
  var ____id = ____r2;
  var __body1 = cut(____id, 0);
  return join(["%while", __test, join(["%do"], __body1)], props(__body1));
}});
get_place = function(place, setfn) {
  var __place = macroexpand(place);
  if (atom63(__place) || hd(__place) === "get" && nil63(getenv("get", "place-expander")) || accessor_literal63(hd(tl(__place)))) {
    return setfn(__place, function(v) {
  return ["%set", __place, v];
});
  } else {
    var __head = hd(__place);
    var __gf = getenv(__head, "place-expander");
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
  var __body2 = cut(____id1, 0);
  return ["get-place", __place1, join(["fn", __vars], __body2)];
}});
setenv("define-expander", {_stash: true, macro: function(name, handler) {
  var ____x10 = ["setenv", ["quote", name]];
  ____x10["place-expander"] = handler;
  var __form = ____x10;
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
  var __body3 = cut(____id2, 0);
  var ____x18 = ["setfn"];
  ____x18.rest = "args";
  return ["define-expander", __name, ["fn", ____x18, ["%call", "define-setter", ["quote", __name], join(["fn", __arglist], __body3), "setfn", "args"]]];
}});
setenv("set", {_stash: true, macro: function(..._42args) {
  var __args = unstash([..._42args]);
  return join(["%do"], map(function(__x24) {
  var ____id3 = __x24;
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
  var __body4 = unstash([..._42args]);
  var __x30 = unique("x");
  var __l = [];
  var __forms = [];
  var ____o = __body4;
  var __k = undefined;
  for (__k of pairs(____o)) {
    var __v1 = ____o[__k];
    if (number63(__k)) {
      __l[__k] = __v1;
    } else {
      add(__forms, ["set", ["get", __x30, ["quote", __k]], __v1]);
    }
  }
  if (some63(__forms)) {
    return join(["let", __x30, join(["%array"], __l)], __forms, [__x30]);
  } else {
    return join(["%array"], __l);
  }
}});
setenv("if", {_stash: true, macro: function(..._42args) {
  var __branches = unstash([..._42args]);
  return hd(expand_if(__branches));
}});
setenv("in", {_stash: true, macro: function(x, ..._42args) {
  var ____r14 = unstash([..._42args]);
  var __x40 = destash33(x, ____r14);
  var ____id4 = ____r14;
  var __e = undefined;
  if (____id4.test === undefined) {
    __e = "=";
  } else {
    __e = ____id4.test;
  }
  var __test1 = __e;
  var __choices = cut(____id4, 0);
  return join(["or"], map(function(c) {
  return [__test1, __x40, c];
}, __choices));
}});
setenv("case", {_stash: true, macro: function(expr, ..._42args) {
  var ____r16 = unstash([..._42args]);
  var __expr = destash33(expr, ____r16);
  var ____id5 = ____r16;
  var __clauses = cut(____id5, 0);
  var __x44 = unique("x");
  var __eq = function(_) {
    return ["=", ["quote", _], __x44];
  };
  var __cl = function(__x47) {
    var ____id6 = __x47;
    var __a = ____id6[0];
    var __b = ____id6[1];
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
  var ____r19 = unstash([..._42args]);
  var __cond = destash33(cond, ____r19);
  var ____id7 = ____r19;
  var __body5 = cut(____id7, 0);
  return ["if", __cond, join(["%do"], __body5)];
}});
setenv("unless", {_stash: true, macro: function(cond, ..._42args) {
  var ____r20 = unstash([..._42args]);
  var __cond1 = destash33(cond, ____r20);
  var ____id8 = ____r20;
  var __body6 = cut(____id8, 0);
  return ["if", ["not", __cond1], join(["%do"], __body6)];
}});
setenv("obj", {_stash: true, macro: function(..._42args) {
  var __body7 = unstash([..._42args]);
  return join(["%object"], mapo(function(x) {
  return x;
}, __body7));
}});
setenv("let", {_stash: true, macro: function(bs, ..._42args) {
  var ____r22 = unstash([..._42args]);
  var __bs = destash33(bs, ____r22);
  var ____id9 = ____r22;
  var __body8 = cut(____id9, 0);
  if (atom63(__bs)) {
    return join(["let", [__bs, hd(__body8)]], tl(__body8));
  } else {
    if (none63(__bs)) {
      return join(["%do"], __body8);
    } else {
      if (hd63(__bs, "%brackets")) {
        return join(["let", tl(__bs)], __body8);
      } else {
        var ____id10 = __bs;
        var __lh1 = ____id10[0];
        var __rh1 = ____id10[1];
        var __bs2 = cut(____id10, 2);
        var ____id11 = bind(__lh1, __rh1);
        var __id12 = ____id11[0];
        var __val = ____id11[1];
        var __bs1 = cut(____id11, 2);
        var __id111 = unique(__id12);
        return ["%do", ["%local", __id111, __val], ["let-symbol", [__id12, __id111], join(["let", join(__bs1, __bs2)], __body8)]];
      }
    }
  }
}});
setenv("with", {_stash: true, macro: function(x, v, ..._42args) {
  var ____r23 = unstash([..._42args]);
  var __x75 = destash33(x, ____r23);
  var __v2 = destash33(v, ____r23);
  var ____id13 = ____r23;
  var __body9 = cut(____id13, 0);
  return join(["let", [__x75, __v2]], __body9, [__x75]);
}});
setenv("let-when", {_stash: true, macro: function(x, v, ..._42args) {
  var ____r24 = unstash([..._42args]);
  var __x80 = destash33(x, ____r24);
  var __v3 = destash33(v, ____r24);
  var ____id14 = ____r24;
  var __body10 = cut(____id14, 0);
  var __y = unique("y");
  return ["let", __y, __v3, ["when", ["yes", __y], join(["let", [__x80, __y]], __body10)]];
}});
setenv("define-transformer", {_stash: true, macro: function(name, form, ..._42args) {
  var ____r25 = unstash([..._42args]);
  var __name1 = destash33(name, ____r25);
  var __form1 = destash33(form, ____r25);
  var ____id15 = ____r25;
  var __body11 = cut(____id15, 0);
  var ____x87 = ["setenv", ["quote", __name1]];
  ____x87.transformer = join(["fn", [__form1]], __body11);
  return join(____x87, props(__body11));
}});
setenv("define-macro", {_stash: true, macro: function(name, args, ..._42args) {
  var ____r26 = unstash([..._42args]);
  var __name2 = destash33(name, ____r26);
  var __args1 = destash33(args, ____r26);
  var ____id16 = ____r26;
  var __body12 = cut(____id16, 0);
  var ____x92 = ["setenv", ["quote", __name2]];
  ____x92.macro = join(["fn", __args1], __body12);
  return join(____x92, props(__body12));
}});
setenv("define-special", {_stash: true, macro: function(name, args, ..._42args) {
  var ____r27 = unstash([..._42args]);
  var __name3 = destash33(name, ____r27);
  var __args2 = destash33(args, ____r27);
  var ____id17 = ____r27;
  var __body13 = cut(____id17, 0);
  var ____x96 = ["setenv", ["quote", __name3]];
  ____x96.special = join(["fn", __args2], __body13);
  return join(____x96, props(__body13));
}});
setenv("define-symbol", {_stash: true, macro: function(name, expansion) {
  var ____x99 = ["setenv", ["quote", name]];
  ____x99.symbol = ["quote", expansion];
  return ____x99;
}});
setenv("define-reader", {_stash: true, macro: function(__x102, ..._42args) {
  var ____id18 = __x102;
  var __char = ____id18[0];
  var __s = ____id18[1];
  var ____r29 = unstash([..._42args]);
  var ____x102 = destash33(__x102, ____r29);
  var ____id19 = ____r29;
  var __body14 = cut(____id19, 0);
  return ["set", ["get", "read-table", __char], join(["fn", [__s]], __body14)];
}});
setenv("define", {_stash: true, macro: function(name, x, ..._42args) {
  var ____r30 = unstash([..._42args]);
  var __name4 = destash33(name, ____r30);
  var __x109 = destash33(x, ____r30);
  var ____id20 = ____r30;
  var __body15 = cut(____id20, 0);
  if (some63(__body15)) {
    return join(["%local-function", __name4], bind_function(__x109, __body15), props(__body15));
  } else {
    return ["%local", __name4, __x109];
  }
}});
setenv("define-global", {_stash: true, macro: function(name, x, ..._42args) {
  var ____r31 = unstash([..._42args]);
  var __name5 = destash33(name, ____r31);
  var __x113 = destash33(x, ____r31);
  var ____id21 = ____r31;
  var __body16 = cut(____id21, 0);
  if (some63(__body16)) {
    return join(["%global-function", __name5], bind_function(__x113, __body16), props(__body16));
  } else {
    if (global_id63(__name5)) {
      return ["set", __name5, __x113];
    } else {
      return ["set", ["get", "_G", ["quote", compile(__name5)]], __x113];
    }
  }
}});
setenv("with-frame", {_stash: true, macro: function(..._42args) {
  var __body17 = unstash([..._42args]);
  var __x120 = unique("x");
  return ["%do", ["add", "environment*", ["obj"]], ["with", __x120, join(["%do"], __body17), ["drop", "environment*"]]];
}});
setenv("with-bindings", {_stash: true, macro: function(__x127, ..._42args) {
  var ____id22 = __x127;
  var __names = ____id22[0];
  var ____r32 = unstash([..._42args]);
  var ____x127 = destash33(__x127, ____r32);
  var ____id23 = ____r32;
  var __body18 = cut(____id23, 0);
  var __x129 = unique("x");
  var ____x132 = ["setenv", __x129];
  ____x132.variable = true;
  return join(["with-frame", ["each", __x129, __names, ____x132]], __body18);
}});
setenv("let-macro", {_stash: true, macro: function(definitions, ..._42args) {
  var ____r33 = unstash([..._42args]);
  var __definitions = destash33(definitions, ____r33);
  var ____id24 = ____r33;
  var __body19 = cut(____id24, 0);
  add(_G.environment, {});
  var ____x135 = __definitions;
  var ____i1 = 0;
  while (____i1 < _35(____x135)) {
    var __m = ____x135[____i1];
    _eval(join(["define-macro"], __m));
    ____i1 = ____i1 + 1;
  }
  var ____x134 = join(["%do"], macroexpand(__body19));
  drop(_G.environment);
  return ____x134;
}});
setenv("let-symbol", {_stash: true, macro: function(expansions, ..._42args) {
  var ____r34 = unstash([..._42args]);
  var __expansions = destash33(expansions, ____r34);
  var ____id25 = ____r34;
  var __body20 = cut(____id25, 0);
  add(_G.environment, {});
  var ____x140 = pair(__expansions);
  var ____i2 = 0;
  while (____i2 < _35(____x140)) {
    var ____id26 = ____x140[____i2];
    var __name6 = ____id26[0];
    var __exp = ____id26[1];
    _eval(["define-symbol", __name6, __exp]);
    ____i2 = ____i2 + 1;
  }
  var ____x139 = join(["%do"], macroexpand(__body20));
  drop(_G.environment);
  return ____x139;
}});
setenv("let-unique", {_stash: true, macro: function(names, ..._42args) {
  var ____r35 = unstash([..._42args]);
  var __names1 = destash33(names, ____r35);
  var ____id27 = ____r35;
  var __body21 = cut(____id27, 0);
  var __bs11 = map(function(n) {
  return [n, ["unique", ["quote", n]]];
}, __names1);
  return join(["let", apply(join, __bs11)], __body21);
}});
setenv("fn", {_stash: true, macro: function(args, ..._42args) {
  var ____r37 = unstash([..._42args]);
  var __args3 = destash33(args, ____r37);
  var ____id28 = ____r37;
  var __body22 = cut(____id28, 0);
  return join(["%function"], bind_function(__args3, __body22), props(__body22));
}});
setenv("apply", {_stash: true, macro: function(f, ..._42args) {
  var ____r38 = unstash([..._42args]);
  var __f = destash33(f, ____r38);
  var ____id29 = ____r38;
  var __args4 = cut(____id29, 0);
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
    var ____x166 = ["obj"];
    ____x166.stack = [["get", "debug", ["quote", "traceback"]]];
    ____x166.message = ["if", ["string?", "m"], ["clip", "m", ["+", ["or", ["search", "m", "\": \""], -2], 2]], ["nil?", "m"], "\"\"", ["str", "m"]];
    return ["list", ["xpcall", ["fn", join(), expr], ["fn", ["m"], ["if", ["obj?", "m"], "m", ____x166]]]];
  }
}});
setenv("each", {_stash: true, macro: function(x, t, ..._42args) {
  var ____r40 = unstash([..._42args]);
  var __x179 = destash33(x, ____r40);
  var __t = destash33(t, ____r40);
  var ____id30 = ____r40;
  var __body23 = cut(____id30, 0);
  var __o1 = unique("o");
  var __n1 = unique("n");
  var __i3 = unique("i");
  var __e1 = undefined;
  if (atom63(__x179)) {
    __e1 = [__i3, __x179];
  } else {
    var __e2 = undefined;
    if (_35(__x179) > 1) {
      __e2 = __x179;
    } else {
      __e2 = [__i3, hd(__x179)];
    }
    __e1 = __e2;
  }
  var ____id31 = __e1;
  var __k1 = ____id31[0];
  var __v4 = ____id31[1];
  return ["let", [__o1, __t], ["for", [__k1], ["pairs", __o1], join(["let", [__v4, ["get", __o1, __k1]]], __body23)]];
}});
setenv("for", {_stash: true, macro: function(i, to, ..._42args) {
  var ____r41 = unstash([..._42args]);
  var __i4 = destash33(i, ____r41);
  var __to = destash33(to, ____r41);
  var ____id32 = ____r41;
  var __body24 = cut(____id32, 0);
  if (obj63(__i4)) {
    return ["let", apply(join, map(function(x) {
  return [x, "nil"];
}, __i4)), join(["%for", __to, join(["%names"], __i4), join(["%do"], __body24)], props(__body24))];
  } else {
    return ["let", __i4, 0, join(["while", ["<", __i4, __to]], __body24, [["inc", __i4]])];
  }
}});
setenv("step", {_stash: true, macro: function(v, t, ..._42args) {
  var ____r43 = unstash([..._42args]);
  var __v5 = destash33(v, ____r43);
  var __t1 = destash33(t, ____r43);
  var ____id33 = ____r43;
  var __body25 = cut(____id33, 0);
  var __x202 = unique("x");
  var __i5 = unique("i");
  return ["let", [__x202, __t1], ["for", __i5, ["#", __x202], join(["let", [__v5, ["at", __x202, __i5]]], __body25)]];
}});
setenv("set-of", {_stash: true, macro: function(..._42args) {
  var __xs = unstash([..._42args]);
  var __l1 = [];
  var ____o2 = __xs;
  var ____i6 = undefined;
  for (____i6 of pairs(____o2)) {
    var __x211 = ____o2[____i6];
    __l1[__x211] = true;
  }
  return join(["obj"], __l1);
}});
setenv("any-of", {_stash: true, macro: function(..._42args) {
  var __xs1 = unstash([..._42args]);
  return ["testify-of", join(["set-of"], __xs1)];
}});
setenv("language", {_stash: true, macro: function() {
  return ["quote", _G.target];
}});
setenv("target", {_stash: true, macro: function(..._42args) {
  var __clauses1 = unstash([..._42args]);
  return __clauses1[_G.target];
}});
setenv("join!", {_stash: true, macro: function(a, ..._42args) {
  var ____r45 = unstash([..._42args]);
  var __a1 = destash33(a, ____r45);
  var ____id34 = ____r45;
  var __bs21 = cut(____id34, 0);
  return ["set", __a1, join(["join", __a1], __bs21)];
}});
setenv("cat!", {_stash: true, macro: function(a, ..._42args) {
  var ____r46 = unstash([..._42args]);
  var __a2 = destash33(a, ____r46);
  var ____id35 = ____r46;
  var __bs3 = cut(____id35, 0);
  return ["set", __a2, join(["cat", __a2], __bs3)];
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
setenv("with-value", {_stash: true, macro: function(name, value, ..._42args) {
  var ____r49 = unstash([..._42args]);
  var __name7 = destash33(name, ____r49);
  var __value = destash33(value, ____r49);
  var ____id36 = ____r49;
  var __body26 = cut(____id36, 0);
  var __x229 = unique("x");
  var __r50 = unique("r");
  return ["let", [__x229, __name7], ["set", __name7, __value], ["with", __r50, join(["do"], __body26), ["set", __name7, __x229]]];
}});
setenv("with-indent", {_stash: true, macro: function(form) {
  var __x236 = unique("x");
  return ["%do", ["inc", "indent-level*"], ["with", __x236, form, ["dec", "indent-level*"]]];
}});
setenv("undefined?", {_stash: true, macro: function(x) {
  var ____x241 = ["target"];
  ____x241.lua = ["=", x, "nil"];
  ____x241.js = ["=", ["typeof", x], "\"undefined\""];
  return ____x241;
}});
setenv("export", {_stash: true, macro: function(..._42args) {
  var __names2 = unstash([..._42args]);
  var ____x253 = ["target"];
  ____x253.lua = ["return", "exports"];
  return join(["with", "exports", ["if", ["undefined?", "exports"], ["obj"], "exports"]], map(function(k) {
  return ["set", ["exports", "." + k], k];
}, __names2), [____x253]);
}});
setenv("when-compiling", {_stash: true, macro: function(..._42args) {
  var __body27 = unstash([..._42args]);
  return _eval(join(["%do"], __body27));
}});
setenv("during-compilation", {_stash: true, macro: function(..._42args) {
  var __body28 = unstash([..._42args]);
  var __form2 = join(["%do"], __body28, [["%do"]]);
  _eval(__form2);
  return __form2;
}});
setenv("%tilde", {_stash: true, macro: function(..._42args) {
  var __args5 = unstash([..._42args]);
  return join(["complement"], __args5);
}});
setenv("%code", {_stash: true, macro: function(c) {
  return ["when-compiling", ["code", c]];
}});
setenv("complement", {_stash: true, macro: function(f) {
  return ["fn", ["..."], ["not", [f, "..."]]];
}});
setenv("compose", {_stash: true, transformer: function(__x269) {
  var ____id37 = __x269;
  var ____id38 = ____id37[0];
  var __compose = ____id38[0];
  var __fns = cut(____id38, 1);
  var __body29 = cut(____id37, 1);
  if (none63(__fns)) {
    return macroexpand(join(["do"], __body29));
  } else {
    if (one63(__fns)) {
      return macroexpand(join(__fns, __body29));
    } else {
      return macroexpand([join([__compose], almost(__fns)), join([last(__fns)], __body29)]);
    }
  }
}});
setenv("complement", {_stash: true, transformer: function(__x274) {
  var ____id39 = __x274;
  var ____id40 = ____id39[0];
  var __complement = ____id40[0];
  var __form3 = ____id40[1];
  var __body30 = cut(____id39, 1);
  if (hd63(__form3, "complement")) {
    return macroexpand(join([__form3[1]], __body30));
  } else {
    return macroexpand(["no", join([__form3], __body30)]);
  }
}});
setenv("expansion", {_stash: true, transformer: function(__x278) {
  var ____id41 = __x278;
  var ____id42 = ____id41[0];
  var __expansion = ____id42[0];
  var __form4 = ____id41[1];
  return __form4;
}});
setenv("hd", {_stash: true, ["place-expander"]: function(setfn, ..._42args) {
  var ____r61 = unstash([..._42args]);
  var __setfn1 = destash33(setfn, ____r61);
  var ____id44 = ____r61;
  var __args7 = cut(____id44, 0);
  return define_setter("hd", function(v, l) {
  return ["set", ["at", l, 0], v];
}, __setfn1, __args7);
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
  if (!__ok) {
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
    if (!(__form === __more)) {
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
  return string63(path) && !("-" === char(path, 0) || ".js" === clip(path, _35(path) - 3) || ".lua" === clip(path, _35(path) - 4));
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
