# Units: N, mm, seconds




proc REXSCFR {nodeTag nodeLocationX nodeLocationY elementTag  storyTag } {
    model BasicBuilder -ndm 2 -ndf 3;	
	source Parameters.tcl;
	source Beamcolumns.tcl;
###################################################################################################
#          Define Building Geometry, Nodes, Masses, and Constraints											  
###################################################################################################

	# calculate panel zone dimensions
	set pzlat23  [expr $dcol_($storyTag)/2.0];	# 中心线到节点边缘的水平距离 (= 柱高的一半)
	set pzvert23 [expr $dbeam_($storyTag)/2.0];	# 中心线到节点边缘的垂直距离 (= 梁高的一半)


	# calculate locations of beam-column joint centerlines:
	set Pier1  $nodeLocationX;		# 柱线1

	set Floor1 [expr $nodeLocationY - $columnend_($storyTag) - $pzvert23];		# 地面
	set Floor2 $nodeLocationY; # 楼层1
	set Floor3 [expr $nodeLocationY + $columnend_($storyTag) + $pzvert23]; # 楼层2

	
	
	
    # 地面节点
	# node $nodeTag $Pier1 $Floor1;
    # #加载点
    # node [expr $nodeTag+59] $Pier1 $Floor3; 
	# 梁柱节点1 at Pier 1, Floor 2
	node [expr $nodeTag+1] [expr $Pier1 - $pzlat23] [expr $Floor2 + $FR_($storyTag)/2];
	node [expr $nodeTag+2] [expr $Pier1 - $pzlat23] [expr $Floor2 + $FR_($storyTag)/2];
	node [expr $nodeTag+3] $Pier1  [expr $Floor2 + $FR_($storyTag)/2];
	node [expr $nodeTag+4] [expr $Pier1 + $pzlat23] [expr $Floor2 + $FR_($storyTag)/2];
	node [expr $nodeTag+5] [expr $Pier1 + $pzlat23] [expr $Floor2 + $FR_($storyTag)/2];
	node [expr $nodeTag+6] [expr $Pier1 + $pzlat23] [expr $Floor2];
	node [expr $nodeTag+7] [expr $Pier1 + $pzlat23] [expr $Floor2 - $FR_($storyTag)/2];
	node [expr $nodeTag+8] [expr $Pier1 + $pzlat23] [expr $Floor2 - $FR_($storyTag)/2];
	node [expr $nodeTag+9] $Pier1 [expr $Floor2 - $FR_($storyTag)/2]; 
	node [expr $nodeTag+10] [expr $Pier1 - $pzlat23] [expr $Floor2 - $FR_($storyTag)/2];
	node [expr $nodeTag+11] [expr $Pier1 - $pzlat23] [expr $Floor2 - $FR_($storyTag)/2];
	node [expr $nodeTag+12] [expr $Pier1 - $pzlat23] [expr $Floor2];


    #耗能器受力点
    node [expr $nodeTag+15] [expr $Pier1 - $pzlat23] [expr $Floor2 + $FR_($storyTag)/2];
    node [expr $nodeTag+17] [expr $Pier1 - $pzlat23] [expr $Floor2 - $FR_($storyTag)/2];
	
    #梁端部受力点
    node [expr $nodeTag+18] [expr $Pier1 - $pzlat23] [expr $Floor2 + $pzvert23];
    node [expr $nodeTag+19] [expr $Pier1 - $pzlat23] [expr $Floor2];
    node [expr $nodeTag+20] [expr $Pier1 - $pzlat23] [expr $Floor2 - $pzvert23];
	
	#梁端加强板端点

	node [expr $nodeTag+21] [expr $Pier1 - $pzlat23-$RP] $Floor2;


	
	
    # 梁柱节点1缝隙张开增加点 at Pier 1, Floor 2
	
    node [expr $nodeTag+30] [expr $Pier1 + $pzlat23] [expr $Floor2 + $pzvert23];
    node [expr $nodeTag+31] [expr $Pier1 + $pzlat23] [expr $Floor2 + $pzvert23-$Drp_($storyTag)];
    node [expr $nodeTag+32] [expr $Pier1 + $pzlat23] [expr $Floor2 + $pzvert23-$Drp_($storyTag)-$Bf_($storyTag)];

    node [expr $nodeTag+33] [expr $Pier1 + $pzlat23] [expr $Floor2 - $pzvert23+$Drp_($storyTag)+$Bf_($storyTag)];
    node [expr $nodeTag+34] [expr $Pier1 + $pzlat23] [expr $Floor2 - $pzvert23+$Drp_($storyTag)];
    node [expr $nodeTag+35] [expr $Pier1 + $pzlat23] [expr $Floor2 - $pzvert23];

		
	node [expr $nodeTag+36] [expr $Pier1 - $pzlat23] [expr $Floor2 + $pzvert23];
	node [expr $nodeTag+37] [expr $Pier1 - $pzlat23] [expr $Floor2 + $pzvert23-$Drp_($storyTag)];
    node [expr $nodeTag+38] [expr $Pier1 - $pzlat23] [expr $Floor2 + $pzvert23-$Drp_($storyTag)-$Bf_($storyTag)];

    node [expr $nodeTag+39] [expr $Pier1 - $pzlat23] [expr $Floor2 - $pzvert23+$Drp_($storyTag)+$Bf_($storyTag)];
    node [expr $nodeTag+40] [expr $Pier1 - $pzlat23] [expr $Floor2 - $pzvert23+$Drp_($storyTag)];
    node [expr $nodeTag+41] [expr $Pier1 - $pzlat23] [expr $Floor2 - $pzvert23];
	
	#梁端部受力点缝隙张开增加点
	node [expr $nodeTag+42] [expr $Pier1 - $pzlat23] [expr $Floor2 + $pzvert23-$Drp_($storyTag)];
	node [expr $nodeTag+43] [expr $Pier1 - $pzlat23] [expr $Floor2 + $pzvert23-$Drp_($storyTag)-$Bf_($storyTag)];
    
    node [expr $nodeTag+44] [expr $Pier1 - $pzlat23] [expr $Floor2 - $pzvert23+$Drp_($storyTag)+$Bf_($storyTag)];
    node [expr $nodeTag+45] [expr $Pier1 - $pzlat23] [expr $Floor2 - $pzvert23+$Drp_($storyTag)];
	
	
   
    equalDOF [expr $nodeTag+12] [expr $nodeTag+19] 2;


###################################################################################################
#          Define Section Properties and Elements													  
###################################################################################################


	


puts "element"	

# #定义柱单元

# element	nonlinearBeamColumn	[expr $elementTag+1]  $nodeTag [expr $nodeTag+9] $numIntgrPts	$secTag_C($storyTag)	$PDeltaTransf;	# Pier 1
# element	nonlinearBeamColumn	[expr $elementTag+2]  [expr $nodeTag+3] [expr $nodeTag+59] $numIntgrPts	$secTag_C($storyTag)	$PDeltaTransf;	# Pier 1

	
#定义梁单元
element	nonlinearBeamColumn	[expr $elementTag+3]  [expr $nodeTag+19] [expr $nodeTag+21] $numIntgrPts	$secTag_RB($storyTag)	$PDeltaTransf;	# Pier 1



#定义节点刚臂梁单元
	set Apz  [expr $Acol_($storyTag)*100];	# area of panel zone element (make much larger than A of frame elements)
	set Ipz  [expr $Icol_($storyTag)*100];  # moment of intertia of panel zone element (make much larger than I of frame elements)
	# elemPanelZone2D eleID  nodeR E  A_PZ I_PZ transfTag
	elemPanelZone2D   [expr $elementTag+6] [expr $nodeTag+1] $Es $Apz $Ipz $PDeltaTransf;	# Pier 1, Floor 2

#定义节点旋转弹簧单元
	source rotPanelZone2D.tcl
	set Ry 1.2; 	# expected yield strength multiplier
	set as_PZ 0.01; # strain hardening of panel zones
	# Spring ID: "4xy00" where 4 = panel zone spring, x = Pier #, y = Floor #
	#2nd Floor PZ springs
	#             ElemID  ndR  ndC  E   Fy   dc       bf_c        tf_c       tp        db       Ry   as
	rotPanelZone2D [expr $elementTag+30] [expr $nodeTag+4] [expr $nodeTag+5] $Es $Fy $dcol_($storyTag) $bfcol_($storyTag) $tfcol_($storyTag) $twcol_($storyTag) $dbeam_($storyTag) $Ry $as_PZ;

	
	
#定义刚臂接触单元
element elasticBeamColumn    [expr $elementTag+35]    [expr $nodeTag+15] [expr $nodeTag+18]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+36]    [expr $nodeTag+18] [expr $nodeTag+42]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+37]    [expr $nodeTag+42] [expr $nodeTag+43]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+38]    [expr $nodeTag+43] [expr $nodeTag+19]   $Es $Apz $Ipz    $PDeltaTransf;

