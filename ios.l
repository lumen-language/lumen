#!/usr/bin/env ./bin/lumen-node

(define-global main ((project-path (o type 'SKEmitterNode)))
 (set target* 'c)
 (load (cat project-path "/lib.ll"))
 (test-parse-properties type))

(export main)
