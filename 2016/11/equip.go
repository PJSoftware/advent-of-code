package main

type Element int

const (
	Hydrogen Element = iota
	Lithium
	Strontium
	Plutonium
	Thulium
	Ruthenium
	Curium
)

type EquipType int

const (
	Generator EquipType = iota
	Microchip
)

type Equip struct {
	Type    EquipType
	Element Element
	OnFloor Floor
}

func NewEquip(el Element, et EquipType) *Equip {
	eq := &Equip{}
	eq.Element = el
	eq.Type = et
	return eq
}

func (eq *Equip) Name() string {
	name := ""

	switch eq.Element {
	case Hydrogen:
		name = "hydrogen"
	case Lithium:
		name = "lithium"
	case Strontium:
		name = "strontium"
	case Plutonium:
		name = "plutonium"
	case Thulium:
		name = "thulium"
	case Ruthenium:
		name = "ruthenium"
	case Curium:
		name = "curium"
	}

	switch eq.Type {
	case Generator:
		name += " generator"
	case Microchip:
		name += "-compatible microchip"
	}

	return name
}