# Units: N, mm, seconds

###################################################################################################
#          Set Up & Source Definition									  
###################################################################################################
	
proc INSCFR {nodeTag nodeLocationX nodeLocationY elementTag  storyTag  } {
    model BasicBuilder -ndm 2 -ndf 3;
	source Parameters.tcl;
	source Beamcolumns.tcl;
###################################################################################################
#          Define Building Geometry, Nodes, Masses, and Constraints											  
###################################################################################################


puts "node"

# calculate panel zone dimensions
	set pzlat23  [expr $dcol_($storyTag)/2.0];	# 中心线到节点边缘的水平距离 (= 柱高的一半)
	set pzvert23 [expr $dbeam_($storyTag)/2.0];	# 中心线到节点边缘的垂直距离 (= 梁高的一半)

# calculate locations of beam-column joint centerlines:
	set Pier1  $nodeLocationX;		# 柱线1

	set Floor1 [expr $nodeLocationY - $columnend_($storyTag) - $pzvert23];		# 地面
	set Floor2 $nodeLocationY; # 楼层1
	set Floor3 [expr $nodeLocationY + $columnend_($storyTag) + $pzvert23]; # 楼层2

    # # 地面节点
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
    node [expr $nodeTag+15] [expr $Pier1 + $pzlat23] [expr $Floor2 + $FR_($storyTag)/2];
    node [expr $nodeTag+17] [expr $Pier1 + $pzlat23] [expr $Floor2 - $FR_($storyTag)/2];
	
    #梁端部受力点
    node [expr $nodeTag+18] [expr $Pier1 + $pzlat23] [expr $Floor2 + $pzvert23];
    node [expr $nodeTag+19] [expr $Pier1 + $pzlat23] [expr $Floor2];
    node [expr $nodeTag+20] [expr $Pier1 + $pzlat23] [expr $Floor2 - $pzvert23];
	
	#梁端加强板端点
	node [expr $nodeTag+21] [expr $Pier1 + $pzlat23+$RP] $Floor2;
	
  

	
	
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
	node [expr $nodeTag+42] [expr $Pier1 + $pzlat23] [expr $Floor2 + $pzvert23-$Drp_($storyTag)];
	node [expr $nodeTag+43] [expr $Pier1 + $pzlat23] [expr $Floor2 + $pzvert23-$Drp_($storyTag)-$Bf_($storyTag)];
    
    node [expr $nodeTag+44] [expr $Pier1 + $pzlat23] [expr $Floor2 - $pzvert23+$Drp_($storyTag)+$Bf_($storyTag)];
    node [expr $nodeTag+45] [expr $Pier1 + $pzlat23] [expr $Floor2 - $pzvert23+$Drp_($storyTag)];
	




#########################################################################################	
		#梁端部受力点缝隙张开增加点
	node [expr $nodeTag+142] [expr $Pier1 - $pzlat23] [expr $Floor2 + $pzvert23-$Drp_($storyTag)];
	node [expr $nodeTag+143] [expr $Pier1 - $pzlat23] [expr $Floor2 + $pzvert23-$Drp_($storyTag)-$Bf_($storyTag)];
    
    node [expr $nodeTag+144] [expr $Pier1 - $pzlat23] [expr $Floor2 - $pzvert23+$Drp_($storyTag)+$Bf_($storyTag)];
    node [expr $nodeTag+145] [expr $Pier1 - $pzlat23] [expr $Floor2 - $pzvert23+$Drp_($storyTag)];
	
	
	    #耗能器受力点
    node [expr $nodeTag+115] [expr $Pier1 - $pzlat23] [expr $Floor2 + $FR_($storyTag)/2];
    node [expr $nodeTag+117] [expr $Pier1 - $pzlat23] [expr $Floor2 - $FR_($storyTag)/2];
	
    #梁端部受力点
    node [expr $nodeTag+118] [expr $Pier1 - $pzlat23] [expr $Floor2 + $pzvert23];
    node [expr $nodeTag+119] [expr $Pier1 - $pzlat23] [expr $Floor2];
    node [expr $nodeTag+120] [expr $Pier1 - $pzlat23] [expr $Floor2 - $pzvert23];
	
	#梁端加强板端点
	node [expr $nodeTag+121] [expr $Pier1 - $pzlat23-$RP] $Floor2;
	
	
	
  
    equalDOF [expr $nodeTag+6] [expr $nodeTag+19] 2;
    equalDOF [expr $nodeTag+12] [expr $nodeTag+119] 2;


###################################################################################################
#          Define Section Properties and Elements													  
###################################################################################################


# #定义柱单元
# element	nonlinearBeamColumn	[expr $elementTag+1]  $nodeTag [expr $nodeTag+9] $numIntgrPts	$secTag_C($storyTag)	$PDeltaTransf;	# Pier 1
# element	nonlinearBeamColumn	[expr $elementTag+2]  [expr $nodeTag+3] [expr $nodeTag+59] $numIntgrPts	$secTag_C($storyTag)	$PDeltaTransf;	# Pier 1

	
#定义梁单元
element	nonlinearBeamColumn	[expr $elementTag+3]  [expr $nodeTag+19] [expr $nodeTag+21] $numIntgrPts	$secTag_RB($storyTag)	$PDeltaTransf;	# Pier 1

#定义梁单元
element	nonlinearBeamColumn	[expr $elementTag+103]  [expr $nodeTag+119] [expr $nodeTag+121] $numIntgrPts	$secTag_RB($storyTag)	$PDeltaTransf;	# Pier 1

#定义节点刚臂梁单元
	set Apz  [expr $Acol_($storyTag)*100];	# area of panel zone element (make much larger than A of frame elements)
	set Ipz  [expr $Icol_($storyTag)*100];  # moment of intertia of panel zone element (make much larger than I of frame elements)
	# elemPanelZone2D eleID  nodeR E  A_PZ I_PZ transfTag
	elemPanelZone2D   [expr $elementTag+6] [expr $nodeTag+1] $Es $Apz $Ipz $PDeltaTransf;	# Pier 1, Floor 2

#定义节点旋转弹簧单元
	source rotPanelZone2D.tcl
	set Ry 1.1; 	# expected yield strength multiplier
	set as_PZ 0.01; # strain hardening of panel zones
	# Spring ID: "4xy00" where 4 = panel zone spring, x = Pier #, y = Floor #
	#2nd Floor PZ springs
	#             ElemID  ndR  ndC  E   Fy   dc       bf_c        tf_c       tp        db       Ry   as
	rotPanelZone2D [expr $elementTag+30] [expr $nodeTag+4] [expr $nodeTag+5] $Es $Fy $dcol_($storyTag) $bfcol_($storyTag) $tfcol_($storyTag) $twcol_($storyTag) $dbeam_($storyTag) $Ry $as_PZ;

	
	
#定义刚臂接触单元
element elasticBeamColumn    [expr $elementTag+35]    [expr $nodeTag+15] [expr $nodeTag+18]   $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+36]    [expr $nodeTag+18] [expr $nodeTag+42]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+37]    [expr $nodeTag+42] [expr $nodeTag+43]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+38]    [expr $nodeTag+43] [expr $nodeTag+19]    $Es $Apz $Ipz    $PDeltaTransf;

