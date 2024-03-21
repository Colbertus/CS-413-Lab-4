@ File: mcclureLab4.s 

@ Author: Colby McClure

@ Email: ctm0026@uah.edu

@ CS 413-01 Spring 2024

@ Purpose: implemented a simple four function integer calculator using Assembly

@ The comments below are to assemble, link, run, and debug the program
@ as -o mcclureLab4.o mcclureLab4.s
@ gcc -o mcclureLab4 mcclureLab4.o -lwiringPi
@ ./mcclureLab4
@ gdb --args ./mcclureLab4

OUTPUT = 1 @ Used to set the selected GPIO pins to output only. 
ON     = 1 @ Turn the LED on.
OFF    = 0 @ Turn the LED off.

RED    = 5 @ Pin number from wiringPi for red led
YELLOW = 4 @ Pin number from wiringPi for yellow led
GREEN  = 3 @ Pin number from wiringPi for green led
BLUE   = 2 @ Pin number from wiringPi for blue led

.equ READERROR, 0
.global main 
.text

main: 

bl wiringPiSetup
mov r1, #-1
cmp r0, r1
bne init  @ Everything is OK so continue with code.

@ This label is for initializing the GPIO pins
@**********
init:
@**********

    @ Set the blue LED mode to output
    ldr r0, =blue_LED
    ldr r0, [r0]
    mov r1, #OUTPUT
    bl pinMode

    @ Set the green LED mode to output
    ldr r0, =green_LED
    ldr r0, [r0]
    mov r1, #OUTPUT
    bl pinMode

    @ Set the yellow LED mode to output
    ldr r0, =yellow_LED
    ldr r0, [r0]
    mov r1, #OUTPUT
    bl pinMode

    @ Set the red LED mode to output
    ldr r0, =red_LED
    ldr r0, [r0]
    mov r1, #OUTPUT
    bl pinMode

    b turnOn @ Branch to the turnOn label

@**********
turnOn:
@**********

    @ Turn on the red LED
    ldr r0, =red_LED
    ldr r0, [r0]
    mov r1, #ON
    bl digitalWrite

    ldr r0, =delayMs
    ldr r0, [r0]
    bl delay

    b waterLoad @ Branch to the waterLoad label

@ This label is for setting the register equal to the max amount of coffee allowed
@**********
waterLoad:
@**********

    mov r4, #48 @ Set r4 equal to max amount of coffee allowed
    mov r7, #0 @ Set r6 equal to amount of small cups used
    mov r8, #0 @ Set r7 equal to amount of medium cups used
    mov r9, #0 @ Set r8 equal to amount of large cups used

@ This label outputs the welcoming message along with the instructions
@**********
beginPrompt:
@**********

    ldr r0, =prompt1 @ Load the first prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =prompt2 @ Load the second prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =prompt3 @ Load the third prompt into r0
    bl printf @ Call printf to print the prompt

    b chooseSize @ Branch to the chooseSize label

@ This label is for outputting the optins for the cup size and allowing input from the user 
@**********
chooseSize:
@**********

    ldr r0, =prompt4 @ Load the fourth prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =prompt5 @ Load the fifth prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =chInputPattern @ Load the input pattern into r0
    ldr r1, =cupInput @ Load the cupInput into r1
    bl scanf @ Call scanf to get the input from the user

    ldr r1, =cupInput @ Load the cupInput into r1
    ldr r11, [r1] @ Load the value of cupInput into r11

    cmp r11, #33 @ Compare r11 with the secret character '!'
    bleq secretCode @ Branch to secretCode if r11 is less than or equal to 33

    cmp r11, #115 @ Compare r11 with the character 's'
    beq checkWater @ Branch to checkWater if r11 is equal to 's'

    cmp r11, #109 @ Compare r11 with the character 'm'
    beq checkWater @ Branch to checkWater if r11 is equal to 'm'

    cmp r11, #108 @ Compare r11 with the character 'l'
    beq checkWater @ Branch to checkWater if r11 is equal to 'l'

    cmp r11, #84 @ Compare r11 with the character 'T'
    beq exit @ Branch to exit if r11 is equal to 'T'

    b chooseSize @ Branch to chooseSize if secret character or any other character is entered

