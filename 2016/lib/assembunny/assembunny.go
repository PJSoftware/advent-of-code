package assembunny

import (
	"fmt"
	"log"
	"regexp"
	"strconv"
)

const VERSION string = "1.1.0"

type Register map[string]int

type Interpreter struct {
	reg   Register
	code  []string
	index int
	steps int
	DNR   bool
	re    map[string]*regexp.Regexp
}

func init() {
	fmt.Printf("AssemBunny Interpreter v%s: ready\n", VERSION)
}

// NewInterpreter sets up a new interpreter to run the code provided
func NewInterpreter(code []string) *Interpreter {
	ai := &Interpreter{}
	ai.reg = make(Register)
	ai.reg["a"] = 0
	ai.reg["b"] = 0
	ai.reg["c"] = 0
	ai.reg["d"] = 0
	ai.code = append(ai.code, code...)
	ai.index = 0
	ai.steps = 0
	ai.DNR = false

	// Build expected regexp pattern
	ai.re = make(map[string]*regexp.Regexp)

	regName := "([a-d])"
	regValue := "([a-d]|[0-9]+)"
	offset := "(-?[0-9]+)"
	ai.re["inc"] = regexp.MustCompile("inc "+regName)
	ai.re["dec"] = regexp.MustCompile("dec "+regName)
	ai.re["cpy"] = regexp.MustCompile("cpy "+regValue+" "+regName)
	ai.re["jnz"] = regexp.MustCompile("jnz "+regValue+" "+offset)
	
	return ai
}

func (ai *Interpreter) IsRunning() bool {
	if ai.index < len(ai.code) {
		return true
	}
	ai.DNR = true
	return false
}

func (ai *Interpreter) NextInstruction() (string, string, string) {
	line := ai.code[ai.index]
	for inst, re := range ai.re {
		match := re.FindStringSubmatch(line)
		if match != nil {
			if len(match) == 2 {
				return inst, match[1], ""
			}
			return inst, match[1], match[2]
		}
	}
	return line, "", ""
}

// ai.Run() runs the code in the interpreter, returning the total number of
// steps processed
func (ai *Interpreter) Run() int {
	if ai.DNR {
		log.Fatalf("This program has already been run and cannot be run again")
	}
	for ai.IsRunning() {
		inst, p1, p2 := ai.NextInstruction()

		switch inst {
		case "inc": ai.inc(p1)
		case "dec": ai.dec(p1)
		case "cpy": ai.cpy(p1,p2)
		case "jnz": ai.jnz(p1,p2)

		default:
			ai.progDump()
			log.Fatalf("Unknown instruction '%s' at line %d", inst, ai.index+1)
		}
		ai.steps++
	}

	return ai.steps
}

func (ai *Interpreter) progDump() {
	for i, line := range ai.code {
		if i == ai.index {
			fmt.Printf(">>> %d: %s <<<\n", i, line)
		} else {
			fmt.Printf("%d: %s\n", i, line)
		}
	}
}
func (ai *Interpreter) inc(p1 string) {
	ai.reg[p1]++
	ai.index++
}

func (ai *Interpreter) dec(p1 string) {
	ai.reg[p1]--
	ai.index++
}

func (ai *Interpreter) cpy(p1, p2 string) {
	regX := p2
	val := ai.extractVal(p1)
	ai.reg[regX] = val
	ai.index++
} 

func (ai *Interpreter) jnz(p1, p2 string) {
	val := ai.extractVal(p1)
	if val != 0 {
		ai.index += int(convertToInt(p2))
	} else {
		ai.index++
	}
}

func (ai *Interpreter) extractVal(p string) int {
	var val int
	if isNumeric(p) {
		val = convertToInt(p)
	} else {
		val = ai.reg[p]
	}
	return val
}

func convertToInt(p string) int {
	x, _ := strconv.ParseInt(p, 10, 32)
	return int(x)
}

// ai.RegisterA() returns the value of register A
func (ai *Interpreter) RegisterA() int {
	return ai.reg["a"]
}

// ai.SetRegisterC() sets the value of register C
func (ai *Interpreter) SetRegisterC(value int) {
	ai.reg["c"] = value
}

func isNumeric(s string) bool {
  _, err := strconv.ParseInt(s, 10, 32)
  return err == nil
}
