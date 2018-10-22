_G.environment = {{}}
_G.target = "lua"
local __v = nil
function _G.values(...)
  return ...
end
function _G.results(x, ...)
  return {x, ...}
end
_G.null = null or JSON.null or error("null not defined")
function _G.nil63(x)
  return x == nil or x == null
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
  if x == nil then
    return y
  else
    return x
  end
end
function _G.complement(f)
  return function (...)
    return no(f(...))
  end
end
function _G.has63(l, k)
  return not( nil == l[k])
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
  local __id49 = obj63(l)
  local __e6 = nil
  if __id49 then
    local __e7 = nil
    if function63(x) then
      __e7 = x(hd(l))
    else
      local __e8 = nil
      if nil == x then
        __e8 = hd(l)
      else
        __e8 = hd(l) == x
      end
      __e7 = __e8
    end
    __e6 = __e7
  else
    __e6 = __id49
  end
  return __e6
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
  local __l = {}
  local __j = 0
  local __e9 = nil
  if nil == from or from < 0 then
    __e9 = 0
  else
    __e9 = from
  end
  local __i2 = __e9
  local __n1 = _35(x)
  local __e10 = nil
  if nil == upto or upto > __n1 then
    __e10 = __n1
  else
    __e10 = upto
  end
  local __upto1 = __e10
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
function _G.vals(x)
  local __t1 = {}
  local ____o5 = x
  local __k3 = nil
  for __k3 in pairs(____o5) do
    local __v5 = ____o5[__k3]
    if number63(__k3) then
      __t1[__k3] = __v5
    end
  end
  return __t1
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
  local __e11 = nil
  if n then
    __e11 = n + 1
  end
  return string.byte(s, __e11)
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
  return l[edge(l) + 1]
end
function _G.almost(l)
  return cut(l, 0, edge(l))
end
function _G.reverse(l)
  local __l1 = props(l)
  local __i6 = edge(l)
  while __i6 >= 0 do
    add(__l1, l[__i6 + 1])
    __i6 = __i6 - 1
  end
  return __l1
end
function _G.join(...)
  local __ls = unstash({...})
  local __r46 = {}
  local ____x3 = __ls
  local ____i7 = 0
  while ____i7 < _35(____x3) do
    local __l11 = ____x3[____i7 + 1]
    if __l11 then
      local __n5 = _35(__r46)
      local ____o6 = __l11
      local __k4 = nil
      for __k4 in pairs(____o6) do
        local __v6 = ____o6[__k4]
        if number63(__k4) then
          __k4 = __k4 + __n5
        end
        __r46[__k4] = __v6
      end
    end
    ____i7 = ____i7 + 1
  end
  return __r46
end
function _G.testify(x, test)
  if function63(x) then
    return x
  else
    if test then
      return function (y)
        return test(y, x)
      end
    else
      return function (y)
        return x == y
      end
    end
  end
end
function _G.find(x, t)
  local __f = testify(x)
  local ____o7 = t
  local ____i9 = nil
  for ____i9 in pairs(____o7) do
    local __x4 = ____o7[____i9]
    local __y = __f(__x4)
    if __y then
      return __y
    end
  end
end
function _G.len(x)
  if string63(x) then
    return _35(x)
  else
    if obj63(x) then
      local __n8 = -1
      local ____o8 = x
      local __k5 = nil
      for __k5 in pairs(____o8) do
        local __v7 = ____o8[__k5]
        if number63(__k5) then
          __k5 = __k5 - 1
          __n8 = max(__n8, __k5)
        end
      end
      __n8 = __n8 + 1
      return __n8
    else
      return 0
    end
  end
end
function _G.first(x, l, pos, reverse63)
  local __f1 = testify(x)
  local __i11 = either(pos, 0)
  local __n10 = len(l)
  local __e12 = nil
  if string63(l) then
    __e12 = char
  end
  local __ref = __e12
  while __i11 < __n10 do
    local __e13 = nil
    if reverse63 then
      __e13 = __n10 - __i11 - 1
    else
      __e13 = __i11
    end
    local __i12 = __e13
    local __e14 = nil
    if __ref then
      __e14 = __ref(l, __i12)
    else
      __e14 = l[__i12 + 1]
    end
    local __v8 = __e14
    local ____y1 = __f1(__v8)
    if yes(____y1) then
      local __y2 = ____y1
      return __i12
    end
    __i11 = __i11 + 1
  end
end
local whitespace = {[" "] = true, ["\t"] = true, ["\r"] = true, ["\n"] = true}
function _G.whitespace63(c)
  return whitespace[c]
