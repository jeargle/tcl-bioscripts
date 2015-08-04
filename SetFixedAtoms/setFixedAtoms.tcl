# setFixedAtoms - create the fixed atom files needed for NAMD
#   John Eargle
#   15 Dec 2005

proc setFixedAtoms {} {

    set sel [atomselect top "all"]
    $sel set occupancy 1
    set sel2 [atomselect top "hydrogen"]
    $sel2 set occupancy 0
    $sel writepdb fixed1.pdb

    set sel2 [atomselect top "not (nucleic or protein or type MG or type POT or type CLA or type ZN or type NH3 or type SL)"]
    $sel2 set occupancy 0
    $sel writepdb fixed2.pdb

    set sel2 [atomselect top "not backbone"]
    $sel2 set occupancy 0
    $sel writepdb fixed3.pdb

    return
}


proc setFixedAtomsNucleic {} {

    set sel [atomselect top "all"]
    $sel set occupancy 1
    set sel2 [atomselect top "hydrogen"]
    $sel2 set occupancy 0
    $sel writepdb fixed1.pdb

    set sel2 [atomselect top "not (nucleic or protein or type MG or type POT or type CLA or type ZN or type NH3 or type SL)"]
    $sel2 set occupancy 0
    $sel writepdb fixed2.pdb

    set sel2 [atomselect top "not (backbone or type MG or type POT or type CLA or type ZN)"]
    $sel2 set occupancy 0
    $sel writepdb fixed3.pdb

    set sel2 [atomselect top "not backbone"]
    $sel2 set occupancy 0
    $sel writepdb fixed4.pdb

    return
}


proc setConstrainedAtoms { forceConstant } {

    set sel [atomselect top "all"]
    $sel set occupancy $forceConstant
    set sel2 [atomselect top "hydrogen"]
    $sel2 set occupancy 0
    #$sel writepdb fixed1.pdb

    set sel2 [atomselect top "not (nucleic or protein or type MG or type POT or type CLA or type ZN or type NH3 or type SL)"]
    $sel2 set occupancy 0
    $sel writepdb constraint1.pdb

    set sel2 [atomselect top "not (nucleic or protein)"]
    $sel2 set occupancy 0
    $sel writepdb constraint2.pdb

    set sel2 [atomselect top "not backbone"]
    $sel2 set occupancy 0
    $sel writepdb constraint3.pdb

    return
}

proc setConstrainedAtomsNucleic {} {

    set forceConstant 10

    set sel [atomselect top "all"]
    $sel set occupancy $forceConstant
    set sel2 [atomselect top "hydrogen"]
    $sel2 set occupancy 0
    $sel2 delete

    set sel2 [atomselect top "not (nucleic or protein or type MG or type POT or type CLA or type ZN or type NH3 or type SL)"]
    $sel2 set occupancy 0
    $sel writepdb constraint1.pdb
    $sel2 delete

    set forceConstant 1
    $sel set occupancy $forceConstant
    set sel2 [atomselect top "hydrogen"]
    $sel2 set occupancy 0
    $sel2 delete

    set sel2 [atomselect top "not (backbone or type MG or type POT or type CLA or type ZN or type NH3 or type SL)"]
    $sel2 set occupancy 0
    $sel writepdb constraint2.pdb
    $sel2 delete

    set sel2 [atomselect top "not backbone"]
    $sel2 set occupancy 0
    $sel writepdb constraint3.pdb
    $sel delete
    $sel2 delete

    return
}
