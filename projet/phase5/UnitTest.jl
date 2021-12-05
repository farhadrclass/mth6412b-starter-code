using Test
# Import the other files    
include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")
include("kruskal.jl")
include("prim.jl")
include("RSL.jl")

"""This is a unit tests for the functions used in phase 2"""
function createGraph()
    println("\nTesting Creating graph")
    # create nodes
    a = Node("a","a",nothing, 0,0,0)
    b = Node("b","b",nothing, 0,0,0)
    c = Node("c","c",nothing, 0,0,0)
    d = Node("d","d",nothing, 0,0,0)
    e = Node("e","e",nothing, 0,0,0)
    f = Node("f","f",nothing, 0,0,0)
    g = Node("g","g",nothing, 0,0,0)
    h = Node("h","h",nothing, 0,0,0)
    i = Node("i","i",nothing, 0,0,0)
    
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
    G = Graph("g",[a,b,c,d,e,f,g,h,i],[ab,ah,bh,bc,hi,hg,ig,ic,cd,cf,gf,df,de,ef],Node{typeof(initNode)}[a],Node{typeof(initNode)}[b])
    print("Testing Create graph, number of nodes\t")
    println(@test nb_nodes(G) == 9)
    print("Testing Create graph, number of edges\t")
    println(@test nb_edges(G) == 14)

    return G
end


function test_setParent()
    # Testing the FindRoot function 
    println("\nTesting the setParent! function")
    # create a node
    a = Node("a","a",nothing,0)
    setParent!(a,a)
    
    b = Node("b","b",nothing,0)
    setParent!(b,a)

    print("Testing b.parent == a\t")
    println(@test b.parent == a)

end

function test_FindRoot()
    # Testing the FindRoot function
    println("\nTesting the FindRoot function")
    # create a node
    a = Node("a","a",nothing,0)
    setParent!(a,a)

    b = Node("b","b",a,0)
    c = Node("c","c",b,0)

    print("Testing root of c\t")
    println(@test findRoot!(c) == a)
end


function test_KruskalMST(graph::Graph{T}) where T
    MST = KruskalMST(graph)
    print("Testing KruskalMST\t")
    println(@test nb_edges(MST) == 8) # n-1
    show(MST)
    return MST
end

function test_PrimMST(graph::Graph{T}) where T
    MST = PrimMST(graph)
    print("Testing PrimMST\t")
    println(@test nb_edges(MST) == 8) # n-1
    show(MST)
    return MST
end
function test_RSL(graph::Graph{T}) where T

    # RSL(algo::Int64, root::Node{T}, myG::Graph{T}) where T
    print("Testing RSL\t")
    weight, Cycle = RSL(1,nodes(graph)[1],graph)
    print("\n",weight,"\n")
    show(Cycle)
    return weight, Cycle
end
function RunAllTest()
    #create a graph
    g = createGraph()
    # Test all the unit test
    test_setParent()
    test_FindRoot()
    MSTsizeK=weightGraph(test_KruskalMST(g))
    MSTsizePrime = weightGraph(test_PrimMST(g))
    # test_RSL(g) # TODO issue becuase graph is  not complete, create a complete graph
    println()
    print("Testing PrimMST and KruskalMST weights\t")
    println(@test  MSTsizePrime== MSTsizeK)
end


#running the tests
RunAllTest()