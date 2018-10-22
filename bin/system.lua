local __dirname = "/code/ref/lumen-language/2018-10-21/lumen3"
local function call_with_file(f, path, mode)
  local ____id = {io.open(path, mode)}
  local __h = ____id[1]
  local __e = ____id[2]
  if not __h then
    error(__e)
  end
  local __x1 = f(__h)
  __h.close(__h)
  return __x1
end
local function read_file(path)
  return call_with_file(function (f)
    return f.read(f, "*a")
  end, path)
end
local function write_file(path, data)
  return call_with_file(function (f)
    return f.write(f, data)
  end, path, "w")
end
local function file_exists63(path)
  local __f = io.open(path)
  local __id2 = is63(__f)
  local __e1 = nil
  if __id2 then
    local __r6 = is63(__f.read(__f, 0)) or 0 == __f.seek(__f, "end")
    __f.close(__f)
    __e1 = __r6
  else
    __e1 = __id2
  end
  return __e1
end
local function directory_exists63(path)
  local __f1 = io.open(path)
  local __id3 = is63(__f1)
  local __e2 = nil
  if __id3 then
    local __r8 = not __f1.read(__f1, 0) and not( 0 == __f1.seek(__f1, "end"))
    __f1.close(__f1)
    __e2 = __r8
  else
    __e2 = __id3
  end
  return __e2
end
local path_separator = char(_G.package.config, 0)
local function path_join(a, ...)
  return reduce(function (x, y)
    return x .. path_separator .. y
  end, {...}, a)
end
local function get_environment_variable(name)
  return os.getenv(name)
end
local function stdout()
  return (process or io).stdout
end
local function stderr()
  return (process or io).stderr
end
local function write(x, out)
  return (out or stdout()):write(x)
end
local function exit(code)
  return os.exit(code)
end
local argv = nil
function _G.set_argv(l)
  argv = l
  return argv
end
function _G.get_argv()
  if nil63(argv) then
    set_argv(_G.arg or _G.args or {})
  end
  return argv
end
local function opt63(x)
  return string63(x) and char(x, 0) == "-" and not( x == "-")
end
function _G.parse_positional(args, pos)
  return cut(args, either(pos, 0), first(opt63, args, pos))
end
function _G.parse_option(args)
  if opt63(hd(args)) then
    return {hd(args), parse_positional(args, 1)}
  end
end
function _G.parse_arguments(aliases, argv)
  local __l = argv or get_argv()
  local __a = aliases or {}
  local __r22 = parse_positional(__l)
  __l = cut(__l, _35(__r22))
  while true do
    local __p = parse_option(__l)
    if not __p then
      break
    end
    local ____y = __p
    if yes(____y) then
      local ____id1 = ____y
      local __o = ____id1[1]
      local __args = ____id1[2]
      if __o == "--" then
        __l = cut(__l, 1)
        break
      end
      __l = cut(__l, 1 + _35(__args))
      local __e3 = nil
      if clip(__o, 0, 2) == "--" then
        __e3 = clip(__o, 2)
      else
        __e3 = clip(__o, 1)
      end
      local __k = __e3
      local __k1 = __a[__k] or __k
      local __e4 = nil
      if none63(__args) then
        __e4 = true
      else
        __e4 = __args
      end
      local __v = __e4
      __r22[__k1] = __v
      add(__r22, {__k1, __v})
    end
  end
  __r22.rest = __l
  set_argv(__r22.rest)
  return __r22
end
function _G.arguments(aliases, argv)
  local __argv = argv or get_argv()
  local __r24 = parse_arguments(__argv, aliases)
  set_argv(__r24.rest)
  __r24.rest = nil
  if not empty63(__r24) then
    return __r24
  end
end
local function reload(module)
  package.loaded[module] = nil
  return require(module)
end
function _G.shell(command)
  local __f2 = io.popen(command)
  local __x5 = __f2.read(__f2, "*all")
  __f2.close(__f2)
  local __s = __x5
  if char(__s, edge(__s)) == "\n" then
    __s = clip(__s, 0, edge(__s))
  end
  if char(__s, edge(__s)) == "\r" then
    __s = clip(__s, 0, edge(__s))
  end
  return __s
end
function _G.rand_string(n)
  local __n = 2 * (n or 16)
  local __s1 = ""
  while _35(__s1) < __n do
    __s1 = __s1 .. shell("cat /dev/urandom | xxd -l 64 -c 64 -ps")
  end
  return clip(__s1, 0, __n)
end
local __e5 = nil
if exports == nil then
  __e5 = {}
else
  __e5 = exports
end
local __exports = __e5
__exports.readFile = read_file
__exports.writeFile = write_file
__exports.fileExists63 = file_exists63
__exports.directoryExists63 = directory_exists63
__exports.pathSeparator = path_separator
__exports.pathJoin = path_join
__exports.getEnvironmentVariable = get_environment_variable
__exports.stdout = stdout
__exports.stderr = stderr
__exports.write = write
__exports.exit = exit
__exports.getArgv = get_argv
__exports.setArgv = set_argv
__exports.arguments = arguments
__exports.reload = reload
__exports.shell = shell
return __exports