element elasticBeamColumn    [expr $elementTag+39]    [expr $nodeTag+19] [expr $nodeTag+44]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+40]    [expr $nodeTag+44] [expr $nodeTag+45]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+41]    [expr $nodeTag+45] [expr $nodeTag+20]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+42]    [expr $nodeTag+20] [expr $nodeTag+17]   $Es $Apz $Ipz    $PDeltaTransf;



#定义刚臂接触单元
element elasticBeamColumn    [expr $elementTag+135]    [expr $nodeTag+115] [expr $nodeTag+118]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+136]    [expr $nodeTag+118] [expr $nodeTag+142]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+137]    [expr $nodeTag+142] [expr $nodeTag+143]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+138]    [expr $nodeTag+143] [expr $nodeTag+119]    $Es $Apz $Ipz    $PDeltaTransf;

element elasticBeamColumn    [expr $elementTag+139]    [expr $nodeTag+119] [expr $nodeTag+144]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+140]    [expr $nodeTag+144] [expr $nodeTag+145]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+141]    [expr $nodeTag+145] [expr $nodeTag+120]    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    [expr $elementTag+142]    [expr $nodeTag+120] [expr $nodeTag+117]    $Es $Apz $Ipz    $PDeltaTransf;




	
# #定义耗能器单元
# element twoNodeLink 44 4 15 -mat $matID_D1  -dir 1;
# element twoNodeLink 45 4 15 -mat $matID_D2  -dir 1;
# element twoNodeLink 46 4 15 -mat $matID_D3  -dir 1;
# element twoNodeLink 47 4 15 -mat $matID_D4  -dir 1;
# element twoNodeLink 48 4 15 -mat $matID_D5  -dir 1;
# element twoNodeLink 49 4 15 -mat $matID_D6  -dir 1;
# element twoNodeLink 50 4 15 -mat $matID_D7  -dir 1;

