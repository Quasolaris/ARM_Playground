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