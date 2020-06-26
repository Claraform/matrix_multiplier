onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib floatmulti_opt

do {wave.do}

view wave
view structure
view signals

do {floatmulti.udo}

run -all

quit -force
