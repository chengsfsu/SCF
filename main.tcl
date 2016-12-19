# Units: N, mm, seconds

###################################################################################################
#          Source定义								  
###################################################################################################
	wipe all;							# clear memory of past model definitions
	model BasicBuilder -ndm 2 -ndf 3;	# Define the model builder, ndm = #dimension, ndf = #dofs
	source DisplayModel2D.tcl;			# procedure for displaying a 2D perspective of model
	source DisplayPlane.tcl;			# procedure for displaying a plane in a model
	source rotPanelZone2D.tcl;			# procedure for defining a rotational spring (zero-length element) to capture panel zone shear distortions
	source elemPanelZone2D_SCFR.tcl;	# procedure for defining 8 elements to create a rectangular panel zone
	source rotSpring2DModIKModel.tcl;	# procedure for defining a rotational spring (zero-length element) for plastic hinges
	
	
	source WSection.tcl;
	source Parameters.tcl;

	source LEXSCFR.tcl;	                # procedure for left exterior SCFR
	source INSCFR.tcl;		            # procedure for inner  SCFR
	source REXSCFR.tcl;	                # procedure for right exterior SCFR

#在使用时需预先进行设计，选择好每层的截面尺寸，自复位耗能系统的参数和结构层数和跨数，然后在相应
#位置进行输入，需要注意的是在record中也需要对不同情况下的输出结果进行重新定义
###################################################################################################
#          定义分析类型										  
###################################################################################################
# Define type of analysis:  "Eigen" = Eigen;  "cyclic" = cyclic;
	set analysisType "cyclic";
	
	
		if {$analysisType == "Eigen"} {
		set dataDir Eigen-Output;	# name of output folder
		file mkdir $dataDir; 								# create output folder
	}
	if {$analysisType == "cyclic"} {
		set dataDir Cyclic-Output;	# name of output folder
		file mkdir $dataDir; 								# create output folder
	}

###################################################################################################
#          建立结构每层的节点部分										  
###################################################################################################




#用左边梁柱节点、右边梁柱节点和中间梁柱节点组装自复位框架
#每个楼层的构建尺寸、耗能滑动力和预应力筋初始预应力均不相同，在Beamcolumns中所有楼层的不同情况进行了穷举，
#然后再采用prco函数通过storyTag对Beamcolumns中每层的定义进行调用。然而proc具有很好的封装性，其不能调用
#主函数main中定义的变量，对材料和截面等编号的选择具有排他性，所以又引入了invoketag这个参数。
	if {$NPiers == 2} {
	for  {set i 0} { $i<$NStories} {incr i} {
 
	# LEXSCFR 节点编号 节点坐标X 节点坐标Y 单元编号 所在楼层编号 调用次数;	
	# LEXSCFR  nodeTag nodeLocationX nodeLocationY elementTag storyTag ;

	LEXSCFR [expr 1+$Nodenumeber*$i] [expr $Columnline] [expr $HStory1+$HStoryTyp*$i] [expr 1+$Elementnumber*$i]  [expr $i] ;
 
	REXSCFR [expr 1+$Nodenumeber*$i+($NPiers-1)*$NStories*$Nodenumeber] [expr $Columnline+$WBay*($NPiers-1)] [expr $HStory1+$HStoryTyp*$i] [expr 1+$Elementnumber*$i+($NPiers-1)*$NStories*$Elementnumber]  [expr $i];
 	}
	}
	if {$NPiers>2} {
	for  {set i 0} { $i<$NStories} {incr i} {
	# LEXSCFR  nodeTag nodeLocationX nodeLocationY elementTag storyTag ;

    LEXSCFR [expr 1+$Nodenumeber*$i] [expr $Columnline] [expr $HStory1+$HStoryTyp*$i] [expr 1+$Elementnumber*$i]   [expr $i];
   
	REXSCFR [expr 1+$Nodenumeber*$i+($NPiers-1)*$NStories*$Nodenumeber] [expr $Columnline+$WBay*($NPiers-1)] [expr $HStory1+$HStoryTyp*$i] [expr 1+$Elementnumber*$i+($NPiers-1)*$NStories*$Elementnumber]   [expr $i] ;
 	}
	for  {set j 1} { $j<[expr $NPiers-1]} {incr j} {
    for  {set i 0} { $i<$NStories} {incr i} {

    INSCFR [expr 1+$Nodenumeber*$i+$j*$NStories*$Nodenumeber] [expr $Columnline+$WBay*$j] [expr $HStory1+$HStoryTyp*$i] [expr 1+$Elementnumber*$i+$j*$NStories*$Elementnumber]   [expr $i];
	}	
	}
	}


