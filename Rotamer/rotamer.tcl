# rotamer.tcl
# Tools for setting the rotamer states of protein and nucleic acid sidechains
# John Eargle
# April 8, 2008

# initSidechainInfo - assign the atom names participating in:
#     1) dihedrals corresponding to specific chi angles
#     2) sidechain atoms that rotate along with these dihedrals
#   rotamers - global array holding all the initialized information
proc initSidechainInfo {} {
    
    variable rotamers

    # Set up 1 dihedral and sidechain
    array set rotamers {}
    # ALA
    set rotamers(ALA,1,dihedral) "N CA CB HB1"
    set rotamers(ALA,1,sidechain) "CB HB1 HB2 HB3"
    set rotamers(ALA,2,dihedral) ""
    set rotamers(ALA,2,sidechain) ""
    set rotamers(ALA,3,dihedral) ""
    set rotamers(ALA,3,sidechain) ""
    set rotamers(ALA,4,dihedral) ""
    set rotamers(ALA,4,sidechain) ""
    # ARG
    set rotamers(ARG,1,dihedral) "N CA CB CG"
    set rotamers(ARG,1,sidechain) "CB HB1 HB2 CG HG1 HG2 CD HD1 HD2 NE HE CZ NH1 HH11 HH12 NH2 HH21 HH22"
    set rotamers(ARG,2,dihedral) "CA CB CG CD"
    set rotamers(ARG,2,sidechain) "CG HG1 HG2 CD HD1 HD2 NE HE CZ NH1 HH11 HH12 NH2 HH21 HH22"
    set rotamers(ARG,3,dihedral) "CB CG CD NE"
    set rotamers(ARG,3,sidechain) "CD HD1 HD2 NE HE CZ NH1 HH11 HH12 NH2 HH21 HH22"
    set rotamers(ARG,4,dihedral) "CG CD NE CZ"
    set rotamers(ARG,4,sidechain) "NE HE CZ NH1 HH11 HH12 NH2 HH21 HH22"
    # ASN
    set rotamers(ASN,1,dihedral) "N CA CB CG"
    set rotamers(ASN,1,sidechain) "CB HB1 HB2 CG OD1 ND2 HD21 HD22"
    set rotamers(ASN,2,dihedral) "CA CB CG OD1"
    set rotamers(ASN,2,sidechain) "CG OD1 ND2 HD21 HD22"
    set rotamers(ASN,3,dihedral) ""
    set rotamers(ASN,3,sidechain) ""
    set rotamers(ASN,4,dihedral) ""
    set rotamers(ASN,4,sidechain) ""
    # ASP
    set rotamers(ASP,1,dihedral) "N CA CB CG"
    set rotamers(ASP,1,sidechain) "CB HB1 HB2 CG OD1 OD2"
    set rotamers(ASP,2,dihedral) "CA CB CG OD1"
    set rotamers(ASP,2,sidechain) "CG OD1 OD2"
    set rotamers(ASP,3,dihedral) ""
    set rotamers(ASP,3,sidechain) ""
    set rotamers(ASP,4,dihedral) ""
    set rotamers(ASP,4,sidechain) ""
    # CYS
    set rotamers(CYS,1,dihedral) "N CA CB SG"
    set rotamers(CYS,1,sidechain) "CB HB1 HB2 SG HG1"
    set rotamers(CYS,2,dihedral) ""
    set rotamers(CYS,2,sidechain) ""
    set rotamers(CYS,3,dihedral) ""
    set rotamers(CYS,3,sidechain) ""
    set rotamers(CYS,4,dihedral) ""
    set rotamers(CYS,4,sidechain) ""
    # GLN
    set rotamers(GLN,1,dihedral) "N CA CB CG"
    set rotamers(GLN,1,sidechain) "CB HB1 HB2 CG HG1 HG2 CD OE1 NE2 HE21 HE22"
    set rotamers(GLN,2,dihedral) "CA CB CG CD"
    set rotamers(GLN,2,sidechain) "CG HG1 HG2 CD OE1 NE2 HE21 HE22"
    set rotamers(GLN,3,dihedral) "CB CG CD OE1"
    set rotamers(GLN,3,sidechain) "CD OE1 NE2 HE21 HE22"
    set rotamers(GLN,4,dihedral) ""
    set rotamers(GLN,4,sidechain) ""
    # GLU
    set rotamers(GLU,1,dihedral) "N CA CB CG"
    set rotamers(GLU,1,sidechain) "CB HB1 HB2 CG HG1 HG2 CD OE1 OE2"
    set rotamers(GLU,2,dihedral) "CA CB CG CD"
    set rotamers(GLU,2,sidechain) "CG HG1 HG2 CD OE1 OE2"
    set rotamers(GLU,3,dihedral) "CB CG CD OE1"
    set rotamers(GLU,3,sidechain) "CD OE1 OE2"
    set rotamers(GLU,4,dihedral) ""
    set rotamers(GLU,4,sidechain) ""
    # GLY
    set rotamers(GLY,1,dihedral) ""
    set rotamers(GLY,1,sidechain) ""
    set rotamers(GLY,2,dihedral) ""
    set rotamers(GLY,2,sidechain) ""
    set rotamers(GLY,3,dihedral) ""
    set rotamers(GLY,3,sidechain) ""
    set rotamers(GLY,4,dihedral) ""
    set rotamers(GLY,4,sidechain) ""
    # HSD
    set rotamers(HSD,1,dihedral) "N CA CB CG"
    set rotamers(HSD,1,sidechain) "CB HB1 HB2 CG ND1 HD1 CD1 HE1 NE2 CD2 HD2"
    set rotamers(HSD,2,dihedral) "CA CB CG ND1"
    set rotamers(HSD,2,sidechain) "CG ND1 HD1 CD1 HE1 NE2 CD2 HD2"
    set rotamers(HSD,3,dihedral) ""
    set rotamers(HSD,3,sidechain) ""
    set rotamers(HSD,4,dihedral) ""
    set rotamers(HSD,4,sidechain) ""
    # HSE
    set rotamers(HSE,1,dihedral) "N CA CB CG"
    set rotamers(HSE,1,sidechain) "CB HB1 HB2 CG ND1 CD1 HE1 NE2 HE2 CD2 HD2"
    set rotamers(HSE,2,dihedral) "CA CB CG ND1"
    set rotamers(HSE,2,sidechain) "CG ND1 CD1 HE1 NE2 HE2 CD2 HD2"
    set rotamers(HSE,3,dihedral) ""
    set rotamers(HSE,3,sidechain) ""
    set rotamers(HSE,4,dihedral) ""
    set rotamers(HSE,4,sidechain) ""
    # HSP
    set rotamers(HSP,1,dihedral) "N CA CB CG"
    set rotamers(HSP,1,sidechain) "CB HB1 HB2 CG ND1 HD1 CD1 HE1 NE2 HE2 CD2 HD2"
    set rotamers(HSP,2,dihedral) "CA CB CG ND1"
    set rotamers(HSP,2,sidechain) "CG ND1 HD1 CD1 HE1 NE2 HE2 CD2 HD2"
    set rotamers(HSP,3,dihedral) ""
    set rotamers(HSP,3,sidechain) ""
    set rotamers(HSP,4,dihedral) ""
    set rotamers(HSP,4,sidechain) ""
    # ILE
    set rotamers(ILE,1,dihedral) "N CA CB CG1"
    set rotamers(ILE,1,sidechain) "CB HB CG1 HG11 HG12 CD HD1 HD2 HD3 CG2 HG21 HG22 HG23"
    set rotamers(ILE,2,dihedral) "CA CB CG1 CD"
    set rotamers(ILE,2,sidechain) "CG1 HG11 HG12 CD HD1 HD2 HD3 CG2 HG21 HG22 HG23"
    set rotamers(ILE,3,dihedral) ""
    set rotamers(ILE,3,sidechain) ""
    set rotamers(ILE,4,dihedral) ""
    set rotamers(ILE,4,sidechain) ""
    # LEU
    set rotamers(LEU,1,dihedral) "N CA CB CG"
    set rotamers(LEU,1,sidechain) "CB HG1 HB2 CG HG CD1 HD11 HD12 HD13 CD2 HD21 HD22 HD23"
    set rotamers(LEU,2,dihedral) "CA CB CG CD1"
    set rotamers(LEU,2,sidechain) "CG HG CD1 HD11 HD12 HD13 CD2 HD21 HD22 HD23"
    set rotamers(LEU,3,dihedral) ""
    set rotamers(LEU,3,sidechain) ""
    set rotamers(LEU,4,dihedral) ""
    set rotamers(LEU,4,sidechain) ""
    # LYS
    set rotamers(LYS,1,dihedral) "N CA CB CG"
    set rotamers(LYS,1,sidechain) "CB HB1 HB2 CG HG1 HG2 CD HD1 HD2 CE HE1 HE2 NZ HZ1 HZ2 HZ3"
    set rotamers(LYS,2,dihedral) "CA CB CG CD"
    set rotamers(LYS,2,sidechain) "CG HG1 HG2 CD HD1 HD2 CE HE1 HE2 NZ HZ1 HZ2 HZ3"
    set rotamers(LYS,3,dihedral) "CB CG CD CE"
    set rotamers(LYS,3,sidechain) "CD HD1 HD2 CE HE1 HE2 NZ HZ1 HZ2 HZ3"
    set rotamers(LYS,4,dihedral) "CG CD CE NZ"
    set rotamers(LYS,4,sidechain) "CE HE1 HE2 NZ HZ1 HZ2 HZ3"
    # MET
    set rotamers(MET,1,dihedral) "N CA CB CG"
    set rotamers(MET,1,sidechain) "CB HB1 HB2 CG HG1 HG2 SD CE HE1 HE2 HE3"
    set rotamers(MET,2,dihedral) "CA CB CG SD"
    set rotamers(MET,2,sidechain) "CG HG1 HG2 SD CE HE1 HE2 HE3"
    set rotamers(MET,3,dihedral) "CB CG SD HE1"
    set rotamers(MET,3,sidechain) "SD CE HE1 HE2 HE3"
    set rotamers(MET,4,dihedral) ""
    set rotamers(MET,4,sidechain) ""
    # PHE
    set rotamers(PHE,1,dihedral) "N CA CB CG"
    set rotamers(PHE,1,sidechain) "CB HB1 HB2 CG CD1 HD1 CE1 HE1 CZ HZ CE2 HE2 CD2 HD2"
    set rotamers(PHE,2,dihedral) "CA CB CG CD1"
    set rotamers(PHE,2,sidechain) "CG CD1 HD1 CE1 HE1 CZ HZ CE2 HE2 CD2 HD2"
    set rotamers(PHE,3,dihedral) ""
    set rotamers(PHE,3,sidechain) ""
    set rotamers(PHE,4,dihedral) ""
    set rotamers(PHE,4,sidechain) ""
    # PRO
    set rotamers(PRO,1,dihedral) ""
    set rotamers(PRO,1,sidechain) ""
    set rotamers(PRO,2,dihedral) ""
    set rotamers(PRO,2,sidechain) ""
    set rotamers(PRO,3,dihedral) ""
    set rotamers(PRO,3,sidechain) ""
    set rotamers(PRO,4,dihedral) ""
    set rotamers(PRO,4,sidechain) ""
    # SER
    set rotamers(SER,1,dihedral) "N CA CB OG"
    set rotamers(SER,1,sidechain) "CB HB1 HB2 OG HG1"
    set rotamers(SER,2,dihedral) ""
    set rotamers(SER,2,sidechain) ""
    set rotamers(SER,3,dihedral) ""
    set rotamers(SER,3,sidechain) ""
    set rotamers(SER,4,dihedral) ""
    set rotamers(SER,4,sidechain) ""
    # THR
    set rotamers(THR,1,dihedral) "N CA CB OG1"
    set rotamers(THR,1,sidechain) "CB HB OG1 HG1 CG2 HG21 HG22 HG23"
    set rotamers(THR,2,dihedral) "CA CB OG1 HG1"
    set rotamers(THR,2,sidechain) "OG1 HG1"
    set rotamers(THR,3,dihedral) "CA CB CG2 HG21"
    set rotamers(THR,3,sidechain) "CG2 HG21 HG22 HG23"
    set rotamers(THR,4,dihedral) ""
    set rotamers(THR,4,sidechain) ""
    # TRP
    set rotamers(TRP,1,dihedral) "N CA CB CG"
    set rotamers(TRP,1,sidechain) "CB HB1 HB2 CG CD1 HD1 NE1 HE1 CD2 CE2 HE3 CE3 CZ2 HZ2 CZ3 HZ3 CH2 HH2"
    set rotamers(TRP,2,dihedral) "CA CB CG CD1"
    set rotamers(TRP,2,sidechain) "CG CD1 HD1 NE1 HE1 CD2 CE2 HE3 CE3 CZ2 HZ2 CZ3 HZ3 CH2 HH2"
    set rotamers(TRP,3,dihedral) ""
    set rotamers(TRP,3,sidechain) ""
    set rotamers(TRP,4,dihedral) ""
    set rotamers(TRP,4,sidechain) ""
    # TYR
    set rotamers(TRP,1,dihedral) "N CA CB CG"
    set rotamers(TRP,1,sidechain) "CB HB1 HB2 CG CD1 HD1 CE1 HE1 CZ OH HH C2 CD2 HE2 HD2"
    set rotamers(TRP,2,dihedral) "CA CB CG CD1"
    set rotamers(TRP,2,sidechain) "CG CD1 HD1 CE1 HE1 CZ OH HH C2 CD2 HE2 HD2"
    set rotamers(TRP,3,dihedral) ""
    set rotamers(TRP,3,sidechain) ""
    set rotamers(TRP,4,dihedral) ""
    set rotamers(TRP,4,sidechain) ""
    # VAL
    set rotamers(VAL,1,dihedral) "N CA CB CG1"
    set rotamers(VAL,1,sidechain) "CB HB CG1 HG11 HG12 HG13 CG2 HG21 HG22 HG23"
    set rotamers(VAL,2,dihedral) ""
    set rotamers(VAL,2,sidechain) ""
    set rotamers(VAL,3,dihedral) ""
    set rotamers(VAL,3,sidechain) ""
    set rotamers(VAL,4,dihedral) ""
    set rotamers(VAL,4,sidechain) ""
    # GAN
    set rotamers(GAN,1,dihedral) "N CA CB CG"
    set rotamers(GAN,1,sidechain) "CB HB1 HB2 CG HG1 HG2 CD OE1 OE2"
    set rotamers(GAN,2,dihedral) "CA CB CG CD"
    set rotamers(GAN,2,sidechain) "CG HG1 HG2 CD OE1 OE2"
    set rotamers(GAN,3,dihedral) "CB CG CD OE1"
    set rotamers(GAN,3,sidechain) "CD OE1 OE2"
    set rotamers(GAN,4,dihedral) ""
    set rotamers(GAN,4,sidechain) ""

    return
}


