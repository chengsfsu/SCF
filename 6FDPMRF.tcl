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

# 定义柱截面的几何性质 W14*398
	set Acol_12 75483;		# cross-sectional area
	set Icol_12  2.5E+9;	# moment of inertia
	# set Mycol_12 20350.0;	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dcol_12 464.6;		# depth
	set bfcol_12 421.4;		# flange width
	set tfcol_12 72.3;		# flange thickness
	set twcol_12 76.71;		# web thickness in the panel zone

# 定义梁截面的几何性质  W36*194
	set Abeam_23  36774;		# cross-sectional area (full section properties)
	set Ibeam_23  5.04E+9;	# moment of inertia  (full section properties)
	# set Mybeam_23 [expr 1.17*$Zbeam_23*$Fy];	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dbeam_23 926.8;		# depth
	set bfbeam_23 307.7;		# flange width
	set tfbeam_23 32;		# flange thickness
	set twbeam_23 19.4;		# web thickness 
puts "node"
# define structure-geometry parameters
	set NStories 1;						# 总楼层数
	set NBays 1;						# 总跨数(除重力柱以外)
	set WBay      9150;		# 跨长
	set HStory1   4570;		# 第一层高度
	set HStoryTyp 3900;		# 其他层高度
	set HBuilding [expr $HStory1 + ($NStories-1)*$HStoryTyp];	# 建筑总高度

# calculate locations of beam-column joint centerlines:
	set Pier1  0.0;		# 柱线1
	set Pier2  [expr $Pier1 + $WBay];     # 柱线2	

	set Floor1 0.0;		# 地面
	set Floor2 [expr $Floor1 + $HStory1]; # 楼层1

	
# calculate panel zone dimensions
	set pzlat23  [expr $dcol_12/2.0];	# 中心线到节点边缘的水平距离 (= 柱高的一半)
	set pzvert23 [expr $dbeam_23/2.0];	# 中心线到节点边缘的垂直距离 (= 梁高的一半)

