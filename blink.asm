; Atmel microprocessor specification
.device ATmega328P

.equ PORTB = 0x05
.equ PORTD = 0x0b
.equ PIND  = 0x09
.equ DDRB  = 0x04
.equ DDRD  = 0x0a


; Atmel processors start execution at 0x0000
.org 0x0000
        jmp main

main:
        ; Note: SBI - set bit in I/0 Registers (there are 32)
        ; DDR* register used to specify input and output registers
        ; DDRB maps over pins 8-13
        ; set 2 bit of DDRB - corresponds to pin 10 (8 + 2)
        sbi DDRB, 2
        ; set 4 bit of DDRB - corresponds to pin 12 (8 + 4)
        sbi DDRB, 4

        ; DDRD maps over pins 0-7
        ; clear 2nd bit -> IO pin 2 is input
        cbi DDRD, 2
        clr r20

check_press_loop:
        ; Note: SBIS - skip if bit is set
        ; if input on pin 2, skip next instruction
        sbis PIND, 2
        rjmp check_press_loop ; loop
        rjmp toggle_leds

check_release_loop:
        ; Note: SBIC - skip if bit is cleared
        sbic PIND, 2
        rjmp check_release_loop ; loop
        rjmp check_press_loop

toggle_leds:
        tst r20
        ; Note: BRNE branch if not equal to - tests zero flag Z
        brne off_pins
        sbis PORTB, 4
        rjmp set_pin_12 ; if pin12 is not on set it
        sbis PORTB, 2
        rjmp set_pin_10 ; if pin 10 is not on set it
        sbis PORTD, 5
        rjmp set_pin_5  ; if pin 5 is not on, set it
; intended fall through
all_on:
        ldi r20, 1
        rjmp check_release_loop

off_pins:
        sbic PORTD, 5
        rjmp off_pin_5
        sbic PORTB, 2
        rjmp off_pin_10
        sbic PORTB, 4
        rjmp off_pin_12
; intended fall through
all_off:
        ldi r20, 0
        rjmp check_release_loop

set_pin_12:
        sbi PORTB, 4
        rjmp check_release_loop

off_pin_12:
        cbi PORTB, 4
        rjmp check_release_loop

set_pin_10:
        sbi PORTB, 2
        rjmp check_release_loop

off_pin_10:
        cbi PORTB, 2
        rjmp check_release_loop

set_pin_5:
        sbi PORTD, 5
        rjmp check_release_loop

off_pin_5:
        cbi PORTD, 5
        rjmp check_release_loop




