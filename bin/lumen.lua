_G.environment = {{}}
_G.target = "lua"
local __v = nil
function _G.values(...)
  return ...
end
function _G.results(x, ...)
  return {x, ...}
end
function _G.nil63(x)
  return x == nil
end
function _G.is63(x)
  return not nil63(x)
end
function _G.no(x)
  return nil63(x) or x == false
end
function _G.yes(x)
  return not no(x)
end
function _G.either(x, y)
  if is63(x) then
    return x
  else
    return y
  end
end
function _G.has63(l, k)
  return is63(l[k])
end
function _G.get63(l, k, default)
  if has63(l, k) then
    return l[k]
  else
    return default
  end
end
function _G._35(x)
  return #x
end
function _G.none63(x)
  return _35(x) == 0
end
function _G.some63(x)
  return _35(x) > 0
end
function _G.one63(x)
  return _35(x) == 1
end
function _G.two63(x)
  return _35(x) == 2
end
function _G.hd(l)
  return l[1]
end
function _G.string63(x)
  return type(x) == "string"
end
function _G.number63(x)
  return type(x) == "number"
end
function _G.boolean63(x)
  return type(x) == "boolean"
end
function _G.function63(x)
  return type(x) == "function"
end
function _G.obj63(x)
  return is63(x) and type(x) == "table"
end
function _G.atom63(x)
  return nil63(x) or string63(x) or number63(x) or boolean63(x)
end
function _G.hd63(l, x)
  local __id4 = obj63(l)
  local __e2 = nil
  if __id4 then
    local __e3 = nil
    if function63(x) then
      __e3 = x(hd(l))
    else
      local __e4 = nil
      if nil63(x) then
        __e4 = hd(l)
      else
        __e4 = hd(l) == x
      end
      __e3 = __e4
    end
    __e2 = __e3
  else
    __e2 = __id4
  end
  return __e2
end
_G.nan = 0 / 0
_G.inf = 1 / 0
_G._inf = - inf
function _G.nan63(n)
  return not( n == n)
end
function _G.inf63(n)
  return n == inf or n == _inf
end
function _G.clip(s, from, upto)
  return string.sub(s, from + 1, upto)
end
function _G.natural63(i)
  return number63(i) and i > 0 and i % 1 == 0
end
function _G.index63(i)
  return natural63(i)
end
function _G.iterate(o, f, l, r)
  local __from = inf
  local __upto = _inf
  local ____o = l
  local __k = nil
  for __k in pairs(____o) do
    local __v1 = ____o[__k]
    if index63(__k) then
      if __k < __from then
        __from = __k
      end
      if __k > __upto then
        __upto = __k
      end
    else
      r = f(r, __v1, __k, nil)
    end
  end
  __from = __from - 1
  local __i1 = __from
  while __i1 < __upto do
    local __v2 = l[__i1 + 1]
    r = f(r, __v2, nil, __i1)
    __i1 = __i1 + 1
  end
  local __o1 = o or {}
  __o1.result = r
  __o1.from = __from
  __o1.upto = __upto
  return __o1
end
local __o2 = {}
function _G.reduce(f, l, r)
  return iterate(__o2, f, l, r).result
end
function _G.cut(x, from, upto)
  if string63(x) then
    return clip(x, from, upto)
  else
    local __l = {}
    local __j = 0
    local __e5 = nil
    if nil63(from) or from < 0 then
      __e5 = 0
    else
      __e5 = from
    end
    local __i2 = __e5
    local __n1 = _35(x)
    local __e6 = nil
    if nil63(upto) or upto > __n1 then
      __e6 = __n1
    else
      __e6 = upto
    end
    local __upto1 = __e6
    while __i2 < __upto1 do
      __l[__j + 1] = x[__i2 + 1]
      __i2 = __i2 + 1
      __j = __j + 1
    end
    local ____o3 = x
    local __k1 = nil
    for __k1 in pairs(____o3) do
      local __v3 = ____o3[__k1]
      if not number63(__k1) then
        __l[__k1] = __v3
      end
    end
    return __l
  end
end
function _G.props(x)
  local __t = {}
  local ____o4 = x
  local __k2 = nil
  for __k2 in pairs(____o4) do
    local __v4 = ____o4[__k2]
    if not number63(__k2) then
      __t[__k2] = __v4
    end
  end
  return __t
end
function _G.edge(x)
  return _35(x) - 1
end
function _G.inner(x)
  return clip(x, 1, edge(x))
end
function _G.tl(l)
  return cut(l, 1)
end
function _G.char(s, n)
  return clip(s, n, n + 1)
end
function _G.code(s, n)
  local __e7 = nil
  if n then
    __e7 = n + 1
  end
  return string.byte(s, __e7)
end
function _G.from_code(n)
  return string.char(n)
end
function _G.string_literal63(x)
  return string63(x) and char(x, 0) == "\""
end
function _G.id_literal63(x)
  return string63(x) and char(x, 0) == "|"
end
function _G.add(l, x)
  return table.insert(l, x)
end
function _G.drop(l)
  return table.remove(l)
end
function _G.last(l)
  if string63(l) then
    return char(l, edge(l))
  else
    return l[edge(l) + 1]
  end
end
function _G.almost(l)
  return cut(l, 0, edge(l))
end
function _G.reverse(l)
  local __l1 = props(l)
  local __i5 = edge(l)
  while __i5 >= 0 do
    add(__l1, l[__i5 + 1])
    __i5 = __i5 - 1
  end
  return __l1
end
function _G.join(...)
  local __ls = unstash({...})
  local __r44 = {}
  local ____x3 = __ls
  local ____i6 = 0
  while ____i6 < _35(____x3) do
    local __l11 = ____x3[____i6 + 1]
    if __l11 then
      local __n4 = _35(__r44)
      local ____o5 = __l11
      local __k3 = nil
      for __k3 in pairs(____o5) do
        local __v5 = ____o5[__k3]
        if number63(__k3) then
          __k3 = __k3 + __n4
        end
        __r44[__k3] = __v5
      end
    end
    ____i6 = ____i6 + 1
  end
  return __r44
