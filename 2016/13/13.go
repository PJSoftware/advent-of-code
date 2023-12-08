package main

import (
	"fmt"
	"log"

	"github.com/pjsoftware/advent-of-code/2016/lib/advent"
)

type Dir struct {
	X,Y int
}

var Directions = []*Dir{
	{0,1},	// Up
	{0,-1},	// Down
	{-1,0},	// Left
	{1,0},	// Right
}

func main() {
	// Tests

	fmt.Print("Starting Tests:\n\n")
	testWorld := NewWorld(1, 1, 7, 4, 10)

	advent.Test("Test Maze Solution", 11, testWorld.MazeSolver(0))
	advent.BailOnFail()
	fmt.Print("All tests passed!\n\n")

	// Solution

	world := NewWorld(1, 1, 31, 39, 1358)
	fmt.Printf("Solution: %d\n", world.MazeSolver(50))
	fmt.Printf("Part 2: %d nodes within 50 steps\n", len(world.NodesWithinMax))
}

// Solution code

// MazeSolver() is my first ever attempt at coding Dijkstra's algorithm for path
// finding -- while actually generating the maze at the same time. The primary
// assumption is that diagonal moves are not possible; the only possible moves
// are N/S/E/W (or Up/Down/Left/Right) Incorporating the generator into the
// solver (with the added assumption that our start and end points are empty
// space) allows us to only generate the nodes we need to solve the puzzle.
func (w *World) MazeSolver(maxDist int) int {
	node := w.NearestUnexploredNode()
	for node != nil {
		fmt.Printf("Nearest Unexplored: (%s) -> %d\n", node.Key(), node.Dist)
		
		if node.Dist <= maxDist {
			w.NodesWithinMax[node.Key()] = true
		}

		if node.Dist == RBN {
			log.Fatalf("Unexpectedly returned target node with distance not determined!")
		}
		
		if node.X == w.Target.X && node.Y == w.Target.Y {
			return node.Dist
		}

		w.GenerateNeighbours(node)
		w.HasBeenExplored(node)
		node = w.NearestUnexploredNode()
	}

	return 0
}

func (w *World) NearestUnexploredNode() *Node {
	dist := RBN
	var node *Node
	node = nil

	for k := range(w.Unexplored) {
		fmt.Printf("> %s\n", k)
		n := w.Nodes[k]
		if n.Dist < dist {
			dist = n.Dist
			node = n
		}
	}

	return node
}

func (w *World) HasBeenExplored(node *Node) {
	delete(w.Unexplored,node.Key())
}

func (w *World) GenerateNeighbours(node *Node) {
	for _, dir := range(Directions) {
		w.NewNode(node.X + dir.X, node.Y + dir.Y, node.Dist+1)
	}
}