# readRotamerLibrary - read in rotamer information from one of Dunbrack's libraries
#     http://dunbrack.fccc.edu/bbdep/bbdepformat.php
proc readRotamerLibrary {args} {

    if {[llength $args] != 1} {
        puts "  Read in rotamer information from one of Dunbrack's libraries."
	puts "    http://dunbrack.fccc.edu/bbdep/bbdepformat.php"
        puts "  Usage: readRotamerLibrary libraryFilename"
        error ""
    }
    
    # Parse the arguments.
    set libraryFilename [lindex $args 0]

    # Check that sidechain information has been initialized
    variable rotamers
    if {![array exists rotamers]} {
	initSidechainInfo
    }

    variable rotamerLibrary
    array unset rotamerLibrary
    array set rotamerLibrary {}

    set libraryFile [open $libraryFilename r]

    while {![eof $libraryFile] && [gets $libraryFile line] >= 0} {
        set line [string trim $line]
	
	# if (rotamer line) add rotamer state to rotamerLibrary
	if {[regexp {^(\w{3})(\s\d){4}} $line temp residue]} {
	    # split line and get length of list
	    set line [regsub -all {\s+} $line " "]
	    set line [regsub {\s+$} $line ""]
	    set words [split $line]
	    set wordCount [llength $words]
	    # tortuous tcl for checking if an array has an element
	    set elementCheck [array get rotamerLibrary "$residue,count"]
	    if {$elementCheck == ""} {
		set rotamerLibrary($residue,count) 0
		set rotamerLibrary($residue,index) 0
	    }
	    set index $rotamerLibrary($residue,count)
	    if {$wordCount == 13} {
		set probability [lindex $words 7]
		set angle1 [lindex $words 11]
		set rotamerLibrary($residue,$index) [list $angle1]
		set rotamerLibrary($residue,$index,probability) $probability
		incr rotamerLibrary($residue,count)
	    } elseif {$wordCount == 15} {
		set probability [lindex $words 7]
		set angle1 [lindex $words 11]
		set angle2 [lindex $words 13]
		set rotamerLibrary($residue,$index) [list $angle1 $angle2]
		set rotamerLibrary($residue,$index,probability) $probability
		incr rotamerLibrary($residue,count)
	    } elseif {$wordCount == 17} {
		set probability [lindex $words 7]
		set angle1 [lindex $words 11]
		set angle2 [lindex $words 13]
		set angle3 [lindex $words 15]
		set rotamerLibrary($residue,$index) [list $angle1 $angle2 $angle3]
		set rotamerLibrary($residue,$index,probability) $probability
		incr rotamerLibrary($residue,count)
	    } elseif {$wordCount == 19} {
		set probability [lindex $words 7]
		set angle1 [lindex $words 11]
		set angle2 [lindex $words 13]
		set angle3 [lindex $words 15]
		set angle4 [lindex $words 17]
		set rotamerLibrary($residue,$index) [list $angle1 $angle2 $angle3 $angle4]
		set rotamerLibrary($residue,$index,probability) $probability
		incr rotamerLibrary($residue,count)
	    }
	}
    }

    close $libraryFile

    return
}


