# ARM Assembly notes for Raspberry PI 4

## Build Script

Run: 
```bash
bash build_script.sh -{FLAG} {ASSEMBLY_FILE}
```

Avaiable flags:
```bash
-b              {.s file}       Build binary                                             
-bod            {.s file}       Build binary and show object dump                        
-br             {.s file}       Build binary and run it                                  
-bd             {.s file}       Build binary with debuggung information                  
-bdr            {.s file}       Build binary and start debugger  
```

## Object Dump
With aliases
```bash
objdump -s -d FILE.o
```

With no aliases
```bash
objdump -s -d -M no-aliases FILE.o
```

## GDB

### GDB uses OCTAL to display return codes

- [Use GDB for Assembly Programming](https://jacobmossberg.se/posts/2017/01/17/use-gdb-on-arm-assembly-program.html)

### Navigating the GNUDebugger
#### Steping through and look at register
1. run build script ```bash build_script.sh -bdr {.s FILE}```
	- In case that the debugger is not started with the ```-tui``` flag (Text Interface), the follwoing steps can help you navigate:
		- type ```list``` to see the code, this helps setting the break point
		- type ```layout src``` to see the code around the breakpoint while you are stepping
2. set breakpoint with ```breakpoint 1```, this sets the breakpoint on the first instruction, a <b>b+</b> on the left shows the breakpoint in the code
5. type ```run```, this will start the programm and stop at the first breakpoint
6. type ```layout regs```, this will display the registers while debugging
7. You are now debugging, with ```step``` you can go from instruction to instruction, you can also set new breakpoints and jump to them withj ```continue``` 

# Negative Numbers

[Source that helped me understanding it better](https://armasm.com/docs/bit-operations/signed-numbers/)

Still something I need to get my head around but this is how I can memorize it.

When we have the number 7 (0000 0111) then the negative representation is: 1111 1001.

Counting the zeros like they would be ones and the ones like they are zeros (negating the number), so 11111001 becomes 0000 0110 (6), we then add 1 and get 7 again. So we have -7. 

In other words, we flip all bits in the binary number and add 1 to it.

To verify we can do this by getting the 7 twos via the GNU-Calculator:

```
twos(7) = 1111 1001
```

Adding +7 to -7 should then give us 0:
```
+7 to -7 -> 
0000 0111 +
1111 1001
-----------
0000 0000
```

We then get a 1 that is carried, this is disgarded by the CPSR (Current Program Status Register).


Other example with -16:

16 = 0001 0000 

twos(16) = 1111 0000 (Flip the bits and add 1)

```
0001 0000 +
1111 0000 
-----------
0000 0000
```

1 got carried


With this knowledge we can make negative numbers with the MOVN instructions:

- MOVN moves the data into the register and negates the bits (Exactly what we need as seen above)

```assembly
// W0 means we use a 32-Bit register, X0 would be 64-Bit register
MOVN W0, #16 

/*
We move 0000...00010000 into W0
MOVN negates the bits so we get:
1111....11101111

Now we add one, to have the -16 represetation
*/

ADD W0, W0, #1

/*
Now we have 1111....11110000
Which is -16
*/
```

[See the ARM Documentatiopn about W and X Registers](https://developer.arm.com/documentation/102374/0101/Registers-in-AArch64---general-purpose-registers)