#整个程序的建模思路是对LEXSCFR边跨节点、INSCFR中跨节点和REXSCFR右跨节点进行多次调用以生成多层多跨
#的模型---由于柱和梁建模的特殊性，未放在节点过程中，而是在main函数中生成，柱单元的生成分成两种情况	
#一种生成底层柱，一种是除底层柱以外的柱，梁单元的生成分成三种情况，一种仅有一跨，第二种是有两款，第	
#三种是有三跨以上---生成各层的预应力筋，发现施加预应力时其损失非常严重---生成重力柱节点、单元和约	
#束---由于传统自复位框架不能按传统方式与楼板相连，有人提出将楼板分块，每块分别与自复位框架相连接
#因此需要建立柱数相同的重力柱---定义空荷载施加预应力，采用equalDOF使重力柱分别与框架柱相连---显示
#变形和施加荷载，在模拟中发现耗能器初始刚度和缝隙刚度对结构周期的影响很大。

###################################################################################################
#          定义梁和柱											  
###################################################################################################
	
source Addsections.tcl	


# for  {set j 0} { $j<$NPiers} {incr j} {
# node [expr $BottomnnodeTag+$j] [expr $Columnline+$WBay*$j] $Ground;
# node [expr $BottomnnodeTag+$j+10000] [expr $Columnline+$WBay*$j] $Ground;
# # equalDOF    [expr $BottomnnodeTag+$j]    [expr $BottomnnodeTag+$j+10000]    1     2;
# element zeroLength [expr $Bottomnspring+$j] [expr $BottomnnodeTag+$j]    [expr $BottomnnodeTag+$j+10000] -mat $Bottomnspring1 $Bottomnspring1 $Bottomnspring2 -dir 1 2 6;
# fix [expr $BottomnnodeTag+$j+10000] 1 1 1;
 # }	
 
 
 for  {set j 0} { $j<$NPiers} {incr j} {
node [expr $BottomnnodeTag+$j] [expr $Columnline+$WBay*$j] $Ground;
fix [expr $BottomnnodeTag+$j] 1 1 1;
 }
#定义柱编号
set ColumnTag 10000;
#定义梁编号
set BeamTag 20000;


#定义预应力筋编号
set TendonTag 30000;
set numIntgrPts 10;
# 定义坐标转换
	set PDeltaTransf 20;
	geomTransf PDelta $PDeltaTransf; 	# PDelta transformation


