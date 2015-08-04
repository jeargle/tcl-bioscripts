# aaPercentage - take an selection string (of protein residues) and
#     print a list of percentages for the amino acid makeup of the
#     set
#   John Eargle - eargle@uiuc.edu
#   14 Jun 2006
#
# Note: each amino acid is counted by its C-alpha so if that 
#   atom is missing, the count is screwed up
#


proc aaPercentage { args } {

    #puts "yo"

    if { [llength $args] < 1} {
	#x3DnaToolsUsage
	puts "aaPercentage selectionString"
	error ""
    }

    set selString [lindex $args 0]

    set aaList [list ALA ARG ASN ASP CYS GLU GLN GLY HIS HSD HSE HSP ILE LEU LYS MET PHE PRO SER THR TRP TYR VAL]

    set totalSel [atomselect top "$selString and alpha"]
    set totalNum [$totalSel num]
    puts "Total amino acids: $totalNum"

    set totalNumCheck 0
    foreach aa $aaList {
	set aaSel [atomselect top "$selString and alpha and resname $aa"]
	set aaNum [$aaSel num]
	incr totalNumCheck $aaNum
	set aaPercent [expr 100.0 * $aaNum / $totalNum]
	puts [format "  %s: %4d, %3.2f%%" $aa $aaNum $aaPercent]
	$aaSel delete
    }

    puts "Check on total: $totalNumCheck"

    return
}

