function _G.getenv(k, p)
  if string63(k) then
    local __i = edge(_G.environment)
    while __i >= 0 do
      local __b = _G.environment[__i + 1][k]
      if is63(__b) then
        local __e9 = nil
        if p then
          __e9 = __b[p]
        else
          __e9 = __b
        end
        return __e9
      else
        __i = __i - 1
      end
    end
  end
end
local function transformer_function(k)
  return getenv(k, "transformer")
end
local function transformer63(k)
  return is63(transformer_function(k))
end
local function macro_function(k)
  return getenv(k, "macro")
end
local function macro63(k)
  return is63(macro_function(k))
end
local function special63(k)
  return is63(getenv(k, "special"))
end
local function special_form63(form)
  return not atom63(form) and special63(hd(form))
end
local function statement63(k)
  return special63(k) and getenv(k, "stmt")
end
local function symbol_expansion(k)
  return getenv(k, "symbol")
end
local function symbol63(k)
  return is63(symbol_expansion(k))
end
local function variable63(k)
  return is63(getenv(k, "variable"))
end
function _G.bound63(x)
  return macro63(x) or special63(x) or symbol63(x) or variable63(x)
end
function _G.quoted(form)
  if string63(form) then
    return escape(form)
  else
    if atom63(form) then
      return form
    else
      return join({"list"}, map(quoted, form))
    end
  end
end
function _G.unquoted(form)
  if string_literal63(form) then
    if read_string(form) == form then
      return eval(form)
    else
      return error("unquoted: bad string-literal")
    end
  else
    if hd63(form, "quote") then
      return form[2]
    else
      return compile(form)
    end
  end
end
local function literal(s)
  if string_literal63(s) then
    return s
  else
    return quoted(s)
  end
end
local function stash_function(args)
  if keys63(args) then
    local __l = {"%object", "\"_stash\"", true}
    local ____o = args
    local __k = nil
    for __k in pairs(____o) do
      local __v = ____o[__k]
      if not number63(__k) then
        add(__l, literal(__k))
        add(__l, __v)
      end
    end
    return join(args, {__l})
  else
    return args
  end
end
local function bias(k)
  if number63(k) and not( _G.target == "lua") then
    if _G.target == "js" then
      k = k - 1
    else
      k = k + 1
    end
  end
  return k
end
function _G.bind_optional(lh, rh)
  if hd63(lh, "o") or hd63(lh, "or") or hd63(lh, "&optional") then
    local ____id = lh
    local ___ = ____id[1]
    local __var = ____id[2]
    local __val = ____id[3]
    return bind(__var, {"%if", {"==", rh, "nil"}, either(__val, "nil"), rh})
  end
end
function _G.bind_dotted(args)
  if _35(args) >= 2 and args[_35(args) - 2 + 1] == "." then
    return join(cut(args, 0, _35(args) - 2), {rest = last(args)})
  else
    return args
  end
end
function _G.bind_destructuring(lh, rh)
  local __lh = bind_dotted(lh)
  local __id1 = unique("id")
  local __bs = {__id1, rh}
  local ____o1 = __lh
  local __k1 = nil
  for __k1 in pairs(____o1) do
    local __v1 = ____o1[__k1]
    local __e10 = nil
    if __k1 == "rest" then
      __e10 = {"cut", __id1, _35(__lh)}
    else
      __e10 = {"get", __id1, {"quote", bias(__k1)}}
    end
    local __x6 = __e10
    __bs = join(__bs, bind(__v1, __x6))
  end
  return __bs
end
function _G.bind(lh, rh)
  if atom63(lh) then
    return {lh, rh}
  else
    return bind_optional(lh, rh) or bind_destructuring(lh, rh)
  end
end
function _G.bind_function(args, body)
  local __args = bind_dotted(args)
  local __args1 = {}
  local function rest()
    __args1.rest = true
    return {"unstash", {"list", "..."}}
  end
  if atom63(__args) then
    return {__args1, join({"let", {__args, rest()}}, body)}
  else
    local __bs1 = {}
    local __ks = {}
    local __r23 = unique("r")
    local ____o2 = __args
    local __k2 = nil
    for __k2 in pairs(____o2) do
      local __v2 = ____o2[__k2]
      if number63(__k2) then
        if atom63(__v2) then
          add(__args1, __v2)
        else
          local __x16 = unique("x")
          add(__args1, __x16)
          __bs1 = join(__bs1, {__v2, __x16})
        end
      else
        __ks[__k2] = __v2
      end
    end
    if keys63(__args) then
      __bs1 = join(__bs1, {__r23, rest()})
      local __n3 = _35(__args1)
      local __i4 = 0
      while __i4 < __n3 do
        local __v3 = __args1[__i4 + 1]
        __bs1 = join(__bs1, {__v3, {"destash!", __v3, __r23}})
        __i4 = __i4 + 1
      end
      __bs1 = join(__bs1, {__ks, __r23})
    end
    return {__args1, join({"let", __bs1}, body)}
  end
end
local function quoting63(depth)
  return number63(depth)
end
local function quasiquoting63(depth)
  return quoting63(depth) and depth > 0
end
local function can_unquote63(depth)
  return quoting63(depth) and depth == 1
end
local function quasisplice63(x, depth)
  return can_unquote63(depth) and not atom63(x) and hd(x) == "unquote-splicing"
end
local function expand_local(__x24)
  local ____id2 = __x24
  local __x25 = ____id2[1]
  local __name = ____id2[2]
  local __value = ____id2[3]
  setenv(__name, {_stash = true, variable = true})
  return {"%local", macroexpand(__name), macroexpand(__value)}
end
local function expand_function(__x27)
  local ____id3 = __x27
  local __x28 = ____id3[1]
  local __args11 = ____id3[2]
  local __body = cut(____id3, 2)
  add(_G.environment, {})
  local ____o3 = __args11
  local ____i5 = nil
  for ____i5 in pairs(____o3) do
    local ____x29 = ____o3[____i5]
    setenv(____x29, {_stash = true, variable = true})
  end
  local ____x30 = join({"%function", __args11}, map(macroexpand, __body))
  drop(_G.environment)
  return ____x30
