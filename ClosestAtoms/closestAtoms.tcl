# closestAtoms - compare atomSet1 to atomSet2 and produce a list of correspondences
#   between the two sets, the atoms in atomSet2 that are closest to the each atom
#   of atomSet1
#     atomSet1: atomselect
#     atomSet2: atomselect
#     outFile:  file for correspondence and distance info
#   John Eargle
#   28 Jan 2006

proc closestAtoms { args } {

    if {[llength $args] < 2 || [llength $args] > 3} {
        puts "Compare atomSet1 to atomSet2 and produce a list of correspondences."
        puts "Usage: closestAtoms atomSet1 atomSet2 \[outFile\]"
        error ""
    }

    #Parse the arguments.
    set atomSet1 [lindex $args 0]
    set atomSet2 [lindex $args 1]
    set outputFileName ""

    if {[llength $args] == 3} {
	set outputFileName [lindex $args 2]
    }

    #set outputFileName $outFile

    set mol1 [$atomSet1 molid]
    set mol2 [$atomSet2 molid]

    set indices1 [$atomSet1 list]
    set indices2 [$atomSet2 list]

    set length1 [$atomSet1 num]
    set length2 [$atomSet2 num]

    #set distances1 [lrepeat $length1 1000]
    set distances1 [list 1000]
    for {set i 1} {$i < $length1} {incr i} {
	lappend distances1 1000
    }
    #set distances2 [lrepeat $length2 1000]

    #set closestAtom [lrepeat $length1 -1]
    set closestAtom [list -1]
    for {set i 1} {$i < $length1} {incr i} {
	lappend closestAtom -1
    }

    for {set i 0} {$i < $length1} {incr i} {
	set atom1 [atomselect $mol1 "index [lindex $indices1 $i]"]
	for {set j 0} {$j < $length2} {incr j} {
	    set atom2 [atomselect $mol2 "index [lindex $indices2 $j]"]
	    set tempDist [measure rmsd $atom1 $atom2]
	    if {$tempDist < [lindex $distances1 $i]} {
		#puts "i:$i, j:$j, index1:[lindex $indices1 $i], index2:[lindex $indices2 $j], tempDist:$tempDist, dist: [lindex $distances1 $i]"
		puts "index1:[lindex $indices1 $i], index2:[lindex $indices2 $j], tempDist:$tempDist, dist: [lindex $distances1 $i]"
		lset distances1 $i $tempDist
		lset closestAtom $i [lindex $indices2 $j]
	    }
	    $atom2 delete
	}
	$atom1 delete
    }
    puts ""

    set outputFile ""
    if {$outputFileName == ""} {
	set outputFile stdout
    } else {
	set outputFile [open $outputFileName w]
    }

    puts $outputFile "Resid1  Index1  Resid2  Index2  Distance"
    puts $outputFile "----------------------------------------"

    for {set i 0} {$i < $length1} {incr i} {
	set atom1 [atomselect $mol1 "index [lindex $indices1 $i]"]
	set closestAtomIndex [lindex $closestAtom $i]
	set atom2 [atomselect $mol2 "index [lindex $closestAtom $i]"]
	puts $outputFile [format "%6d  %6d  %6d  %6d  %8.2f" \
			      [$atom1 get resid] [$atom1 get index] \
			      [$atom2 get resid] [$atom2 get index] \
			      [lindex $distances1 $i]]
	$atom1 delete
	$atom2 delete
    }
    
    if {$outputFileName != ""} {
	close $outputFile
    }

    return
}

# Like closestAtoms except over a trajectory
proc closestAtoms2 { molid selString1 selString2 outFile } {

    set outputFileName $outFile

    set mol1 $molid
    set mol2 $molid

    set atomSet1 [atomselect $mol1 $selString1]
    set atomSet2 [atomselect $mol2 $selString2]
    set indices1 [$atomSet1 list]
    set indices2 [$atomSet2 list]
    set resids1 [$atomSet1 get resid]
    set resids2 [$atomSet2 get resid]
    set length1 [$atomSet1 num]
    set length2 [$atomSet2 num]
    
    $atomSet1 delete
    $atomSet2 delete

    set numFrames [molinfo $mol1 get numframes]

    set outputFile [open $outputFileName w]
    puts $outputFile "Resid1  Index1  Resid2  Index2  Distance"
    #puts $outputFile "----------------------------------------"

    for {set frame 0} {$frame < $numFrames} {incr frame} {
	puts "frame: $frame"
	#set distances1 [lrepeat $length1 1000]
	set distances1 [list 1000]
	for {set i 1} {$i < $length1} {incr i} {
	    lappend distances1 1000
	}
	#set distances2 [lrepeat $length2 1000]
	
	#set closestAtom [lrepeat $length1 -1]
	set closestAtom [list -1]
	for {set i 1} {$i < $length1} {incr i} {
	    lappend closestAtom -1
	}
	
	for {set i 0} {$i < $length1} {incr i} {
	    set atom1 [atomselect $mol1 "index [lindex $indices1 $i]" frame $frame]
	    for {set j 0} {$j < $length2} {incr j} {
		set atom2 [atomselect $mol2 "index [lindex $indices2 $j]" frame $frame]
		set tempDist [measure rmsd $atom1 $atom2]
		if {$tempDist < [lindex $distances1 $i]} {
		    #puts "i:$i, j:$j, index1:[lindex $indices1 $i], index2:[lindex $indices2 $j], tempDist:$tempDist, dist: [lindex $distances1 $i]"
		    #puts "index1:[lindex $indices1 $i], index2:[lindex $indices2 $j], tempDist:$tempDist, dist: [lindex $distances1 $i]"
		    lset distances1 $i $tempDist
		    lset closestAtom $i $j
		}
		$atom2 delete
	    }
	    $atom1 delete
	}
	
	for {set i 0} {$i < $length1} {incr i} {
	    #set atom1 [atomselect $mol1 "index [lindex $indices1 $i]" frame $frame]
	    #set closestAtomIndex [lindex $closestAtom $i]
	    #set atom2 [atomselect $mol2 "index [lindex $closestAtom $i]" frame $frame]
	    set j [lindex $closestAtom $i]
	    puts $outputFile [format "%6d  %6d  %6d  %6d  %8.2f" \
				  [lindex $resids1 $i] [lindex $indices1 $i] \
				  [lindex $resids2 $j] [lindex $indices2 $j] \
				  [lindex $distances1 $i]]
	    #$atom1 delete
	    #$atom2 delete
	}
	puts $outputFile ""
    }
    
    close $outputFile

    return
}