end
function _G.trim(s, where, test)
  local __where = where or "both"
  local __test1 = test or whitespace63
  local __f3 = complement(testify(__test1))
  local __e15 = nil
  if __where == "front" or __where == "both" then
    __e15 = first(__f3, s)
  else
    __e15 = 0
  end
  local __p1 = __e15
  local __e16 = nil
  if __where == "end" or __where == "both" then
    __e16 = first(__f3, s, nil, true) + 1
  end
  local __p2 = __e16
  if string63(s) then
    return clip(s, __p1, __p2)
  else
    return cut(s, __p1, __p2)
  end
end
function _G.in63(x, t)
  return find(testify(x), t)
end
function _G.pair(l)
  local __l12 = {}
  local __i20 = 0
  while __i20 < _35(l) do
    add(__l12, {l[__i20 + 1], l[__i20 + 1 + 1]})
    __i20 = __i20 + 1
    __i20 = __i20 + 1
  end
  return __l12
end
function _G.sort(l, f)
  table.sort(l, f)
  return l
end
function _G.map(f, x)
  local __t4 = {}
  local ____x284 = x
  local ____i21 = 0
  while ____i21 < _35(____x284) do
    local __v15 = ____x284[____i21 + 1]
    local __y4 = f(__v15)
    if not( __y4 == nil) then
      add(__t4, __y4)
    end
    ____i21 = ____i21 + 1
  end
  local ____o12 = x
  local __k8 = nil
  for __k8 in pairs(____o12) do
    local __v16 = ____o12[__k8]
    if not number63(__k8) then
      local __y5 = f(__v16)
      if not( __y5 == nil) then
        __t4[__k8] = __y5
      end
    end
  end
  return __t4
end
function _G.keep(v, x)
  local __f4 = testify(v)
  return map(function (v)
    if yes(__f4(v)) then
      return v
    end
  end, x)
end
function _G.keys63(t)
  local ____o13 = t
  local __k9 = nil
  for __k9 in pairs(____o13) do
    local __v17 = ____o13[__k9]
    if not number63(__k9) then
      return true
    end
  end
  return false
end
function _G.empty63(t)
  local ____o14 = t
  local ____i24 = nil
  for ____i24 in pairs(____o14) do
    local __x285 = ____o14[____i24]
    return false
  end
  return true
end
function _G.stash(args)
  if keys63(args) then
    local __p = {}
    local ____o15 = args
    local __k10 = nil
    for __k10 in pairs(____o15) do
      local __v18 = ____o15[__k10]
      if not number63(__k10) then
        __p[__k10] = __v18
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
    local __l4 = last(args)
    if obj63(__l4) and __l4._stash then
      local __args11 = almost(args)
      local ____o16 = __l4
      local __k11 = nil
      for __k11 in pairs(____o16) do
        local __v19 = ____o16[__k11]
        if not( __k11 == "_stash") then
          __args11[__k11] = __v19
        end
      end
      return __args11
    else
      return args
    end
  end
end
function _G.destash33(l, args1)
  if obj63(l) and l._stash then
    local ____o17 = l
    local __k12 = nil
    for __k12 in pairs(____o17) do
      local __v20 = ____o17[__k12]
      if not( __k12 == "_stash") then
        args1[__k12] = __v20
      end
    end
  else
    return l
  end
end
function _G.search(s, pattern, start)
  local __e17 = nil
  if start then
    __e17 = start + 1
  end
  local __start = __e17
  local __i28 = string.find(s, pattern, __start, true)
  return __i28 and __i28 - 1
end
function _G.split(s, sep)
  if s == "" or sep == "" then
    return {}
  else
    local __l5 = {}
    local __n20 = _35(sep)
    while true do
      local __i29 = search(s, sep)
      if nil == __i29 then
        break
      else
        add(__l5, clip(s, 0, __i29))
        s = clip(s, __i29 + __n20)
      end
    end
    add(__l5, s)
    return __l5
  end
end
function _G.cat(s, ...)
  return reduce(function (a, b)
    return a .. b
  end, {...}, s or "")
end
function _G._43(n, ...)
  return reduce(function (a, b)
    return a + b
  end, {...}, n or 0)
end
function _G._45(n, ...)
  return reduce(function (a, b)
    return a - b
  end, {...}, n or 0)
end
function _G._42(n, ...)
  return reduce(function (a, b)
    return a * b
  end, {...}, either(n, 1))
end
function _G._47(n, ...)
  return reduce(function (a, b)
    return a / b
  end, {...}, either(n, 1))
end
function _G._37(n, ...)
  return reduce(function (a, b)
    return a % b
  end, {...}, either(n, 1))
end
local function pairwise(f, xs)
  local __i30 = 0
  while __i30 < edge(xs) do
    local __a3 = xs[__i30 + 1]
    local __b1 = xs[__i30 + 1 + 1]
    if not f(__a3, __b1) then
      return false
    end
    __i30 = __i30 + 1
  end
  return true
end
function _G._60(...)
  local __xs1 = unstash({...})
  return pairwise(function (a, b)
    return a < b
  end, __xs1)