proc findAvailableRotamerStates {args} {

    variable rotamerLibrary

    if {[llength $args] != 4} {
        puts "  Cycle through rotamers available in rotamerLibrary and output those that have no steric clashes."
        puts "  Usage: findAvailableRotamerState molID chain resID clashSelectionString"
	puts "    clashSelectionString should identify the set of atoms that should not clash with rotamer states (e.g. chain P)"
        error ""
    }
    
    # Parse the arguments.
    set molId [lindex $args 0]
    set chain [lindex $args 1]
    set resid [lindex $args 2]
    set clashSelString [lindex $args 3]

    set residueSelString "chain $chain and resid $resid"
    set residueSel [atomselect $molId $residueSelString]
    set residue [lindex [$residueSel get resname] 0]
    set clashSel [atomselect $molId "(same residue as $clashSelString and within 1.75 of ($residueSelString and not backbone)) and not ($residueSelString)"]

    set rotamerLibrary($residue,index) 0
    for {set i 0} {$i < $rotamerLibrary($residue,count)} {incr i} {
	getRotamerState $molId $chain $resid $i
	$clashSel update
	display update
	if {[$clashSel num] == 0} {
	    set currentIndex $rotamerLibrary($residue,index)
	    puts "$currentIndex: $chain -- ${residue}${resid}; p($currentIndex): $rotamerLibrary($residue,$currentIndex,probability)"
	}
    }

    set rotamerLibrary($residue,index) 0
    $residueSel delete
    $clashSel delete

    return
}


