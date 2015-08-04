# John Eargle
# 16 Nov 2005
#   Get times (psecs) for ions residing near counter ions.  This
#   was developed for getting residence times of K and Na to
#   phosphates in the backbone of tRNA.

variable targetTimeHash ;# What the ions are close to
variable thresholdDistance ;# Distance where ions are considered to be "away" from the target
variable residenceTimeHash ;# Hash of residence time lists per ion


proc initializeJunk {numIons numTargets} {

    variable targetTimeHash
    variable residenceTimeHash

    for {set i 0} {$i < $numIons} {incr i} {
	for {set j 0} {$j < $numTargets} {incr j} {
	    set targetTimeHash("$i,$j") -1
	}
	set residenceTimeHash($i) = [llist ]
    }

    return
}


proc checkIonDistances {ions time} {

    variable targetTimeHash
    variable thresholdDistance
    variable residenceTimeHash

    set numIons [$ions num]
    set numTargets [llength $targetList]

    for {set i 0} {$i < $numIons} {incr i} {
	for {set j 0} {$j < $numTargets} {incr j} {
	    set distance [measure rmsd [lindex $ions $i] [lindex $targetList $j]]
	    # if {initial contact with target}
	    if {$targetTimeHash("$i,$j") == -1} {
		if {$distance < $thresholdDistance} {
		    # Activate target
		    set targetTimeHash("$i,$j") $time
		}
	    }
	    # Target is already activated
	    else {
		if {$distance >= $thresholdDistance} {
		    # Deactivate target and record time
		    [lappend $residenceTimeHash($ion) [expr $time - $targetTimeHash("$i,$j")]]
		    set targetTimeHash("$i,$j") -1
		}
	    }
	}
    }

    return
}


proc ionResidence {ions targets} {

    variable residenceTimeHash

    set time 0
    set numIons [$ions num]
    set numTargets [$targets num]

    # Get the number of frames in the movie
    set numFrames [molinfo top get numframes]

    # Loop through the frames
    for {set i 0} {$i < $num} {incr i} {
	puts "i: $i"
	# make atomselection
	set foo [atomselect top "nucleic" frame $i]
	set time [expr 500 * 50 * $i]
	checkIonDistances $ions $time
    }

    # Write out lists of residence times
    for {set i 0} {$i < $numIons} {incr i} {
	puts "ion $i"
	set listLength [llength $residenceTimeHash($i)]
	for {set j 0} {$j < $listLength} {incr j} {
	    puts [lindex $residenceTimeHash($i) $j]
	}
    }

    return
}
