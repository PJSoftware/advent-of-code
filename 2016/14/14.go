package main

import (
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"strings"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

func main() {
  // Tests

  fmt.Print("Starting Tests:\n\n")

  testSalt := "abc"
  advent.Test("64th OTP key index", 22728, Solve(testSalt))
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");

  // Solution
  
  salt := advent.InputString("14")
  fmt.Printf("Index of 64th OTP key: %d\n",Solve(salt))
}

// Solution code

type SolverData struct {
  salt string
  hash map[int]string
  keys []int
}

func NewSolver(salt string) *SolverData {
  s := &SolverData{}
  s.hash = make(map[int]string)
  s.keys = make([]int, 0)
  s.salt = salt
  return s
}

func Solve(salt string) int {
  s := NewSolver(salt)

  index := 0
  for len(s.keys) < 64 {
    hash := s.GenHash(index)
    if s.isKey(hash, index) {
      s.keys = append(s.keys, index)
      fmt.Printf("Key found at index=%d: %s\n", index, hash)
    }
    index++
  }
  return s.keys[63]
}

func (s *SolverData) isKey(hash string, index int) bool {
  c := foundTriple(hash)
  if c == 0 {
    return false
  }

  quint := string([]byte{c,c,c,c,c})
  for i := 1; i<= 1000; i++ {
    h2 := s.GenHash(index + i)
    if strings.Contains(h2, quint) {
      return true
    }
  }

  return false
}

func foundTriple(str string) byte {
  bytes := []byte(str)
  for i := 0; i < len(bytes)-2; i++ {
    if bytes[i] == bytes[i+1] && bytes[i] == bytes[i+2] {
      return bytes[i]
    }
  }
  return 0
}

func (s *SolverData) GenHash(index int) string {
  if hash, ok := s.hash[index]; ok {
    return hash
  }

  txt := fmt.Sprintf("%s%d", s.salt, index)
  hashBytes := md5.Sum([]byte(txt))
  hash := hex.EncodeToString(hashBytes[:])
  s.hash[index] = hash

  return hash
}