# #定义柱单元
for  {set j 0} { $j<$NPiers} {incr j} {
for  {set i 0} { $i<$NStories} {incr i} {
if {$i == 0} {
element	nonlinearBeamColumn	[expr $ColumnTag+$j*$NStories+$i]  [expr $BottomnnodeTag+$j] [expr 10+$Nodenumeber*$i+$j*$NStories*$Nodenumeber] $numIntgrPts	$secTag_C($i)	$PDeltaTransf;
}

if {$i != 0} {

element	nonlinearBeamColumn	[expr $ColumnTag+$j*$NStories+$i]  [expr 4+$Nodenumeber*($i-1)+$j*$NStories*$Nodenumeber] [expr 10+$Nodenumeber*$i+$j*$NStories*$Nodenumeber] $numIntgrPts	$secTag_C($i)	$PDeltaTransf;
}
}
}
# #定义梁单元
for  {set j 1} { $j<$NPiers} {incr j} {
for  {set i 0} { $i<$NStories} {incr i} {
#当仅有一跨时
if {$NPiers == 2} {
if {$j == 1} {
element	nonlinearBeamColumn	[expr $BeamTag+$j*$NStories+$i]  [expr 22+$Nodenumeber*$i] [expr 22+$Nodenumeber*$i+$j*$NStories*$Nodenumeber] $numIntgrPts	$secTag_B($i)	$PDeltaTransf;
}
}
#当仅有两跨时分为两种情况
if {$NPiers == 3} {
#左边跨与中跨连接
if {$j == 1} {
element	nonlinearBeamColumn	[expr $BeamTag+$j*$NStories+$i]  [expr 22+$Nodenumeber*$i] [expr 122+$Nodenumeber*$i+$j*$NStories*$Nodenumeber] $numIntgrPts	$secTag_B($i)	$PDeltaTransf;
}
#右边跨与中跨连接
if {$j == [expr $NPiers-1]} {
element	nonlinearBeamColumn	[expr $BeamTag+$j*$NStories+$i]  [expr 22+$Nodenumeber*$i+($j-1)*$NStories*$Nodenumeber] [expr 22+$Nodenumeber*$i+($NPiers-1)*$NStories*$Nodenumeber] $numIntgrPts	$secTag_B($i)	$PDeltaTransf;
}
}
#当有两跨以上时分为三种情况
if {$NPiers > 3} {
#左边跨与中跨连接
if {$j == 1} {
element	nonlinearBeamColumn	[expr $BeamTag+$j*$NStories+$i]  [expr 22+$Nodenumeber*$i] [expr 122+$Nodenumeber*$i+$j*$NStories*$Nodenumeber] $numIntgrPts	$secTag_B($i)	$PDeltaTransf;
}
#中跨与中跨连接
if {1<$j&&$j<[expr $NPiers-1]} {
element	nonlinearBeamColumn	[expr $BeamTag+$j*$NStories+$i]  [expr 22+$Nodenumeber*$i+($j-1)*$NStories*$Nodenumeber] [expr 122+$Nodenumeber*$i+$j*$NStories*$Nodenumeber] $numIntgrPts	$secTag_B($i)	$PDeltaTransf;
}
#右边跨与中跨连接
if {$j == [expr $NPiers-1]} {
element	nonlinearBeamColumn	[expr $BeamTag+$j*$NStories+$i]  [expr 22+$Nodenumeber*$i+($j-1)*$NStories*$Nodenumeber] [expr 22+$Nodenumeber*$i+($NPiers-1)*$NStories*$Nodenumeber] $numIntgrPts	$secTag_B($i)	$PDeltaTransf;
}
}

}
}

###################################################################################################
#          定义预应力筋											  
###################################################################################################


	#定义预应力筋单元 
	set matID_Intial 20;          # 未施加预应力时预应力筋标签
	set matID_T(0) 21;          # 预应力筋标签
	set matID_T(1) 22;          # 预应力筋标签
	set matID_T(2) 23;          # 预应力筋标签
	set matID_T(3) 24;          # 预应力筋标签
	set matID_T(4) 25;          # 预应力筋标签
	set matID_T(5) 26;          # 预应力筋标签
# 定义预应力筋参数
set fz 1723.8;
set E2 1.986e5;	
set b 0.007;
set yieldStrain [expr $fz/$E2];
#第六层
set ABfrp5 [expr 1416*4];
set initStrain_(5) [expr 0.56*$yieldStrain] ;
#第五层
set ABfrp4 [expr 2306*4];
set initStrain_(4)  [expr 0.5*$yieldStrain] ;
#第四层
set ABfrp3 [expr 3070*4];
set initStrain_(3)  [expr 0.45*$yieldStrain] ;
#第三层
set ABfrp2 [expr 4658*4];
set initStrain_(2)  [expr 0.39*$yieldStrain] ;
#第二层
set ABfrp1 [expr 6068*4];
set initStrain_(1)  [expr 0.34*$yieldStrain] ;
#第一层
set ABfrp0 [expr 8352*4];
set initStrain_(0)  [expr 0.29*$yieldStrain];


