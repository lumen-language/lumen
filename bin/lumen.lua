environment = {{}}
target = "lua"
function nil63(x)
  return x == nil
end
function is63(x)
  return not nil63(x)
end
function no(x)
  return nil63(x) or x == false
end
function yes(x)
  return not no(x)
end
function either(x, y)
  if is63(x) then
    return x
  else
    return y
  end
end
function has63(l, k)
  return is63(l[k])
end
function _35(x)
  return #x
end
function none63(x)
  return _35(x) == 0
end
function some63(x)
  return _35(x) > 0
end
function one63(x)
  return _35(x) == 1
end
function two63(x)
  return _35(x) == 2
end
function hd(l)
  return l[1]
end
function string63(x)
  return type(x) == "string"
end
function number63(x)
  return type(x) == "number"
end
function boolean63(x)
  return type(x) == "boolean"
end
function function63(x)
  return type(x) == "function"
end
function obj63(x)
  return is63(x) and type(x) == "table"
end
function atom63(x)
  return nil63(x) or string63(x) or number63(x) or boolean63(x)
end
function hd63(l, x)
  local __id1 = obj63(l)
  local __e1 = nil
  if __id1 then
    local __e2 = nil
    if function63(x) then
      __e2 = x(hd(l))
    else
      __e2 = hd(l) == x
    end
    __e1 = __e2
  else
    __e1 = __id1
  end
  return __e1
end
nan = 0 / 0
inf = 1 / 0
_inf = - inf
function nan63(n)
  return not( n == n)
end
function inf63(n)
  return n == inf or n == _inf
end
function clip(s, from, upto)
  return string.sub(s, from + 1, upto)
end
function cut(x, from, upto)
  local __l = {}
  local __j = 0
  local __e3 = nil
  if nil63(from) or from < 0 then
    __e3 = 0
  else
    __e3 = from
  end
  local __i = __e3
  local __n = _35(x)
  local __e4 = nil
  if nil63(upto) or upto > __n then
    __e4 = __n
  else
    __e4 = upto
  end
  local __upto = __e4
  while __i < __upto do
    __l[__j + 1] = x[__i + 1]
    __i = __i + 1
    __j = __j + 1
  end
  local ____o = x
  local __k = nil
  for __k in pairs(____o) do
    local __v = ____o[__k]
    if not number63(__k) then
      __l[__k] = __v
    end
  end
  return __l
end
function keys(x)
  local __t = {}
  local ____o1 = x
  local __k1 = nil
  for __k1 in pairs(____o1) do
    local __v1 = ____o1[__k1]
    if not number63(__k1) then
      __t[__k1] = __v1
    end
  end
  return __t
end
function edge(x)
  return _35(x) - 1
end
function inner(x)
  return clip(x, 1, edge(x))
end
function tl(l)
  return cut(l, 1)
end
function char(s, n)
  return clip(s, n, n + 1)
end
function code(s, n)
  local __e5 = nil
  if n then
    __e5 = n + 1
  end
  return string.byte(s, __e5)
end
function from_code(n)
  return string.char(n)
end
function string_literal63(x)
  return string63(x) and char(x, 0) == "\""
end
function id_literal63(x)
  return string63(x) and char(x, 0) == "|"
end
function add(l, x)
  return table.insert(l, x)
end
function drop(l)
  return table.remove(l)
end
function last(l)
  return l[edge(l) + 1]
end
function almost(l)
  return cut(l, 0, edge(l))
end
function reverse(l)
  local __l1 = keys(l)
  local __i3 = edge(l)
  while __i3 >= 0 do
    add(__l1, l[__i3 + 1])
    __i3 = __i3 - 1
  end
  return __l1
end
function reduce(f, x)
  if none63(x) then
    return nil
  else
    if one63(x) then
      return hd(x)
    else
      return f(hd(x), reduce(f, tl(x)))
    end
  end
end
function join(...)
  local __ls = unstash({...})
  local __r38 = {}
  local ____x2 = __ls
  local ____i4 = 0
  while ____i4 < _35(____x2) do
    local __l11 = ____x2[____i4 + 1]
    if __l11 then
      local __n3 = _35(__r38)
      local ____o2 = __l11
      local __k2 = nil
      for __k2 in pairs(____o2) do
        local __v2 = ____o2[__k2]
        if number63(__k2) then
          __k2 = __k2 + __n3
        end
        __r38[__k2] = __v2
      end
    end
    ____i4 = ____i4 + 1
  end
  return __r38
end
function testify(x, test)
  if function63(x) then
    return x
  else
    if test then
      return function (y)
        return test(x, y)
      end
    else
      return function (y)
        return x == y
      end
    end
  end
end
function find(x, t)
  local __f = testify(x)
  local ____o3 = t
  local ____i6 = nil
  for ____i6 in pairs(____o3) do
    local __x3 = ____o3[____i6]
    local __y = __f(__x3)
    if __y then
      return __y
    end
  end
end
function first(x, l, pos)
  local __f1 = testify(x)
  local __i7 = either(pos, 0)
  local __n6 = -1
  local ____o4 = l
  local __k3 = nil
  for __k3 in pairs(____o4) do
    local __v3 = ____o4[__k3]
    if number63(__k3) then
      __k3 = __k3 - 1
      __n6 = max(__n6, __k3)
    end
  end
  __n6 = __n6 + 1
  while __i7 < __n6 do
    local __v4 = l[__i7 + 1]
    local ____y1 = __f1(__v4)
    if yes(____y1) then
      local __y2 = ____y1
      return __i7
    end
    __i7 = __i7 + 1
  end
