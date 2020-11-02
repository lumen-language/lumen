local delimiters = {["("] = true, [")"] = true, ["["] = true, ["]"] = true, ["{"] = true, ["}"] = true, [";"] = true, ["\r"] = true, ["\n"] = true}
local whitespace = {[" "] = true, ["\t"] = true, ["\r"] = true, ["\n"] = true}
local function stream(str, more)
  return {pos = 0, string = str, len = _35(str), more = more}
end
local function peek_char(s, __x)
  local __e = nil
  if __x == nil then
    __e = 0
  else
    __e = __x
  end
  local __i = __e
  local ____id = s
  local __pos = ____id.pos
  local __len = ____id.len
  local __str = ____id.string
  if __pos + __i < __len then
    return char(__str, __pos + __i)
  end
end
local function read_char(s)
  local __c = peek_char(s)
  if __c then
    s.pos = s.pos + 1
    return __c
  end
end
local function skip_non_code(s)
  local __any63 = nil
  while true do
    local __c1 = peek_char(s)
    if nil63(__c1) then
      break
    else
      if whitespace[__c1] then
        read_char(s)
      else
        if __c1 == ";" then
          while __c1 and not( __c1 == "\n") do
            __c1 = read_char(s)
          end
          skip_non_code(s)
        else
          break
        end
      end
    end
    __any63 = true
  end
  return __any63
end
local read_table = {}
local function read(s, eof)
  skip_non_code(s)
  local __c2 = peek_char(s)
  if is63(__c2) then
    return (read_table[__c2] or read_table[""])(s)
  else
    return eof
  end
end
local function read_all(s)
  local __l = {}
  local __eof = {}
  while true do
    local __form = read(s, __eof)
    if __form == __eof then
      break
    end
    add(__l, __form)
  end
  return __l
end
function _G.read_string(str, more)
  return read(stream(str, more))
end
local function key63(atom)
  return string63(atom) and _35(atom) > 1 and char(atom, edge(atom)) == ":"
end
local function expected(s, c)
  local ____id1 = s
  local __more = ____id1.more
  local __pos1 = ____id1.pos
  return __more or error("Expected " .. c .. " at " .. __pos1)
end
local function wrap(s, x)
  local __y = read(s)
  if __y == s.more then
    return __y
  else
    return {x, __y}
  end
end
local function hex_prefix63(str)
  local __e1 = nil
  if code(str, 0) == 45 then
    __e1 = 1
  else
    __e1 = 0
  end
  local __i1 = __e1
  local __id2 = code(str, __i1) == 48
  local __e2 = nil
  if __id2 then
    __i1 = __i1 + 1
    local __n = code(str, __i1)
    __e2 = __n == 120 or __n == 88
  else
    __e2 = __id2
  end
  return __e2
end
local function maybe_number(str)
  if hex_prefix63(str) then
    return tonumber(str)
  else
    if number_code63(code(str, edge(str))) then
      return number(str)
    end
  end
end
local function real63(x)
  return number63(x) and not nan63(x) and not inf63(x)
end
local function valid_access63(str)
  return _35(str) > 2 and not( "." == char(str, 0)) and not( "." == char(str, edge(str))) and nil63(search(str, ".."))
end
local function parse_index(a, b)
  print(str({"parse-index", a, b}))
  if nil63(a) then
    return "." .. b
  else
    local __n1 = number(a)
    if nil63(__n1) then
      return {"get", b, quoted(a)}
    else
      return {"at", b, __n1}
    end
  end
end
local function parse_access(x, prev)
  print(str({"parse-access", x, prev}))
  return parse_index(x, prev)
end
local function read_atom(s, __x6)
  local __e3 = nil
  if __x6 == nil then
    __e3 = false
  else
    __e3 = __x6
  end
  local __basic63 = __e3
  local __str1 = ""
  while true do
    local __c3 = peek_char(s)
    if __c3 == "\\" then
      __str1 = __str1 .. read_char(s) .. read_char(s)
    else
      if __c3 and (not whitespace[__c3] and not delimiters[__c3]) then
        __str1 = __str1 .. read_char(s)
      else
        break
      end
    end
  end
  if __str1 == "true" then
    return true
  else
    if __str1 == "false" then
      return false
    else
      if __basic63 then
        return s
      else
        local __n2 = maybe_number(__str1)
        if real63(__n2) then
          return __n2
        else
          return __str1
        end
      end
    end
  end
