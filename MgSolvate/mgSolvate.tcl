# mgSolvate - fill out primary coordination (octahedral) for Mg ions
#   John Eargle - eargle@uiuc.edu
#   27 Mar 2006
#
# Run mgSolvate inside VMD while your Mg-containing structure is
# the top molecule.  It will produce these files:
#     temp.pdb     temporary file
#     temp2.pdb    temporary file
#     final.pdb    structure with all added O atoms
#     mgWaters.pdb file with only the added O atoms
#
# tRNA-Test.pdb is a structure file that has all the Mg solvation
# cases handled by mgSolvate.


proc mgSolvate {args} {
    global errorInfo errorCode
    set oldcontext [psfcontext new]  ;# new context
    set errflag [catch { eval ::MgSolvate::mgSolvate $args } errMsg]
    set savedInfo $errorInfo
    set savedCode $errorCode
    psfcontext $oldcontext delete  ;# revert to old context
    if $errflag { error $errMsg $savedInfo $savedCode }
    return
}


namespace eval ::MgSolvate:: {

    variable currentMolid 0
    variable currentWaterIndex 0
    variable distanceCutoff 3.0 ;# existing O atoms must be within this distance to be counted
    variable waterDistance 2.2  ;# new O atoms placed this far from Mg

}


proc ::MgSolvate::mgSolvateUsage { } {
    puts "Usage: mgSolvate"
    return
}


proc ::MgSolvate::mgSolvate {args} {

    variable currentMolid
    variable currentWaterIndex
    variable distanceCutoff

    # Print usage information if no arguments are given
    if { [llength $args] < 0} {
	mgSolvateUsage
	error ""
    }

    set mgAtoms [atomselect top "type MG"]
    set currentMolid [$mgAtoms molid]
    set missingWaterList {}
    set totalMissingWaters 0

    # Tally missing waters
    foreach id [$mgAtoms get index] {
	set tempOList [atomselect $currentMolid "mass 15.99 and within $distanceCutoff of index $id"]
	set solvationNumber [$tempOList num]
	$tempOList delete
	puts "solvationNumber: $solvationNumber"
	switch $solvationNumber {
	    0 {
		lappend missingWaterList 6
		incr totalMissingWaters 6
	    }
	    1 {
		lappend missingWaterList 5
		incr totalMissingWaters 5
	    }
	    2 {
		lappend missingWaterList 4
		incr totalMissingWaters 4
	    }
	    3 {
		lappend missingWaterList 3
		incr totalMissingWaters 3
	    }
	    4 {
		lappend missingWaterList 2
		incr totalMissingWaters 2
	    }
	    5 {
		lappend missingWaterList 1
		incr totalMissingWaters 1
	    }
	    6 {
		lappend missingWaterList 0
		puts "All waters present and accounted for: index $id"
	    }
	    default {
		lappend missingWaterList 0
		puts "More than 6 oxygen atoms on index $id"
	    }
	}
    }

    puts "totalMissingWaters: $totalMissingWaters"
    set allAtoms [atomselect $currentMolid "all"]
    $allAtoms writepdb temp.pdb
    $allAtoms delete
    #exec sed "\$d" temp.pdb > temp2.pdb
    set inFile [open "temp.pdb" r]
    set outFile [open "temp2.pdb" w]

    set lastIndex 0
    gets $inFile line
    while {![regexp {END} $line]} {
	if {[regexp {\D+ (\d+)} $line matchVar lineIndex]} {
	    set lastIndex $lineIndex
	    #puts "   lastIndex: $lastIndex"
	} else {
	    puts "   weird line: $line"
	}
	puts $outFile $line
	gets $inFile line
    }
    close $inFile

    # Write added waters to (0 0 0) in temp.pdb
    set lastResid 500
    set lastWaterIndex [expr $lastIndex + $totalMissingWaters]
    for {set i [expr $lastIndex + 1]} {$i <= $lastWaterIndex} {incr i; incr lastResid} {
	puts $outFile [format "ATOM  %5d  O   HOH X%4d       0.000   0.000   0.000  1.00  0.00           QQQ" $i $lastResid]
    }
    puts $outFile "END"
    close $outFile

    mol load pdb "temp2.pdb"
    set currentMolid [molinfo top]

    puts "list lengths"
    puts "     mgAtoms: [$mgAtoms num]"
    puts "     missingWaterList: [llength $missingWaterList]"

    set currentWaterIndex [expr $lastIndex + 1]

    # Move waters from origin to their rightful places around Mg ions
    foreach id [$mgAtoms get index] waterNum $missingWaterList {
	puts "waterNum: $waterNum"
	puts "currentWaterIndex: $currentWaterIndex"
	switch $waterNum {
	    0 {
		puts "All Mgs present and accounted for: index $id"
	    }
	    1 {
		addOneWater $id
	    }
	    2 {
		addTwoWaters $id
	    }
	    3 {
		addThreeWaters $id
	    }
	    4 {
		addFourWaters $id
	    }
	    5 {
		addFiveWaters $id
	    }
	    6 {
		addSixWaters $id
	    }
	    default {
		puts "More than 6 oxygen atoms asked for index $id"
	    }
	}
    }

    set allAtoms [atomselect $currentMolid "all"]
    $allAtoms writepdb "final.pdb"
    $allAtoms delete

    puts "indices: [expr $lastIndex + 1] to [expr $currentWaterIndex - 1]"

    set addedWaters [atomselect $currentMolid "serial [expr $lastIndex + 1] to [expr $currentWaterIndex - 1]"]
    $addedWaters writepdb "mgWaters.pdb"
    $addedWaters delete
    
    return
}