end
function in63(x, t)
  return find(testify(x), t)
end
function pair(l)
  local __l12 = {}
  local __i9 = 0
  while __i9 < _35(l) do
    add(__l12, {l[__i9 + 1], l[__i9 + 1 + 1]})
    __i9 = __i9 + 1
    __i9 = __i9 + 1
  end
  return __l12
end
function sort(l, f)
  table.sort(l, f)
  return l
end
function map(f, x)
  local __t1 = {}
  local ____x5 = x
  local ____i10 = 0
  while ____i10 < _35(____x5) do
    local __v5 = ____x5[____i10 + 1]
    local __y3 = f(__v5)
    if is63(__y3) then
      add(__t1, __y3)
    end
    ____i10 = ____i10 + 1
  end
  local ____o5 = x
  local __k4 = nil
  for __k4 in pairs(____o5) do
    local __v6 = ____o5[__k4]
    if not number63(__k4) then
      local __y4 = f(__v6)
      if is63(__y4) then
        __t1[__k4] = __y4
      end
    end
  end
  return __t1
end
function keep(v, x)
  local __f2 = testify(v)
  return map(function (v)
    if yes(__f2(v)) then
      return v
    end
  end, x)
end
function keys63(t)
  local ____o6 = t
  local __k5 = nil
  for __k5 in pairs(____o6) do
    local __v7 = ____o6[__k5]
    if not number63(__k5) then
      return true
    end
  end
  return false
end
function empty63(t)
  local ____o7 = t
  local ____i13 = nil
  for ____i13 in pairs(____o7) do
    local __x6 = ____o7[____i13]
    return false
  end
  return true
end
function stash(args)
  if keys63(args) then
    local __p = {}
    local ____o8 = args
    local __k6 = nil
    for __k6 in pairs(____o8) do
      local __v8 = ____o8[__k6]
      if not number63(__k6) then
        __p[__k6] = __v8
      end
    end
    __p._stash = true
    add(args, __p)
  end
  return args
end
function unstash(args)
  if none63(args) then
    return {}
  else
    local __l2 = last(args)
    if obj63(__l2) and __l2._stash then
      local __args1 = almost(args)
      local ____o9 = __l2
      local __k7 = nil
      for __k7 in pairs(____o9) do
        local __v9 = ____o9[__k7]
        if not( __k7 == "_stash") then
          __args1[__k7] = __v9
        end
      end
      return __args1
    else
      return args
    end
  end
end
function destash33(l, args1)
  if obj63(l) and l._stash then
    local ____o10 = l
    local __k8 = nil
    for __k8 in pairs(____o10) do
      local __v10 = ____o10[__k8]
      if not( __k8 == "_stash") then
        args1[__k8] = __v10
      end
    end
  else
    return l
  end
end
function search(s, pattern, start)
  local __e6 = nil
  if start then
    __e6 = start + 1
  end
  local __start = __e6
  local __i17 = string.find(s, pattern, __start, true)
  return __i17 and __i17 - 1
end
function split(s, sep)
  if s == "" or sep == "" then
    return {}
  else
    local __l3 = {}
    local __n14 = _35(sep)
    while true do
      local __i18 = search(s, sep)
      if nil63(__i18) then
        break
      else
        add(__l3, clip(s, 0, __i18))
        s = clip(s, __i18 + __n14)
      end
    end
    add(__l3, s)
    return __l3
  end
end
function cat(...)
  local __xs = unstash({...})
  return either(reduce(function (a, b)
    return a .. b
  end, __xs), "")
end
function _43(...)
  local __xs1 = unstash({...})
  return either(reduce(function (a, b)
    return a + b
  end, __xs1), 0)
end
function _45(...)
  local __xs2 = unstash({...})
  return either(reduce(function (b, a)
    return a - b
  end, reverse(__xs2)), 0)
end
function _42(...)
  local __xs3 = unstash({...})
  return either(reduce(function (a, b)
    return a * b
  end, __xs3), 1)
end
function _47(...)
  local __xs4 = unstash({...})
  return either(reduce(function (b, a)
    return a / b
  end, reverse(__xs4)), 1)
end
function _37(...)
  local __xs5 = unstash({...})
  return either(reduce(function (b, a)
    return a % b
  end, reverse(__xs5)), 0)
end
local function pairwise(f, xs)
  local __i19 = 0
  while __i19 < edge(xs) do
    local __a = xs[__i19 + 1]
    local __b = xs[__i19 + 1 + 1]
    if not f(__a, __b) then
      return false
    end
    __i19 = __i19 + 1
  end
  return true
end
function _60(...)
  local __xs6 = unstash({...})
  return pairwise(function (a, b)
    return a < b
  end, __xs6)
end
function _62(...)
  local __xs7 = unstash({...})
  return pairwise(function (a, b)
    return a > b
  end, __xs7)
end
function _61(...)
  local __xs8 = unstash({...})
  return pairwise(function (a, b)
    return a == b
  end, __xs8)
