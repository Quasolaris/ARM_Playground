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