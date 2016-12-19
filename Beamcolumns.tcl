

    set numIntgrPts 10;

    set invoketag 0
# 定义坐标转换
	set PDeltaTransf [expr $invoketag+1];
	geomTransf PDelta $PDeltaTransf; 	# PDelta transformation
	
	
	#第一层	
# 定义柱截面的几何性质 W14*398
	set Acol_(0) 75483;		# cross-sectional area
	set Icol_(0)  2.5E+9;	# moment of inertia
	# set Mycol_12 20350.0;	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dcol_(0) 464.6;		# depth
	set bfcol_(0) 421.4;		# flange width
	set tfcol_(0) 72.3;		# flange thickness
	# set twcol_(0) 76.8;		# web thickness in the panel zone
	set twcol_(0) 76.8;		# web thickness in the panel zone

# 定义梁截面的几何性质  W36*194
	set Abeam_(0)  36774;		# cross-sectional area (full section properties)
	set Ibeam_(0)  5.04E+9;	# moment of inertia  (full section properties)
	# set Mybeam_23 [expr 1.17*$Zbeam_23*$Fy];	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dbeam_(0) 926.8;		# depth
	set bfbeam_(0) 307.7;		# flange width
	set tfbeam_(0) 32;		# flange thickness
	set twbeam_(0) 19.4;		# web thickness 
#第二层	
# 定义柱截面的几何性质 W14*398
	set Acol_(1) 75483;		# cross-sectional area
	set Icol_(1)  2.5E+9;	# moment of inertia
	# set Mycol_12 20350.0;	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dcol_(1) 464.6;		# depth
	set bfcol_(1) 421.4;		# flange width
	set tfcol_(1) 72.3;		# flange thickness
	# set twcol_(1) 70.4;		# web thickness in the panel zone
	set twcol_(1) 70.4;		# web thickness in the panel zone

# 定义梁截面的几何性质  W36*182
	set Abeam_(1)  34581;		# cross-sectional area (full section properties)
	set Ibeam_(1)  4.7E+9;	# moment of inertia  (full section properties)
	# set Mybeam_23 [expr 1.17*$Zbeam_23*$Fy];	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dbeam_(1) 922.8;		# depth
	set bfbeam_(1) 306.7;		# flange width
	set tfbeam_(1) 30;		# flange thickness
	set twbeam_(1) 18.4;		# web thickness 




#第三层
# 定义柱截面的几何性质 W14*342
	set Acol_(2) 65161;		# cross-sectional area
	set Icol_(2)  2.0E+9;	# moment of inertia
	# set Mycol_12 20350.0;	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dcol_(2) 445.5;		# depth
	set bfcol_(2) 415.5;		# flange width
	set tfcol_(2) 62.7;		# flange thickness
	# set twcol_(2) 67.7;		# web thickness in the panel zone
	set twcol_(2) 67.7;		# web thickness in the panel zone

# 定义梁截面的几何性质  W36*170
	set Abeam_(2)  32258;		# cross-sectional area (full section properties)
	set Ibeam_(2)  4.37E+9;	# moment of inertia  (full section properties)
	# set Mybeam_23 [expr 1.17*$Zbeam_23*$Fy];	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dbeam_(2) 918.7;		# depth
	set bfbeam_(2) 305.6;		# flange width
	set tfbeam_(2) 27.9;		# flange thickness
	set twbeam_(2) 17.3;		# web thickness 		

	
#第四层
# 定义柱截面的几何性质 W14*342
	set Acol_(3) 65161;		# cross-sectional area
	set Icol_(3)  2.0E+9;	# moment of inertia
	# set Mycol_12 20350.0;	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dcol_(3) 445.5;		# depth
	set bfcol_(3) 415.5;		# flange width
	set tfcol_(3) 62.7;		# flange thickness
	# set twcol_(3) 55.0;		# web thickness in the panel zone
	set twcol_(3) 55.0;		# web thickness in the panel zone

