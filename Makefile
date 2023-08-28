IMAGE_NAME 		:= spyro2-build:latest
DOCKER 			:= docker
CURRENT_DIR 	:= $(shell pwd)
MAKE 			:= make
DECOMP_SUFFIX 	:= _decomp
ISODUMP_DIR 	:= isodump

.PHONY: all

all: dirs container_and_build

dirs:
	mkdir -p build

# Build the docker image. Will rebuild if Dockerfile changes.
image_creation.timestamp: Dockerfile
	docker build -t $(IMAGE_NAME) .
	touch $@

# Run docker container. Will build image if image_creation_timestamp is not present or is older than Dockerfile.
container_and_build: image_creation.timestamp
	docker run --rm -it -v $(CURRENT_DIR):/spyro2 -w /spyro2 $(IMAGE_NAME) bash -c "$(MAKE) build/spyro2$(DECOMP_SUFFIX).bin && bash"

container: image_creation.timestamp
	docker run --rm -it -v $(CURRENT_DIR):/spyro2 -w /spyro2 $(IMAGE_NAME)

$(ISODUMP_DIR): spyro2.bin
	dumpsxiso spyro2.bin -x ./$(ISODUMP_DIR) -s ./$(ISODUMP_DIR)/spyro2.xml
	cp $(ISODUMP_DIR)/spyro2.xml $(ISODUMP_DIR)/spyro2$(DECOMP_SUFFIX).xml
	sed -i 's/source="SCUS_944.25"/source="SCUS_944.25$(DECOMP_SUFFIX)"/g' $(ISODUMP_DIR)/spyro2$(DECOMP_SUFFIX).xml

game/basegame/SCUS_944.25: $(ISODUMP_DIR)
	cp $(ISODUMP_DIR)/SCUS_944.25 game/basegame

game/split.timestamp: game/basegame/SCUS_944.25
	$(MAKE) -C game split_all

game/basegame/build/SCUS_944.25: game/split.timestamp
	$(MAKE) -C game

build/spyro2$(DECOMP_SUFFIX).bin: game/basegame/build/SCUS_944.25
	cp game/basegame/build/SCUS_944.25 $(ISODUMP_DIR)/SCUS_944.25$(DECOMP_SUFFIX)
	mkpsxiso $(ISODUMP_DIR)/spyro2$(DECOMP_SUFFIX).xml -o build/spyro2$(DECOMP_SUFFIX).bin -c build/spyro2$(DECOMP_SUFFIX).cue

# build/spyro2_orig_rebuild.bin: build/iso/spyro2.xml
# 	mkpsxiso build/iso/spyro2.xml -o build/spyro2_orig_rebuild.bin -c build/spyro2_orig_rebuild.cue

# build/spyro2$(DECOMP_SUFFIX).ok: build/spyro2$(DECOMP_SUFFIX).bin build/spyro2_orig_rebuild.bin
# 	sha1sum build/spyro2$(DECOMP_SUFFIX).bin | cut -d' ' -f1 > build/spyro2$(DECOMP_SUFFIX).sha1
# 	sha1sum build/spyro2_orig_rebuild.bin | cut -d' ' -f1 > build/spyro2_orig_rebuild.sha1
# 	cmp build/spyro2$(DECOMP_SUFFIX).sha1 build/spyro2_orig_rebuild.sha1
# 	touch $@

clean:
	rm -rf build
	rm -rf game/basegame/SCUS_944.25
	$(MAKE) -C game clean