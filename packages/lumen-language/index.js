#!/usr/bin/env node
const path = require('path');
const Module = require('module').Module;
process.env.NODE_PATH = (process.env.NODE_PATH || "") + ":" + path.join(__dirname, 'bin');
Module._initPaths();
if (require.main === module) {
  module.filename = path.resolve('repl');
  module.paths = Module._nodeModulePaths(module.filename);
}
if (!global.hasOwnProperty('require')) {
  global.require = require;
}
Object.assign(exports, require(path.join(__dirname, "bin", "lumen.js")));
if (require.main === module) {
  exports.main();
}