end
function _G._62(...)
  local __xs2 = unstash({...})
  return pairwise(function (a, b)
    return a > b
  end, __xs2)
end
function _G._61(...)
  local __xs3 = unstash({...})
  return pairwise(function (a, b)
    return a == b
  end, __xs3)
end
function _G._6061(...)
  local __xs4 = unstash({...})
  return pairwise(function (a, b)
    return a <= b
  end, __xs4)
end
function _G._6261(...)
  local __xs5 = unstash({...})
  return pairwise(function (a, b)
    return a >= b
  end, __xs5)
end
function _G.number(s)
  return tonumber(s)
end
function _G.number_code63(n)
  return n > 47 and n < 58
end
function _G.numeric63(s)
  local __n21 = _35(s)
  local __i31 = 0
  while __i31 < __n21 do
    if not number_code63(code(s, __i31)) then
      return false
    end
    __i31 = __i31 + 1
  end
  return some63(s)
end
function _G.lowercase_code63(n)
  return n > 96 and n < 123
end
function _G.camel_case(str)
  local __s1 = ""
  local __n22 = _35(str)
  local __i32 = 0
  while __i32 < __n22 do
    local __c = code(str, __i32)
    if __c == 45 and lowercase_code63(code(str, __i32 - 1) or 0) and lowercase_code63(code(str, __i32 + 1) or 0) then
      __i32 = __i32 + 1
      __c = code(str, __i32) - 32
    end
    __s1 = __s1 .. from_code(__c)
    __i32 = __i32 + 1
  end
  return __s1
end
function _G.escape(s)
  local __s11 = "\""
  local __i33 = 0
  while __i33 < _35(s) do
    local __c1 = char(s, __i33)
    local __e18 = nil
    if __c1 == "\n" then
      __e18 = "\\n"
    else
      local __e19 = nil
      if __c1 == "\r" then
        __e19 = "\\r"
      else
        local __e20 = nil
        if __c1 == "\"" then
          __e20 = "\\\""
        else
          local __e21 = nil
          if __c1 == "\\" then
            __e21 = "\\\\"
          else
            __e21 = __c1
          end
          __e20 = __e21
        end
        __e19 = __e20
      end
      __e18 = __e19
    end
    local __c11 = __e18
    __s11 = __s11 .. __c11
    __i33 = __i33 + 1
  end
  return __s11 .. "\""
end
function _G.str(x, stack)
  if string63(x) then
    return escape(x)
  else
    if x == null then
      return "null"
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
              local __s2 = "("
              local __sp = ""
              local __xs6 = {}
              local __ks = {}
              local __n23 = -1
              local __l6 = stack or {}
              add(__l6, x)
              local ____o18 = x
              local __k13 = nil
              for __k13 in pairs(____o18) do
                local __v21 = ____o18[__k13]
                if number63(__k13) then
                  __xs6[__k13] = str(__v21, __l6)
                  __n23 = max(__n23, __k13 - 1)
                else
                  if not string63(__k13) then
                    __k13 = str(__k13, __l6)
                  end
                  add(__ks, __k13 .. ":")
                  add(__ks, str(__v21, __l6))
                end
              end
              __n23 = __n23 + 1
              drop(__l6)
              local __i35 = 0
              while __i35 < __n23 do
                local __v22 = either(__xs6[__i35 + 1], "nil")
                __s2 = __s2 .. __sp .. __v22
                __sp = " "
                __i35 = __i35 + 1
              end
              local ____x297 = __ks
              local ____i36 = 0
              while ____i36 < _35(____x297) do
                local __v23 = ____x297[____i36 + 1]
                __s2 = __s2 .. __sp .. __v23
                __sp = " "
                ____i36 = ____i36 + 1
              end
              return __s2 .. ")"
            end
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
  local ____r158 = unstash({...})
  local __k14 = destash33(k, ____r158)
  local ____id48 = ____r158
  local __keys = cut(____id48, 0)
  if string63(__k14) then
    local __e22 = nil
    if __keys.toplevel then
      __e22 = hd(_G.environment)
    else
      __e22 = last(_G.environment)
    end
    local __frame = __e22
    local __entry = __frame[__k14] or {}
    local ____o19 = __keys
    local __k15 = nil
    for __k15 in pairs(____o19) do
      local __v24 = ____o19[__k15]
      __entry[__k15] = __v24
    end
    __frame[__k14] = __entry
    return __frame[__k14]
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
setenv("quote", {_stash = true, macro = function (form)
  return quoted(form)
end})
setenv("quasiquote", {_stash = true, macro = function (form)
  return quasiexpand(form, 1)
end})
setenv("do", {_stash = true, macro = function (...)
  local __body = unstash({...})
  return join({"%do"}, __body)
end})
setenv("while", {_stash = true, macro = function (test, ...)
  local ____r2 = unstash({...})
  local __test = destash33(test, ____r2)
  local ____id = ____r2
  local __body1 = cut(____id, 0)
  return join({"%while", __test, join({"%do"}, __body1)}, props(__body1))
end})
function _G.get_place(place, setfn)
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
  local ____r5 = unstash({...})
  local __vars = destash33(vars, ____r5)
  local __place1 = destash33(place, ____r5)
  local ____id1 = ____r5
  local __body2 = cut(____id1, 0)
  return {"get-place", __place1, join({"fn", __vars}, __body2)}
