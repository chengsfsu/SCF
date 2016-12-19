proc GeneratePeaks {Dmax {DincrStatic 0.01} {CycleType "Push"} {Fact 1} } {;	# generate incremental disps for Dmax
	###########################################################################
	## GeneratePeaks $Dmax $DincrStatic $CycleType $Fact 
	###########################################################################
	#这里设置了三个参数的默认值，如果没有定义的话则使用默认值
	# generate incremental disps for Dmax
	# this proc creates a file which defines a vector then executes the file to return the vector of disp. increments
	# by Silvia Mazzoni, 2006
	# input variables
	#	$Dmax	: peak displacement (can be + or negative)
	#	$DincrStatic	: displacement increment (optional, default=0.01, independently of units)
	#	$CycleType	: Full (0->+peak), Half (0->+peak->0), Full (0->+peak->0->-peak->0)   (optional, def=Full)
	#	$Fact	: scaling factor (optional, default=1)
	#	$iDstepFileName	: file name where displacement history is stored temporarily, until next disp. peak
	# output variable
	#	$iDstep	: vector of displacement increments
	file mkdir data
	set outFileID [open data/tmpDsteps.tcl w]
	set Disp 0.
	puts $outFileID "set iDstep { ";puts $outFileID $Disp;puts $outFileID $Disp;	# open vector definition and some 0
	set Dmax [expr $Dmax*$Fact];	# scale value
	if {$Dmax<0} {;  # avoid the divide by zero
		set dx [expr -$DincrStatic]
	} else {
		set dx $DincrStatic;
	}
	set NstepsPeak [expr int(abs($Dmax)/$DincrStatic)]
	for {set i 1} {$i <= $NstepsPeak} {incr i 1} {;		# zero to one从原点推覆到最大值
		set Disp [expr $Disp + $dx]
		puts $outFileID $Disp;			# write to file
	}
	if {$CycleType !="Push"} {
		for {set i 1} {$i <= $NstepsPeak} {incr i 1} {;		# one to zero如果执行的不是pushover,从最大值推覆到原点
			set Disp [expr $Disp - $dx]
			puts $outFileID $Disp;			# write to file
		}
		if {$CycleType !="Half"} {
			for {set i 1} {$i <= $NstepsPeak} {incr i 1} {;		# zero to minus one如果执行的不是Halfcycle,从原点推覆到负向最大值
				set Disp [expr $Disp - $dx]
				puts $outFileID $Disp;			# write to file
			}
			for {set i 1} {$i <= $NstepsPeak} {incr i 1} {;		# minus one to zero从负向最大值推覆到原点
				set Disp [expr $Disp + $dx]
				puts $outFileID $Disp;			# write to file
			}
		}
	}
	puts $outFileID " }";		# close vector definition
	close $outFileID
	source data/tmpDsteps.tcl;		# source tcl file to define entire vector
	return $iDstep
}