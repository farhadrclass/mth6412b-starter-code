### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 4235d250-4a2d-11ec-05cf-ed7f8ef4a0ed
md"
Date: 11/20/2021
"


# ╔═╡ 383b808d-703e-4bfa-85d8-1ac0ee286018
md"# Traveling Salesman Project - Phase 4
#### Course: MTH6412B
### Under the supervision of Prof. Dominique Orban
"

# ╔═╡ 18803656-e750-4a5d-a0a1-eb51b898701d
md"""
Names:
* 1]Mozhgan Moeintaghavi
* 2]Farhad Rahbarnia 
[1] Mathematics and Industrial engineering Faculty, Polytechnique Montréal, [Email](mozhgan.moeintaghavi@polymtl.ca)
[2]Mathematics and Industrial engineering Faculty, Polytechnique Montréal, [Email](Farhad.rahbarnia@polymtl.ca)
"""

# ╔═╡ d4622193-c461-4c69-a25d-ef33aeb5380c
md"
# Github repository URL:
[Code to Github Phase4: https://github.com/farhadrclass/mth6412b-starter-code/tree/Phase-4/projet/phase4](https://github.com/farhadrclass/mth6412b-starter-code/tree/Phase-4/projet/phase4)
"

# ╔═╡ ba3bd3db-a9df-4dfa-82ea-1a0ff287e332
md" 
# Introduction 
The fourth phase of the project entails implementing two algorithms of RSL, and Held and Karp.

The following sections go through the modifications we have made to the file  ... in phase 3 of the project , and the files of RSL.jl, HK.jl, oneTree.jl, and UnitTest.jl.
"


# ╔═╡ d0ee665f-a00e-4347-91b7-1d146a54deec
md"
# An overview of what has been accomplished
In this phase of the project, we implemented two algorithms of RSL and HK. Then we tested and compared these algorithms, as well as the variants that we deemed appropriate in order to obtain the best approximations on the symmetric TSP instances.
 



The codes and the related explanations are imported in the following sections of the report.
"

# ╔═╡ 27652466-e38d-4d9e-8837-056a7ea33522
md" # implement the Rosenkrantz, Stearns and Lewis algorithm;
# implement the Held and Karp (HK) climb algorithm;
# the algorithm contains several parameters:
# 1 Kruskal vs. Prim;
3.2 the choice of the privileged vertex (the root);
3.3 the choice of the step length t (HK);
3.4 the choice of the stop criterion (HK).
# by playing on these parameters, identify the best possible routes on the problems of the symmetrical TSP (you can use different parameters on different problems)

# graphically illustrate the routes identified and express the relative error with an optimal route 1 for each of the two algorithms;
# reproduce your results by passing an instance of the TSP as an argument to a main program.
"

# ╔═╡ 60e2146a-4559-4c4a-a9e1-92e8c524e96b
md" 
# The RSL.jl file
The inOrder() function retrieves the root and then returns the ordered list of the nodes after the MST is found.
Another alternative is to create a tree to accomplish the same thing.

Our assumption is that the graph is complete.


"


# ╔═╡ 53b93dd1-49f7-4445-8d90-3c850ea94711
md" 
# The oneTree.jl file

The Function minFindRem!() is defined to find min of a list and return it, and then delete it from the list. 
And then function oneTree() is used to find 1_tree. After removing the node root and all the edges from it , and finding the MST,  we then find the lowest edges (2) for our 1-tree.
The function bestOneTree() returns the best one tree.



"


# ╔═╡ 627ab0c0-63e4-4ace-b636-347f4e7b4c32


# ╔═╡ 7e7bd011-365c-4123-bf82-c9527fbc0ee1
md" 
# The HK.jl file
In the article An Effective Implementation of the Lin-Kernighan Traveling Salesman Heuristic by Keld Helsgaun, page 25, shows a really good implementation of Held and Karp Algorithm.

First, we defined the function degree_cal() to to calculate the degree of nodes in  graph. Then, function vk_cal() calculates V_K of a graph, this function basically updates the degree of the nodes of a graph by -2.
vk=dk-2 
returns TRUE if all vk ==0 , otherwise, it returns False.


The function stepSizeCal() returns the step size, as suggested in the paper. 

firstPeriod is the flag that indicates whether we are in the first period.

n is the size of nodes in the graph.

per is the period length.

t is the step size.

flagW is true if Wk <= w(K-1)

incrFlag is true when the last step of period results in the increment of w.

lastStep is true when it is the last step of period.

The function HK_soklver() is the main function of HK algorithm.
The graph is the original graph
The root is the starting point 

Here, if algo == 1, it uses the Prim algorithm; Otherwise, it uses Kruskal algorithm.  
Here, MaxIter is used to stop if we iterate more, the defualt value for MaxIter is 10000.


"


# ╔═╡ 09daf3b5-3c5c-4aac-ac82-241ebb2ee99c
md" 
# The parameters

"

# ╔═╡ a9138fbb-8028-4371-8fe4-3fe75f3b109b
md" 
# The step length

"

# ╔═╡ cba2c037-d58f-49d6-8c2e-d8b92c319bde
md" 
# The stopping criteria

"

# ╔═╡ 6f0723c5-eeda-4286-aa37-90917b1efd2d
md" 
# The UnitTest.jl file

"

# ╔═╡ cd344b69-b25d-40cb-955a-62a168d2233e
md"
# Examples of an output of the system 

"

# ╔═╡ 9cd80baa-fd8b-4b22-901a-0e45088ab3e0
md"
# Conclusion

In this assignment, we implemented both algorithms of RSL and HK.

"

# ╔═╡ Cell order:
# ╟─4235d250-4a2d-11ec-05cf-ed7f8ef4a0ed
# ╟─383b808d-703e-4bfa-85d8-1ac0ee286018
# ╟─18803656-e750-4a5d-a0a1-eb51b898701d
# ╟─d4622193-c461-4c69-a25d-ef33aeb5380c
# ╟─ba3bd3db-a9df-4dfa-82ea-1a0ff287e332
# ╟─d0ee665f-a00e-4347-91b7-1d146a54deec
# ╠═27652466-e38d-4d9e-8837-056a7ea33522
# ╟─60e2146a-4559-4c4a-a9e1-92e8c524e96b
# ╟─53b93dd1-49f7-4445-8d90-3c850ea94711
# ╠═627ab0c0-63e4-4ace-b636-347f4e7b4c32
# ╟─7e7bd011-365c-4123-bf82-c9527fbc0ee1
# ╠═09daf3b5-3c5c-4aac-ac82-241ebb2ee99c
# ╠═a9138fbb-8028-4371-8fe4-3fe75f3b109b
# ╠═cba2c037-d58f-49d6-8c2e-d8b92c319bde
# ╠═6f0723c5-eeda-4286-aa37-90917b1efd2d
# ╠═cd344b69-b25d-40cb-955a-62a168d2233e
# ╟─9cd80baa-fd8b-4b22-901a-0e45088ab3e0