end
function _6061(...)
  local __xs9 = unstash({...})
  return pairwise(function (a, b)
    return a <= b
  end, __xs9)
end
function _6261(...)
  local __xs10 = unstash({...})
  return pairwise(function (a, b)
    return a >= b
  end, __xs10)
end
function number(s)
  return tonumber(s)
end
function number_code63(n)
  return n > 47 and n < 58
end
function numeric63(s)
  local __n15 = _35(s)
  local __i20 = 0
  while __i20 < __n15 do
    if not number_code63(code(s, __i20)) then
      return false
    end
    __i20 = __i20 + 1
  end
  return some63(s)
end
function lowercase_code63(n)
  return n > 96 and n < 123
end
function camel_case(str)
  local __s = ""
  local __n16 = _35(str)
  local __i21 = 0
  while __i21 < __n16 do
    local __c = code(str, __i21)
    if __c == 45 and lowercase_code63(code(str, __i21 - 1) or 0) and lowercase_code63(code(str, __i21 + 1) or 0) then
      __i21 = __i21 + 1
      __c = code(str, __i21) - 32
    end
    __s = __s .. from_code(__c)
    __i21 = __i21 + 1
  end
  return __s
end
function escape(s)
  local __s1 = "\""
  local __i22 = 0
  while __i22 < _35(s) do
    local __c1 = char(s, __i22)
    local __e7 = nil
    if __c1 == "\n" then
      __e7 = "\\n"
    else
      local __e8 = nil
      if __c1 == "\r" then
        __e8 = "\\r"
      else
        local __e9 = nil
        if __c1 == "\"" then
          __e9 = "\\\""
        else
          local __e10 = nil
          if __c1 == "\\" then
            __e10 = "\\\\"
          else
            __e10 = __c1
          end
          __e9 = __e10
        end
        __e8 = __e9
      end
      __e7 = __e8
    end
    local __c11 = __e7
    __s1 = __s1 .. __c11
    __i22 = __i22 + 1
  end
  return __s1 .. "\""
end
function str(x, stack)
  if string63(x) then
    return escape(x)
  else
    if atom63(x) then
      return tostring(x)
    else
      if function63(x) then
        return "function"
      else
        if stack and in63(x, stack) then
          return "circular"
        else
          if not( type(x) == "table") then
            return escape(tostring(x))
          else
            local __s11 = "("
            local __sp = ""
            local __xs11 = {}
            local __ks = {}
            local __l4 = stack or {}
            add(__l4, x)
            local ____o11 = x
            local __k9 = nil
            for __k9 in pairs(____o11) do
              local __v11 = ____o11[__k9]
              if number63(__k9) then
                __xs11[__k9] = str(__v11, __l4)
              else
                if not string63(__k9) then
                  __k9 = str(__k9, __l4)
                end
                add(__ks, __k9 .. ":")
                add(__ks, str(__v11, __l4))
              end
            end
            drop(__l4)
            local ____o12 = join(__xs11, __ks)
            local ____i24 = nil
            for ____i24 in pairs(____o12) do
              local __v12 = ____o12[____i24]
              __s11 = __s11 .. __sp .. __v12
              __sp = " "
            end
            return __s11 .. ")"
          end
        end
      end
    end
  end
end
function apply(f, args)
  return f((unpack or table.unpack)(stash(args)))
end
function call(f, ...)
  return f(...)
end
function setenv(k, ...)
  local ____r78 = unstash({...})
  local __k10 = destash33(k, ____r78)
  local ____id = ____r78
  local __keys = cut(____id, 0)
  if string63(__k10) then
    local __e11 = nil
    if __keys.toplevel then
      __e11 = hd(environment)
    else
      __e11 = last(environment)
    end
    local __frame = __e11
    local __entry = __frame[__k10] or {}
    local ____o13 = __keys
    local __k11 = nil
    for __k11 in pairs(____o13) do
      local __v13 = ____o13[__k11]
      __entry[__k11] = __v13
    end
    __frame[__k10] = __entry
    return __frame[__k10]
  end
end
local math = math
abs = math.abs
acos = math.acos
asin = math.asin
atan = math.atan
atan2 = math.atan2
ceil = math.ceil
cos = math.cos
floor = math.floor
log = math.log
log10 = math.log10
max = math.max
min = math.min
pow = math.pow
random = math.random
sin = math.sin
sinh = math.sinh
sqrt = math.sqrt
tan = math.tan
tanh = math.tanh
trunc = math.floor
setenv("quote", {_stash = true, macro = function (form)
  return quoted(form)
end})
setenv("quasiquote", {_stash = true, macro = function (form)
  return quasiexpand(form, 1)
end})
function get_place(place, setfn)
  local __place = macroexpand(place)
  if atom63(__place) or hd(__place) == "get" and nil63(getenv("get", "expander")) or accessor_literal63(hd(tl(__place))) then
    return setfn(__place, function (v)
      return {"%set", __place, v}
    end)
  else
    local __head = hd(__place)
    local __gf = getenv(__head, "expander")
    if __gf then
      return apply(__gf, join({setfn}, tl(__place)))
    else
      return error(str(__place) .. " is not a valid place expression")
    end
  end