end})
setenv("define-expander", {_stash = true, macro = function (name, handler)
  local ____x10 = {"setenv", {"quote", name}}
  ____x10.expander = handler
  local __form = ____x10
  eval(__form)
  return __form
end})
function _G.define_setter(name, setter, setfn, args, vars)
  if none63(args) then
    local __vars1 = reverse(vars or {})
    return setfn(join({name}, __vars1), function (v)
      return apply(setter, join({v}, __vars1))
    end)
  else
    local __v = hd(args)
    return define_setter(name, setter, setfn, tl(args), join({__v}, vars))
  end
end
setenv("define-setter", {_stash = true, macro = function (name, arglist, ...)
  local ____r9 = unstash({...})
  local __name = destash33(name, ____r9)
  local __arglist = destash33(arglist, ____r9)
  local ____id2 = ____r9
  local __body3 = cut(____id2, 0)
  local ____x18 = {"setfn"}
  ____x18.rest = "args"
  return {"define-expander", __name, {"fn", ____x18, {"%call", "define-setter", {"quote", __name}, join({"fn", __arglist}, __body3), "setfn", "args"}}}
end})
setenv("set", {_stash = true, macro = function (...)
  local __args = unstash({...})
  return join({"%do"}, map(function (__x24)
    local ____id3 = __x24
    local __lh = ____id3[1]
    local __rh = ____id3[2]
    return get_place(__lh, function (getter, setter)
      return setter(__rh)
    end)
  end, pair(__args)))
end})
setenv("at", {_stash = true, macro = function (l, i)
  if _G.target == "lua" and number63(i) then
    i = i + 1
  else
    if _G.target == "lua" then
      i = {"+", i, 1}
    end
  end
  return {"get", l, i}
end})
setenv("wipe", {_stash = true, macro = function (place)
  if _G.target == "lua" then
    return {"set", place, "nil"}
  else
    return {"%delete", place}
  end
end})
setenv("list", {_stash = true, macro = function (...)
  local __body4 = unstash({...})
  local __x30 = unique("x")
  local __l = {}
  local __forms = {}
  local ____o = __body4
  local __k = nil
  for __k in pairs(____o) do
    local __v1 = ____o[__k]
    if number63(__k) then
      __l[__k] = __v1
    else
      add(__forms, {"set", {"get", __x30, {"quote", __k}}, __v1})
    end
  end
  if some63(__forms) then
    return join({"let", __x30, join({"%array"}, __l)}, __forms, {__x30})
  else
    return join({"%array"}, __l)
  end
end})
setenv("if", {_stash = true, macro = function (...)
  local __branches = unstash({...})
  return hd(expand_if(__branches))
end})
setenv("case", {_stash = true, macro = function (expr, ...)
  local ____r14 = unstash({...})
  local __expr = destash33(expr, ____r14)
  local ____id4 = ____r14
  local __clauses = cut(____id4, 0)
  local __x40 = unique("x")
  local __eq = function (_)
    return {"=", {"quote", _}, __x40}
  end
  local __cl = function (__x43)
    local ____id5 = __x43
    local __a = ____id5[1]
    local __b = ____id5[2]
    if nil == __b then
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
  return {"let", __x40, __expr, join({"if"}, apply(join, map(__cl, pair(__clauses))))}
end})
setenv("when", {_stash = true, macro = function (cond, ...)
  local ____r17 = unstash({...})
  local __cond = destash33(cond, ____r17)
  local ____id6 = ____r17
  local __body5 = cut(____id6, 0)
  return {"if", __cond, join({"%do"}, __body5)}
end})
setenv("unless", {_stash = true, macro = function (cond, ...)
  local ____r18 = unstash({...})
  local __cond1 = destash33(cond, ____r18)
  local ____id7 = ____r18
  local __body6 = cut(____id7, 0)
  return {"if", {"not", __cond1}, join({"%do"}, __body6)}
end})
setenv("obj", {_stash = true, macro = function (...)
  local __body7 = unstash({...})
  return join({"%object"}, mapo(function (x)
    return x
  end, __body7))
end})
setenv("let", {_stash = true, macro = function (bs, ...)
  local ____r20 = unstash({...})
  local __bs = destash33(bs, ____r20)
  local ____id8 = ____r20
  local __body8 = cut(____id8, 0)
  if atom63(__bs) then
    return join({"let", {__bs, hd(__body8)}}, tl(__body8))
  else
    if none63(__bs) then
      return join({"%do"}, __body8)
    else
      local ____id9 = __bs
      local __lh1 = ____id9[1]
      local __rh1 = ____id9[2]
      local __bs2 = cut(____id9, 2)
      local ____id10 = bind(__lh1, __rh1)
      local __id11 = ____id10[1]
      local __val = ____id10[2]
      local __bs1 = cut(____id10, 2)
      local __id111 = unique(__id11)
      return {"%do", {"%local", __id111, __val}, {"let-symbol", {__id11, __id111}, join({"let", join(__bs1, __bs2)}, __body8)}}
    end
  end
end})
setenv("with", {_stash = true, macro = function (x, v, ...)
  local ____r21 = unstash({...})
  local __x70 = destash33(x, ____r21)
  local __v2 = destash33(v, ____r21)
  local ____id12 = ____r21
  local __body9 = cut(____id12, 0)
  return join({"let", {__x70, __v2}}, __body9, {__x70})
end})
setenv("let-when", {_stash = true, macro = function (x, v, ...)
  local ____r22 = unstash({...})
  local __x75 = destash33(x, ____r22)
  local __v3 = destash33(v, ____r22)
  local ____id13 = ____r22
  local __body10 = cut(____id13, 0)
  local __y = unique("y")
  return {"let", __y, __v3, {"when", {"yes", __y}, join({"let", {__x75, __y}}, __body10)}}
end})
setenv("define-transformer", {_stash = true, macro = function (name, form, ...)
  local ____r23 = unstash({...})
  local __name1 = destash33(name, ____r23)
  local __form1 = destash33(form, ____r23)
  local ____id14 = ____r23
  local __body11 = cut(____id14, 0)
  local ____x82 = {"setenv", {"quote", __name1}}
  ____x82.transformer = join({"fn", {__form1}}, __body11)
  return join(____x82, props(__body11))
end})
setenv("define-macro", {_stash = true, macro = function (name, args, ...)
  local ____r24 = unstash({...})
  local __name2 = destash33(name, ____r24)
  local __args1 = destash33(args, ____r24)
  local ____id15 = ____r24
  local __body12 = cut(____id15, 0)
  local ____x87 = {"setenv", {"quote", __name2}}
  ____x87.macro = join({"fn", __args1}, __body12)
  return join(____x87, props(__body12))
end})
setenv("define-special", {_stash = true, macro = function (name, args, ...)
  local ____r25 = unstash({...})
  local __name3 = destash33(name, ____r25)
  local __args2 = destash33(args, ____r25)
  local ____id16 = ____r25
  local __body13 = cut(____id16, 0)
  local ____x91 = {"setenv", {"quote", __name3}}
  ____x91.special = join({"fn", __args2}, __body13)
  return join(____x91, props(__body13))
end})
setenv("define-symbol", {_stash = true, macro = function (name, expansion)
  local ____x94 = {"setenv", {"quote", name}}
  ____x94.symbol = {"quote", expansion}
  return ____x94
end})
setenv("define-reader", {_stash = true, macro = function (__x97, ...)
  local ____id17 = __x97
  local __char = ____id17[1]
  local __s = ____id17[2]
  local ____r27 = unstash({...})
  local ____x97 = destash33(__x97, ____r27)
  local ____id18 = ____r27
  local __body14 = cut(____id18, 0)
  return {"set", {"get", "read-table", __char}, join({"fn", {__s}}, __body14)}
end})
setenv("define", {_stash = true, macro = function (name, x, ...)
  local ____r28 = unstash({...})
  local __name4 = destash33(name, ____r28)
  local __x104 = destash33(x, ____r28)
  local ____id19 = ____r28
  local __body15 = cut(____id19, 0)
  if some63(__body15) then
    return join({"%local-function", __name4}, bind_function(__x104, __body15), props(__body15))
  else
    return {"%local", __name4, __x104}
  end
end})
setenv("define-global", {_stash = true, macro = function (name, x, ...)
  local ____r29 = unstash({...})
  local __name5 = destash33(name, ____r29)
  local __x108 = destash33(x, ____r29)
  local ____id20 = ____r29
  local __body16 = cut(____id20, 0)
  if some63(__body16) then
    return join({"%global-function", __name5}, bind_function(__x108, __body16), props(__body16))
  else
    if global_id63(__name5) then
      return {"set", __name5, __x108}
    else
      return {"set", {"get", "_G", {"quote", compile(__name5)}}, __x108}
    end
  end
end})
setenv("with-frame", {_stash = true, macro = function (...)
  local __body17 = unstash({...})
  local __x115 = unique("x")
  return {"%do", {"add", "environment*", {"obj"}}, {"with", __x115, join({"%do"}, __body17), {"drop", "environment*"}}}
end})
setenv("with-bindings", {_stash = true, macro = function (__x122, ...)
  local ____id21 = __x122
  local __names = ____id21[1]
  local ____r30 = unstash({...})
  local ____x122 = destash33(__x122, ____r30)
  local ____id22 = ____r30
  local __body18 = cut(____id22, 0)
  local __x124 = unique("x")
  local ____x127 = {"setenv", __x124}
  ____x127.variable = true
  return join({"with-frame", {"each", __x124, __names, ____x127}}, __body18)
end})
setenv("let-macro", {_stash = true, macro = function (definitions, ...)
  local ____r31 = unstash({...})
  local __definitions = destash33(definitions, ____r31)
  local ____id23 = ____r31
  local __body19 = cut(____id23, 0)
  add(_G.environment, {})
  local ____x130 = __definitions
  local ____i1 = 0
  while ____i1 < _35(____x130) do
    local __m = ____x130[____i1 + 1]
    eval(join({"define-macro"}, __m))
    ____i1 = ____i1 + 1
  end
  local ____x129 = join({"%do"}, macroexpand(__body19))
  drop(_G.environment)
  return ____x129
end})
setenv("let-symbol", {_stash = true, macro = function (expansions, ...)
  local ____r32 = unstash({...})
  local __expansions = destash33(expansions, ____r32)
  local ____id24 = ____r32
  local __body20 = cut(____id24, 0)
  add(_G.environment, {})
  local ____x135 = pair(__expansions)
  local ____i2 = 0
  while ____i2 < _35(____x135) do
    local ____id25 = ____x135[____i2 + 1]
    local __name6 = ____id25[1]
    local __exp = ____id25[2]
    eval({"define-symbol", __name6, __exp})
    ____i2 = ____i2 + 1
  end
  local ____x134 = join({"%do"}, macroexpand(__body20))
  drop(_G.environment)
  return ____x134
end})
setenv("let-unique", {_stash = true, macro = function (names, ...)
  local ____r33 = unstash({...})
  local __names1 = destash33(names, ____r33)
  local ____id26 = ____r33
  local __body21 = cut(____id26, 0)
  local __bs11 = map(function (n)
    return {n, {"unique", {"quote", n}}}
  end, __names1)
  return join({"let", apply(join, __bs11)}, __body21)
end})
setenv("fn", {_stash = true, macro = function (args, ...)
  local ____r35 = unstash({...})
  local __args3 = destash33(args, ____r35)
  local ____id27 = ____r35
  local __body22 = cut(____id27, 0)
  return join({"%function"}, bind_function(__args3, __body22), props(__body22))
end})
setenv("apply", {_stash = true, macro = function (f, ...)
  local ____r36 = unstash({...})
  local __f = destash33(f, ____r36)
  local ____id28 = ____r36
  local __args4 = cut(____id28, 0)
  if _35(__args4) > 1 then
    return {"%call", "apply", __f, {"join", join({"list"}, almost(__args4)), last(__args4)}}
  else
    return join({"%call", "apply", __f}, __args4)
  end
end})
setenv("guard", {_stash = true, macro = function (expr)
  if _G.target == "js" then
    return {{"fn", join(), {"%try", {"list", true, expr}}}}
  else
    local ____x161 = {"obj"}
    ____x161.stack = {{"get", "debug", {"quote", "traceback"}}}
    ____x161.message = {"if", {"string?", "m"}, {"clip", "m", {"+", {"or", {"search", "m", "\": \""}, -2}, 2}}, {"=", "nil", "m"}, "\"\"", {"str", "m"}}
    return {"list", {"xpcall", {"fn", join(), expr}, {"fn", {"m"}, {"if", {"obj?", "m"}, "m", ____x161}}}}
  end
end})
setenv("each", {_stash = true, macro = function (x, t, ...)
  local ____r38 = unstash({...})
  local __x174 = destash33(x, ____r38)
  local __t = destash33(t, ____r38)
  local ____id29 = ____r38
  local __body23 = cut(____id29, 0)
  local __o1 = unique("o")
  local __n1 = unique("n")
  local __i3 = unique("i")
  local __e = nil
  if atom63(__x174) then
    __e = {__i3, __x174}
  else
    local __e1 = nil
    if _35(__x174) > 1 then
      __e1 = __x174
    else
      __e1 = {__i3, hd(__x174)}
    end
    __e = __e1
  end
  local ____id30 = __e
  local __k1 = ____id30[1]
  local __v4 = ____id30[2]
  return {"let", {__o1, __t}, {"for", {__k1}, {"pairs", __o1}, join({"let", {__v4, {"get", __o1, __k1}}}, __body23)}}
end})
setenv("for", {_stash = true, macro = function (i, to, ...)
  local ____r39 = unstash({...})
  local __i4 = destash33(i, ____r39)
  local __to = destash33(to, ____r39)
  local ____id31 = ____r39
  local __body24 = cut(____id31, 0)
  if obj63(__i4) then
    return {"let", apply(join, map(function (x)
      return {x, "nil"}
    end, __i4)), join({"%for", __to, join({"%names"}, __i4), join({"%do"}, __body24)}, props(__body24))}
  else
    return {"let", __i4, 0, join({"while", {"<", __i4, __to}}, __body24, {{"inc", __i4}})}
  end
end})
setenv("step", {_stash = true, macro = function (v, t, ...)
  local ____r41 = unstash({...})
  local __v5 = destash33(v, ____r41)
  local __t1 = destash33(t, ____r41)
  local ____id32 = ____r41
  local __body25 = cut(____id32, 0)
  local __x197 = unique("x")
  local __i5 = unique("i")
  return {"let", {__x197, __t1}, {"for", __i5, {"#", __x197}, join({"let", {__v5, {"at", __x197, __i5}}}, __body25)}}
end})
setenv("set-of", {_stash = true, macro = function (...)
  local __xs = unstash({...})
  local __l1 = {}
  local ____o2 = __xs
  local ____i6 = nil
  for ____i6 in pairs(____o2) do
    local __x206 = ____o2[____i6]
    __l1[__x206] = true
  end
  return join({"obj"}, __l1)
end})
setenv("language", {_stash = true, macro = function ()
  return {"quote", _G.target}
end})
setenv("target", {_stash = true, macro = function (...)
  local __clauses1 = unstash({...})
  return __clauses1[_G.target]
end})
setenv("join!", {_stash = true, macro = function (a, ...)
  local ____r43 = unstash({...})
  local __a1 = destash33(a, ____r43)
  local ____id33 = ____r43
  local __bs21 = cut(____id33, 0)
  return {"set", __a1, join({"join", __a1}, __bs21)}
end})
setenv("cat!", {_stash = true, macro = function (a, ...)
  local ____r44 = unstash({...})
  local __a2 = destash33(a, ____r44)
  local ____id34 = ____r44
  local __bs3 = cut(____id34, 0)
  return {"set", __a2, join({"cat", __a2}, __bs3)}
end})
setenv("inc", {_stash = true, macro = function (n, by)
  local __e2 = nil
  if nil63(by) then
    __e2 = 1
  else
    __e2 = by
  end
  return {"set", n, {"+", n, __e2}}
end})
setenv("dec", {_stash = true, macro = function (n, by)
  local __e3 = nil
  if nil63(by) then
    __e3 = 1
  else
    __e3 = by
  end
  return {"set", n, {"-", n, __e3}}
end})
setenv("with-indent", {_stash = true, macro = function (form)
  local __x220 = unique("x")
  return {"%do", {"inc", "indent-level*"}, {"with", __x220, form, {"dec", "indent-level*"}}}
end})
setenv("undefined?", {_stash = true, macro = function (x)
  local ____x225 = {"target"}
  ____x225.lua = {"=", x, "nil"}
  ____x225.js = {"=", {"typeof", x}, "\"undefined\""}
  return ____x225
end})
setenv("export", {_stash = true, macro = function (...)
  local __names2 = unstash({...})
  local ____x237 = {"target"}
  ____x237.lua = {"return", "exports"}
  return join({"with", "exports", {"if", {"undefined?", "exports"}, {"obj"}, "exports"}}, map(function (k)
    return {"set", {"exports", "." .. k}, k}
  end, __names2), {____x237})
end})
setenv("when-compiling", {_stash = true, macro = function (...)
  local __body26 = unstash({...})
  return eval(join({"%do"}, __body26))
end})
setenv("during-compilation", {_stash = true, macro = function (...)
  local __body27 = unstash({...})
  local __form2 = join({"%do"}, __body27, {{"%do"}})
  eval(__form2)
  return __form2
end})
setenv("compose", {_stash = true, transformer = function (__x245)
  local ____id35 = __x245
  local ____id36 = ____id35[1]
  local __compose = ____id36[1]
  local __fns = cut(____id36, 1)
  local __body28 = cut(____id35, 1)
  if none63(__fns) then
    return macroexpand(join({"do"}, __body28))
  else
    if one63(__fns) then
      return macroexpand(join(__fns, __body28))
    else
      return macroexpand({join({__compose}, almost(__fns)), join({last(__fns)}, __body28)})
    end
  end
end})
setenv("complement", {_stash = true, transformer = function (__x250)
  local ____id37 = __x250
  local ____id38 = ____id37[1]
  local __complement = ____id38[1]
  local __form3 = ____id38[2]
  local __body29 = cut(____id37, 1)
  if hd63(__form3, "complement") then
    return macroexpand(join({__form3[2]}, __body29))
  else
    return macroexpand({"no", join({__form3}, __body29)})
  end
end})
setenv("expansion", {_stash = true, transformer = function (__x254)
  local ____id39 = __x254
  local ____id40 = ____id39[1]
  local __expansion = ____id40[1]
  local __form4 = ____id39[2]
  return __form4
end})
setenv("jsx", {_stash = true, transformer = function (__x255)
  local ____id41 = __x255
  local ____id42 = ____id41[1]
  local __jsx = ____id42[1]
  local __name7 = ____id42[2]
  local __body30 = cut(____id41, 1)
  return macroexpand(join({{"React", ".create-element"}, {"quote", __name7}, join({"%object"}, mapo(function (x)
    return x
  end, props(__body30)))}, vals(__body30)))
end})
setenv("hd", {_stash = true, expander = function (setfn, ...)
  local ____r57 = unstash({...})
  local __setfn1 = destash33(setfn, ____r57)
  local ____id44 = ____r57
  local __args6 = cut(____id44, 0)
  return define_setter("hd", function (v, l)
    return {"set", {"at", l, 0}, v}
  end, __setfn1, __args6)
end})
setenv("mac", {_stash = true, macro = function (name, args, ...)
  local ____r59 = unstash({...})
  local __name8 = destash33(name, ____r59)
  local __args7 = destash33(args, ____r59)
  local ____id45 = ____r59
  local __body31 = cut(____id45, 0)
  return {"during-compilation", join({"define-macro", __name8, __args7}, __body31)}
end})
setenv("def", {_stash = true, macro = function (name, args, ...)
  local ____r60 = unstash({...})
  local __name9 = destash33(name, ____r60)
  local __args8 = destash33(args, ____r60)
  local ____id46 = ____r60
  local __body32 = cut(____id46, 0)
  return {"during-compilation", join({"define-global", __name9, __args8}, __body32)}
end})
setenv("in", {_stash = true, macro = function (x, ...)
  local ____r61 = unstash({...})
  local __x273 = destash33(x, ____r61)
  local ____id47 = ____r61
  local __vals = cut(____id47, 0)
  if none63(__vals) then
    return {"do"}
  else
    if one63(__vals) then
      return {"=", __x273, hd(__vals)}
    else
      return join({"or"}, map(function (v)
        return {"=", __x273, v}
      end, __vals))
    end
  end
end})
local __dirname = "/code/ref/lumen-language/2018-10-21/lumen3"
local reader = require("./reader")
local compiler = require("./compiler")
local system = require("./system")
function _G.error_message(v)
  return "error: " .. v.message .. "\n" .. v.stack