# cycle through rotamers available in rotamerLibrary
# @param molId molecule ID
# @param chain chain that contains the residue to modify
# @param resid resid of the residue to modify
proc cycleRotamerState {args} {

    variable rotamerLibrary

    if {[llength $args] != 3} {
        puts "  Cycle through rotamers available in rotamerLibrary."
        puts "  Usage: cycleRotamerState molID chain resID"
        error ""
    }
    
    # Parse the arguments.
    set molId [lindex $args 0]
    set chain [lindex $args 1]
    set resid [lindex $args 2]

    set residueSel [atomselect $molId "chain $chain and resid $resid"]
    if {[$residueSel num] == 0} {
	return
    }
    set residue [lindex [$residueSel get resname] 0]

    incr rotamerLibrary($residue,index)
    if {$rotamerLibrary($residue,index) == $rotamerLibrary($residue,count)} {
	set rotamerLibrary($residue,index) 0
    }

    set elementCheck [array get rotamerLibrary "$residue,count"]
    if {$elementCheck == ""} {
	$residueSel delete
	puts "Error(cycleRotamerState): no information for that residue in rotamerLibrary"
	return
    }

    #set currentIndex $rotamerLibrary($residue,index)
    #puts "$currentIndex: $chain -- ${residue}${resid}; p($currentIndex): $rotamerLibrary($residue,$currentIndex,probability)"
    setRotamerState $molId $chain $resid $rotamerLibrary($residue,$rotamerLibrary($residue,index))

    $residueSel delete

    return
}