# 定义梁截面的几何性质  W36*135
	set Abeam_(3)  25613;		# cross-sectional area (full section properties)
	set Ibeam_(3)  3.25E+9;	# moment of inertia  (full section properties)
	# set Mybeam_23 [expr 1.17*$Zbeam_23*$Fy];	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dbeam_(3) 903;		# depth
	set bfbeam_(3) 303.5;		# flange width
	set tfbeam_(3) 20.1;		# flange thickness
	set twbeam_(3) 15.2;		# web thickness 
#第五层
# 定义柱截面的几何性质 W14*283
	set Acol_(4) 53742;		# cross-sectional area
	set Icol_(4)  1.6E+9;	# moment of inertia
	# set Mycol_12 20350.0;	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dcol_(4) 425.2;		# depth
	set bfcol_(4) 409.2;		# flange width
	set tfcol_(4) 52.6;		# flange thickness
	# set twcol_(4) 51.9;		# web thickness in the panel zone
	set twcol_(4) 51.9;		# web thickness in the panel zone

# 定义梁截面的几何性质  W33*118
	set Abeam_(4)  22387;		# cross-sectional area (full section properties)
	set Ibeam_(4)  2.46E+9;	# moment of inertia  (full section properties)
	# set Mybeam_23 [expr 1.17*$Zbeam_23*$Fy];	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dbeam_(4) 834.6;		# depth
	set bfbeam_(4) 291.6;		# flange width
	set tfbeam_(4) 18.8;		# flange thickness
	set twbeam_(4) 14.0;		# web thickness 
#第六层
	# 定义柱截面的几何性质 W14*283
	set Acol_(5) 53742;		# cross-sectional area
	set Icol_(5)  1.6E+9;	# moment of inertia
	# set Mycol_12 20350.0;	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dcol_(5) 425.2;		# depth
	set bfcol_(5) 409.2;		# flange width
	set tfcol_(5) 52.6;		# flange thickness
	# set twcol_(5) 32.8;		# web thickness in the panel zone
	set twcol_(5) 32.8;		# web thickness in the panel zone

# 定义梁截面的几何性质  W30*90
	set Abeam_(5)  17032;		# cross-sectional area (full section properties)
	set Ibeam_(5)  1.5E+9;	# moment of inertia  (full section properties)
	# set Mybeam_23 [expr 1.17*$Zbeam_23*$Fy];	# yield moment at plastic hinge location (i.e., My of RBS section)
	set dbeam_(5) 750.1;		# depth
	set bfbeam_(5) 264.2;		# flange width
	set tfbeam_(5) 15.5;		# flange thickness
	set twbeam_(5) 11.9;		# web thickness 
	
	
	# define FDs parameters
    #梁上下摩擦耗能器间距
    set FR_(0) 966.8;
    set FR_(1) 962.8;
    set FR_(2) 958.7;
    set FR_(3) 943;
    set FR_(4) 874.6;
    set FR_(5) 790.1;
	#梁端加强板长度
	set RP 1828.8;
    #梁端加强板厚度
	set Drp_(0) 31.7;
	set Drp_(1) 28.6;
	set Drp_(2) 25.4;
	set Drp_(3) 25.4;
	set Drp_(4) 22.2;
	set Drp_(5) 14.3;
	#梁翼缘厚度
	set Bf_(0) $twbeam_(0);
	set Bf_(1) $twbeam_(1);
	set Bf_(2) $twbeam_(2);
	set Bf_(3) $twbeam_(3);
	set Bf_(4) $twbeam_(4);
	set Bf_(5) $twbeam_(5);
	#柱端连接点
	set columnend_(0) 1000;
	set columnend_(1) 1000;
	set columnend_(2) 1000;
	set columnend_(3) 1000;
	set columnend_(4) 1000;
	set columnend_(5) 1000;

	# 定义材料性质

    set matID_C [expr 1+$invoketag];         # 钢柱标签
	set matID_B [expr 2+$invoketag];         # 钢梁标签
	set matID_Ch [expr 3+$invoketag];          # 梁Channel单元标签

	
	

	for  {set p 0} { $p<$NStories} {incr p} {
	set matID_G1($p) [expr $p*12+4+$invoketag];          # 梁柱仅受压接触单元标签
	set matID_G2($p) [expr $p*12+5+$invoketag];          # 梁柱仅受压接触单元标签
	set matID_G3($p) [expr $p*12+6+$invoketag];          # 梁柱仅受压接触单元标签
	set matID_G5($p) [expr $p*12+7+$invoketag];          # 梁柱受拉接触单元标签
	
	set matID_D1($p) [expr $p*12+8+$invoketag];          # 耗能器标签
	set matID_D2($p) [expr $p*12+9+$invoketag];          # 耗能器标签
	set matID_D3($p) [expr $p*12+10+$invoketag];          # 耗能器标签
	set matID_D4($p) [expr $p*12+11+$invoketag];          # 耗能器标签
	set matID_D5($p) [expr $p*12+12+$invoketag];         # 耗能器标签
	set matID_D6($p) [expr $p*12+13+$invoketag];         # 耗能器标签
	set matID_D7($p) [expr $p*12+14+$invoketag];         # 耗能器标签
	set matID_D10($p) [expr $p*12+15+$invoketag];        # 耗能器标签
    }
	# 定义材料性质

	set Es 2.06e5;			# 钢弹性模量
	set Fy 345;			# 钢屈服强度
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
uniaxialMaterial Steel02 $matID_Ch $Fy $Es $b $R0 $cR1 $cR2 $a1 $a2 $a3 $a4 $sigInit;