end
local function expand_definition(__x32)
  local ____id4 = __x32
  local __x33 = ____id4[1]
  local __name1 = ____id4[2]
  local __args2 = ____id4[3]
  local __body1 = cut(____id4, 3)
  add(_G.environment, {})
  local ____o4 = __args2
  local ____i6 = nil
  for ____i6 in pairs(____o4) do
    local ____x34 = ____o4[____i6]
    setenv(____x34, {_stash = true, variable = true})
  end
  local ____x35 = join({__x33, macroexpand(__name1), __args2}, map(macroexpand, __body1))
  drop(_G.environment)
  return ____x35
end
local function expand_macro(form)
  return macroexpand(expand1(form))
end
function _G.expand1(__x37)
  local ____id5 = __x37
  local __name2 = ____id5[1]
  local __body2 = cut(____id5, 1)
  return apply(macro_function(__name2), __body2)
end
local function expand_transformer(form)
  return transformer_function(hd(hd(form)))(form)
end
function _G.identifier63(x)
  return string63(x) and not string_literal63(x) and not id_literal63(x) and not accessor_literal63(x)
end
function _G.expand_compose(form)
  if identifier63(form) then
    if _35(form) >= 3 then
      local ____y = search(form, ":")
      if yes(____y) then
        local __i7 = ____y
        local __parts = split(form, ":")
        if not find(none63, __parts) then
          return join({"compose"}, map(expand_atom, map(read_string, __parts)))
        end
      end
    end
  end
end
function _G.orf(f, ...)
  if none63({...}) then
    return function (...)
      return f(...)
    end
  else
    local __g = orf(...)
    return function (...)
      local __x40 = f(...)
      if yes(__x40) then
        return __x40
      else
        return __g(...)
      end
    end
  end
end
function _G.andf(f, ...)
  if none63({...}) then
    return function (...)
      return f(...)
    end
  else
    local __g1 = andf(...)
    return function (...)
      return f(...) and __g1(...)
    end
  end
end
function _G.expand_and(form)
  if identifier63(form) then
    if _35(form) >= 3 then
      local ____y1 = search(form, "&")
      if yes(____y1) then
        local __i8 = ____y1
        local __parts1 = split(form, "&")
        if not find(none63, __parts1) then
          return join({"andf"}, map(expand_atom, map(read_string, __parts1)))
        end
      end
    end
  end
end
function _G.ref(l, k)
  if not nil63(l) then
    if function63(l) then
      return l(k)
    else
      return l[k]
    end
  end
end
function _G.set_ref(l, k, v)
  if nil63(l) then
    return v
  else
    if function63(l) then
      set_ref(l(), k, v)
      return l
    else
      l[k] = v
      return l
    end
  end
end
function _G.expand_ref(form)
  if identifier63(form) then
    if char(form, 0) == "!" and not( char(form, 1) == "!") and _35(form) >= 2 then
      return {{"%brackets"}, "do", "_" .. form}
    else
      if _35(form) >= 3 then
        local ____y2 = search(form, "!")
        if yes(____y2) then
          local __i9 = ____y2
          local __parts2 = split(form, "!")
          if not find(none63, __parts2) then
            local __x45 = expand_atom(read_string(hd(__parts2)))
            local ____x46 = map(expand_atom, map(read_string, tl(__parts2)))
            local ____i10 = 0
            while ____i10 < _35(____x46) do
              local __k3 = ____x46[____i10 + 1]
              __x45 = {"ref", __x45, quoted(__k3)}
              ____i10 = ____i10 + 1
            end
            return __x45
          end
        end
      end
    end
  end
end
function _G.jsx63(form)
  return identifier63(form) and char(form, 0) == "<" and char(form, edge(form)) == ">"
end
function _G.uppercase_code63(c)
  return c >= 65 and c <= 90
end
function _G.compile_jsx(form)
  if form == "" then
    return {"jsx", {"React", ".Fragment"}}
  else
    if identifier63(form) and uppercase_code63(code(form, 0) or 0) then
      return {"jsx", form}
    else
      return {"jsx", quoted(form)}
    end
  end
end
function _G.expand_jsx(form)
  if jsx63(form) then
    return compile_jsx(inner(form))
  end
end
_G.expand_atom_functions = {}
add(_G.expand_atom_functions, expand_jsx)
function _G.expand_atom(form)
  local ____x52 = _G.expand_atom_functions
  local ____i11 = 0
  while ____i11 < _35(____x52) do
    local __f = ____x52[____i11 + 1]
    local __x53 = __f(form)
    if not( __x53 == nil) then
      return __x53
    end
    ____i11 = ____i11 + 1
  end
  return form
end
function _G.macroexpand_atom(form)
  if symbol63(form) then
    return macroexpand(symbol_expansion(form))
  else
    local __expr = expand_atom(form)
    if __expr == form then
      return __expr
    else
      return macroexpand(__expr)
    end
  end
end
function _G.macroexpand(form)
  if atom63(form) then
    return macroexpand_atom(form)
  else
    if none63(form) then
      return map(macroexpand, form)
    else
      local __x54 = macroexpand(hd(form))
      local __args3 = tl(form)
      local __form = join({__x54}, __args3)
      if __x54 == nil then
        return macroexpand(__args3)
      else
        if __x54 == "%local" then
          return expand_local(__form)
        else
          if __x54 == "%function" then
            return expand_function(__form)
          else
            if __x54 == "%global-function" then
              return expand_definition(__form)
            else
              if __x54 == "%local-function" then
                return expand_definition(__form)
              else
                if macro63(__x54) then
                  return expand_macro(__form)
                else
                  if hd63(__x54, transformer63) then
                    return expand_transformer(__form)
                  else
                    return join({__x54}, map(macroexpand, __args3))
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
local function quasiquote_list(form, depth)
  local __xs = {{"list"}}
  local ____o5 = form
  local __k4 = nil
  for __k4 in pairs(____o5) do
    local __v4 = ____o5[__k4]
    if not number63(__k4) then
      local __e11 = nil
      if quasisplice63(__v4, depth) then
        __e11 = quasiexpand(__v4[2])
      else
        __e11 = quasiexpand(__v4, depth)
      end
      local __v5 = __e11
      last(__xs)[__k4] = __v5
    end
  end
  local ____x59 = form
  local ____i13 = 0
  while ____i13 < _35(____x59) do
    local __x60 = ____x59[____i13 + 1]
    if quasisplice63(__x60, depth) then
      local __x61 = quasiexpand(__x60[2])
      add(__xs, __x61)
      add(__xs, {"list"})
    else
      add(last(__xs), quasiexpand(__x60, depth))
    end
    ____i13 = ____i13 + 1
  end
  local __pruned = keep(function (x)
    return _35(x) > 1 or not( hd(x) == "list") or keys63(x)
  end, __xs)
  if one63(__pruned) then
    return hd(__pruned)
  else
    return join({"join"}, __pruned)
  end
