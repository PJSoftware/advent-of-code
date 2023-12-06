package main

type Element int

const (
	NoElement Element = iota
	Hydrogen
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
	Safety  Safety
	OnFloor Floor
}

func NewEquip(el Element, et EquipType) *Equip {
	eq := &Equip{}
	eq.Element = el
	eq.Type = et
	if et == Generator {
		eq.Safety = AlwaysSafe
	} else {
		eq.Safety = Unprotected
	}
	return eq
}