@ This label is for checking to make sure that the user input is valid
@**********
checkWater:
@**********

    cmp r11, #115 @ Compare r11 and 115
    moveq r6, #6 @ If r11 is equal to 1, move 6 into r6

    cmp r11, #115 @ Compare r11 and 115
    addeq r7, r7, #1 @ If r11 is equal to 1, add 1 to r7

    cmp r11, #109 @ Compare r11 and 109
    moveq r6, #8 @ If r11 is equal to 109, move 8 into r6

    cmp r11, #109 @ Compare r11 and 109
    addeq r8, r8, #1 @ If r11 is equal to 109, add 1 to r8

    cmp r11, #108 @ Compare r11 and 108
    moveq r6, #10 @ If r11 is equal to 108, move 10 into r6

    cmp r11, #108 @ Compare r11 and 108
    addeq r9, r9, #1 @ If r11 is equal to 3, add 1 to r9

    cmp r4, r6 @ Compare r4 and r6
    bge brewPrep @ Branch to brewCoffee if r4 is greater than or equal to r6

    ldr r0, =brewBad @ Load the brewBad prompt into r0
    bl printf @ Call printf to print the prompt

    b lowWater @ Branch to lowWater

    b chooseSize @ Branch to chooseSize
    
@ This label is for brewing the coffee if there's enough water
@**********
brewPrep:
@**********

    ldr r0, =brewGood1 @ Load the brewGood1 prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =brewGood2 @ Load the brewGood2 prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =chInputPattern @ Load the character input pattern into r0
    ldr r1, =buttonInput @ Load the buttonInput into r1
    bl scanf @ Call scanf to get the input from the user

    ldr r1, =buttonInput @ Load the buttonInput into r1
    ldr r5, [r1] @ Load the value of buttonInput into r5

    cmp r5, #33 @ Compare r5 and character '!'
    bleq secretCode @ Branch to secretCode if r5 is less than or equal to 33

    cmp r5, #66 @ Compare r5 and character 'B'
    beq brewCoffee @ Branch to brewCoffee if r5 is equal to 'B'

    b brewPrep @ Branch to brewPrep if secret code or any other character is entered

@ This label is for brewing the coffee 
@**********
brewCoffee:
@**********

    subs r4, r4, r6 @ Subtract r6 from r4

    cmp r11, #115 @ Compare r11 with the character 's'
    bleq brewSmall @ Branch to brewSmall if r11 is equal to 's'

    cmp r11, #109 @ Compare r11 with the character 'm'
    bleq brewMedium @ Branch to brewMedium if r11 is equal to 'm'

    cmp r11, #108 @ Compare r11 with the character 'l'
    bleq brewLarge @ Branch to brewLarge if r11 is equal to 'l'

    ldr r0, =brewSuccess @ Load the brewSuccess prompt into r0
    bl printf @ Call printf to print the prompt

    cmp r4, #6 @ Compare r4 and to the minimum amount of water
    bge beginPrompt @ Branch to beginPrompt if r4 is greater than or equal to 6

    ldr r0, =waterLow1 @ Load the waterLow1 prompt into r0
    bl printf @ Call printf to print the prompt

    ldr r0, =waterLow2 @ Load the waterLow2 prompt into r0
    bl printf @ Call printf to print the prompt

    bl lowWater @ Branch to lowWater subroutine

    b exit @ Branch to exit