# element twoNodeLink 51 7 17 -mat $matID_D1  -dir 1;
# element twoNodeLink 52 7 17 -mat $matID_D2  -dir 1;
# element twoNodeLink 53 7 17 -mat $matID_D3  -dir 1;
# element twoNodeLink 54 7 17 -mat $matID_D4  -dir 1;
# element twoNodeLink 55 7 17 -mat $matID_D5  -dir 1;
# element twoNodeLink 56 7 17 -mat $matID_D6  -dir 1;
# element twoNodeLink 57 7 17 -mat $matID_D7  -dir 1;
#定义耗能器单元
# element twoNodeLink 144 1 115 -mat $matID_D1  -dir 1;
# element twoNodeLink 145 1 115 -mat $matID_D2  -dir 1;
# element twoNodeLink 146 1 115 -mat $matID_D3  -dir 1;
# element twoNodeLink 147 1 115 -mat $matID_D4  -dir 1;
# element twoNodeLink 148 1 115 -mat $matID_D5  -dir 1;
# element twoNodeLink 149 1 115 -mat $matID_D6  -dir 1;
# element twoNodeLink 150 1 115 -mat $matID_D7  -dir 1;

# element twoNodeLink 151 10 117 -mat $matID_D1  -dir 1;
# element twoNodeLink 152 10 117 -mat $matID_D2  -dir 1;
# element twoNodeLink 153 10 117 -mat $matID_D3  -dir 1;
# element twoNodeLink 154 10 117 -mat $matID_D4  -dir 1;
# element twoNodeLink 155 10 117 -mat $matID_D5  -dir 1;
# element twoNodeLink 156 10 117 -mat $matID_D6  -dir 1;
# element twoNodeLink 157 10 117 -mat $matID_D7  -dir 1;	

element twoNodeLink [expr $elementTag+50] [expr $nodeTag+1] [expr $nodeTag+115] -mat $matID_D10($storyTag)  -dir 1;
element twoNodeLink [expr $elementTag+51] [expr $nodeTag+10] [expr $nodeTag+117] -mat $matID_D10($storyTag)  -dir 1;	
element twoNodeLink [expr $elementTag+52] [expr $nodeTag+4] [expr $nodeTag+15] -mat $matID_D10($storyTag)  -dir 1;
element twoNodeLink [expr $elementTag+53] [expr $nodeTag+7] [expr $nodeTag+17] -mat $matID_D10($storyTag)  -dir 1;	

