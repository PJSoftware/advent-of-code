package main

import (
	"fmt"
	"log"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type chipValue int
type bot struct {
  id int
  full bool
  chipHigh, chipLow chipValue
  instructions string
}
type bin []chipValue
type bots map[int]*bot
type bins map[int]*bin
type factory struct {
  botArmy bots
  binBank bins
  idBot *bot
  sought int
}

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")

  testInstructions := []string{
    "value 5 goes to bot 2",
    "bot 2 gives low to bot 1 and high to bot 0",
    "value 3 goes to bot 1",
    "bot 1 gives low to output 1 and high to bot 0",
    "bot 0 gives low to output 2 and high to output 0",
    "value 2 goes to bot 2",
  }

  testFactory := newFactory(testInstructions)
  testFactory.identifyBot(5,2)
  testFactory.start()
  advent.Test("bot sought", 2, testFactory.botSought())
  advent.BailOnFail()

  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputStrings("10")
  factory := newFactory(input)
  factory.identifyBot(61,17)
  factory.start()

  fmt.Printf("Solution: %d\n",factory.botSought())
}

// Solution code

func newFactory(instructions []string) *factory {
  f := &factory{}
  f.botArmy = make(bots)
  f.binBank = make(bins)
  f.idBot = addBot(0)
  f.sought = 0
  return f
}

func addBot(id int) *bot {
  b := &bot{}
  b.id = id
  b.full = false
  b.chipHigh = 0
  b.chipLow = 0
  b.instructions = ""
  return b
}

func (b *bot) giveChip(val chipValue) {
  if b.full {
    log.Printf("Bot %d already holds (%v,%v) and was overloaded by %v", b.id, b.chipHigh, b.chipLow, val)
  }
  if val < 1 {
    log.Printf("Unexpected value of %d passed to bot %d", val, b.id)
  }  

  if b.chipHigh == 0 {
    b.chipHigh = val
  } else if val > b.chipHigh {
    b.chipLow = b.chipHigh
    b.chipHigh = val
  } else {
    b.chipLow = val
  }
  b.full = b.chipLow != 0
}

func (f *factory) identifyBot(v1, v2 chipValue) {
  f.idBot.giveChip(v1)
  f.idBot.giveChip(v2)
}