end
setenv("let-place", {_stash = true, macro = function (vars, place, ...)
  local ____r7 = unstash({...})
  local __vars1 = destash33(vars, ____r7)
  local __place2 = destash33(place, ____r7)
  local ____id1 = ____r7
  local __body1 = cut(____id1, 0)
  return {"get-place", __place2, join({"fn", __vars1}, __body1)}
end})
setenv("define-expander", {_stash = true, macro = function (name, handler)
  local ____x10 = {"setenv", {"quote", name}}
  ____x10.expander = handler
  local __form1 = ____x10
  eval(__form1)
  return __form1
end})
function define_setter(name, setter, setfn, args, vars)
  if none63(args) then
    local __vars2 = reverse(vars)
    return setfn(join({name}, __vars2), function (v)
      return apply(setter, join({v}, __vars2))
    end)
  else
    local __v = hd(args)
    return define_setter(name, setter, setfn, tl(args), join({__v}, vars))
  end
end
setenv("define-setter", {_stash = true, macro = function (name, arglist, ...)
  local ____r13 = unstash({...})
  local __name1 = destash33(name, ____r13)
  local __arglist1 = destash33(arglist, ____r13)
  local ____id3 = ____r13
  local __body3 = cut(____id3, 0)
  local ____x25 = {"setfn"}
  ____x25.rest = "args"
  return {"define-expander", __name1, {"fn", ____x25, {"%call", "define-setter", {"quote", __name1}, join({"fn", __arglist1}, __body3), "setfn", "args"}}}
end})
setenv("set", {_stash = true, macro = function (...)
  local __args1 = unstash({...})
  return join({"do"}, map(function (__x34)
    local ____id5 = __x34
    local __lh1 = ____id5[1]
    local __rh1 = ____id5[2]
    return get_place(__lh1, function (getter, setter)
      return setter(__rh1)
    end)
  end, pair(__args1)))
end})
setenv("at", {_stash = true, macro = function (l, i)
  if target == "lua" and number63(i) then
    i = i + 1
  else
    if target == "lua" then
      i = {"+", i, 1}
    end
  end
  return {"get", l, i}
end})
setenv("wipe", {_stash = true, macro = function (place)
  if target == "lua" then
    return {"set", place, "nil"}
  else
    return {"%delete", place}
  end
end})
setenv("list", {_stash = true, macro = function (...)
  local __body5 = unstash({...})
  local __x53 = unique("x")
  local __l1 = {}
  local __forms1 = {}
  local ____o1 = __body5
  local __k1 = nil
  for __k1 in pairs(____o1) do
    local __v2 = ____o1[__k1]
    if number63(__k1) then
      __l1[__k1] = __v2
    else
      add(__forms1, {"set", {"get", __x53, {"quote", __k1}}, __v2})
    end
  end
  if some63(__forms1) then
    return join({"let", __x53, join({"%array"}, __l1)}, __forms1, {__x53})
  else
    return join({"%array"}, __l1)
  end
end})
setenv("if", {_stash = true, macro = function (...)
  local __branches1 = unstash({...})
  return hd(expand_if(__branches1))
end})
setenv("case", {_stash = true, macro = function (expr, ...)
  local ____r25 = unstash({...})
  local __expr1 = destash33(expr, ____r25)
  local ____id8 = ____r25
  local __clauses1 = cut(____id8, 0)
  local __x76 = unique("x")
  local __eq1 = function (_)
    return {"=", {"quote", _}, __x76}
  end
  local __cl1 = function (__x79)
    local ____id9 = __x79
    local __a1 = ____id9[1]
    local __b1 = ____id9[2]
    if nil63(__b1) then
      return {__a1}
    else
      if string63(__a1) or number63(__a1) then
        return {__eq1(__a1), __b1}
      else
        if one63(__a1) then
          return {__eq1(hd(__a1)), __b1}
        else
          if _35(__a1) > 1 then
            return {join({"or"}, map(__eq1, __a1)), __b1}
          end
        end
      end
    end
  end
  return {"let", __x76, __expr1, join({"if"}, apply(join, map(__cl1, pair(__clauses1))))}
end})
setenv("when", {_stash = true, macro = function (cond, ...)
  local ____r29 = unstash({...})
  local __cond1 = destash33(cond, ____r29)
  local ____id11 = ____r29
  local __body7 = cut(____id11, 0)
  return {"if", __cond1, join({"do"}, __body7)}
end})
setenv("unless", {_stash = true, macro = function (cond, ...)
  local ____r31 = unstash({...})
  local __cond3 = destash33(cond, ____r31)
  local ____id13 = ____r31
  local __body9 = cut(____id13, 0)
  return {"if", {"not", __cond3}, join({"do"}, __body9)}
end})
setenv("obj", {_stash = true, macro = function (...)
  local __body11 = unstash({...})
  return join({"%object"}, mapo(function (x)
    return x
  end, __body11))
end})
setenv("let", {_stash = true, macro = function (bs, ...)
  local ____r35 = unstash({...})
  local __bs11 = destash33(bs, ____r35)
  local ____id18 = ____r35
  local __body13 = cut(____id18, 0)
  if atom63(__bs11) then
    return join({"let", {__bs11, hd(__body13)}}, tl(__body13))
  else
    if none63(__bs11) then
      return join({"do"}, __body13)
    else
      local ____id19 = __bs11
      local __lh3 = ____id19[1]
      local __rh3 = ____id19[2]
      local __bs21 = cut(____id19, 2)
      local ____id20 = bind(__lh3, __rh3)
      local __id21 = ____id20[1]
      local __val1 = ____id20[2]
      local __bs12 = cut(____id20, 2)
      local __id121 = unique(__id21)
      return {"do", {"%local", __id121, __val1}, {"let-symbol", {__id21, __id121}, join({"let", join(__bs12, __bs21)}, __body13)}}
    end
  end
end})
setenv("with", {_stash = true, macro = function (x, v, ...)
  local ____r37 = unstash({...})
  local __x129 = destash33(x, ____r37)
  local __v4 = destash33(v, ____r37)
  local ____id23 = ____r37
  local __body15 = cut(____id23, 0)
  return join({"let", {__x129, __v4}}, __body15, {__x129})
end})
setenv("let-when", {_stash = true, macro = function (x, v, ...)
  local ____r39 = unstash({...})
  local __x141 = destash33(x, ____r39)
  local __v6 = destash33(v, ____r39)
  local ____id25 = ____r39
  local __body17 = cut(____id25, 0)
  local __y1 = unique("y")
  return {"let", __y1, __v6, {"when", {"yes", __y1}, join({"let", {__x141, __y1}}, __body17)}}
end})
setenv("define-macro", {_stash = true, macro = function (name, args, ...)
  local ____r41 = unstash({...})
  local __name3 = destash33(name, ____r41)
  local __args3 = destash33(args, ____r41)
  local ____id27 = ____r41
  local __body19 = cut(____id27, 0)
  local ____x152 = {"setenv", {"quote", __name3}}
  ____x152.macro = join({"fn", __args3}, __body19)
  local __form3 = ____x152
  eval(__form3)
  return __form3
end})
setenv("define-special", {_stash = true, macro = function (name, args, ...)
  local ____r43 = unstash({...})
  local __name5 = destash33(name, ____r43)
  local __args5 = destash33(args, ____r43)
  local ____id29 = ____r43
  local __body21 = cut(____id29, 0)
  local ____x160 = {"setenv", {"quote", __name5}}
  ____x160.special = join({"fn", __args5}, __body21)
  local __form5 = join(____x160, keys(__body21))
  eval(__form5)
  return __form5
end})
setenv("define-symbol", {_stash = true, macro = function (name, expansion)
  setenv(name, {_stash = true, symbol = expansion})
  local ____x166 = {"setenv", {"quote", name}}
  ____x166.symbol = {"quote", expansion}
  return ____x166
end})
setenv("define-reader", {_stash = true, macro = function (__x175, ...)
  local ____id32 = __x175
  local __char1 = ____id32[1]
  local __s1 = ____id32[2]
  local ____r47 = unstash({...})
  local ____x175 = destash33(__x175, ____r47)
  local ____id33 = ____r47
  local __body23 = cut(____id33, 0)
  return {"set", {"get", "read-table", __char1}, join({"fn", {__s1}}, __body23)}
end})
setenv("define", {_stash = true, macro = function (name, x, ...)
  local ____r49 = unstash({...})
  local __name7 = destash33(name, ____r49)
  local __x186 = destash33(x, ____r49)
  local ____id35 = ____r49
  local __body25 = cut(____id35, 0)
  setenv(__name7, {_stash = true, variable = true})
  if some63(__body25) then
    return join({"%local-function", __name7}, bind42(__x186, __body25))
  else
    return {"%local", __name7, __x186}
  end
end})
setenv("define-global", {_stash = true, macro = function (name, x, ...)
  local ____r51 = unstash({...})
  local __name9 = destash33(name, ____r51)
  local __x194 = destash33(x, ____r51)
  local ____id37 = ____r51
  local __body27 = cut(____id37, 0)
  setenv(__name9, {_stash = true, toplevel = true, variable = true})
  if some63(__body27) then
    return join({"%global-function", __name9}, bind42(__x194, __body27))
  else
    return {"set", __name9, __x194}
  end
end})
setenv("with-frame", {_stash = true, macro = function (...)
  local __body29 = unstash({...})
  local __x206 = unique("x")
  return {"do", {"add", "environment", {"obj"}}, {"with", __x206, join({"do"}, __body29), {"drop", "environment"}}}
end})
setenv("with-bindings", {_stash = true, macro = function (__x219, ...)
  local ____id40 = __x219
  local __names1 = ____id40[1]
  local ____r53 = unstash({...})
  local ____x219 = destash33(__x219, ____r53)
  local ____id41 = ____r53
  local __body31 = cut(____id41, 0)
  local __x221 = unique("x")
  local ____x224 = {"setenv", __x221}
  ____x224.variable = true
  return join({"with-frame", {"each", __x221, __names1, ____x224}}, __body31)
end})
setenv("let-macro", {_stash = true, macro = function (definitions, ...)
  local ____r56 = unstash({...})
  local __definitions1 = destash33(definitions, ____r56)
  local ____id43 = ____r56
  local __body33 = cut(____id43, 0)
  add(environment, {})
  map(function (m)
    return macroexpand(join({"define-macro"}, m))
  end, __definitions1)
  local ____x230 = join({"do"}, macroexpand(__body33))
  drop(environment)
  return ____x230
end})
setenv("let-symbol", {_stash = true, macro = function (expansions, ...)
  local ____r60 = unstash({...})
  local __expansions1 = destash33(expansions, ____r60)
  local ____id46 = ____r60
  local __body35 = cut(____id46, 0)
  add(environment, {})
  map(function (__x240)
    local ____id47 = __x240
    local __name11 = ____id47[1]
    local __exp1 = ____id47[2]
    return macroexpand({"define-symbol", __name11, __exp1})
  end, pair(__expansions1))
  local ____x239 = join({"do"}, macroexpand(__body35))
  drop(environment)
  return ____x239
end})
setenv("let-unique", {_stash = true, macro = function (names, ...)
  local ____r64 = unstash({...})
  local __names3 = destash33(names, ____r64)
  local ____id49 = ____r64
  local __body37 = cut(____id49, 0)
  local __bs3 = map(function (n)
    return {n, {"unique", {"quote", n}}}
  end, __names3)
  return join({"let", apply(join, __bs3)}, __body37)
end})
setenv("fn", {_stash = true, macro = function (args, ...)
  local ____r67 = unstash({...})
  local __args7 = destash33(args, ____r67)
  local ____id51 = ____r67
  local __body39 = cut(____id51, 0)
  return join({"%function"}, bind42(__args7, __body39))
end})
setenv("apply", {_stash = true, macro = function (f, ...)
  local ____r69 = unstash({...})
  local __f1 = destash33(f, ____r69)
  local ____id53 = ____r69
  local __args9 = cut(____id53, 0)
  if _35(__args9) > 1 then
    return {"%call", "apply", __f1, {"join", join({"list"}, almost(__args9)), last(__args9)}}
  else
    return join({"%call", "apply", __f1}, __args9)
  end
end})
setenv("guard", {_stash = true, macro = function (expr)
  if target == "js" then
    return {{"fn", join(), {"%try", {"list", true, expr}}}}
  else
    local ____x301 = {"obj"}
    ____x301.stack = {{"get", "debug", {"quote", "traceback"}}}
    ____x301.message = {"if", {"string?", "m"}, {"clip", "m", {"+", {"or", {"search", "m", "\": \""}, -2}, 2}}, {"nil?", "m"}, "\"\"", {"str", "m"}}
    return {"list", {"xpcall", {"fn", join(), expr}, {"fn", {"m"}, {"if", {"obj?", "m"}, "m", ____x301}}}}
  end
end})
setenv("each", {_stash = true, macro = function (x, t, ...)
  local ____r73 = unstash({...})
  local __x326 = destash33(x, ____r73)
  local __t1 = destash33(t, ____r73)
  local ____id56 = ____r73
  local __body41 = cut(____id56, 0)
  local __o3 = unique("o")
  local __n3 = unique("n")
  local __i3 = unique("i")
  local __e4 = nil
  if atom63(__x326) then
    __e4 = {__i3, __x326}
  else
    local __e5 = nil
    if _35(__x326) > 1 then
      __e5 = __x326
    else
      __e5 = {__i3, hd(__x326)}
    end
    __e4 = __e5
  end
  local ____id57 = __e4
  local __k3 = ____id57[1]
  local __v8 = ____id57[2]
  return {"let", {__o3, __t1}, {"for", {__k3}, {"pairs", __o3}, join({"let", {__v8, {"get", __o3, __k3}}}, __body41)}}
end})
setenv("for", {_stash = true, macro = function (i, to, ...)
  local ____r76 = unstash({...})
  local __i5 = destash33(i, ____r76)
  local __to1 = destash33(to, ____r76)
  local ____id59 = ____r76
  local __body43 = cut(____id59, 0)
  if obj63(__i5) then
    return {"let", apply(join, map(function (x)
      return {x, "nil"}
    end, __i5)), {"%for", __to1, join({"%names"}, __i5), join({"do"}, __body43)}}
  else
    return {"let", __i5, 0, join({"while", {"<", __i5, __to1}}, __body43, {{"inc", __i5}})}
  end
end})
setenv("step", {_stash = true, macro = function (v, t, ...)
  local ____r79 = unstash({...})
  local __v10 = destash33(v, ____r79)
  local __t3 = destash33(t, ____r79)
  local ____id61 = ____r79
  local __body45 = cut(____id61, 0)
  local __x369 = unique("x")
  local __i7 = unique("i")
  return {"let", {__x369, __t3}, {"for", __i7, {"#", __x369}, join({"let", {__v10, {"at", __x369, __i7}}}, __body45)}}
end})
setenv("set-of", {_stash = true, macro = function (...)
  local __xs1 = unstash({...})
  local __l3 = {}
  local ____o5 = __xs1
  local ____i9 = nil
  for ____i9 in pairs(____o5) do
    local __x381 = ____o5[____i9]
    __l3[__x381] = true
  end
  return join({"obj"}, __l3)
end})
setenv("language", {_stash = true, macro = function ()
  return {"quote", target}
end})
setenv("target", {_stash = true, macro = function (...)
  local __clauses3 = unstash({...})
  return __clauses3[target]
end})
setenv("join!", {_stash = true, macro = function (a, ...)
  local ____r83 = unstash({...})
  local __a3 = destash33(a, ____r83)
  local ____id63 = ____r83
  local __bs5 = cut(____id63, 0)
  return {"set", __a3, join({"join", __a3}, __bs5)}
end})
setenv("cat!", {_stash = true, macro = function (a, ...)
  local ____r85 = unstash({...})
  local __a5 = destash33(a, ____r85)
  local ____id65 = ____r85
  local __bs7 = cut(____id65, 0)
  return {"set", __a5, join({"cat", __a5}, __bs7)}
end})
setenv("inc", {_stash = true, macro = function (n, by)
  local __e6 = nil
  if nil63(by) then
    __e6 = 1
  else
    __e6 = by
  end
  return {"set", n, {"+", n, __e6}}
end})
setenv("dec", {_stash = true, macro = function (n, by)
  local __e7 = nil
  if nil63(by) then
    __e7 = 1
  else
    __e7 = by
  end
  return {"set", n, {"-", n, __e7}}
end})
setenv("with-indent", {_stash = true, macro = function (form)
  local __x412 = unique("x")
  return {"do", {"inc", "indent-level"}, {"with", __x412, form, {"dec", "indent-level"}}}
end})
setenv("undefined?", {_stash = true, macro = function (x)
  local ____x421 = {"target"}
  ____x421.lua = {"=", x, "nil"}
  ____x421.js = {"=", {"typeof", x}, "\"undefined\""}
  return ____x421
end})
setenv("export", {_stash = true, macro = function (...)
  local __names5 = unstash({...})
  local ____x443 = {"target"}
  ____x443.lua = {"return", "exports"}
  return join({"with", "exports", {"if", {"undefined?", "exports"}, {"obj"}, "exports"}}, map(function (k)
    return {"set", {"exports", "." .. k}, k}
  end, __names5), {____x443})
end})
setenv("when-compiling", {_stash = true, macro = function (...)
  local __body47 = unstash({...})
  return eval(join({"do"}, __body47))
end})
setenv("during-compilation", {_stash = true, macro = function (...)
  local __body49 = unstash({...})
  local __form7 = join({"do"}, __body49)
  eval(__form7)
  return __form7
end})
setenv("hd", {_stash = true, expander = function (setfn, ...)
  local ____r98 = unstash({...})
  local __setfn1 = destash33(setfn, ____r98)
  local ____id67 = ____r98
  local __args11 = cut(____id67, 0)
  return define_setter("hd", function (v, l)
    return {"set", {"at", l, 0}, v}
  end, __setfn1, __args11)
end})
local reader = require("./reader")
local compiler = require("./compiler")
local system = require("./system")
local function eval_print(form)
  local ____id = {xpcall(function ()
    return compiler.eval(form)
  end, function (m)
    if obj63(m) then
      return m
    else
      local __e = nil
      if string63(m) then
        __e = clip(m, (search(m, ": ") or -2) + 2)
      else
        local __e1 = nil
        if nil63(m) then
          __e1 = ""
        else
          __e1 = str(m)
        end
        __e = __e1
      end
      return {stack = debug.traceback(), message = __e}
    end
  end)}
  local __ok = ____id[1]
  local __v = ____id[2]
  if not __ok then
    return print("error: " .. __v.message .. "\n" .. __v.stack)
  else
    if is63(__v) then
      return print(str(__v))
    end
  end