end
function _G.testify(x, test)
  if function63(x) then
    return x
  else
    if test then
      return function(y)
        return test(x, y)
      end
    else
      return function(y)
        return x == y
      end
    end
  end
end
function _G.testify_of(x)
  return testify(x, get63)
end
function _G.find(x, t)
  local __f = testify(x)
  local ____o6 = t
  local ____i8 = nil
  for ____i8 in pairs(____o6) do
    local __x4 = ____o6[____i8]
    local __y = __f(__x4)
    if yes(__y) then
      return __y
    end
  end
end
function _G.first(x, l, pos)
  local __f1 = testify(x)
  local __i9 = either(pos, 0)
  local __n7 = -1
  local ____o7 = l
  local __k4 = nil
  for __k4 in pairs(____o7) do
    local __v6 = ____o7[__k4]
    if number63(__k4) then
      __k4 = __k4 - 1
      __n7 = max(__n7, __k4)
    end
  end
  __n7 = __n7 + 1
  while __i9 < __n7 do
    local __v7 = l[__i9 + 1]
    local ____y1 = __f1(__v7)
    if yes(____y1) then
      local __y2 = ____y1
      return __i9
    end
    __i9 = __i9 + 1
  end
end
function _G.in63(x, t)
  return find(testify(x), t)
end
_G.whitespace = {[" "] = true, ["\n"] = true, ["\t"] = true, ["\r"] = true}
function _G.whitec(c)
  return get63(_G.whitespace, c)
end
function _G.nonwhite(c)
  return not whitec(c)
end
function _G.blank(s)
  return nil63(s) or (function(...)
    return not find(...)
  end)(function(...)
  return not whitec(...)
end, s)
end
function _G.nonblank(s)
  if not blank(s) then
    return s
  end
end
function _G.trim(s, __x5, ...)
  local __e8 = nil
  if __x5 == nil then
    __e8 = whitec
  else
    __e8 = __x5
  end
  local __test = __e8
  local ____r58 = unstash({...})
  local __s = destash33(s, ____r58)
  local ____x5 = destash33(__x5, ____r58)
  local ____id = ____r58
  local __e9 = nil
  if ____id.where == nil then
    __e9 = "both"
  else
    __e9 = ____id.where
  end
  local __where = __e9
  local __f2 = testify(__test)
  local __p1 = first(function(...)
  return not __f2(...)
end, __s)
  if is63(__p1) then
    local __e10 = nil
    if __where == "front" or __where == "both" then
      __e10 = __p1
    else
      __e10 = 0
    end
    local __e11 = nil
    if __where == "end" or __where == "both" then
      local __i11 = _35(__s) - 1
      while __i11 > __p1 and __f2(__s[__i11 + 1]) do
        __i11 = __i11 - 1
      end
      __e11 = __i11 + 1
    end
    return cut(__s, __e10, __e11)
  else
    return ""
  end
end
function _G.ltrim(s, __x7)
  local __e12 = nil
  if __x7 == nil then
    __e12 = whitec
  else
    __e12 = __x7
  end
  local __test1 = __e12
  return trim(s, __test1, {_stash = true, where = "front"})
end
function _G.rtrim(s, __x8)
  local __e13 = nil
  if __x8 == nil then
    __e13 = whitec
  else
    __e13 = __x8
  end
  local __test2 = __e13
  return trim(s, __test2, {_stash = true, where = "end"})
end
function _G.str_replace(s, before, after, ...)
  local ____r62 = unstash({...})
  local __s1 = destash33(s, ____r62)
  local __before = destash33(before, ____r62)
  local __after = destash33(after, ____r62)
  local ____id1 = ____r62
  local __more = cut(____id1, 0)
  local ____id2 = split(__s1, __before)
  local __a = ____id2[1]
  local __bs = cut(____id2, 1)
  local ____x10 = __bs
  local ____i12 = 0
  while ____i12 < _35(____x10) do
    local __x11 = ____x10[____i12 + 1]
    __a = __a .. (__after or "") .. __x11
    ____i12 = ____i12 + 1
  end
  if some63(__more) then
    return apply(str_replace, join({__a}, __more))
  else
    return __a
  end
end
function _G.str_starts63(str, s)
  return clip(str, 0, _35(s)) == s
end
function _G.str_ends63(str, s)
  return clip(str, _35(str) - _35(s)) == s
end
function _G.pair(l)
  local __l12 = {}
  local __i13 = 0
  while __i13 < _35(l) do
    add(__l12, {l[__i13 + 1], l[__i13 + 1 + 1]})
    __i13 = __i13 + 1
    __i13 = __i13 + 1
  end
  return __l12
end
function _G.sort(l, f)
  table.sort(l, f)
  return l
end
function _G.map(f, x)
  local __t1 = {}
  local ____x14 = x
  local ____i14 = 0
  while ____i14 < _35(____x14) do
    local __v8 = ____x14[____i14 + 1]
    local __y3 = f(__v8)
    if is63(__y3) then
      add(__t1, __y3)
    end
    ____i14 = ____i14 + 1
  end
  local ____o8 = x
  local __k5 = nil
  for __k5 in pairs(____o8) do
    local __v9 = ____o8[__k5]
    if not number63(__k5) then
      local __y4 = f(__v9)
      if is63(__y4) then
        __t1[__k5] = __y4
      end
    end
  end
  return __t1
end
function _G.keep(v, x)
  local __f3 = testify(v)
  return map(function(v)
  if yes(__f3(v)) then
    return v
  end
end, x)
end
function _G.keys63(t)
  local ____o9 = t
  local __k6 = nil
  for __k6 in pairs(____o9) do
    local __v10 = ____o9[__k6]
    if not number63(__k6) then
      return true
    end
  end
  return false
end
function _G.empty63(t)
  local ____o10 = t
  local ____i17 = nil
  for ____i17 in pairs(____o10) do
    local __x15 = ____o10[____i17]
    return false
  end
  return true
