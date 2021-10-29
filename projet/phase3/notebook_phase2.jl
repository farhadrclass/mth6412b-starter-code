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

# ╔═╡ 878caccb-db99-415a-a3b5-c0beb8db58e4
md"""
Names:
* 1]Mozhgan Moeintaghavi
* 2]Farhad Rahbarnia 
[1] Mathematics and Industrial engineering Faculty, Polytechnique Montréal, [Email](mozhgan.moeintaghavi@polymtl.ca)

[2]Mathematics and Industrial engineering Faculty, Polytechnique Montréal, [Email](Farhad.rahbarnia@polymtl.ca)
"""

# ╔═╡ a28aca2f-8ddb-4f0f-aa3a-9547065d0f14
md"
# Github repository URL:
[Code to Github Phase2: https://github.com/farhadrclass/mth6412b-starter-code/tree/phase-2](https://github.com/farhadrclass/mth6412b-starter-code/tree/phase-2 )
"

# ╔═╡ eb0de4b9-4857-4075-a345-e983f6c64327
md" 
# Introduction 

The second phase of the project entails creating a minimal spanning tree given a
connected and undirected graph. The procedures and outputs of phase 2 of the project are documented in this report. 

The following sections go through all of the modifications we have made to the file node.jl in phase1, and the creation of the new files of kruskal.jl, and UnitTest.jl written by Julia programming language.
"

# ╔═╡ eb25b6ef-4db5-464b-957a-97e241817e6f
md"
# An overview of what has been accomplished




-The initial stage in the development of our code in the Phase2 branch was to choose and create a data structure for the connected components of a graph.
-We also implemented and tested the Kruskal algorithm on the given connected and undirected graph.

-We have included unit tests to ensure that our functions provide the expected outcomes.

-In the final stage, we tested our implementation on numerous cases of symmetric TSP.
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

Return a parent of the node
\"\"\"
parent(node::AbstractNode) = node.parent

\"\"\"
Return a rank of the node
\"\"\"

rank(node::AbstractNode) = node.rank
\"\"\"

EN: present the node 
\"\"\"

function show(node::AbstractNode)
  if (node.parent !== nothing) # if we have something to show
    println(\"Node \", name(node), \", data: \", data(node), \", Parent: \",parent(node), \", Rank: \",rank(node))
  else
    println(\"Node \", name(node), \", data: \", data(node))
  end
end

\"\"\"
Setter for the parent\"\"\"

function setParent!(node::Node{T}, parentBuffer::Node{T}) where T
  node.parent = parentBuffer
  node
end
\"\"\"
Setter for the rank\"\"\"

function setRank!(node::Node{T}, rankBuffer::Int) where T
  node.rank = rankBuffer
  node
end
```

"

# ╔═╡ b0547220-c6e3-402b-9f37-9f80bee009e4
md"

# The Kruskal.jl file

We have designed a FindRoot function that uses recursion to locate the root of a node. If a node's parent is itself, it is considered as a root.
Otherwise, it will return the parent's root.



We were inspired by a python code from a website, which can be seen in the report's References section.
The output is a list of spanning trees, with the input being a graph.

```julia 
\"\"\"


function FindRoot(node::Node{T}) where T
\"\"\"
This function finds the  root of a node, Using recursion\"\"\"
\"\"\"
    if node.parent == node
        return node
    end
    return FindRoot(node.parent)    
end

\"\"\"
\"\"\"
The function to calculte Kruskal Min spanning tree
    Inspired by python code from https://www.algotree.org/algorithms/minimum_spanning_tree/kruskals/
Input  graph 
Output list of spanning trees     
\"\"\"

function KruskalMST(graph::Graph{T}) where T
    # we can create a graph to hold the tree 
    # for now we init with  nodes of graph and empty edges
    # we will update the nodes later 
    MST = Graph(string(graph.name,\"MST\"),graph.nodes,Edge[])
    
    #Initilize the nodes parent
    for node in graph.nodes
        # Way one add here 
        # node.parent = node
        # node.rank = 0
\"\"\"
        # Way two use the function in node.jl
        setParent!(node,node)
        setRank!(node,0)
    end
\"\"\"
    # we need to sort the edge list by their weight
    sort!(graph.edges, by = weight)
    
    # Finding the MST
    for edge in graph.edges
        root1= FindRoot(edge.node1)
        root2= FindRoot(edge.node2)

        if root1 != root2
            add_edge!(MST, edge)
            if root1.rank < root2.rank
                root1.parent = root2
                root2.rank +=1
            else
                root2.parent = root1
                root1.rank +=1
            end
        end
    end
\"\"\"
    # now we update the node of the MST since we changed the parents 
    MST.nodes = copy(graph.nodes) # we use copy since it is a pointer type
    return MST
end

		
```

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


```julia 
\"\"\"


\"\"\"

using Test
# Import the other files    
include(\"node.jl\")
include(\"edge.jl\")
include(\"graph.jl\")
include(\"read_stsp.jl\")
include(\"kruskal.jl\")
\"\"\"This is a unit tests for the functions used in phase 2\"\"\"
function createGraph()
    println(\"\nTesting Creating graph\")
    # create nodes
    a = Node(\"a\",\"a\",nothing, 0)
    b = Node(\"b\",\"b\",nothing, 0)
    c = Node(\"c\",\"c\",nothing, 0)
    d = Node(\"d\",\"d\",nothing, 0)
    e = Node(\"e\",\"e\",nothing, 0)
    f = Node(\"f\",\"f\",nothing, 0)
    g = Node(\"g\",\"g\",nothing, 0)
    h = Node(\"h\",\"h\",nothing, 0)
    i = Node(\"i\",\"i\",nothing, 0)
\"\"\"    
    setParent!(a,a)
    setParent!(b,b)
    setParent!(c,c)
    setParent!(d,d)
    setParent!(e,e)
    setParent!(f,f)
    setParent!(h,h)
    setParent!(d,d)
    # set edges

\"\"\"
    ab = Edge(a,b,4)
    ah = Edge(a,h,8)
    bh = Edge(b,h,11)
    bc = Edge(b,c,8)
    hi = Edge(h,i,7)
    hg = Edge(h,g,1)
    ig = Edge(i,g,6)
    ic = Edge(i,c,2)
    cd = Edge(c,d,7)
    cf = Edge(c,f,4)
    gf = Edge(g,f,2)
    df = Edge(d,f,14)
    de = Edge(d,e,9)
    ef = Edge(e,f,10)
\"\"\"
    #creating graph
    G = Graph(\"g\",[a,b,c,d,e,f,g,h,i],[ab,ah,bh,bc,hi,hg,ig,ic,cd,cf,gf,df,de,ef])
    print(\"Testing Create graph, number of nodes\t\")
    println(@test nb_nodes(G) == 9)
    print(\"Testing Create graph, number of edges\t\")
    println(@test nb_edges(G) == 14)

    return G
end
\"\"\"


function test_setParent()
    # Testing the FindRoot function
    println(\"\nTesting the setParent! function\")
    # create a node
    a = Node(\"a\",\"a\",nothing,0)
    setParent!(a,a)
    
    b = Node(\"b\",\"b\",nothing,0)
    setParent!(b,a)

    print(\"Testing b.parent == a\t\")
    println(@test b.parent == a)
\"\"\"

end
\"\"\"

function test_FindRoot()
    # Testing the FindRoot function
    println(\"\nTesting the FindRoot function\")
    # create a node
    a = Node(\"a\",\"a\",nothing,0)
    setParent!(a,a)

    b = Node(\"b\",\"b\",a,0)
    c = Node(\"c\",\"c\",b,0)

    print(\"Testing root of c\t\")
    println(@test FindRoot(c) == a)
end


function test_KruskalMST(graph::Graph{T}) where T
    MST = KruskalMST(graph)
    print(\"Testing KruskalMST\t\")
    println(@test nb_edges(MST) == 8) # n-1
end
\"\"\"

function RunAllTest()
    #create a graph
    g = createGraph()
    # Test all the unit test
    test_setParent()
    test_FindRoot()
    test_KruskalMST(g)
end
\"\"\"


#running the tests
RunAllTest()














```











"

# ╔═╡ 5791abd3-42c2-4377-b608-0daffdae317e
md"
# Example of an output of the system 
"

# ╔═╡ bf2ceabd-c51f-4409-9f3a-7af8f769ed19
md"
# Conclusion

In this assignment, we used the Kruskal algorithm to create a minimum spanning tree from a connected and undirected graph.

After defining, and running the test functions, the code is also complemented by unit tests.
"

# ╔═╡ 688170be-2680-4f19-b43b-b43ee7e87231
md"

# References


Our code is inspired by a python code from https://www.algotree.org/algorithms/minimum_spanning_tree/kruskals/

https://en.wikipedia.org/wiki/Kruskal%27s_algorithm

"

# ╔═╡ Cell order:
# ╟─fa87b764-4a78-43bd-a608-6fa66cbaff9d
# ╟─cfcdbdb0-26c6-11ec-2f48-d39be0ce8566
# ╟─878caccb-db99-415a-a3b5-c0beb8db58e4
# ╟─a28aca2f-8ddb-4f0f-aa3a-9547065d0f14
# ╠═eb0de4b9-4857-4075-a345-e983f6c64327
# ╟─eb25b6ef-4db5-464b-957a-97e241817e6f
# ╟─e95e0d52-afb0-477d-bf8f-15dee6a772da
# ╠═d99539bb-a8d8-4eb1-a183-4f8a278008af
# ╠═b0547220-c6e3-402b-9f37-9f80bee009e4
# ╠═505689c7-572c-498f-8707-984574e68936
# ╟─5791abd3-42c2-4377-b608-0daffdae317e
# ╟─bf2ceabd-c51f-4409-9f3a-7af8f769ed19
# ╟─688170be-2680-4f19-b43b-b43ee7e87231
