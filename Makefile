CC_PREFIX ?= arm-none-eabi-

SH = sh
FLASH_FILE = flash.sh

CC = $(CC_PREFIX)gcc
AS = $(CC_PREFIX)as
LD = $(CC_PREFIX)ld
OBJCOPY = $(CC_PREFIX)objcopy
SIZE = $(CC_PREFIX)size
CFLAGS = -mcpu=cortex-m4 -mthumb -g

SRC = main.c
OBJ = $(SRC:%.c=%.o)

TARGET = main.elf
BIN = main.bin
MAP = main.map
LOADER_SCRIPT = stm32f4.ld

all: $(TARGET)

$(TARGET): $(OBJ) $(LOADER_SCRIPT)
	$(LD) -M=$(MAP) -T $(LOADER_SCRIPT) -o $@ $(OBJ)

%.o: %.c
	$(CC) -c $(CFLAGS) -o $@ $<

%.o: %.s
	$(AS) -c $(CFLAGS) -o $@ $<

flash: $(TARGET)
	$(SH) $(FLASH_FILE)

clean:
	rm -f $(OBJ) $(TARGET) $(BIN) $(MAP)

.PHONY: all flash clean