proc ::MgSolvate::addOneWater { index  } {

    variable currentMolid
    variable currentWaterIndex
    variable distanceCutoff
    variable waterDistance

    puts "adding one water"

    set mgSel [atomselect $currentMolid "index $index"]
    set mgLoc [list [$mgSel get x] [$mgSel get y] [$mgSel get z]]
    $mgSel delete

    set waters [atomselect $currentMolid "mass 15.99 and within $distanceCutoff of index $index"]
    set watLocs [$waters get {x y z}]
    $waters delete
    if {[llength $watLocs] != 5} {
	puts "Error: weirdness with water numbers around Mg with index $index"
    }

    set watLoc1 [lindex $watLocs 0]
    set watLoc2 [lindex $watLocs 1]
    set watLoc3 [lindex $watLocs 2]
    set watLoc4 [lindex $watLocs 3]
    set watLoc5 [lindex $watLocs 4]

    set watDir1 [vecnorm [vecsub $watLoc1 $mgLoc]]
    set watDir2 [vecnorm [vecsub $watLoc2 $mgLoc]]
    set watDir3 [vecnorm [vecsub $watLoc3 $mgLoc]]
    set watDir4 [vecnorm [vecsub $watLoc4 $mgLoc]]
    set watDir5 [vecnorm [vecsub $watLoc5 $mgLoc]]

    set watDirs [list $watDir1 $watDir2 $watDir3 $watDir4 $watDir5]

    set pairMap [getWaterPairs $watDirs]
    set pairedNum 0

    for {set i 0} {$i < 5} {incr i} {
	puts "[lindex $pairMap $i]"
    }

    for {set i 0} {$i < 5} {incr i} {
	if {[lindex $pairMap $i] == -1} {
	    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert [lindex $watDirs $i]]]]]
	    $wat delete
	    incr currentWaterIndex
	} else {
	    incr pairedNum
	}
    }

    # pairedNum should only be 4
    if {$pairedNum != 4} {
	puts "Error: addOneWater - pairedNum is the wrong value"
	puts "pairedNum: $pairedNum"
    }

    return
}


