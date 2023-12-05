# Laboratory Work No. 3 

### Authors (FAF-213)
* Corneliu Catlabuga
* Beatricia Golban
* Gabriel Gitlan

### Compilation Commands
```bash
nasm -f bin -o boot.bin boot.asm && 
nasm -f bin -o main.bin main.asm && 
cat boot.bin main.bin > boot.img && 
truncate -s 1474560 boot.img && 
rm boot.bin main.bin
```