end
function _G.stash(args)
  if keys63(args) then
    local __p = {}
    local ____o11 = args
    local __k7 = nil
    for __k7 in pairs(____o11) do
      local __v11 = ____o11[__k7]
      if not number63(__k7) then
        __p[__k7] = __v11
      end
    end
    __p._stash = true
    add(args, __p)
  end
  return args
end
function _G.unstash(args)
  if none63(args) then
    return {}
  else
    local __l2 = last(args)
    if obj63(__l2) and __l2._stash then
      local __args1 = almost(args)
      local ____o12 = __l2
      local __k8 = nil
      for __k8 in pairs(____o12) do
        local __v12 = ____o12[__k8]
        if not( __k8 == "_stash") then
          __args1[__k8] = __v12
        end
      end
      return __args1
    else
      return args
    end
  end
end
function _G.destash33(l, args1)
  if obj63(l) and l._stash then
    local ____o13 = l
    local __k9 = nil
    for __k9 in pairs(____o13) do
      local __v13 = ____o13[__k9]
      if not( __k9 == "_stash") then
        args1[__k9] = __v13
      end
    end
  else
    return l
  end
end
function _G.search(s, pattern, start)
  local __e14 = nil
  if start then
    __e14 = start + 1
  end
  local __start = __e14
  local __i21 = string.find(s, pattern, __start, true)
  return __i21 and __i21 - 1
end
function _G.split(s, sep)
  if s == "" or sep == "" then
    return {}
  else
    local __l3 = {}
    local __n15 = _35(sep)
    while true do
      local __i22 = search(s, sep)
      if nil63(__i22) then
        break
      else
        add(__l3, clip(s, 0, __i22))
        s = clip(s, __i22 + __n15)
      end
    end
    add(__l3, s)
    return __l3
  end
end
function _G.concat(sep, s, ...)
  return reduce(function(a, b)
  return a .. sep .. b
end, {...}, s or "")
end
function _G.cat(s, ...)
  return reduce(function(a, b)
  return a .. b
end, {...}, s or "")
end
function _G._43(n, ...)
  return reduce(function(a, b)
  return a + b
end, {...}, n or 0)
end
function _G._45(n, ...)
  return reduce(function(a, b)
  return a - b
end, {...}, n or 0)
end
function _G._42(n, ...)
  return reduce(function(a, b)
  return a * b
end, {...}, either(n, 1))
end
function _G._47(n, ...)
  return reduce(function(a, b)
  return a / b
end, {...}, either(n, 1))
end
function _G._37(n, ...)
  return reduce(function(a, b)
  return a % b
end, {...}, either(n, 1))
end
local function pairwise(f, xs)
  local __i23 = 0
  while __i23 < edge(xs) do
    local __a1 = xs[__i23 + 1]
    local __b = xs[__i23 + 1 + 1]
    if not f(__a1, __b) then
      return false
    end
    __i23 = __i23 + 1
  end
  return true
end
function _G._60(...)
  local __xs = unstash({...})
  return pairwise(function(a, b)
  return a < b
end, __xs)
end
function _G._62(...)
  local __xs1 = unstash({...})
  return pairwise(function(a, b)
  return a > b
end, __xs1)
end
function _G._61(...)
  local __xs2 = unstash({...})
  return pairwise(function(a, b)
  return a == b
end, __xs2)
end
function _G._6061(...)
  local __xs3 = unstash({...})
  return pairwise(function(a, b)
  return a <= b
end, __xs3)
end
function _G._6261(...)
  local __xs4 = unstash({...})
  return pairwise(function(a, b)
  return a >= b
end, __xs4)
end
function _G.number(s)
  return tonumber(s)
end
function _G.number_code63(n)
  return n > 47 and n < 58
end
function _G.numeric63(s)
  local __n16 = _35(s)
  local __i24 = 0
  while __i24 < __n16 do
    if not number_code63(code(s, __i24)) then
      return false
    end
    __i24 = __i24 + 1
  end
  return some63(s)
end
function _G.lowercase_code63(n)
  return n >= 97 and n <= 122
end
function _G.uppercase_code63(n)
  return n >= 65 and n <= 90
end
function _G.camel_case(str)
  local __s2 = ""
  local __n17 = _35(str)
  local __i25 = 0
  while __i25 < __n17 do
    local __c = code(str, __i25)
    if __c == 45 and (lowercase_code63(code(str, __i25 - 1) or 0) or uppercase_code63(code(str, __i25 - 1) or 0)) and lowercase_code63(code(str, __i25 + 1) or 0) then
      __i25 = __i25 + 1
      __c = code(str, __i25) - 32
    end
    __s2 = __s2 .. from_code(__c)
    __i25 = __i25 + 1
  end
  return __s2
end
function _G.escape(s)
  local __s11 = "\""
  local __i26 = 0
  while __i26 < _35(s) do
    local __c1 = char(s, __i26)
    local __e15 = nil
    if __c1 == "\n" then
      __e15 = "\\n"
    else
      local __e16 = nil
      if __c1 == "\r" then
        __e16 = "\\r"
      else
        local __e17 = nil
        if __c1 == "\"" then
          __e17 = "\\\""
        else
          local __e18 = nil
          if __c1 == "\\" then
            __e18 = "\\\\"
          else
            __e18 = __c1
          end
          __e17 = __e18
        end
        __e16 = __e17
      end
      __e15 = __e16
    end
    local __c11 = __e15
    __s11 = __s11 .. __c11
    __i26 = __i26 + 1
  end
  return __s11 .. "\""
end
function _G.str(x, stack)
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
            local __s3 = "("
            local __sp = ""
            local __xs5 = {}
            local __ks = {}
            local __l4 = stack or {}
            add(__l4, x)
            local ____o14 = x
            local __k10 = nil
            for __k10 in pairs(____o14) do
              local __v14 = ____o14[__k10]
              if number63(__k10) then
                __xs5[__k10] = str(__v14, __l4)
              else
                if not string63(__k10) then
                  __k10 = str(__k10, __l4)
                end
                add(__ks, __k10 .. ":")
                add(__ks, str(__v14, __l4))
              end
            end
            drop(__l4)
            local ____o15 = join(__xs5, __ks)
            local ____i28 = nil
            for ____i28 in pairs(____o15) do
              local __v15 = ____o15[____i28]
              __s3 = __s3 .. __sp .. __v15
              __sp = " "
            end
            return __s3 .. ")"
          end
        end
      end
    end
  end
