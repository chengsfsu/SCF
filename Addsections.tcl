puts "Addsections"
	model BasicBuilder -ndm 2 -ndf 3;
	# 定义材料性质
 
	set matID_C 1;
	set matID_B 2;
	set matID_Ficc1 3;
	set matID_Ficc2 5;
	set matID_Ficc3 6;
	set Bottomnspring1 7;
	set Bottomnspring2 8;
		
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
# uniaxialMaterial Elastic $matTag $E <$eta> <$Eneg>
uniaxialMaterial Elastic $matID_Ficc3 $Es
#铰接参数
uniaxialMaterial Elastic $matID_Ficc1 [expr $Es*1E10];
uniaxialMaterial Elastic $matID_Ficc2 1;

#地下室转动贡献
uniaxialMaterial Elastic $Bottomnspring1 [expr $Es*1E10];
uniaxialMaterial Elastic $Bottomnspring2 5.65E11;
set secTag_C(0) [expr 1]
set secTag_B(0) [expr 2]
set secTag_RB(0) [expr 3]

set secTag_C(1) [expr 11]
set secTag_B(1) [expr 12]
set secTag_RB(1) [expr 13]

set secTag_C(2) [expr 21]
set secTag_B(2) [expr 22]
set secTag_RB(2) [expr 23]

set secTag_C(3) [expr 31]
set secTag_B(3) [expr 32]
set secTag_RB(3) [expr 33]

set secTag_C(4) [expr 41]
set secTag_B(4) [expr 42]
set secTag_RB(4) [expr 43]

set secTag_C(5) [expr 51]
set secTag_B(5) [expr 52]
set secTag_RB(5) [expr 53]

set secTag_Ficc [expr 55]

set dbeam_(0) 926.8;		# depth
set dbeam_(1) 922.8;		# depth
set dbeam_(2) 918.7;		# depth
set dbeam_(3) 903;		    # depth
set dbeam_(4) 834.6;		# depth
set dbeam_(5) 750.1;		# depth

#定义第一层梁柱截面 W14*398 W36*194
WSection $secTag_C(0) $matID_C  464 421 72.3 45.0  10 2 2 5;
WSection $secTag_B(0) $matID_B  927 308 32.0 19.4  10 2 2 5;

#定义第二层梁柱截面 W14*398 W36*182
WSection $secTag_C(1) $matID_C  464 421 72.3 45.0  10 2 2 5;
WSection $secTag_B(1) $matID_B  923 307 30 18.4  10 2 2 5;

#定义第三层梁柱截面 W14*342 W36*170
WSection $secTag_C(2) $matID_C  446 416 62.7 39.1  10 2 2 5;
WSection $secTag_B(2) $matID_B  919 306 27.9 17.3  10 2 2 5;

#定义第四层梁柱截面 W14*342 W36*135
WSection $secTag_C(3) $matID_C  446 416 62.7 39.1  10 2 2 5;
WSection $secTag_B(3) $matID_B  903 304 20.1 15.2  10 2 2 5;

#定义第五层梁柱截面 W14*283 W33*118
WSection $secTag_C(4) $matID_C  425 409 52.6 32.8  10 2 2 5;
WSection $secTag_B(4) $matID_B  835 292 18.8 14.0  10 2 2 5;

#定义第六层梁柱截面 W14*283 W30*90
WSection $secTag_C(5) $matID_C  425 409 52.6 32.8  10 2 2 5;
WSection $secTag_B(5) $matID_B  750 264 15.5 11.9  10 2 2 5;


WSection $secTag_Ficc $matID_Ficc3  7500 2640 155 119  10 2 2 5;