# calculate plastic hinge offsets from beam-column centerlines:
	set phlat23 [expr $pzlat23 + 0.0];	# 中心线到梁铰的水平距离
	set phvert23 [expr $pzvert23 + 0.0];			# 中心线到柱铰的垂直距离


	# define FDs parameters
    #梁上下摩擦耗能器间距
    set FR 964.9;
	#梁端加强板长度
	set RP 1828.8;
    #梁端加强板厚度
	set Drp 31.7;
	#梁翼缘厚度
	set Bf $twbeam_23;

    
	
	
    set n 1; # 层数
	set m 2; # 柱数
	set node1 50;
	set node2 100;
	
	for  {set j 0} { $j<$n} {incr j} {
    for  {set i 0} { $i<$m} {incr i} {
	# 梁柱节点1 at Pier 2, Floor 2
	node [expr $i*$node1+1+$j*$m*$node1] [expr $i*$WBay+$Pier1 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $FR/2];
	node [expr $i*$node1+2+$j*$m*$node1] [expr $i*$WBay+$Pier1 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $FR/2];
	node [expr $i*$node1+3+$j*$m*$node1] [expr $i*$WBay+$Pier1]  [expr $j*$HStoryTyp+$Floor2 + $FR/2];
	node [expr $i*$node1+4+$j*$m*$node1] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $FR/2];
	node [expr $i*$node1+5+$j*$m*$node1] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $FR/2];
	node [expr $i*$node1+6+$j*$m*$node1] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2];
	node [expr $i*$node1+7+$j*$m*$node1] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $FR/2];
	node [expr $i*$node1+8+$j*$m*$node1] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $FR/2];
	node [expr $i*$node1+9+$j*$m*$node1] [expr $i*$WBay+$Pier1]  [expr $j*$HStoryTyp+$Floor2 - $FR/2]; 
	node [expr $i*$node1+10+$j*$m*$node1] [expr $i*$WBay+$Pier1 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $FR/2];
	node [expr $i*$node1+11+$j*$m*$node1] [expr $i*$WBay+$Pier1 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $FR/2];
	node [expr $i*$node1+12+$j*$m*$node1] [expr $i*$WBay+$Pier1 - $pzlat23] [expr $j*$HStoryTyp+$Floor2];
	
	# 梁柱节点1缝隙张开增加点 at Pier 2, Floor 2
	node [expr $i*$node1+30+$j*$m*$node1] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $phvert23];
    node [expr $i*$node1+31+$j*$m*$node1] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $phvert23-$Drp];
    node [expr $i*$node1+32+$j*$m*$node1] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $phvert23-$Drp-$Bf];

    node [expr $i*$node1+33+$j*$m*$node1] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $phvert23+$Drp+$Bf];
    node [expr $i*$node1+34+$j*$m*$node1] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $phvert23+$Drp];
    node [expr $i*$node1+35+$j*$m*$node1] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $phvert23];

		
	node [expr $i*$node1+36+$j*$m*$node1] [expr $i*$WBay+$Pier1 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $phvert23];
	node [expr $i*$node1+37+$j*$m*$node1] [expr $i*$WBay+$Pier1 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $phvert23-$Drp];
    node [expr $i*$node1+38+$j*$m*$node1] [expr $i*$WBay+$Pier1 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $phvert23-$Drp-$Bf];

    node [expr $i*$node1+39+$j*$m*$node1] [expr $i*$WBay+$Pier1 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $phvert23+$Drp+$Bf];
    node [expr $i*$node1+40+$j*$m*$node1] [expr $i*$WBay+$Pier1 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $phvert23+$Drp];
    node [expr $i*$node1+41+$j*$m*$node1] [expr $i*$WBay+$Pier1 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $phvert23];
	
	}
	}
	
    for  {set j 0} { $j<$n} {incr j} {
    for  {set i 0} { $i<[expr $m-1]} {incr i} {
	#耗能器受力点
    node [expr $i*$node2+15+$j*$m*$node2] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $FR/2];
    node [expr $i*$node2+17+$j*$m*$node2] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $FR/2];
	
    #梁端部受力点
    node [expr $i*$node2+18+$j*$m*$node2] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $phvert23];
    node [expr $i*$node2+19+$j*$m*$node2] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2];
    node [expr $i*$node2+20+$j*$m*$node2] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $phvert23];
	
	#梁端加强板端点
	node [expr $i*$node2+21+$j*$m*$node2] [expr $i*$WBay+$Pier1 + $pzlat23+$RP] [expr $j*$HStoryTyp+$Floor2];
	
	
	#梁端部受力点缝隙张开增加点
	node [expr $i*$node2+42+$j*$m*$node2] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $phvert23-$Drp];
	node [expr $i*$node2+43+$j*$m*$node2] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $phvert23-$Drp-$Bf];
    
    node [expr $i*$node2+44+$j*$m*$node2] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $phvert23+$Drp+$Bf];
    node [expr $i*$node2+45+$j*$m*$node2] [expr $i*$WBay+$Pier1 + $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $phvert23+$Drp];
	}
	}
	
	for  {set j 0} { $j<$n} {incr j} {
    for  {set i 0} { $i<[expr $m-1]} {incr i} {
	#耗能器受力点
    node [expr $i*$node2+65+$j*$m*$node2] [expr $i*$WBay+$Pier2 - $pzlat23] [expr  $j*$HStoryTyp+$Floor2 + $FR/2];
    node [expr $i*$node2+67+$j*$m*$node2] [expr $i*$WBay+$Pier2 - $pzlat23] [expr  $j*$HStoryTyp+$Floor2 - $FR/2];
	
    #梁端部受力点
    node [expr $i*$node2+68+$j*$m*$node2] [expr $i*$WBay+$Pier2 - $pzlat23] [expr  $j*$HStoryTyp+$Floor2 + $phvert23];
    node [expr $i*$node2+69+$j*$m*$node2] [expr $i*$WBay+$Pier2 - $pzlat23] [expr  $j*$HStoryTyp+$Floor2];
    node [expr $i*$node2+70+$j*$m*$node2] [expr $i*$WBay+$Pier2 - $pzlat23] [expr  $j*$HStoryTyp+$Floor2 - $phvert23];
	
	#梁端加强板端点
	node [expr $i*$node2+71+$j*$m*$node2] [expr $i*$WBay+$Pier2 - $pzlat23-$RP] [expr $j*$HStoryTyp+$Floor2;]
	
	#梁端部受力点缝隙张开增加点
	node [expr $i*$node2+92+$j*$m*$node2] [expr $i*$WBay+$Pier2 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $phvert23-$Drp];
	node [expr $i*$node2+93+$j*$m*$node2] [expr $i*$WBay+$Pier2 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 + $phvert23-$Drp-$Bf];
    
    node [expr $i*$node2+94+$j*$m*$node2] [expr $i*$WBay+$Pier2 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $phvert23+$Drp+$Bf];
    node [expr $i*$node2+95+$j*$m*$node2] [expr $i*$WBay+$Pier2 - $pzlat23] [expr $j*$HStoryTyp+$Floor2 - $phvert23+$Drp];
	}
	}	
	
	
	

	
	
	

	
	
	
	for  {set i 0} { $i<$m} {incr i} {
	# 地面节点
	node [expr $i*10000+10000] [expr $i*$WBay+$Pier1] $Floor1;
	}
	
	# # 定义填充墙节点
	# node 96 $Pier1 [expr $Floor2 - $FR/2];
	# node 97 $Pier2 [expr $Floor2 - $FR/2]; 
	# node 98 $Pier1 $Floor1;
	# node 99 $Pier2 $Floor1;
	
	
	
	
	# 地面固结
	for  {set i 0} { $i<$m} {incr i} {
	fix [expr $i*10000+10000] 1 1 0;
	}

    equalDOF 62 69 2;
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

	
	set matID_D10 18;          # 耗能器标签
	
	set matID_G1 19;          # 梁柱仅受压接触单元标签
	set matID_G2 20;          # 梁柱仅受压接触单元标签
	set matID_G3 21;          # 梁柱仅受压接触单元标签
	set matID_G5 22;          # 梁柱受拉接触单元标签	

	
	
	


	
