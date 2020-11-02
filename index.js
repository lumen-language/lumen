#!/usr/bin/env node
var _G = (typeof _G !== "undefined") ? _G
  : (typeof global !== "undefined") ? global
  : (typeof window !== "undefined") ? window
  : (typeof self !== "undefined") ? self : this;

_G._G = _G;

const path = require('path');
process.env.NODE_PATH = (process.env.NODE_PATH || "") + path.delimiter + path.join(__dirname, 'bin');
if (require.main === module) {
  module.paths = require('module').Module._nodeModulePaths(path.resolve('repl'));
}
require('module').Module._initPaths();
_G.require = require;

_G.ustring = (_G.ustring || {})
_G.ustring.new = x => [...x]

_G.require.extensions['.l'] = function (module, filename) {
  const source = _G.compile_file(filename)
  // const filename2 = filename.replace(/[.]l$/, '') + '.js'
  // _G.fs.writeFileSync(filename2, source)
  // module.exports = _G.require(filename2)
  // return module
  return module._compile(source, filename);
}

Object.assign(exports, require("./bin/lumen.js"));
if (require.main === module) {
  exports.main(process.argv.slice(2));
}
