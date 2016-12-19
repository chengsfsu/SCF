# Units: N, mm, seconds
###################################################################################################
#          Set Up & Source Definition									  
###################################################################################################
	wipe all;							# clear memory of past model definitions
	model BasicBuilder -ndm 2 -ndf 3;	# Define the model builder, ndm = #dimension, ndf = #dofs
	source DisplayModel2D.tcl;			# procedure for displaying a 2D perspective of model
	source DisplayPlane.tcl;			# procedure for displaying a plane in a model
	source rotPanelZone2D.tcl;			# procedure for defining a rotational spring (zero-length element) to capture panel zone shear distortions
	source elemPanelZone2D_SCFR.tcl;			# procedure for defining 8 elements to create a rectangular panel zone
	source rotSpring2DModIKModel.tcl;	# procedure for defining a rotational spring (zero-length element) for plastic hinges
###################################################################################################
#          Define Analysis Type										  
###################################################################################################
logFile errorFile on
set dataDir Data;				    # set up name of data directory (you can remove this)
file mkdir $dataDir; 				# create data directory
###################################################################################################
#          Define Building Geometry, Nodes, Masses, and Constraints											  
###################################################################################################
puts "node"
# define structure-geometry parameters
	set NStories 2;						# 总楼层数
	set NBays 1;						# 总跨数(除重力柱以外)
	set WBay      4880;		# 跨长
	set HStory1   1377;		# 第一层高度
	set HStoryTyp 1068;		# 其他层高度
	set HBuilding [expr $HStory1 + ($NStories-1)*$HStoryTyp];	# 建筑总高度

# calculate locations of beam-column joint centerlines:
	set Pier1  0.0;		# 柱线1
	set Pier2  [expr $Pier1 + $WBay];     # 柱线2

	set Floor1 0.0;		# 地面
	set Floor2 [expr $Floor1 + $HStory1]; # 楼层1
	set Floor3 [expr $Floor2 + $HStoryTyp]; # 楼层2

	
# calculate panel zone dimensions
	set pzlat23  [expr 446/2.0];	# 中心线到节点边缘的水平距离 (= 柱高的一半)
	set pzvert23 [expr 592/2.0];	# 中心线到节点边缘的垂直距离 (= 梁高的一半)

# calculate plastic hinge offsets from beam-column centerlines:
	set phlat23 [expr $pzlat23 + 0.0];	# 中心线到梁铰的水平距离
	set phvert23 [expr $pzvert23 + 0.0];			# 中心线到柱铰的垂直距离