# 定义Hysteretic填充墙材料参数

# # 300厚混凝土填充墙
# set s1p 0.1;
# set e1p 5.39542E-05;
# set s2p 0.1;
# set e2p 0.000829267;
# set s3p 0.1;
# set e3p 0.004336289;

# set s1n -1.932563756;
# set e1n -5.39542E-05;
# set s2n -2.512332883;
# set e2n -0.000829267;
# set s3n -0.502466577;
# set e3n -0.004336289;





# # 200厚石灰岩填充墙

# set s1p 0.1;
# set e1p 0.000114895;
# set s2p 0.1;
# set e2p 0.002187931;
# set s3p 0.1;
# set e3p 0.009656086;

# set s1n -5.765738169;
# set e1n -0.000114895;
# set s2n -7.49545962;
# set e2n -0.002187931;
# set s3n -1.499091924;
# set e3n -0.009656086;

# 300厚石灰岩填充墙

set s1p 0.1;
set e1p 0.000114895;
set s2p 0.1;
set e2p 0.002278467;
set s3p 0.1;
set e3p 0.009746622;

set s1n -6.004322938;
set e1n -0.000114895;
set s2n -7.80561982;
set e2n -0.002278467;
set s3n -1.561123964;
set e3n -0.009746622;


set pinchX 1;
set pinchY 1;
set damage1 0;
set damage2 0;
set beta  0.6;
uniaxialMaterial Hysteretic $matID_P $s1p $e1p $s2p $e2p $s3p $e3p $s1n $e1n $s2n $e2n $s3n $e3n $pinchX $pinchY $damage1 $damage2 $beta;
	
	
# 定义填充墙铰接参数
set E0 2.06e10;
set E1 1;
uniaxialMaterial Elastic $matID_Z1 $E0;
uniaxialMaterial Elastic $matID_Z2 $E1;		
	
	
	# 定义Steel02材料参数
	set Es 2.06e5;			# 钢弹性模量
	set Fy 385;			# 钢屈服强度
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
# set fz 1030;
    set fz 1723.8;
    set E2 1.95e5;
    set b 0.007;
#预应力筋初始应变
set initStrain 2.31e-3;



# uniaxialMaterial Elastic $matID_T0 $E2;

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
WSection $secTag_C $matID_C  464 421 72.3 45.0  10 2 2 5;
WSection $secTag_B $matID_B  927 308 32.0 19.4  10 2 2 5;
WSection $secTag_RB $matID_B 927 308 63.8 19.4  10 2 2 5;

