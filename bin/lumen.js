environment = [{}];
target = "js";
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
nan = 0 / 0;
inf = 1 / 0;
_inf = - inf;
nan63 = function (n) {
  return !( n === n);
};
inf63 = function (n) {
  return n === inf || n === _inf;
};
clip = function (s, from, upto) {
  return s.substring(from, upto);
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
  var __i = __e3;
  var __n = _35(x);
  var __e4 = undefined;
  if (nil63(upto) || upto > __n) {
    __e4 = __n;
  } else {
    __e4 = upto;
  }
  var __upto = __e4;
  while (__i < __upto) {
    __l[__j] = x[__i];
    __i = __i + 1;
    __j = __j + 1;
  }
  var ____o = x;
  var __k = undefined;
  for (__k in ____o) {
    var __v = ____o[__k];
    var __e5 = undefined;
    if (numeric63(__k)) {
      __e5 = parseInt(__k);
    } else {
      __e5 = __k;
    }
    var __k1 = __e5;
    if (! number63(__k1)) {
      __l[__k1] = __v;
    }
  }
  return __l;
};
keys = function (x) {
  var __t = [];
  var ____o1 = x;
  var __k2 = undefined;
  for (__k2 in ____o1) {
    var __v1 = ____o1[__k2];
    var __e6 = undefined;
    if (numeric63(__k2)) {
      __e6 = parseInt(__k2);
    } else {
      __e6 = __k2;
    }
    var __k3 = __e6;
    if (! number63(__k3)) {
      __t[__k3] = __v1;
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
  var __i3 = edge(l);
  while (__i3 >= 0) {
    add(__l1, l[__i3]);
    __i3 = __i3 - 1;
  }
  return __l1;
};
reduce = function (f, x) {
  if (none63(x)) {
    return undefined;
  } else {
    if (one63(x)) {
      return hd(x);
    } else {
      return f(hd(x), reduce(f, tl(x)));
    }
  }
};
join = function (..._42args) {
  var __ls = unstash([..._42args]);
  var __r39 = [];
  var ____x2 = __ls;
  var ____i4 = 0;
  while (____i4 < _35(____x2)) {
    var __l11 = ____x2[____i4];
    if (__l11) {
      var __n3 = _35(__r39);
      var ____o2 = __l11;
      var __k4 = undefined;
      for (__k4 in ____o2) {
        var __v2 = ____o2[__k4];
        var __e7 = undefined;
        if (numeric63(__k4)) {
          __e7 = parseInt(__k4);
        } else {
          __e7 = __k4;
        }
        var __k5 = __e7;
        if (number63(__k5)) {
          __k5 = __k5 + __n3;
        }
        __r39[__k5] = __v2;
      }
    }
    ____i4 = ____i4 + 1;
  }
  return __r39;
};
testify = function (x, test) {
  if (function63(x)) {
    return x;
  } else {
    if (test) {
      return function (y) {
        return test(x, y);
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
  var ____o3 = t;
  var ____i6 = undefined;
  for (____i6 in ____o3) {
    var __x3 = ____o3[____i6];
    var __e8 = undefined;
    if (numeric63(____i6)) {
      __e8 = parseInt(____i6);
    } else {
      __e8 = ____i6;
    }
    var ____i61 = __e8;
    var __y = __f(__x3);
    if (__y) {
      return __y;
    }
  }
};
first = function (x, l, pos) {
  var __f1 = testify(x);
  var __i7 = either(pos, 0);
  var __n6 = -1;
  var ____o4 = l;
  var __k6 = undefined;
  for (__k6 in ____o4) {
    var __v3 = ____o4[__k6];
    var __e9 = undefined;
    if (numeric63(__k6)) {
      __e9 = parseInt(__k6);
    } else {
      __e9 = __k6;
    }
    var __k7 = __e9;
    if (number63(__k7)) {
      __n6 = max(__n6, __k7);
    }
  }
  __n6 = __n6 + 1;
  while (__i7 < __n6) {
    var __v4 = l[__i7];
    var ____y1 = __f1(__v4);
    if (yes(____y1)) {
      var __y2 = ____y1;
      return __i7;
    }
    __i7 = __i7 + 1;
  }
};
in63 = function (x, t) {
  return find(testify(x), t);
};
pair = function (l) {
  var __l12 = [];
  var __i9 = 0;
  while (__i9 < _35(l)) {
    add(__l12, [l[__i9], l[__i9 + 1]]);
    __i9 = __i9 + 1;
    __i9 = __i9 + 1;
  }
  return __l12;
};
sort = function (l, f) {
  var __e10 = undefined;
  if (f) {
    __e10 = function (a, b) {
      if (f(a, b)) {
        return -1;
      } else {
        return 1;
      }
    };
  }
  return l.sort(__e10);
};
map = function (f, x) {
  var __t1 = [];
  var ____x5 = x;
  var ____i10 = 0;
  while (____i10 < _35(____x5)) {
    var __v5 = ____x5[____i10];
    var __y3 = f(__v5);
    if (is63(__y3)) {
      add(__t1, __y3);
    }
    ____i10 = ____i10 + 1;
  }
  var ____o5 = x;
  var __k8 = undefined;
  for (__k8 in ____o5) {
    var __v6 = ____o5[__k8];
    var __e11 = undefined;
    if (numeric63(__k8)) {
      __e11 = parseInt(__k8);
    } else {
      __e11 = __k8;
    }
    var __k9 = __e11;
    if (! number63(__k9)) {
      var __y4 = f(__v6);
      if (is63(__y4)) {
        __t1[__k9] = __y4;
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
  var ____o6 = t;
  var __k10 = undefined;
  for (__k10 in ____o6) {
    var __v7 = ____o6[__k10];
    var __e12 = undefined;
    if (numeric63(__k10)) {
      __e12 = parseInt(__k10);
    } else {
      __e12 = __k10;
    }
    var __k11 = __e12;
    if (! number63(__k11)) {
      return true;
    }
  }
  return false;
};
empty63 = function (t) {
  var ____o7 = t;
  var ____i13 = undefined;
  for (____i13 in ____o7) {
    var __x6 = ____o7[____i13];
    var __e13 = undefined;
    if (numeric63(____i13)) {
      __e13 = parseInt(____i13);
    } else {
      __e13 = ____i13;
    }
    var ____i131 = __e13;
    return false;
  }
  return true;
};
stash = function (args) {
  if (keys63(args)) {
    var __p = [];
    var ____o8 = args;
    var __k12 = undefined;
    for (__k12 in ____o8) {
      var __v8 = ____o8[__k12];
      var __e14 = undefined;
      if (numeric63(__k12)) {
        __e14 = parseInt(__k12);
      } else {
        __e14 = __k12;
      }
      var __k13 = __e14;
      if (! number63(__k13)) {
        __p[__k13] = __v8;
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
      var ____o9 = __l2;
      var __k14 = undefined;
      for (__k14 in ____o9) {
        var __v9 = ____o9[__k14];
        var __e15 = undefined;
        if (numeric63(__k14)) {
          __e15 = parseInt(__k14);
        } else {
          __e15 = __k14;
        }
        var __k15 = __e15;
        if (!( __k15 === "_stash")) {
          __args1[__k15] = __v9;
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
    var ____o10 = l;
    var __k16 = undefined;
    for (__k16 in ____o10) {
      var __v10 = ____o10[__k16];
      var __e16 = undefined;
      if (numeric63(__k16)) {
        __e16 = parseInt(__k16);
      } else {
        __e16 = __k16;
      }
      var __k17 = __e16;
      if (!( __k17 === "_stash")) {
        args1[__k17] = __v10;
      }
    }
  } else {
    return l;
  }
};
search = function (s, pattern, start) {
  var __i17 = s.indexOf(pattern, start);
  if (__i17 >= 0) {
    return __i17;
  }
};
split = function (s, sep) {
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
cat = function (..._42args) {
  var __xs = unstash([..._42args]);
  return either(reduce(function (a, b) {
    return a + b;
  }, __xs), "");
};
_43 = function (..._42args) {
  var __xs1 = unstash([..._42args]);
  return either(reduce(function (a, b) {
    return a + b;
  }, __xs1), 0);
};
_45 = function (..._42args) {
  var __xs2 = unstash([..._42args]);
  return either(reduce(function (b, a) {
    return a - b;
  }, reverse(__xs2)), 0);
};
_42 = function (..._42args) {
  var __xs3 = unstash([..._42args]);
  return either(reduce(function (a, b) {
    return a * b;
  }, __xs3), 1);
};
_47 = function (..._42args) {
  var __xs4 = unstash([..._42args]);
  return either(reduce(function (b, a) {
    return a / b;
  }, reverse(__xs4)), 1);
};
_37 = function (..._42args) {
  var __xs5 = unstash([..._42args]);
  return either(reduce(function (b, a) {
    return a % b;
  }, reverse(__xs5)), 0);
};
var pairwise = function (f, xs) {
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
_60 = function (..._42args) {
  var __xs6 = unstash([..._42args]);
  return pairwise(function (a, b) {
    return a < b;
  }, __xs6);
};
_62 = function (..._42args) {
  var __xs7 = unstash([..._42args]);
  return pairwise(function (a, b) {
    return a > b;
  }, __xs7);
};
_61 = function (..._42args) {
  var __xs8 = unstash([..._42args]);
  return pairwise(function (a, b) {
    return a === b;
  }, __xs8);
};
_6061 = function (..._42args) {
  var __xs9 = unstash([..._42args]);
  return pairwise(function (a, b) {
    return a <= b;
  }, __xs9);
};
_6261 = function (..._42args) {
  var __xs10 = unstash([..._42args]);
  return pairwise(function (a, b) {
    return a >= b;
  }, __xs10);
};
number = function (s) {
  var __n15 = parseFloat(s);
  if (! isNaN(__n15)) {
    return __n15;
  }
};
number_code63 = function (n) {
  return n > 47 && n < 58;
};
numeric63 = function (s) {
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
lowercase_code63 = function (n) {
  return n > 96 && n < 123;
};
camel_case = function (str) {
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
var tostring = function (x) {
  return x.toString();
};
escape = function (s) {
  var __s1 = "\"";
  var __i22 = 0;
  while (__i22 < _35(s)) {
    var __c1 = char(s, __i22);
    var __e17 = undefined;
    if (__c1 === "\n") {
      __e17 = "\\n";
    } else {
      var __e18 = undefined;
      if (__c1 === "\r") {
        __e18 = "\\r";
      } else {
        var __e19 = undefined;
        if (__c1 === "\"") {
          __e19 = "\\\"";
        } else {
          var __e20 = undefined;
          if (__c1 === "\\") {
            __e20 = "\\\\";
          } else {
            __e20 = __c1;
          }
          __e19 = __e20;
        }
        __e18 = __e19;
      }
      __e17 = __e18;
    }
    var __c11 = __e17;
    __s1 = __s1 + __c11;
    __i22 = __i22 + 1;
  }
  return __s1 + "\"";
};
str = function (x, stack) {
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
                      var __xs11 = [];
                      var __ks = [];
                      var __l4 = stack || [];
                      add(__l4, x);
                      var ____o11 = x;
                      var __k18 = undefined;
                      for (__k18 in ____o11) {
                        var __v11 = ____o11[__k18];
                        var __e21 = undefined;
                        if (numeric63(__k18)) {
                          __e21 = parseInt(__k18);
                        } else {
                          __e21 = __k18;
                        }
                        var __k19 = __e21;
                        if (number63(__k19)) {
                          __xs11[__k19] = str(__v11, __l4);
                        } else {
                          add(__ks, __k19 + ":");
                          add(__ks, str(__v11, __l4));
                        }
                      }
                      drop(__l4);
                      var ____o12 = join(__xs11, __ks);
                      var ____i24 = undefined;
                      for (____i24 in ____o12) {
                        var __v12 = ____o12[____i24];
                        var __e22 = undefined;
                        if (numeric63(____i24)) {
                          __e22 = parseInt(____i24);
                        } else {
                          __e22 = ____i24;
                        }
                        var ____i241 = __e22;
                        __s11 = __s11 + __sp + __v12;
                        __sp = " ";
                      }
                      return __s11 + ")";
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
apply = function (f, args) {
  var __args = stash(args);
  return f.apply(f, __args);
};
call = function (f, ..._42args) {
  var ____r80 = unstash([..._42args]);
  var __f3 = destash33(f, ____r80);
  var ____id = ____r80;
  var __args11 = cut(____id, 0);
  return apply(__f3, __args11);
};
setenv = function (k, ..._42args) {
  var ____r81 = unstash([..._42args]);
  var __k20 = destash33(k, ____r81);
  var ____id1 = ____r81;
  var __keys = cut(____id1, 0);
  if (string63(__k20)) {
    var __e23 = undefined;
    if (__keys.toplevel) {
      __e23 = hd(environment);
    } else {
      __e23 = last(environment);
    }
    var __frame = __e23;
    var __entry = __frame[__k20] || {};
    var ____o13 = __keys;
    var __k21 = undefined;
    for (__k21 in ____o13) {
      var __v13 = ____o13[__k21];
      var __e24 = undefined;
      if (numeric63(__k21)) {
        __e24 = parseInt(__k21);
      } else {
        __e24 = __k21;
      }
      var __k22 = __e24;
      __entry[__k22] = __v13;
    }
    __frame[__k20] = __entry;
    return __frame[__k20];
  }
};
print = function (x) {
  return console.log(x);
};
error = function (x) {
  throw new Error(x);
};
var math = Math;
abs = math.abs;
acos = math.acos;
asin = math.asin;
atan = math.atan;
atan2 = math.atan2;
ceil = math.ceil;
cos = math.cos;
floor = math.floor;
log = math.log;
log10 = math.log10;
max = math.max;
min = math.min;
pow = math.pow;
random = math.random;
sin = math.sin;
sinh = math.sinh;
sqrt = math.sqrt;
tan = math.tan;
tanh = math.tanh;
trunc = math.floor;
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
setenv("quote", {_stash: true, macro: function (form) {
  return quoted(form);
}});
setenv("quasiquote", {_stash: true, macro: function (form) {
  return quasiexpand(form, 1);
}});
setenv("set", {_stash: true, macro: function (..._42args) {
  var __args1 = unstash([..._42args]);
  return join(["do"], map(function (__x8) {
    var ____id1 = __x8;
    var __lh1 = ____id1[0];
    var __rh1 = ____id1[1];
    return ["%set", __lh1, __rh1];
  }, pair(__args1)));
}});
setenv("at", {_stash: true, macro: function (l, i) {
  if (target === "lua" && number63(i)) {
    i = i + 1;
  } else {
    if (target === "lua") {
      i = ["+", i, 1];
    }
  }
  return ["get", l, i];
}});
setenv("wipe", {_stash: true, macro: function (place) {
  if (target === "lua") {
    return ["set", place, "nil"];
  } else {
    return ["%delete", place];
  }
}});
setenv("list", {_stash: true, macro: function (..._42args) {
  var __body1 = unstash([..._42args]);
  var __x28 = unique("x");
  var __l1 = [];
  var __forms1 = [];
  var ____o1 = __body1;
  var __k2 = undefined;
  for (__k2 in ____o1) {
    var __v1 = ____o1[__k2];
    var __e7 = undefined;
    if (numeric63(__k2)) {
      __e7 = parseInt(__k2);
    } else {
      __e7 = __k2;
    }
    var __k3 = __e7;
    if (number63(__k3)) {
      __l1[__k3] = __v1;
    } else {
      add(__forms1, ["set", ["get", __x28, ["quote", __k3]], __v1]);
    }
  }
  if (some63(__forms1)) {
    return join(["let", __x28, join(["%array"], __l1)], __forms1, [__x28]);
  } else {
    return join(["%array"], __l1);
  }
}});
setenv("if", {_stash: true, macro: function (..._42args) {
  var __branches1 = unstash([..._42args]);
  return hd(expand_if(__branches1));
}});
setenv("case", {_stash: true, macro: function (expr, ..._42args) {
  var ____r15 = unstash([..._42args]);
  var __expr1 = destash33(expr, ____r15);
  var ____id4 = ____r15;
  var __clauses1 = cut(____id4, 0);
  var __x51 = unique("x");
  var __eq1 = function (_) {
    return ["=", ["quote", _], __x51];
  };
  var __cl1 = function (__x54) {
    var ____id5 = __x54;
    var __a1 = ____id5[0];
    var __b1 = ____id5[1];
    if (nil63(__b1)) {
      return [__a1];
    } else {
      if (string63(__a1) || number63(__a1)) {
        return [__eq1(__a1), __b1];
      } else {
        if (one63(__a1)) {
          return [__eq1(hd(__a1)), __b1];
        } else {
          if (_35(__a1) > 1) {
            return [join(["or"], map(__eq1, __a1)), __b1];
          }
        }
      }
    }
  };
  return ["let", __x51, __expr1, join(["if"], apply(join, map(__cl1, pair(__clauses1))))];
}});
setenv("when", {_stash: true, macro: function (cond, ..._42args) {
  var ____r19 = unstash([..._42args]);
  var __cond1 = destash33(cond, ____r19);
  var ____id7 = ____r19;
  var __body3 = cut(____id7, 0);
  return ["if", __cond1, join(["do"], __body3)];
}});
setenv("unless", {_stash: true, macro: function (cond, ..._42args) {
  var ____r21 = unstash([..._42args]);
  var __cond3 = destash33(cond, ____r21);
  var ____id9 = ____r21;
  var __body5 = cut(____id9, 0);
  return ["if", ["not", __cond3], join(["do"], __body5)];
}});
setenv("obj", {_stash: true, macro: function (..._42args) {
  var __body7 = unstash([..._42args]);
  return join(["%object"], mapo(function (x) {
    return x;
  }, __body7));
}});
setenv("let", {_stash: true, macro: function (bs, ..._42args) {
  var ____r25 = unstash([..._42args]);
  var __bs11 = destash33(bs, ____r25);
  var ____id14 = ____r25;
  var __body9 = cut(____id14, 0);
  if (atom63(__bs11)) {
    return join(["let", [__bs11, hd(__body9)]], tl(__body9));
  } else {
    if (none63(__bs11)) {
      return join(["do"], __body9);
    } else {
      var ____id15 = __bs11;
      var __lh3 = ____id15[0];
      var __rh3 = ____id15[1];
      var __bs21 = cut(____id15, 2);
      var ____id16 = bind(__lh3, __rh3);
      var __id17 = ____id16[0];
      var __val1 = ____id16[1];
      var __bs12 = cut(____id16, 2);
      var __id121 = unique(__id17);
      return ["do", ["%local", __id121, __val1], ["let-symbol", [__id17, __id121], join(["let", join(__bs12, __bs21)], __body9)]];
    }
  }
}});
setenv("with", {_stash: true, macro: function (x, v, ..._42args) {
  var ____r27 = unstash([..._42args]);
  var __x104 = destash33(x, ____r27);
  var __v3 = destash33(v, ____r27);
  var ____id19 = ____r27;
  var __body11 = cut(____id19, 0);
  return join(["let", [__x104, __v3]], __body11, [__x104]);
}});
setenv("let-when", {_stash: true, macro: function (x, v, ..._42args) {
  var ____r29 = unstash([..._42args]);
  var __x116 = destash33(x, ____r29);
  var __v5 = destash33(v, ____r29);
  var ____id21 = ____r29;
  var __body13 = cut(____id21, 0);
  var __y1 = unique("y");
  return ["let", __y1, __v5, ["when", ["yes", __y1], join(["let", [__x116, __y1]], __body13)]];
}});
setenv("define-macro", {_stash: true, macro: function (name, args, ..._42args) {
  var ____r31 = unstash([..._42args]);
  var __name1 = destash33(name, ____r31);
  var __args3 = destash33(args, ____r31);
  var ____id23 = ____r31;
  var __body15 = cut(____id23, 0);
  var ____x127 = ["setenv", ["quote", __name1]];
  ____x127.macro = join(["fn", __args3], __body15);
  var __form1 = ____x127;
  _eval(__form1);
  return __form1;
}});
setenv("define-special", {_stash: true, macro: function (name, args, ..._42args) {
  var ____r33 = unstash([..._42args]);
  var __name3 = destash33(name, ____r33);
  var __args5 = destash33(args, ____r33);
  var ____id25 = ____r33;
  var __body17 = cut(____id25, 0);
  var ____x135 = ["setenv", ["quote", __name3]];
  ____x135.special = join(["fn", __args5], __body17);
  var __form3 = join(____x135, keys(__body17));
  _eval(__form3);
  return __form3;
}});
setenv("define-symbol", {_stash: true, macro: function (name, expansion) {
  setenv(name, {_stash: true, symbol: expansion});
  var ____x141 = ["setenv", ["quote", name]];
  ____x141.symbol = ["quote", expansion];
  return ____x141;
}});
setenv("define-reader", {_stash: true, macro: function (__x150, ..._42args) {
  var ____id28 = __x150;
  var __char1 = ____id28[0];
  var __s1 = ____id28[1];
  var ____r37 = unstash([..._42args]);
  var ____x150 = destash33(__x150, ____r37);
  var ____id29 = ____r37;
  var __body19 = cut(____id29, 0);
  return ["set", ["get", "read-table", __char1], join(["fn", [__s1]], __body19)];
}});
setenv("define", {_stash: true, macro: function (name, x, ..._42args) {
  var ____r39 = unstash([..._42args]);
  var __name5 = destash33(name, ____r39);
  var __x161 = destash33(x, ____r39);
  var ____id31 = ____r39;
  var __body21 = cut(____id31, 0);
  setenv(__name5, {_stash: true, variable: true});
  if (some63(__body21)) {
    return join(["%local-function", __name5], bind42(__x161, __body21));
  } else {
    return ["%local", __name5, __x161];
  }
}});
setenv("define-global", {_stash: true, macro: function (name, x, ..._42args) {
  var ____r41 = unstash([..._42args]);
  var __name7 = destash33(name, ____r41);
  var __x169 = destash33(x, ____r41);
  var ____id33 = ____r41;
  var __body23 = cut(____id33, 0);
  setenv(__name7, {_stash: true, toplevel: true, variable: true});
  if (some63(__body23)) {
    return join(["%global-function", __name7], bind42(__x169, __body23));
  } else {
    return ["set", __name7, __x169];
  }
}});
setenv("with-frame", {_stash: true, macro: function (..._42args) {
  var __body25 = unstash([..._42args]);
  var __x181 = unique("x");
  return ["do", ["add", "environment", ["obj"]], ["with", __x181, join(["do"], __body25), ["drop", "environment"]]];
}});
setenv("with-bindings", {_stash: true, macro: function (__x194, ..._42args) {
  var ____id36 = __x194;
  var __names1 = ____id36[0];
  var ____r43 = unstash([..._42args]);
  var ____x194 = destash33(__x194, ____r43);
  var ____id37 = ____r43;
  var __body27 = cut(____id37, 0);
  var __x196 = unique("x");
  var ____x199 = ["setenv", __x196];
  ____x199.variable = true;
  return join(["with-frame", ["each", __x196, __names1, ____x199]], __body27);
}});
setenv("let-macro", {_stash: true, macro: function (definitions, ..._42args) {
  var ____r46 = unstash([..._42args]);
  var __definitions1 = destash33(definitions, ____r46);
  var ____id39 = ____r46;
  var __body29 = cut(____id39, 0);
  add(environment, {});
  map(function (m) {
    return macroexpand(join(["define-macro"], m));
  }, __definitions1);
  var ____x205 = join(["do"], macroexpand(__body29));
  drop(environment);
  return ____x205;
}});
setenv("let-symbol", {_stash: true, macro: function (expansions, ..._42args) {
  var ____r50 = unstash([..._42args]);
  var __expansions1 = destash33(expansions, ____r50);
  var ____id42 = ____r50;
  var __body31 = cut(____id42, 0);
  add(environment, {});
  map(function (__x215) {
    var ____id43 = __x215;
    var __name9 = ____id43[0];
    var __exp1 = ____id43[1];
    return macroexpand(["define-symbol", __name9, __exp1]);
  }, pair(__expansions1));
  var ____x214 = join(["do"], macroexpand(__body31));
  drop(environment);
  return ____x214;
}});
setenv("let-unique", {_stash: true, macro: function (names, ..._42args) {
  var ____r54 = unstash([..._42args]);
  var __names3 = destash33(names, ____r54);
  var ____id45 = ____r54;
  var __body33 = cut(____id45, 0);
  var __bs3 = map(function (n) {
    return [n, ["unique", ["quote", n]]];
  }, __names3);
  return join(["let", apply(join, __bs3)], __body33);
}});
setenv("fn", {_stash: true, macro: function (args, ..._42args) {
  var ____r57 = unstash([..._42args]);
  var __args7 = destash33(args, ____r57);
  var ____id47 = ____r57;
  var __body35 = cut(____id47, 0);
  return join(["%function"], bind42(__args7, __body35));
}});
setenv("apply", {_stash: true, macro: function (f, ..._42args) {
  var ____r59 = unstash([..._42args]);
  var __f1 = destash33(f, ____r59);
  var ____id49 = ____r59;
  var __args9 = cut(____id49, 0);
  if (_35(__args9) > 1) {
    return ["%call", "apply", __f1, ["join", join(["list"], almost(__args9)), last(__args9)]];
  } else {
    return join(["%call", "apply", __f1], __args9);
  }
}});
setenv("guard", {_stash: true, macro: function (expr) {
  if (target === "js") {
    return [["fn", join(), ["%try", ["list", true, expr]]]];
  } else {
    var ____x276 = ["obj"];
    ____x276.stack = [["get", "debug", ["quote", "traceback"]]];
    ____x276.message = ["if", ["string?", "m"], ["clip", "m", ["+", ["or", ["search", "m", "\": \""], -2], 2]], ["nil?", "m"], "\"\"", ["str", "m"]];
    return ["list", ["xpcall", ["fn", join(), expr], ["fn", ["m"], ["if", ["obj?", "m"], "m", ____x276]]]];
  }
}});
setenv("each", {_stash: true, macro: function (x, t, ..._42args) {
  var ____r63 = unstash([..._42args]);
  var __x304 = destash33(x, ____r63);
  var __t1 = destash33(t, ____r63);
  var ____id52 = ____r63;
  var __body37 = cut(____id52, 0);
  var __o3 = unique("o");
  var __n3 = unique("n");
  var __i3 = unique("i");
  var __e8 = undefined;
  if (atom63(__x304)) {
    __e8 = [__i3, __x304];
  } else {
    var __e9 = undefined;
    if (_35(__x304) > 1) {
      __e9 = __x304;
    } else {
      __e9 = [__i3, hd(__x304)];
    }
    __e8 = __e9;
  }
  var ____id53 = __e8;
  var __k5 = ____id53[0];
  var __v7 = ____id53[1];
  var __e10 = undefined;
  if (target === "lua") {
    __e10 = __body37;
  } else {
    __e10 = [join(["let", __k5, ["if", ["numeric?", __k5], ["parseInt", __k5], __k5]], __body37)];
  }
  return ["let", [__o3, __t1, __k5, "nil"], ["%for", __o3, __k5, join(["let", [__v7, ["get", __o3, __k5]]], __e10)]];
}});
setenv("for", {_stash: true, macro: function (i, to, ..._42args) {
  var ____r65 = unstash([..._42args]);
  var __i5 = destash33(i, ____r65);
  var __to1 = destash33(to, ____r65);
  var ____id55 = ____r65;
  var __body39 = cut(____id55, 0);
  return ["let", __i5, 0, join(["while", ["<", __i5, __to1]], __body39, [["inc", __i5]])];
}});
setenv("step", {_stash: true, macro: function (v, t, ..._42args) {
  var ____r67 = unstash([..._42args]);
  var __v9 = destash33(v, ____r67);
  var __t3 = destash33(t, ____r67);
  var ____id57 = ____r67;
  var __body41 = cut(____id57, 0);
  var __x340 = unique("x");
  var __i7 = unique("i");
  return ["let", [__x340, __t3], ["for", __i7, ["#", __x340], join(["let", [__v9, ["at", __x340, __i7]]], __body41)]];
}});
setenv("set-of", {_stash: true, macro: function (..._42args) {
  var __xs1 = unstash([..._42args]);
  var __l3 = [];
  var ____o5 = __xs1;
  var ____i9 = undefined;
  for (____i9 in ____o5) {
    var __x352 = ____o5[____i9];
    var __e11 = undefined;
    if (numeric63(____i9)) {
      __e11 = parseInt(____i9);
    } else {
      __e11 = ____i9;
    }
    var ____i91 = __e11;
    __l3[__x352] = true;
  }
  return join(["obj"], __l3);
}});
setenv("language", {_stash: true, macro: function () {
  return ["quote", target];
}});
setenv("target", {_stash: true, macro: function (..._42args) {
  var __clauses3 = unstash([..._42args]);
  return __clauses3[target];
}});
setenv("join!", {_stash: true, macro: function (a, ..._42args) {
  var ____r71 = unstash([..._42args]);
  var __a3 = destash33(a, ____r71);
  var ____id59 = ____r71;
  var __bs5 = cut(____id59, 0);
  return ["set", __a3, join(["join", __a3], __bs5)];
}});
setenv("cat!", {_stash: true, macro: function (a, ..._42args) {
  var ____r73 = unstash([..._42args]);
  var __a5 = destash33(a, ____r73);
  var ____id61 = ____r73;
  var __bs7 = cut(____id61, 0);
  return ["set", __a5, join(["cat", __a5], __bs7)];
}});
setenv("inc", {_stash: true, macro: function (n, by) {
  var __e12 = undefined;
  if (nil63(by)) {
    __e12 = 1;
  } else {
    __e12 = by;
  }
  return ["set", n, ["+", n, __e12]];
}});
setenv("dec", {_stash: true, macro: function (n, by) {
  var __e13 = undefined;
  if (nil63(by)) {
    __e13 = 1;
  } else {
    __e13 = by;
  }
  return ["set", n, ["-", n, __e13]];
}});
setenv("with-indent", {_stash: true, macro: function (form) {
  var __x383 = unique("x");
  return ["do", ["inc", "indent-level"], ["with", __x383, form, ["dec", "indent-level"]]];
}});
setenv("undefined?", {_stash: true, macro: function (x) {
  var ____x392 = ["target"];
  ____x392.lua = ["=", x, "nil"];
  ____x392.js = ["=", ["typeof", x], "\"undefined\""];
  return ____x392;
}});
setenv("export", {_stash: true, macro: function (..._42args) {
  var __names5 = unstash([..._42args]);
  var ____x414 = ["target"];
  ____x414.lua = ["return", "exports"];
  return join(["with", "exports", ["if", ["undefined?", "exports"], ["obj"], "exports"]], map(function (k) {
    return ["set", ["exports", "." + k], k];
  }, __names5), [____x414]);
}});
setenv("when-compiling", {_stash: true, macro: function (..._42args) {
  var __body43 = unstash([..._42args]);
  return _eval(join(["do"], __body43));
}});
setenv("during-compilation", {_stash: true, macro: function (..._42args) {
  var __body45 = unstash([..._42args]);
  var __form5 = join(["do"], __body45);
  _eval(__form5);
  return __form5;
}});
var reader = require("./reader");
var compiler = require("./compiler");
var system = require("./system");
var eval_print = function (form) {
  var ____id = (function () {
    try {
      return [true, compiler._eval(form)];
    }
    catch (__e4) {
      return [false, __e4];
    }
  })();
  var __ok = ____id[0];
  var __v = ____id[1];
  if (! __ok) {
    return print(__v.stack);
  } else {
    if (is63(__v)) {
      return print(str(__v));
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
  var ___in = process.stdin;
  ___in.setEncoding("utf8");
  return ___in.on("data", rep1);
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
_load = function (path) {
  var __previous = target;
  target = "js";
  var __code = compile_file(path);
  target = __previous;
  return compiler.run(__code);
};
script_file63 = function (path) {
  return string63(path) && !( "-" === char(path, 0) || ".js" === clip(path, _35(path) - 3) || ".lua" === clip(path, _35(path) - 4));
};
run_file = function (path) {
  if (script_file63(path)) {
    return _load(path);
  } else {
    return compiler.run(read_file(path));
  }
};
read_from_string = function (str, start, _end) {
  var __s1 = reader.stream(str);
  __s1.pos = either(start, __s1.pos);
  __s1.len = either(_end, __s1.len);
  var __form2 = reader.read(__s1);
  if (nil63(__form2)) {
    return error("End of string during parsing");
  } else {
    var ____x2 = [__form2];
    ____x2.rest = __s1.pos;
    return ____x2;
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
      catch (__e5) {
        return [false, __e5];
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
                      for (__k in ____o) {
                        var __v2 = ____o[__k];
                        var __e1 = undefined;
                        if (numeric63(__k)) {
                          __e1 = parseInt(__k);
                        } else {
                          __e1 = __k;
                        }
                        var __k1 = __e1;
                        if (number63(__k1)) {
                          __xs[__k1] = pp_to_string(__v2, __l);
                        } else {
                          add(__ks, __k1 + ":");
                          add(__ks, pp_to_string(__v2, __l));
                        }
                      }
                      drop(__l);
                      var ____o1 = join(__xs, __ks);
                      var ____i1 = undefined;
                      for (____i1 in ____o1) {
                        var __v3 = ____o1[____i1];
                        var __e2 = undefined;
                        if (numeric63(____i1)) {
                          __e2 = parseInt(____i1);
                        } else {
                          __e2 = ____i1;
                        }
                        var ____i11 = __e2;
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
  argv = argv || get_argv();
  var __arg = hd(argv);
  if (script_file63(__arg)) {
    set_argv(tl(argv));
    return _load(__arg);
  }
  var __args = parse_arguments({c: "compile", o: "output", t: "target", e: "eval", h: "help", r: "repl"}, argv);
  if (script_file63(hd(__args))) {
    return _load(hd(__args));
  } else {
    if (__args.help) {
      return print(usage());
    } else {
      var __pre = keep(string63, __args);
      var __cmds = keep(obj63, __args);
      var __input = "";
      var __enter_repl = true;
      var ____x4 = __pre;
      var ____i2 = 0;
      while (____i2 < _35(____x4)) {
        var __file = ____x4[____i2];
        run_file(__file);
        ____i2 = ____i2 + 1;
      }
      var ____x5 = __cmds;
      var ____i3 = 0;
      while (____i3 < _35(____x5)) {
        var ____id2 = ____x5[____i3];
        var __a = ____id2[0];
        var __val = ____id2[1];
        if (__a === "target") {
          target = hd(__val);
          break;
        }
        ____i3 = ____i3 + 1;
      }
      var ____x6 = __cmds;
      var ____i4 = 0;
      while (____i4 < _35(____x6)) {
        var ____id3 = ____x6[____i4];
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
                var ____x7 = __val1;
                var ____i5 = 0;
                while (____i5 < _35(____x7)) {
                  var __x8 = ____x7[____i5];
                  __input = __input + compile_file(__x8);
                  ____i5 = ____i5 + 1;
                }
                __enter_repl = false;
              } else {
                if (__a1 === "output") {
                  write_file(hd(__val1), __input);
                  __input = "";
                } else {
                  if (__a1 === "target") {
                    target = hd(__val1);
                  } else {
                    if (__a1 === "eval") {
                      var ____x9 = __val1;
                      var ____i6 = 0;
                      while (____i6 < _35(____x9)) {
                        var __x10 = ____x9[____i6];
                        rep(__x10);
                        ____i6 = ____i6 + 1;
                      }
                      __enter_repl = false;
                    }
                  }
                }
              }
            }
          }
        }
        ____i4 = ____i4 + 1;
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
var __e3 = undefined;
if (typeof(exports) === "undefined") {
  __e3 = {};
} else {
  __e3 = exports;
}
var __exports = __e3;
__exports.reader = reader;
__exports.compiler = compiler;
__exports.system = system;
__exports.main = main;
__exports;
