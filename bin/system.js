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
var path_join = function (..._42args) {
  var __parts = unstash([..._42args]);
  return reduce(function (x, y) {
    return x + path_separator + y;
  }, __parts) || "";
};
var get_environment_variable = function (name) {
  return process.env[name];
};
var stdout = function () {
  return process.stdout;
};
var stderr = function () {
  return process.stderr;
};
var write = function (x, out) {
  var __out = out || stdout();
  __out.write(x);
  return undefined;
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
opt63 = function (x) {
  return string63(x) && char(x, 0) === "-";
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
  var __r16 = parse_positional(__l);
  __l = cut(__l, _35(__r16));
  while (true) {
    var __p = parse_option(__l);
    if (! __p) {
      break;
    }
    var ____y = __p;
    if (yes(____y)) {
      var ____id = ____y;
      var __o = ____id[0];
      var __args = ____id[1];
      if (__o === "--") {
        __l = cut(__l, 1);
        break;
      }
      __l = cut(__l, 1 + _35(__args));
      var __e = undefined;
      if (clip(__o, 0, 2) === "--") {
        __e = clip(__o, 2);
      } else {
        __e = clip(__o, 1);
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
      __r16[__k1] = __v;
      add(__r16, [__k1, __v]);
    }
  }
  __r16.rest = __l;
  set_argv(__r16.rest);
  return __r16;
};
arguments = function (aliases, argv) {
  var __argv = argv || get_argv();
  var __r18 = parse_arguments(__argv, aliases);
  set_argv(__r18.rest);
  delete __r18.rest;
  if (! empty63(__r18)) {
    return __r18;
  }
};
var reload = function (module) {
  delete require.cache[require.resolve(module)];
  return require(module);
};
var run = function (command) {
  return child_process.execSync(command).toString();
};
exports["read-file"] = read_file;
exports["write-file"] = write_file;
exports["file-exists?"] = file_exists63;
exports["directory-exists?"] = directory_exists63;
exports["path-separator"] = path_separator;
exports["path-join"] = path_join;
exports["get-environment-variable"] = get_environment_variable;
exports.stdout = stdout;
exports.stderr = stderr;
exports.write = write;
exports.exit = exit;
exports["get-argv"] = get_argv;
exports["set-argv"] = set_argv;
exports.arguments = arguments;
exports.reload = reload;
exports.run = run;