proc ::MgSolvate::addTwoWaters { index } {

    variable currentMolid
    variable currentWaterIndex
    variable distanceCutoff
    variable waterDistance

    puts "adding two waters"

    set mgSel [atomselect $currentMolid "index $index"]
    set mgLoc [list [$mgSel get x] [$mgSel get y] [$mgSel get z]]
    $mgSel delete

    set waters [atomselect $currentMolid "mass 15.99 and within $distanceCutoff of index $index"]
    set watLocs [$waters get {x y z}]
    $waters delete
    if {[llength $watLocs] != 4} {
	puts "Error: weirdness with water numbers around Mg with index $index"
    }
    set watLoc1 [lindex $watLocs 0]
    set watLoc2 [lindex $watLocs 1]
    set watLoc3 [lindex $watLocs 2]
    set watLoc4 [lindex $watLocs 3]

    set watDir1 [vecnorm [vecsub $watLoc1 $mgLoc]]
    set watDir2 [vecnorm [vecsub $watLoc2 $mgLoc]]
    set watDir3 [vecnorm [vecsub $watLoc3 $mgLoc]]
    set watDir4 [vecnorm [vecsub $watLoc4 $mgLoc]]

    set watDirs [list $watDir1 $watDir2 $watDir3 $watDir4]

    set pairMap [getWaterPairs $watDirs]
    set pairedNum 0

    for {set i 0} {$i < 4} {incr i} {
	if {[lindex $pairMap $i] == -1} {
	    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert [lindex $watDirs $i]]]]]
	    $wat delete
	    incr currentWaterIndex
	} else {
	    incr pairedNum
	}
    }

    # pairedNum should only be 2 or 4
    puts "pairedNum: $pairedNum"
    if {$pairedNum == 4} {
	set pairedWaterIndex1 -1
	set pairedWaterIndex2 -1

	# get first paired
	for {set i 0} {$i < 3} {incr i} {
	    if {$pairedWaterIndex1 == -1} {
		if {[lindex $pairMap $i] != -1} {
		    set pairedWaterIndex1 $i
		}
	    } else {
		if {[lindex $pairMap $i] != -1 && [lindex $pairMap $i] != $pairedWaterIndex1} {
		    set pairedWaterIndex2 $i
		    break
		}
	    }
	}

	set dir3 [vecnorm [veccross [lindex $watDirs $pairedWaterIndex1] [lindex $watDirs $pairedWaterIndex2]]]

	set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	$wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance $dir3]]]
	$wat delete
	incr currentWaterIndex

	set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	$wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir3]]]]
	$wat delete
	incr currentWaterIndex
    }
    
    return
}


proc ::MgSolvate::addThreeWaters { index } {

    variable currentMolid
    variable currentWaterIndex
    variable distanceCutoff
    variable waterDistance

    puts "adding three waters"

    set mgSel [atomselect $currentMolid "index $index"]
    set mgLoc [list [$mgSel get x] [$mgSel get y] [$mgSel get z]]
    $mgSel delete

    set waters [atomselect $currentMolid "mass 15.99 and within $distanceCutoff of index $index"]
    set watLocs [$waters get {x y z}]
    $waters delete
    if {[llength $watLocs] != 3} {
	puts "Error: weirdness with water numbers around Mg with index $index"
    }
    set watLoc1 [lindex $watLocs 0]
    set watLoc2 [lindex $watLocs 1]
    set watLoc3 [lindex $watLocs 2]

    set watDir1 [vecnorm [vecsub $watLoc1 $mgLoc]]
    set watDir2 [vecnorm [vecsub $watLoc2 $mgLoc]]
    set watDir3 [vecnorm [vecsub $watLoc3 $mgLoc]]

    set watDirs [list $watDir1 $watDir2 $watDir3]

    set pairMap [getWaterPairs $watDirs]
    set pairedNum 0
    
    for {set i 0} {$i < 3} {incr i} {
	if {[lindex $pairMap $i] == -1} {
	    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert [lindex $watDirs $i]]]]]
	    $wat delete
	    incr currentWaterIndex
	} else {
	    incr pairedNum
	}
    }

    # pairedNum should only be 0 or 2
    puts "pairedNum: $pairedNum"
    if {$pairedNum == 2} {
	set pairedWaterIndex -1
	set unpairedWaterIndex -1

	# get first paired
	for {set i 0} {$i < 3} {incr i} {
	    if {[lindex $pairMap $i] != -1} {
		set pairedWaterIndex $i
		break
	    }
	}

	# get unpaired
	for {set i 0} {$i < 3} {incr i} {
	    if {[lindex $pairMap $i] == -1} {
		set unpairedWaterIndex $i
		break
	    }
	}

	set dir3 [vecnorm [veccross [lindex $watDirs $pairedWaterIndex] [lindex $watDirs $unpairedWaterIndex]]]

	set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	$wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance $dir3]]]
	$wat delete
	incr currentWaterIndex

	set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	$wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir3]]]]
	$wat delete
	incr currentWaterIndex
    }
    
    return
}