# 定义梁柱仅受压接触单元
element zeroLength  [expr $elementTag+58] [expr $nodeTag+30] [expr $nodeTag+18] -mat $matID_G1($storyTag) -dir 1;
element zeroLength  [expr $elementTag+59] [expr $nodeTag+31] [expr $nodeTag+42] -mat $matID_G2($storyTag) -dir 1;
element zeroLength  [expr $elementTag+60] [expr $nodeTag+32] [expr $nodeTag+43] -mat $matID_G3($storyTag) -dir 1;
element zeroLength  [expr $elementTag+61] [expr $nodeTag+33] [expr $nodeTag+44] -mat $matID_G3($storyTag) -dir 1;
element zeroLength  [expr $elementTag+62] [expr $nodeTag+34] [expr $nodeTag+45] -mat $matID_G2($storyTag) -dir 1;
element zeroLength  [expr $elementTag+63] [expr $nodeTag+35] [expr $nodeTag+20] -mat $matID_G1($storyTag) -dir 1;



element zeroLength  [expr $elementTag+65] [expr $nodeTag+30] [expr $nodeTag+18] -mat $matID_G5($storyTag) -dir 1;
element zeroLength  [expr $elementTag+66] [expr $nodeTag+31] [expr $nodeTag+42] -mat $matID_G5($storyTag) -dir 1;
element zeroLength  [expr $elementTag+67] [expr $nodeTag+32] [expr $nodeTag+43] -mat $matID_G5($storyTag) -dir 1;
element zeroLength  [expr $elementTag+68] [expr $nodeTag+33] [expr $nodeTag+44] -mat $matID_G5($storyTag)  -dir 1;
element zeroLength  [expr $elementTag+69] [expr $nodeTag+34] [expr $nodeTag+45] -mat $matID_G5($storyTag)  -dir 1;
element zeroLength  [expr $elementTag+70] [expr $nodeTag+35] [expr $nodeTag+20] -mat $matID_G5($storyTag)  -dir 1;

	
# 定义梁柱仅受压接触单元	
element zeroLength  [expr $elementTag+158] [expr $nodeTag+118] [expr $nodeTag+36] -mat $matID_G1($storyTag) -dir 1;
element zeroLength  [expr $elementTag+159] [expr $nodeTag+142] [expr $nodeTag+37] -mat $matID_G2($storyTag) -dir 1;
element zeroLength  [expr $elementTag+160] [expr $nodeTag+143] [expr $nodeTag+38] -mat $matID_G3($storyTag) -dir 1;
element zeroLength  [expr $elementTag+161] [expr $nodeTag+144] [expr $nodeTag+39] -mat $matID_G3($storyTag) -dir 1;
element zeroLength  [expr $elementTag+162] [expr $nodeTag+145] [expr $nodeTag+40] -mat $matID_G2($storyTag) -dir 1;
element zeroLength  [expr $elementTag+163] [expr $nodeTag+120] [expr $nodeTag+41] -mat $matID_G1($storyTag) -dir 1;



element zeroLength  [expr $elementTag+165] [expr $nodeTag+118] [expr $nodeTag+36] -mat $matID_G5($storyTag) -dir 1;
element zeroLength  [expr $elementTag+166] [expr $nodeTag+142] [expr $nodeTag+37] -mat $matID_G5($storyTag) -dir 1;
element zeroLength  [expr $elementTag+167] [expr $nodeTag+143] [expr $nodeTag+38] -mat $matID_G5($storyTag) -dir 1;
element zeroLength  [expr $elementTag+168] [expr $nodeTag+144] [expr $nodeTag+39] -mat $matID_G5($storyTag) -dir 1;
element zeroLength  [expr $elementTag+169] [expr $nodeTag+145] [expr $nodeTag+40] -mat $matID_G5($storyTag) -dir 1;
element zeroLength  [expr $elementTag+170] [expr $nodeTag+120] [expr $nodeTag+41] -mat $matID_G5($storyTag) -dir 1;	

	


}