# define FDs parameters
    #梁上下摩擦耗能器间距
    set FR 842;
	#梁端加强板长度
	set RP 730;
    #梁端加强板厚度
	set Drp 12
	#梁翼缘厚度
	set Bf 17.3
    # 地面节点
	node 1000 $Pier1 $Floor1;
	node 2000 $Pier2 $Floor2;

	# 梁柱节点1 at Pier 1, Floor 2
	node 1 [expr $Pier1 - $pzlat23] [expr $Floor2 + $FR/2];
	node 2 [expr $Pier1 - $pzlat23] [expr $Floor2 + $FR/2];
	node 3 $Pier1  [expr $Floor2 + $FR/2];
	node 4 [expr $Pier1 + $pzlat23] [expr $Floor2 + $FR/2];
	node 5 [expr $Pier1 + $pzlat23] [expr $Floor2 + $FR/2];
	node 6 [expr $Pier1 + $pzlat23] [expr $Floor2];
	node 7 [expr $Pier1 + $pzlat23] [expr $Floor2 - $FR/2];
	node 8 [expr $Pier1 + $pzlat23] [expr $Floor2 - $FR/2];
	node 9 $Pier1 [expr $Floor2 - $FR/2]; 
	node 10 [expr $Pier1 - $pzlat23] [expr $Floor2 - $FR/2];
	node 11 [expr $Pier1 - $pzlat23] [expr $Floor2 - $FR/2];
	node 12 [expr $Pier1 - $pzlat23] [expr $Floor2];

    # #柱上部与摩擦螺栓连接点
	# node 13 $Pier1 [expr $Floor2 + $FR/2];
    # #柱下部与摩擦螺栓连接点
	# node 16 $Pier1 [expr $Floor2 -$FR/2];
	
    #耗能器受力点
    node 15 [expr $Pier1 + $pzlat23] [expr $Floor2 + $FR/2];
    node 17 [expr $Pier1 + $pzlat23] [expr $Floor2 - $FR/2];
	
    #梁端部受力点
    node 18 [expr $Pier1 + $pzlat23] [expr $Floor2 + $phvert23];
    node 19 [expr $Pier1 + $pzlat23] [expr $Floor2];
    node 20 [expr $Pier1 + $pzlat23] [expr $Floor2 - $phvert23];
	
	#梁端加强板端点
	node 21 [expr $Pier1 + $pzlat23+$RP] $Floor2;
	
    #加载点
    node 59 $Pier1 [expr $Floor3 - $phvert23]; 

	
	
    # 梁柱节点1缝隙张开增加点 at Pier 1, Floor 2
	
    node 30 [expr $Pier1 + $pzlat23] [expr $Floor2 + $phvert23];
    node 31 [expr $Pier1 + $pzlat23] [expr $Floor2 + $phvert23-$Drp];
    node 32 [expr $Pier1 + $pzlat23] [expr $Floor2 + $phvert23-$Drp-$Bf];

    node 33 [expr $Pier1 + $pzlat23] [expr $Floor2 - $phvert23+$Drp+$Bf];
    node 34 [expr $Pier1 + $pzlat23] [expr $Floor2 - $phvert23+$Drp];
    node 35 [expr $Pier1 + $pzlat23] [expr $Floor2 - $phvert23];

		
	node 36 [expr $Pier1 - $pzlat23] [expr $Floor2 + $phvert23];
	node 37 [expr $Pier1 - $pzlat23] [expr $Floor2 + $phvert23-$Drp];
    node 38 [expr $Pier1 - $pzlat23] [expr $Floor2 + $phvert23-$Drp-$Bf];

    node 39 [expr $Pier1 - $pzlat23] [expr $Floor2 - $phvert23+$Drp+$Bf];
    node 40 [expr $Pier1 - $pzlat23] [expr $Floor2 - $phvert23+$Drp];
    node 41 [expr $Pier1 - $pzlat23] [expr $Floor2 - $phvert23];
	
	#梁端部受力点缝隙张开增加点
	node 42 [expr $Pier1 + $pzlat23] [expr $Floor2 + $phvert23-$Drp];
	node 43 [expr $Pier1 + $pzlat23] [expr $Floor2 + $phvert23-$Drp-$Bf];
    
    node 44 [expr $Pier1 + $pzlat23] [expr $Floor2 - $phvert23+$Drp+$Bf];
    node 45 [expr $Pier1 + $pzlat23] [expr $Floor2 - $phvert23+$Drp];
	
	
	
	
	
	
	# 地面固结
	fix 1000 1 1 0;
	fix 2000 0 1 0;
   
    equalDOF 6 19 2;


###################################################################################################
#          Define Section Properties and Elements													  
###################################################################################################
puts "section"
# 定义材料性质

    set matID_C 1;         # 钢柱标签
	set matID_B 2;         # 钢梁标签
	set matID_Ch 3;          # 梁Channel单元标签
    set matID_P 5;			# 填充墙标签
	set matID_Z1 6;			# 零长度平动自由度标签
	set matID_Z2 7;			# 零长度旋转自由度标签
	set matID_T0 8;          # 未施加预应力时预应力筋标签
	set matID_T1 9;          # 预应力筋标签
	set matID_D1 10;          # 耗能器标签
	set matID_D2 11;          # 耗能器标签
	set matID_D3 12;          # 耗能器标签
	set matID_D4 13;          # 耗能器标签
	set matID_D5 15;          # 耗能器标签
	set matID_D6 16;          # 耗能器标签
	set matID_D7 17;          # 耗能器标签
	set matID_D10 100;          # 耗能器标签
	
	set matID_G1 18;          # 梁柱仅受压接触单元标签
	set matID_G2 19;          # 梁柱仅受压接触单元标签
	set matID_G3 20;          # 梁柱仅受压接触单元标签
	set matID_G5 21;          # 梁柱受拉接触单元标签	

	set matID_Z1 22;			# 零长度平动自由度标签
	set matID_Z2 23;			# 零长度旋转自由度标签
	set Es 2.06e5;			# 钢弹性模量
	set Fy 385;			# 钢屈服强度
