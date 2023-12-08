package main

import (
	"fmt"
	"log"
	"math"
	"strconv"
	"strings"
)

// RBN is a Really Big Number. Dijkstra's algorithm technically should set the
// distance of unvisited nodes to 'infinity' but for our purposes, RBN will be
// big enough. It doesn't get much bigger than MaxInt anyway...
const RBN int = math.MaxInt

type World struct {
	Source *Node
	Target *Node
	Seed   int

	NodesWithinMax map[string]bool

	Nodes      map[string]*Node
	Walls      map[string]bool
	Unexplored map[string]bool
}

func NewWorld(srcX, srcY, trgX, trgY, seed int) *World {
	w := &World{}
	w.Seed = seed

	w.Nodes = make(map[string]*Node)
	w.Walls = make(map[string]bool)
	w.Unexplored = make(map[string]bool)
	w.NodesWithinMax = make(map[string]bool)

	if !w.isNode(srcX, srcY) {
		log.Fatalf("Error: Source (%d,%d) is not actually a valid node!",srcX, srcY)
	}
	w.Source = w.NewNode(srcX, srcY, 0)

	if !w.isNode(trgX, trgY) {
		log.Fatalf("Error: Target (%d,%d) is not actually a valid node!",trgX, trgY)
	}
	w.Target = w.NewNode(trgX, trgY, RBN)

	return w
}

// isNode(x,y) returns true if a node in our grid is empty (ie, a cubicle) or
// false if not (a wall!)
func (w *World) isNode(x, y int) bool {
	k := nodeKey(x,y)
	if w.Walls[k] {
		return false
	}

	s1 := x*x + 3*x + 2*x*y + y + y*y
	s2 := s1 + w.Seed
	s3a := strconv.FormatInt(int64(s2), 2)
	s3b := len(strings.ReplaceAll(s3a, "0", ""))
	rv := s3b%2 == 0
	if !rv {
		w.Walls[k] = true
	}

	return rv
}

// addNode() is called internally to add the node to the world
func (w *World) addNode(n *Node) {
	k := n.Key()
	w.Nodes[k] = n
	w.Unexplored[k] = true
}

// Node handling

type Node struct {
	X, Y int
	Dist int
}

// w.NewNode() is used to generate a new node. If the specified node is not a
// valid node, it will return nil. If it already exists, it will return the
// existing node instead
func (w *World) NewNode(x int, y int, dist int) *Node {
	if x < 0 || y < 0 {
		return nil
	}

	if !w.isNode(x, y) {
		return nil
	}

	if exist, ok := w.Nodes[nodeKey(x,y)]; ok {
		if exist.Dist == RBN {
			exist.Dist = dist
		}
		return exist
	}

	n := &Node{}
	n.X = x
	n.Y = y
	n.Dist = dist

	w.addNode(n)

	return n
}

func (n *Node) Key() string {
	return nodeKey(n.X, n.Y)
}

func nodeKey(x, y int) string {
	return fmt.Sprintf("%d,%d", x, y)
}