end
function _G.apply(f, args)
  return f((unpack or table.unpack)(stash(args)))
end
function _G.call(f, ...)
  return f(...)
end
function _G.setenv(k, ...)
  local ____r107 = unstash({...})
  local __k11 = destash33(k, ____r107)
  local ____id3 = ____r107
  local __keys = cut(____id3, 0)
  if string63(__k11) then
    local __e19 = nil
    if __keys.toplevel then
      __e19 = hd(_G.environment)
    else
      __e19 = last(_G.environment)
    end
    local __frame = __e19
    local __entry = __frame[__k11] or {}
    local ____o16 = __keys
    local __k12 = nil
    for __k12 in pairs(____o16) do
      local __v16 = ____o16[__k12]
      __entry[__k12] = __v16
    end
    __frame[__k11] = __entry
    return __frame[__k11]
  end
end
local math = math
_G.abs = math.abs
_G.acos = math.acos
_G.asin = math.asin
_G.atan = math.atan
_G.atan2 = math.atan2
_G.ceil = math.ceil
_G.cos = math.cos
_G.floor = math.floor
_G.log = math.log
_G.log10 = math.log10
_G.max = math.max
_G.min = math.min
_G.pow = math.pow
_G.random = math.random
_G.sin = math.sin
_G.sinh = math.sinh
_G.sqrt = math.sqrt
_G.tan = math.tan
_G.tanh = math.tanh
_G.trunc = math.floor
setenv("do", {_stash = true, macro = function(...)
  local __body = unstash({...})
  return join({"%do"}, __body)
end})
setenv("break", {_stash = true, macro = function(...)
  local __body1 = unstash({...})
  return join({"%break"}, __body1)
end})
setenv("return", {_stash = true, macro = function(...)
  local __body2 = unstash({...})
  return join({"%return"}, __body2)
end})
setenv("continue", {_stash = true, macro = function(...)
  local __body3 = unstash({...})
  return join({"%continue"}, __body3)
end})
setenv("quote", {_stash = true, macro = function(form)
  return quoted(form)
end})
setenv("quasiquote", {_stash = true, macro = function(form)
  return quasiexpand(form, 1)
end})
setenv("while", {_stash = true, macro = function(test, ...)
  local ____r2 = unstash({...})
  local __test = destash33(test, ____r2)
  local ____id = ____r2
  local __body4 = cut(____id, 0)
  return join({"%while", __test, join({"%do"}, __body4)}, props(__body4))
end})
function _G.get_place(place, setfn)
  local __place = macroexpand(place)
  if atom63(__place) or hd(__place) == "get" and nil63(getenv("get", "place-expander")) or accessor_literal63(hd(tl(__place))) then
    return setfn(__place, function(v)
  return {"%set", __place, v}
end)
  else
    local __head = hd(__place)
    local __gf = getenv(__head, "place-expander")
    if __gf then
      return apply(__gf, join({setfn}, tl(__place)))
    else
      return error(str(__place) .. " is not a valid place expression")
    end
  end
end
setenv("let-place", {_stash = true, macro = function(vars, place, ...)
  local ____r5 = unstash({...})
  local __vars = destash33(vars, ____r5)
  local __place1 = destash33(place, ____r5)
  local ____id1 = ____r5
  local __body5 = cut(____id1, 0)
  return {"get-place", __place1, join({"fn", __vars}, __body5)}
end})
setenv("define-expander", {_stash = true, macro = function(name, handler)
  local ____x16 = {"setenv", {"quote", name}}
  ____x16["place-expander"] = handler
  local __form = ____x16
  eval(__form)
  return __form
end})
function _G.define_setter(name, setter, setfn, args, vars)
  if none63(args) then
    local __vars1 = reverse(vars or {})
    return setfn(join({name}, __vars1), function(v)
  return apply(setter, join({v}, __vars1))
end)
  else
    local __v = hd(args)
    return define_setter(name, setter, setfn, tl(args), join({__v}, vars))
  end