# setRotamerState - set all dihedral angles for a particular rotamer state
# @param molId molecule ID
# @param chain chain that contains the residue to modify
# @param resid resid of the residue to modify
# @param angles list of angles 1-4; if only first 2 angles are needed, just use a 2-element list
proc setRotamerState {args} {

    if {[llength $args] != 4} {
        puts "  Set all dihedral angles for a particular rotamer state."
        puts "  Usage: setRotamerState molID chain resID {angles}"
        error ""
    }
    
    # Parse the arguments.
    set molId [lindex $args 0]
    set chain [lindex $args 1]
    set resid [lindex $args 2]
    set angles [lindex $args 3]

    set angleNum [llength $angles]

    if {$angleNum > 4} {
	puts "Error(setRotamerState): too many angles in list; angleNum=$angleNum"
	set angleNum 4
    }

    #puts -nonewline "  "
    for {set i 0} {$i < $angleNum} {incr i} {
	setRotamerSubstate $molId $chain $resid [expr $i+1] [lindex $angles $i]
	#puts -nonewline " [lindex $angles $i]"
    }
    #puts ""

    return
}


# change a residue's rotamer state to one from the library
# @param molId molecule ID
# @param chain chain that contains the residue to modify
# @param resid resid of the residue to modify
# @param rotamerState index of rotamer state in the library
proc getRotamerState {args} {

    variable rotamerLibrary

    if {[llength $args] != 4} {
        puts "  Change a residue's rotamer state to one from the library."
        puts "  Usage: getRotamerState molID chain resID rotamerState"
        error ""
    }
    
    # Parse the arguments.
    set molId [lindex $args 0]
    set chain [lindex $args 1]
    set resid [lindex $args 2]
    set rotamerState [lindex $args 3]

    set residueSel [atomselect $molId "chain $chain and resid $resid"]
    if {[$residueSel num] == 0} {
	return
    }
    set residue [lindex [$residueSel get resname] 0]

    if {$rotamerState > $rotamerLibrary($residue,count)} {
	$residueSel delete
	puts "Error(getRotamerState): rotamer state not in rotamerLibrary; last rotamer state: $rotamerLibrary($residue,count)"
	return
    }

    set elementCheck [array get rotamerLibrary "$residue,count"]
    if {$elementCheck == ""} {
	$residueSel delete
	puts "Error(getRotamerState): no information for that residue in rotamerLibrary"
	return
    }

    set rotamerLibrary($residue,index) $rotamerState
    #puts "$rotamerLibrary($residue,index): $chain -- ${residue}${resid}"
    setRotamerState $molId $chain $resid $rotamerLibrary($residue,$rotamerState)

    $residueSel delete
    
    return
}