# 定义梁柱仅受压缝截面参数


# set Ect 2.06e9; 
# uniaxialMaterial ENT  $matID_G1  $Ect;
# uniaxialMaterial Elastic $matID_G2 [expr $Es/100];

#定义每层耗能器滑动力
#第六层
set Ff(5) [expr 355000/7];
#第五层
set Ff(4) [expr 526000/7];
#第四层
set Ff(3) [expr 559000/7];
#第三层
set Ff(2) [expr 735000/7];
#第二层
set Ff(1) [expr 755000/7];
#第一层
set Ff(0) [expr 730000/7];
	
	
	
# 定义耗能器参数
set Rhard 1e-10;
set Plate_W 508;
set Plate_t 12.7; 
set Number 50;
set Distance_bolt 80;
set Stiffness_Damper [expr ($Es*$Plate_W*$Plate_t)/$Number];
set Bolt_1 [expr $Stiffness_Damper/(40+$Distance_bolt*1+0)];
set Bolt_2 [expr $Stiffness_Damper/(40+$Distance_bolt*3+0)];
set Bolt_3 [expr $Stiffness_Damper/(40+$Distance_bolt*5+0)];
set Bolt_4 [expr $Stiffness_Damper/(40+$Distance_bolt*7+0)]; 
set Bolt_5 [expr $Stiffness_Damper/(40+$Distance_bolt*9+0)]; 
set Bolt_6 [expr $Stiffness_Damper/(40+$Distance_bolt*11+0)]; 
set Bolt_7 [expr $Stiffness_Damper/(40+$Distance_bolt*13+0)];

for  {set p 0} { $p<$NStories} {incr p} {
uniaxialMaterial Steel01 $matID_D1($p) $Ff($p) $Bolt_1 $Rhard ;    # 耗能器
uniaxialMaterial Steel01 $matID_D2($p) $Ff($p) $Bolt_2 $Rhard ;    # 耗能器
uniaxialMaterial Steel01 $matID_D3($p) $Ff($p) $Bolt_3 $Rhard ;    # 耗能器
uniaxialMaterial Steel01 $matID_D4($p) $Ff($p) $Bolt_4 $Rhard ;    # 耗能器
uniaxialMaterial Steel01 $matID_D5($p) $Ff($p) $Bolt_5 $Rhard ;    # 耗能器
uniaxialMaterial Steel01 $matID_D6($p) $Ff($p) $Bolt_6 $Rhard ;    # 耗能器
uniaxialMaterial Steel01 $matID_D7($p) $Ff($p) $Bolt_7 $Rhard ;    # 耗能器
# uniaxialMaterial Parallel $matTag $tag1 $tag2 ... <-factors $fact1 $fact2 ...>
uniaxialMaterial Parallel $matID_D10($p)  $matID_D1($p) $matID_D2($p) $matID_D3($p) $matID_D4($p) $matID_D5($p) $matID_D6($p) $matID_D7($p); 
}	

	


