package graph

import "fmt"

type graphNodeType int

const (
	undefined graphNodeType = iota
	anonymous
	identified
)

// Graph is the master data structure. A Graph consists of Nodes linked by
// Paths. The Graph data structure maintains a list of all Nodes, and a list
// of all Paths. It also maintains an index of all Nodes' Keys, and Names where
// relevant.
type Graph struct {
	Nodes map[int]*Node
	Paths map[string]*Path

	Keys  map[string]int
	Names map[string]int

	nodeType graphNodeType
}

// Nodes have an Index (used to access them quickly via the Graph) and a Value.
// They can also contain an optional Key and/or Name. (Typically a Key might
// represent coordinates or similar, and Name might be a location name.)
// Finally, each Node maintains a list of all Paths which lead from it.
type Node struct {
	Index int
	Value int
	Key   string
	Name  string
	Paths map[int]*Path
}

// Paths have an optional Weight (for a weighted graph) and may be Directed
// or not (ie, undirected)
type Path struct {
	Weight       int
	Directed     bool
	NodeA, NodeB int
}

func NewGraph() *Graph {
	g := &Graph{}
	g.Paths = make(map[string]*Path)
	g.Nodes = make(map[int]*Node)
	g.Keys = make(map[string]int)
	g.Names = make(map[string]int)
	g.nodeType = undefined
	return g
}

// AddAnonymousNode() adds an anonymous node to the graph, using the specified index, and
// sets the node's value. AddAnonymousNode() and AddIdentifiedNode() are not
// compatible.
func (g *Graph) AddAnonymousNode(index, value int) error {
	if g.nodeType == identified {
		return fmt.Errorf("may not mix calls to AddIdentifiedNode() and AddAnonymousNode()")
	}
	if _, exists := g.Nodes[index]; exists {
		return fmt.Errorf("index %d already exists in graph", index)
	}

	g.nodeType = anonymous
	g.addNode(index, value)
	return nil
}

// AddIdentifiedNode() adds a node to the graph with specific unique
// identifiers. It can set either a Key, or a Name. (Typically a Key might
// represent coordinates or similar, and Name might be a location name.) It will
// generate a unique index for the node, and hence AddAnonymousNode() and
// AddIdentifiedNode() are not compatible.
//
// AddIdentifiedNode() ensures that both the Key and Name are not only unique,
// but that there is no crossover between the two. Names may not be used as
// Keys, and vice versa.
func (g *Graph) AddIdentifiedNode(key string, name string, value int) error {
	if g.nodeType == anonymous {
		panic("may not mix calls to AddAnonymousNode() and AddIdentifiedNode()")
	}

	if key == "" && name == "" {
		return fmt.Errorf("must specify at least one of name or key")
	}

	if key != "" {
		if _, exists := g.Keys[key]; exists {
			return fmt.Errorf("key '%s' already exists in graph", key)
		}
		if _, exists := g.Names[key]; exists {
			return fmt.Errorf("key '%s' matches a Name already used in graph", key)
		}
	}
	if name != "" {
		if _, exists := g.Names[name]; exists {
			return fmt.Errorf("name '%s' already exists in graph", name)
		}
		if _, exists := g.Keys[name]; exists {
			return fmt.Errorf("name '%s' matches a Key already used in graph", name)
		}
	}

	g.nodeType = identified
	index := len(g.Nodes) + 1
	g.addNode(index, value)

	if key != "" {
		g.Keys[key] = index
	}
	if name != "" {
		g.Names[name] = index
	}
	return nil
}

// addNode() creates a new node and adds it to the graph
func (g *Graph) addNode(index, value int) {
	n := &Node{}
	n.Index = index
	n.Value = value
	n.Paths = make(map[int]*Path)
	g.Nodes[index] = n
}

// AddDirectedPath adds a one-directional path from <fromNode> to <toNode>.
//
// The <fromNode> and <toNode> parameters may be either a valid node index (for
// an anonymous-node graph), or a key or name (for an identified-node graph).
func (g *Graph) AddDirectedPath(fromNode, toNode any, weight int) error {
	var from, to int
	var err error

	if from, err = g.identifyNode(fromNode); err != nil {
		return err
	}	
	if to, err = g.identifyNode(toNode); err != nil {
		return err
	}

	pathKey := g.directedPathKey(from, to)
	if _, exists := g.Paths[pathKey]; exists {
		return fmt.Errorf("path from node #%d to node #%d exists", from, to)
	}

	path := g.addPath(from, to, weight, true, pathKey)
	g.Nodes[from].Paths[to] = path
	return nil
}

// AddPathBetween adds a bi-directional path between <node1> to <node2>.
//
// The <node1> and <node2> parameters may be either a valid node index (for
// an anonymous-node graph), or a key or name (for an identified-node graph).
func (g *Graph) AddPathBetween(node1, node2 any, weight int) error {
	var n1, n2 int
	var err error

	if n1, err = g.identifyNode(node1); err != nil {
		return err
	}	
	if n2, err = g.identifyNode(node2); err != nil {
		return err
	}

	pathKey := g.undirectedPathKey(n1, n2)
	if _, exists := g.Paths[pathKey]; exists {
		return fmt.Errorf("path between nodes #%d and #%d exists", n1, n2)
	}

	path := g.addPath(n1, n2, weight, true, pathKey)
	g.Nodes[n1].Paths[n2] = path
	g.Nodes[n2].Paths[n1] = path
	return nil
}

// directedPathKey() generates a key for the directed path from n1 to n2
func (g *Graph) directedPathKey(n1, n2 int) string {
	return fmt.Sprintf("%d>%d", n1, n2)
}

// undirectedPathKey() generates a key for the undirected path between n1 and n2
func (g *Graph) undirectedPathKey(n1, n2 int) string {
	if n1 > n2 { n2, n1 = n1, n2 }
	return fmt.Sprintf("%d-%d", n1, n2)
}

// identifyNode() converts a valid node identifier (int for anonymous, string --
// either name or key -- for identified) into a node index
func (g *Graph) identifyNode(ident any) (int, error) {
	var ok bool

	if g.nodeType == anonymous {
		var idx int
		if idx, ok = ident.(int); !ok {
			return 0, fmt.Errorf("int identifier expected for anonymous nodes; '%v' is a %T", ident, ident)
		}
		if _, exists := g.Nodes[idx]; !exists {
			return 0, fmt.Errorf("index %d does not exist in graph", idx)
		}
	
		return idx, nil
	}

	if g.nodeType == identified {
		var str string
		if str, ok = ident.(string); !ok {
			return 0, fmt.Errorf("string identifier expected for identified nodes; '%v' is a %T", ident, ident)
		}
		if idx, exists := g.Names[str]; exists {
			return idx, nil
		}
		if idx, exists := g.Keys[str]; exists {
			return idx, nil
		}
		return 0, fmt.Errorf("specified ident '%s' does not exist as either name or key", str)
	}

	return 0, fmt.Errorf("graph type has not yet been initialised; no nodes added")
}

// addPath() creates a new path with the specified parameters and adds it to the
// graph
func (g *Graph) addPath(src, dest int, weight int, directed bool, key string) *Path {
	p := &Path{}
	p.Weight = weight
	p.Directed = directed
	p.NodeA = src
	p.NodeB = dest
	g.Paths[key] = p
	return p
}

// Neighbours() returns a list of the indices of all nodes reachable from the
// specified node
func (g *Graph) Neighbours(index int) []int {
	result := []int{}

	for idx := range g.Nodes[index].Paths {
		result = append(result, idx)
	}

	return result
}
