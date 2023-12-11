package main

import (
	"fmt"
	"log"
	"regexp"
	"strconv"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type Grid struct {
  Nodes map[string]*Node
}

func NewGrid() *Grid {
  g := &Grid{}
  g.Nodes = make(map[string]*Node)
  return g
}

func (g *Grid) AddNode(n *Node) {
  g.Nodes[n.Name()] = n
}

type Node struct {
  X, Y int
  Size int
  Used int
}

var nodeRE *regexp.Regexp

func NewNode(input string) *Node {
  if nodeRE == nil {
    nodeRE = regexp.MustCompile("^/dev/grid/node-x([0-9]+)-y([0-9]+)[ \t]+([0-9]+)T[ \t]+([0-9]+)T")
  }

  match := nodeRE.FindStringSubmatch(input)
  if match == nil {
    return nil
  }

  n := &Node{}
  n.X = convertToInt(match[1])
  n.Y = convertToInt(match[2])
  n.Size = convertToInt(match[3])
  n.Used = convertToInt(match[4])
  return n
}

func (n *Node) Name() string {
  return fmt.Sprintf("node-x%d-y%d", n.X, n.Y)
}

func (n *Node) Avail() int {
  return n.Size - n.Used
}

func (n *Node) UsePC() int {
  return int(float64(n.Used)/float64(n.Size))
}

func main() {
  // No sample data provided; pre-testing not possible
  
  input := advent.InputStrings("22")

  g := NewGrid()
  for _, line := range input {
    n := NewNode(line)
    if n != nil {
      g.AddNode(n)
    }
  }
  fmt.Printf("%d nodes imported into grid\n", len(g.Nodes))

  fmt.Printf("Valid Pairs: %d\n",g.CountValidPairs())
}

// Solution code

func (g *Grid) CountValidPairs() int {
  valid := 0
  for nameA, nodeA := range g.Nodes {
    for nameB, nodeB := range g.Nodes {
      if nameA == nameB { continue }
      if nodeA.Used > 0 && nodeB.Avail() >= nodeA.Used {
        valid++
      }
    }
  }
  return valid
}

func convertToInt(s string) int {
  i, err := strconv.ParseInt(s, 10, 64)
  if err != nil {
    log.Fatalf("Unexpected conversion error, '%s' not numeric!", s)
  }
  return int(i)
}