#预应力筋应变
uniaxialMaterial Steel01 $matID_Intial $fz $E2 $b;   #预应力筋
uniaxialMaterial InitStrainMaterial $matID_T(0) $matID_Intial $initStrain_(0);
uniaxialMaterial InitStrainMaterial $matID_T(1) $matID_Intial $initStrain_(1);
uniaxialMaterial InitStrainMaterial $matID_T(2) $matID_Intial $initStrain_(2);
uniaxialMaterial InitStrainMaterial $matID_T(3) $matID_Intial $initStrain_(3);
uniaxialMaterial InitStrainMaterial $matID_T(4) $matID_Intial $initStrain_(4);
uniaxialMaterial InitStrainMaterial $matID_T(5) $matID_Intial $initStrain_(5);

for  {set i 0} { $i<$NStories} {incr i} {
if {$i == 0} {
set ABfrp $ABfrp0;
set matID_Tendon $matID_T(0);
} 
if {$i == 1} {
set ABfrp $ABfrp1;
set matID_Tendon $matID_T(1);
} 
if {$i == 2} {
set ABfrp $ABfrp2;
set matID_Tendon $matID_T(2);
} 
if {$i == 3} {
set ABfrp $ABfrp3;
set matID_Tendon $matID_T(3);
} 
if {$i == 4} {
set ABfrp $ABfrp4;
set matID_Tendon $matID_T(4);
} 
if {$i == 5} {
set ABfrp $ABfrp5;
set matID_Tendon $matID_T(5);
} 
element truss [expr $TendonTag+$i] [expr $Nodenumeber*$i+13] [expr $Nodenumeber*$i+($NPiers-1)*$NStories*$Nodenumeber+7] $ABfrp $matID_Tendon; 	
}	





############################################################################
#              重力柱节点、单元和约束              			   			   #
############################################################################
puts "Ficcolumn"



for  {set number 0} { $number<$NPiers} {incr number} {
#重力柱节点
#地面节点
node [expr $FiccolumnnodeTag($number)+1000] [expr $NPiers*$WBay] $Ground;
fix [expr $FiccolumnnodeTag($number)+1000] 1 1 0;

for  {set i 0} { $i<[expr $NStories-1]} {incr i} {
node [expr $FiccolumnnodeTag($number)+$i+1001] [expr $NPiers*$WBay] [expr $HStory1+$i*$HStoryTyp+($dbeam_($i)/2)];
}

for  {set i 0} { $i<$NStories} {incr i} {
node [expr $FiccolumnnodeTag($number)+$i+1101] [expr $NPiers*$WBay] [expr $HStory1+$i*$HStoryTyp+($dbeam_($i)/2)];
}

for  {set i 0} { $i<[expr $NStories-1]} {incr i} {
mass [expr $FiccolumnnodeTag($number)+1101+$i] [expr 809/$NPiers] [expr 809/$NPiers] [expr 809/$NPiers];
}

mass [expr $FiccolumnnodeTag($number)+1101+[expr $NStories-1]] [expr 589/$NPiers] [expr 589/$NPiers] [expr 589/$NPiers];

	# puts "NPiers = $NPiers ";	

# 重力柱单元
for  {set i 0} { $i<$NStories} {incr i} {
element	nonlinearBeamColumn	[expr $FiccolumnTag($number)+$i+5000] [expr $FiccolumnnodeTag($number)+$i+1000] [expr $FiccolumnnodeTag($number)+$i+1101] $numIntgrPts $secTag_Ficc $PDeltaTransf;
}
# 重力柱单元铰接
for  {set i 0} { $i<[expr $NStories-1]} {incr i} {
element zeroLength [expr $FiccolumnTag($number)+$i+6000] [expr $FiccolumnnodeTag($number)+$i+1001] [expr $FiccolumnnodeTag($number)+$i+1101] -mat $matID_Ficc1 $matID_Ficc1 $matID_Ficc2 -dir 1 2 3;
}
}