end
setenv("define-setter", {_stash = true, macro = function(name, arglist, ...)
  local ____r9 = unstash({...})
  local __name = destash33(name, ____r9)
  local __arglist = destash33(arglist, ____r9)
  local ____id2 = ____r9
  local __body6 = cut(____id2, 0)
  local ____x24 = {"setfn"}
  ____x24.rest = "args"
  return {"define-expander", __name, {"fn", ____x24, {"%call", "define-setter", {"quote", __name}, join({"fn", __arglist}, __body6), "setfn", "args"}}}
end})
setenv("set", {_stash = true, macro = function(...)
  local __args = unstash({...})
  return join({"%do"}, map(function(__x30)
  local ____id3 = __x30
  local __lh = ____id3[1]
  local __rh = ____id3[2]
  return get_place(__lh, function(getter, setter)
  return setter(__rh)
end)
end, pair(__args)))
end})
setenv("at", {_stash = true, macro = function(l, i)
  if _G.target == "lua" and number63(i) then
    i = i + 1
  else
    if _G.target == "lua" then
      i = {"+", i, 1}
    end
  end
  return {"get", l, i}
end})
setenv("wipe", {_stash = true, macro = function(place)
  if _G.target == "lua" then
    return {"set", place, "nil"}
  else
    return {"%delete", place}
  end
end})
setenv("list", {_stash = true, macro = function(...)
  local __body7 = unstash({...})
  local __x36 = unique("x")
  local __l = {}
  local __forms = {}
  local ____o = __body7
  local __k = nil
  for __k in pairs(____o) do
    local __v1 = ____o[__k]
    if number63(__k) then
      __l[__k] = __v1
    else
      add(__forms, {"set", {"get", __x36, {"quote", __k}}, __v1})
    end
  end
  if some63(__forms) then
    return join({"let", __x36, join({"%array"}, __l)}, __forms, {__x36})
  else
    return join({"%array"}, __l)
  end
end})
setenv("if", {_stash = true, macro = function(...)
  local __branches = unstash({...})
  return hd(expand_if(__branches))
end})
setenv("in", {_stash = true, macro = function(x, ...)
  local ____r14 = unstash({...})
  local __x46 = destash33(x, ____r14)
  local ____id4 = ____r14
  local __e = nil
  if ____id4.test == nil then
    __e = "="
  else
    __e = ____id4.test
  end
  local __test1 = __e
  local __choices = cut(____id4, 0)
  return join({"or"}, map(function(c)
  return {__test1, __x46, c}
end, __choices))
end})
setenv("case", {_stash = true, macro = function(expr, ...)
  local ____r16 = unstash({...})
  local __expr = destash33(expr, ____r16)
  local ____id5 = ____r16
  local __clauses = cut(____id5, 0)
  local __x50 = unique("x")
  local __eq = function(_)
    return {"=", {"quote", _}, __x50}
  end
  local __cl = function(__x53)
    local ____id6 = __x53
    local __a = ____id6[1]
    local __b = ____id6[2]
    if nil63(__b) then
      return {__a}
    else
      if string63(__a) or number63(__a) then
        return {__eq(__a), __b}
      else
        if one63(__a) then
          return {__eq(hd(__a)), __b}
        else
          if _35(__a) > 1 then
            return {join({"or"}, map(__eq, __a)), __b}
          end
        end
      end
    end
  end
  return {"let", __x50, __expr, join({"if"}, apply(join, map(__cl, pair(__clauses))))}
end})
setenv("when", {_stash = true, macro = function(cond, ...)
  local ____r19 = unstash({...})
  local __cond = destash33(cond, ____r19)
  local ____id7 = ____r19
  local __body8 = cut(____id7, 0)
  return {"if", __cond, join({"%do"}, __body8)}
end})
setenv("unless", {_stash = true, macro = function(cond, ...)
  local ____r20 = unstash({...})
  local __cond1 = destash33(cond, ____r20)
  local ____id8 = ____r20
  local __body9 = cut(____id8, 0)
  return {"if", {"not", __cond1}, join({"%do"}, __body9)}
end})
setenv("obj", {_stash = true, macro = function(...)
  local __body10 = unstash({...})
  return join({"%object"}, mapo(function(x)
  return x
end, __body10))
end})
setenv("let", {_stash = true, macro = function(bs, ...)
  local ____r22 = unstash({...})
  local __bs = destash33(bs, ____r22)
  local ____id9 = ____r22
  local __body11 = cut(____id9, 0)
  if atom63(__bs) then
    return join({"let", {__bs, hd(__body11)}}, tl(__body11))
  else
    if none63(__bs) then
      return join({"%do"}, __body11)
    else
      if hd63(__bs, "%brackets") then
        return join({"let", tl(__bs)}, __body11)
      else
        local ____id10 = __bs
        local __lh1 = ____id10[1]
        local __rh1 = ____id10[2]
        local __bs2 = cut(____id10, 2)
        local ____id11 = bind(__lh1, __rh1)
        local __id12 = ____id11[1]
        local __val = ____id11[2]
        local __bs1 = cut(____id11, 2)
        local __id111 = unique(__id12)
        return {"%do", {"%local", __id111, __val}, {"let-symbol", {__id12, __id111}, join({"let", join(__bs1, __bs2)}, __body11)}}
      end
    end
  end
end})
setenv("with", {_stash = true, macro = function(x, v, ...)
  local ____r23 = unstash({...})
  local __x81 = destash33(x, ____r23)
  local __v2 = destash33(v, ____r23)
  local ____id13 = ____r23
  local __body12 = cut(____id13, 0)
  return join({"let", {__x81, __v2}}, __body12, {__x81})
end})
setenv("let-when", {_stash = true, macro = function(x, v, ...)
  local ____r24 = unstash({...})
  local __x86 = destash33(x, ____r24)
  local __v3 = destash33(v, ____r24)
  local ____id14 = ____r24
  local __body13 = cut(____id14, 0)
  local __y = unique("y")
  return {"let", __y, __v3, {"when", {"yes", __y}, join({"let", {__x86, __y}}, __body13)}}
end})
setenv("define-transformer", {_stash = true, macro = function(name, form, ...)
  local ____r25 = unstash({...})
  local __name1 = destash33(name, ____r25)
  local __form1 = destash33(form, ____r25)
  local ____id15 = ____r25
  local __body14 = cut(____id15, 0)
  local ____x93 = {"setenv", {"quote", __name1}}
  ____x93.transformer = join({"fn", {__form1}}, __body14)
  return join(____x93, props(__body14))
end})
setenv("define-macro", {_stash = true, macro = function(name, args, ...)
  local ____r26 = unstash({...})
  local __name2 = destash33(name, ____r26)
  local __args1 = destash33(args, ____r26)
  local ____id16 = ____r26
  local __body15 = cut(____id16, 0)
  local ____x98 = {"setenv", {"quote", __name2}}
  ____x98.macro = join({"fn", __args1}, __body15)
  return join(____x98, props(__body15))
end})
setenv("define-special", {_stash = true, macro = function(name, args, ...)
  local ____r27 = unstash({...})
  local __name3 = destash33(name, ____r27)
  local __args2 = destash33(args, ____r27)
  local ____id17 = ____r27
  local __body16 = cut(____id17, 0)
  local ____x102 = {"setenv", {"quote", __name3}}
  ____x102.special = join({"fn", __args2}, __body16)
  return join(____x102, props(__body16))
end})
setenv("define-symbol", {_stash = true, macro = function(name, expansion)
  local ____x105 = {"setenv", {"quote", name}}
  ____x105.symbol = {"quote", expansion}
  return ____x105
end})
setenv("define-reader", {_stash = true, macro = function(__x108, ...)
  local ____id18 = __x108
  local __char = ____id18[1]
  local __s = ____id18[2]
  local ____r29 = unstash({...})
  local ____x108 = destash33(__x108, ____r29)
  local ____id19 = ____r29
  local __body17 = cut(____id19, 0)
  return {"set", {"get", "read-table", __char}, join({"fn", {__s}}, __body17)}
end})
setenv("define", {_stash = true, macro = function(name, x, ...)
  local ____r30 = unstash({...})
  local __name4 = destash33(name, ____r30)
  local __x115 = destash33(x, ____r30)
  local ____id20 = ____r30
  local __body18 = cut(____id20, 0)
  if some63(__body18) then
    return join({"%local-function", __name4}, bind_function(__x115, __body18), props(__body18))
  else
    return {"%local", __name4, __x115}
  end
end})
setenv("define-global", {_stash = true, macro = function(name, x, ...)
  local ____r31 = unstash({...})
  local __name5 = destash33(name, ____r31)
  local __x119 = destash33(x, ____r31)
  local ____id21 = ____r31
  local __body19 = cut(____id21, 0)
  if some63(__body19) then
    return join({"%global-function", __name5}, bind_function(__x119, __body19), props(__body19))
  else
    if global_id63(__name5) then
      return {"set", __name5, __x119}
    else
      return {"set", {"get", "_G", {"quote", compile(__name5)}}, __x119}
    end
  end
end})
setenv("with-frame", {_stash = true, macro = function(...)
  local __body20 = unstash({...})
  local __x126 = unique("x")
  return {"%do", {"add", "environment*", {"obj"}}, {"with", __x126, join({"%do"}, __body20), {"drop", "environment*"}}}
end})
setenv("with-bindings", {_stash = true, macro = function(__x133, ...)
  local ____id22 = __x133
  local __names = ____id22[1]
  local ____r32 = unstash({...})
  local ____x133 = destash33(__x133, ____r32)
  local ____id23 = ____r32
  local __body21 = cut(____id23, 0)
  local __x135 = unique("x")
  local ____x138 = {"setenv", __x135}
  ____x138.variable = true
  return join({"with-frame", {"each", __x135, __names, ____x138}}, __body21)
end})
setenv("let-macro", {_stash = true, macro = function(definitions, ...)
  local ____r33 = unstash({...})
  local __definitions = destash33(definitions, ____r33)
  local ____id24 = ____r33
  local __body22 = cut(____id24, 0)
  add(_G.environment, {})
  local ____x141 = __definitions
  local ____i1 = 0
  while ____i1 < _35(____x141) do
    local __m = ____x141[____i1 + 1]
    eval(join({"define-macro"}, __m))
    ____i1 = ____i1 + 1
  end
  local ____x140 = join({"%do"}, macroexpand(__body22))
  drop(_G.environment)
  return ____x140
end})
setenv("let-symbol", {_stash = true, macro = function(expansions, ...)
  local ____r34 = unstash({...})
  local __expansions = destash33(expansions, ____r34)
  local ____id25 = ____r34
  local __body23 = cut(____id25, 0)
  add(_G.environment, {})
  local ____x146 = pair(__expansions)
  local ____i2 = 0
  while ____i2 < _35(____x146) do
    local ____id26 = ____x146[____i2 + 1]
    local __name6 = ____id26[1]
    local __exp = ____id26[2]
    eval({"define-symbol", __name6, __exp})
    ____i2 = ____i2 + 1
  end
  local ____x145 = join({"%do"}, macroexpand(__body23))
  drop(_G.environment)
  return ____x145
end})
setenv("let-unique", {_stash = true, macro = function(names, ...)
  local ____r35 = unstash({...})
  local __names1 = destash33(names, ____r35)
  local ____id27 = ____r35
  local __body24 = cut(____id27, 0)
  local __bs11 = map(function(n)
  return {n, {"unique", {"quote", n}}}
end, __names1)
  return join({"let", apply(join, __bs11)}, __body24)
end})
setenv("fn", {_stash = true, macro = function(args, ...)
  local ____r37 = unstash({...})
  local __args3 = destash33(args, ____r37)
  local ____id28 = ____r37
  local __body25 = cut(____id28, 0)
  return join({"%function"}, bind_function(__args3, __body25), props(__body25))
end})
setenv("apply", {_stash = true, macro = function(f, ...)
  local ____r38 = unstash({...})
  local __f = destash33(f, ____r38)
  local ____id29 = ____r38
  local __args4 = cut(____id29, 0)
  if _35(__args4) > 1 then
    return {"%call", "apply", __f, {"join", join({"list"}, almost(__args4)), last(__args4)}}
  else
    return join({"%call", "apply", __f}, __args4)
  end
end})
setenv("guard", {_stash = true, macro = function(expr)
  if _G.target == "js" then
    return {{"fn", join(), {"%try", {"list", true, expr}}}}
  else
    local ____x172 = {"obj"}
    ____x172.stack = {{"get", "debug", {"quote", "traceback"}}}
    ____x172.message = {"if", {"string?", "m"}, {"clip", "m", {"+", {"or", {"search", "m", "\": \""}, -2}, 2}}, {"nil?", "m"}, "\"\"", {"str", "m"}}
    return {"list", {"xpcall", {"fn", join(), expr}, {"fn", {"m"}, {"if", {"obj?", "m"}, "m", ____x172}}}}
  end
end})
setenv("each", {_stash = true, macro = function(x, t, ...)
  local ____r40 = unstash({...})
  local __x185 = destash33(x, ____r40)
  local __t = destash33(t, ____r40)
  local ____id30 = ____r40
  local __body26 = cut(____id30, 0)
  local __o1 = unique("o")
  local __n1 = unique("n")
  local __i3 = unique("i")
  local __e1 = nil
  if atom63(__x185) then
    __e1 = {__i3, __x185}
  else
    local __e2 = nil
    if _35(__x185) > 1 then
      __e2 = __x185
    else
      __e2 = {__i3, hd(__x185)}
    end
    __e1 = __e2
  end
  local ____id31 = __e1
  local __k1 = ____id31[1]
  local __v4 = ____id31[2]
  return {"let", {__o1, __t}, {"for", {__k1}, {"pairs", __o1}, join({"let", {__v4, {"get", __o1, __k1}}}, __body26)}}
end})
setenv("for", {_stash = true, macro = function(i, to, ...)
  local ____r41 = unstash({...})
  local __i4 = destash33(i, ____r41)
  local __to = destash33(to, ____r41)
  local ____id32 = ____r41
  local __body27 = cut(____id32, 0)
  if obj63(__i4) then
    return {"let", apply(join, map(function(x)
  return {x, "nil"}
end, __i4)), join({"%for", __to, join({"%names"}, __i4), join({"%do"}, __body27)}, props(__body27))}
  else
    return {"let", __i4, 0, join({"while", {"<", __i4, __to}}, __body27, {{"inc", __i4}})}
  end
end})
setenv("step", {_stash = true, macro = function(v, t, ...)
  local ____r43 = unstash({...})
  local __v5 = destash33(v, ____r43)
  local __t1 = destash33(t, ____r43)
  local ____id33 = ____r43
  local __body28 = cut(____id33, 0)
  local __x208 = unique("x")
  local __i5 = unique("i")
  return {"let", {__x208, __t1}, {"for", __i5, {"#", __x208}, join({"let", {__v5, {"at", __x208, __i5}}}, __body28)}}
end})
setenv("set-of", {_stash = true, macro = function(...)
  local __xs = unstash({...})
  local __l1 = {}
  local ____o2 = __xs
  local ____i6 = nil
  for ____i6 in pairs(____o2) do
    local __x217 = ____o2[____i6]
    __l1[__x217] = true
  end
  return join({"obj"}, __l1)
end})
setenv("any-of", {_stash = true, macro = function(...)
  local __xs1 = unstash({...})
  return {"testify-of", join({"set-of"}, __xs1)}
end})
setenv("language", {_stash = true, macro = function()
  return {"quote", _G.target}
end})
setenv("target", {_stash = true, macro = function(...)
  local __clauses1 = unstash({...})
  return either(__clauses1[_G.target], join({"%do"}, __clauses1))
end})
setenv("join!", {_stash = true, macro = function(a, ...)
  local ____r45 = unstash({...})
  local __a1 = destash33(a, ____r45)
  local ____id34 = ____r45
  local __bs21 = cut(____id34, 0)
  return {"set", __a1, join({"join", __a1}, __bs21)}
end})
setenv("cat!", {_stash = true, macro = function(a, ...)
  local ____r46 = unstash({...})
  local __a2 = destash33(a, ____r46)
  local ____id35 = ____r46
  local __bs3 = cut(____id35, 0)
  return {"set", __a2, join({"cat", __a2}, __bs3)}
end})
setenv("inc", {_stash = true, macro = function(n, by)
  local __e3 = nil
  if nil63(by) then
    __e3 = 1
  else
    __e3 = by
  end
  return {"set", n, {"+", n, __e3}}
end})
setenv("dec", {_stash = true, macro = function(n, by)
  local __e4 = nil
  if nil63(by) then
    __e4 = 1
  else
    __e4 = by
  end
  return {"set", n, {"-", n, __e4}}
end})
setenv("with-value", {_stash = true, macro = function(name, value, ...)
  local ____r49 = unstash({...})
  local __name7 = destash33(name, ____r49)
  local __value = destash33(value, ____r49)
  local ____id36 = ____r49
  local __body29 = cut(____id36, 0)
  local __x236 = unique("x")
  local __r50 = unique("r")
  return {"let", {__x236, __name7}, {"set", __name7, __value}, {"with", __r50, join({"do"}, __body29), {"set", __name7, __x236}}}
end})
setenv("with-indent", {_stash = true, macro = function(form)
  local __x243 = unique("x")
  return {"%do", {"inc", "indent-level*"}, {"with", __x243, form, {"dec", "indent-level*"}}}
end})
setenv("undefined?", {_stash = true, macro = function(x)
  local ____x248 = {"target"}
  ____x248.lua = {"=", x, "nil"}
  ____x248.js = {"=", {"typeof", x}, "\"undefined\""}
  return ____x248
end})
setenv("export", {_stash = true, macro = function(...)
  local __names2 = unstash({...})
  local ____x260 = {"target"}
  ____x260.lua = {"return", "exports"}
  return join({"with", "exports", {"if", {"undefined?", "exports"}, {"obj"}, "exports"}}, map(function(k)
  return {"set", {"exports", "." .. k}, k}
end, __names2), {____x260})
end})
setenv("when-compiling", {_stash = true, macro = function(...)
  local __body30 = unstash({...})
  return eval(join({"%do"}, __body30))
end})
setenv("during-compilation", {_stash = true, macro = function(...)
  local __body31 = unstash({...})
  local __form2 = join({"%do"}, __body31, {{"%do"}})
  eval(__form2)
  return __form2
end})
setenv("%tilde", {_stash = true, macro = function(...)
  local __args5 = unstash({...})
  return join({"complement"}, __args5)
end})
setenv("%code", {_stash = true, macro = function(c)
  return {"when-compiling", {"code", c}}
end})
setenv("complement", {_stash = true, macro = function(f)
  return {"fn", {"..."}, {"not", {f, "..."}}}
end})
setenv("compose", {_stash = true, transformer = function(__x276)
  local ____id37 = __x276
  local ____id38 = ____id37[1]
  local __compose = ____id38[1]
  local __fns = cut(____id38, 1)
  local __body32 = cut(____id37, 1)
  if none63(__fns) then
    return macroexpand(join({"do"}, __body32))
  else
    if one63(__fns) then
      return macroexpand(join(__fns, __body32))
    else
      return macroexpand({join({__compose}, almost(__fns)), join({last(__fns)}, __body32)})
    end
  end
end})
setenv("complement", {_stash = true, transformer = function(__x281)
  local ____id39 = __x281
  local ____id40 = ____id39[1]
  local __complement = ____id40[1]
  local __form3 = ____id40[2]
  local __body33 = cut(____id39, 1)
  if hd63(__form3, "complement") then
    return macroexpand(join({__form3[2]}, __body33))
  else
    return macroexpand({"no", join({__form3}, __body33)})
  end
end})
setenv("expansion", {_stash = true, transformer = function(__x285)
  local ____id41 = __x285
  local ____id42 = ____id41[1]
  local __expansion = ____id42[1]
  local __form4 = ____id41[2]
  return __form4
end})
setenv("hd", {_stash = true, ["place-expander"] = function(setfn, ...)
  local ____r61 = unstash({...})
  local __setfn1 = destash33(setfn, ____r61)
  local ____id44 = ____r61
  local __args7 = cut(____id44, 0)
  return define_setter("hd", function(v, l)
  return {"set", {"at", l, 0}, v}
end, __setfn1, __args7)
end})
local reader = require("./reader")
local compiler = require("./compiler")
local system = require("./system")
local function eval_print(form)
  local ____id = {xpcall(function()
  return compiler.eval({"results", form})
end, function(m)
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
    local ____x2 = __v
    local ____i = 0
    while ____i < _35(____x2) do
      local __x3 = ____x2[____i + 1]
      if is63(__x3) or _35(__v) > 1 then
        print(str(__x3))
      end
      ____i = ____i + 1
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
  if process then
    process.stdin:removeAllListeners()
    return process.stdin:on("data", rep1)
  else
    while true do
      local __s = io.read()
      if __s then
        rep1(__s .. "\n")
      else
        break
      end
    end
  end
end
function _G.read_file(path)
  return system.readFile(path)
end
function _G.write_file(path, data)
  return system.writeFile(path, data)
end
function _G.read_from_file(path)
  local __s1 = reader.stream(system.readFile(path))
  local __body = reader.readAll(__s1)
  return join({"do"}, __body)
end
function _G.expand_file(path)
  return compiler.expand(read_from_file(path))
end
function _G.compile_file(path)
  local __form1 = expand_file(path)
  return compiler.compile(__form1, {_stash = true, stmt = true})
end
function _G._load(path)
  local __previous = _G.target
  _G.target = "lua"
  local __code = compile_file(path)
  _G.target = __previous
  return compiler.run(__code)
end
function _G.script_file63(path)
  return string63(path) and not( "-" == char(path, 0) or ".js" == clip(path, _35(path) - 3) or ".lua" == clip(path, _35(path) - 4))
end
function _G.run_file(path)
  if script_file63(path) then
    return _load(path)
  else
    return compiler.run(read_file(path))
  end
end
function _G.run_script(file, argv)
  set_argv(argv)
  local ____id1 = run_file(file)
  local __main = ____id1.main
  if nil63(__main) then
    return error("main not exported for script file " .. str(file))
  else
    return __main(argv)
  end
end
function _G.read_from_string(str, start, _end)
  local __s2 = reader.stream(str)
  __s2.pos = either(start, __s2.pos)
  __s2.len = either(_end, __s2.len)
  local __form2 = reader.read(__s2)
  if nil63(__form2) then
    return error("End of string during parsing")
  else
    local ____x5 = {__form2}
    ____x5.rest = __s2.pos
    return ____x5
  end
end
function _G.readable_string63(str)
  local __id5 = string63(str)
  local __e4 = nil
  if __id5 then
    local ____id2 = {xpcall(function()
  return read_from_string(str)
end, function(m)
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
    local __ok1 = ____id2[1]
    local __v1 = ____id2[2]
    __e4 = __ok1 and hd(__v1) == str
  else
    __e4 = __id5
  end
  return __e4
end
function _G.pp_to_string(x, stack)
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
                      local ____i2 = nil
                      for ____i2 in pairs(____o1) do
                        local __v3 = ____o1[____i2]
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
  if script_file63(hd(argv)) then
    return run_script(hd(argv), tl(argv))
  else
    local __args = parse_arguments({c = "compile", o = "output", t = "target", e = "eval", h = "help", r = "repl"}, argv)
    if script_file63(hd(__args)) then
      return run_script(hd(__args), tl(__args))
    else
      if __args.help then
        return print(usage())
      else
        local __pre = keep(string63, __args)
        local __cmds = keep(obj63, __args)
        local __input = ""
        local __enter_repl = true
        local ____x7 = __pre
        local ____i3 = 0
        while ____i3 < _35(____x7) do
          local __file = ____x7[____i3 + 1]
          run_file(__file)
          ____i3 = ____i3 + 1
        end
        local ____x8 = __cmds
        local ____i4 = 0
        while ____i4 < _35(____x8) do
          local ____id3 = ____x8[____i4 + 1]
          local __a = ____id3[1]
          local __val = ____id3[2]
          if __a == "target" then
            _G.target = hd(__val)
            break
          end
          ____i4 = ____i4 + 1
        end
        local ____x9 = __cmds
        local ____i5 = 0
        while ____i5 < _35(____x9) do
          local ____id4 = ____x9[____i5 + 1]
          local __a1 = ____id4[1]
          local __val1 = ____id4[2]
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
                  local ____x10 = __val1
                  local ____i6 = 0
                  while ____i6 < _35(____x10) do
                    local __x11 = ____x10[____i6 + 1]
                    __input = __input .. compile_file(__x11)
                    ____i6 = ____i6 + 1
                  end
                  __enter_repl = false
                else
                  if __a1 == "output" then
                    write_file(hd(__val1), __input)
                    __input = ""
                  else
                    if __a1 == "target" then
                      _G.target = hd(__val1)
                    else
                      if __a1 == "eval" then
                        local ____x12 = __val1
                        local ____i7 = 0
                        while ____i7 < _35(____x12) do
                          local __x13 = ____x12[____i7 + 1]
                          rep(__x13)
                          ____i7 = ____i7 + 1
                        end
                        __enter_repl = false
                      end
                    end
                  end
                end
              end
            end
          end
          ____i5 = ____i5 + 1
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
__exports.usage = usage
__exports.main = main
return __exports
