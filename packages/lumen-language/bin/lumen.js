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
  return obj63(l) && hd(l) === x;
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
  var __e = undefined;
  if (nil63(from) || from < 0) {
    __e = 0;
  } else {
    __e = from;
  }
  var __i = __e;
  var __n = _35(x);
  var __e1 = undefined;
  if (nil63(upto) || upto > __n) {
    __e1 = __n;
  } else {
    __e1 = upto;
  }
  var __upto = __e1;
  while (__i < __upto) {
    __l[__j] = x[__i];
    __i = __i + 1;
    __j = __j + 1;
  }
  var ____o = x;
  var __k = undefined;
  for (__k in ____o) {
    var __v = ____o[__k];
    var __e2 = undefined;
    if (numeric63(__k)) {
      __e2 = parseInt(__k);
    } else {
      __e2 = __k;
    }
    var __k1 = __e2;
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
    var __e3 = undefined;
    if (numeric63(__k2)) {
      __e3 = parseInt(__k2);
    } else {
      __e3 = __k2;
    }
    var __k3 = __e3;
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
  var ____r38 = unstash(_42args);
  var ___4242kwargs = destash(_42args);
  var ____id = ___4242kwargs;
  var ____id1 = ____r38;
  var __ls = cut(____id1, 0);
  var __r39 = [];
  var ____x1 = __ls;
  var ____i4 = 0;
  while (____i4 < _35(____x1)) {
    var __l11 = ____x1[____i4];
    if (__l11) {
      var __n3 = _35(__r39);
      var ____o2 = __l11;
      var __k4 = undefined;
      for (__k4 in ____o2) {
        var __v2 = ____o2[__k4];
        var __e4 = undefined;
        if (numeric63(__k4)) {
          __e4 = parseInt(__k4);
        } else {
          __e4 = __k4;
        }
        var __k5 = __e4;
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
find = function (f, t) {
  var ____o3 = t;
  var ____i6 = undefined;
  for (____i6 in ____o3) {
    var __x2 = ____o3[____i6];
    var __e5 = undefined;
    if (numeric63(____i6)) {
      __e5 = parseInt(____i6);
    } else {
      __e5 = ____i6;
    }
    var ____i61 = __e5;
    var __y = f(__x2);
    if (__y) {
      return __y;
    }
  }
};
first = function (f, l) {
  var ____x3 = l;
  var ____i7 = 0;
  while (____i7 < _35(____x3)) {
    var __x4 = ____x3[____i7];
    var __y1 = f(__x4);
    if (__y1) {
      return __y1;
    }
    ____i7 = ____i7 + 1;
  }
};
in63 = function (x, t) {
  return find(function (y) {
    return x === y;
  }, t);
};
pair = function (l) {
  var __l12 = [];
  var __i8 = 0;
  while (__i8 < _35(l)) {
    add(__l12, [l[__i8], l[__i8 + 1]]);
    __i8 = __i8 + 1;
    __i8 = __i8 + 1;
  }
  return __l12;
};
sort = function (l, f) {
  var __e6 = undefined;
  if (f) {
    __e6 = function (a, b) {
      if (f(a, b)) {
        return -1;
      } else {
        return 1;
      }
    };
  }
  return l.sort(__e6);
};
map = function (f, x) {
  var __t1 = [];
  var ____x6 = x;
  var ____i9 = 0;
  while (____i9 < _35(____x6)) {
    var __v3 = ____x6[____i9];
    var __y2 = f(__v3);
    if (is63(__y2)) {
      add(__t1, __y2);
    }
    ____i9 = ____i9 + 1;
  }
  var ____o4 = x;
  var __k6 = undefined;
  for (__k6 in ____o4) {
    var __v4 = ____o4[__k6];
    var __e7 = undefined;
    if (numeric63(__k6)) {
      __e7 = parseInt(__k6);
    } else {
      __e7 = __k6;
    }
    var __k7 = __e7;
    if (! number63(__k7)) {
      var __y3 = f(__v4);
      if (is63(__y3)) {
        __t1[__k7] = __y3;
      }
    }
  }
  return __t1;
};
keep = function (f, x) {
  return map(function (v) {
    if (yes(f(v))) {
      return v;
    }
  }, x);
};
keys63 = function (t) {
  var ____o5 = t;
  var __k8 = undefined;
  for (__k8 in ____o5) {
    var __v5 = ____o5[__k8];
    var __e8 = undefined;
    if (numeric63(__k8)) {
      __e8 = parseInt(__k8);
    } else {
      __e8 = __k8;
    }
    var __k9 = __e8;
    if (! number63(__k9)) {
      return true;
    }
  }
  return false;
};
empty63 = function (t) {
  var ____o6 = t;
  var ____i12 = undefined;
  for (____i12 in ____o6) {
    var __x7 = ____o6[____i12];
    var __e9 = undefined;
    if (numeric63(____i12)) {
      __e9 = parseInt(____i12);
    } else {
      __e9 = ____i12;
    }
    var ____i121 = __e9;
    return false;
  }
  return true;
};
stash = function (args) {
  if (keys63(args)) {
    var __p = [];
    var ____o7 = args;
    var __k10 = undefined;
    for (__k10 in ____o7) {
      var __v6 = ____o7[__k10];
      var __e10 = undefined;
      if (numeric63(__k10)) {
        __e10 = parseInt(__k10);
      } else {
        __e10 = __k10;
      }
      var __k11 = __e10;
      if (! number63(__k11)) {
        __p[__k11] = __v6;
      }
    }
    __p._stash = true;
    add(args, __p);
  }
  return args;
};
stash63 = function (x) {
  return obj63(x) && x._stash;
};
destash = function (args) {
  if (stash63(args)) {
    return args;
  } else {
    var __l2 = last(args);
    if (! stash63(__l2)) {
      __l2 = {};
      __l2._stash = true;
    }
    return __l2;
  }
};
astash = function (..._42args) {
  var __xs = _42args;
  var __n10 = _35(__xs);
  var __ks = drop(__xs);
  if (! stash63(__ks)) {
    if (!( __n10 === 0)) {
      add(__xs, __ks);
    }
    __ks = {};
    __ks._stash = true;
  }
  return [__xs, __ks];
};
unstash = function (args) {
  if (none63(args)) {
    return [];
  } else {
    var __l3 = last(args);
    if (obj63(__l3) && __l3._stash) {
      var __args1 = almost(args);
      var ____o8 = __l3;
      var __k12 = undefined;
      for (__k12 in ____o8) {
        var __v7 = ____o8[__k12];
        var __e11 = undefined;
        if (numeric63(__k12)) {
          __e11 = parseInt(__k12);
        } else {
          __e11 = __k12;
        }
        var __k13 = __e11;
        if (!( __k13 === "_stash")) {
          __args1[__k13] = __v7;
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
    var ____o9 = l;
    var __k14 = undefined;
    for (__k14 in ____o9) {
      var __v8 = ____o9[__k14];
      var __e12 = undefined;
      if (numeric63(__k14)) {
        __e12 = parseInt(__k14);
      } else {
        __e12 = __k14;
      }
      var __k15 = __e12;
      if (!( __k15 === "_stash")) {
        args1[__k15] = __v8;
      }
    }
  } else {
    return l;
  }
};
search = function (s, pattern, start) {
  var __i16 = s.indexOf(pattern, start);
  if (__i16 >= 0) {
    return __i16;
  }
};
split = function (s, sep) {
  if (s === "" || sep === "") {
    return [];
  } else {
    var __l4 = [];
    var __n13 = _35(sep);
    while (true) {
      var __i17 = search(s, sep);
      if (nil63(__i17)) {
        break;
      } else {
        add(__l4, clip(s, 0, __i17));
        s = clip(s, __i17 + __n13);
      }
    }
    add(__l4, s);
    return __l4;
  }
};
cat = function (..._42args) {
  var ____r59 = unstash(_42args);
  var ___4242kwargs1 = destash(_42args);
  var ____id2 = ___4242kwargs1;
  var ____id3 = ____r59;
  var __xs1 = cut(____id3, 0);
  return either(reduce(function (a, b) {
    return a + b;
  }, __xs1), "");
};
_43 = function (..._42args) {
  var ____r61 = unstash(_42args);
  var ___4242kwargs2 = destash(_42args);
  var ____id4 = ___4242kwargs2;
  var ____id5 = ____r61;
  var __xs2 = cut(____id5, 0);
  return either(reduce(function (a, b) {
    return a + b;
  }, __xs2), 0);
};
_45 = function (..._42args) {
  var ____r63 = unstash(_42args);
  var ___4242kwargs3 = destash(_42args);
  var ____id6 = ___4242kwargs3;
  var ____id7 = ____r63;
  var __xs3 = cut(____id7, 0);
  return either(reduce(function (b, a) {
    return a - b;
  }, reverse(__xs3)), 0);
};
_42 = function (..._42args) {
  var ____r65 = unstash(_42args);
  var ___4242kwargs4 = destash(_42args);
  var ____id8 = ___4242kwargs4;
  var ____id9 = ____r65;
  var __xs4 = cut(____id9, 0);
  return either(reduce(function (a, b) {
    return a * b;
  }, __xs4), 1);
};
_47 = function (..._42args) {
  var ____r67 = unstash(_42args);
  var ___4242kwargs5 = destash(_42args);
  var ____id10 = ___4242kwargs5;
  var ____id11 = ____r67;
  var __xs5 = cut(____id11, 0);
  return either(reduce(function (b, a) {
    return a / b;
  }, reverse(__xs5)), 1);
};
_37 = function (..._42args) {
  var ____r69 = unstash(_42args);
  var ___4242kwargs6 = destash(_42args);
  var ____id12 = ___4242kwargs6;
  var ____id13 = ____r69;
  var __xs6 = cut(____id13, 0);
  return either(reduce(function (b, a) {
    return a % b;
  }, reverse(__xs6)), 0);
};
var pairwise = function (f, xs) {
  var __i18 = 0;
  while (__i18 < edge(xs)) {
    var __a = xs[__i18];
    var __b = xs[__i18 + 1];
    if (! f(__a, __b)) {
      return false;
    }
    __i18 = __i18 + 1;
  }
  return true;
};
_60 = function (..._42args) {
  var ____r72 = unstash(_42args);
  var ___4242kwargs7 = destash(_42args);
  var ____id14 = ___4242kwargs7;
  var ____id15 = ____r72;
  var __xs7 = cut(____id15, 0);
  return pairwise(function (a, b) {
    return a < b;
  }, __xs7);
};
_62 = function (..._42args) {
  var ____r74 = unstash(_42args);
  var ___4242kwargs8 = destash(_42args);
  var ____id16 = ___4242kwargs8;
  var ____id17 = ____r74;
  var __xs8 = cut(____id17, 0);
  return pairwise(function (a, b) {
    return a > b;
  }, __xs8);
};
_61 = function (..._42args) {
  var ____r76 = unstash(_42args);
  var ___4242kwargs9 = destash(_42args);
  var ____id18 = ___4242kwargs9;
  var ____id19 = ____r76;
  var __xs9 = cut(____id19, 0);
  return pairwise(function (a, b) {
    return a === b;
  }, __xs9);
};
_6061 = function (..._42args) {
  var ____r78 = unstash(_42args);
  var ___4242kwargs10 = destash(_42args);
  var ____id20 = ___4242kwargs10;
  var ____id21 = ____r78;
  var __xs10 = cut(____id21, 0);
  return pairwise(function (a, b) {
    return a <= b;
  }, __xs10);
};
_6261 = function (..._42args) {
  var ____r80 = unstash(_42args);
  var ___4242kwargs11 = destash(_42args);
  var ____id22 = ___4242kwargs11;
  var ____id23 = ____r80;
  var __xs11 = cut(____id23, 0);
  return pairwise(function (a, b) {
    return a >= b;
  }, __xs11);
};
number = function (s) {
  var __n14 = parseFloat(s);
  if (! isNaN(__n14)) {
    return __n14;
  }
};
number_code63 = function (n) {
  return n > 47 && n < 58;
};
numeric63 = function (s) {
  var __n15 = _35(s);
  var __i19 = 0;
  while (__i19 < __n15) {
    if (! number_code63(code(s, __i19))) {
      return false;
    }
    __i19 = __i19 + 1;
  }
  return some63(s);
};
var tostring = function (x) {
  return x.toString();
};
escape = function (s) {
  var __s1 = "\"";
  var __i20 = 0;
  while (__i20 < _35(s)) {
    var __c = char(s, __i20);
    var __e13 = undefined;
    if (__c === "\n") {
      __e13 = "\\n";
    } else {
      var __e14 = undefined;
      if (__c === "\r") {
        __e14 = "\\r";
      } else {
        var __e15 = undefined;
        if (__c === "\"") {
          __e15 = "\\\"";
        } else {
          var __e16 = undefined;
          if (__c === "\\") {
            __e16 = "\\\\";
          } else {
            __e16 = __c;
          }
          __e15 = __e16;
        }
        __e14 = __e15;
      }
      __e13 = __e14;
    }
    var __c1 = __e13;
    __s1 = __s1 + __c1;
    __i20 = __i20 + 1;
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
                      var __s = "(";
                      var __sp = "";
                      var __xs12 = [];
                      var __ks1 = [];
                      var __l5 = stack || [];
                      add(__l5, x);
                      var ____o10 = x;
                      var __k16 = undefined;
                      for (__k16 in ____o10) {
                        var __v9 = ____o10[__k16];
                        var __e17 = undefined;
                        if (numeric63(__k16)) {
                          __e17 = parseInt(__k16);
                        } else {
                          __e17 = __k16;
                        }
                        var __k17 = __e17;
                        if (number63(__k17)) {
                          __xs12[__k17] = str(__v9, __l5);
                        } else {
                          add(__ks1, __k17 + ":");
                          add(__ks1, str(__v9, __l5));
                        }
                      }
                      drop(__l5);
                      var ____o11 = join(__xs12, __ks1);
                      var ____i22 = undefined;
                      for (____i22 in ____o11) {
                        var __v10 = ____o11[____i22];
                        var __e18 = undefined;
                        if (numeric63(____i22)) {
                          __e18 = parseInt(____i22);
                        } else {
                          __e18 = ____i22;
                        }
                        var ____i221 = __e18;
                        __s = __s + __sp + __v10;
                        __sp = " ";
                      }
                      return __s + ")";
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
  var ____r89 = unstash(_42args);
  var ___4242kwargs12 = destash(_42args);
  var ____id24 = ___4242kwargs12;
  var __f = destash33(f, ____r89);
  var ____id25 = ____r89;
  var __args11 = cut(____id25, 0);
  return apply(__f, __args11);
};
setenv = function (k, ..._42args) {
  var ____r90 = unstash(_42args);
  var ___4242kwargs13 = destash(_42args);
  var ____id26 = ___4242kwargs13;
  var __k18 = destash33(k, ____r90);
  var ____id27 = ____r90;
  var __keys = cut(____id27, 0);
  if (string63(__k18)) {
    var __e19 = undefined;
    if (__keys.toplevel) {
      __e19 = hd(environment);
    } else {
      __e19 = last(environment);
    }
    var __frame = __e19;
    var __entry = __frame[__k18] || {};
    var ____o12 = __keys;
    var __k19 = undefined;
    for (__k19 in ____o12) {
      var __v11 = ____o12[__k19];
      var __e20 = undefined;
      if (numeric63(__k19)) {
        __e20 = parseInt(__k19);
      } else {
        __e20 = __k19;
      }
      var __k20 = __e20;
      __entry[__k20] = __v11;
    }
    __frame[__k18] = __entry;
    return __frame[__k18];
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
setenv("quote", {_stash: true, macro: function (form) {
  return quoted(form);
}});
setenv("quasiquote", {_stash: true, macro: function (form) {
  return quasiexpand(form, 1);
}});
setenv("set", {_stash: true, macro: function (..._42args) {
  var ____r6 = unstash(_42args);
  var ___4242kwargs1 = destash(_42args);
  var ____id3 = ___4242kwargs1;
  var ____id4 = ____r6;
  var __args1 = cut(____id4, 0);
  return join(["do"], map(function (__x4) {
    var ____id5 = __x4;
    var __lh1 = ____id5[0];
    var __rh1 = ____id5[1];
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
  var ____r13 = unstash(_42args);
  var ___4242kwargs3 = destash(_42args);
  var ____id8 = ___4242kwargs3;
  var ____id9 = ____r13;
  var __body1 = cut(____id9, 0);
  var __x22 = unique("x");
  var __l1 = [];
  var __forms1 = [];
  var ____o1 = __body1;
  var __k2 = undefined;
  for (__k2 in ____o1) {
    var __v1 = ____o1[__k2];
    var __e8 = undefined;
    if (numeric63(__k2)) {
      __e8 = parseInt(__k2);
    } else {
      __e8 = __k2;
    }
    var __k3 = __e8;
    if (number63(__k3)) {
      __l1[__k3] = __v1;
    } else {
      add(__forms1, ["set", ["get", __x22, ["quote", __k3]], __v1]);
    }
  }
  if (some63(__forms1)) {
    return join(["let", __x22, join(["%array"], __l1)], __forms1, [__x22]);
  } else {
    return join(["%array"], __l1);
  }
}});
setenv("if", {_stash: true, macro: function (..._42args) {
  var ____r15 = unstash(_42args);
  var ___4242kwargs5 = destash(_42args);
  var ____id12 = ___4242kwargs5;
  var ____id13 = ____r15;
  var __branches1 = cut(____id13, 0);
  return hd(expand_if(__branches1));
}});
setenv("case", {_stash: true, macro: function (expr, ..._42args) {
  var ____r19 = unstash(_42args);
  var ___4242kwargs7 = destash(_42args);
  var ____id17 = ___4242kwargs7;
  var __expr1 = destash33(expr, ____r19);
  var ____id18 = ____r19;
  var __clauses1 = cut(____id18, 0);
  var __x41 = unique("x");
  var __eq1 = function (_) {
    return ["=", ["quote", _], __x41];
  };
  var __cl1 = function (__x44) {
    var ____id19 = __x44;
    var __a1 = ____id19[0];
    var __b1 = ____id19[1];
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
  return ["let", __x41, __expr1, join(["if"], apply(join, map(__cl1, pair(__clauses1))))];
}});
setenv("when", {_stash: true, macro: function (cond, ..._42args) {
  var ____r23 = unstash(_42args);
  var ___4242kwargs9 = destash(_42args);
  var ____id22 = ___4242kwargs9;
  var __cond1 = destash33(cond, ____r23);
  var ____id23 = ____r23;
  var __body3 = cut(____id23, 0);
  return ["if", __cond1, join(["do"], __body3)];
}});
setenv("unless", {_stash: true, macro: function (cond, ..._42args) {
  var ____r25 = unstash(_42args);
  var ___4242kwargs11 = destash(_42args);
  var ____id26 = ___4242kwargs11;
  var __cond3 = destash33(cond, ____r25);
  var ____id27 = ____r25;
  var __body5 = cut(____id27, 0);
  return ["if", ["not", __cond3], join(["do"], __body5)];
}});
setenv("obj", {_stash: true, macro: function (..._42args) {
  var ____r28 = unstash(_42args);
  var ___4242kwargs13 = destash(_42args);
  var ____id30 = ___4242kwargs13;
  var ____id31 = ____r28;
  var __body7 = cut(____id31, 0);
  return join(["%object"], mapo(function (x) {
    return x;
  }, __body7));
}});
setenv("let", {_stash: true, macro: function (bs, ..._42args) {
  var ____r31 = unstash(_42args);
  var ___4242kwargs15 = destash(_42args);
  var ____id37 = ___4242kwargs15;
  var __bs11 = destash33(bs, ____r31);
  var ____id38 = ____r31;
  var __body9 = cut(____id38, 0);
  if (atom63(__bs11)) {
    return join(["let", [__bs11, hd(__body9)]], tl(__body9));
  } else {
    if (none63(__bs11)) {
      return join(["do"], __body9);
    } else {
      var ____id39 = __bs11;
      var __lh3 = ____id39[0];
      var __rh3 = ____id39[1];
      var __bs21 = cut(____id39, 2);
      var ____id40 = bind(__lh3, __rh3);
      var __id41 = ____id40[0];
      var __val1 = ____id40[1];
      var __bs12 = cut(____id40, 2);
      var __renames1 = [];
      if (! id_literal63(__id41)) {
        var __id121 = unique(__id41);
        __renames1 = [__id41, __id121];
        __id41 = __id121;
      }
      return ["do", ["%local", __id41, __val1], ["let-symbol", __renames1, join(["let", join(__bs12, __bs21)], __body9)]];
    }
  }
}});
setenv("with", {_stash: true, macro: function (x, v, ..._42args) {
  var ____r33 = unstash(_42args);
  var ___4242kwargs17 = destash(_42args);
  var ____id44 = ___4242kwargs17;
  var __x84 = destash33(x, ____r33);
  var __v3 = destash33(v, ____r33);
  var ____id45 = ____r33;
  var __body11 = cut(____id45, 0);
  return join(["let", [__x84, __v3]], __body11, [__x84]);
}});
setenv("let-when", {_stash: true, macro: function (x, v, ..._42args) {
  var ____r35 = unstash(_42args);
  var ___4242kwargs19 = destash(_42args);
  var ____id48 = ___4242kwargs19;
  var __x94 = destash33(x, ____r35);
  var __v5 = destash33(v, ____r35);
  var ____id49 = ____r35;
  var __body13 = cut(____id49, 0);
  var __y1 = unique("y");
  return ["let", __y1, __v5, ["when", ["yes", __y1], join(["let", [__x94, __y1]], __body13)]];
}});
setenv("define-macro", {_stash: true, macro: function (name, args, ..._42args) {
  var ____r37 = unstash(_42args);
  var ___4242kwargs21 = destash(_42args);
  var ____id52 = ___4242kwargs21;
  var __name1 = destash33(name, ____r37);
  var __args3 = destash33(args, ____r37);
  var ____id53 = ____r37;
  var __body15 = cut(____id53, 0);
  var ____x103 = ["setenv", ["quote", __name1]];
  ____x103.macro = join(["fn", __args3], __body15);
  var __form1 = ____x103;
  _eval(__form1);
  return __form1;
}});
setenv("define-special", {_stash: true, macro: function (name, args, ..._42args) {
  var ____r39 = unstash(_42args);
  var ___4242kwargs23 = destash(_42args);
  var ____id56 = ___4242kwargs23;
  var __name3 = destash33(name, ____r39);
  var __args5 = destash33(args, ____r39);
  var ____id57 = ____r39;
  var __body17 = cut(____id57, 0);
  var ____x109 = ["setenv", ["quote", __name3]];
  ____x109.special = join(["fn", __args5], __body17);
  var __form3 = join(____x109, keys(__body17));
  _eval(__form3);
  return __form3;
}});
setenv("define-symbol", {_stash: true, macro: function (name, expansion) {
  setenv(name, {_stash: true, symbol: expansion});
  var ____x115 = ["setenv", ["quote", name]];
  ____x115.symbol = ["quote", expansion];
  return ____x115;
}});
setenv("define-reader", {_stash: true, macro: function (__x123, ..._42args) {
  var ____id61 = __x123;
  var __char1 = ____id61[0];
  var __s1 = ____id61[1];
  var ____r43 = unstash(_42args);
  var ___4242kwargs25 = destash(_42args);
  var ____id62 = ___4242kwargs25;
  var ____x123 = destash33(__x123, ____r43);
  var ____id63 = ____r43;
  var __body19 = cut(____id63, 0);
  return ["set", ["get", "read-table", __char1], join(["fn", [__s1]], __body19)];
}});
setenv("define", {_stash: true, macro: function (name, x, ..._42args) {
  var ____r45 = unstash(_42args);
  var ___4242kwargs27 = destash(_42args);
  var ____id66 = ___4242kwargs27;
  var __name5 = destash33(name, ____r45);
  var __x131 = destash33(x, ____r45);
  var ____id67 = ____r45;
  var __body21 = cut(____id67, 0);
  setenv(__name5, {_stash: true, variable: true});
  if (some63(__body21)) {
    return join(["%local-function", __name5], bind42(__x131, __body21));
  } else {
    return ["%local", __name5, __x131];
  }
}});
setenv("define-global", {_stash: true, macro: function (name, x, ..._42args) {
  var ____r47 = unstash(_42args);
  var ___4242kwargs29 = destash(_42args);
  var ____id70 = ___4242kwargs29;
  var __name7 = destash33(name, ____r47);
  var __x137 = destash33(x, ____r47);
  var ____id71 = ____r47;
  var __body23 = cut(____id71, 0);
  setenv(__name7, {_stash: true, toplevel: true, variable: true});
  if (some63(__body23)) {
    return join(["%global-function", __name7], bind42(__x137, __body23));
  } else {
    return ["set", __name7, __x137];
  }
}});
setenv("with-frame", {_stash: true, macro: function (..._42args) {
  var ____r49 = unstash(_42args);
  var ___4242kwargs31 = destash(_42args);
  var ____id74 = ___4242kwargs31;
  var ____id75 = ____r49;
  var __body25 = cut(____id75, 0);
  var __x147 = unique("x");
  return ["do", ["add", "environment", ["obj"]], ["with", __x147, join(["do"], __body25), ["drop", "environment"]]];
}});
setenv("with-bindings", {_stash: true, macro: function (__x159, ..._42args) {
  var ____id79 = __x159;
  var __names1 = ____id79[0];
  var ____r51 = unstash(_42args);
  var ___4242kwargs33 = destash(_42args);
  var ____id80 = ___4242kwargs33;
  var ____x159 = destash33(__x159, ____r51);
  var ____id81 = ____r51;
  var __body27 = cut(____id81, 0);
  var __x160 = unique("x");
  var ____x163 = ["setenv", __x160];
  ____x163.variable = true;
  return join(["with-frame", ["each", __x160, __names1, ____x163]], __body27);
}});
setenv("let-macro", {_stash: true, macro: function (definitions, ..._42args) {
  var ____r54 = unstash(_42args);
  var ___4242kwargs35 = destash(_42args);
  var ____id84 = ___4242kwargs35;
  var __definitions1 = destash33(definitions, ____r54);
  var ____id85 = ____r54;
  var __body29 = cut(____id85, 0);
  add(environment, {});
  map(function (m) {
    return macroexpand(join(["define-macro"], m));
  }, __definitions1);
  var ____x167 = join(["do"], macroexpand(__body29));
  drop(environment);
  return ____x167;
}});
setenv("let-symbol", {_stash: true, macro: function (expansions, ..._42args) {
  var ____r58 = unstash(_42args);
  var ___4242kwargs37 = destash(_42args);
  var ____id89 = ___4242kwargs37;
  var __expansions1 = destash33(expansions, ____r58);
  var ____id90 = ____r58;
  var __body31 = cut(____id90, 0);
  add(environment, {});
  map(function (__x175) {
    var ____id91 = __x175;
    var __name9 = ____id91[0];
    var __exp1 = ____id91[1];
    return macroexpand(["define-symbol", __name9, __exp1]);
  }, pair(__expansions1));
  var ____x174 = join(["do"], macroexpand(__body31));
  drop(environment);
  return ____x174;
}});
setenv("let-unique", {_stash: true, macro: function (names, ..._42args) {
  var ____r62 = unstash(_42args);
  var ___4242kwargs39 = destash(_42args);
  var ____id94 = ___4242kwargs39;
  var __names3 = destash33(names, ____r62);
  var ____id95 = ____r62;
  var __body33 = cut(____id95, 0);
  var __bs3 = map(function (n) {
    return [n, ["unique", ["quote", n]]];
  }, __names3);
  return join(["let", apply(join, __bs3)], __body33);
}});
setenv("fn", {_stash: true, macro: function (args, ..._42args) {
  var ____r65 = unstash(_42args);
  var ___4242kwargs41 = destash(_42args);
  var ____id98 = ___4242kwargs41;
  var __args7 = destash33(args, ____r65);
  var ____id99 = ____r65;
  var __body35 = cut(____id99, 0);
  return join(["%function"], bind42(__args7, __body35));
}});
setenv("apply", {_stash: true, macro: function (f, ..._42args) {
  var ____r67 = unstash(_42args);
  var ___4242kwargs43 = destash(_42args);
  var ____id102 = ___4242kwargs43;
  var __f1 = destash33(f, ____r67);
  var ____id103 = ____r67;
  var __args9 = cut(____id103, 0);
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
    var ____x230 = ["obj"];
    ____x230.stack = [["get", "debug", ["quote", "traceback"]]];
    ____x230.message = ["if", ["string?", "m"], ["clip", "m", ["+", ["or", ["search", "m", "\": \""], -2], 2]], ["nil?", "m"], "\"\"", ["str", "m"]];
    return ["list", ["xpcall", ["fn", join(), expr], ["fn", ["m"], ["if", ["obj?", "m"], "m", ____x230]]]];
  }
}});
setenv("each", {_stash: true, macro: function (x, t, ..._42args) {
  var ____r71 = unstash(_42args);
  var ___4242kwargs45 = destash(_42args);
  var ____id107 = ___4242kwargs45;
  var __x256 = destash33(x, ____r71);
  var __t1 = destash33(t, ____r71);
  var ____id108 = ____r71;
  var __body37 = cut(____id108, 0);
  var __o3 = unique("o");
  var __n3 = unique("n");
  var __i3 = unique("i");
  var __e9 = undefined;
  if (atom63(__x256)) {
    __e9 = [__i3, __x256];
  } else {
    var __e10 = undefined;
    if (_35(__x256) > 1) {
      __e10 = __x256;
    } else {
      __e10 = [__i3, hd(__x256)];
    }
    __e9 = __e10;
  }
  var ____id109 = __e9;
  var __k5 = ____id109[0];
  var __v7 = ____id109[1];
  var __e11 = undefined;
  if (target === "lua") {
    __e11 = __body37;
  } else {
    __e11 = [join(["let", __k5, ["if", ["numeric?", __k5], ["parseInt", __k5], __k5]], __body37)];
  }
  return ["let", [__o3, __t1, __k5, "nil"], ["%for", __o3, __k5, join(["let", [__v7, ["get", __o3, __k5]]], __e11)]];
}});
setenv("for", {_stash: true, macro: function (i, to, ..._42args) {
  var ____r73 = unstash(_42args);
  var ___4242kwargs47 = destash(_42args);
  var ____id112 = ___4242kwargs47;
  var __i5 = destash33(i, ____r73);
  var __to1 = destash33(to, ____r73);
  var ____id113 = ____r73;
  var __body39 = cut(____id113, 0);
  return ["let", __i5, 0, join(["while", ["<", __i5, __to1]], __body39, [["inc", __i5]])];
}});
setenv("step", {_stash: true, macro: function (v, t, ..._42args) {
  var ____r75 = unstash(_42args);
  var ___4242kwargs49 = destash(_42args);
  var ____id116 = ___4242kwargs49;
  var __v9 = destash33(v, ____r75);
  var __t3 = destash33(t, ____r75);
  var ____id117 = ____r75;
  var __body41 = cut(____id117, 0);
  var __x288 = unique("x");
  var __i7 = unique("i");
  return ["let", [__x288, __t3], ["for", __i7, ["#", __x288], join(["let", [__v9, ["at", __x288, __i7]]], __body41)]];
}});
setenv("set-of", {_stash: true, macro: function (..._42args) {
  var ____r77 = unstash(_42args);
  var ___4242kwargs51 = destash(_42args);
  var ____id120 = ___4242kwargs51;
  var ____id1211 = ____r77;
  var __xs1 = cut(____id1211, 0);
  var __l3 = [];
  var ____o5 = __xs1;
  var ____i9 = undefined;
  for (____i9 in ____o5) {
    var __x298 = ____o5[____i9];
    var __e12 = undefined;
    if (numeric63(____i9)) {
      __e12 = parseInt(____i9);
    } else {
      __e12 = ____i9;
    }
    var ____i91 = __e12;
    __l3[__x298] = true;
  }
  return join(["obj"], __l3);
}});
setenv("language", {_stash: true, macro: function () {
  return ["quote", target];
}});
setenv("target", {_stash: true, macro: function (..._42args) {
  var ____r81 = unstash(_42args);
  var ___4242kwargs53 = destash(_42args);
  var ____id124 = ___4242kwargs53;
  var ____id125 = ____r81;
  var __clauses3 = cut(____id125, 0);
  return __clauses3[target];
}});
setenv("join!", {_stash: true, macro: function (a, ..._42args) {
  var ____r83 = unstash(_42args);
  var ___4242kwargs55 = destash(_42args);
  var ____id128 = ___4242kwargs55;
  var __a3 = destash33(a, ____r83);
  var ____id129 = ____r83;
  var __bs5 = cut(____id129, 0);
  return ["set", __a3, join(["join", __a3], __bs5)];
}});
setenv("cat!", {_stash: true, macro: function (a, ..._42args) {
  var ____r85 = unstash(_42args);
  var ___4242kwargs57 = destash(_42args);
  var ____id132 = ___4242kwargs57;
  var __a5 = destash33(a, ____r85);
  var ____id133 = ____r85;
  var __bs7 = cut(____id133, 0);
  return ["set", __a5, join(["cat", __a5], __bs7)];
}});
setenv("inc", {_stash: true, macro: function (n, by) {
  var __e13 = undefined;
  if (nil63(by)) {
    __e13 = 1;
  } else {
    __e13 = by;
  }
  return ["set", n, ["+", n, __e13]];
}});
setenv("dec", {_stash: true, macro: function (n, by) {
  var __e14 = undefined;
  if (nil63(by)) {
    __e14 = 1;
  } else {
    __e14 = by;
  }
  return ["set", n, ["-", n, __e14]];
}});
setenv("with-indent", {_stash: true, macro: function (form) {
  var __x323 = unique("x");
  return ["do", ["inc", "indent-level"], ["with", __x323, form, ["dec", "indent-level"]]];
}});
setenv("export", {_stash: true, macro: function (..._42args) {
  var ____r95 = unstash(_42args);
  var ___4242kwargs59 = destash(_42args);
  var ____id136 = ___4242kwargs59;
  var ____id137 = ____r95;
  var __names5 = cut(____id137, 0);
  if (target === "js") {
    return join(["do"], map(function (k) {
      return ["set", ["get", "exports", ["quote", k]], k];
    }, __names5));
  } else {
    var __x339 = {};
    var ____o7 = __names5;
    var ____i11 = undefined;
    for (____i11 in ____o7) {
      var __k7 = ____o7[____i11];
      var __e15 = undefined;
      if (numeric63(____i11)) {
        __e15 = parseInt(____i11);
      } else {
        __e15 = ____i11;
      }
      var ____i111 = __e15;
      __x339[__k7] = __k7;
    }
    return ["return", join(["%object"], mapo(function (x) {
      return x;
    }, __x339))];
  }
}});
setenv("when-compiling", {_stash: true, macro: function (..._42args) {
  var ____r99 = unstash(_42args);
  var ___4242kwargs61 = destash(_42args);
  var ____id140 = ___4242kwargs61;
  var ____id141 = ____r99;
  var __body43 = cut(____id141, 0);
  return _eval(join(["do"], __body43));
}});
setenv("during-compilation", {_stash: true, macro: function (..._42args) {
  var ____r101 = unstash(_42args);
  var ___4242kwargs63 = destash(_42args);
  var ____id144 = ___4242kwargs63;
  var ____id145 = ____r101;
  var __body45 = cut(____id145, 0);
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
      return [true, compiler["eval"](form)];
    }
    catch (__e) {
      return [false, __e];
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
  return eval_print(reader["read-string"](s));
};
var repl = function () {
  var __buf = "";
  var rep1 = function (s) {
    __buf = __buf + s;
    var __more = [];
    var __form = reader["read-string"](__buf, __more);
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
compile_file = function (path) {
  var __s = reader.stream(system["read-file"](path));
  var __body = reader["read-all"](__s);
  var __form1 = compiler.expand(join(["do"], __body));
  return compiler.compile(__form1, {_stash: true, stmt: true});
};
_load = function (path) {
  var __previous = target;
  target = "js";
  var __code = compile_file(path);
  target = __previous;
  return compiler.run(__code);
};
var script_file63 = function (path) {
  return !( "-" === char(path, 0) || ".js" === clip(path, _35(path) - 3) || ".lua" === clip(path, _35(path) - 4));
};
var run_file = function (path) {
  if (script_file63(path)) {
    return _load(path);
  } else {
    return compiler.run(system["read-file"](path));
  }
};
var usage = function () {
  print("usage: lumen [<file> <arguments> | options <object files>]");
  print(" <file>\t\tProgram read from script file");
  print(" <arguments>\tPassed to program in system.argv");
  print(" <object files>\tLoaded before compiling <input>");
  print("options:");
  print(" -c <input>\tCompile input file");
  print(" -o <output>\tOutput file");
  print(" -t <target>\tTarget language (default: lua)");
  return print(" -e <expr>\tExpression to evaluate");
};
var main = function (argv) {
  var __argv = argv || system.argv;
  var __arg = hd(__argv);
  if (__arg && script_file63(__arg)) {
    return _load(__arg);
  } else {
    if (__arg === "-h" || __arg === "--help") {
      return usage();
    } else {
      var __pre = [];
      var __input = undefined;
      var __output = undefined;
      var __target1 = undefined;
      var __expr = undefined;
      var __i = 0;
      while (__i < _35(__argv)) {
        var __a = __argv[__i];
        if (__a === "-c" || __a === "-o" || __a === "-t" || __a === "-e") {
          if (__i === edge(__argv)) {
            print("missing argument for " + __a);
          } else {
            __i = __i + 1;
            var __val = __argv[__i];
            if (__a === "-c") {
              __input = __val;
            } else {
              if (__a === "-o") {
                __output = __val;
              } else {
                if (__a === "-t") {
                  __target1 = __val;
                } else {
                  if (__a === "-e") {
                    __expr = __val;
                  }
                }
              }
            }
          }
        } else {
          if (!( "-" === char(__a, 0))) {
            add(__pre, __a);
          }
        }
        __i = __i + 1;
      }
      var ____x2 = __pre;
      var ____i1 = 0;
      while (____i1 < _35(____x2)) {
        var __file = ____x2[____i1];
        run_file(__file);
        ____i1 = ____i1 + 1;
      }
      if (nil63(__input)) {
        if (__expr) {
          return rep(__expr);
        } else {
          return repl();
        }
      } else {
        if (__target1) {
          target = __target1;
        }
        var __code1 = compile_file(__input);
        if (nil63(__output) || __output === "-") {
          return print(__code1);
        } else {
          return system["write-file"](__output, __code1);
        }
      }
    }
  }
};
exports.reader = reader;
exports.compiler = compiler;
exports.system = system;
exports.main = main;
