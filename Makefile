%.hex: %.asm
	avra -fI $<
	rm *.eep.hex *.obj *.cof

all: $(patsubst %.asm,%.hex,$(wildcard *.asm))

upload: ${program}.hex
	avrdude -c arduino -p m328p -P /dev/ttyACM3 -b 115200 -U flash:w:$<

.PHONY: all upload monitor
