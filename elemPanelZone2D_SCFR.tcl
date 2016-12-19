########################################################################################################
# elemPanelZone2D.tcl
# Procedure that creates panel zone elements
# 
# The process is based on Gupta 1999
# Reference:  Gupta, A., and Krawinkler, H. (1999). "Seismic Demands for Performance Evaluation of Steel Moment Resisting Frame Structures,"
#            Technical Report 132, The John A. Blume Earthquake Engineering Research Center, Department of Civil Engineering, Stanford University, Stanford, CA.
#
#
# Written by: Dimitrios Lignos
# Date: 11/09/2008
#
# Modified by: Laura Eads
# Date: 1/4/2010
# Modification: changed numbering scheme for panel zone nodes
#
# Formal arguments
#	eleID     - unique element ID for the zero-length rotational spring
#	nodeR     - node ID for first point (top left) of panel zone --> this node creates all the others
#	E         - Young's modulus
#   A_PZ	  - area of rigid link that creates the panel zone
#   I_PZ      - moment of inertia of Rigid link that creates the panel zone
#   transfTag - geometric transformation
#
########################################################################################################
proc elemPanelZone2D {eleID nodeR E A_PZ I_PZ transfTag} {

# define panel zone nodes
	set node_xy01 $nodeR;  					# top left of joint
	set node_xy02 [expr $node_xy01 + 1];	# top left of joint
	set node_xy7  [expr $node_xy01 + 2];	# top center of joint
	set node_xy03 [expr $node_xy01 + 3];	# top right of joint
	set node_xy04 [expr $node_xy01 + 4];	# top right of joint
	set node_xy05 [expr $node_xy01 + 5];	# middle right of joint (vertical middle, horizontal right)
	set node_xy06 [expr $node_xy01 + 6];	# btm right of joint
	set node_xy07 [expr $node_xy01 + 7];	# btm right of joint
	set node_xy6  [expr $node_xy01 + 8];	# btm center of joint
	set node_xy08 [expr $node_xy01 + 9];	# btm left of joint
	set node_xy09 [expr $node_xy01 + 10];	# btm left of joint
	set node_xy10 [expr $node_xy01 + 11];	# middle left of joint (vertical middle, horizontal left)
	
	
	

	
	set node_xy11 [expr $node_xy01 + 29];
	set node_xy12 [expr $node_xy01 + 30];
	set node_xy13 [expr $node_xy01 + 31];
	set node_xy14 [expr $node_xy01 + 32];
	set node_xy15 [expr $node_xy01 + 33];
	set node_xy16 [expr $node_xy01 + 34];
	set node_xy17 [expr $node_xy01 + 35];
	set node_xy18 [expr $node_xy01 + 36];
	set node_xy19 [expr $node_xy01 + 37];
	set node_xy20 [expr $node_xy01 + 38];
	set node_xy21 [expr $node_xy01 + 39];
	set node_xy22 [expr $node_xy01 + 40];
	
	
# create element IDs as a function of first input eleID (8 per panel zone)
	set x1 $eleID;			# left element on top of panel zone
	set x2 [expr $x1 + 1];	# right element on top of panel zone
	set x3 [expr $x1 + 2];	# top element on right side of panel zone
	set x4 [expr $x1 + 3];	# btm element on right side of panel zone
	set x5 [expr $x1 + 4];	# right element on btm of panel zone
	set x6 [expr $x1 + 5];	# left element on btm of panel zone
	set x7 [expr $x1 + 6];	# btm element on left side of panel zone
	set x8 [expr $x1 + 7];	# top element on left side of panel zone
    set x9 [expr $x1 + 8];
    set x10 [expr $x1 + 9];
    set x11 [expr $x1 + 10];
    set x12 [expr $x1 + 11];
    set x13 [expr $x1 + 12];
    set x14 [expr $x1 + 13];
    set x15 [expr $x1 + 14];
    set x16 [expr $x1 + 15];
    set x17 [expr $x1 + 16];
    set x18 [expr $x1 + 17];
    set x19 [expr $x1 + 18];
    set x20 [expr $x1 + 19];


# create panel zone elements
	#                            tag     ndI             ndJ        A_PZ     E       I_PZ     transfTag
	element elasticBeamColumn    $x1    $node_xy02   $node_xy7     $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x2    $node_xy7    $node_xy03    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x3    $node_xy04   $node_xy11    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x4    $node_xy11   $node_xy12    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x5    $node_xy12   $node_xy13    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x6    $node_xy13   $node_xy05    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x7    $node_xy05   $node_xy14    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x8    $node_xy14   $node_xy15    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x9    $node_xy15   $node_xy16    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x10   $node_xy16   $node_xy06    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x11   $node_xy07   $node_xy6    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x12   $node_xy6   $node_xy08    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x13   $node_xy09   $node_xy22    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x14   $node_xy22   $node_xy21    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x15   $node_xy21   $node_xy20    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x16   $node_xy20   $node_xy10    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x17   $node_xy10   $node_xy19    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x18   $node_xy19   $node_xy18    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x19   $node_xy18   $node_xy17    $A_PZ    $E      $I_PZ   $transfTag;
	element elasticBeamColumn    $x20   $node_xy17   $node_xy01    $A_PZ    $E      $I_PZ   $transfTag;

}