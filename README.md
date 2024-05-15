# zigdump

Tool to view files in hexadecimal format, like xxd, but in [zig](https://ziglang.org/).

> Not include all funcitions from xxd, this is only a program to studies.


## Build

Setup zig in your machine. Developed on zig 0.12.0

```sh
zig build
```

Executable inside `./zig-out/bin`.

## References

- [Zig Doc](https://ziglang.org/documentation/0.12.0/)
- [Zig Standar Library](https://ziglang.org/documentation/0.12.0/std/)
- [xxd man](https://linux.die.net/man/1/xxd)
- [xxd source code](https://github.com/vim/vim/blob/master/src/xxd/xxd.c)

## Benchmark

- **Compiled with: `zig build -Doptimize=Debug`**

| Command                       |       Mean [s] | Min [s] | Max [s] |    Relative |
|:------------------------------|---------------:|--------:|--------:|------------:|
| `xxd ./zig`                   | 44.780 ± 1.379 |  42.368 |  47.603 |        1.00 |
| `./zig-out/bin/zigdump ./zig` | 47.753 ± 0.386 |  47.420 |  48.423 | 1.07 ± 0.03 |

- **Compiled with: `zig build -Doptimize=ReleaseSafe`**

| Command | Mean [s] | Min [s] | Max [s] | Relative |
|:------------------------------|---------------:|-------:|-------:|------------:|
| `xxd ./zig`                   | 44.106 ± 0.868 | 42.578 | 45.315 | 5.94 ± 0.12 |
| `./zig-out/bin/zigdump ./zig` | 7.421 ± 0.033  | 7.371  | 7.466  | 1.00        |

- **Compiled with: `zig build -Doptimize=ReleaseFast`**

| Command | Mean [s] | Min [s] | Max [s] | Relative |
|:------------------------------|---------------:|-------:|-------:|------------:|
| `xxd ./zig`                   | 47.417 ± 2.821 | 44.298 | 50.783 | 7.12 ± 0.42 |
| `./zig-out/bin/zigdump ./zig` | 6.663 ± 0.033  | 6.619  | 6.704  | 1.00        |

- **Compiled with: `zig build -Doptimize=ReleaseSmall`**

| Command                       |       Mean [s] | Min [s] | Max [s] |    Relative |
|:------------------------------|---------------:|--------:|--------:|------------:|
| `xxd ./zig`                   | 49.071 ± 0.404 |  48.554 |  49.711 | 5.34 ± 0.08 |
| `./zig-out/bin/zigdump ./zig` |  9.187 ± 0.120 |   9.088 |   9.510 |        1.00 |

Only for fun. There is a lot of difference in implemented features

Used [hyperfine](https://github.com/sharkdp/hyperfine) for benchmark.

All tests made with `zig` 0.12.0 binary, with the follow script

```sh
#!/bin/bash
options=("Debug" "ReleaseSafe" "ReleaseFast" "ReleaseSmall")
bin="./zig"
if [ ! -d "logs" ]; then
	mkdir logs
fi
for opt in "${options[@]}"; do
	echo ">> Compiling for options ${opt} ..."
	 zig build -Doptimize=${opt}
	 if [ "$?" -eq 0 ]; then
		echo ">> Making benchmark for ${opt}"
		 ./hyperfine --export-markdown "logs/${opt}.md" --warmup 3 "xxd $bin" "./zig-out/bin/zigdump $bin"
	 else
		echo ">> Compilation fail!"
	 fi
done
echo ">> Done"
```

## Features

- [x] View data in hexadecimal and printable characters
- [ ] Switch to bits. `-b | -bits`
- [ ] Select column size by `-c | -cols`
- [ ] Separate the output of evrey byte by a whitespace `-g | -groupsize`
- [ ] Stop after writing some octets `-l | -len`
- [ ] Start read from byte `-s | -seek`
- [ ] Hexa output in uppercase letters `-u`

> Maybe in the future, but not now?