element elasticBeamColumn    [expr $elementTag+39]    [expr $nodeTag+19] [expr $nodeTag+44]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+40]    [expr $nodeTag+44] [expr $nodeTag+45]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+41]    [expr $nodeTag+45] [expr $nodeTag+20]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+42]    [expr $nodeTag+20] [expr $nodeTag+17]    $Es $Apz $Ipz    $PDeltaTransf;



#定义耗能器单元
element twoNodeLink [expr $elementTag+50] [expr $nodeTag+1] [expr $nodeTag+15] -mat $matID_D10($storyTag)  -dir 1;

element twoNodeLink [expr $elementTag+51] [expr $nodeTag+10] [expr $nodeTag+17] -mat $matID_D10($storyTag)  -dir 1;	

# 定义梁柱仅受压接触单元


element zeroLength  [expr $elementTag+58] [expr $nodeTag+18] [expr $nodeTag+36] -mat [expr $matID_G1($storyTag)] -dir 1;
element zeroLength  [expr $elementTag+59] [expr $nodeTag+42] [expr $nodeTag+37] -mat [expr $matID_G2($storyTag)] -dir 1;
element zeroLength  [expr $elementTag+60] [expr $nodeTag+43] [expr $nodeTag+38] -mat [expr $matID_G3($storyTag)] -dir 1;
element zeroLength  [expr $elementTag+61] [expr $nodeTag+44] [expr $nodeTag+39] -mat [expr $matID_G3($storyTag)] -dir 1;
element zeroLength  [expr $elementTag+62] [expr $nodeTag+45] [expr $nodeTag+40] -mat [expr $matID_G2($storyTag)] -dir 1;
element zeroLength  [expr $elementTag+63] [expr $nodeTag+20] [expr $nodeTag+41] -mat [expr $matID_G1($storyTag)] -dir 1;



element zeroLength  [expr $elementTag+65] [expr $nodeTag+18] [expr $nodeTag+36] -mat [expr $matID_G5($storyTag)] -dir 1;
element zeroLength  [expr $elementTag+66] [expr $nodeTag+42] [expr $nodeTag+37] -mat [expr $matID_G5($storyTag)] -dir 1;
element zeroLength  [expr $elementTag+67] [expr $nodeTag+43] [expr $nodeTag+38] -mat [expr $matID_G5($storyTag)] -dir 1;
element zeroLength  [expr $elementTag+68] [expr $nodeTag+44] [expr $nodeTag+39] -mat [expr $matID_G5($storyTag)]  -dir 1;
element zeroLength  [expr $elementTag+69] [expr $nodeTag+45] [expr $nodeTag+40] -mat [expr $matID_G5($storyTag)]  -dir 1;
element zeroLength  [expr $elementTag+70] [expr $nodeTag+20] [expr $nodeTag+41] -mat [expr $matID_G5($storyTag)]  -dir 1;

	
	
}

