# 定义结构立面布置
	set NStories 6;						# 总楼层数
	set NPiers 5;						# 总跨数(除重力柱以外)
	
	set Columnline  0.0;		# 柱线
	set Ground 0.0;		# 地面
	
	set WBay      9150;		# 跨长
	set HStory1   4570;		# 第一层高度
	set HStoryTyp 3960;		# 其他层高度
	set HBuilding [expr $HStory1 + ($NStories-1)*$HStoryTyp];	# 建筑总高度
	set Nodenumeber 200;
	set Elementnumber 200;

puts "Ficcolumn"
#定义重力柱编号
set FiccolumnTag(0) 50000;
set FiccolumnTag(1) 60000;
set FiccolumnTag(2) 70000;
set FiccolumnTag(3) 80000;
set FiccolumnTag(4) 90000;
#定义重力柱节点编号
set FiccolumnnodeTag(0) 50000;
set FiccolumnnodeTag(1) 60000;
set FiccolumnnodeTag(2) 70000;
set FiccolumnnodeTag(3) 80000;
set FiccolumnnodeTag(4) 90000;

#定义底层初始节点编号
set BottomnnodeTag 100000;
set Bottomnspring [expr $BottomnnodeTag+500];
