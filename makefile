.PHONY: all rebuild bundle clean test

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

all: $(MODS:.x=.js) $(MODS:.x=.lua) $(BINS)

rebuild:
	@make clean
	@LUMEN_HOST=node make -B
	@make test

bootstrap:
	@bin/lumen-luvi -e nil

bundle:
	@npx luvit-luvi . -o bin/lumen-language

clean:
	@git checkout $(MODS:.x=.js) $(MODS:.x=.lua)
	@rm -f obj/* $(BINS)

bin/lumen-language: $(MODS:.x=.js) $(MODS:.x=.lua) init.lua main.lua package.json index.js
	@rm -f $(BINS)

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
	@mkdir -p obj
	@$(LUMEN) -c $< -o $@ -t js

obj/%.lua : %.l
	@echo "  $@"
	@mkdir -p obj
	@$(LUMEN) -c $< -o $@ -t lua

bin/%.js : %.l
	@echo $@
	@$(LUMEN) -c $< -o $@ -t js

bin/%.lua : %.l
	@echo $@
	@$(LUMEN) -c $< -o $@ -t lua

test: all bootstrap
	@echo js:
	@LUMEN_HOST=$(LUMEN_NODE) ./test.l
	@echo lua:
	@LUMEN_HOST=$(LUMEN_LUA) ./test.l
	@echo luvi:
	@LUMEN_HOST=$(LUMEN_LUVI) ./test.l
