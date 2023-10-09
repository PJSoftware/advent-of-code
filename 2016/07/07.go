package main

import (
	"fmt"
	"regexp"

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
  abba := regexp.MustCompile(`([a-z])([a-z])\2\1`)
  ABBA := abba.FindStringSubmatch(ip.addr)
  hasABBA := len(ABBA) > 0 && ABBA[1] != ABBA[2]
  if !hasABBA {
    fmt.Printf("%s - No ABBA found\n",ip.addr)
    return false
  }

  abbaHyperNet := regexp.MustCompile(`\[[^]]*([a-z])([a-z])\2\1.*\]`)
  ABBAhn := abbaHyperNet.FindStringSubmatch(ip.addr)
  hasABBAhn := len(ABBAhn) > 0 && ABBAhn[1] != ABBAhn[2]
  if hasABBAhn {
    fmt.Printf("%s - ABBA in HyperNet\n",ip.addr)
    return false
  }  

  return true
}
