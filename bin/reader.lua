local delimiters = {["("] = true, [")"] = true, ["["] = true, ["]"] = true, ["{"] = true, ["}"] = true, [";"] = true, ["\r"] = true, ["\n"] = true}
local whitespace = {[" "] = true, ["\t"] = true, ["\r"] = true, ["\n"] = true}
local function stream(str, more)
  return {pos = 0, string = str, len = _35(str), more = more}
end
local function peek_char(s)
  local ____id = s
  local __pos = ____id.pos
  local __len = ____id.len
  local __str = ____id.string
  if __pos < __len then
    return char(__str, __pos)
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
  end
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
  local __e = nil
  if code(str, 0) == 45 then
    __e = 1
  else
    __e = 0
  end
  local __i = __e
  local __id2 = code(str, __i) == 48
  local __e1 = nil
  if __id2 then
    __i = __i + 1
    local __n = code(str, __i)
    __e1 = __n == 120 or __n == 88
  else
    __e1 = __id2
  end
  return __e1
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
read_table[""] = function (s)
  local __str1 = ""
  while true do
    local __c3 = peek_char(s)
    if __c3 and (not whitespace[__c3] and not delimiters[__c3]) then
      __str1 = __str1 .. read_char(s)
    else
      break
    end
  end
  if __str1 == "true" then
    return true
  else
    if __str1 == "false" then
      return false
    else
      local __n1 = maybe_number(__str1)
      if real63(__n1) then
        return __n1
      else
        return __str1
      end
    end
  end
end
read_table["("] = function (s)
  read_char(s)
  local __r15 = nil
  local __l1 = {}
  while nil63(__r15) do
    skip_non_code(s)
    local __c4 = peek_char(s)
    if __c4 == ")" then
      read_char(s)
      __r15 = __l1
    else
      if nil63(__c4) then
        __r15 = expected(s, ")")
      else
        local __x1 = read(s)
        if key63(__x1) then
          local __k = clip(__x1, 0, edge(__x1))
          local __v = read(s)
          __l1[__k] = __v
        else
          add(__l1, __x1)
        end
      end
    end
  end
  return __r15
end
read_table[")"] = function (s)
  return error("Unexpected ) at " .. s.pos)
end
read_table["["] = function (s)
  read_char(s)
  local __r18 = nil
  local __l2 = {"%brackets"}
  local __n2 = 1
  while nil63(__r18) do
    skip_non_code(s)
    local __c5 = peek_char(s)
    if __c5 == "]" then
      read_char(s)
      __r18 = __l2
    else
      if nil63(__c5) then
        __r18 = expected(s, "]")
      else
        local __x3 = read(s)
        __l2[__n2 + 1] = __x3
        __n2 = __n2 + 1
      end
    end
  end
  return __r18
end
read_table["]"] = function (s)
  return error("Unexpected ] at " .. s.pos)
end
read_table["{"] = function (s)
  read_char(s)
  local __r21 = nil
  local __l3 = {"%braces"}
  local __n3 = 1
  while nil63(__r21) do
    skip_non_code(s)
    local __c6 = peek_char(s)
    if __c6 == "}" then
      read_char(s)
      __r21 = __l3
    else
      if nil63(__c6) then
        __r21 = expected(s, "}")
      else
        local __x5 = read(s)
        __l3[__n3 + 1] = __x5
        __n3 = __n3 + 1
      end
    end
  end
  return __r21
end
read_table["}"] = function (s)
  return error("Unexpected } at " .. s.pos)
end
read_table["\""] = function (s)
  read_char(s)
  local __r24 = nil
  local __str2 = "\""
  while nil63(__r24) do
    local __c7 = peek_char(s)
    if __c7 == "\"" then
      __r24 = __str2 .. read_char(s)
    else
      if nil63(__c7) then
        __r24 = expected(s, "\"")
      else
        if __c7 == "\\" then
          __str2 = __str2 .. read_char(s)
        end
        __str2 = __str2 .. read_char(s)
      end
    end
  end
  return __r24
end
read_table["|"] = function (s)
  read_char(s)
  local __r26 = nil
  local __str3 = "|"
  while nil63(__r26) do
    local __c8 = peek_char(s)
    if __c8 == "|" then
      __r26 = __str3 .. read_char(s)
    else
      if nil63(__c8) then
        __r26 = expected(s, "|")
      else
        __str3 = __str3 .. read_char(s)
      end
    end
  end
  return __r26
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
local __e2 = nil
if exports == nil then
  __e2 = {}
else
  __e2 = exports
end
local __exports = __e2
__exports.stream = stream
__exports.read = read
__exports.readAll = read_all
__exports.readString = read_string
__exports.readTable = read_table
return __exports
