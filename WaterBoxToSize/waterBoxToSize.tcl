# waterBox - create a water box with a set volume by padding each
#   side of the system by the same amount
#   John Eargle
#   29 Nov 2005

package require solvate

proc getBoxSize {args} {

    set atoms [atomselect top "all"]

    set center [measure center $atoms]
    puts "center = ([lindex $center 0], [lindex $center 1], [lindex $center 2])"

    set minMax [measure minmax $atoms]
    set boxSides [vecsub [lindex $minMax 1] [lindex $minMax 0]]
    puts "boxSides = ([lindex $boxSides 0], [lindex $boxSides 1], [lindex $boxSides 2])"

    puts [format "cellBasisVector1        %.2f  0.0    0.0" \
	      [lindex $boxSides 0]]
    puts [format "cellBasisVector2        0.0    %.2f  0.0" \
	      [lindex $boxSides 1]]
    puts [format "cellBasisVector3        0.0    0.0    %.2f" \
	      [lindex $boxSides 2]]  
    puts [format "cellOrigin              %.2f  %.2f  %.2f" \
	      [lindex $center 0] [lindex $center 1] [lindex $center 2]]

    $atoms delete

    return
}


# calculate the extra padding needed for VMD's solvate after Grubmueller's solvate
#   has been run to generate an initial layer of water
proc getBoxPadding { padding } {

    set atomSel [atomselect top "all"]
    set protNucSel [atomselect top "protein or nucleic"]

    set atomsMinMax [measure minmax $atomSel]
    set protNucMinMax [measure minmax $protNucSel]

    set atomsSides [vecsub [lindex $atomsMinMax 1] [lindex $atomsMinMax 0]]
    set protNucSides [vecsub [lindex $protNucMinMax 1] [lindex $protNucMinMax 0]]

    set waterPadding [vecsub $atomsSides $protNucSides]

    set minWaterPadding 1000000
    for {set i 0} {$i < 3} {incr i} {
	if {[lindex $waterPadding $i] < $minWaterPadding} {
	    set minWaterPadding [lindex $waterPadding $i]
	}
    }

    set minWaterPadding [expr $minWaterPadding / 2.0]
    set minPadding [expr $padding - $minWaterPadding]

    puts "atomsMinMax: $atomsMinMax"
    puts "protNucMinMax: $protNucMinMax"

    puts "atomsSides: $atomsSides"
    puts "protNucSides: $protNucSides"

    puts "Minimum padding to use:"
    puts "  solvate -t $minPadding"
    
    $atomSel delete
    $protNucSel delete

    return
}


proc waterBox {totalVolume} {

    puts "totalVolume = $totalVolume"

    set atoms [atomselect top "all"]

    set center [measure center $atoms]
    puts "center = ([lindex $center 0], [lindex $center 1], [lindex $center 2])"

    set minMax [measure minmax $atoms]
    set boxSides [vecsub [lindex $minMax 1] [lindex $minMax 0]]
    puts "boxSides = ([lindex $boxSides 0], [lindex $boxSides 1], [lindex $boxSides 2])"

    puts [format "cellBasisVector1        %.2f  0.0    0.0" \
	      [lindex $boxSides 0]]
    puts [format "cellBasisVector2        0.0    %.2f  0.0" \
	      [lindex $boxSides 1]]
    puts [format "cellBasisVector3        0.0    0.0    %.2f" \
	      [lindex $boxSides 2]]  
    puts [format "cellOrigin              %.2f  %.2f  %.2f" \
	      [lindex $center 0] [lindex $center 1] [lindex $center 2]]

    set quadCoeffs [list [expr [lindex $boxSides 0] * [lindex $boxSides 1]] \
		    [expr [lindex $boxSides 0] + [lindex $boxSides 1]] \
		    1]
    #puts "hey1"
    set cubeCoeffs [list [expr ([lindex $quadCoeffs 0] * [lindex $boxSides 2]) - \
			  $totalVolume] \
		    [expr ([lindex $quadCoeffs 1] * [lindex $boxSides 2]) + \
		     [lindex $quadCoeffs 0]] \
		    [expr [lindex $boxSides 2] + [lindex $quadCoeffs 1]] \
		    1]
    #puts "hey2"
    set diffCoeffs [list [expr [lindex $cubeCoeffs 1]] \
		    [expr [lindex $cubeCoeffs 2] * 2] \
		    [expr [lindex $cubeCoeffs 3] * 3]]
    #puts "hey3"

    puts "cubic equation: [lindex $cubeCoeffs 0] + [lindex $cubeCoeffs 1]x + [lindex $cubeCoeffs 2]x^2 + [lindex $cubeCoeffs 3]x^3 = 0"
    puts "diff equation:  [lindex $diffCoeffs 0] + [lindex $diffCoeffs 1]x + [lindex $diffCoeffs 2]x^2 = 0"
    puts ""
    
    set i 0
    set x 0
    set y [cubicFunc $x $cubeCoeffs]
    set slope [quadraticFunc $x $diffCoeffs]
    puts "Startup Values"
    puts "  x     = $x"
    puts "  f(x)  = $y"
    puts "  f'(x) = $slope"

    while {[expr abs($y)] > 0.5} {
	set x [expr $x-($y/$slope)]
	set y [cubicFunc $x $cubeCoeffs]
	set slope [quadraticFunc $x $diffCoeffs]
	incr i
	puts "Round $i"
	puts "  x     = $x"
	puts "  f(x)  = $y"
	puts "  f'(x) = $slope"
    }

    return
}


proc cubicFunc {x cubeCoeffs} {

    return [expr [lindex $cubeCoeffs 0] + \
	    ([lindex $cubeCoeffs 1] * $x) + \
	    ([lindex $cubeCoeffs 2] * $x * $x) + \
	    ([lindex $cubeCoeffs 3] * $x * $x * $x)]
}


proc quadraticFunc {x quadCoeffs} {

    return [expr [lindex $quadCoeffs 0] + \
	    ([lindex $quadCoeffs 1] * $x) + \
	    ([lindex $quadCoeffs 2] * $x * $x)]
}