proc ::MgSolvate::addFourWaters { index } {

    variable currentMolid
    variable currentWaterIndex
    variable distanceCutoff
    variable waterDistance

    puts "adding four waters"

    set mgSel [atomselect $currentMolid "index $index"]
    set mgLoc [list [$mgSel get x] [$mgSel get y] [$mgSel get z]]
    $mgSel delete

    set waters [atomselect $currentMolid "mass 15.99 and within $distanceCutoff of index $index"]
    set watLocs [$waters get {x y z}]
    $waters delete
    if {[llength $watLocs] != 2} {
	puts "Error: weirdness with water numbers around Mg with index $index"
    }
    set watLoc1 [lindex $watLocs 0]
    set watLoc2 [lindex $watLocs 1]

    set watDir1 [vecnorm [vecsub $watLoc1 $mgLoc]]
    set watDir2 [vecnorm [vecsub $watLoc2 $mgLoc]]

    # Two cases: 1) water opposite each other 2) waters next to each other
    if {[veclength [vecadd $watDir1 $watDir2]] < 0.7} {
	set dir1 $watDir1
	set dir2 {0 1 0}
	set dir3 {0 0 1}
	
	set rotationMat [transvec $dir1]
	set dir2 [vectrans $rotationMat $dir2]
	set dir3 [vectrans $rotationMat $dir3]
	
	set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	$wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance $dir2]]]
	$wat delete
	incr currentWaterIndex
	
	set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	$wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance $dir3]]]
	$wat delete
	incr currentWaterIndex
	
	set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	$wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir2]]]]
	$wat delete
	incr currentWaterIndex
	
	set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	$wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir3]]]]
	$wat delete
	incr currentWaterIndex
    } else {
	set dir1 $watDir1
	set dir2 $watDir2
	set dir3 [vecnorm [veccross $dir1 $dir2]]
	
	set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	$wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance $dir3]]]
	$wat delete
	incr currentWaterIndex
	
	set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	$wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir1]]]]
	$wat delete
	incr currentWaterIndex

	set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	$wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir2]]]]
	$wat delete
	incr currentWaterIndex
	
	set wat [atomselect $currentMolid "serial $currentWaterIndex"]
	$wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir3]]]]
	$wat delete
	incr currentWaterIndex
    }

    return
}


proc ::MgSolvate::addFiveWaters { index } {

    variable currentMolid
    variable currentWaterIndex
    variable distanceCutoff
    variable waterDistance

    puts "adding five waters"

    set mgSel [atomselect $currentMolid "index $index"]
    set mgLoc [list [$mgSel get x] [$mgSel get y] [$mgSel get z]]
    $mgSel delete

    set water [atomselect $currentMolid "mass 15.99 and within $distanceCutoff of index $index"]
    set watLoc [$water get {x y z}]
    $water delete
    if {[llength $watLoc] != 1} {
	puts "Error: weirdness with water numbers around Mg with index $index"
    }
    set watLoc1 [lindex $watLoc 0]

    set dir1 [vecnorm [vecsub $watLoc1 $mgLoc]]
    set dir2 {0 1 0}
    set dir3 {0 0 1}

    set rotationMat [transvec $dir1]
    set dir2 [vectrans $rotationMat $dir2]
    set dir3 [vectrans $rotationMat $dir3]

    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance $dir2]]]
    $wat delete
    incr currentWaterIndex

    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance $dir3]]]
    $wat delete
    incr currentWaterIndex

    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir1]]]]
    $wat delete
    incr currentWaterIndex

    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir2]]]]
    $wat delete
    incr currentWaterIndex

    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir3]]]]
    $wat delete
    incr currentWaterIndex

    return
}


