"""
This is  the main file for image reconstruction
"""

using Pkg
using Random
using FileIO
using Images, ImageView, ImageMagick
include(joinpath(@__DIR__, "shredder-julia", "bin", "tools.jl"))


# Import the other files    
include("node.jl")
include("edge.jl")
include("graph.jl")
include("read_stsp.jl")

include("kruskal.jl")
include("prim.jl")
include("RSL.jl")
include("HK.jl")
include("GraphPlot.jl")


function createGraph(path, graphName)
    # read the graph from the file 
    # localGraphName=string(path,graphName)
    fileName = joinpath(@__DIR__, "shredder-julia", "tsp", "instances", graphName * ".tsp")
    graph_nodes, graph_edges = read_stsp(fileName)

    if (length(graph_nodes) > 0) # check to see if the name is assigned in the TSP file, if not we do something else 
        nodesList = Node{typeof(graph_nodes[1])}[]
        vert1List = Node{typeof(graph_nodes[1])}[]
        vert2List = Node{typeof(graph_nodes[1])}[]
    else
        nodesList = Node{Int64}[]
        vert1List = Node{Int64}[]
        vert2List = Node{Int64}[]
    end


    for k = 1:length(graph_edges)
        if (length(graph_nodes) > 0) # check to see if the name is assigned in the TSP file, if not we do something else 
            node_buff = Node(string(k), graph_nodes[k], nothing, 0, 0, 0)
        else
            node_buff = Node(string(k), k, nothing, 0, 0, 0) #name is the same as we assign it 
        end
        push!(nodesList, node_buff)
    end

    # edge positions
    # go through the edge list and create the edges of the graph


    edgesList = Edge[]


    # add a flag if the nodes are read then you have a edge list then use it to get the node then assign 

    for k = 1:length(graph_edges)
        for item in graph_edges[k]
            edge_buff = Edge(nodesList[k], nodesList[item[1]], item[2])
            push!(edgesList, edge_buff)
        end
    end


    # create a graph using data types
    # G = Graph(graphName, nodesList, edgesList)
    G = Graph(graphName, nodesList, Edge[], vert1List, vert2List)
    #adding the edges here so we test there is no dublicate 
    for k = 1:length(edgesList)
        add_edge!(G, edgesList[k])
    end
    println("Finished creating a graph")

    # show(G)
    G
end


RSL_flag = true
println("Reading all the images \n\n\n")
for fileName in readdir(joinpath(@__DIR__, "shredder-julia", "tsp", "instances"))
    fileName = replace(fileName, ".tsp" => "") # removing tsp since createGraph expcet only the name 
    println("reading the file: ", fileName)
    BufferG = createGraph(joinpath(@__DIR__, "shredder-julia", "tsp", "instances"), fileName)
    
    # find the first node that has 1 as the name 
    root = nodes(BufferG)[findfirst(n -> name(n) == "1", nodes(BufferG))]

    #Remove the first one from the list
    myG = deepcopy(BufferG)
    deleteat!(edges(myG), findall(x->(name(root) == name(node1(x)) || name(root) == name(node2(x))), edges(myG)))

    # remove the node root and all the edges from it 
    deleteat!(nodes(myG), findall(x->name(x)==name(root), nodes(myG)))
    


    if RSL_flag
        println("RSL has been selected")
        cycleWeight, Cycle = RSL(1, nodes(myG)[1], myG)
        # BestCycle = Cycle
        # #Testing the nodes as root  RSL 
        # minW = Inf
        # cc = 0
        # for node in nodes(myG)
        #     cycleWeight, Cycle = RSL(1, node, myG)
        #     if cycleWeight < minW
        #         cc += 1
        #         minW = cycleWeight
        #         BestCycle = Cycle
        #         println("best RSL weightGraph ", minW)

        #         if (cc > 3) # we only take 3 updates 
        #             break
        #         end
        #     end
        # end
        # cycleWeight = minW
        # Cycle = BestCycle
        println("RSL weightGraph ", cycleWeight, " graph weightGraph")



    else #HK
        Cycle_HK = HK_solver(1, root, myG, 100)
        cycleWeight_HK = weightGraph(Cycle)
    end

    # Once a tour has been identified, construct a list of nodes along that tour without removing the
    # the zero node. Using the write_tour() function, create a .tour file in TSPLib format that
    # describes your tour. Sample .tour files are available in the tsp/tours directory
    # directory; these have been identified by a TSP solving method, but do not necessarily give an
    # necessarily give an optimal solution.
    myTourSize = nb_nodes(Cycle) + 1
    myTour = zeros(Int, myTourSize)

    nextNode = "2" # first node 
    myTour[1] = -1
    myTour[2] = 1
    # we start at the first node and find the tour 
    for i = 3:myTourSize
        idx = findfirst(edge -> nextNode in [name(node1(edge)), name(node2(edge))] && !(string(myTour[i-2]) in [name(node1(edge)), name(node2(edge))]), edges(Cycle))
        if nextNode == name(node1(edges(Cycle)[idx]))
            nextNode = name(node2(edges(Cycle)[idx]))
        else
            nextNode = name(node1(edges(Cycle)[idx]))
        end
        myTour[i] = parse(Int, nextNode)
    end
    myTour = myTour[2:end] 
    myTour = myTour.- 1 # we expct the tour to start from zero
    myTourFile = joinpath(@__DIR__, "shredder-julia", "tsp", "tours", fileName * ".tour")


    write_tour(myTourFile, myTour, Float32(cycleWeight)) # why in write_tour it expect Float32!!!

    inputFilename = joinpath(@__DIR__, "shredder-julia", "images", "shuffled", fileName * ".png")
    outputFilename = joinpath(@__DIR__, "shredder-julia", "images", "ourReconst", fileName * "-reconstructed.png")
    reconstruct_picture(myTourFile, inputFilename, outputFilename)



    println("------------------------------------------------------")

end
