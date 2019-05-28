#!/usr/bin/env ./bin/lumen-node

(define-global main ((project-path (o type 'SKEmitterNode) (o framework)))
 (set target* 'c)
 (load (cat project-path "/lib.ll"))
 (if framework
     (test-parse-properties type framework)
     (test-parse-properties type)))

(export main)
