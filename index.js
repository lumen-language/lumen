#!/usr/bin/env node
const path = require('path');
process.env.NODE_PATH = (process.env.NODE_PATH || "") + path.delimiter + path.join(__dirname, 'bin');
if (require.main === module) {
  module.paths = require('module').Module._nodeModulePaths(path.resolve('repl'));
}
require('module').Module._initPaths();
global.require = require;
Object.assign(exports, require("./bin/lumen.js"));
if (require.main === module) {
  exports.main(exports.system.getArgv());
}
