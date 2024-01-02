package main

import (
	"fmt"
	"log"
	"regexp"
	"strconv"

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

var reInput = regexp.MustCompile(`value (\d+) goes to bot (\d+)`)
var reChoose = regexp.MustCompile(`bot (\d+) gives low to (bot|output) (\d+) and high to (bot|output) (\d+)`)

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

  testFactory := newFactory(testInstructions,5,2)
  testFactory.start()
  advent.Test("bot sought", 2, testFactory.botSought())
  advent.BailOnFail()

  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  input := advent.InputStrings("10")
  factory := newFactory(input,61,17)
  factory.start()

  fmt.Printf("Solution: %d\n",factory.botSought())

  result := 1
  for id, bin := range(factory.binBank) {
    if id <= 2 {
      fmt.Printf("Bin #%d: %v\n", id, *bin)
      binContents := *bin
      result *= int(binContents[0])
    }
  }
  fmt.Printf("Solution 2: %d\n", result)
}

// Solution code

func newFactory(instructions []string, c1,c2 chipValue) *factory {
  f := &factory{}
  f.botArmy = make(bots)
  f.binBank = make(bins)
  f.idBot = newBot(0)
  f.idBot.giveChip(c1)
  f.idBot.giveChip(c2)
  f.sought = 0
  
  for _, cmd := range(instructions) {
    if reInput.MatchString(cmd) {
      match := reInput.FindStringSubmatch(cmd)
      v1, _ := strconv.Atoi(match[1])
      bID, _ := strconv.Atoi(match[2])
      fmt.Printf("Give Chip #%d to bot %d\n", v1, bID)
      f.addBot(bID).giveChip(chipValue(v1))
      f.checkTarget(bID)

    } else if reChoose.MatchString(cmd) {
      match := reChoose.FindStringSubmatch(cmd)
      bID, _ := strconv.Atoi(match[1])
      f.addBot(bID).program(cmd)
    
    } else {
      fmt.Printf("Unrecognised command: %s\n", cmd)

    }
  }
  return f
}

func (f *factory) addBot(id int) *bot {
  if _, ok := f.botArmy[id]; !ok {
    f.botArmy[id] = newBot(id)
  }
  return f.botArmy[id]
}

func (f *factory) addBin(id int) *bin {
  if _, ok := f.binBank[id]; !ok {
    f.binBank[id] = newBin()
  }
  return f.binBank[id]
}

func (f *factory) checkTarget(id int) {
  if f.botArmy[id].chipHigh == f.idBot.chipHigh && f.botArmy[id].chipLow == f.idBot.chipLow {
    f.sought = id
  }
}

func newBot(id int) *bot {
  b := &bot{}
  b.id = id
  b.full = false
  b.chipHigh = 0
  b.chipLow = 0
  b.instructions = ""
  return b
}

func newBin() *bin {
  b := &bin{}
  return b
}

func (b *bin) deposit(val chipValue) {
  *b = append(*b, val)
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

func (b *bot) program(cmd string) {
  b.instructions = cmd
}

func (f *factory) start() {
  for {
    count := 0

    for _, b := range(f.botArmy) {
      if !b.full {
        continue
      }

      count++
      if reChoose.MatchString(b.instructions) {
        match := reChoose.FindStringSubmatch(b.instructions)
        objL := match[2]
        idL, _ := strconv.Atoi(match[3])
        objH := match[4]
        idH, _ := strconv.Atoi(match[5])
        
        if objL == "bot" {
          f.addBot(idL).giveChip(b.chipLow)
          f.checkTarget(idL)
          fmt.Printf("Bot %d gives chip #%v to bot %d\n", b.id, b.chipLow, idL)
        } else {
          f.addBin(idL).deposit(b.chipLow)
          fmt.Printf("Bot %d places chip #%v in bin %d\n", b.id, b.chipLow, idL)
        }

        if objH == "bot" {
          f.addBot(idH).giveChip(b.chipHigh)
          f.checkTarget(idH)
          fmt.Printf("Bot %d gives chip #%v to bot %d\n", b.id, b.chipHigh, idH)
        } else {
          f.addBin(idL).deposit(b.chipHigh)
          fmt.Printf("Bot %d places chip #%v in bin %d\n", b.id, b.chipHigh, idH)
        }

        b.chipLow = 0
        b.chipHigh = 0
        b.full = false
      }
    }

    if count == 0 {
      return
    }
  }

}

func (f *factory) botSought() int {
  return f.sought
}