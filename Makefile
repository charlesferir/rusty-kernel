BSP ?= microzed

ifeq ($(BSP),rpi4)
	TARGET            = aarch64-rpi4
	LD_SCRIPT_PATH    = $(shell pwd)/src/bsp/raspberrypi
	QEMU_BINARY       = qemu-system-aarch64
	QEMU_MACHINE_TYPE = raspi3
	QEMU_RELEASE_ARGS = -d in_asm -display none
else ifeq ($(BSP),microzed)
	TARGET            = armv7a-microzed
	QEMU_BINARY       = qemu-system-aarch64
	LD_SCRIPT_PATH    = $(shell pwd)/src/bsp/microzed
	QEMU_MACHINE_TYPE = xilinx-zynq-a9
	QEMU_RELEASE_ARGS = -d in_asm -display none
endif

# Export for build.rs.
export LD_SCRIPT_PATH

DIST_DIR              = target/$(TARGET)/dist
KERNEL_ELF            = target/$(TARGET)/release/rusty-kernel
# This parses cargo's dep-info file.
# https://doc.rust-lang.org/cargo/guide/build-cache.html#dep-info-files
KERNEL_ELF_DEPS = $(filter-out %: ,$(file < $(KERNEL_ELF).d)) Cargo.toml
KERNEL_BIN = $(DIST_DIR)/kernel8.img

$(KERNEL_BIN): $(KERNEL_ELF_DEPS)
	@mkdir -p $(DIST_DIR)
	@cargo objcopy --release --target='specs/$(TARGET).json' -- --strip-all -O binary $(KERNEL_BIN)

.PHONY: all qemu clean

all: $(KERNEL_BIN)

qemu: $(KERNEL_BIN)
	$(QEMU_BINARY) -M $(QEMU_MACHINE_TYPE) -d in_asm -display none -kernel $(KERNEL_BIN)

clean:
	@rm -rf $(KERNEL_BIN)
	@cargo clean
