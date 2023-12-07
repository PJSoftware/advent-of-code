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
	Elerium
	Dilithium
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
		name = "h"
	case Lithium:
		name = "l"
	case Strontium:
		name = "s"
	case Plutonium:
		name = "p"
	case Thulium:
		name = "t"
	case Ruthenium:
		name = "r"
	case Curium:
		name = "c"
	case Elerium:
		name = "e"
	case Dilithium:
		name = "d"
	}

	switch eq.Type {
	case Generator:
		name += "g"
	case Microchip:
		name += "m"
	}

	return name
}