end
local function read_list(s, ending)
  read_char(s)
  local __r18 = nil
  local __l1 = {}
  while nil63(__r18) do
    skip_non_code(s)
    local __c4 = peek_char(s)
    if __c4 == ending then
      read_char(s)
      __r18 = __l1
    else
      if nil63(__c4) then
        __r18 = expected(s, ending)
      else
        local __x7 = read(s)
        if key63(__x7) then
          local __k = clip(__x7, 0, edge(__x7))
          local __v = read(s)
          __l1[__k] = __v
        else
          add(__l1, __x7)
        end
      end
    end
  end
  return __r18
end
local function read_next(s, prev, ws63, eof)
  return prev
end
read_table[""] = function (s)
  return read_next(s, read_atom(s))
end
read_table["("] = function (s)
  return read_next(s, read_list(s, ")"))
end
read_table[")"] = function (s)
  return error("Unexpected ) at " .. s.pos)
end
read_table["["] = function (s)
  read_char(s)
  local __r24 = nil
  local __l2 = {{"%brackets"}}
  while nil63(__r24) do
    skip_non_code(s)
    local __c5 = peek_char(s)
    if __c5 == "]" then
      read_char(s)
      __r24 = __l2
    else
      if nil63(__c5) then
        __r24 = expected(s, "]")
      else
        local __x14 = read(s)
        add(__l2, __x14)
      end
    end
  end
  return __r24
end
read_table["]"] = function (s)
  return error("Unexpected ] at " .. s.pos)
end
read_table["{"] = function (s)
  read_char(s)
  local __r27 = nil
  local __l3 = {{"%braces"}}
  while nil63(__r27) do
    skip_non_code(s)
    local __c6 = peek_char(s)
    if __c6 == "}" then
      read_char(s)
      __r27 = __l3
    else
      if nil63(__c6) then
        __r27 = expected(s, "}")
      else
        local __x17 = read(s)
        add(__l3, __x17)
      end
    end
  end
  return __r27
end
read_table["}"] = function (s)
  return error("Unexpected } at " .. s.pos)
end
read_table["\""] = function (s)
  read_char(s)
  local __r30 = nil
  local __str2 = "\""
  while nil63(__r30) do
    local __c7 = peek_char(s)
    if __c7 == "\"" then
      __r30 = __str2 .. read_char(s)
    else
      if nil63(__c7) then
        __r30 = expected(s, "\"")
      else
        if __c7 == "\\" then
          __str2 = __str2 .. read_char(s)
        end
        __str2 = __str2 .. read_char(s)
      end
    end
  end
  return __r30
end
read_table["|"] = function (s)
  read_char(s)
  local __r32 = nil
  local __str3 = "|"
  while nil63(__r32) do
    local __c8 = read_char(s)
    if nil63(__c8) then
      __r32 = expected(s, "|")
    else
      if __c8 == "|" then
        if peek_char(s) == "|" then
          __str3 = __str3 .. read_char(s)
        else
          __r32 = __str3 .. __c8
        end
      else
        __str3 = __str3 .. __c8
      end
    end
  end
  return __r32
end
read_table["'"] = function (s)
  read_char(s)
  return wrap(s, "quote")
end
read_table["`"] = function (s)
  read_char(s)
  return wrap(s, "quasiquote")
end
read_table[","] = function (s)
  read_char(s)
  if peek_char(s) == "@" then
    read_char(s)
    return wrap(s, "unquote-splicing")
  else
    return wrap(s, "unquote")
  end
end
read_table["~"] = function (s)
  read_char(s)
  return wrap(s, "complement")
end
local __e4 = nil
if exports == nil then
  __e4 = {}
else
  __e4 = exports
end
local __exports = __e4
__exports.stream = stream
__exports.read = read
__exports.readAll = read_all
__exports.readString = read_string
__exports.readTable = read_table
return __exports