############################################################################
#              定义空荷载，施加预应力              			   			   #
############################################################################



pattern Plain 100 Linear  {
load 22 0 0 0;
};
puts "prestress loading"
	constraints Plain;					
	numberer Plain;						
	system BandGeneral;
     test EnergyIncr 1.0e-6 200;					
	algorithm Newton;	
    integrator LoadControl 1; 
   analysis Static;
    analyze 1;

###########################################################################
#              每个重力柱与每个框架柱分别连接              			   			   #
############################################################################

for  {set number 0} { $number<$NPiers} {incr number} {

for  {set i 0} { $i<$NStories} {incr i} {
equalDOF [expr $FiccolumnTag($number)+$i+1101]   [expr 4+$Nodenumeber*$i+$number*$NStories*$Nodenumeber] 1; 
}

}


source EigenAnalysis.tcl

###################################################################################################
#          计算ASCE7-10中地震力									  
###################################################################################################

#首先计算总基底剪力的系数Cs
set Sds 1.0;
set R 8.0;
set I 1.0;
set Cs [expr $Sds/($R/$I)];

# puts "$Cs"

#计算总基底剪力的系数Cs的上限值
set Sd1 0.6;
set Csmax [expr $Sd1/($T1*($R/$I))];
# 计算总基底剪力的系数Cs的下限值
set Csmin1 [expr 0.044*$Sds*$I];
set Csmin2 [expr 0.5*$Sd1/($R/$I)];
set Csmin3 0.01;
set Csmin [list $Csmin1 $Csmin2 $Csmin3];

# 如果Cs初始值比最小值小，则取最小值为当前值
for {set i 0} {$i<3} {incr $i} {
	if  {$Cs < [lindex $Csmin $i]} { 
	set Cs [lindex $Csmin $i];
	}
break;
}
# puts "$Cs"
#如果Cs初始值比最大值小，则取最大值为当前值
if  {$Cs > $Csmax} { 
	set Cs $Csmax;
}
puts "[format "Cs = %s" $Cs]"

# 计算指数系数k
if {$T1 <= 0.5} {
	set exponent 1
}
if {$T1>0.5&&$T1<2.5} {
	set exponent [expr 1 + ($T1-0.5)/2]
}
if {$T1>=2.5} {
	set exponent 2
}
puts "[format "exponent = %s" $exponent]"

set sumWiHi 0.0;		# sum of Wi time Hi
set Fx ""  ;            #侧向力 
set WeightTotal 0.0;    #结构总重


set FloorW(1) 8090;
set FloorW(2) 8090; 
set FloorW(3) 8090;
set FloorW(4) 8090; 
set FloorW(5) 8090;  
set FloorW(6) 5890;
set iFloorWeight [list $FloorW(1) $FloorW(2) $FloorW(3) $FloorW(4) $FloorW(5)  $FloorW(6)]


# sum of Wi time Hi
for {set level 2} {$level <=[expr $NStories+1]} {incr level 1} { 	
    set FloorWeight [lindex $iFloorWeight [expr $level-1-1]];
    set WeightTotal [expr $WeightTotal+ $FloorWeight]
	set FloorHeight [expr ($level-1)*$HStoryTyp];
	set sumWiHi [expr $sumWiHi+$FloorWeight*[expr pow($FloorHeight,$exponent)]];		# sum of storey weight times height, for lateral-load distribution
}


# 每层侧向力
set Vbase [expr $Cs*$WeightTotal];

for {set level 2} {$level <=[expr $NStories+1]} {incr level 1} { ;	
	set FloorWeight [lindex $iFloorWeight [expr $level-1-1]];
	set FloorHeight [expr ($level-1)*$HStoryTyp];
	lappend Fx [expr int(($FloorWeight*[expr pow($FloorHeight,$exponent)]/$sumWiHi)*$Vbase)];		# per node per floor
}

set ForceDistribution [lrange $Fx 0 [expr $NStories-1]]