end
local function eval_print(form)
  local ____id = {xpcall(function ()
    return compiler.eval({"results", form})
  end, function (m)
    if obj63(m) then
      return m
    else
      local __e = nil
      if string63(m) then
        __e = clip(m, (search(m, ": ") or -2) + 2)
      else
        local __e1 = nil
        if nil == m then
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
    return print(error_message(__v))
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
function _G.file_truedir(path)
  if system.fileExists63(path) then
    return shell("cd \"$(dirname " .. escape(path) .. ")\" && pwd")
  else
    return path
  end
end
function _G.read_from_file(path)
  local __s1 = reader.stream(system.readFile(path))
  local __body = reader.readAll(__s1)
  return join({"do", {"%local", "__dirname", escape(file_truedir(path))}}, __body)
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
    local ____x6 = {__form2}
    ____x6.rest = __s2.pos
    return ____x6
  end
end
function _G.readable_string63(str)
  local __id5 = string63(str)
  local __e4 = nil
  if __id5 then
    local ____id2 = {xpcall(function ()
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
          if nil == m then
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
  if x == nil then
    return "nil"
  else
    if x == null then
      return "null"
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
        local ____x8 = __pre
        local ____i3 = 0
        while ____i3 < _35(____x8) do
          local __file = ____x8[____i3 + 1]
          run_file(__file)
          ____i3 = ____i3 + 1
        end
        local ____x9 = __cmds
        local ____i4 = 0
        while ____i4 < _35(____x9) do
          local ____id3 = ____x9[____i4 + 1]
          local __a = ____id3[1]
          local __val = ____id3[2]
          if __a == "target" then
            _G.target = hd(__val)
            break
          end
          ____i4 = ____i4 + 1
        end
        local ____x10 = __cmds
        local ____i5 = 0
        while ____i5 < _35(____x10) do
          local ____id4 = ____x10[____i5 + 1]
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
                  local ____x11 = __val1
                  local ____i6 = 0
                  while ____i6 < _35(____x11) do
                    local __x12 = ____x11[____i6 + 1]
                    __input = __input .. compile_file(__x12)
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
                        local ____x13 = __val1
                        local ____i7 = 0
                        while ____i7 < _35(____x13) do
                          local __x14 = ____x13[____i7 + 1]
                          rep(__x14)
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
