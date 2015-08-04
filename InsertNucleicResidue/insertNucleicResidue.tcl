# John Eargle
# 7 Apr 2006
#   Move two tRNA molecules together around the residue insert
#   location, move target residues (by the backbone) to template
#   positions, & add a new residue to the template insertion
#   position.

proc insertNucleicResidue { targetId templateId } {

    #set templateId 0
    #set targetId 4

    #set target [atomselect $targetId "resid 43 44 45 46 48"]
    set template [atomselect $templateId "all"]

    set targetBackbone [atomselect $targetId "backbone and resid 43 44 45 46 48"]
    set templateBackbone [atomselect $templateId "backbone and resid 43 44 45 46 48"]
    
    $template move [measure fit $templateBackbone $targetBackbone]
    $template delete
    $targetBackbone delete
    $templateBackbone delete
    
    set targetRes [atomselect $targetId "resid 46"]
    set targetResBackbone [atomselect $targetId "resid 46 and (type C4' or type C2' or type C3' or type C1' or type O4')"]
    set templateResBackbone [atomselect $templateId "resid 46 and (type C4' or type C2' or type C3' or type C1' or type O4')"]
    #set targetResBackbone [atomselect $targetId "index 1434 1436 1453"]
    #set templateResBackbone [atomselect $templateId "index 928 929 932"]

    $targetRes move [measure fit $targetResBackbone $templateResBackbone]

    $targetRes delete
    $targetResBackbone delete
    $templateResBackbone delete

    
    set templateRes47Backbone [atomselect $templateId "backbone and resid 47"]
    #set insertResBackbone [atomselect $targetId "backbone and resid 1000"]
    #set insertRes [atomselect $targetId "resit 1000"]
    
    #$insertRes move [measure fit $insertResBackbone $templateRes47Backbone]
    
    $templateRes47Backbone delete

    return
}

    #set targetResBackboneList [list [atomselect $targetId "backbone and resid 43"] \
	\#				   [atomselect $targetId "backbone and resid 44"] \
	\#				   [atomselect $targetId "backbone and resid 45"] \
	\#				   [atomselect $targetId "backbone and resid 46"] \
	\#				   [atomselect $targetId "backbone and resid 48"]]

#set templateResBackboneList [list [atomselect $templateId "backbone and resid 43"] \
    \#				     [atomselect $templateId "backbone and resid 44"] \
    \#				     [atomselect $templateId "backbone and resid 45"] \
    \#				     [atomselect $templateId "backbone and resid 46"] \
    \#				     [atomselect $templateId "backbone and resid 48"]]

#    set targetResList [list [atomselect $targetId "resid 43"] \
\#			   [atomselect $targetId "resid 44"] \
\#			   [atomselect $targetId "resid 45"] \
\#			   [atomselect $targetId "resid 46"] \
\#			   [atomselect $targetId "resid 48"]]
 #   
    #set targetResBackboneList [list [atomselect $targetId "resid 43 and (type P or type O3' or type C1' or type C2' or type C3' or type C4' or type O4')"] \
\#				   [atomselect $targetId "resid 44 and (type P or type O3' or type C1' or type C2' or type C3' or type C4' or type O4')"] \
\#				   [atomselect $targetId "resid 45 and (type P or type O3' or type C1')"] \
\#				   [atomselect $targetId "resid 46 and (type P or type C3' or type C1')"] \
\#				   [atomselect $targetId "resid 48 and (type P or type O3' or type C1' or type C2' or type C3' or type C4' or type O4')"]]
 #   
    #
    #set templateResBackboneList [list [atomselect $templateId "resid 43 and (type P or type O3' or type C1' or type C2' or type C3' or type C4' or type O4')"] \
\#				     [atomselect $templateId "resid 44 and (type P or type O3' or type C1' or type C2' or type C3' or type C4' or type O4')"] \
\#				     [atomselect $templateId "resid 45 and (type P or type O3' or type C1')"] \
\#				     [atomselect $templateId "resid 46 and (type P or type C3' or type C1')"] \
\#				     [atomselect $templateId "resid 48 and (type P or type O3' or type C1' or type C2' or type C3' or type C4' or type O4')"]]
 #   

#    for {set i 0} {$i < [llength $targetResList]} {incr i} {
#	if {$i == 3} {
#	    set moveMatrix [measure fit [lindex $targetResBackboneList $i] \
\#			    [lindex $templateResBackboneList $i]]
#	    [lindex $targetResList $i] move $moveMatrix
#	}
#	[lindex $targetResList $i] delete
#	[lindex $targetResBackboneList $i] delete
##	[lindex $templateResBackboneList $i] delete
#    }
