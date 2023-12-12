package assembunny

import (
	"fmt"
	"log"
	"regexp"
	"strconv"
)

const VERSION string = "1.0.0"

type Register map[string]int

func init() {
	fmt.Printf("AssemBunny Interpreter v%s: ready\n", VERSION)
}

func RunAndReturnA(code []string) int {
	reg := make(Register)
	reg["a"] = 0
	reg["b"] = 0
	reg["c"] = 0
	reg["d"] = 0

	index := 0
	re := regexp.MustCompile("(cpy|inc|dec|jnz) ([0-9a-z]+) ?([0-9a-z-]+)?")
	for index < len(code) {
		line := code[index]
		instruction := re.FindStringSubmatch(line)
		if instruction == nil {
			log.Fatalf("Unsupported instruction: AssemBunny v%s does not support '%s'", VERSION, line)
		}
		
		switch instruction[1] {
		case "cpy":
			regX := instruction[3]
			val := 0
			if isNumeric(instruction[2]) {
				x, _ := strconv.ParseInt(instruction[2], 10, 32)
				val = int(x)
			} else {
				val = reg[instruction[2]]
			}
			reg[regX] = val
			index++

		case "inc":
			reg[instruction[2]]++
			index++

		case "dec":
			reg[instruction[2]]--
			index++

		case "jnz":
			val := 0
			if isNumeric(instruction[2]) {
				x, _ := strconv.ParseInt(instruction[2], 10, 32)
				val = int(x)
			} else {
				val = reg[instruction[2]]
			}
			if val != 0 {
				y, _ := strconv.ParseInt(instruction[3], 10, 32)
				// fmt.Printf("# %d: **Reg %s != 0 (%d) so JMP by %d (%d,%d,%d,%d)\n", index, instruction[2], reg[instruction[2]], y, reg["a"], reg["b"], reg["c"], reg["d"])
				index += int(y)
			} else {
				index++
			}

		default:
			log.Fatalf("Unknown instruction '%s' at line %d", line, index)

		}
	}

	return reg["a"]
}

func isNumeric(s string) bool {
  _, err := strconv.ParseInt(s, 10, 32)
  return err == nil
}
