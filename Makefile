.PHONY: build clean shell help left right

# Build both left and right firmware
build: left right

# Build left side firmware
left:
	@echo "Building left side firmware..."
	@mkdir -p firmware
	docker run --rm -v "$(PWD)/config":/config-local -v "$(PWD)/firmware":/firmware-local zmk-build:latest \
		sh -c "export ZEPHYR_BASE=/workspace/zephyr && \
		       export CMAKE_PREFIX_PATH=/workspace/zephyr/share/zephyr-package/cmake && \
		       cp -r /config-local/* /workspace/config/ && \
		       west build -d build/left -s zmk/app -b nice_nano_v2 -- -DSHIELD=corne_left -DZMK_CONFIG=/workspace/config && \
		       cp build/left/zephyr/zmk.uf2 /firmware-local/corne_left-nice_nano_v2.uf2"
	@echo "Left firmware built: firmware/corne_left-nice_nano_v2.uf2"

# Build right side firmware
right:
	@echo "Building right side firmware..."
	@mkdir -p firmware
	docker run --rm -v "$(PWD)/config":/config-local -v "$(PWD)/firmware":/firmware-local zmk-build:latest \
		sh -c "export ZEPHYR_BASE=/workspace/zephyr && \
		       export CMAKE_PREFIX_PATH=/workspace/zephyr/share/zephyr-package/cmake && \
		       cp -r /config-local/* /workspace/config/ && \
		       west build -d build/right -s zmk/app -b nice_nano_v2 -- -DSHIELD=corne_right -DZMK_CONFIG=/workspace/config && \
		       cp build/right/zephyr/zmk.uf2 /firmware-local/corne_right-nice_nano_v2.uf2"
	@echo "Right firmware built: firmware/corne_right-nice_nano_v2.uf2"

# Build the Docker image
docker-build:
	@echo "Building Docker image..."
	docker build -t zmk-build:latest .

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf build firmware
	docker run --rm -v "$(PWD)":/workspace zmk-build:latest \
		rm -rf build .west

# Drop into shell for debugging
shell:
	docker run --rm -it -v "$(PWD)":/workspace zmk-build:latest /bin/bash

# Show help
help:
	@echo "ZMK Firmware Build Commands:"
	@echo "  make docker-build  - Build the Docker image (run this first)"
	@echo "  make build         - Build both left and right firmware"
	@echo "  make left          - Build only left side firmware"
	@echo "  make right         - Build only right side firmware"
	@echo "  make clean         - Clean build artifacts"
	@echo "  make shell         - Drop into Docker container shell"
	@echo ""
	@echo "Firmware outputs will be in: firmware/"
