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
	nodes map[int]*Node
	Paths map[string]*Path

	keys  map[string]int
	names map[string]int

	nodeList []int
	nodeType graphNodeType
}

// Nodes have an Index (used to access them quickly via the Graph) and a Value.
// They can also contain an optional Key and/or Name. (Typically a Key might
// represent coordinates or similar, and Name might be a location name.)
// Finally, each Node maintains a list of all Paths which lead from it.
type Node struct {
	Index int
	Value any
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
	g.nodes = make(map[int]*Node)
	g.keys = make(map[string]int)
	g.names = make(map[string]int)
	g.nodeType = undefined
	return g
}

// Nodes() returns the list of all node indices belonging to the graph
func (g *Graph) Nodes() []int {
	return g.nodeList
}

// AddAnonymousNode() adds an anonymous node to the graph, using the specified index, and
// sets the node's value. AddAnonymousNode() and AddIdentifiedNode() are not
// compatible.
func (g *Graph) AddAnonymousNode(index int, value any) error {
	if g.nodeType == identified {
		return fmt.Errorf("may not mix calls to AddIdentifiedNode() and AddAnonymousNode()")
	}
	if _, exists := g.nodes[index]; exists {
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
func (g *Graph) AddIdentifiedNode(key string, name string, value any) error {
	if g.nodeType == anonymous {
		panic("may not mix calls to AddAnonymousNode() and AddIdentifiedNode()")
	}

	if key == "" && name == "" {
		return fmt.Errorf("must specify at least one of name or key")
	}

	if key != "" {
		if _, exists := g.keys[key]; exists {
			return fmt.Errorf("key '%s' already exists in graph", key)
		}
		if _, exists := g.names[key]; exists {
			return fmt.Errorf("key '%s' matches a Name already used in graph", key)
		}
	}
	if name != "" {
		if _, exists := g.names[name]; exists {
			return fmt.Errorf("name '%s' already exists in graph", name)
		}
		if _, exists := g.keys[name]; exists {
			return fmt.Errorf("name '%s' matches a Key already used in graph", name)
		}
	}

	g.nodeType = identified
	index := len(g.nodes) + 1
	g.addNode(index, value)

	if key != "" {
		g.keys[key] = index
		g.nodes[index].Key = key
	}
	if name != "" {
		g.names[name] = index
		g.nodes[index].Name = name
	}
	return nil
}

// addNode() creates a new node and adds it to the graph
func (g *Graph) addNode(index int, value any) {
	n := &Node{}
	n.Index = index
	n.Value = value
	n.Paths = make(map[int]*Path)
	g.nodes[index] = n
	g.nodeList = append(g.nodeList, index)
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
	g.nodes[from].Paths[to] = path
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
	g.nodes[n1].Paths[n2] = path
	g.nodes[n2].Paths[n1] = path
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
		if _, exists := g.nodes[idx]; !exists {
			return 0, fmt.Errorf("index %d does not exist in graph", idx)
		}
	
		return idx, nil
	}

	if g.nodeType == identified {
		var str string
		if idxNamed, ok := ident.(int); ok {
			if _, exists := g.nodes[idxNamed]; !exists {
				return 0, fmt.Errorf("index %d does not exist in graph", idxNamed)
			}
			return idxNamed, nil
		}
		if str, ok = ident.(string); !ok {
			return 0, fmt.Errorf("string identifier expected for identified nodes; '%v' is a %T", ident, ident)
		}
		if idx, exists := g.names[str]; exists {
			return idx, nil
		}
		if idx, exists := g.keys[str]; exists {
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

	for idx := range g.nodes[index].Paths {
		result = append(result, idx)
	}

	return result
}

// Names() returns a slice of all node names
func (g *Graph) Names() []string {
	names := make([]string, 0, len(g.names))
	for name := range g.names {
		names = append(names, name)
	}
	return names
}

// NodeByName() returns the index of the node with the specified name. It
// returns an error if the name specified does not exist.
func (g *Graph) NodeByName(name string) (int, error) {
	idx, exists := g.names[name]
	if !exists {
		return 0, fmt.Errorf("node with name '%s' does not exist", name)
	}
	return idx, nil
}

// Keys() returns a slice of all node keys
func (g *Graph) Keys() []string {
	keys := make([]string, 0, len(g.keys))
	for key := range g.keys {
			keys = append(keys, key)
	}
	return keys
}

// SetAllNodeValues() sets the value of all nodes in the graph
func (g *Graph) SetAllNodeValues(value any) {
	for _, node := range(g.nodes) {
		node.Value = value
	}
}

// SetNodeValue() sets the value of the specified node
func (g *Graph) SetNodeValue(index int, value any) {
	g.nodes[index].Value = value
}

// NodeValue() returns the value of the specified node
func (g *Graph) NodeValue(index int) any {
	return g.nodes[index].Value
}

// NodeName() returns the name of the specified node
func (g *Graph) NodeName(index int) string {
	return g.nodes[index].Name
}

// PathLength() returns the length of the direct path from NodeA to NodeB. If
// the specified path is not defined, it returns an error
func (g *Graph) PathLength(node1, node2 any) (int, error) {
	var n1, n2 int
	var err error
	if n1, err = g.identifyNode(node1); err != nil {
		return -1, err
	}	
	if n2, err = g.identifyNode(node2); err != nil {
		return -1, err
	}

	node := g.nodes[n1]
	if path, ok := node.Paths[n2]; ok {
		return path.Weight, nil
	}
	
	return -1, fmt.Errorf("path between nodes '%v' and '%v' not found", node1, node2)
}