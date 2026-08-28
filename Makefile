.PHONY: build clean keymap

KEYMAP_DRAWER_VERSION := 0.23.0

build:
	mkdir -p build
	builds=$$(yq -r '.include[] | "build " + .board + " " + .shield + " \"" + (.snippet // "") + "\" \"" + (.["cmake-args"] // "") + "\" \"" + (.["artifact-name"] // "") + "\";"' build.yaml) && \
	docker run \
		--rm \
		--user "$(shell id -u):$(shell id -g)" \
		--env HOME=/tmp \
		--volume "$(CURDIR):/config:ro" \
		--volume "$(CURDIR)/build:/build" \
		--workdir /build \
		docker.io/zmkfirmware/zmk-build-arm:stable \
		sh -lc 'set -eu; \
			mkdir -p workspace artifacts; \
			if [ ! -d workspace/.west ]; then west init -l /config/config workspace; fi; \
			cd workspace; \
			west update --fetch-opt=--filter=tree:0; \
			west zephyr-export; \
			build() { \
				board="$$1"; \
				shield="$$2"; \
				snippet="$$3"; \
				cmake_args="$$4"; \
				artifact_name="$$5"; \
				rm -rf "build/$$shield"; \
				set --; \
				if [ -n "$$snippet" ]; then set -- "$$@" -S "$$snippet"; fi; \
				west build -s zmk/app -d "build/$$shield" -b "$$board" "$$@" -- -DZMK_CONFIG=/config/config -DSHIELD="$$shield" -DZMK_EXTRA_MODULES=/config $$cmake_args; \
				if [ -z "$$artifact_name" ]; then artifact_name="$$shield-$$board-zmk"; fi; \
				cp "build/$$shield/zephyr/zmk.uf2" "/build/artifacts/$$artifact_name.uf2"; \
			}; \
			'"$$builds"

keymap:
	mkdir -p assets build/keymap-drawer
	uvx --from keymap-drawer==$(KEYMAP_DRAWER_VERSION) keymap \
		-c keymap_drawer.config.yaml parse \
		-z config/sofle.keymap \
		-o build/keymap-drawer/sofle.yaml
	uvx --from keymap-drawer==$(KEYMAP_DRAWER_VERSION) keymap \
		-c keymap_drawer.config.yaml draw \
		build/keymap-drawer/sofle.yaml \
		-o assets/sofle.svg

clean:
	rm -rf build