# Read in output from closestAtoms, closestAtoms2, or farthestAtoms and parse
# distance data into a matrix (timestep x atom)
proc genAtomDistanceMatrix { inFile outFile } {

    set inputFile [open $inFile "r"]
    set outputFile [open $outFile "w"]
    while {![eof $inputFile] && [gets $inputFile line] >= 0} {
	if {[regexp {^\s*\d+\s+\d+\s+\d+\s+\d+\s+(\d+\.\d+)} $line temp distance]} {
	    puts -nonewline $outputFile "$distance "
	} elseif {[string equal $line ""]} {
	    puts $outputFile ""
	}
    }
    close $inputFile
    close $outputFile
    
    return
}

# farthestAtoms - compare atomSet1 to atomSet2 and produce a list of correspondences
#   between the two sets, the atoms in atomSet2 that are farthest to the each atom
#   of atomSet1
#     atomSet1: atomselect
#     atomSet2: atomselect
#     outFile:  file for correspondence and distance info
#   John Eargle
#   28 Jan 2007
proc farthestAtoms { atomSet1 atomSet2 outFile } {

    set outputFileName $outFile

    set mol1 [$atomSet1 molid]
    set mol2 [$atomSet2 molid]

    set indices1 [$atomSet1 list]
    set indices2 [$atomSet2 list]

    set length1 [$atomSet1 num]
    set length2 [$atomSet2 num]

    #set distances1 [lrepeat $length1 1000]
    set distances1 [list 0]
    for {set i 1} {$i < $length1} {incr i} {
	lappend distances1 0
    }
    #set distances2 [lrepeat $length2 1000]

    #set closestAtom [lrepeat $length1 -1]
    set closestAtom [list -1]
    for {set i 1} {$i < $length1} {incr i} {
	lappend closestAtom -1
    }

    for {set i 0} {$i < $length1} {incr i} {
	set atom1 [atomselect $mol1 "index [lindex $indices1 $i]"]
	for {set j 0} {$j < $length2} {incr j} {
	    set atom2 [atomselect $mol2 "index [lindex $indices2 $j]"]
	    set tempDist [measure rmsd $atom1 $atom2]
	    if {$tempDist > [lindex $distances1 $i]} {
		#puts "i:$i, j:$j, index1:[lindex $indices1 $i], index2:[lindex $indices2 $j], tempDist:$tempDist, dist: [lindex $distances1 $i]"
		puts "index1:[lindex $indices1 $i], index2:[lindex $indices2 $j], tempDist:$tempDist, dist: [lindex $distances1 $i]"
		lset distances1 $i $tempDist
		lset closestAtom $i [lindex $indices2 $j]
	    }
	    $atom2 delete
	}
	$atom1 delete
    }

    set outputFile [open $outputFileName w]
    puts $outputFile "Resid1  Index1  Resid2  Index2  Distance"
    puts $outputFile "----------------------------------------"

    for {set i 0} {$i < $length1} {incr i} {
	set atom1 [atomselect $mol1 "index [lindex $indices1 $i]"]
	set closestAtomIndex [lindex $closestAtom $i]
	set atom2 [atomselect $mol2 "index [lindex $closestAtom $i]"]
	puts $outputFile [format "%6d  %6d  %6d  %6d  %8.2f" \
			      [$atom1 get resid] [$atom1 get index] \
			      [$atom2 get resid] [$atom2 get index] \
			      [lindex $distances1 $i]]
	$atom1 delete
	$atom2 delete
    }
    
    close $outputFile

    return
}