end
local function rep(s)
  return eval_print(reader.readString(s))
end
local function repl()
  local __buf = ""
  local function rep1(s)
    __buf = __buf .. s
    local __more = {}
    local __form = reader.readString(__buf, __more)
    if not( __form == __more) then
      eval_print(__form)
      __buf = ""
      return system.write("> ")
    end
  end
  system.write("> ")
  while true do
    local __s = io.read()
    if __s then
      rep1(__s .. "\n")
    else
      break
    end
  end
end
function read_file(path)
  return system.readFile(path)
end
function write_file(path, data)
  return system.writeFile(path, data)
end
function read_from_file(path)
  local __s1 = reader.stream(system.readFile(path))
  local __body = reader.readAll(__s1)
  return join({"do"}, __body)
end
function expand_file(path)
  return compiler.expand(read_from_file(path))
end
function compile_file(path)
  local __form1 = expand_file(path)
  return compiler.compile(__form1, {_stash = true, stmt = true})
end
function _load(path)
  local __previous = target
  target = "lua"
  local __code = compile_file(path)
  target = __previous
  return compiler.run(__code)
end
function script_file63(path)
  return string63(path) and not( "-" == char(path, 0) or ".js" == clip(path, _35(path) - 3) or ".lua" == clip(path, _35(path) - 4))