# ###################################################################################################
# #          考虑高阶模态后计算ASCE7-10中地震力									  
# ###################################################################################################

# #首先计算总基底剪力的系数Cs
# set Sds 1.0;
# set R 8.0;
# set I 1.0;
# set Cs [expr $Sds/($R/$I)];

# # puts "$Cs"

# #计算总基底剪力的系数Cs的上限值
# set Sd1 0.6;
# set Csmax [expr $Sd1/($T1*($R/$I))];
# # 计算总基底剪力的系数Cs的下限值
# set Csmin1 [expr 0.044*$Sds*$I];
# set Csmin2 [expr 0.5*$Sd1/($R/$I)];
# set Csmin3 0.01;
# set Csmin [list $Csmin1 $Csmin2 $Csmin3];

# # 如果Cs初始值比最小值小，则取最小值为当前值
# for {set i 0} {$i<3} {incr $i} {
	# if  {$Cs < [lindex $Csmin $i]} { 
	# set Cs [lindex $Csmin $i];
	# }
# break;
# }
# # puts "$Cs"
# #如果Cs初始值比最大值小，则取最大值为当前值
# if  {$Cs > $Csmax} { 
	# set Cs $Csmax;
# }
# puts "[format "Cs = %s" $Cs]"

# # 计算指数系数k
# if {$T1 <= 0.5} {
	# set exponent 1
# }
# if {$T1>0.5&&$T1<2.5} {
	# set exponent [expr 1 + ($T1-0.5)/2]
# }
# if {$T1>=2.5} {
	# set exponent 2
# }
# puts "[format "exponent = %s" $exponent]"

# set sumWiHi 0.0;		# sum of Wi time Hi
# set Fx ""  ;            #侧向力 
# set WeightTotal 0.0;    #结构总重


# set FloorW(1) 8090;
# set FloorW(2) 8090; 
# set FloorW(3) 8090;
# set FloorW(4) 8090; 
# set FloorW(5) 8090;  
# set FloorW(6) 5890;
# set iFloorWeight [list $FloorW(1) $FloorW(2) $FloorW(3) $FloorW(4) $FloorW(5)  $FloorW(6)]


# # sum of Wi time Hi
# for {set level 2} {$level <=[expr $NStories+1]} {incr level 1} { 	
    # set FloorWeight [lindex $iFloorWeight [expr $level-1-1]];
    # set WeightTotal [expr $WeightTotal+ $FloorWeight]
	# set FloorHeight [expr ($level-1)*$HStoryTyp];
	# set sumWiHi [expr $sumWiHi+$FloorWeight*[expr pow($FloorHeight,$exponent)]];		# sum of storey weight times height, for lateral-load distribution
# }


# # 每层侧向力
# set Vbase [expr $Cs*$WeightTotal];
# # 顶层附加力
# set Roofcoffient [expr 0.08*$T1+0.01];
# set Addroofforce [expr $Roofcoffient*$Vbase]; 
# # puts $Addroofforce
# set Restforce [expr $Vbase-$Addroofforce];
# for {set level 2} {$level <=[expr $NStories+1]} {incr level 1} { ;	
	# set FloorWeight [lindex $iFloorWeight [expr $level-1-1]];
	# set FloorHeight [expr ($level-1)*$HStoryTyp];
	# lappend Fx [expr int(($FloorWeight*[expr pow($FloorHeight,$exponent)]/$sumWiHi)*$Restforce)];		# per node per floor
# }

# set ForceDistribution [lrange $Fx 0 [expr $NStories-1]]
# set Roofforce [lindex $ForceDistribution [expr $NStories-1]]
# set Totalroofforce [expr int($Roofforce+$Addroofforce)]
# set ForceDistribution [lreplace $ForceDistribution [expr $NStories-1] [expr $NStories-1] $Totalroofforce]


puts  "[format "ForceDistribution = %s" $ForceDistribution]"
puts  "[format "Fx = %s" $Fx]"
puts  "[format "Vbase = %s"  [expr $Vbase/1000]]"
puts  "[format "T1 = %s"  $T1]"





