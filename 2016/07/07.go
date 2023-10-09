package main

import (
	"fmt"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  // Tests

  testData := map[string]bool{
    "abba[mnop]qrst": true,
    "abcd[bddb]xyyx": false,
    "aaaa[qwer]tyui": false,
    "ioxxoj[asdfgh]zxcvbn": true,
  }

  fmt.Print("Starting Tests:\n\n")
  for testInput, exp := range(testData) {
    got := NewIPV7(testInput).SupportsTLS()
    advent.Test(testInput, exp, got)
  }
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  inputData := advent.InputStrings("07")
  count := 0
  for _, input := range(inputData) {
    ip := NewIPV7(input)
    if ip.SupportsTLS() {
      count++
    }
  }

  fmt.Printf("# supporting TLS: %d\n",count)
}

// Solution code

type ipv7 struct {
  addr string
}

func NewIPV7(ip string) *ipv7 {
  return &ipv7{addr: ip}
}

func (ip *ipv7) SupportsTLS() bool {
  abba, inHN := FindABBA(ip.addr)
  if inHN {
    return false
  }

  return abba
}

func FindABBA(text string) (bool,bool) {
  abba := false
  inHN := false

  for i := 0; i < len(text) - 4; i++ {
    if text[i] == '[' {
      inHN = true
    } else if text[i] == ']' {
      inHN = false
    } else if text[i] == text[i+3] && text[i+1] == text[i+2] && text[i] != text[i+1] {
      abba = true
      if inHN {
        return abba, inHN
      }
    }
  }
  return abba, inHN
}