end
function run_file(path)
  if script_file63(path) then
    return _load(path)
  else
    return compiler.run(read_file(path))
  end
end
function read_from_string(str, start, _end)
  local __s2 = reader.stream(str)
  __s2.pos = either(start, __s2.pos)
  __s2.len = either(_end, __s2.len)
  local __form2 = reader.read(__s2)
  if nil63(__form2) then
    return error("End of string during parsing")
  else
    local ____x2 = {__form2}
    ____x2.rest = __s2.pos
    return ____x2
  end
end
function readable_string63(str)
  local __id4 = string63(str)
  local __e4 = nil
  if __id4 then
    local ____id1 = {xpcall(function ()
      return read_from_string(str)
    end, function (m)
      if obj63(m) then
        return m
      else
        local __e5 = nil
        if string63(m) then
          __e5 = clip(m, (search(m, ": ") or -2) + 2)
        else
          local __e6 = nil
          if nil63(m) then
            __e6 = ""
          else
            __e6 = str(m)
          end
          __e5 = __e6
        end
        return {stack = debug.traceback(), message = __e5}
      end
    end)}
    local __ok1 = ____id1[1]
    local __v1 = ____id1[2]
    __e4 = __ok1 and hd(__v1) == str
  else
    __e4 = __id4
  end
  return __e4