set numIntgrPts 10;	

	
# 定义耗能器参数
# set Ff 26071;
set Ff 104286;
set E3 2.06E5
set Rhard 1e-5;
set Plate_W 508;
set Plate_t 12.7; 
set Number 40;
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
set q 200
# set up geometric transformation of elements
	set PDeltaTransf 1;
	geomTransf PDelta $PDeltaTransf; 	# PDelta transformation

    #定义柱单元
	if {$n != 1} {
	for  {set j 0} { $j<[expr $n-1]} {incr j} {
    for  {set i 0} { $i<$m} {incr i} {
	element	nonlinearBeamColumn [expr $q*$i+1+$j*$m*$node1+$m*$node1] [expr $i*$node1+3+$j*$m*$node1] [expr $i*$node1+9+$j*$m*$node1+$m*$node1]  $numIntgrPts	$secTag_C	$PDeltaTransf;	
    }
    }
    }


	for  {set i 0} { $i<$m} {incr i} {
	# 地面节点
	element	nonlinearBeamColumn	[expr 1+$q*$i]  [expr $i*10000+10000] [expr $i*$node1+9] $numIntgrPts	$secTag_C	$PDeltaTransf;
	}
	
#定义梁单元


	for  {set j 0} { $j<[expr $n-1]} {incr j} {
    for  {set i 0} { $i<$m} {incr i} {
    element	nonlinearBeamColumn	3  69 71 $numIntgrPts	$secTag_RB	$PDeltaTransf;	# Pier 1
    element	nonlinearBeamColumn	4  19 21 $numIntgrPts	$secTag_RB	$PDeltaTransf;	# Pier 1
    element	nonlinearBeamColumn	5  71 21 $numIntgrPts	$secTag_B	$PDeltaTransf;	# Pier 1
    }
    }
#定义节点刚臂梁单元
	set Apz  [expr $Acol_12*100];	# area of panel zone element (make much larger than A of frame elements)
	set Ipz  [expr $Icol_12*100];  # moment of intertia of panel zone element (make much larger than I of frame elements)
	# elemPanelZone2D eleID  nodeR E  A_PZ I_PZ transfTag
	elemPanelZone2D   6 51 $Es $Apz $Ipz $PDeltaTransf;	# Pier 1, Floor 2
	elemPanelZone2D   30 1 $Es $Apz $Ipz $PDeltaTransf;	# Pier 1, Floor 2

#定义节点旋转弹簧单元
	source rotPanelZone2D.tcl
	set Ry 1.2; 	# expected yield strength multiplier
	set as_PZ 0.01; # strain hardening of panel zones
	# Spring ID: "4xy00" where 4 = panel zone spring, x = Pier #, y = Floor #
	#2nd Floor PZ springs
	#             ElemID  ndR  ndC  E   Fy   dc       bf_c        tf_c       tp        db       Ry   as
	rotPanelZone2D 55 54 55 $Es $Fy $dcol_12 $bfcol_12 $tfcol_12 $twcol_12 $dbeam_23 $Ry $as_PZ;
	rotPanelZone2D 58 4 5 $Es $Fy $dcol_12 $bfcol_12 $tfcol_12 $twcol_12 $dbeam_23 $Ry $as_PZ;

	
	
#定义刚臂接触单元
element elasticBeamColumn    61    65 68    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    62    68 92    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    63    92 93    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    64    93 69    $Es $Apz $Ipz    $PDeltaTransf;

element elasticBeamColumn    65    69 94    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    66    94 95    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    67    95 70    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    68    70 67    $Es $Apz $Ipz    $PDeltaTransf;




#定义刚臂接触单元
element elasticBeamColumn    69    15 18    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    70    18 42    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    71    42 43    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    72    43 19    $Es $Apz $Ipz    $PDeltaTransf;

element elasticBeamColumn    73    19 44    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    74    44 45    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    75    45 20    $Es $Apz $Ipz    $PDeltaTransf;
element elasticBeamColumn    76    20 17    $Es $Apz $Ipz    $PDeltaTransf;


	
#定义预应力筋单元
# set ABfrp 2317;
set ABfrp 9262;
element truss 77 56 12 $ABfrp $matID_T1; 	
	
	

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

element twoNodeLink 78 51 65 -mat $matID_D10  -dir 1;

element twoNodeLink 79 60 67 -mat $matID_D10  -dir 1;	

element twoNodeLink 80 4 15 -mat  $matID_D10  -dir 1;
 
element twoNodeLink 81 7 17 -mat  $matID_D10  -dir 1;

# 定义梁柱仅受压接触单元




set Stiffness_B [expr  $Abeam_23*$Es/$WBay]
uniaxialMaterial ENT  $matID_G1  [expr $Stiffness_B*50];
uniaxialMaterial ENT  $matID_G2  [expr $Stiffness_B*50];
uniaxialMaterial ENT  $matID_G3  [expr $Stiffness_B*50];
uniaxialMaterial Elastic $matID_G5 1E-5;