proc ::MgSolvate::addSixWaters { index } {

    variable currentMolid
    variable currentWaterIndex
    variable waterDistance

    puts "adding six waters"
    puts "currentMolid: $currentMolid, currentWaterIndex: $currentWaterIndex"

    set dir1 {1 0 0}
    set dir2 {0 1 0}
    set dir3 {0 0 1}

    set mgSel [atomselect $currentMolid "index $index"]
    set mgLoc [list [$mgSel get x] [$mgSel get y] [$mgSel get z]]
    $mgSel delete

    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance $dir1]]]
    $wat delete
    incr currentWaterIndex

    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance $dir2]]]
    $wat delete
    incr currentWaterIndex

    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance $dir3]]]
    $wat delete
    incr currentWaterIndex

    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir1]]]]
    $wat delete
    incr currentWaterIndex

    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir2]]]]
    $wat delete
    incr currentWaterIndex

    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance [vecinvert $dir3]]]]
    $wat delete
    incr currentWaterIndex

    return
}


# Takes a list of water direction vectors (direction relative to the Mg
#   they surround) and pairs those pointing in opposite
#   directions from each other
proc ::MgSolvate::getWaterPairs { watDirs } {

    set numWaters [llength $watDirs]
    if {$numWaters < 1} {
	return 0
    }
    puts "numWaters: $numWaters"

    set pairMap {-1}

    for {set i 1} {$i < $numWaters} {incr i} {
	lappend pairMap -1
    }

    for {set i 0} {$i < [expr $numWaters-1]} {incr i} {
	for {set j [expr $i+1]} {$j < $numWaters} {incr j} {
	    if {[veclength [vecadd [lindex $watDirs $i] [lindex $watDirs $j]]] < 0.7} {
		#puts "HEY!!!"
		if {[lindex $pairMap $i] != -1 || [lindex $pairMap $j] != -1} {
		    puts "Error: getWaterPairs - indices in pairMap are screwed"
		    puts "pairMap($i) = [lindex $pairMap $i], pairMap($j) = [lindex $pairMap $j]"
		} else {
		    set pairMap [lreplace $pairMap $i $i $j]
		    set pairMap [lreplace $pairMap $j $j $i]
		}
	    }
	}
    }

    for {set i 0} {$i < $numWaters} {incr i} {
	puts "  pairMap($i) = [lindex $pairMap $i]"
    }

    return $pairMap
}


proc ::MgSolvate::addOneWater2 { index  } {

    variable currentMolid
    variable currentWaterIndex
    variable distanceCutoff
    variable waterDistance

    puts "adding one water"

    set mgSel [atomselect $currentMolid "index $index"]
    set mgLoc [list [$mgSel get x] [$mgSel get y] [$mgSel get z]]
    $mgSel delete

    set waters [atomselect $currentMolid "mass 15.99 and within $distanceCutoff of index $index"]
    set watLocs [$waters get {x y z}]
    $waters delete
    if {[llength $watLocs] != 5} {
	puts "Error: weirdness with water numbers around Mg with index $index"
    }
    set watLoc1 [lindex $watLocs 0]
    set watLoc2 [lindex $watLocs 1]
    set watLoc3 [lindex $watLocs 2]
    set watLoc4 [lindex $watLocs 3]
    set watLoc5 [lindex $watLocs 4]

    set watDir1 [vecnorm [vecsub $watLoc1 $mgLoc]]
    set watDir2 [vecnorm [vecsub $watLoc2 $mgLoc]]
    set watDir3 [vecnorm [vecsub $watLoc3 $mgLoc]]
    set watDir4 [vecnorm [vecsub $watLoc4 $mgLoc]]
    set watDir5 [vecnorm [vecsub $watLoc5 $mgLoc]]

    set dir1 [vecinvert [vecnorm [vecadd $watDir1 $watDir2 $watDir3 $watDir4 $watDir5]]]

    set wat [atomselect $currentMolid "serial $currentWaterIndex"]
    $wat move [transoffset [vecadd $mgLoc [vecscale $waterDistance $dir1]]]
    $wat delete
    incr currentWaterIndex

    return
}
