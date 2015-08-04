# pdbRewrapBox - recenter a water box around the system of interest and write out pdb and psf files
#   John Eargle
#   Feb 2011

proc pdbRewrapBox { args } {

    if {[llength $args] != 3} {
        puts "Recenter a water box around the system of interest and write out pdb and psf files"
        puts "Usage: pdbRewrapBox molID outputPrefix atomSelectionString"
	puts "  molID: VMD molecule ID"
	puts "  outputPrefix: output filename for new pdb and psf files"
	puts "  atomSelectionString: atomselection string specifying molecule(s) around which to recenter the box"
        error ""
    }
    
    set molId [lindex $args 0]
    set outputPrefix [lindex $args 1]
    set atomSelectString [lindex $args 2]

    set allSel [atomselect $molId "all"]
    $allSel writepdb temp.pdb
    $allSel writepsf temp.psf
    $allSel delete

    mol load psf temp.psf
    mol addfile temp.pdb
    
    set pbcCoord [pbc get -now]

    set centerSel [atomselect top $atomSelectString]
    set centerCoord [measure center $centerSel]
    $centerSel delete
    
    set xNegCutoff [expr [lindex $centerCoord 0] - ([lindex $pbcCoord 0 0] / 2.0)]
    set yNegCutoff [expr [lindex $centerCoord 1] - ([lindex $pbcCoord 0 1] / 2.0)]
    set zNegCutoff [expr [lindex $centerCoord 2] - ([lindex $pbcCoord 0 2] / 2.0)]
    set xPosCutoff [expr [lindex $centerCoord 0] + ([lindex $pbcCoord 0 0] / 2.0)]
    set yPosCutoff [expr [lindex $centerCoord 1] + ([lindex $pbcCoord 0 1] / 2.0)]
    set zPosCutoff [expr [lindex $centerCoord 2] + ([lindex $pbcCoord 0 2] / 2.0)]

    set waterSel [atomselect top "type SOD POT MG or water and not hydrogen"]
    set waterIndices [$waterSel get index]
    $waterSel delete

    set moveSel [atomselect top "same residue as index $waterIndices and x < $xNegCutoff"]
    $moveSel moveby [list [lindex $pbcCoord 0 0] 0.0 0.0]
    $moveSel delete    
    set moveSel [atomselect top "same residue as index $waterIndices and y < $yNegCutoff"]
    $moveSel moveby [list 0.0 [lindex $pbcCoord 0 1] 0.0]
    $moveSel delete
    set moveSel [atomselect top "same residue as index $waterIndices and z < $zNegCutoff"]
    $moveSel moveby [list 0.0 0.0 [lindex $pbcCoord 0 2]]
    $moveSel delete
    set moveSel [atomselect top "same residue as index $waterIndices and x > $xPosCutoff"]
    $moveSel moveby [list [expr -[lindex $pbcCoord 0 0]] 0.0 0.0]
    $moveSel delete    
    set moveSel [atomselect top "same residue as index $waterIndices and y > $yPosCutoff"]
    $moveSel moveby [list 0.0 [expr -[lindex $pbcCoord 0 1]] 0.0]
    $moveSel delete
    set moveSel [atomselect top "same residue as index $waterIndices and z > $zPosCutoff"]
    $moveSel moveby [list 0.0 0.0 [expr -[lindex $pbcCoord 0 2]]]
    $moveSel delete
    
    set allSel [atomselect top "all"]
    $allSel writepdb "$outputPrefix.pdb"
    $allSel writepsf "$outputPrefix.psf"
    $allSel delete
    
    return
}