element zeroLength  82 68 86 -mat $matID_G1 -dir 1;
element zeroLength  83 92 87 -mat $matID_G2 -dir 1;
element zeroLength  84 93 88 -mat $matID_G3 -dir 1;
element zeroLength  85 94 89 -mat $matID_G3 -dir 1;
element zeroLength  86 95 90 -mat $matID_G2 -dir 1;
element zeroLength  87 70 91 -mat $matID_G1 -dir 1;



element zeroLength  88 68 86 -mat $matID_G5 -dir 1;
element zeroLength  89 92 87 -mat $matID_G5 -dir 1;
element zeroLength  90 93 88 -mat $matID_G5 -dir 1;
element zeroLength  91 94 89 -mat $matID_G5  -dir 1;
element zeroLength  92 95 90 -mat $matID_G5  -dir 1;
element zeroLength  93 70 91 -mat $matID_G5  -dir 1;

	
element zeroLength  94 30 18 -mat $matID_G1 -dir 1;
element zeroLength  95 31 42 -mat $matID_G2 -dir 1;
element zeroLength  96 32 43 -mat $matID_G3 -dir 1;
element zeroLength  97 33 44 -mat $matID_G3 -dir 1;
element zeroLength  98 34 45 -mat $matID_G2 -dir 1;
element zeroLength  99 35 20 -mat $matID_G1 -dir 1;



element zeroLength  100 30 18 -mat $matID_G5 -dir 1;
element zeroLength  101 31 42 -mat $matID_G5 -dir 1;
element zeroLength  102 32 43 -mat $matID_G5 -dir 1;
element zeroLength  103 33 44 -mat $matID_G5  -dir 1;
element zeroLength  104 34 45 -mat $matID_G5  -dir 1;
element zeroLength  105 35 20 -mat $matID_G5  -dir 1;	

# #定义填充墙单元
# #300厚混凝土填充墙
# set Area 355860;
# # 200厚石灰岩填充墙
# set Area 234340;
# # 300厚石灰岩填充墙
# set Area 351510;

# element truss 116 96 99 $Area $matID_P; 
# element truss 117 97 98 $Area $matID_P; 

# element zeroLength  118 9 96     -mat $matID_Z1 $matID_Z1 $matID_Z2 -dir 1 2 3;
# element zeroLength  119 99 20000  -mat $matID_Z1 $matID_Z1 $matID_Z2 -dir 1 2 3;
# element zeroLength  120 98 10000  -mat $matID_Z1 $matID_Z1 $matID_Z2 -dir 1 2 3;
# element zeroLength  121 59 97    -mat $matID_Z1 $matID_Z1 $matID_Z2 -dir 1 2 3;

	
# # display the model with the node numbers
# DisplayModel2D NodeNumbers;
	


############################################################################
#              Recorders					                			   
############################################################################
# record drift histories
	# record drifts
	recorder Drift -file $dataDir/Drift-Story1.out -time -iNode 10000 -jNode 21 -dof 1 -perpDirn 2;
	
# record floor displacements	
	recorder Node -file $dataDir/Disp.out -time -node 21 -dof 1 disp;
	
# record base shear reactions
	recorder Node -file $dataDir/Vbase1.out -time -node 10000 -dof 1 reaction;
	recorder Node -file $dataDir/Vbase2.out -time -node 20000 -dof 1 reaction;

# record column shear force
	recorder Element -file $dataDir/ele1force.out -time -ele 1 localForce;
	recorder Element -file $dataDir/ele2force.out -time -ele 2 localForce;

# record friction damper reactions
recorder Element -file $dataDir/ele78force.out -time -ele 78 localForce;
recorder Element -file $dataDir/ele78defor.out -time -ele 78 deformations;

recorder Element -file $dataDir/ele80force.out -time -ele 80 localForce;
recorder Element -file $dataDir/ele80defor.out -time -ele 80 deformations;
# record tendon force
recorder Element -file $dataDir/ele77force.out -time -ele 77 axialForce;
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




puts "loads"
pattern Plain 1 Linear  {
load 21 1000 0 0
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

set IDctrlNode 21;
set IDctrlDOF 1;
puts "analysis"
source boxanalyze.Static.Cycle.tcl;

