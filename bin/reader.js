var delimiters = {["("]: true, [")"]: true, ["["]: true, ["]"]: true, ["{"]: true, ["}"]: true, [";"]: true, ["\r"]: true, ["\n"]: true};
var whitespace = {[" "]: true, ["\t"]: true, ["\r"]: true, ["\n"]: true};
var stream = function(str, more) {
  return {pos: 0, string: str, len: _35(str), more: more};
};
var peek_char = function(s) {
  var ____id = s;
  var __pos = ____id.pos;
  var __len = ____id.len;
  var __str = ____id.string;
  if (__pos < __len) {
    return char(__str, __pos);
  }
};
var read_char = function(s) {
  var __c = peek_char(s);
  if (__c) {
    s.pos = s.pos + 1;
    return __c;
  }
};
var skip_non_code = function(s) {
  while (true) {
    var __c1 = peek_char(s);
    if (nil63(__c1)) {
      break;
    } else {
      if (whitespace[__c1]) {
        read_char(s);
      } else {
        if (__c1 === ";") {
          while (__c1 && !(__c1 === "\n")) {
            __c1 = read_char(s);
          }
          skip_non_code(s);
        } else {
          break;
        }
      }
    }
  }
};
var read_table = {};
var read = function(s, eof) {
  skip_non_code(s);
  var __c2 = peek_char(s);
  if (is63(__c2)) {
    return (read_table[__c2] || read_table[""])(s);
  } else {
    return eof;
  }
};
var read_all = function(s) {
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
read_string = function(str, more) {
  return read(stream(str, more));
};
var key63 = function(atom) {
  return string63(atom) && _35(atom) > 1 && char(atom, edge(atom)) === ":" && !(atom === "::");
};
var expected = function(s, c) {
  var ____id1 = s;
  var __more = ____id1.more;
  var __pos1 = ____id1.pos;
  return __more || error("Expected " + c + " at " + __pos1);
};
var wrap = function(s, x) {
  var __y = read(s);
  if (__y === s.more) {
    return __y;
  } else {
    return [x, __y];
  }
};
var hex_prefix63 = function(str) {
  var __e = undefined;
  if (code(str, 0) === 45) {
    __e = 1;
  } else {
    __e = 0;
  }
  var __i = __e;
  var __id2 = code(str, __i) === 48;
  var __e1 = undefined;
  if (__id2) {
    __i = __i + 1;
    var __n = code(str, __i);
    __e1 = __n === 120 || __n === 88;
  } else {
    __e1 = __id2;
  }
  return __e1;
};
var maybe_number = function(str) {
  if (hex_prefix63(str)) {
    return parseInt(str, 16);
  } else {
    if (number_code63(code(str, edge(str)))) {
      return number(str);
    }
  }
};
var real63 = function(x) {
  return number63(x) && !nan63(x) && !inf63(x);
};
read_table[""] = function(s) {
  var __str1 = "";
  while (true) {
    var __c3 = peek_char(s);
    if (__c3 && (!whitespace[__c3] && !delimiters[__c3])) {
      __str1 = __str1 + read_char(s);
    } else {
      break;
    }
  }
  if (__str1 === "true") {
    return true;
  } else {
    if (__str1 === "false") {
      return false;
    } else {
      var __n1 = maybe_number(__str1);
      if (real63(__n1)) {
        return __n1;
      } else {
        return __str1;
      }
    }
  }
};
read_table["("] = function(s) {
  read_char(s);
  var __r15 = undefined;
  var __l1 = [];
  while (nil63(__r15)) {
    skip_non_code(s);
    var __c4 = peek_char(s);
    if (__c4 === ")") {
      read_char(s);
      __r15 = __l1;
    } else {
      if (nil63(__c4)) {
        __r15 = expected(s, ")");
      } else {
        var __x1 = read(s);
        if (key63(__x1)) {
          var __k = clip(__x1, 0, edge(__x1));
          var __v = read(s);
          __l1[__k] = __v;
        } else {
          add(__l1, __x1);
        }
      }
    }
  }
  return __r15;
};
read_table[")"] = function(s) {
  return error("Unexpected ) at " + s.pos);
};
read_table["["] = function(s) {
  read_char(s);
  var __r18 = undefined;
  var __l2 = ["%brackets"];
  var __n2 = 1;
  while (nil63(__r18)) {
    skip_non_code(s);
    var __c5 = peek_char(s);
    if (__c5 === "]") {
      read_char(s);
      __r18 = __l2;
    } else {
      if (nil63(__c5)) {
        __r18 = expected(s, "]");
      } else {
        var __x3 = read(s);
        __l2[__n2] = __x3;
        __n2 = __n2 + 1;
      }
    }
  }
  return __r18;
};
read_table["]"] = function(s) {
  return error("Unexpected ] at " + s.pos);
};
read_table["{"] = function(s) {
  read_char(s);
  var __r21 = undefined;
  var __l3 = ["%braces"];
  var __n3 = 1;
  while (nil63(__r21)) {
    skip_non_code(s);
    var __c6 = peek_char(s);
    if (__c6 === "}") {
      read_char(s);
      __r21 = __l3;
    } else {
      if (nil63(__c6)) {
        __r21 = expected(s, "}");
      } else {
        var __x5 = read(s);
        __l3[__n3] = __x5;
        __n3 = __n3 + 1;
      }
    }
  }
  return __r21;
};
read_table["}"] = function(s) {
  return error("Unexpected } at " + s.pos);
};
read_table["\""] = function(s) {
  read_char(s);
  var __r24 = undefined;
  var __str2 = "\"";
  while (nil63(__r24)) {
    var __c7 = peek_char(s);
    if (__c7 === "\"") {
      __r24 = __str2 + read_char(s);
    } else {
      if (nil63(__c7)) {
        __r24 = expected(s, "\"");
      } else {
        if (__c7 === "\\") {
          __str2 = __str2 + read_char(s);
        }
        __str2 = __str2 + read_char(s);
      }
    }
  }
  return __r24;
};
read_table["|"] = function(s) {
  read_char(s);
  var __r26 = undefined;
  var __str3 = "|";
  while (nil63(__r26)) {
    var __c8 = peek_char(s);
    if (__c8 === "|") {
      __r26 = __str3 + read_char(s);
    } else {
      if (nil63(__c8)) {
        __r26 = expected(s, "|");
      } else {
        __str3 = __str3 + read_char(s);
      }
    }
  }
  return __r26;
};
read_table["'"] = function(s) {
  read_char(s);
  return wrap(s, "quote");
};
read_table["`"] = function(s) {
  read_char(s);
  return wrap(s, "quasiquote");
};
read_table[","] = function(s) {
  read_char(s);
  if (peek_char(s) === "@") {
    read_char(s);
    return wrap(s, "unquote-splicing");
  } else {
    return wrap(s, "unquote");
  }
};
read_table["@"] = function(s) {
  read_char(s);
  return wrap(s, "%@");
};
read_table["~"] = function(s) {
  read_char(s);
  return wrap(s, "%tilde");
};
var __e2 = undefined;
if (typeof(exports) === "undefined") {
  __e2 = {};
} else {
  __e2 = exports;
}
var __exports = __e2;
__exports.stream = stream;
__exports.read = read;
__exports.readAll = read_all;
__exports.readString = read_string;
__exports.readTable = read_table;
__exports;