end
function pp_to_string(x, stack)
  if nil63(x) then
    return "nil"
  else
    if nan63(x) then
      return "nan"
    else
      if x == inf then
        return "inf"
      else
        if x == _inf then
          return "-inf"
        else
          if boolean63(x) then
            if x then
              return "true"
            else
              return "false"
            end
          else
            if string63(x) then
              if readable_string63(x) then
                return x
              else
                return escape(x)
              end
            else
              if function63(x) then
                return "function"
              else
                if atom63(x) then
                  return tostring(x)
                else
                  if stack and in63(x, stack) then
                    return "circular"
                  else
                    if not( type(x) == "table") then
                      return escape(tostring(x))
                    else
                      local __s3 = "("
                      local __sp = ""
                      local __xs = {}
                      local __ks = {}
                      local __l = stack or {}
                      add(__l, x)
                      local ____o = x
                      local __k = nil
                      for __k in pairs(____o) do
                        local __v2 = ____o[__k]
                        if number63(__k) then
                          __xs[__k] = pp_to_string(__v2, __l)
                        else
                          if not string63(__k) then
                            __k = pp_to_string(__k, __l)
                          end
                          add(__ks, __k .. ":")
                          add(__ks, pp_to_string(__v2, __l))
                        end
                      end
                      drop(__l)
                      local ____o1 = join(__xs, __ks)
                      local ____i1 = nil
                      for ____i1 in pairs(____o1) do
                        local __v3 = ____o1[____i1]
                        __s3 = __s3 .. __sp .. __v3
                        __sp = " "
                      end
                      return __s3 .. ")"
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
local function usage()
  return "\nUsage:\n  lumen <file> [<args>...]\n  lumen [options] [<object-files>...]\n\n  <file>          Program read from script file\n  <object-files>  Loaded before compiling <input>\n\nOptions:\n  -c <input>...   Compile input files\n  -o <output>     Write compiler output to <output>\n  -t <target>     Set target language (default: lua)\n  -e <expr>...    Expressions to evaluate\n"
