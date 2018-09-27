.PHONY: all bundle clean test

LUMEN_LUA  ?= lua
LUMEN_NODE ?= node
LUMEN_HOST ?= $(LUMEN_LUA)

LUMEN := LUMEN_HOST="$(LUMEN_HOST)" bin/lumen

OBJS :=	obj/runtime.o	\
	obj/macros.o	\
	obj/main.o

MODS := bin/lumen.x	\
	bin/reader.x	\
	bin/compiler.x	\
	bin/system.x

BINS := bin/lumen-language

all: $(MODS:.x=.js) $(MODS:.x=.lua)

bundle: all $(BINS) init.lua main.lua package.json index.js
	@echo luvi:
	@bin/lumen-luvi ./test.l

bin/lumen-language: all
	@npx luvit-luvi . -o bin/lumen-language

clean:
	@git checkout $(MODS:.x=.js) $(MODS:.x=.lua)
	@rm -f obj/* $(BINS)

bin/lumen.js: $(OBJS:.o=.js)
	@echo $@
	@cat $^ > $@.tmp
	@mv $@.tmp $@

bin/lumen.lua: $(OBJS:.o=.lua)
	@echo $@
	@cat $^ > $@.tmp
	@mv $@.tmp $@

obj/%.js : %.l
	@echo "  $@"
	@$(LUMEN) -c $< -o $@ -t js

obj/%.lua : %.l
	@echo "  $@"
	@$(LUMEN) -c $< -o $@ -t lua

bin/%.js : %.l
	@echo $@
	@$(LUMEN) -c $< -o $@ -t js

bin/%.lua : %.l
	@echo $@
	@$(LUMEN) -c $< -o $@ -t lua

test: all
	@echo js:
	@LUMEN_HOST=$(LUMEN_NODE) ./test.l
	@echo lua:
	@LUMEN_HOST=$(LUMEN_LUA) ./test.l
