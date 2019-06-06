function _G.getenv(k, p)
  if string63(k) then
    local __i = edge(_G.environment)
    while __i >= 0 do
      local __b = _G.environment[__i + 1][k]
      if is63(__b) then
        local __e8 = nil
        if p then
          __e8 = __b[p]
        else
          __e8 = __b
        end
        return __e8
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
  if nil63(form) then
    return form
  else
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
        return compile(form, {_stash = true, ["escape-reserved"] = false})
      end
    end
  end
end
function _G.dequoted(x)
  if nil63(x) then
    return x
  else
    if string_literal63(x) then
      return unquoted(x)
    else
      if not string63(x) then
        return compile(x)
      else
        return x
      end
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
function _G.stash_function(args)
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
    if not( _G.target == "lua") then
      k = k - 1
    else
      k = k + 1
    end
  end
  return k
end
function _G.bind_atom(lh, rh)
  if atom63(lh) then
    return {lh, rh}
  end
end
function _G.bind_optional(lh, rh)
  if hd63(lh, "o") or hd63(lh, "or") or hd63(lh, "&optional") then
    local ____id = lh
    local ___ = ____id[1]
    local __var = ____id[2]
    local __val = ____id[3]
    return bind(__var, {"%if", {"=", rh, "nil"}, __val or "nil", rh})
  end
end
function _G.bind_destructuring(lh, rh)
  local __id1 = unique("id")
  local __bs = {__id1, rh}
  local ____o1 = lh
  local __k1 = nil
  for __k1 in pairs(____o1) do
    local __v1 = ____o1[__k1]
    local __e9 = nil
    if __k1 == "rest" then
      __e9 = {"cut", __id1, _35(lh)}
    else
      __e9 = {"get", __id1, {"quote", bias(__k1)}}
    end
    local __x7 = __e9
    __bs = join(__bs, bind(__v1, __x7))
  end
  return __bs
end
function _G.brackets63(x)
  return hd63(x, "%brackets")
end
function _G.bind_brackets(lh, rh)
  if brackets63(lh) then
    return bind(tl(lh), rh)
  end
end
function _G.dotted63(l)
  return ({["&"] = true, ["."] = true})[l[_35(l) - 2 + 1]]
end
function _G.dotted(l)
  if dotted63(l) then
    return join(cut(l, 0, _35(l) - 2), {rest = last(l)})
  end
end
function _G.bind_dotted(lh, rh)
  if dotted63(lh) then
    return bind(dotted(lh), rh)
  end
end
function _G.bind(lh, rh)
  return bind_atom(lh, rh) or bind_brackets(lh, rh) or bind_dotted(lh, rh) or bind_optional(lh, rh) or bind_destructuring(lh, rh)
end
function _G.bind_function(args, body)
  local __args1 = {}
  local __e10 = nil
  if brackets63(args) then
    __e10 = tl(args)
  else
    __e10 = args
  end
  local __args = __e10
  local __e11 = nil
  if dotted63(__args) then
    __e11 = dotted(__args)
  else
    __e11 = __args
  end
  local __args11 = __e11
  local function rest()
    __args1.rest = true
    return {"unstash", {"list", "..."}}
  end
  if atom63(__args11) then
    return {__args1, join({"let", {__args11, rest()}}, body)}
  else
    local __bs1 = {}
    local __ks = {}
    local __r29 = unique("r")
    local ____o2 = __args11
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
    if keys63(__args11) then
      __bs1 = join(__bs1, {__r29, rest()})
      local __n3 = _35(__args1)
      local __i4 = 0
      while __i4 < __n3 do
        local __v3 = __args1[__i4 + 1]
        __bs1 = join(__bs1, {__v3, {"destash!", __v3, __r29}})
        __i4 = __i4 + 1
      end
      __bs1 = join(__bs1, {__ks, __r29})
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
function _G.auto_type()
  return getenv("%%type", "type")
end
function _G.auto_value()
  if _G.target == "js" or _G.target == "lua" then
    return "nil"
  end
end
function _G.auto_local(name, value)
  local __e12 = nil
  if is63(value) then
    __e12 = value
  else
    __e12 = auto_value()
  end
  local __v4 = __e12
  local __t = auto_type()
  if is63(__t) then
    local ____x24 = {"%local", name, __v4}
    ____x24.type = __t
    return ____x24
  else
    return {"%local", name, __v4}
  end
end
local function expand_local(__x26)
  local ____id2 = __x26
  local __x27 = ____id2[1]
  local __name = ____id2[2]
  local __value = ____id2[3]
  local __type = ____id2.type
  local __args2 = cut(____id2, 3)
  local __name1 = macroexpand(__name)
  local __type1 = macroexpand(__type)
  setenv(__name1, {_stash = true, variable = true, type = __type1})
  local __prev = __type1
  add(_G.environment, {})
  local __e13 = nil
  if is63(__type1) then
    __e13 = setenv("%%type", {_stash = true, type = __type1})
  end
  local ____x28 = macroexpand(__value)
  drop(_G.environment)
  local __value1 = ____x28
  local __args3 = map(macroexpand, __args2)
  return join({__x27, __name1, __value1}, __args3)
end
local function expand_block(__x30)
  local ____id3 = __x30
  local __x31 = ____id3[1]
  local __body = cut(____id3, 1)
  add(_G.environment, {})
  local ____x32 = join({__x31}, map(macroexpand, __body))
  drop(_G.environment)
  return ____x32
end
local function expand_function(__x34)
  local ____id4 = __x34
  local __x35 = ____id4[1]
  local __args4 = ____id4[2]
  local __body1 = cut(____id4, 2)
  add(_G.environment, {})
  local ____o3 = __args4
  local ____i5 = nil
  for ____i5 in pairs(____o3) do
    local ____x36 = ____o3[____i5]
    setenv(____x36, {_stash = true, variable = true})
  end
  local ____x37 = join({__x35, __args4}, map(macroexpand, __body1))
  drop(_G.environment)
  return ____x37
end
local function expand_definition(__x39)
  local ____id5 = __x39
  local __x40 = ____id5[1]
  local __name2 = ____id5[2]
  local __args5 = ____id5[3]
  local __body2 = cut(____id5, 3)
  add(_G.environment, {})
  local ____o4 = __args5
  local ____i6 = nil
  for ____i6 in pairs(____o4) do
    local ____x41 = ____o4[____i6]
    setenv(____x41, {_stash = true, variable = true})
  end
  local ____x42 = join({__x40, macroexpand(__name2), __args5}, map(macroexpand, __body2))
  drop(_G.environment)
  return ____x42
