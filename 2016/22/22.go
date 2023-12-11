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
  MaxX, MaxY int
}

func NewGrid() *Grid {
  g := &Grid{}
  g.Nodes = make(map[string]*Node)
  return g
}

func (g *Grid) AddNode(n *Node) {
  g.Nodes[n.Name()] = n
  if n.X > g.MaxX { g.MaxX = n.X }
  if n.Y > g.MaxY { g.MaxY = n.Y }
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
  return nodeName(n.X, n.Y)
}

func nodeName(x, y int) string {
  return fmt.Sprintf("node-x%d-y%d", x, y)
}

func (n *Node) Avail() int {
  return n.Size - n.Used
}

func (n *Node) UsePC() int {
  return int(float64(n.Used)/float64(n.Size))
}

func main() {
  // Tests

  testData := []string{
    "Filesystem            Size  Used  Avail  Use%",
    "/dev/grid/node-x0-y0   10T    8T     2T   80%",
    "/dev/grid/node-x0-y1   11T    6T     5T   54%",
    "/dev/grid/node-x0-y2   32T   28T     4T   87%",
    "/dev/grid/node-x1-y0    9T    7T     2T   77%",
    "/dev/grid/node-x1-y1    8T    0T     8T    0%",
    "/dev/grid/node-x1-y2   11T    7T     4T   63%",
    "/dev/grid/node-x2-y0   10T    6T     4T   60%",
    "/dev/grid/node-x2-y1    9T    8T     1T   88%",
    "/dev/grid/node-x2-y2    9T    6T     3T   66%",
  }

  testGrid := NewGrid()
  for _, data := range testData {
    n := NewNode(data)
    if n != nil {
      testGrid.AddNode(n)
    }
  }
  advent.Test("nodes loaded correctly", 9, len(testGrid.Nodes))
  advent.Test("viable pairs", 7, testGrid.CountViablePairs()) // 7, apparently!
  advent.Test("steps to retrieve", 7, testGrid.RetrievePayload())
  advent.BailOnFail()
  fmt.Print("All tests passed!\n\n");

  input := advent.InputStrings("22")

  g := NewGrid()
  for _, line := range input {
    n := NewNode(line)
    if n != nil {
      g.AddNode(n)
    }
  }
  fmt.Printf("%d nodes imported into grid\n", len(g.Nodes))

  fmt.Printf("Viable Pairs: %d\n",g.CountViablePairs())
  fmt.Printf("Steps to retrieve: %d\n",g.RetrievePayload())
}

// Solution code

func (g *Grid) CountViablePairs() int {
  viable := 0
  for nameA, nodeA := range g.Nodes {
    for nameB, nodeB := range g.Nodes {
      if nameA == nameB { continue }
      if nodeA.Used > 0 && nodeB.Avail() >= nodeA.Used {
        viable++
      }
    }
  }
  return viable
}

// RetrievePayload() approach: A quick visual inspection of the data shows that
// it should be possible to "move" the empty node (from position 26,22) just to
// the left of the payload position (to 30, 0), then "walk" the payload along
// the top row to the target position.
//
// Estimated number of moves required: 4 + 22 + 30*(1+4) + 1 = 177
//
// Actual formula:
//   (payload.X-1)-empty.X 
//   + empty.Y-payload.Y
//   + (payload.x-1)*5 + 1
func (g *Grid) RetrievePayload() int {
  payload := g.RetrieveNodeByCoordinates(g.MaxX, 0)
  empty := g.RetrieveEmptyNode()

  fmt.Printf("Target data %dT @ (%d,%d)\n", payload.Used, payload.X, payload.Y)
  fmt.Printf("Empty node %dT @ (%d,%d)\n", empty.Used, empty.X, empty.Y)

  // Rather than actually moving the data (just yet) let's just calculate the
  // formula
  //
  // This is possible because a simple glance at the data shows no obvious
  // roadblocks to actually performing the operation (although I'm sure Step 2
  // will change that! (Oh wait; this is step 2!)) Since all we want is the
  // number of steps, we should be able to calculate that directly.
  stepsToMoveEmpty := empty.Y-payload.Y + payload.X-empty.X-1
  stepsToWalkPayload := (payload.X-1)*5 + 1
  return stepsToMoveEmpty + stepsToWalkPayload
}

func (g *Grid) RetrieveNodeByCoordinates(x, y int) *Node {
  name := nodeName(x, y)
  if node, ok := g.Nodes[name]; ok {
    return node
  }
  return nil
}

func (g *Grid) RetrieveEmptyNode() *Node {
  for _, node := range g.Nodes {
    if node.Used == 0 {
      return node
    }
  }
  return nil
}

func convertToInt(s string) int {
  i, err := strconv.ParseInt(s, 10, 64)
  if err != nil {
    log.Fatalf("Unexpected conversion error, '%s' not numeric!", s)
  }
  return int(i)
}