# set one rotamer-specific dihedral angle for a residue
# @param molId molecule ID
# @param chain chain that contains the residue to modify
# @param resid resid of the residue to modify
# @param rotamer rotamer state to change {1,2,3,4}
# @param newAngle angle the dihedral should be changed to
proc setRotamerSubstate {args} {

    variable rotamers

    if {[llength $args] != 5} {
        puts "  Set one rotamer-specific dihedral angle for a residue."
        puts "  Usage: setRotamerSubstate molID chain resID rotamer newAngle"
        error ""
    }
    
    # Parse the arguments.
    set molId [lindex $args 0]
    set chain [lindex $args 1]
    set resid [lindex $args 2]
    set rotamer [lindex $args 3]
    set newAngle [lindex $args 4]

    set residueSel [atomselect $molId "chain $chain and resid $resid"]
    set residueName [lindex [$residueSel get resname] 0]
    $residueSel delete

    if {$rotamers($residueName,$rotamer,dihedral) != ""} {
	set dihedralAtomSel [atomselect $molId "chain $chain and resid $resid and name $rotamers($residueName,$rotamer,dihedral)"]
	set dihedralAtomList [$dihedralAtomSel get index]
	#puts "$dihedralAtomList"
	$dihedralAtomSel delete
	
	set sidechain "chain $chain and resid $resid and name $rotamers($residueName,$rotamer,sidechain)"
	#puts "$sidechain"
	
	setDihedral $molId $dihedralAtomList $newAngle $sidechain
    }

    return
}


