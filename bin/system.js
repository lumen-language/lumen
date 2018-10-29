var fs = require("fs");
var child_process = require("child_process");
var read_file = function (path) {
  return fs.readFileSync(path, "utf8");
};
var write_file = function (path, data) {
  return fs.writeFileSync(path, data, "utf8");
};
var file_exists63 = function (path) {
  return fs.existsSync(path, "utf8") && fs.statSync(path).isFile();
};
var directory_exists63 = function (path) {
  return fs.existsSync(path, "utf8") && fs.statSync(path).isDirectory();
};
var path_separator = require("path").sep;
var path_join = function (a, ..._42args) {
  return reduce(function (x, y) {
    return x + path_separator + y;
  }, [..._42args], a);
};
var get_environment_variable = function (name) {
  return process.env[name];
};
var stdout = function () {
  return (process || io).stdout;
};
var stderr = function () {
  return (process || io).stderr;
};
var write = function (x, out) {
  return (out || stdout()).write(x);
};
var exit = function (code) {
  return process.exit(code);
};
var argv = undefined;
set_argv = function (l) {
  argv = l;
  return argv;
};
get_argv = function () {
  if (nil63(argv)) {
    set_argv(cut(process.argv, 2));
  }
  return argv;
};
var opt63 = function (x) {
  return string63(x) && char(x, 0) === "-" && !( x === "-");
};
parse_positional = function (args, pos) {
  return cut(args, either(pos, 0), first(opt63, args, pos));
};
parse_option = function (args) {
  if (opt63(hd(args))) {
    return [hd(args), parse_positional(args, 1)];
  }
};
parse_arguments = function (aliases, argv) {
  var __l = argv || get_argv();
  var __a = aliases || {};
  var __r17 = parse_positional(__l);
  __l = cut(__l, _35(__r17));
  while (true) {
    var __p = parse_option(__l);
    if (! __p) {
      break;
    }
    var ____y = __p;
    if (yes(____y)) {
      var ____id = ____y;
      var __op = ____id[0];
      var __args = ____id[1];
      if (__op === "--") {
        __l = cut(__l, 1);
        break;
      }
      __l = cut(__l, 1 + _35(__args));
      var __e = undefined;
      if (clip(__op, 0, 2) === "--") {
        __e = clip(__op, 2);
      } else {
        __e = clip(__op, 1);
      }
      var __k = __e;
      var __k1 = __a[__k] || __k;
      var __e1 = undefined;
      if (none63(__args)) {
        __e1 = true;
      } else {
        __e1 = __args;
      }
      var __v = __e1;
      __r17[__k1] = __v;
      add(__r17, [__k1, __v]);
    }
  }
  __r17.rest = __l;
  set_argv(__r17.rest);
  return __r17;
};
arguments = function (aliases, argv) {
  var __argv = argv || get_argv();
  var __r19 = parse_arguments(__argv, aliases);
  set_argv(__r19.rest);
  delete __r19.rest;
  if (! empty63(__r19)) {
    return __r19;
  }
};
var reload = function (module) {
  delete require.cache[require.resolve(module)];
  return require(module);
};
var run = function (command) {
  return child_process.execSync(command).toString();
};
var __e2 = undefined;
if (typeof(exports) === "undefined") {
  __e2 = {};
} else {
  __e2 = exports;
}
var __exports = __e2;
__exports.readFile = read_file;
__exports.writeFile = write_file;
__exports.fileExists63 = file_exists63;
__exports.directoryExists63 = directory_exists63;
__exports.pathSeparator = path_separator;
__exports.pathJoin = path_join;
__exports.getEnvironmentVariable = get_environment_variable;
__exports.stdout = stdout;
__exports.stderr = stderr;
__exports.write = write;
__exports.exit = exit;
__exports.getArgv = get_argv;
__exports.setArgv = set_argv;
__exports.arguments = arguments;
__exports.reload = reload;
__exports.run = run;
__exports;