# 定义Steel02材料参数
    set b 0.03;
    set R0 15;
    set cR1 0.925;
    set cR2 0.15;
    set a1 0.02;
    set a2 1.0;
    set a3 0.02;
    set a4 1.0;
    set sigInit 0;
	
uniaxialMaterial Steel02 $matID_C $Fy $Es $b $R0 $cR1 $cR2 $a1 $a2 $a3 $a4 $sigInit;
uniaxialMaterial Steel02 $matID_B $Fy $Es $b $R0 $cR1 $cR2 $a1 $a2 $a3 $a4 $sigInit;

# 定义预应力筋参数
set fz 1030;
set E2 1.95e5;
#预应力筋初始应变
set initStrain 1.27e-3;





uniaxialMaterial Steel01 $matID_T0 $fz $E2 $b;   #预应力筋
uniaxialMaterial InitStrainMaterial $matID_T1 $matID_T0 $initStrain;



# 定义梁柱仅受压缝截面参数


# set Ect 2.06e9; 
# uniaxialMaterial ENT  $matID_G1  $Ect;
# uniaxialMaterial Elastic $matID_G2 [expr $Es/100];

#定义梁、柱截面
set secTag_C 1
set secTag_B 2
set secTag_RB 3
source WSection.tcl;
WSection $secTag_C $matID_C  446 416 62.7 39.1  10 2 2 5;
WSection $secTag_B $matID_B  610 228 17.3 11.2  10 2 2 5;
WSection $secTag_RB $matID_B  610 228 29.3 11.2  10 2 2 5;

set numIntgrPts 10;	
# 定义柱截面的几何性质 W360*509
	set Acol_12 64900;		# cross-sectional area
	set Icol_12  2.05E+9;	# moment of inertia
	# set Mycol_12 20350.0;	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dcol_12 446;		# depth
	set bfcol_12 416;		# flange width
	set tfcol_12 62.7;		# flange thickness
	set twcol_12 39.1;		# web thickness in the panel zone

# 定义梁截面的几何性质  W610*113
	set Abeam_23  14400;		# cross-sectional area (full section properties)
	set Ibeam_23  8.75E+8;	# moment of inertia  (full section properties)
	# set Mybeam_23 [expr 1.17*$Zbeam_23*$Fy];	# yield moment at plastic hinge location (i.e., My of RBS section)
	# set dbeam_23 608;		# depth
	set dbeam_23 842;		# depth


	
	
# 定义耗能器参数
set Ff 40000;
set Rhard 1e-5;
set Plate_W 160;
set Plate_t 20; 
set Number 60;
set Distance_bolt 80;
set Stiffness_Damper [expr ($Es*$Plate_W*$Plate_t)/$Number];
set Bolt_1 [expr $Stiffness_Damper/(40+$Distance_bolt*1+0)];
set Bolt_2 [expr $Stiffness_Damper/(40+$Distance_bolt*3+0)];
set Bolt_3 [expr $Stiffness_Damper/(40+$Distance_bolt*5+0)];
set Bolt_4 [expr $Stiffness_Damper/(40+$Distance_bolt*7+0)]; 
set Bolt_5 [expr $Stiffness_Damper/(40+$Distance_bolt*9+0)]; 
set Bolt_6 [expr $Stiffness_Damper/(40+$Distance_bolt*11+0)]; 
set Bolt_7 [expr $Stiffness_Damper/(40+$Distance_bolt*13+0)];