# get one rotamer-specific dihedral angle for a residue
# @param molId molecule ID
# @param chain chain that contains the residue to modify
# @param resid resid of the residue to modify
# @param rotamer rotamer state to get {1,2,3,4}
# @param angle angle the dihedral should be changed to
# @return dihedral angle in degrees
proc getRotamerSubstate {args} {

    variable rotamers

    if {[llength $args] != 4} {
        puts "  Get one rotamer-specific dihedral angle for a residue."
        puts "  Usage: getRotamerSubstate molID chain resID rotamer"
        error ""
    }
    
    # Parse the arguments.
    set molId [lindex $args 0]
    set chain [lindex $args 1]
    set resid [lindex $args 2]
    set rotamer [lindex $args 3]

    set residueSel [atomselect $molId "chain $chain and resid $resid"]
    set residueName [lindex [$residueSel get resname] 0]
    $residueSel delete

    set dihedralAtomSel [atomselect $molId "resid $resid and name $rotamers($residueName,$rotamer,dihedral)"]
    set dihedralAtomList [$dihedralAtomSel get index]
    $dihedralAtomSel delete

    set angle getDihedral {$molId $dihedralAtomList}

    return $angle
}


# set one dihedral angle for a residue
# @param molId molecule ID
# @param dihedralAtomList list of dihedral atom indices
# @param newAngle angle that dihedral should be set to
# @param sidechain atomselection string for sidechain atoms that should be rotated
proc setDihedral {args} {

    if {[llength $args] != 4} {
        puts "  Set one dihedral angle for a residue."
        puts "  Usage: setDihedral molID dihedralAtomList newAngle sidechain"
        error ""
    }
    
    # Parse the arguments.
    set molId [lindex $args 0]
    set dihedralAtomList [lindex $args 1]
    set newAngle [lindex $args 2]
    set sidechain [lindex $args 3]

    label delete Dihedrals
    label add Dihedrals $molId/[lindex $dihedralAtomList 0] \
	$molId/[lindex $dihedralAtomList 1] \
	$molId/[lindex $dihedralAtomList 2] \
	$molId/[lindex $dihedralAtomList 3]
    set dihedralLabel [label list Dihedrals]
    set currentAngle [lindex [lindex $dihedralLabel 0] 4]
    set offsetAngle [expr $newAngle - $currentAngle]
    
    set atom2 [atomselect $molId "index [lindex [lindex [lindex $dihedralLabel 0] 1] 1]"]
    set atom3 [atomselect $molId "index [lindex [lindex [lindex $dihedralLabel 0] 2] 1]"]

    set coord1 [lindex [$atom2 get {x y z}] 0]
    set coord2 [lindex [$atom3 get {x y z}] 0]
    
    $atom2 delete
    $atom3 delete
    
    set sidechainSel [atomselect $molId $sidechain]
    $sidechainSel move [trans bond $coord1 $coord2 $offsetAngle deg]
    $sidechainSel delete
    
    #puts "offsetAngle: $offsetAngle"

    return
}


