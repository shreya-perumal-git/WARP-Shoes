#Sets
set ID; #Product Number
set RM; #Raw Material Number
set M; #Machine Number

#Parameters
param Price{ID}; #Sales Price per pair
param Demand{ID}; #Number of Pairs

param RM_Cost{RM}; #Cost per material
param Max_Quantity{RM}; #Max material available
param Amt_Req{ID, RM} default 0; #Amount of material per pair

param Op_Cost{M}; #Operating cost of machine per min per shoe
param Time{ID, M} default 0; #Time required in seconds

#Constant Parameters
param B default 17000000; #budget
param Max_Machine_Time default 1290600; #max machine time per machine in seconds
param Warehouse_Cap default 140000; #max number of pairs of shoes in warehouse

#Variables
var x{ID} >=0; #Number Of Pairs of Shoes

#model
	maximize Profit: 
		
		(sum {i in ID} x[i] * Price[i])
		- (sum {i in ID} 10*max(0,(2*Demand[i]) - x[i]))
		- (sum {i in ID, r in RM} x[i] * Amt_Req[i,r] * RM_Cost[r])
		- (sum {m in M, i in ID} (x[i] * Time[i,m] * Op_Cost[m] / 30))
		- (sum {m in M, i in ID} (x[i] * Time[i,m] / 72));
		
	
	subject to Raw_Material_Cost{r in RM}: sum {i in ID} (x[i] * Amt_Req[i,r] * RM_Cost[r]) <= B;
	subject to Material_Available{r in RM}: sum {i in ID} (x[i] * Amt_Req[i,r]) <= Max_Quantity[r];
	subject to Machine_Time_Limit{m in M}: sum{i in ID} (2 * x[i] * Time[i,m]) <= Max_Machine_Time;
	subject to Warehouse_Capacity: sum{i in ID} x[i] <= Warehouse_Cap;
	 

/*
Question 5
Take out warehouse constraint and add:
+ 10*(Warehouse_Cap - sum{i in ID} x[i])

Question 6
Max_Machine_Time = 8*28*60*60 = 806400

Question 7
B = 17000000
*/