end
function _G.quasiexpand(form, depth)
  if quasiquoting63(depth) then
    if atom63(form) then
      return {"quote", form}
    else
      if can_unquote63(depth) and hd(form) == "unquote" then
        return quasiexpand(form[2])
      else
        if hd(form) == "unquote" or hd(form) == "unquote-splicing" then
          return quasiquote_list(form, depth - 1)
        else
          if hd(form) == "quasiquote" then
            return quasiquote_list(form, depth + 1)
          else
            return quasiquote_list(form, depth)
          end
        end
      end
    end
  else
    if atom63(form) then
      return form
    else
      if hd(form) == "quote" then
        return form
      else
        if hd(form) == "quasiquote" then
          return quasiexpand(form[2], 1)
        else
          return map(function (x)
            return quasiexpand(x, depth)
          end, form)
        end
      end
    end
  end
end
function _G.expand_if(__x65)
  local ____id6 = __x65
  local __a = ____id6[1]
  local __b1 = ____id6[2]
  local __c = cut(____id6, 2)
  if is63(__b1) then
    return {join({"%if", __a, __b1}, expand_if(__c))}
  else
    if is63(__a) then
      return {__a}
    end
  end
end
_G.indent_level = 0
function _G.indentation()
  local __s = ""
  local __i14 = 0
  while __i14 < _G.indent_level do
    __s = __s .. "  "
    __i14 = __i14 + 1
  end
  return __s
end
local reserved = {js = {["="] = true, ["=="] = true, ["+"] = true, ["-"] = true, ["%"] = true, ["*"] = true, ["/"] = true, ["<"] = true, [">"] = true, ["<="] = true, [">="] = true, ["break"] = true, case = true, catch = true, class = true, const = true, continue = true, debugger = true, default = true, delete = true, ["do"] = true, ["else"] = true, eval = true, finally = true, ["for"] = true, ["function"] = true, ["if"] = true, import = true, ["in"] = true, instanceof = true, let = true, new = true, ["return"] = true, switch = true, throw = true, try = true, typeof = true, var = true, void = true, with = true}, lua = {["="] = true, ["=="] = true, ["+"] = true, ["-"] = true, ["%"] = true, ["*"] = true, ["/"] = true, ["<"] = true, [">"] = true, ["<="] = true, [">="] = true, ["and"] = true, ["end"] = true, ["in"] = true, ["load"] = true, ["repeat"] = true, ["while"] = true, ["break"] = true, ["false"] = true, ["local"] = true, ["return"] = true, ["do"] = true, ["for"] = true, ["nil"] = true, ["then"] = true, ["else"] = true, ["function"] = true, ["not"] = true, ["true"] = true, ["elseif"] = true, ["if"] = true, ["or"] = true, ["until"] = true}}
function _G.reserved63(x)
  return has63(reserved[_G.target], x)
end
local function valid_code63(n)
  return number_code63(n) or n > 64 and n < 91 or n > 96 and n < 123 or n == 95
end
function _G.global_id63(id)
  local __n7 = _35(id)
  return __n7 > 1 and char(id, __n7 - 1) == "*" and valid_code63(code(id, __n7 - 2))
end
function _G.compile_id(id, escape_reserved63)
  if global_id63(id) then
    return "_G." .. compile_id(clip(id, 0, edge(id)), escape_reserved63)
  else
    local __e12 = nil
    if number_code63(code(id, 0)) then
      __e12 = "_"
    else
      __e12 = ""
    end
    local __id11 = __e12
    local __i15 = 0
    while __i15 < _35(id) do
      local __c1 = char(id, __i15)
      local __n8 = code(__c1)
      local __e13 = nil
      if __c1 == "-" and not( id == "-") then
        __e13 = "_"
      else
        local __e14 = nil
        if valid_code63(__n8) then
          __e14 = __c1
        else
          local __e15 = nil
          if __i15 == 0 then
            __e15 = "_" .. __n8
          else
            __e15 = __n8
          end
          __e14 = __e15
        end
        __e13 = __e14
      end
      local __c11 = __e13
      __id11 = __id11 .. __c11
      __i15 = __i15 + 1
    end
    if either(escape_reserved63, true) and reserved63(__id11) then
      return "_" .. __id11
    else
      return __id11
    end
  end
end
function _G.valid_id63(x, escape_reserved63)
  return some63(x) and x == compile_id(x, escape_reserved63)
end
local __names = {}
function _G.unique(x)
  local __x69 = compile_id(x, true)
  if has63(__names, __x69) then
    local __i16 = __names[__x69]
    __names[__x69] = __names[__x69] + 1
    return unique(__x69 .. __i16)
  else
    __names[__x69] = 1
    return "__" .. __x69
  end
end
function _G.key(k)
  if string_literal63(k) then
    local __i17 = inner(k)
    if valid_id63(__i17) then
      return __i17
    else
      return "[" .. k .. "]"
    end
  else
    return "[" .. tostring(k) .. "]"
  end