@**********
lowWater:
@**********

    push {lr} @ Push the link register to the stack
    ldr r0, =red_LED @ Load the red_LED into r0
    ldr r0, [r0] @ Load the value of red_LED into r0
    mov r1, #OFF @ Set r1 equal to OFF
    bl digitalWrite @ Call digitalWrite to turn off the red LED

    ldr r0, =delayMs @ Load the delayMs into r0
    ldr r0, [r0] @ Load the value of delayMs into r0
    bl delay @ Call delay to delay the execution

    ldr r0, =red_LED @ Load the red_LED into r0
    ldr r0, [r0] @ Load the value of red_LED into r0
    mov r1, #ON @ Set r1 equal to ON
    bl digitalWrite @ Call digitalWrite to turn on the red LED

    ldr r0, =delayMs @ Load the delayMs into r0
    ldr r0, [r0] @ Load the value of delayMs into r0
    bl delay @ Call delay to delay the execution

    ldr r0, =red_LED @ Load the red_LED into r0
    ldr r0, [r0] @ Load the value of red_LED into r0
    mov r1, #OFF @ Set r1 equal to OFF
    bl digitalWrite @ Call digitalWrite to turn off the red LED

    ldr r0, =delayMs @ Load the delayMs into r0
    ldr r0, [r0] @ Load the value of delayMs into r0
    bl delay @ Call delay to delay the execution

    ldr r0, =red_LED @ Load the red_LED into r0
    ldr r0, [r0] @ Load the value of red_LED into r0
    mov r1, #ON @ Set r1 equal to ON
    bl digitalWrite @ Call digitalWrite to turn on the red LED

    ldr r0, =delayMs @ Load the delayMs into r0
    ldr r0, [r0] @ Load the value of delayMs into r0
    bl delay @ Call delay to delay the execution

    pop {pc} @ Exit the subroutine

@ This label ends the program and shuts off all the LEDs
@**********
exit:
@**********

    ldr r0, =red_LED @ Load the red_LED into r0
    ldr r0, [r0] @ Load the value of red_LED into r0
    mov r1, #OFF @ Set r1 equal to OFF
    bl digitalWrite @ Call digitalWrite to turn off the red LED

    ldr r0, =blue_LED @ Load the blue_LED into r0
    ldr r0, [r0] @ Load the value of blue_LED into r0
    mov r1, #OFF @ Set r1 equal to OFF
    bl digitalWrite @ Call digitalWrite to turn off the blue LED

    ldr r0, =yellow_LED @ Load the yellow_LED into r0
    ldr r0, [r0] @ Load the value of yellow_LED into r0
    mov r1, #OFF @ Set r1 equal to OFF
    bl digitalWrite @ Call digitalWrite to turn off the yellow LED

    ldr r0, =green_LED @ Load the green_LED into r0
    ldr r0, [r0] @ Load the value of green_LED into r0
    mov r1, #OFF @ Set r1 equal to OFF
    bl  digitalWrite @ Call digitalWrite to turn off the green LED

	mov r7, #0x01 @ Set r7 equal to 0x01
	svc 0 @ Call svc 0 to exit the program

@ This subroutine is for the secret code to display the water level and the amount of cups used
@**********
secretCode:
@**********
    push {lr} @ Push the link register to the stack 
    ldr r0, =waterLevel @ Load the waterLevel prompt into r0
    mov r1, r4 @ Load the value of r4 into r1
    bl printf @ Call printf to print the prompt

    ldr r0, =smallCups @ Load the smallCups prompt into r0
    mov r1, r7 @ Load the value of r7 into r1
    bl printf @ Call printf to print the prompt

    ldr r0, =mediumCups @ Load the mediumCups prompt into r0
    mov r1, r8 @ Load the value of r8 into r1
    bl printf @ Call printf to print the prompt

    ldr r0, =largeCups @ Load the largeCups prompt into r0
    mov r1, r9 @ Load the value of r9 into r1
    bl printf @ Call printf to print the prompt

    pop {pc} @ Exit the subroutine 

@ This subroutine is for turning the yellow LED on and off
@**********
brewSmall:
@**********

    push {lr} @ Push the link register to the stack

    ldr r0, =yellow_LED @ Load the yellow_LED into r0
    ldr r0, [r0] @ Load the value of yellow_LED into r0
    mov r1, #ON @ Set r1 equal to ON
    bl digitalWrite @ Call digitalWrite to turn on the yellow LED

    ldr r0, =smallDelayMs @ Load the smallDelayMs into r0
    ldr r0, [r0] @ Load the value of smallDelayMs into r0
    bl delay @ Call delay to delay the execution

    ldr r0, =yellow_LED @ Load the yellow_LED into r0
    ldr r0, [r0] @ Load the value of yellow_LED into r0
    mov r1, #OFF @ Set r1 equal to OFF
    bl digitalWrite @ Call digitalWrite to turn off the yellow LED

    pop {pc} @ Exit the subroutine

