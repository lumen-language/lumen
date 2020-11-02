var delimiters = {["("]: true, [")"]: true, ["["]: true, ["]"]: true, ["{"]: true, ["}"]: true, [";"]: true, ["\r"]: true, ["\n"]: true};
var whitespace = {[" "]: true, ["\t"]: true, ["\r"]: true, ["\n"]: true};
var stream = function (str, more) {
  return {pos: 0, string: str, len: _35(str), more: more};
};
var peek_char = function (s, __x) {
  var __e = undefined;
  if (__x === undefined) {
    __e = 0;
  } else {
    __e = __x;
  }
  var __i = __e;
  var ____id = s;
  var __pos = ____id.pos;
  var __len = ____id.len;
  var __str = ____id.string;
  if (__pos + __i < __len) {
    return char(__str, __pos + __i);
  }
};
var read_char = function (s) {
  var __c = peek_char(s);
  if (__c) {
    s.pos = s.pos + 1;
    return __c;
  }
};
var skip_non_code = function (s) {
  var __any63 = undefined;
  while (true) {
    var __c1 = peek_char(s);
    if (nil63(__c1)) {
      break;
    } else {
      if (whitespace[__c1]) {
        read_char(s);
      } else {
        if (__c1 === ";") {
          while (__c1 && !( __c1 === "\n")) {
            __c1 = read_char(s);
          }
          skip_non_code(s);
        } else {
          break;
        }
      }
    }
    __any63 = true;
  }
  return __any63;
};
var read_table = {};
var read = function (s, eof) {
  skip_non_code(s);
  var __c2 = peek_char(s);
  if (is63(__c2)) {
    return (read_table[__c2] || read_table[""])(s);
  } else {
    return eof;
  }
};
var read_all = function (s) {
  var __l = [];
  var __eof = {};
  while (true) {
    var __form = read(s, __eof);
    if (__form === __eof) {
      break;
    }
    add(__l, __form);
  }
  return __l;
};
read_string = function (str, more) {
  return read(stream(str, more));
};
var key63 = function (atom) {
  return string63(atom) && _35(atom) > 1 && char(atom, edge(atom)) === ":";
};
var expected = function (s, c) {
  var ____id1 = s;
  var __more = ____id1.more;
  var __pos1 = ____id1.pos;
  return __more || error("Expected " + c + " at " + __pos1);
};
var wrap = function (s, x) {
  var __y = read(s);
  if (__y === s.more) {
    return __y;
  } else {
    return [x, __y];
  }
};
var hex_prefix63 = function (str) {
  var __e1 = undefined;
  if (code(str, 0) === 45) {
    __e1 = 1;
  } else {
    __e1 = 0;
  }
  var __i1 = __e1;
  var __id2 = code(str, __i1) === 48;
  var __e2 = undefined;
  if (__id2) {
    __i1 = __i1 + 1;
    var __n = code(str, __i1);
    __e2 = __n === 120 || __n === 88;
  } else {
    __e2 = __id2;
  }
  return __e2;
};
var maybe_number = function (str) {
  if (hex_prefix63(str)) {
    return parseInt(str, 16);
  } else {
    if (number_code63(code(str, edge(str)))) {
      return number(str);
    }
  }
};
var real63 = function (x) {
  return number63(x) && ! nan63(x) && ! inf63(x);
};
var valid_access63 = function (str) {
  return _35(str) > 2 && !( "." === char(str, 0)) && !( "." === char(str, edge(str))) && nil63(search(str, ".."));
};
var parse_index = function (a, b) {
  print(str(["parse-index", a, b]));
  if (nil63(a)) {
    return "." + b;
  } else {
    var __n1 = number(a);
    if (nil63(__n1)) {
      return ["get", b, quoted(a)];
    } else {
      return ["at", b, __n1];
    }
  }
};
var parse_access = function (x, prev) {
  print(str(["parse-access", x, prev]));
  return parse_index(x, prev);
};
var read_atom = function (s, __x6) {
  var __e3 = undefined;
  if (__x6 === undefined) {
    __e3 = false;
  } else {
    __e3 = __x6;
  }
  var __basic63 = __e3;
  var __str1 = "";
  while (true) {
    var __c3 = peek_char(s);
    if (__c3 === "\\") {
      __str1 = __str1 + read_char(s) + read_char(s);
    } else {
      if (__c3 && (! whitespace[__c3] && ! delimiters[__c3])) {
        __str1 = __str1 + read_char(s);
      } else {
        break;
      }
    }
  }
  if (__str1 === "true") {
    return true;
  } else {
    if (__str1 === "false") {
      return false;
    } else {
      if (__basic63) {
        return s;
      } else {
        var __n2 = maybe_number(__str1);
        if (real63(__n2)) {
          return __n2;
        } else {
          return __str1;
        }
      }
    }
  }
};
var read_list = function (s, ending) {
  read_char(s);
  var __r18 = undefined;
  var __l1 = [];
  while (nil63(__r18)) {
    skip_non_code(s);
    var __c4 = peek_char(s);
    if (__c4 === ending) {
      read_char(s);
      __r18 = __l1;
    } else {
      if (nil63(__c4)) {
        __r18 = expected(s, ending);
      } else {
        var __x7 = read(s);
        if (key63(__x7)) {
          var __k = clip(__x7, 0, edge(__x7));
          var __v = read(s);
          __l1[__k] = __v;
        } else {
          add(__l1, __x7);
        }
      }
    }
  }
  return __r18;
};
var read_next = function (s, prev, ws63, eof) {
  return prev;
};
read_table[""] = function (s) {
  return read_next(s, read_atom(s));
};
read_table["("] = function (s) {
  return read_next(s, read_list(s, ")"));
};
read_table[")"] = function (s) {
  return error("Unexpected ) at " + s.pos);
};
read_table["["] = function (s) {
  read_char(s);
  var __r24 = undefined;
  var __l2 = [["%brackets"]];
  while (nil63(__r24)) {
    skip_non_code(s);
    var __c5 = peek_char(s);
    if (__c5 === "]") {
      read_char(s);
      __r24 = __l2;
    } else {
      if (nil63(__c5)) {
        __r24 = expected(s, "]");
      } else {
        var __x14 = read(s);
        add(__l2, __x14);
      }
    }
  }
  return __r24;
};
read_table["]"] = function (s) {
  return error("Unexpected ] at " + s.pos);
};
read_table["{"] = function (s) {
  read_char(s);
  var __r27 = undefined;
  var __l3 = [["%braces"]];
  while (nil63(__r27)) {
    skip_non_code(s);
    var __c6 = peek_char(s);
    if (__c6 === "}") {
      read_char(s);
      __r27 = __l3;
    } else {
      if (nil63(__c6)) {
        __r27 = expected(s, "}");
      } else {
        var __x17 = read(s);
        add(__l3, __x17);
      }
    }
  }
  return __r27;
};
read_table["}"] = function (s) {
  return error("Unexpected } at " + s.pos);
};
read_table["\""] = function (s) {
  read_char(s);
  var __r30 = undefined;
  var __str2 = "\"";
  while (nil63(__r30)) {
    var __c7 = peek_char(s);
    if (__c7 === "\"") {
      __r30 = __str2 + read_char(s);
    } else {
      if (nil63(__c7)) {
        __r30 = expected(s, "\"");
      } else {
        if (__c7 === "\\") {
          __str2 = __str2 + read_char(s);
        }
        __str2 = __str2 + read_char(s);
      }
    }
  }
  return __r30;
};
read_table["|"] = function (s) {
  read_char(s);
  var __r32 = undefined;
  var __str3 = "|";
  while (nil63(__r32)) {
    var __c8 = read_char(s);
    if (nil63(__c8)) {
      __r32 = expected(s, "|");
    } else {
      if (__c8 === "|") {
        if (peek_char(s) === "|") {
          __str3 = __str3 + read_char(s);
        } else {
          __r32 = __str3 + __c8;
        }
      } else {
        __str3 = __str3 + __c8;
      }
    }
  }
  return __r32;
};
read_table["'"] = function (s) {
  read_char(s);
  return wrap(s, "quote");
};
read_table["`"] = function (s) {
  read_char(s);
  return wrap(s, "quasiquote");
};
read_table[","] = function (s) {
  read_char(s);
  if (peek_char(s) === "@") {
    read_char(s);
    return wrap(s, "unquote-splicing");
  } else {
    return wrap(s, "unquote");
  }
};
read_table["~"] = function (s) {
  read_char(s);
  return wrap(s, "complement");
};
var __e4 = undefined;
if (typeof(exports) === "undefined") {
  __e4 = {};
} else {
  __e4 = exports;
}
var __exports = __e4;
__exports.stream = stream;
__exports.read = read;
__exports.readAll = read_all;
__exports.readString = read_string;
__exports.readTable = read_table;
__exports;