# # display the model with the node numbers
# DisplayModel2D NodeNumbers;
# # display deformed shape:
	# set ViewScale 5;
	# DisplayModel2D DeformedShape $ViewScale ;	# display deformed shape, the scaling factor needs to be adjusted for each model
	
############################################################################
#              定义结果输出					                			   
############################################################################
# # record drift histories
	# # record drifts
	# recorder Drift -file $dataDir/Drift-Story1.out -time -iNode 1000 -jNode 59 -dof 1 -perpDirn 2;
	
# record floor displacements	
	recorder Node -file $dataDir/Disp.out -time -node [expr $FiccolumnnodeTag(0)+$NStories+1100] -dof 1 disp;
	
# record base shear reactions
	# region 1 -node [expr $BottomnnodeTag+0+10000] [expr $BottomnnodeTag+1+10000] [expr $BottomnnodeTag+2+10000] [expr $BottomnnodeTag+3+10000] [expr $BottomnnodeTag+4+10000]  -nodeRange [expr $BottomnnodeTag+0+10000] [expr $BottomnnodeTag+($NPiers-1)+10000];
	region 1 -node [expr $BottomnnodeTag+0] [expr $BottomnnodeTag+1] [expr $BottomnnodeTag+2] [expr $BottomnnodeTag+3] [expr $BottomnnodeTag+4]
	
	recorder Node -file $dataDir/Vbase1.out -time -region 1 -dof 1 reaction;

# # record story 1 column forces in global coordinates 
	# recorder Element -file $dataDir/Fcol1.out -time -ele 1 force;

# # record friction damper reactions
# recorder Element -file $dataDir/ele50force.out -time -ele 50 localForce;
# recorder Element -file $dataDir/ele50defor.out -time -ele 50 deformations;

# recorder Element -file $dataDir/ele51force.out -time -ele 51 localForce;
# recorder Element -file $dataDir/ele51defor.out -time -ele 51 deformations;
# # record tendon force
# recorder Element -file $dataDir/ele43force.out -time -ele 43 axialForce;	


############################################################################
#              施加低周反复荷载                			   			   #
############################################################################
if {$analysisType == "cyclic"} { 
# set	dat1	0.00375
# set	dat2	0.0075
# set	dat3	0.01
# set	dat4	0.015
# set	dat5	0.02
# set	dat6	0.031
set	dat7	0.05





puts "loads"
	set lat(5) 450;	# force on each beam-column joint in Floor 6
	set lat(4) 357;	# force on each beam-column joint in Floor 5
	set lat(3) 269;	# force on each beam-column joint in Floor 4
	set lat(2) 187;	# force on each beam-column joint in Floor 3
	set lat(1) 114;	# force on each beam-column joint in Floor 2
	set lat(0) 50;	# force on each beam-column joint in Floor 1

	
	for  {set number 0} { $number<$NPiers} {incr number} {		
	
	# pattern Plain [expr 200+$number] Linear {	
	

# for  {set i 0} { $i<$NStories} {incr i} {
# load [expr $FiccolumnnodeTag($number)+$i+1101] $lat($i) 0 0;
# }
# }

pattern Plain [expr 200+$number] Linear {	
for  {set i 0} { $i<$NStories} {incr i} {
set lat($i) [lindex $ForceDistribution $i];	# force on each beam-column joint in Floor 
load [expr $FiccolumnnodeTag($number)+$i+1101] $lat($i) 0 0;
}
}

}


set bm $HBuilding;
set iDmax "[expr $dat7*$bm]" ;

set IDctrlNode [expr $FiccolumnnodeTag(0)+$NStories+1100]
set IDctrlDOF 1
puts "analysis"
source boxanalyze.Static.Cycle.tcl
}





# ############################################################################
# #              计算周期值              			   			   #
# ############################################################################

# if {$analysisType == "Eigen"} { 
	# puts "Running Eigen..."
# source EigenAnalysis.tcl
# puts "EigenAnalysis complete";			# display this message in the command window
# } 	
	