@ This subroutine is for turning the green LED on and off
@**********
brewMedium:
@**********

    push {lr} @ Push the link register to the stack

    ldr r0, =green_LED @ Load the green_LED into r0
    ldr r0, [r0] @ Load the value of green_LED into r0
    mov r1, #ON @ Set r1 equal to ON
    bl digitalWrite @ Call digitalWrite to turn on the green LED

    ldr r0, =mediumDelayMs @ Load the mediumDelayMs into r0
    ldr r0, [r0] @ Load the value of mediumDelayMs into r0
    bl delay @ Call delay to delay the execution

    ldr r0, =green_LED @ Load the green_LED into r0
    ldr r0, [r0] @ Load the value of green_LED into r0
    mov r1, #OFF @ Set r1 equal to OFF
    bl digitalWrite @ Call digitalWrite to turn off the green LED

    pop {pc} @ Exit the subroutine

    
@ This subroutine is for turning the blue LED on and off
@**********
brewLarge:
@**********

    push {lr} @ Push the link register to the stack

    ldr r0, =blue_LED @ Load the address of blue_LED into r0
    ldr r0, [r0] @ Load the value of blue_LED into r0
    mov r1, #ON @ Set r1 equal to ON
    bl digitalWrite @ Call digitalWrite to turn on the blue LED

    ldr r0, =largeDelayMs @ Load the address of largeDelayMs into r0
    ldr r0, [r0] @ Load the value of largeDelayMs into r0
    bl delay @ Call delay to delay the execution

    ldr r0, =blue_LED @ Load the address of blue_LED into r0
    ldr r0, [r0] @ Load the value of blue_LED into r0
    mov r1, #OFF @ Set r1 equal to OFF
    bl digitalWrite @ Call digitalWrite to turn off the blue LED
    
    pop {pc} @ Exit the subroutine

.data 

.balign 4

@ Define the values for the pins

blue_LED   : .word BLUE
green_LED  : .word GREEN
yellow_LED : .word YELLOW
red_LED    : .word RED

delayMs: .word 1000

.balign 4
smallDelayMs: .word 6000

.balign 4
mediumDelayMs: .word 8000

.balign 4
largeDelayMs: .word 10000

.balign 4
prompt1: .asciz "Welcome to the Coffee Maker \n"

.balign 4
prompt2: .asciz "Insert K-cup and press B to begin making coffee \n"

.balign 4
prompt3: .asciz "Press T to turn off the machine \n"

.balign 4
prompt4: .asciz "Please select the size of the cup you would like to use \n"

.balign 4
prompt5: .asciz " [s] Small (6 oz) [m] Medium (8 oz) [l] Large (10 oz) \n"

.balign 4
brewGood1: .asciz "Ready to Brew \n" 

.balign 4
brewGood2: .asciz "Please place a cup in the tray and press [B] to begin brewing \n"

.balign 4
brewBad: .asciz "Not enough water to brew the coffee, please select a smaller cup size \n"

.balign 4
brewSuccess: .asciz "Coffee is ready! \n"

.balign 4
waterLow1: .asciz "The water level is low, please refill the reservoir \n"

.balign
waterLow2: .asciz "Powering down... \n"

.balign 4
waterLevel: .asciz "Water level: %d \n"

.balign 4
smallCups: .asciz "Small: %d \n"

.balign 4
mediumCups: .asciz "Medium: %d \n"

.balign 4
largeCups: .asciz "Large: %d \n"

.balign 4
cupInput: .word 0 

.balign 4 
numInputPattern: .asciz "%d"

.balign 4
buttonInput: .word 0

.balign 4
chInputPattern: .asciz " %c" 

.global printf
.global scanf

.extern wiringPiSetup 
.extern delay
.extern digitalWrite
.extern pinMode
