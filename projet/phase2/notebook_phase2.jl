### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ fa87b764-4a78-43bd-a608-6fa66cbaff9d
md"
Date: 10/06/2021
"

# ╔═╡ cfcdbdb0-26c6-11ec-2f48-d39be0ce8566
md"# Traveling Salesman Project - Phase 2
#### Course: MTH6412B
### Under the supervision of Prof. Dominique Orban
"

# ╔═╡ 639fd037-a885-4bcd-b90d-dfa6c7799391
md"
# Github repository URL:
[Code to Github Phase2: https://github.com/farhadrclass/mth6412b-starter-code/tree/phase-2](https://github.com/farhadrclass/mth6412b-starter-code/tree/phase-2 )
"

# ╔═╡ 878caccb-db99-415a-a3b5-c0beb8db58e4
md"""
Names:
* 1]Mozhgan Moeintaghavi
* 2]Farhad Rahbarnia 
[1] Mathematics and Industrial engineering Faculty, Polytechnique Montréal, [Email](mozhgan.moeintaghavi@polymtl.ca)

[2]Mathematics and Industrial engineering Faculty, Polytechnique Montréal, [Email](Farhad.rahbarnia@polymtl.ca)
"""

# ╔═╡ eb0de4b9-4857-4075-a345-e983f6c64327
md" 
# Introduction 

The second phase of the project entails
"

# ╔═╡ eb25b6ef-4db5-464b-957a-97e241817e6f
md"
# An overview of what has been accomplished

We developed our code in the Phase 2 branch 
"

# ╔═╡ e95e0d52-afb0-477d-bf8f-15dee6a772da
md" 
# The node.jl file


"

# ╔═╡ d99539bb-a8d8-4eb1-a183-4f8a278008af
md" 

In phase1 of the project, we introduced name and data. Here, we have introduced two new parameters of: parent and rank. 
We introduced parent, which can be empty, or include some nodes. When there is no other node to be the parent, we added a treshold of Nothing.

The rank was also introduced to know about the tree's level or height, and the lower the rank, the further the rank is from the root.


We also added two setParent and setRank functions, as well as some modifications to the show function. So, it now prints the name, data, parent, and rank for each node if the parent is not empty. If otherwise, it will merely print its name and data.

```julia 


\"\"\"

\"\"\"

mutable struct Node{T} <: AbstractNode{T}
  name::String
  data::T
  parent::Union{Node{T},Nothing} # the parent can be empty or some nodes 
  rank::Int # this is used to keep the level in the tree
end



\"\"\"



```

"

# ╔═╡ b0547220-c6e3-402b-9f37-9f80bee009e4
md"

# The Kruskal.jl file

We have designed a FindRoot function that uses recursion to locate the root of a node. If a node's parent is itself, it is considered as a root.
Otherwise, it will return the parent's root.



We were inspired by a python code from a website, which can be seen in the report's References section.
The output is a list of spanning trees, with the input being a graph.






"

# ╔═╡ 505689c7-572c-498f-8707-984574e68936
md"
# The UnitTest.jl file


We have imported all the files of node.jl, edge.jl, graph.jl, read_stsp.jl, and kruskal.jl. 
In order to test the functions, it is broken down to functions, and used a modular approach to test them. Each test function is testing the different functionality, and is explained as below:


Then, we created a graph using the function createGraph(), which is clearly shown in an image uploaded in the Output section of the report.
Then, we created 9 nodes of a,b,c,d,e,f,g, h, and i. 
For adding the parents, we set the parent of each node to itself at first. 
Also, we defined the edges between the nodes, and assigned the weights to them.
After creating a graph, we tested whether the number of nodes is 9, and number of edges is 14. 


The graph created is as following to test in the unit test. We used this graph in the unit test and tested kruskal algorithm on it.


We defined two functions of: test_setParent(), and test_FindRoot() in order to test whether it works properly for our node examples.

For testing the minimum spanning tree by kruskal algorithm, we defined the test_KruskalMST function, in which the input is a graph, and the output is the minimum spanning tree. Here, this function checks whether the number of edges in this spanning tree is equal to 8, which is already known in our graph (the number of nodes - 1 is 8.)

Finally, we defined RunAllTest() function so that it would make it possible for us to create a graph, and then run all the testing by that. So, in order to run the unit testing, we just need to run this function.

The output of this unit testing is uploaded in the Output section of the report.

"

# ╔═╡ 8b35782c-9ab5-4907-b3fc-216e3c40b725


# ╔═╡ 5791abd3-42c2-4377-b608-0daffdae317e
md"
# Example of an output of the system 
"

# ╔═╡ bf2ceabd-c51f-4409-9f3a-7af8f769ed19
md"
# Conclusion

Overall, 
"

# ╔═╡ 688170be-2680-4f19-b43b-b43ee7e87231
md"

# References


Inspired by python code from https://www.algotree.org/algorithms/minimum_spanning_tree/kruskals/

https://en.wikipedia.org/wiki/Kruskal%27s_algorithm

"

# ╔═╡ Cell order:
# ╟─fa87b764-4a78-43bd-a608-6fa66cbaff9d
# ╟─cfcdbdb0-26c6-11ec-2f48-d39be0ce8566
# ╟─639fd037-a885-4bcd-b90d-dfa6c7799391
# ╟─878caccb-db99-415a-a3b5-c0beb8db58e4
# ╠═eb0de4b9-4857-4075-a345-e983f6c64327
# ╟─eb25b6ef-4db5-464b-957a-97e241817e6f
# ╟─e95e0d52-afb0-477d-bf8f-15dee6a772da
# ╟─d99539bb-a8d8-4eb1-a183-4f8a278008af
# ╠═b0547220-c6e3-402b-9f37-9f80bee009e4
# ╠═505689c7-572c-498f-8707-984574e68936
# ╠═8b35782c-9ab5-4907-b3fc-216e3c40b725
# ╠═5791abd3-42c2-4377-b608-0daffdae317e
# ╟─bf2ceabd-c51f-4409-9f3a-7af8f769ed19
# ╟─688170be-2680-4f19-b43b-b43ee7e87231