# get one dihedral angle for a residue
# @param molId molecule ID
# @param dihedralAtomList list of dihedral atom indices
# @return dihedral angle in degrees
proc getDihedral {args} {

    if {[llength $args] != 2} {
        puts "  Get one dihedral angle for a residue."
        puts "  Usage: getDihedral molID dihedralAtomList"
        error ""
    }
    
    # Parse the arguments.
    set molId [lindex $args 0]
    set dihedralAtomList [lindex $args 1]

    label delete Dihedrals
    label add Dihedrals $molId/[lindex $dihedralAtomList 0] \
	$molId/[lindex $dihedralAtomList 1] \
	$molId/[lindex $dihedralAtomList 2] \
	$molId/[lindex $dihedralAtomList 3]
    set dihedralLabel [label list Dihedrals]
    set angle [lindex [lindex $dihedralLabel 0] 4]
    
    return $angle
}


# get a list of indices for all atoms with atom labels
# @param molId molecule ID
# @param labelIndices list of atom indices
# @return list of indices
proc getAtomLabelIndices {args} {

    if {[llength $args] != 1} {
        puts "  Get a list of indices for all atoms with atom labels."
        puts "  Usage: getAtomLabelIndices molID"
        error ""
    }
    
    # Parse the arguments.
    set molId [lindex $args 0]
    
    set labelIndices {}
    foreach atomLabel [label list Atoms] {
	if {[lindex [lindex $atomLabel 0] 0] == $molId} {
	    lappend labelIndices [lindex [lindex $atomLabel 0] 1]
	}
    }

    return $labelIndices
}


# rotateRotamerSubstate
proc rotateRotamerSubstate {args} {

    if {[llength $args] != 5} {
        puts "  Rotate fully around a rotamer angle.  For dihedral visualization."
        puts "  Usage: rotateRotamerSubstate molID chain resID rotamer stepSize"
        error ""
    }

    # Parse the arguments.
    set molId [lindex $args 0]
    set chain [lindex $args 1]
    set resid [lindex $args 2]
    set rotamer [lindex $args 3]
    set stepSize [lindex $args 4]    

    for {set angle -180} {$angle <= 180} {incr angle $stepSize} {
	setRotamerSubstate 0 $chain $resid $rotamer $angle
	display update
	after 50
    }

    return
}


# rotateRotamerSubstate2
proc rotateRotamerSubstate2 {args} {

    if {[llength $args] != 4} {
        puts "  Rotate fully around a rotamer angle.  For dihedral visualization."
        puts "  Usage: rotateRotamerSubstate2 molID dihedralAtomList sidechain stepSize"
        error ""
    }

    # Parse the arguments.
    set molId [lindex $args 0]
    set dihedralAtomList [lindex $args 1]
    set sidechain [lindex $args 2]
    set stepSize [lindex $args 3]

    for {set i -180} {$i <= 180} {set i [expr $i + $stepSize]} {
	setDihedral 0 $dihedralAtomList $i $sidechain
	display update
	after 50
    }

    return
}


# rotateRotamerState
proc rotateRotamerState {molId chain resid stepSize} {

    if {[llength $args] != 4} {
        puts "  Rotate fully around all rotamer angles.  For dihedral visualization."
        puts "  Usage: rotateRotamerState molID chain resID stepSize"
        error ""
    }

    # Parse the arguments.
    set molId [lindex $args 0]
    set chain [lindex $args 1]
    set resid [lindex $args 2]
    set stepSize [lindex $args 3]

    for {set angle -180} {$angle <= 180} {incr angle $stepSize} {
	setRotamerSubstate 0 $chain $resid 1 $angle
	setRotamerSubstate 0 $chain $resid 2 [expr ($angle * 2) - 180]
	setRotamerSubstate 0 $chain $resid 3 [expr $angle * 3]
	setRotamerSubstate 0 $chain $resid 4 [expr ($angle * 4) - 180]
	display update
	#after 5
    }

    return
}
