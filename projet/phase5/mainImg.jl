"""
This is  the main file for image reconstruction
"""

using  Pkg
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
    fileName = joinpath(@__DIR__, "shredder-julia","tsp","instances",graphName*".tsp")
    graph_nodes, graph_edges = read_stsp(fileName)


    # nodesList = AbstractNode[]
    if (length(graph_nodes) > 0) # check to see if the name is assigned in the TSP file, if not we do something else 
        nodesList = Node{typeof(graph_nodes[1])}[]
    else
        nodesList = Node{Int64}[]
    end


    for k=1:length(graph_edges)
        if (length(graph_nodes) > 0) # check to see if the name is assigned in the TSP file, if not we do something else 
            node_buff = Node(string(k),graph_nodes[k],nothing ,0,0,0)
        else
            node_buff = Node(string(k),k, nothing ,0,0,0) #name is the same as we assign it 
        end
        push!(nodesList,node_buff)
    end

    # edge positions
    # go through the edge list and create the edges of the graph


    edgesList=Edge[]

    # edgesList = AbstractEdge[]

    # add a flag if the nodes are read then you have a edge list then use it to get the node then assign 

    for k = 1 : length(graph_edges)
        for item in graph_edges[k]
            edge_buff = Edge(nodesList[k], nodesList[item[1]],item[2])
            push!(edgesList, edge_buff)
        end
    end


    # create a graph using data types
    # G = Graph(graphName, nodesList, edgesList)
    G = Graph(graphName, nodesList, Edge[])

    #adding the edges here so we test there is no dublicate 
    for k =1:length(edgesList)
        add_edge!(G,edgesList[k])
    end
    println("Finished creating a graph")

    # show(G)
    G
end



println("Reading all the images \n\n\n")
for fileName in readdir(joinpath(@__DIR__, "shredder-julia","tsp","instances"))
    fileName =replace(fileName, ".tsp" => "") # removing tsp since createGraph expcet only the name 
    println("reading the file: " ,fileName) 
    BufferG= createGraph(joinpath(@__DIR__, "shredder-julia","tsp","instances"),fileName)
    
    # find the first node that has 1 as the name 
    root = nodes(BufferG)[findfirst(n -> name(n) == "1", nodes(BufferG))]
    print(root)
    break

    # newG= deepcopy(BufferG)
    # # Testing Kruskal
    # MST = KruskalMST(BufferG)
    # println("The weight of KruskalMST for graph ", fileName," is ",weightGraph(MST)," and number of edges are ",nb_edges(MST))
    # println()

    # MST = PrimMST(BufferG)
    # println("The weight of PrimMST for graph ", fileName," is ",weightGraph(MST)," and number of edges are ",nb_edges(MST))
    # println()

    # cycleWeight, Cycle = RSL(1,nodes(BufferG)[1],BufferG)
    # println("The weight of RSL for graph ", fileName," is ",cycleWeight,"  Optimal Value is ", OptimalVal[fileName] )
    # if(cycleWeight>2*OptimalVal[fileName]) # this is what Prof. Orban suggested 
    #     println("The value of True is larger than 2* optimal value, we will test the triangle inequality hewre to make sure if it correct")
    #     flag=false
    #     #Trinagle Inequality
    #     for edge in edges(BufferG)
    #         for node in nodes(BufferG)
    #             if node != node1(edge) && node != node2(edge) # if the node isn't on the edge
    #                 e1 = findfirst(x-> (node1(x)==node && node2(node1(edge)))||(node2(x)==node && node1(node1(edge))),edges(BufferG)) 
    #                 e2 = findfirst(x-> (node1(x)==node && node2(node2(edge)))||(node2(x)==node && node1(node2(edge))),edges(BufferG)) 
    #                 if(weight(edge)>weight(e1)+weight(e2))
    #                     flag=true
    #                     print("Violate the triangle")
    #                     break
    #                 end
    #                 if(flag)
    #                     break
    #                 end
    #             end
    #         end
    #     end
    # end

    # println()
    # HK_cycle= HK_solver(1, nodes(newG)[1], newG, 10000000000000) 

    # println("The weight of HK Cycle for graph ", fileName," is ",weightGraph(HK_cycle),"  Optimal Value is ", OptimalVal[fileName] )
    # println()




    # println("------------------------------------------------------")
end


