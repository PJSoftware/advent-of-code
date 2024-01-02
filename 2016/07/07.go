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
    "abcd[bdcdb]xyyx": true,
    "aaaa[qwer]tyui": false,
    "ioxxoj[asdfgh]zxcvbn": true,
  }

  fmt.Print("Starting Tests:\n\n")

  ip1 := NewIPV7("abba[mnop]qrst[bdcdb]xyyx")
  advent.Test("superNet","abba:qrst:xyyx",ip1.superNet)
  advent.Test("hyperNet",":mnop:bdcdb:",ip1.hyperNet)

  for testInput, exp := range(testData) {
    got := NewIPV7(testInput).SupportsTLS()
    advent.Test("TLS: "+testInput, exp, got)
  }

  testData2 := map[string]bool{
    "aba[bab]xyz": true,
    "xyx[xyx]xyx": false,
    "aaa[kek]eke": true,
    "zazbz[bzb]cdb": true,
  }
  for testInput2, exp := range(testData2) {
    got := NewIPV7(testInput2).SupportsSSL()
    advent.Test("SSL: "+testInput2, exp, got)
  }

  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");
  
  // Solution
  
  inputData := advent.InputStrings("07")
  countTLS := 0
  countSSL := 0
  for _, input := range(inputData) {
    ip := NewIPV7(input)
    if ip.SupportsTLS() {
      countTLS++
    }
    if ip.SupportsSSL() {
      countSSL++
    }
  }

  fmt.Printf("# supporting TLS: %d\n",countTLS)
  fmt.Printf("# supporting SSL: %d\n",countSSL)
}

// Solution code

type ipv7 struct {
  addr string
  superNet string
  hyperNet string
}

func NewIPV7(addr string) *ipv7 {
  ip := &ipv7{}
  ip.addr = addr
  sn := regexp.MustCompile(`\[[^]]*\]`)
  hn := regexp.MustCompile(`^[^[]*\[|\][^[]*\[|\][^[]*$`)
  ip.superNet = sn.ReplaceAllString(addr,":")
  ip.hyperNet = hn.ReplaceAllString(addr,":")
  return ip
}

func (ip *ipv7) SupportsTLS() bool {
  abba, inHN := ip.FindABBA()
  if inHN {
    return false
  }

  return abba
}

func (ip *ipv7) FindABBA() (bool,bool) {
  abba := false
  inHN := false
  text := ip.addr

  for i := 0; i < len(text) - 3; i++ {
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

func (ip *ipv7) SupportsSSL() bool {
  text := ip.superNet
  
  for i := 0; i < len(text) - 2; i++ {
    if text[i] == ':' || text[i+1] == ':' || text[i+2] == ':' {
      continue
    }
    if text[i] == text[i+2] && text[i+1] != text[i] {
      bab := fmt.Sprintf("%c%c%c",text[i+1],text[i],text[i+1])
      match, _ := regexp.MatchString(bab, ip.hyperNet)
      if match {
        return true
      }
    }
  }
  return false
}
