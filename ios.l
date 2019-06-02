#!/usr/bin/env ./bin/lumen-node

(define-global main ((project-path (o type 'SKEmitterNode) (o framework) (o subframework)))
 (set target* 'c)
 (load (cat project-path "/lib.ll"))
 (if subframework
     (test-parse-properties type framework subframework)
     framework
     (test-parse-properties type framework)
     (test-parse-properties type)))

(export main)