end
local function main(argv)
  argv = argv or get_argv()
  local __arg = hd(argv)
  if script_file63(__arg) then
    set_argv(tl(argv))
    return _load(__arg)
  end
  local __args = parse_arguments({c = "compile", o = "output", t = "target", e = "eval", h = "help", r = "repl"}, argv)
  if script_file63(hd(__args)) then
    return _load(hd(__args))
  else
    if __args.help then
      return print(usage())
    else
      local __pre = keep(string63, __args)
      local __cmds = keep(obj63, __args)
      local __input = ""
      local __enter_repl = true
      local ____x4 = __pre
      local ____i2 = 0
      while ____i2 < _35(____x4) do
        local __file = ____x4[____i2 + 1]
        run_file(__file)
        ____i2 = ____i2 + 1
      end
      local ____x5 = __cmds
      local ____i3 = 0
      while ____i3 < _35(____x5) do
        local ____id2 = ____x5[____i3 + 1]
        local __a = ____id2[1]
        local __val = ____id2[2]
        if __a == "target" then
          target = hd(__val)
          break
        end
        ____i3 = ____i3 + 1
      end
      local ____x6 = __cmds
      local ____i4 = 0
      while ____i4 < _35(____x6) do
        local ____id3 = ____x6[____i4 + 1]
        local __a1 = ____id3[1]
        local __val1 = ____id3[2]
        if __a1 == "help" then
          print(usage())
        else
          if __a1 == "repl" then
            __enter_repl = true
          else
            if boolean63(__val1) or none63(__val1) then
              print("missing argument for " .. __a1)
            else
              if __a1 == "compile" then
                local ____x7 = __val1
                local ____i5 = 0
                while ____i5 < _35(____x7) do
                  local __x8 = ____x7[____i5 + 1]
                  __input = __input .. compile_file(__x8)
                  ____i5 = ____i5 + 1
                end
                __enter_repl = false
              else
                if __a1 == "output" then
                  write_file(hd(__val1), __input)
                  __input = ""
                else
                  if __a1 == "target" then
                    target = hd(__val1)
                  else
                    if __a1 == "eval" then
                      local ____x9 = __val1
                      local ____i6 = 0
                      while ____i6 < _35(____x9) do
                        local __x10 = ____x9[____i6 + 1]
                        rep(__x10)
                        ____i6 = ____i6 + 1
                      end
                      __enter_repl = false
                    end
                  end
                end
              end
            end
          end
        end
        ____i4 = ____i4 + 1
      end
      if some63(__input) then
        print(__input)
      end
      if __enter_repl or __args.repl then
        return repl()
      end
    end
  end
end
local __e7 = nil
if exports == nil then
  __e7 = {}
else
  __e7 = exports
end
local __exports = __e7
__exports.reader = reader
__exports.compiler = compiler
__exports.system = system
__exports.main = main
return __exports
