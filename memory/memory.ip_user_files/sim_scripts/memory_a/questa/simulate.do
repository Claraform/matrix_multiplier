onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib memory_a_opt

do {wave.do}

view wave
view structure
view signals

do {memory_a.udo}

run -all

quit -force
