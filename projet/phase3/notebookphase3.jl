### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 87d97df2-3a5d-11ec-07bd-35341be2e20c
md"
Date: 10/31/2021
"


# ╔═╡ 6c54cf11-a918-42c4-bc60-b2ae66da3dfe
md"# Traveling Salesman Project - Phase 3
#### Course: MTH6412B
### Under the supervision of Prof. Dominique Orban
"

# ╔═╡ f584fd50-ce54-4721-9a79-a797389393b1
md"""
Names:
* 1]Mozhgan Moeintaghavi
* 2]Farhad Rahbarnia 
[1] Mathematics and Industrial engineering Faculty, Polytechnique Montréal, [Email](mozhgan.moeintaghavi@polymtl.ca)

[2]Mathematics and Industrial engineering Faculty, Polytechnique Montréal, [Email](Farhad.rahbarnia@polymtl.ca)
"""

# ╔═╡ 9f87c0bb-2826-4e0f-8e9a-27dbb14a13ca
md"
# Github repository URL:
[Code to Github Phase3: https://github.com/farhadrclass/mth6412b-starter-code/tree/phase-3](https://github.com/farhadrclass/mth6412b-starter-code/tree/phase-3 )
"

# ╔═╡ 1dcdf3b4-7290-4e53-91a2-6f7181a79064
md" 
# Introduction 

The third phase of the project entails creating a minimal spanning tree given a
connected and undirected graph. The procedures and outputs of phase 2 of the project are documented in this report. 

The following sections go through all of the modifications we have made to the file node.jl in phase1, and the creation of the new files of prim.jl, and UnitTest.jl written by Julia programming language.
"

# ╔═╡ cba90a0a-2595-4a96-926a-039e9fe2c0e7
md"
# An overview of what has been accomplished


In this phase of the project, we developed the two acceleration heuristics and solved the rank question.
Then, using the lecture notes example and multiple instances of TSP symmetric in the unit tests, we constructed the Prim method, and tested it.

The codes and the related explanations are imported in the following sections of the report.


"

# ╔═╡ 85e9756d-bd4a-4b4b-bc9f-f6be8238ab12
md" 
# The Kruskal.jl file(previous phase modifications)

This File contains the algorithm for kruskal spanning tree.


We have used two heuristics of: Union via rank, and Path compression in order to quickly discover the root of a tree in a forest of disjoint sets.

Then, we impl;emented Kruskal algorithm to show that the parent for each node is the node h.

So, based on the output below, the tests are correctly implemented since it is also clearly shown in the unit test that all the nodes are connected to the node h.




```julia

function findRoot!(node::Node{T}) where T
# \"\"\"This function finds the  root of a node, Using recursion\"\"\"
    if parent(node) == node        
        return node
    else
        # path Compression is added here, add the parent to be the root
        setParent!(node, findRoot!(parent(node)))
    end
    return parent(node)   
end

function union!(MST::Graph{T},edge) where T 
    root1= findRoot!(edge.node1)
    root2= findRoot!(edge.node2)

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
The function to calculte Kruskal Min spanning tree
    Inspired by python code from https://www.algotree.org/algorithms/minimum_spanning_tree/kruskals/
Input  graph 
Output list of spanning trees     
\"\"\"
function KruskalMST(graph::Graph{T}) where T
    # we can create a graph to hold the tree 
    # for now we init with  nodes of graph and empty edges
    # we will update the nodes later 
    MST = Graph(string(graph.name,\"MST\"),nodes(graph),Edge[])
    
    #Initilize the nodes parent
    for node in nodes(graph)
        # Way one add here 
        # node.parent = node
        # node.rank = 0

        # Way two use the function in node.jl
        setParent!(node,node)
        setRank!(node,0)
    end

    # we need to sort the edge list by their weight
    sort!(graph.edges, by = weight)
    
    # Finding the MST, Here we already implement by rank
    for edge in edges(graph)
        union!(MST,edge)
    end
    # now we update the node of the MST since we changed the parents 
    MST.nodes = copy(graph.nodes) # we use copy since it is a pointer type
    return MST
end

```

"

# ╔═╡ 1af7dc2c-38e7-44e4-8137-3157b5de5677
Twoheuristics = let
    import PlutoUI
    PlutoUI.LocalResource(joinpath(split(@__FILE__, '#')[1] * ".assets", "photo1635695120.jpeg"))
end

# ╔═╡ 811ec570-8777-4b49-87fd-b0b1b0e04789
md"

# The Question:



Show that the rank of a node will always be less than |S|-1 Then show that this rank will in fact always be less than log2(|S|) ;









The proof:


## Property 1:
Any root node of rank k has ≥2^k nodes in its tree.
###Proof by induction:
Base case: For k=0, we have a single node, ≥2^0=1
Inductive hypothesis: Assume it’s true for k
A node of rank k+1 is created only by merging two roots of rank k 
By inductive hypothesis, each subtree has ≥2^k nodes, then the k+1 rank node has ≥2^k+2^k≥2^(k+1)  nodes in its tree.

- Show that the rank of a node will always be less than |S|-1.
### Proof by contradiction:
Assume the rank of a node is |S| or greater. For now, assume the rank is |S|. By property 1, the node has ≥2^(|S|) nodes in its tree, which is obviously a contradiction since we only have |S| nodes in total. (obviously 2^(|S|)  !=|S|  for any s≥0). Assume the rank is x>|S|, then the node has ≥2^x>2^|S|  nodes in its tree, which is obviously a contradiction again. 

## Property 2:
If x is not a root node, then rank(x) < rank(parent(x))
Proof: A node of rank k is created only by merging two roots of rank k-1.

- Then, show that this rank will in fact always be less than log2(|S|). 


From property 1 and property 2, we conclude that the highest rank of a node is ≤⌊log_2⁡〖|S|〗 ⌋

Because if we have a node with rank x, then we must have at least  ≥2^x nodes, and we have |S| nodes, meaning that |S|≥2^x must be true, the greatest amount of x  that we can have is obviously ⌊log_2⁡〖|S|〗 ⌋ since x is an integer.



"

# ╔═╡ 9ca21b46-bb3e-467c-a76f-795d0a146935
md" 
# The Prim.jl file
We created a function to to calculte prim minimum spanning tree, which is denoted as PrimMST.
We created a graph to hold the tree in this function, and started with graph nodes and empty edges.

The start node is randomly chosen, and the edge list must be sorted by weight. Then  our nodes are updated depending on the parent and rank for each adjacent nodes. Here, we repeat the method until all nodes are covered.




















```julia


function PrimMST(graph::Graph{T}) where T
    # we can create a graph to hold the tree 
    # for now we init with  nodes of graph and empty edges
    # we will update the nodes later 
    #Initilize the nodes parent
    for node in nodes(graph)
        # Way two use the function in node.jl
        setParent!(node,node)
        setRank!(node,0)
    end


    # nodesList = Node{typeof(nodes(graph))}[]
    initNode  =  nodes(graph)[1]  # random start for node


    MST = Graph(string(graph.name,\"PrimMST\"),[initNode],Edge[])
    
    # add_node!(MST,initNode)
    # we need to sort the edge list by their weight
    sortEdge = sort(graph.edges, by = weight, rev = false)
    while length(nodes(graph)) !=length(nodes(MST))
        #first we need to get the list of nodes in MST 
        namesNodes = [name(x) for x in nodes(MST)]
        for edge in sortEdge #go through the edges 
            # check if the first node is  but second is not then we add it 
            if (!isnothing(findfirst(x-> x == edge.node1.name, namesNodes)) && isnothing(findfirst(x-> x == edge.node2.name, namesNodes)))
                add_node!(MST,edge.node2)
                add_edge!(MST,edge)
                break
            elseif  (isnothing(findfirst(x-> x == edge.node1.name, namesNodes)) && !isnothing(findfirst(x-> x == edge.node2.name, namesNodes)))
                add_node!(MST,edge.node1)
                add_edge!(MST,edge)
                break
            end
        end

    end

    # now we update the node of the MST since we changed the parents 
    return MST
end






















```
"

# ╔═╡ b2ea7e85-5d0a-40c9-a67a-d3ae7e858cc3
md" 
# The UnitTest.jl file

We execute all the tests on the graphs, and compare KruskalMST and PrimMST's weight and size to see if the results are the same.
we run the tests by creating four functions of test_setParent(), test_FindRoot(), test_KruskalMST(), and test_PrimMST(). 

In order to simultaneously implement all the tests, we created RunAllTest() function to execute.



We have also tested our code on the sample which is provided in the lab lectures.

```julia

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
    
    setParent!(a,a)
    setParent!(b,b)
    setParent!(c,c)
    setParent!(d,d)
    setParent!(e,e)
    setParent!(f,f)
    setParent!(h,h)
    setParent!(d,d)
    # set edges
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

    #creating graph
    G = Graph(\"g\",[a,b,c,d,e,f,g,h,i],[ab,ah,bh,bc,hi,hg,ig,ic,cd,cf,gf,df,de,ef])
    print(\"Testing Create graph, number of nodes\t\")
    println(@test nb_nodes(G) == 9)
    print(\"Testing Create graph, number of edges\t\")
    println(@test nb_edges(G) == 14)

    return G
end


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

end

function test_FindRoot()
    # Testing the FindRoot function
    println(\"\nTesting the FindRoot function\")
    # create a node
    a = Node(\"a\",\"a\",nothing,0)
    setParent!(a,a)

    b = Node(\"b\",\"b\",a,0)
    c = Node(\"c\",\"c\",b,0)

    print(\"Testing root of c\t\")
    println(@test findRoot!(c) == a)
end


function test_KruskalMST(graph::Graph{T}) where T
    MST = KruskalMST(graph)
    print(\"Testing KruskalMST\t\")
    println(@test nb_edges(MST) == 8) # n-1
    show(MST)
    return MST
end

function test_PrimMST(graph::Graph{T}) where T
    MST = PrimMST(graph)
    print(\"Testing PrimMST\t\")
    println(@test nb_edges(MST) == 8) # n-1
    show(MST)
    return MST
end

function RunAllTest()
    #create a graph
    g = createGraph()
    # Test all the unit test
    test_setParent()
    test_FindRoot()
    MSTsizeK=weightGraph(test_KruskalMST(g))
    MSTsizePrime = weightGraph(test_PrimMST(g))
    println()
    print(\"Testing PrimMST and KruskalMST weights\t\")
    println(@test  MSTsizePrime== MSTsizeK)
end


#running the tests
RunAllTest()





```

"

# ╔═╡ 393033d2-0308-40e9-9e43-2d0dee5b6a5d
md"
# Examples of an output of the system 


















"

# ╔═╡ 22fc59cc-4ff1-4fc4-a67b-5c70f1d409d9
Tests= let
    PlutoUI.LocalResource(joinpath(split(@__FILE__, '#')[1] * ".assets", "photo1635695120 (1).jpeg"))
end

# ╔═╡ d1f467f9-062a-4623-93df-36cbe47d7742
Test_on_other_graphs = let
    PlutoUI.LocalResource(joinpath(split(@__FILE__, '#')[1] * ".assets", "photo1635695120 (2).jpeg"))
end

# ╔═╡ 7d64cae4-6826-4438-826c-d694a8c0c3ed

Weights = let
    PlutoUI.LocalResource(joinpath(split(@__FILE__, '#')[1] * ".assets", "photo1635695120 (3).jpeg"))
end

# ╔═╡ 50162bd1-3a89-4c52-8dc8-dcef8f349fad
md"
# Conclusion

In this assignment, we implemented the Prim algorithm to create a minimum spanning tree from a connected and undirected graph.

After defining, and running the test functions, the code is also complemented by unit tests. By testing on some graphs of gr17, gr21, and gr24, bayg29, ... , we have compared the weight and edge of the minimum spanning trees obtained by Kruskal and Prim algorithms, and the tests show that the output is the same.


"


# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.16"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "5efcf53d798efede8fee5b2c8b09284be359bf24"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.2"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "d911b6a12ba974dabe2291c6d450094a7226b372"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.1"

[[PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "4c8a7d080daca18545c56f1cac28710c362478f3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.16"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╟─87d97df2-3a5d-11ec-07bd-35341be2e20c
# ╟─6c54cf11-a918-42c4-bc60-b2ae66da3dfe
# ╟─f584fd50-ce54-4721-9a79-a797389393b1
# ╟─9f87c0bb-2826-4e0f-8e9a-27dbb14a13ca
# ╟─1dcdf3b4-7290-4e53-91a2-6f7181a79064
# ╟─cba90a0a-2595-4a96-926a-039e9fe2c0e7
# ╟─85e9756d-bd4a-4b4b-bc9f-f6be8238ab12
# ╟─1af7dc2c-38e7-44e4-8137-3157b5de5677
# ╟─811ec570-8777-4b49-87fd-b0b1b0e04789
# ╟─9ca21b46-bb3e-467c-a76f-795d0a146935
# ╟─b2ea7e85-5d0a-40c9-a67a-d3ae7e858cc3
# ╟─393033d2-0308-40e9-9e43-2d0dee5b6a5d
# ╟─22fc59cc-4ff1-4fc4-a67b-5c70f1d409d9
# ╟─d1f467f9-062a-4623-93df-36cbe47d7742
# ╟─7d64cae4-6826-4438-826c-d694a8c0c3ed
# ╟─50162bd1-3a89-4c52-8dc8-dcef8f349fad
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002