end
local function expand_macro(form)
  return macroexpand(expand1(form))
end
function _G.expand1(__x44)
  local ____id6 = __x44
  local __name3 = ____id6[1]
  local __body3 = cut(____id6, 1)
  return apply(macro_function(__name3), __body3)
end
local function expand_transformer(form)
  return transformer_function(hd(hd(form)))(form)
end
function _G.macroexpand(form)
  if symbol63(form) then
    return macroexpand(symbol_expansion(form))
  else
    if atom63(form) then
      return form
    else
      local __x45 = hd(form)
      if __x45 == "%local" then
        return expand_local(form)
      else
        if __x45 == "%block" then
          return expand_block(form)
        else
          if __x45 == "%function" then
            return expand_function(form)
          else
            if __x45 == "%global-function" then
              return expand_definition(form)
            else
              if __x45 == "%local-function" then
                return expand_definition(form)
              else
                if macro63(__x45) then
                  return expand_macro(form)
                else
                  if hd63(__x45, transformer63) then
                    return expand_transformer(form)
                  else
                    return map(macroexpand, form)
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
  local __k3 = nil
  for __k3 in pairs(____o5) do
    local __v5 = ____o5[__k3]
    if not number63(__k3) then
      local __e14 = nil
      if quasisplice63(__v5, depth) then
        __e14 = quasiexpand(__v5[2])
      else
        __e14 = quasiexpand(__v5, depth)
      end
      local __v6 = __e14
      last(__xs)[__k3] = __v6
    end
  end
  local ____x48 = form
  local ____i8 = 0
  while ____i8 < _35(____x48) do
    local __x49 = ____x48[____i8 + 1]
    if quasisplice63(__x49, depth) then
      local __x50 = quasiexpand(__x49[2])
      add(__xs, __x50)
      add(__xs, {"list"})
    else
      add(last(__xs), quasiexpand(__x49, depth))
    end
    ____i8 = ____i8 + 1
  end
  local __pruned = keep(function(x)
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
          return map(function(x)
  return quasiexpand(x, depth)
end, form)
        end
      end
    end
  end
end
function _G.expand_if(__x54)
  local ____id7 = __x54
  local __a = ____id7[1]
  local __b1 = ____id7[2]
  local __c = cut(____id7, 2)
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
  local __i9 = 0
  while __i9 < _G.indent_level do
    __s = __s .. "  "
    __i9 = __i9 + 1
  end
  return __s
end
_G.reserved = {js = {["="] = true, ["=="] = true, ["+"] = true, ["-"] = true, ["%"] = true, ["*"] = true, ["/"] = true, ["<"] = true, [">"] = true, ["<="] = true, [">="] = true, ["break"] = true, case = true, catch = true, class = true, const = true, continue = true, debugger = true, default = true, delete = true, ["do"] = true, ["else"] = true, eval = true, finally = true, ["for"] = true, ["function"] = true, ["if"] = true, import = true, ["in"] = true, instanceof = true, let = true, new = true, ["return"] = true, switch = true, throw = true, try = true, typeof = true, var = true, void = true, with = true}, lua = {["="] = true, ["=="] = true, ["+"] = true, ["-"] = true, ["%"] = true, ["*"] = true, ["/"] = true, ["<"] = true, [">"] = true, ["<="] = true, [">="] = true, ["and"] = true, ["end"] = true, ["in"] = true, ["load"] = true, ["repeat"] = true, ["while"] = true, ["break"] = true, ["false"] = true, ["local"] = true, ["return"] = true, ["do"] = true, ["for"] = true, ["nil"] = true, ["then"] = true, ["else"] = true, ["function"] = true, ["not"] = true, ["true"] = true, ["elseif"] = true, ["if"] = true, ["or"] = true, ["until"] = true, ["goto"] = true}, c = {auto = true, ["break"] = true, case = true, const = true, continue = true, default = true, ["do"] = true, ["else"] = true, enum = true, extern = true, ["for"] = true, ["goto"] = true, ["if"] = true, inline = true, register = true, restrict = true, ["return"] = true, signed = true, sizeof = true, static = true, struct = true, switch = true, typedef = true, union = true, unsigned = true, void = true, volatile = true, ["while"] = true, _Alignas = true, _Alignof = true, _Atomic = true, _Bool = true, _Complex = true, _Generic = true, _Imaginary = true, _Noreturn = true, _Static_assert = true, _Thread_local = true}}
function _G.reserved63(x)
  return has63(_G.reserved[_G.target] or _G.reserved.js, x)
end
function _G.valid_code63(n)
  return number_code63(n) or uppercase_code63(n) or lowercase_code63(n) or n == 95 or _G.target == "c" and (n == 60 or n == 62 or n == 42 or n == 32) or _G.target == "js" and n == 36
end
function _G.global_id63(id)
  local __n7 = _35(id)
  return __n7 > 1 and char(id, __n7 - 1) == "*" and valid_code63(code(id, __n7 - 2))
end
function _G.compile_id(id, escape_reserved63)
  if global_id63(id) then
    local __e20 = nil
    if _G.target == "c" then
      __e20 = ""
    else
      __e20 = "_G."
    end
    return __e20 .. compile_id(clip(id, 0, edge(id)), escape_reserved63)
  else
    if char(id, 0) == ":" and _35(id) > 1 then
      if _G.target == "c" then
        return camel_case(clip(id, 1)) .. ":"
      else
        return "\"" .. clip(id, 1) .. "\""
      end
    else
      local __e15 = nil
      if number_code63(code(id, 0)) then
        __e15 = "_"
      else
        __e15 = ""
      end
      local __id11 = __e15
      local __i10 = 0
      while __i10 < _35(id) do
        local __c1 = char(id, __i10)
        local __n8 = code(__c1)
        local __e16 = nil
        if __c1 == "-" and not( id == "-") then
          __e16 = "_"
        else
          local __e17 = nil
          if __c1 == "/" and not( __i10 == 0) and not( __i10 == edge(id)) then
            __e17 = "___"
          else
            local __e18 = nil
            if valid_code63(__n8) then
              __e18 = __c1
            else
              local __e19 = nil
              if __i10 == 0 then
                __e19 = "_" .. __n8
              else
                __e19 = __n8
              end
              __e18 = __e19
            end
            __e17 = __e18
          end
          __e16 = __e17
        end
        local __c11 = __e16
        __id11 = __id11 .. __c11
        __i10 = __i10 + 1
      end
      if either(escape_reserved63, true) and reserved63(__id11) then
        return "_" .. __id11
      else
        return __id11
      end
    end
  end
end
function _G.valid_id63(x, escape_reserved63)
  return some63(x) and x == compile_id(x, escape_reserved63)
end
local __names = {}
function _G.unique(x)
  local __x58 = compile_id(x, true)
  if has63(__names, __x58) then
    local __i11 = __names[__x58]
    __names[__x58] = __names[__x58] + 1
    return unique(__x58 .. __i11)
  else
    __names[__x58] = 1
    return "__" .. __x58
  end
end
function _G.key(k)
  if string_literal63(k) then
    local __i12 = inner(k)
    if valid_id63(__i12) then
      return __i12
    else
      return "[" .. k .. "]"
    end
  else
    return "[" .. compile(k) .. "]"
  end
end
function _G.mapo(f, t)
  local __o6 = {}
  local ____o7 = t
  local __k4 = nil
  for __k4 in pairs(____o7) do
    local __v7 = ____o7[__k4]
    local __x59 = f(__v7)
    if is63(__x59) then
      add(__o6, literal(__k4))
      add(__o6, __x59)
    end
  end
  return __o6
end
local ____x61 = {}
local ____x63 = {}
____x63.value = "!"
____x63.space = ""
local ____x62 = {____x63}
____x62.lua = "not"
____x61["not"] = ____x62
local ____x64 = {}
local ____x66 = {}
____x66.value = "."
____x66.space = ""
____x64["."] = {____x66}
local ____x68 = {}
____x68.value = "->"
____x68.space = ""
____x64["->"] = {____x68}
local ____x69 = {}
____x69["*"] = "*"
____x69["/"] = "/"
____x69["%"] = "%"
local ____x70 = {}
local ____x71 = {"+"}
____x71.lua = ".."
____x70.cat = ____x71
local ____x72 = {}
____x72["+"] = "+"
____x72["-"] = "-"
local ____x73 = {}
____x73["<"] = "<"
____x73[">"] = ">"
____x73["<="] = "<="
____x73[">="] = ">="
local ____x74 = {}
local ____x75 = {"=="}
____x75.js = "==="
____x74["="] = ____x75
local ____x76 = {}
local ____x77 = {"&&"}
____x77.lua = "and"
____x76["and"] = ____x77
local ____x78 = {}
local ____x79 = {"||"}
____x79.lua = "or"
____x78["or"] = ____x79
_G.infix = {____x61, ____x64, ____x69, ____x70, ____x72, ____x73, ____x74, ____x76, ____x78}
local ____x81 = {}
local ____x83 = {}
____x83.value = "-"
____x83.space = " "
____x81["-"] = {____x83}
local ____x84 = {}
local ____x85 = {}
____x85.lh = "("
____x85.value = "*"
____x85.rh = ")"
____x84.c = ____x85
____x81["*"] = ____x84
local ____x87 = {}
____x87.value = "!"
____x87.space = ""
local ____x86 = {____x87}
local ____x88 = {}
____x88.value = "not"
____x88.space = " "
____x86.lua = ____x88
____x81["not"] = ____x86
_G.unary = {____x81}
local function index(k)
  if number63(k) then
    return k - 1
  end
end
function _G.precedence(form)
  if not( atom63(form) or unary63(form)) then
    local ____o8 = infix
    local __k5 = nil
    for __k5 in pairs(____o8) do
      local __v8 = ____o8[__k5]
      if __v8[hd(form)] then
        return index(__k5)
      end
    end
  end
  return 0
end
function _G.levelop(level, op, k)
  local __x89 = level[op]
  if obj63(__x89) then
    local __e21 = nil
    if has63(__x89, _G.target) then
      __e21 = __x89[_G.target]
    else
      __e21 = hd(__x89)
    end
    local __r62 = __e21
    if nil63(k) then
      return __r62
    else
      if obj63(__r62) and has63(__r62, k) then
        return __r62[k]
      else
        if string63(__r62) and k == "value" then
          return __r62
        end
      end
    end
  else
    if string63(__x89) and k == "value" then
      return __x89
    end
  end
end
function _G.getop(ops, op, k, default)
  return either(find(function(level)
  return levelop(level, op, k)
end, ops), default)
end
function _G.inop(op, k, default)
  return getop(infix, op, k, default)
end
function _G.unop(op, k, default)
  return getop(_G.unary, op, k, default)
end
function _G.infix63(x)
  return is63(inop(x, "value"))
end
function _G.unary63(form)
  return two63(form) and unop(hd(form), "value")
end
function _G.infix_operator63(x)
  return obj63(x) and infix63(hd(x))
end
function _G.compile_args(args, sep, open, close)
  local __close = either(close, ")")
  local __open = either(open, "(")
  local __sep = either(sep, ", ")
  local __c2 = ""
  local __s1 = __open
  local ____x90 = _G.indent_level
  _G.indent_level = 0
  local ____x91 = args
  local ____i15 = 0
  while ____i15 < _35(____x91) do
    local __x92 = ____x91[____i15 + 1]
    __s1 = __s1 .. __c2 .. compile(__x92)
    __c2 = __sep
    ____i15 = ____i15 + 1
  end
  local ____r71
  _G.indent_level = ____x90
  return __s1 .. __close
end
local function escape_newlines(s)
  local __s11 = ""
  local __i16 = 0
  while __i16 < _35(s) do
    local __c3 = char(s, __i16)
    local __e22 = nil
    if __c3 == "\n" then
      __e22 = "\\n"
    else
      local __e23 = nil
      if __c3 == "\r" then
        __e23 = ""
      else
        __e23 = __c3
      end
      __e22 = __e23
    end
    __s11 = __s11 .. __e22
    __i16 = __i16 + 1
  end
  return __s11
end
function _G.compile_nil(x)
  if _G.target == "lua" then
    return "nil"
  else
    if _G.target == "js" then
      return "undefined"
    else
      return "nil"
    end
  end
end
function _G.compile_boolean(x)
  if x then
    return "true"
  else
    return "false"
  end
end
function _G.compile_atom(x, escape_reserved63)
  if x == "nil" then
    return compile_nil(x)
  else
    if x == "..." then
      local __e24 = nil
      if _G.target == "js" then
        __e24 = compile("*args")
      else
        __e24 = ""
      end
      return "..." .. __e24
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
              return compile_boolean(x)
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
local function terminator(stmt63)
  if not stmt63 then
    return ""
  else
    if not( _G.target == "lua") then
      return ";\n"
    else
      return "\n"
    end
  end
end
local function compile_special(form, stmt63)
  local ____id8 = form
  local __x93 = ____id8[1]
  local __args6 = cut(____id8, 1)
  local ____id9 = getenv(__x93)
  local __special = ____id9.special
  local __stmt = ____id9.stmt
  local __self_tr63 = ____id9.tr
  local __tr = terminator(stmt63 and not __self_tr63)
  local __e25 = nil
  if stmt63 and not __self_tr63 then
    __e25 = indentation()
  else
    __e25 = ""
  end
  local __ind = __e25
  if form.ephemeral then
    return ""
  else
    return __ind .. apply(__special, __args6) .. __tr
  end
end
function _G.accessor_literal63(x)
  return string63(x) and (char(x, 0) == "." and not( char(x, 1) == ".") and some63(char(x, 1)) or char(x, 0) == "-" and char(x, 1) == ">" and some63(char(x, 2)))
end
function _G.accessor_form63(x)
  return obj63(x) and accessor_literal63(last(x))
end
function _G.accessor_prefix(x, dot)
  if _G.target == "c" and char(x, 0) == "-" then
    return "->"
  else
    return dot
  end
end
function _G.accessor_suffix(x)
  local __e26 = nil
  if char(x, 0) == "." then
    __e26 = 1
  else
    __e26 = 2
  end
  return clip(x, __e26)
end
function _G.accessor_literal(x)
  return compile(camel_case(accessor_suffix(x)), {_stash = true, ["escape-reserved"] = false})
end
function _G.compile_method(f, args, chain63)
  if chain63 and none63(args) then
    return f
  else
    local __x94 = hd(args)
    if accessor_literal63(__x94) then
      return compile_method(f .. accessor_prefix(__x94, ".") .. accessor_literal(__x94), tl(args), true)
    else
      if hd63(__x94, accessor_literal63) then
        local __e27 = nil
        if _G.target == "lua" then
          __e27 = ":"
        else
          __e27 = "."
        end
        return compile_method(f .. accessor_prefix(hd(__x94), __e27) .. accessor_literal(hd(__x94)) .. compile_args(tl(__x94)), tl(args), true)
      else
        return f .. compile_args(args)
      end
    end
  end
end
local function parenthesize_call63(x)
  return not atom63(x) and hd(x) == "%function" or precedence(x) > 0
end
function _G.compile_call(form, ...)
  local ____r85 = unstash({...})
  local __form = destash33(form, ____r85)
  local ____id10 = ____r85
  local __no_stash63 = ____id10["no-stash"]
  local __f = hd(__form)
  local __f1 = compile(__f)
  local __args7 = tl(__form)
  local __e28 = nil
  if __no_stash63 then
    __e28 = __args7
  else
    __e28 = stash_function(__args7)
  end
  local __args12 = compile_method("", __e28)
  if parenthesize_call63(__f) then
    return "(" .. __f1 .. ")" .. __args12
  else
    return __f1 .. __args12
  end
end
local function op_delims(parent, child, right63)
  local __e29 = nil
  if right63 then
    __e29 = _6261
  else
    __e29 = _62
  end
  if __e29(precedence(child), precedence(parent)) then
    return {"(", ")"}
  else
    return {"", ""}
  end
end
local function compile_infix(form)
  local ____id111 = form
  local __op = ____id111[1]
  local ____id12 = cut(____id111, 1)
  local __a1 = ____id12[1]
  local __b2 = ____id12[2]
  local ____id13 = op_delims(form, __a1, false)
  local __ao = ____id13[1]
  local __ac = ____id13[2]
  local ____id14 = op_delims(form, __b2, true)
  local __bo = ____id14[1]
  local __bc = ____id14[2]
  local __a2 = compile(__a1)
  local __b3 = compile(__b2)
  local __e30 = nil
  if unary63(form) then
    __e30 = _G.unary
  else
    __e30 = infix
  end
  local __ops = __e30
  local __x98 = hd(form)
  local __op1 = getop(__ops, __x98, "value")
  local __lh = getop(__ops, __x98, "lh", "")
  local __rh = getop(__ops, __x98, "rh", "")
  local __e31 = nil
  if __ops == _G.unary then
    __e31 = ""
  else
    __e31 = " "
  end
  local __sp = getop(__ops, __x98, "space", __e31)
  if __ops == _G.unary then
    return __lh .. __op1 .. __ao .. __sp .. __a2 .. __ac .. __rh
  else
    return __lh .. __ao .. __a2 .. __ac .. __sp .. __op1 .. __sp .. __bo .. __b3 .. __bc .. __rh
  end
end
function _G.compile_function(args, body, ...)
  local ____r88 = unstash({...})
  local __args8 = destash33(args, ____r88)
  local __body4 = destash33(body, ____r88)
  local ____id15 = ____r88
  local __name4 = ____id15.name
  local __prefix = ____id15.prefix
  local __infix = ____id15.infix
  local __global63 = ____id15.global
  local __async63 = ____id15.async
  local __keyword = ____id15.keyword
  local __generator63 = ____id15.generator
  local __e32 = nil
  if __name4 then
    __e32 = compile(__name4)
  else
    __e32 = ""
  end
  local __id16 = __e32
  local __e33 = nil
  if __global63 and not( _G.target == "c") then
    __e33 = "_G." .. __id16
  else
    __e33 = __id16
  end
  local __id17 = __e33
  local __e34 = nil
  if __args8.rest then
    __e34 = join(__args8, {"..."})
  else
    __e34 = __args8
  end
  local __args13 = __e34
  local __args9 = compile_args(__args13)
  _G.indent_level = _G.indent_level + 1
  local ____x101 = compile(__body4, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  local __body5 = ____x101
  local __ind1 = indentation()
  local __e35 = nil
  if __prefix then
    __e35 = __prefix .. " "
  else
    __e35 = ""
  end
  local __p = __e35
  local __e36 = nil
  if __generator63 then
    __e36 = ""
  else
    local __e37 = nil
    if __infix then
      __e37 = " " .. __infix
    else
      __e37 = ""
    end
    __e36 = __e37
  end
  local __m = __e36
  local __e38 = nil
  if not( _G.target == "lua") then
    __e38 = ""
  else
    __e38 = "end"
  end
  local __tr1 = __e38
  local __e39 = nil
  if __async63 then
    __e39 = "async "
  else
    __e39 = ""
  end
  local __async1 = __e39
  local __e40 = nil
  if __generator63 and _G.target == "js" then
    __e40 = "function*"
  else
    __e40 = "function"
  end
  local __func = either(unquoted(__keyword), __e40)
  local __e41 = nil
  if some63(__id17) then
    __e41 = " "
  else
    __e41 = ""
  end
  local __c4 = __e41
  if __name4 then
    __tr1 = __tr1 .. "\n"
  end
  if not( _G.target == "lua") then
    return __async1 .. __func .. __c4 .. __id17 .. __args9 .. __m .. " {\n" .. __body5 .. __ind1 .. "}" .. __tr1
  else
    return __p .. __func .. __c4 .. __id17 .. __args9 .. __m .. "\n" .. __body5 .. __ind1 .. __tr1
  end
end
local function can_return63(form)
  return is63(form) and (atom63(form) or not( hd(form) == "%return") and not statement63(hd(form)))
end
function _G.compile(form, ...)
  local ____r90 = unstash({...})
  local __form1 = destash33(form, ____r90)
  local ____id18 = ____r90
  local __stmt1 = ____id18.stmt
  local __esc63 = ____id18["escape-reserved"]
  if nil63(__form1) then
    return ""
  else
    if special_form63(__form1) then
      return compile_special(__form1, __stmt1)
    else
      local __tr2 = terminator(__stmt1)
      local __e42 = nil
      if __stmt1 then
        __e42 = indentation()
      else
        __e42 = ""
      end
      local __ind2 = __e42
      local __e43 = nil
      if atom63(__form1) then
        __e43 = compile_atom(__form1, either(__esc63, true))
      else
        local __e44 = nil
        if infix63(hd(__form1)) then
          __e44 = compile_infix(__form1)
        else
          __e44 = compile_call(__form1)
        end
        __e43 = __e44
      end
      local __form2 = __e43
      return __ind2 .. __form2 .. __tr2
    end
  end
end
function _G.lower_statement(form, tail63)
  local __hoist = {}
  local __e = lower(form, __hoist, true, tail63)
  if is63(__e) then
    add(__hoist, __e)
  end
  return join({"%do"}, __hoist)
end
function _G.lower_body(body, tail63)
  add(_G.environment, {})
  local ____x104 = lower_statement(join({"%do"}, body), tail63)
  drop(_G.environment)
  return ____x104
end
function _G.lower_block(body, tail63)
  return join({"%block", lower_body(body)}, props(body))
end
local function literal63(form)
  return atom63(form) or hd(form) == "%array" or hd(form) == "%object"
end
local function standalone63(form)
  return not atom63(form) and not infix63(hd(form)) and not literal63(form) and not( "get" == hd(form)) and not accessor_form63(form) or id_literal63(form)
end
local function lower_do(args, hoist, stmt63, tail63)
  local ____x107 = almost(args)
  local ____i17 = 0
  while ____i17 < _35(____x107) do
    local __x108 = ____x107[____i17 + 1]
    local ____y = lower(__x108, hoist, stmt63)
    if yes(____y) then
      local __e1 = ____y
      if standalone63(__e1) then
        add(hoist, __e1)
      end
    end
    ____i17 = ____i17 + 1
  end
  local __e2 = lower(last(args), hoist, stmt63, tail63)
  if tail63 and can_return63(__e2) then
    return {"%return", __e2}
  else
    return __e2
  end
end
local function lower_set(args, hoist, stmt63, tail63)
  local ____id19 = args
  local __lh1 = ____id19[1]
  local __rh1 = ____id19[2]
  local __lh11 = lower(__lh1, hoist)
  local __rh11 = lower(__rh1, hoist)
  add(hoist, {"%set", __lh11, __rh11})
  if not( stmt63 and not tail63) then
    return __lh11
  end
end
local function lower_if(args, hoist, stmt63, tail63)
  local ____id20 = args
  local __cond = ____id20[1]
  local ___then = ____id20[2]
  local ___else = ____id20[3]
  if stmt63 then
    local __e46 = nil
    if is63(___else) then
      __e46 = {lower_body({___else}, tail63)}
    end
    return add(hoist, join({"%if", lower(__cond, hoist), lower_body({___then}, tail63)}, __e46))
  else
    local __e3 = unique("e")
    add(hoist, auto_local(__e3, "nil"))
    local __e45 = nil
    if is63(___else) then
      __e45 = {lower({"%set", __e3, ___else})}
    end
    add(hoist, join({"%if", lower(__cond, hoist), lower({"%set", __e3, ___then})}, __e45))
    return __e3
  end
end
local function lower_short(x, args, hoist, stmt63, tail63)
  if none63(args) then
    if x == "and" then
      return true
    else
      return false
    end
  else
    if one63(args) then
      return hd(args)
    else
      local ____id21 = args
      local __a3 = ____id21[1]
      local __b4 = ____id21[2]
      local __hoist1 = {}
      local __b11 = lower(__b4, __hoist1)
      if some63(__hoist1) then
        local __id22 = unique("id")
        local __e47 = nil
        if x == "and" then
          __e47 = {"%if", __id22, __b4, __id22}
        else
          __e47 = {"%if", __id22, __id22, __b4}
        end
        return lower({"%do", auto_local(__id22, __a3), __e47}, hoist)
      else
        return {x, lower(__a3, hoist), __b11}
      end
    end
  end
end
local function lower_try(args, hoist, tail63)
  return add(hoist, {"%try", lower_body(args, tail63)})
end
local function lower_while(args, hoist)
  local ____id23 = args
  local __c5 = ____id23[1]
  local __body6 = cut(____id23, 1)
  local __pre = {}
  local __c6 = lower(__c5, __pre)
  local __e48 = nil
  if none63(__pre) then
    __e48 = {"%while", __c6, lower_body(__body6)}
  else
    __e48 = {"%while", true, join({"%do"}, __pre, {{"%if", {"not", __c6}, {"break"}}, lower_body(__body6)})}
  end
  return add(hoist, __e48)
end
local function lower_for(args, hoist)
  local ____id24 = args
  local __t1 = ____id24[1]
  local __k6 = ____id24[2]
  local __body7 = cut(____id24, 2)
  return add(hoist, join({"%for", lower(__t1, hoist), __k6, lower_body(__body7)}, props(__body7)))
end
local function lower_function(args)
  local ____id25 = args
  local __a4 = ____id25[1]
  local __body8 = cut(____id25, 1)
  return join({"%function", __a4, lower_body(__body8, true)}, props(__body8))
end
local function lower_definition(kind, args, hoist, stmt63, tail63)
  local ____id26 = args
  local __name5 = ____id26[1]
  local __args10 = ____id26[2]
  local __body9 = cut(____id26, 2)
  local __name11 = lower(__name5, hoist)
  add(hoist, join({kind, __name11, __args10, lower_body(__body9, true)}, props(__body9)))
  if not( stmt63 and not tail63) then
    return __name11
  end
end
function _G.lower_local(form, hoist, stmt63, tail63)
  local ____id27 = form
  local __kind = ____id27[1]
  local __name6 = ____id27[2]
  local __value2 = ____id27[3]
  local __ephemeral63 = ____id27.ephemeral
  local __type2 = ____id27.type
  local __args111 = cut(____id27, 3)
  local __name12 = lower(__name6, hoist)
  local __type11 = lower(__type2, hoist)
  local __form11 = join({__kind, __name12, __value2}, __args111)
  add(_G.environment, {})
  local __e49 = nil
  if is63(__type11) then
    __form11.type = __type11
    __e49 = setenv("%%type", {_stash = true, type = __type11})
  end
  local __e50 = nil
  if __ephemeral63 then
    __e50 = lower(__value2, hoist, stmt63, tail63)
  else
    lower_special(__form11, hoist, stmt63, tail63)
    local __e51 = nil
    if not( stmt63 and not tail63) then
      __e51 = __name12
    end
    __e50 = __e51
  end
  local ____x135 = __e50
  drop(_G.environment)
  local __r106 = ____x135
  if not __ephemeral63 then
    setenv(__name12, {_stash = true, variable = true, type = __type11})
  end
  return __r106
end
function _G.lower_call(form, hoist)
  local __form3 = map(function(x)
  return lower(x, hoist)
end, form)
  if some63(__form3) then
    return __form3
  end
end
local function lower_infix63(form)
  return _35(form) > 3 and infix63(hd(form))
end
local function infix_form(__x136)
  local ____id28 = __x136
  local __x137 = ____id28[1]
  local __a5 = ____id28[2]
  local __bs2 = cut(____id28, 2)
  local ____x138 = __bs2
  local ____i18 = 0
  while ____i18 < _35(____x138) do
    local __b5 = ____x138[____i18 + 1]
    __a5 = {__x137, __a5, __b5}
    ____i18 = ____i18 + 1
  end
  return __a5
end
local function lower_pairwise63(form)
  return _35(form) > 3 and in63(hd(form), {"<", "<=", "=", ">=", ">"})
end
local function pairwise_form(__x141)
  local ____id29 = __x141
  local __x142 = ____id29[1]
  local __a6 = ____id29[2]
  local __bs3 = cut(____id29, 2)
  local __e4 = {"and"}
  local ____x144 = __bs3
  local ____i19 = 0
  while ____i19 < _35(____x144) do
    local __b6 = ____x144[____i19 + 1]
    add(__e4, {__x142, __a6, __b6})
    __a6 = __b6
    ____i19 = ____i19 + 1
  end
  return __e4
end
function _G.lower_special(form, hoist, stmt63, tail63)
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
            local ____id30 = form
            local __x147 = ____id30[1]
            local __args121 = cut(____id30, 1)
            if __x147 == "%do" then
              return lower_do(__args121, hoist, stmt63, tail63)
            else
              if __x147 == "%block" then
                return lower_block(__args121, tail63)
              else
                if __x147 == "%call" then
                  return lower(__args121, hoist, stmt63, tail63)
                else
                  if __x147 == "%set" then
                    return lower_set(__args121, hoist, stmt63, tail63)
                  else
                    if __x147 == "%if" then
                      return lower_if(__args121, hoist, stmt63, tail63)
                    else
                      if __x147 == "%try" then
                        return lower_try(__args121, hoist, tail63)
                      else
                        if __x147 == "%while" then
                          return lower_while(__args121, hoist)
                        else
                          if __x147 == "%for" then
                            return lower_for(__args121, hoist)
                          else
                            if __x147 == "%function" then
                              return lower_function(__args121)
                            else
                              if __x147 == "%local-function" or __x147 == "%global-function" then
                                return lower_definition(__x147, __args121, hoist, stmt63, tail63)
                              else
                                if __x147 == "%local" then
                                  return lower_local(form, hoist, stmt63, tail63)
                                else
                                  if in63(__x147, {"and", "or"}) then
                                    return lower_short(__x147, __args121, hoist, stmt63, tail63)
                                  else
                                    if statement63(__x147) then
                                      return lower_special(form, hoist, stmt63, tail63)
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
  end
end
function _G.expand(form)
  return lower(macroexpand(form))
end
local load1 = _G.loadstring or _G["load"]
local function run(code)
  local ____id31 = {load1(code)}
  local __f11 = ____id31[1]
  local __e6 = ____id31[2]
  if __f11 then
    return __f11()
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
setenv("%do", {_stash = true, special = function(...)
  local __forms = unstash({...})
  local __s2 = ""
  local ____x152 = __forms
  local ____i20 = 0
  while ____i20 < _35(____x152) do
    local __x153 = ____x152[____i20 + 1]
    if _G.target == "lua" and immediate_call63(__x153) and "\n" == char(__s2, edge(__s2)) then
      __s2 = clip(__s2, 0, edge(__s2)) .. ";\n"
    end
    __s2 = __s2 .. compile(__x153, {_stash = true, stmt = true})
    if not atom63(__x153) then
      if hd(__x153) == "%return" or hd(__x153) == "%break" or hd(__x153) == "%continue" then
        break
      end
    end
    ____i20 = ____i20 + 1
  end
  return __s2
end, stmt = true, tr = true})
setenv("%brackets", {_stash = true, special = function(...)
  local __forms1 = unstash({...})
  if _G.target == "c" then
    return compile_args(__forms1, " ", "[", "]")
  else
    return compile(join({"%array"}, __forms1))
  end
end})
setenv("%braces", {_stash = true, special = function(...)
  local __forms2 = unstash({...})
  return compile(join({"%object"}, __forms2))
end})
setenv("%block", {_stash = true, special = function(...)
  local ____r119 = unstash({...})
  local ____id32 = ____r119
  local __prefix1 = ____id32.prefix
  local __forms3 = cut(____id32, 0)
  local __e52 = nil
  if is63(__prefix1) then
    __e52 = trim(compile(__prefix1, {_stash = true, stmt = true}), testify_of({[";"] = true, [" "] = true, ["\n"] = true})) .. " "
  else
    __e52 = ""
  end
  local __p1 = __e52
  local __s3 = indentation() .. __p1 .. "{\n"
  _G.indent_level = _G.indent_level + 1
  local ____x160 = __forms3
  local ____i21 = 0
  while ____i21 < _35(____x160) do
    local __x161 = ____x160[____i21 + 1]
    __s3 = __s3 .. compile(__x161, {_stash = true, stmt = true})
    ____i21 = ____i21 + 1
  end
  local ____x159
  _G.indent_level = _G.indent_level - 1
  __s3 = __s3 .. indentation() .. "}\n"
  return __s3
end, stmt = true, tr = true})
setenv("%if", {_stash = true, special = function(cond, cons, alt)
  local __cond1 = compile(cond)
  _G.indent_level = _G.indent_level + 1
  local ____x162 = compile(cons, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  local __cons = ____x162
  local __e53 = nil
  if alt then
    _G.indent_level = _G.indent_level + 1
    local ____x163 = compile(alt, {_stash = true, stmt = true})
    _G.indent_level = _G.indent_level - 1
    __e53 = ____x163
  end
  local __alt = __e53
  local __ind3 = indentation()
  local __s4 = ""
  if not( _G.target == "lua") then
    __s4 = __s4 .. __ind3 .. "if (" .. __cond1 .. ") {\n" .. __cons .. __ind3 .. "}"
  else
    __s4 = __s4 .. __ind3 .. "if " .. __cond1 .. " then\n" .. __cons
  end
  if __alt and not( _G.target == "lua") then
    __s4 = __s4 .. " else {\n" .. __alt .. __ind3 .. "}"
  else
    if __alt then
      __s4 = __s4 .. __ind3 .. "else\n" .. __alt
    end
  end
  if _G.target == "lua" then
    return __s4 .. __ind3 .. "end\n"
  else
    return __s4 .. "\n"
  end
end, stmt = true, tr = true})
setenv("%while", {_stash = true, special = function(cond, form)
  local __cond2 = compile(cond)
  _G.indent_level = _G.indent_level + 1
  local ____x164 = compile(form, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  local __body10 = ____x164
  local __ind4 = indentation()
  if not( _G.target == "lua") then
    return __ind4 .. "while (" .. __cond2 .. ") {\n" .. __body10 .. __ind4 .. "}\n"
  else
    return __ind4 .. "while " .. __cond2 .. " do\n" .. __body10 .. __ind4 .. "end\n"
  end
end, stmt = true, tr = true})
setenv("%names", {_stash = true, special = function(...)
  local __args131 = unstash({...})
  if one63(__args131) then
    return compile(hd(__args131))
  else
    local __e54 = nil
    if not( _G.target == "lua") then
      __e54 = "["
    else
      __e54 = ""
    end
    local __s5 = __e54
    local __c7 = ""
    local ____x166 = __args131
    local ____i22 = 0
    while ____i22 < _35(____x166) do
      local __x167 = ____x166[____i22 + 1]
      __s5 = __s5 .. __c7 .. compile(__x167)
      __c7 = ", "
      ____i22 = ____i22 + 1
    end
    local __e55 = nil
    if not( _G.target == "lua") then
      __e55 = "]"
    else
      __e55 = ""
    end
    return __s5 .. __e55
  end
end})
setenv("%for", {_stash = true, special = function(t, k, form, ...)
  local ____r122 = unstash({...})
  local __t2 = destash33(t, ____r122)
  local __k7 = destash33(k, ____r122)
  local __form4 = destash33(form, ____r122)
  local ____id33 = ____r122
  local __await63 = ____id33.await
  local __t3 = compile(__t2)
  local __k8 = compile(__k7)
  local __ind5 = indentation()
  _G.indent_level = _G.indent_level + 1
  local ____x169 = compile(__form4, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  local __body11 = ____x169
  local __e56 = nil
  if __await63 then
    __e56 = "await "
  else
    __e56 = ""
  end
  local __a7 = __e56
  if _G.target == "lua" then
    return __ind5 .. "for " .. __k8 .. " in " .. __t3 .. " do\n" .. __body11 .. __ind5 .. "end\n"
  else
    return __ind5 .. "for " .. __a7 .. "(" .. __k8 .. " of " .. __t3 .. ") {\n" .. __body11 .. __ind5 .. "}\n"
  end
end, stmt = true, tr = true})
setenv("%try", {_stash = true, special = function(form)
  local __e7 = unique("e")
  local __ind6 = indentation()
  _G.indent_level = _G.indent_level + 1
  local ____x170 = compile(form, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  local __body12 = ____x170
  local __hf = {"%return", {"%array", false, __e7}}
  _G.indent_level = _G.indent_level + 1
  local ____x173 = compile(__hf, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  local __h = ____x173
  return __ind6 .. "try {\n" .. __body12 .. __ind6 .. "}\n" .. __ind6 .. "catch (" .. __e7 .. ") {\n" .. __h .. __ind6 .. "}\n"
end, stmt = true, tr = true})
setenv("%delete", {_stash = true, special = function(place)
  return "delete " .. compile(place)
end, stmt = true})
setenv("%break", {_stash = true, special = function()
  return "break"
end, stmt = true})
setenv("%continue", {_stash = true, special = function()
  return "continue"
end, stmt = true})
setenv("%function", {_stash = true, special = function(args, ...)
  local ____r127 = unstash({...})
  local __args14 = destash33(args, ____r127)
  local ____id34 = ____r127
  local __arrow63 = ____id34.arrow
  local __type3 = ____id34.type
  local __body13 = cut(____id34, 0)
  if _G.target == "js" and __arrow63 then
    local ____x175 = {__args14}
    ____x175.keyword = ""
    ____x175.infix = "=>"
    return apply(compile_function, join(____x175, __body13))
  else
    if _G.target == "c" then
      local ____x176 = {__args14}
      ____x176.keyword = __type3
      return apply(compile_function, join(____x176, __body13))
    else
      return apply(compile_function, join({__args14}, __body13))
    end
  end
end})
setenv("%global-function", {_stash = true, special = function(name, args, ...)
  local ____r128 = unstash({...})
  local __name7 = destash33(name, ____r128)
  local __args15 = destash33(args, ____r128)
  local ____id35 = ____r128
  local __type4 = ____id35.type
  local __body14 = cut(____id35, 0)
  if not( _G.target == "js") then
    local ____x180 = {__args15}
    ____x180.name = __name7
    local __e57 = nil
    if _G.target == "c" then
      __e57 = __type4
    end
    ____x180.keyword = __e57
    ____x180.global = true
    local __x179 = apply(compile_function, join(____x180, __body14))
    return indentation() .. __x179
  else
    return compile({"%set", __name7, join({"%function", __args15}, __body14)}, {_stash = true, stmt = true})
  end
end, stmt = true, tr = true})
setenv("%local-function", {_stash = true, special = function(name, args, ...)
  local ____r129 = unstash({...})
  local __name8 = destash33(name, ____r129)
  local __args16 = destash33(args, ____r129)
  local ____id36 = ____r129
  local __type5 = ____id36.type
  local __body15 = cut(____id36, 0)
  if not( _G.target == "js") then
    local ____x185 = {__args16}
    ____x185.name = __name8
    local __e58 = nil
    if _G.target == "c" then
      __e58 = __type5
    end
    ____x185.keyword = __e58
    local __e59 = nil
    if _G.target == "lua" then
      __e59 = "local"
    end
    ____x185.prefix = __e59
    local __x184 = apply(compile_function, join(____x185, __body15))
    return indentation() .. __x184
  else
    return compile({"%local", __name8, join({"%function", __args16}, __body15)}, {_stash = true, stmt = true})
  end
end, stmt = true, tr = true})
setenv("%return", {_stash = true, special = function(x)
  if nil63(x) then
    return "return"
  else
    return "return " .. compile(x)
  end
end, stmt = true})
setenv("new", {_stash = true, special = function(x, count)
  local __e60 = nil
  if obj63(x) then
    __e60 = x
  else
    __e60 = {x}
  end
  local ____id37 = __e60
  local __type6 = ____id37[1]
  local __args17 = cut(____id37, 1)
  local __t4 = dequoted(__type6)
  if nil63(count) then
    return "new " .. __t4 .. compile_args(__args17)
  else
    return "new " .. __t4 .. "[" .. compile(count) .. "]"
  end
end})
setenv("typeof", {_stash = true, special = function(x)
  return "typeof(" .. compile(x) .. ")"
end})
setenv("throw", {_stash = true, special = function(x)
  if _G.target == "js" then
    return "throw " .. compile(x)
  else
    return "error(" .. compile(x) .. ")"
  end
end, stmt = true})
function _G.default_value63(value, type)
  return _G.target == "c" and value == "nil"
end
setenv("%local", {_stash = true, special = function(name, value, ...)
  local ____r135 = unstash({...})
  local __name9 = destash33(name, ____r135)
  local __value3 = destash33(value, ____r135)
  local ____id38 = ____r135
  local __type7 = ____id38.type
  local __id39 = compile(__name9)
  local __type12 = dequoted(__type7)
  local __e61 = nil
  if default_value63(__value3, __type12) then
    __e61 = nil
  else
    __e61 = __value3
  end
  local __value4 = __e61
  local __value11 = compile(__value4)
  local __e62 = nil
  if is63(__value4) then
    __e62 = " = " .. __value11
  else
    __e62 = ""
  end
  local __rh2 = __e62
  local __e63 = nil
  if _G.target == "c" then
    __e63 = either(__type12, "auto")
  else
    local __e64 = nil
    if _G.target == "lua" then
      __e64 = "local"
    else
      __e64 = "var"
    end
    __e63 = __e64
  end
  local __keyword1 = __e63
  return __keyword1 .. " " .. __id39 .. __rh2
end, stmt = true})
setenv("%set", {_stash = true, special = function(lh, rh)
  local __lh2 = compile(lh)
  local __e65 = nil
  if nil63(rh) then
    __e65 = "nil"
  else
    __e65 = rh
  end
  local __rh3 = compile(__e65)
  return __lh2 .. " = " .. __rh3
end, stmt = true})
setenv("get", {_stash = true, special = function(t, k)
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
setenv("%array", {_stash = true, special = function(...)
  local __forms4 = unstash({...})
  local __e66 = nil
  if _G.target == "lua" then
    __e66 = "{"
  else
    __e66 = "["
  end
  local __open1 = __e66
  local __e67 = nil
  if _G.target == "lua" then
    __e67 = "}"
  else
    __e67 = "]"
  end
  local __close1 = __e67
  local __s6 = ""
  local __c8 = ""
  local ____o9 = __forms4
  local __k9 = nil
  for __k9 in pairs(____o9) do
    local __v9 = ____o9[__k9]
    if number63(__k9) then
      __s6 = __s6 .. __c8 .. compile(__v9)
      __c8 = ", "
    end
  end
  return __open1 .. __s6 .. __close1
end})
setenv("%object", {_stash = true, special = function(...)
  local __forms5 = unstash({...})
  local __s7 = "{"
  local __c9 = ""
  local __e68 = nil
  if _G.target == "lua" then
    __e68 = " = "
  else
    __e68 = ": "
  end
  local __sep1 = __e68
  local ____o10 = pair(__forms5)
  local __k10 = nil
  for __k10 in pairs(____o10) do
    local __v10 = ____o10[__k10]
    if number63(__k10) then
      local ____id40 = __v10
      local __k111 = ____id40[1]
      local __v11 = ____id40[2]
      __s7 = __s7 .. __c9 .. key(__k111) .. __sep1 .. compile(__v11)
      __c9 = ", "
    end
  end
  return __s7 .. "}"
end})
setenv("%literal", {_stash = true, special = function(...)
  local __args18 = unstash({...})
  return apply(cat, map(unquoted, __args18))
end})
setenv("%stmt", {_stash = true, special = function(...)
  local __args19 = unstash({...})
  local __s8 = indentation()
  local ____x194 = __args19
  local ____i25 = 0
  while ____i25 < _35(____x194) do
    local __x195 = ____x194[____i25 + 1]
    __s8 = __s8 .. unquoted(__x195)
    ____i25 = ____i25 + 1
  end
  __s8 = __s8 .. "\n"
  return __s8
end, stmt = true, tr = true})
setenv("unpack", {_stash = true, special = function(x)
  if _G.target == "lua" then
    return "(unpack or table.unpack)(" .. compile(x) .. ")"
  else
    return "..." .. compile(x)
  end
end})
setenv("%@", {_stash = true, special = function(x)
  return "@" .. compile(x)
end})
setenv("%newline", {_stash = true, special = function()
  return "\n"
end, stmt = true, tr = true})
setenv("%indent", {_stash = true, special = function(x)
  _G.indent_level = _G.indent_level + 1
  local ____x196 = compile(x, {_stash = true, stmt = true})
  _G.indent_level = _G.indent_level - 1
  return ____x196
end, stmt = true, tr = true})
local __e69 = nil
if exports == nil then
  __e69 = {}
else
  __e69 = exports
end
local __exports = __e69
__exports.run = run
__exports.eval = eval
__exports.expand = expand
__exports.compile = compile
return __exports