# 定义梁柱仅受压接触参数
for  {set p 0} { $p<$NStories} {incr p} {
set Stiffness_B [expr  $Abeam_($p)*$Es/$WBay]
uniaxialMaterial ENT  $matID_G1($p)  [expr $Stiffness_B*1];
uniaxialMaterial ENT  $matID_G2($p)  [expr $Stiffness_B*1];
uniaxialMaterial ENT  $matID_G3($p)  [expr $Stiffness_B*1];
uniaxialMaterial Elastic $matID_G5($p) 0.02;
}


puts "section"
set secTag_C(0) [expr 1+$invoketag]
set secTag_B(0) [expr 2+$invoketag]
set secTag_RB(0) [expr 3+$invoketag]

set secTag_C(1) [expr 11+$invoketag]
set secTag_B(1) [expr 12+$invoketag]
set secTag_RB(1) [expr 13+$invoketag]

set secTag_C(2) [expr 21+$invoketag]
set secTag_B(2) [expr 22+$invoketag]
set secTag_RB(2) [expr 23+$invoketag]

set secTag_C(3) [expr 31+$invoketag]
set secTag_B(3) [expr 32+$invoketag]
set secTag_RB(3) [expr 33+$invoketag]

set secTag_C(4) [expr 41+$invoketag]
set secTag_B(4) [expr 42+$invoketag]
set secTag_RB(4) [expr 43+$invoketag]

set secTag_C(5) [expr 51+$invoketag]
set secTag_B(5) [expr 52+$invoketag]
set secTag_RB(5) [expr 53+$invoketag]


#定义第一层梁柱截面 W14*398 W36*194
WSection $secTag_C(0) $matID_C  464 421 72.3 45.0  10 2 2 5;
WSection $secTag_B(0) $matID_B  927 308 32.0 19.4  10 2 2 5;
WSection $secTag_RB(0) $matID_Ch  927 308 63.8 19.4  10 2 2 5;
#定义第二层梁柱截面 W14*398 W36*182
WSection $secTag_C(1) $matID_C  464 421 72.3 45.0  10 2 2 5;
WSection $secTag_B(1) $matID_B  923 307 30 18.4  10 2 2 5;
WSection $secTag_RB(1) $matID_Ch  923 307 58.6 18.4  10 2 2 5;
#定义第三层梁柱截面 W14*342 W36*170
WSection $secTag_C(2) $matID_C  446 416 62.7 39.1  10 2 2 5;
WSection $secTag_B(2) $matID_B  919 306 27.9 17.3  10 2 2 5;
WSection $secTag_RB(2) $matID_Ch  919 306 53.3 17.3  10 2 2 5;
#定义第四层梁柱截面 W14*342 W36*135
WSection $secTag_C(3) $matID_C  446 416 62.7 39.1  10 2 2 5;
WSection $secTag_B(3) $matID_B  903 304 20.1 15.2  10 2 2 5;
WSection $secTag_RB(3) $matID_Ch  903 304 45.5 15.2  10 2 2 5;
#定义第五层梁柱截面 W14*283 W33*118
WSection $secTag_C(4) $matID_C  425 409 52.6 32.8  10 2 2 5;
WSection $secTag_B(4) $matID_B  835 292 18.8 14.0  10 2 2 5;
WSection $secTag_RB(4) $matID_Ch  835 292 41.0 14.0  10 2 2 5;
#定义第六层梁柱截面 W14*283 W30*90
WSection $secTag_C(5) $matID_C  425 409 52.6 32.8  10 2 2 5;
WSection $secTag_B(5) $matID_B  750 264 15.5 11.9  10 2 2 5;
WSection $secTag_RB(5) $matID_Ch  750 264 29.8 11.9  10 2 2 5;