end
function _G.mapo(f, t)
  local __o6 = {}
  local ____o7 = t
  local __k5 = nil
  for __k5 in pairs(____o7) do
    local __v6 = ____o7[__k5]
    local __x70 = f(__v6)
    if is63(__x70) then
      add(__o6, literal(__k5))
      add(__o6, __x70)
    end
  end
  return __o6
end
local ____x72 = {}
local ____x73 = {}
____x73.js = "!"
____x73.lua = "not"
____x72["not"] = ____x73
local ____x74 = {}
____x74["*"] = "*"
____x74["/"] = "/"
____x74["%"] = "%"
local ____x75 = {}
local ____x76 = {}
____x76.js = "+"
____x76.lua = ".."
____x75.cat = ____x76
local ____x77 = {}
____x77["+"] = "+"
____x77["-"] = "-"
local ____x78 = {}
____x78["<"] = "<"
____x78[">"] = ">"
____x78["<="] = "<="
____x78[">="] = ">="
local ____x79 = {}
local ____x80 = {}
____x80.js = "==="
____x80.lua = "=="
____x79["=="] = ____x80
local ____x81 = {}
local ____x82 = {}
____x82.js = "&&"
____x82.lua = "and"
____x81["and"] = ____x82
local ____x83 = {}
local ____x84 = {}
____x84.js = "||"
____x84.lua = "or"
____x83["or"] = ____x84
local infix = {____x72, ____x74, ____x75, ____x77, ____x78, ____x79, ____x81, ____x83}
local function unary63(form)
  return two63(form) and in63(hd(form), {"not", "-"})
end
local function index(k)
  if number63(k) then
    return k - 1
  end
end
local function precedence(form)
  if not( atom63(form) or unary63(form)) then
    local ____o8 = infix
    local __k6 = nil
    for __k6 in pairs(____o8) do
      local __v7 = ____o8[__k6]
      if __v7[hd(form)] then
        return index(__k6)
      end
    end
  end
  return 0
end
local function getop(op)
  return find(function (level)
    local __x86 = level[op]
    if obj63(__x86) then
      return __x86[_G.target]
    else
      if string63(__x86) then
        return __x86
      end
    end
  end, infix)
end
local function infix63(x)
  return is63(getop(x))
end
function _G.infix_operator63(x)
  return obj63(x) and infix63(hd(x))
end
local function compile_args(args)
  local __s1 = "("
  local __c2 = ""
  local ____x87 = args
  local ____i20 = 0
  while ____i20 < _35(____x87) do
    local __x88 = ____x87[____i20 + 1]
    __s1 = __s1 .. __c2 .. compile(__x88)
    __c2 = ", "
    ____i20 = ____i20 + 1
  end
  return __s1 .. ")"
end
local function escape_newlines(s)
  local __s11 = ""
  local __i21 = 0
  while __i21 < _35(s) do
    local __c3 = char(s, __i21)
    local __e16 = nil
    if __c3 == "\n" then
      __e16 = "\\n"
    else
      local __e17 = nil
      if __c3 == "\r" then
        __e17 = ""
      else
        __e17 = __c3
      end
      __e16 = __e17
    end
    __s11 = __s11 .. __e16
    __i21 = __i21 + 1
  end
  return __s11
end
function _G.compile_atom(x, escape_reserved63)
  if x == "nil" and _G.target == "lua" then
    return x
  else
    if x == "nil" then
      return "undefined"
    else
      if x == "..." then
        local __e18 = nil
        if _G.target == "js" then
          __e18 = compile("*args")
        else
          __e18 = ""
        end
        return "..." .. __e18
      else
        if id_literal63(x) then
          return inner(x)
        else
          if string_literal63(x) then
            return escape_newlines(x)
          else
            if string63(x) then
              return compile_id(x, either(escape_reserved63, true))
            else
              if boolean63(x) then
                if x then
                  return "true"
                else
                  return "false"
                end
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
                      if number63(x) then
                        return x .. ""
                      else
                        return error("Cannot compile atom: " .. str(x))
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
local function terminator(stmt63)
  if not stmt63 then
    return ""
  else
    if _G.target == "js" then
      return ";\n"
    else
      return "\n"
    end
  end
end
local function compile_special(form, stmt63)
  local ____id7 = form
  local __x89 = ____id7[1]
  local __args4 = cut(____id7, 1)
  local ____id8 = getenv(__x89)
  local __special = ____id8.special
  local __stmt = ____id8.stmt
  local __self_tr63 = ____id8.tr
  local __tr = terminator(stmt63 and not __self_tr63)
  return apply(__special, __args4) .. __tr
end
function _G.accessor_literal63(x)
  return string63(x) and char(x, 0) == "." and not( char(x, 1) == ".") and some63(char(x, 1))
end
function _G.accessor_form63(x)
  return obj63(x) and accessor_literal63(last(x))
end
function _G.accessor_literal(x)
  return compile(camel_case(clip(x, 1)), {_stash = true, ["escape-reserved"] = false})
end
function _G.compile_method(f, args, chain63)
  if chain63 and none63(args) then
    return f
  else
    local __x90 = hd(args)
    if accessor_literal63(__x90) then
      return compile_method(f .. "." .. accessor_literal(__x90), tl(args), true)
    else
      if hd63(__x90, accessor_literal63) then
        local __e19 = nil
        if _G.target == "lua" then
          __e19 = ":"
        else
          __e19 = "."
        end
        return compile_method(f .. __e19 .. accessor_literal(hd(__x90)) .. compile_args(tl(__x90)), tl(args), true)
      else
        return f .. compile_args(args)
      end
    end
  end
end
local function parenthesize_call63(x)
  return not atom63(x) and hd(x) == "%function" or precedence(x) > 0
end
local function compile_call(form)
  local __f1 = hd(form)
  local __f11 = compile(__f1)
  local __args5 = compile_method("", stash_function(tl(form)))
  if parenthesize_call63(__f1) then
    return "(" .. __f11 .. ")" .. __args5
  else
    return __f11 .. __args5
  end
end
local function op_delims(parent, child, right63)
  local __e20 = nil
  if right63 then
    __e20 = _6261
  else
    __e20 = _62
  end
  if __e20(precedence(child), precedence(parent)) then
    return {"(", ")"}
  else
    return {"", ""}
  end
