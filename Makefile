##############
# parameters #
##############
# do you want to show the commands executed ?
DO_MKDBG?=0
# do you want to lint all php files?
DO_PHP_LINT:=1
# should we depend on the Makefile itself?
DO_ALLDEP:=1

#############
# variables #
#############
SOURCES=$(shell find src -name "*.php")
LINT:=$(addprefix out/,$(addsuffix .lint,$(SOURCES)))
ALL:=

########
# code #
########
# silent stuff
ifeq ($(DO_MKDBG),1)
Q:=
# we are not silent in this branch
else # DO_MKDBG
Q:=@
#.SILENT:
endif # DO_MKDBG

ifeq ($(DO_PHP_LINT),1)
ALL:=$(ALL) $(LINT)
endif # DO_PHP_LINT

#########
# rules #
#########
.PHONY: all
all: $(ALL)
	@true

.PHONY: clean
clean:
	$(info doing [$@])
	$(Q)-rm -f $(ALL)

.PHONY: clean_hard
clean_hard:
	$(info doing [$@])
	$(Q)git clean -qffxd

.PHONY: debug
debug:
	$(info SOURCES is $(SOURCES))
	$(info LINT is $(LINT))
	$(info ALL is $(ALL))

############
# patterns #
############
$(LINT): out/%.lint: %
	$(info doing [$@] from [$<])
	$(Q)php -l $< > /dev/null
	$(Q)pymakehelper touch_mkdir $@

############
# all deps #
############

ifeq ($(DO_ALLDEP),1)
.EXTRA_PREREQS+=$(foreach mk, ${MAKEFILE_LIST},$(abspath ${mk}))
endif # DO_ALLDEP
