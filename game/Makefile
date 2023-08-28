MAKE := make

OVERLAY_TARGETS := ovr0_title_and_loading

.PHONY: basegame $(OVERLAY_TARGETS) split_basegame clean all split_all

all: $(OVERLAY_TARGETS) basegame
split_all: split_$(OVERLAY_TARGETS) split_basegame

$(OVERLAY_TARGETS): 
	$(MAKE) $@/build/$@.wad

$(OVERLAY_TARGETS)/build/$(OVERLAY_TARGETS).wad:
	$(MAKE) -f build.mk SUBDIR=$(basename $(notdir $@)) SPYRO2_BASENAME=$(notdir $@)

split_$(OVERLAY_TARGETS): 
	$(MAKE) -f build.mk SUBDIR=$(basename $(notdir $(patsubst split_%,%,$@))) SPYRO2_BASENAME=$(notdir $(patsubst split_%,%,$@)).wad split

split_basegame: 
	$(MAKE) -f build.mk SUBDIR=basegame SPYRO2_BASENAME=SCUS_944.25 split

basegame: basegame/build/SCUS_944.25

basegame/build/SCUS_944.25:
	$(MAKE) -f build.mk SUBDIR=basegame SPYRO2_BASENAME=SCUS_944.25

# recursively delete all build/, assets/, asm/ directories. also deleted all *.timestamp files, all *.ld files, all *_auto.* files
clean:
	find . -name "build" -type d -exec rm -rf {} +
	find . -name "assets" -type d -exec rm -rf {} +
	find . -name "asm" -type d -exec rm -rf {} +
	find . -name "*.timestamp" -type f -exec rm -f {} +
	find . -name "*.ld" -type f -exec rm -f {} +
	find . -name "*_auto.*" -type f -exec rm -f {} +