end
local function compile_infix(form)
  local ____id9 = form
  local __op = ____id9[1]
  local ____id10 = cut(____id9, 1)
  local __a1 = ____id10[1]
  local __b2 = ____id10[2]
  local ____id111 = op_delims(form, __a1, false)
  local __ao = ____id111[1]
  local __ac = ____id111[2]
  local ____id12 = op_delims(form, __b2, true)
  local __bo = ____id12[1]
  local __bc = ____id12[2]
  local __a2 = compile(__a1)
  local __b3 = compile(__b2)
  local __op1 = getop(__op)
  if unary63(form) then
    return __op1 .. __ao .. " " .. __a2 .. __ac
  else
    return __ao .. __a2 .. __ac .. " " .. __op1 .. " " .. __bo .. __b3 .. __bc
  end
end
function _G.compile_function(args, body, ...)
  local ____r87 = unstash({...})
  local __args6 = destash33(args, ____r87)
  local __body3 = destash33(body, ____r87)
  local ____id13 = ____r87
  local __name3 = ____id13.name
  local __prefix = ____id13.prefix
  local __global63 = ____id13.global
  local __async63 = ____id13.async
  local __generator63 = ____id13.generator
  local __e21 = nil
  if __name3 then
    __e21 = compile(__name3)
  else
    __e21 = ""
  end
  local __id14 = __e21
  local __e22 = nil
  if __global63 then
    __e22 = "_G." .. __id14
  else
    __e22 = __id14
  end
  local __id15 = __e22
  local __e23 = nil
  if __args6.rest then
    __e23 = join(__args6, {"..."})
  else
    __e23 = __args6
  end
  local __args12 = __e23
  local __args7 = compile_args(__args12)
  _G.indent_level = _G.indent_level + 1
  local ____x95 = compile(__body3, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  local __body4 = ____x95
  local __ind = indentation()
  local __e24 = nil
  if __prefix then
    __e24 = __prefix .. " "
  else
    __e24 = ""
  end
  local __p = __e24
  local __e25 = nil
  if _G.target == "js" then
    __e25 = ""
  else
    __e25 = "end"
  end
  local __tr1 = __e25
  local __e26 = nil
  if __async63 then
    __e26 = "async "
  else
    __e26 = ""
  end
  local __async1 = __e26
  local __e27 = nil
  if __generator63 then
    __e27 = "function* "
  else
    __e27 = "function "
  end
  local __func = __e27
  if __name3 then
    __tr1 = __tr1 .. "\n"
  end
  if _G.target == "js" then
    return __async1 .. __func .. __id15 .. __args7 .. " {\n" .. __body4 .. __ind .. "}" .. __tr1
  else
    return __p .. "function " .. __id15 .. __args7 .. "\n" .. __body4 .. __ind .. __tr1
  end
end
local function can_return63(form)
  return is63(form) and (atom63(form) or not( hd(form) == "return") and not statement63(hd(form)))
end
function _G.compile(form, ...)
  local ____r89 = unstash({...})
  local __form1 = destash33(form, ____r89)
  local ____id16 = ____r89
  local __stmt1 = ____id16.stmt
  local __esc63 = ____id16["escape-reserved"]
  if nil63(__form1) then
    return ""
  else
    if special_form63(__form1) then
      return compile_special(__form1, __stmt1)
    else
      local __tr2 = terminator(__stmt1)
      local __e28 = nil
      if __stmt1 then
        __e28 = indentation()
      else
        __e28 = ""
      end
      local __ind1 = __e28
      local __e29 = nil
      if atom63(__form1) then
        __e29 = compile_atom(__form1, either(__esc63, true))
      else
        local __e30 = nil
        if infix63(hd(__form1)) then
          __e30 = compile_infix(__form1)
        else
          __e30 = compile_call(__form1)
        end
        __e29 = __e30
      end
      local __form2 = __e29
      return __ind1 .. __form2 .. __tr2
    end
  end
end
local function lower_statement(form, tail63)
  local __hoist = {}
  local __e = lower(form, __hoist, true, tail63)
  local __e31 = nil
  if some63(__hoist) and is63(__e) then
    __e31 = join({"%do"}, __hoist, {__e})
  else
    local __e32 = nil
    if is63(__e) then
      __e32 = __e
    else
      local __e33 = nil
      if _35(__hoist) > 1 then
        __e33 = join({"%do"}, __hoist)
      else
        __e33 = hd(__hoist)
      end
      __e32 = __e33
    end
    __e31 = __e32
  end
  return either(__e31, {"%do"})
end
local function lower_body(body, tail63)
  return lower_statement(join({"%do"}, body), tail63)
end
local function literal63(form)
  return atom63(form) or hd(form) == "%array" or hd(form) == "%object"
end
local function standalone63(form)
  return not atom63(form) and not infix63(hd(form)) and not literal63(form) and not( "get" == hd(form)) and not accessor_form63(form) or id_literal63(form)
end
local function lower_do(args, hoist, stmt63, tail63)
  local ____x102 = almost(args)
  local ____i22 = 0
  while ____i22 < _35(____x102) do
    local __x103 = ____x102[____i22 + 1]
    local ____y3 = lower(__x103, hoist, stmt63)
    if yes(____y3) then
      local __e1 = ____y3
      if standalone63(__e1) then
        add(hoist, __e1)
      end
    end
    ____i22 = ____i22 + 1
  end
  local __e2 = lower(last(args), hoist, stmt63, tail63)
  if tail63 and can_return63(__e2) then
    return {"return", __e2}
  else
    return __e2
  end
end
local function lower_set(args, hoist, stmt63, tail63)
  local ____id17 = args
  local __lh1 = ____id17[1]
  local __rh = ____id17[2]
  local __lh11 = lower(__lh1, hoist)
  local __rh1 = lower(__rh, hoist)
  add(hoist, {"%set", __lh11, __rh1})
  if not( stmt63 and not tail63) then
    return __lh11
  end
end
local function lower_if(args, hoist, stmt63, tail63)
  local ____id18 = args
  local __cond = ____id18[1]
  local ___then = ____id18[2]
  local ___else = ____id18[3]
  if stmt63 then
    local __e35 = nil
    if is63(___else) then
      __e35 = {lower_body({___else}, tail63)}
    end
    return add(hoist, join({"%if", lower(__cond, hoist), lower_body({___then}, tail63)}, __e35))
  else
    local __e3 = unique("e")
    add(hoist, {"%local", __e3, "nil"})
    local __e34 = nil
    if is63(___else) then
      __e34 = {lower({"%set", __e3, ___else})}
    end
    add(hoist, join({"%if", lower(__cond, hoist), lower({"%set", __e3, ___then})}, __e34))
    return __e3
  end
end
local function lower_short(x, args, hoist)
  local ____id19 = args
  local __a3 = ____id19[1]
  local __b4 = ____id19[2]
  local __hoist1 = {}
  local __b11 = lower(__b4, __hoist1)
  if some63(__hoist1) then
    local __id20 = unique("id")
    local __e36 = nil
    if x == "and" then
      __e36 = {"%if", __id20, __b4, __id20}
    else
      __e36 = {"%if", __id20, __id20, __b4}
    end
    return lower({"%do", {"%local", __id20, __a3}, __e36}, hoist)
  else
    return {x, lower(__a3, hoist), __b11}
  end
end
local function lower_try(args, hoist, tail63)
  return add(hoist, {"%try", lower_body(args, tail63)})
end
local function lower_while(args, hoist)
  local ____id21 = args
  local __c4 = ____id21[1]
  local __body5 = cut(____id21, 1)
  local __pre = {}
  local __c5 = lower(__c4, __pre)
  local __e37 = nil
  if none63(__pre) then
    __e37 = {"%while", __c5, lower_body(__body5)}
  else
    __e37 = {"%while", true, join({"%do"}, __pre, {{"%if", {"not", __c5}, {"break"}}, lower_body(__body5)})}
  end
  return add(hoist, __e37)
end
local function lower_for(args, hoist)
  local ____id22 = args
  local __t = ____id22[1]
  local __k7 = ____id22[2]
  local __body6 = cut(____id22, 2)
  return add(hoist, join({"%for", lower(__t, hoist), __k7, lower_body(__body6)}, props(__body6)))
end
local function lower_function(args)
  local ____id23 = args
  local __a4 = ____id23[1]
  local __body7 = cut(____id23, 1)
  return join({"%function", __a4, lower_body(__body7, true)}, props(__body7))
end
local function lower_definition(kind, args, hoist, stmt63, tail63)
  local ____id24 = args
  local __name4 = ____id24[1]
  local __args8 = ____id24[2]
  local __body8 = cut(____id24, 2)
  local __name11 = lower(__name4, hoist)
  add(hoist, join({kind, __name11, __args8, lower_body(__body8, true)}, props(__body8)))
  if not( stmt63 and not tail63) then
    return __name11
  end
end
local function lower_call(form, hoist)
  local __form3 = map(function (x)
    return lower(x, hoist)
  end, form)
  if some63(__form3) then
    return __form3
  end
end
local function lower_infix63(form)
  return _35(form) > 3 and infix63(hd(form))
end
local function infix_form(__x131)
  local ____id25 = __x131
  local __x132 = ____id25[1]
  local __a5 = ____id25[2]
  local __bs2 = cut(____id25, 2)
  local ____x133 = __bs2
  local ____i23 = 0
  while ____i23 < _35(____x133) do
    local __b5 = ____x133[____i23 + 1]
    __a5 = {__x132, __a5, __b5}
    ____i23 = ____i23 + 1
  end
  return __a5
end
local function lower_pairwise63(form)
  return _35(form) > 3 and in63(hd(form), {"<", "<=", "==", ">=", ">"})
end
local function pairwise_form(__x136)
  local ____id26 = __x136
  local __x137 = ____id26[1]
  local __a6 = ____id26[2]
  local __bs3 = cut(____id26, 2)
  local __e4 = {"and"}
  local ____x139 = __bs3
  local ____i24 = 0
  while ____i24 < _35(____x139) do
    local __b6 = ____x139[____i24 + 1]
    add(__e4, {__x137, __a6, __b6})
    __a6 = __b6
    ____i24 = ____i24 + 1
  end
  return __e4
end
local function lower_special(form, hoist)
  local __e5 = lower_call(form, hoist)
  if __e5 then
    return add(hoist, __e5)
  end
end
function _G.lower(form, hoist, stmt63, tail63)
  if atom63(form) then
    return form
  else
    if empty63(form) then
      return {"%array"}
    else
      if nil63(hoist) then
        return lower_statement(form)
      else
        if lower_pairwise63(form) then
          return lower(pairwise_form(form), hoist, stmt63, tail63)
        else
          if lower_infix63(form) then
            return lower(infix_form(form), hoist, stmt63, tail63)
          else
            local ____id27 = form
            local __x142 = ____id27[1]
            local __args9 = cut(____id27, 1)
            if __x142 == "%do" then
              return lower_do(__args9, hoist, stmt63, tail63)
            else
              if __x142 == "%call" then
                return lower(__args9, hoist, stmt63, tail63)
              else
                if __x142 == "%set" then
                  return lower_set(__args9, hoist, stmt63, tail63)
                else
                  if __x142 == "%if" then
                    return lower_if(__args9, hoist, stmt63, tail63)
                  else
                    if __x142 == "%try" then
                      return lower_try(__args9, hoist, tail63)
                    else
                      if __x142 == "%while" then
                        return lower_while(__args9, hoist)
                      else
                        if __x142 == "%for" then
                          return lower_for(__args9, hoist)
                        else
                          if __x142 == "%function" then
                            return lower_function(__args9)
                          else
                            if __x142 == "%local-function" or __x142 == "%global-function" then
                              return lower_definition(__x142, __args9, hoist, stmt63, tail63)
                            else
                              if in63(__x142, {"and", "or"}) then
                                return lower_short(__x142, __args9, hoist)
                              else
                                if statement63(__x142) then
                                  return lower_special(form, hoist)
                                else
                                  return lower_call(form, hoist)
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
        end
      end
    end
  end
end
function _G.expand(form)
  return lower(macroexpand(form))
end
local load1 = _G.loadstring or _G["load"]
local function run(code)
  local ____id28 = {load1(code)}
  local __f2 = ____id28[1]
  local __e6 = ____id28[2]
  if __f2 then
    return __f2()
  else
    return error(__e6 .. " in " .. code)
  end
end
_G._37result = nil
function _G.eval(form)
  local __previous = _G.target
  _G.target = "lua"
  local __code = compile(expand({"set", "%result", form}))
  _G.target = __previous
  run(__code)
  return _37result
end
function _G.immediate_call63(x)
  return obj63(x) and obj63(hd(x)) and hd(hd(x)) == "%function"
end
setenv("%do", {_stash = true, special = function (...)
  local __forms = unstash({...})
  local __s2 = ""
  local ____x147 = __forms
  local ____i25 = 0
  while ____i25 < _35(____x147) do
    local __x148 = ____x147[____i25 + 1]
    if _G.target == "lua" and immediate_call63(__x148) and "\n" == char(__s2, edge(__s2)) then
      __s2 = clip(__s2, 0, edge(__s2)) .. ";\n"
    end
    __s2 = __s2 .. compile(__x148, {_stash = true, stmt = true})
    if not atom63(__x148) then
      if hd(__x148) == "return" or hd(__x148) == "break" then
        break
      end
    end
    ____i25 = ____i25 + 1
  end
  return __s2
end, stmt = true, tr = true})
setenv("%if", {_stash = true, special = function (cond, cons, alt)
  local __cond1 = compile(cond)
  _G.indent_level = _G.indent_level + 1
  local ____x149 = compile(cons, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  local __cons = ____x149
  local __e38 = nil
  if alt then
    _G.indent_level = _G.indent_level + 1
    local ____x150 = compile(alt, {_stash = true, stmt = true})
    _G.indent_level = _G.indent_level - 1
    __e38 = ____x150
  end
  local __alt = __e38
  local __ind2 = indentation()
  local __s3 = ""
  if _G.target == "js" then
    __s3 = __s3 .. __ind2 .. "if (" .. __cond1 .. ") {\n" .. __cons .. __ind2 .. "}"
  else
    __s3 = __s3 .. __ind2 .. "if " .. __cond1 .. " then\n" .. __cons
  end
  if __alt and _G.target == "js" then
    __s3 = __s3 .. " else {\n" .. __alt .. __ind2 .. "}"
  else
    if __alt then
      __s3 = __s3 .. __ind2 .. "else\n" .. __alt
    end
  end
  if _G.target == "lua" then
    return __s3 .. __ind2 .. "end\n"
  else
    return __s3 .. "\n"
  end
end, stmt = true, tr = true})
setenv("%while", {_stash = true, special = function (cond, form)
  local __cond2 = compile(cond)
  _G.indent_level = _G.indent_level + 1
  local ____x151 = compile(form, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  local __body9 = ____x151
  local __ind3 = indentation()
  if _G.target == "js" then
    return __ind3 .. "while (" .. __cond2 .. ") {\n" .. __body9 .. __ind3 .. "}\n"
  else
    return __ind3 .. "while " .. __cond2 .. " do\n" .. __body9 .. __ind3 .. "end\n"
  end
end, stmt = true, tr = true})
setenv("%names", {_stash = true, special = function (...)
  local __args10 = unstash({...})
  if one63(__args10) then
    return compile(hd(__args10))
  else
    local __e39 = nil
    if _G.target == "js" then
      __e39 = "["
    else
      __e39 = ""
    end
    local __s4 = __e39
    local __c6 = ""
    local ____x153 = __args10
    local ____i26 = 0
    while ____i26 < _35(____x153) do
      local __x154 = ____x153[____i26 + 1]
      __s4 = __s4 .. __c6 .. compile(__x154)
      __c6 = ", "
      ____i26 = ____i26 + 1
    end
    local __e40 = nil
    if _G.target == "js" then
      __e40 = "]"
    else
      __e40 = ""
    end
    return __s4 .. __e40
  end
end})
setenv("%for", {_stash = true, special = function (t, k, form, ...)
  local ____r117 = unstash({...})
  local __t1 = destash33(t, ____r117)
  local __k8 = destash33(k, ____r117)
  local __form4 = destash33(form, ____r117)
  local ____id29 = ____r117
  local __await63 = ____id29.await
  local __t2 = compile(__t1)
  local __k9 = compile(__k8)
  local __ind4 = indentation()
  _G.indent_level = _G.indent_level + 1
  local ____x156 = compile(__form4, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  local __body10 = ____x156
  local __e41 = nil
  if __await63 then
    __e41 = "await "
  else
    __e41 = ""
  end
  local __a7 = __e41
  if _G.target == "lua" then
    return __ind4 .. "for " .. __k9 .. " in " .. __t2 .. " do\n" .. __body10 .. __ind4 .. "end\n"
  else
    return __ind4 .. "for " .. __a7 .. "(" .. __k9 .. " of " .. __t2 .. ") {\n" .. __body10 .. __ind4 .. "}\n"
  end
end, stmt = true, tr = true})
setenv("%try", {_stash = true, special = function (form)
  local __e7 = unique("e")
  local __ind5 = indentation()
  _G.indent_level = _G.indent_level + 1
  local ____x157 = compile(form, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  local __body11 = ____x157
  local __hf = {"return", {"%array", false, __e7}}
  _G.indent_level = _G.indent_level + 1
  local ____x160 = compile(__hf, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  local __h = ____x160
  return __ind5 .. "try {\n" .. __body11 .. __ind5 .. "}\n" .. __ind5 .. "catch (" .. __e7 .. ") {\n" .. __h .. __ind5 .. "}\n"
end, stmt = true, tr = true})
setenv("%delete", {_stash = true, special = function (place)
  return indentation() .. "delete " .. compile(place)
end, stmt = true})
setenv("break", {_stash = true, special = function ()
  return indentation() .. "break"
end, stmt = true})
setenv("%function", {_stash = true, special = function (args, ...)
  local ____r121 = unstash({...})
  local __args111 = destash33(args, ____r121)
  local ____id30 = ____r121
  local __body12 = cut(____id30, 0)
  return apply(compile_function, join({__args111}, __body12))
end})
setenv("%global-function", {_stash = true, special = function (name, args, ...)
  local ____r122 = unstash({...})
  local __name5 = destash33(name, ____r122)
  local __args121 = destash33(args, ____r122)
  local ____id31 = ____r122
  local __body13 = cut(____id31, 0)
  if _G.target == "lua" then
    local ____x165 = {__args121}
    ____x165.name = __name5
    ____x165.global = true
    local __x164 = apply(compile_function, join(____x165, __body13))
    return indentation() .. __x164
  else
    return compile({"%set", __name5, join({"%function", __args121}, __body13)}, {_stash = true, stmt = true})
  end
end, stmt = true, tr = true})
setenv("%local-function", {_stash = true, special = function (name, args, ...)
  local ____r123 = unstash({...})
  local __name6 = destash33(name, ____r123)
  local __args13 = destash33(args, ____r123)
  local ____id32 = ____r123
  local __body14 = cut(____id32, 0)
  if _G.target == "lua" then
    local ____x170 = {__args13}
    ____x170.name = __name6
    ____x170.prefix = "local"
    local __x169 = apply(compile_function, join(____x170, __body14))
    return indentation() .. __x169
  else
    return compile({"%local", __name6, join({"%function", __args13}, __body14)}, {_stash = true, stmt = true})
  end
end, stmt = true, tr = true})
setenv("return", {_stash = true, special = function (x)
  local __e42 = nil
  if nil63(x) then
    __e42 = "return"
  else
    __e42 = "return " .. compile(x)
  end
  local __x173 = __e42
  return indentation() .. __x173
end, stmt = true})
setenv("new", {_stash = true, special = function (x)
  return "new " .. compile(x)
end})
setenv("typeof", {_stash = true, special = function (x)
  return "typeof(" .. compile(x) .. ")"
end})
setenv("throw", {_stash = true, special = function (x)
  local __e43 = nil
  if _G.target == "js" then
    __e43 = "throw " .. compile(x)
  else
    __e43 = "error(" .. compile(x) .. ")"
  end
  local __e8 = __e43
  return indentation() .. __e8
end, stmt = true})
setenv("%local", {_stash = true, special = function (name, value)
  local __id33 = compile(name)
  local __value1 = compile(value)
  local __e44 = nil
  if is63(value) then
    __e44 = " = " .. __value1
  else
    __e44 = ""
  end
  local __rh11 = __e44
  local __e45 = nil
  if _G.target == "js" then
    __e45 = "var "
  else
    __e45 = "local "
  end
  local __keyword = __e45
  local __ind6 = indentation()
  return __ind6 .. __keyword .. __id33 .. __rh11
end, stmt = true})
setenv("%set", {_stash = true, special = function (lh, rh)
  local __lh2 = compile(lh)
  local __e46 = nil
  if nil63(rh) then
    __e46 = "nil"
  else
    __e46 = rh
  end
  local __rh2 = compile(__e46)
  return indentation() .. __lh2 .. " = " .. __rh2
end, stmt = true})
setenv("get", {_stash = true, special = function (t, k)
  local __t11 = compile(t)
  local __k11 = compile(k, {_stash = true, ["escape-reserved"] = false})
  if _G.target == "lua" and char(__t11, 0) == "{" or infix_operator63(t) then
    __t11 = "(" .. __t11 .. ")"
  end
  if string_literal63(k) and valid_id63(inner(k)) then
    return __t11 .. "." .. inner(k)
  else
    return __t11 .. "[" .. __k11 .. "]"
  end
end})
setenv("%array", {_stash = true, special = function (...)
  local __forms1 = unstash({...})
  local __e47 = nil
  if _G.target == "lua" then
    __e47 = "{"
  else
    __e47 = "["
  end
  local __open = __e47
  local __e48 = nil
  if _G.target == "lua" then
    __e48 = "}"
  else
    __e48 = "]"
  end
  local __close = __e48
  local __s5 = ""
  local __c7 = ""
  local ____o9 = __forms1
  local __k10 = nil
  for __k10 in pairs(____o9) do
    local __v8 = ____o9[__k10]
    if number63(__k10) then
      __s5 = __s5 .. __c7 .. compile(__v8)
      __c7 = ", "
    end
  end
  return __open .. __s5 .. __close
end})
setenv("%object", {_stash = true, special = function (...)
  local __forms2 = unstash({...})
  local __s6 = "{"
  local __c8 = ""
  local __e49 = nil
  if _G.target == "lua" then
    __e49 = " = "
  else
    __e49 = ": "
  end
  local __sep = __e49
  local ____o10 = pair(__forms2)
  local __k111 = nil
  for __k111 in pairs(____o10) do
    local __v9 = ____o10[__k111]
    if number63(__k111) then
      local ____id34 = __v9
      local __k12 = ____id34[1]
      local __v10 = ____id34[2]
      __s6 = __s6 .. __c8 .. key(__k12) .. __sep .. compile(__v10)
      __c8 = ", "
    end
  end
  return __s6 .. "}"
end})
setenv("%literal", {_stash = true, special = function (...)
  local __args14 = unstash({...})
  return apply(cat, map(unquoted, __args14))
end})
setenv("unpack", {_stash = true, special = function (x)
  if _G.target == "lua" then
    return "(unpack or table.unpack)(" .. compile(x) .. ")"
  else
    return "..." .. compile(x)
  end
end})
local __e50 = nil
if exports == nil then
  __e50 = {}
else
  __e50 = exports
end
local __exports = __e50
__exports.run = run
__exports.eval = eval
__exports.expand = expand
__exports.compile = compile
return __exports
