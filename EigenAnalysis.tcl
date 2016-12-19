############################################################################
#                       Eigenvalue Analysis                    			   
############################################################################
	# set pi [expr 2.0*asin(1.0)];						# Definition of pi
	# set nEigenI 1;										# mode i = 1
	# set nEigenJ 2;										# mode j = 2
	# set lambdaN [eigen [expr $nEigenJ]];				# eigenvalue analysis for nEigenJ modes
	# set lambdaI [lindex $lambdaN [expr $nEigenI-1]];	# eigenvalue mode i = 1
	# set lambdaJ [lindex $lambdaN [expr $nEigenJ-1]];	# eigenvalue mode j = 2
	# set w1 [expr pow($lambdaI,0.5)];					# w1 (1st mode circular frequency)
	# set w2 [expr pow($lambdaJ,0.5)];					# w2 (2nd mode circular frequency)
	# set T1 [expr 2.0*$pi/$w1];							# 1st mode period of the structure
	# set T2 [expr 2.0*$pi/$w2];							# 2nd mode period of the structure
	# puts "T1 = $T1 s";									# display the first mode period in the command window
	# puts "T2 = $T2 s";									# display the second mode period in the command window

	
# ----------------------------------------------------------------------------------------------------
#puts "eigenvalue analysis"
set Ndof 12
set PI 3.141593;						            # Definition of PI
# set lambdaN [eigen -fullGenLapack [expr $Ndof]];				        # eigenvalue analysis for 12 modes
set lambdaN [eigen [expr $Ndof]];				# eigenvalue analysis for nEigenJ modes
set lambdaI [lindex $lambdaN [expr 0]];	#			# eigenvalue mode i = 1
#set lambdaJ [lindex $lambdaN [expr 1]];	            # eigenvalue mode j = 2
#set lambdaK [lindex $lambdaN [expr 2]];	            # eigenvalue mode j = 3
set w1 [expr pow($lambdaI,0.5)];					# w1 (1st mode circular frequency)
#set w2 [expr pow($lambdaJ,0.5)];					# w2 (2nd mode circular frequency)
#set w3 [expr pow($lambdaK,0.5)];					# w3 (3nd mode circular frequency)
set T1 [expr 2.0*$PI/$w1];							# 1st mode period of the structure
#set T2 [expr 2.0*$PI/$w2];							# 2nd mode period of the structure
#set T3 [expr 2.0*$PI/$w3];							# 3nd mode period of the structure
puts "T1 = $T1 s";									# display the first mode period in the command window
#puts "T2 = $T2 s";									# display the second mode period in the command window
#puts "T3 = $T3 s";									# display the third mode period in the command window
# recoder eigenvalues 
set eigenvalues "$dataDir/periods.out"
set open_eigens [open $eigenvalues "w"]
for {set i 1} {$i <=$Ndof} {incr i 1} {
   set lambda [lindex $lambdaN [expr $i-1]]
   set w [expr pow($lambda,0.5)]
   set T [expr 2.0*$PI/$w]
   puts $open_eigens "$T"
}   
close $open_eigens