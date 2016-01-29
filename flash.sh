#!/bin/sh

openocd -f board/stm32f4discovery.cfg >/dev/null 2>&1 &
PID=$!

arm-none-eabi-gdb -n main.elf <<EOF
target remote :3333
monitor reset halt
load
monitor reset run
EOF

kill -2 $PID