uniaxialMaterial Steel01 $matID_D1 $Ff $Bolt_1 $Rhard ;    # 耗能器
uniaxialMaterial Steel01 $matID_D2 $Ff $Bolt_2 $Rhard ;    # 耗能器
uniaxialMaterial Steel01 $matID_D3 $Ff $Bolt_3 $Rhard ;    # 耗能器
uniaxialMaterial Steel01 $matID_D4 $Ff $Bolt_4 $Rhard ;    # 耗能器
uniaxialMaterial Steel01 $matID_D5 $Ff $Bolt_5 $Rhard ;    # 耗能器
uniaxialMaterial Steel01 $matID_D6 $Ff $Bolt_6 $Rhard ;    # 耗能器
uniaxialMaterial Steel01 $matID_D7 $Ff $Bolt_7 $Rhard ;    # 耗能器	
	

	
# uniaxialMaterial Parallel $matTag $tag1 $tag2 ... <-factors $fact1 $fact2 ...>
uniaxialMaterial Parallel $matID_D10  $matID_D1 $matID_D2 $matID_D3 $matID_D4 $matID_D5 $matID_D6 $matID_D7; 




puts "element"	
# set up geometric transformation of elements
	set PDeltaTransf 1;
	geomTransf PDelta $PDeltaTransf; 	# PDelta transformation

#定义柱单元
# element	nonlinearBeamColumn	1  1000 16 $numIntgrPts	$secTag_C	$PDeltaTransf;	# Pier 1
# element	nonlinearBeamColumn	2  16 9 $numIntgrPts	$secTag_C	$PDeltaTransf;	# Pier 1
# element	nonlinearBeamColumn	3  3 13 $numIntgrPts	$secTag_C	$PDeltaTransf;	# Pier 1
# element	nonlinearBeamColumn	5  13 59 $numIntgrPts	$secTag_C	$PDeltaTransf;	# Pier 1
	
element	nonlinearBeamColumn	1  1000 9 $numIntgrPts	$secTag_C	$PDeltaTransf;	# Pier 1
element	nonlinearBeamColumn	2  3 59 $numIntgrPts	$secTag_C	$PDeltaTransf;	# Pier 1

	
#定义梁单元
element	nonlinearBeamColumn	3  19 21 $numIntgrPts	$secTag_RB	$PDeltaTransf;	# Pier 1
element	nonlinearBeamColumn	5  21 2000 $numIntgrPts	$secTag_B	$PDeltaTransf;	# Pier 1



#定义节点刚臂梁单元
	set Apz  [expr $Acol_12*100];	# area of panel zone element (make much larger than A of frame elements)
	set Ipz  [expr $Icol_12*100];  # moment of intertia of panel zone element (make much larger than I of frame elements)
	# elemPanelZone2D eleID  nodeR E  A_PZ I_PZ transfTag
	elemPanelZone2D   6 1 $Es $Apz $Ipz $PDeltaTransf;	# Pier 1, Floor 2

#定义节点旋转弹簧单元
	source rotPanelZone2D.tcl
	set Ry 1.2; 	# expected yield strength multiplier
	set as_PZ 0.01; # strain hardening of panel zones
	# Spring ID: "4xy00" where 4 = panel zone spring, x = Pier #, y = Floor #
	#2nd Floor PZ springs
	#             ElemID  ndR  ndC  E   Fy   dc       bf_c        tf_c       tp        db       Ry   as
	rotPanelZone2D 30 4 5 $Es $Fy $dcol_12 $bfcol_12 $tfcol_12 $twcol_12 $dbeam_23 $Ry $as_PZ;

	
	
#定义刚臂接触单元
element elasticBeamColumn    35    15 18    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    36    18 42    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    37    42 43    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    38    43 19    $Es $Apz $Ipz    $PDeltaTransf;

element elasticBeamColumn    39    19 44    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    40    44 45    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    41    45 20    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    42    20 17    $Es $Apz $Ipz    $PDeltaTransf;


	
# #定义预应力筋单元
# set ABfrp 4854;
# element truss 43 12 2000 $ABfrp $matID_T1; 	
	
	

#定义耗能器单元


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

element twoNodeLink 50 4 15 -mat $matID_D10  -dir 1;

element twoNodeLink 51 7 17 -mat $matID_D10  -dir 1;	

# 定义梁柱仅受压接触单元




