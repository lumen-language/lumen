
var bcrypt;
var crypto = require('crypto');

function hashpw(passphrase, rounds=16, salt=crypto.randomBytes(rounds)) {
  // > require('../utils').opensshCipherInfo('aes128-ctr')
  var cinf = { keySize: 16, blockSize: 16, opensslName: 'aes-128-ctr' };

  if (bcrypt === undefined) {
    bcrypt = require('bcrypt-pbkdf');
  }
  var pass = new Uint8Array([...passphrase].map(x => x.charCodeAt(0)));
  var salti = new Uint8Array(salt);
  /* Use the pbkdf to derive both the key and the IV. */
  var out = new Uint8Array(cinf.keySize + cinf.blockSize);
  var res = bcrypt.pbkdf(pass, pass.length, salti, salti.length,
    out, out.length, rounds);
  if (res !== 0) {
    throw (new Error('bcrypt_pbkdf function returned ' +
      'failure, parameters invalid'));
  }
  out = Buffer.from(out);
  return rounds + ":" + salt.toString('hex') + ":" + out.toString('hex');
}
exports.hashpw = hashpw;

function fromhash(x) {
  var [rounds, salt, h] = x.split(":");
  return {rounds: parseInt(rounds),
    salt: Buffer.from(salt, "hex"),
    hash: Buffer.from(h, "hex")};
  // if (r.rounds === 16 && salt.length === 16 && hash.length === 32) {
  //   return r;
  // }
}
exports.parse = fromhash;

function readpw(passphrase, x) {
  var h = fromhash(x);
  return hashpw(passphrase, h.rounds, h.salt);
}
exports.readpw = readpw;

function checkpw(pass, check) {
  if (check == null) {
    return hashpw(pass);
  }
  return check === readpw(pass, check);
}
exports.checkpw = checkpw;