set Stiffness_B [expr  $Abeam_23*$Es/$WBay]
uniaxialMaterial ENT  $matID_G1  [expr $Stiffness_B*15];
uniaxialMaterial ENT  $matID_G2  [expr $Stiffness_B*15];
uniaxialMaterial ENT  $matID_G3  [expr $Stiffness_B*15];
uniaxialMaterial Elastic $matID_G5 1E-5;

element zeroLength  58 30 18 -mat $matID_G1 -dir 1;
element zeroLength  59 31 42 -mat $matID_G2 -dir 1;
element zeroLength  60 32 43 -mat $matID_G3 -dir 1;
element zeroLength  61 33 44 -mat $matID_G3 -dir 1;
element zeroLength  62 34 45 -mat $matID_G2 -dir 1;
element zeroLength  63 35 20 -mat $matID_G1 -dir 1;



element zeroLength  65 30 18 -mat $matID_G5 -dir 1;
element zeroLength  66 31 42 -mat $matID_G5 -dir 1;
element zeroLength  67 32 43 -mat $matID_G5 -dir 1;
element zeroLength  68 33 44 -mat $matID_G5  -dir 1;
element zeroLength  69 34 45 -mat $matID_G5  -dir 1;
element zeroLength  70 35 20 -mat $matID_G5  -dir 1;

	
	
	
# # display the model with the node numbers
# DisplayModel2D NodeNumbers;
	


############################################################################
#              Recorders					                			   
############################################################################
# record drift histories
	# record drifts
	recorder Drift -file $dataDir/Drift-Story1.out -time -iNode 1000 -jNode 59 -dof 1 -perpDirn 2;
	
# record floor displacements	
	recorder Node -file $dataDir/Disp.out -time -node 59 -dof 1 disp;
	
# record base shear reactions
	recorder Node -file $dataDir/Vbase1.out -time -node 1000 -dof 1 reaction;
	recorder Node -file $dataDir/Vbase2.out -time -node 2000 -dof 2 reaction;
# record story 1 column forces in global coordinates 
	recorder Element -file $dataDir/Fcol1.out -time -ele 1 force;

# # record response history of all frame beam springs (one file for moment, one for rotation)
	# recorder Element -file $dataDir/MRFbeam-Mom-Hist.out -time -ele 31 force;
	# recorder Element -file $dataDir/MRFbeam-Rot-Hist.out -time -ele 31 deformation;

# record friction damper reactions
recorder Element -file $dataDir/ele50force.out -time -ele 50 localForce;
recorder Element -file $dataDir/ele50defor.out -time -ele 50 deformations;

recorder Element -file $dataDir/ele51force.out -time -ele 51 localForce;
recorder Element -file $dataDir/ele51defor.out -time -ele 51 deformations;
# record tendon force
recorder Element -file $dataDir/ele43force.out -time -ele 43 axialForce;	
############################################################################
#              Pushover Analysis                			   			   #
############################################################################

# # display deformed shape:
	# set ViewScale 5;
	# DisplayModel2D DeformedShape $ViewScale ;	# display deformed shape, the scaling factor needs to be adjusted for each model

set	dat1	0.00375
set	dat2	0.0075
set	dat3	0.01
set	dat4	0.015
set	dat5	0.02
set	dat6	0.031
set	dat7	0.036

# set	dat1	0.006
# set	dat2	0.011
# set	dat3	0.016
# set	dat4	0.021


puts "loads"
pattern Plain 1 Linear  {
load 59 1000 0 0
};
puts "analysis"
constraints Transformation;	
numberer Plain;
system BandGeneral;
test NormDispIncr 1.0e-6 200 0;
algorithm KrylovNewton;
integrator LoadControl 0.01;
analysis Static;
analyze 1;

set bm $HBuilding;
set iDmax "[expr $dat1*$bm] 
          [expr $dat2*$bm]
          [expr $dat3*$bm]
          [expr $dat4*$bm]
          [expr $dat5*$bm]
          [expr $dat6*$bm]
          [expr $dat7*$bm]" ;

set IDctrlNode 59
set IDctrlDOF 1
puts "analysis"
source boxanalyze.Static.Cycle.tcl

