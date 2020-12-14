
using Pkg
Pkg.activate(joinpath(@__DIR__, "mth6412b/"))
using Test
import Base.show
using Plots
using LinearAlgebra
using Random, FileIO, Images, ImageView, ImageMagick
@enum Version slow_convergence = 1 lin_kernighan = 2

include(joinpath(@__DIR__, "exceptions.jl"))
include(joinpath(@__DIR__, "node.jl"))
include(joinpath(@__DIR__, "edge.jl"))
include(joinpath(@__DIR__, "graph.jl"))
include(joinpath(@__DIR__, "connected_component.jl"))
include(joinpath(@__DIR__, "heuristics.jl"))
include(joinpath(@__DIR__, "kruskal.jl"))
include(joinpath(@__DIR__, "prim.jl"))
include(joinpath(@__DIR__, "tree.jl"))
include(joinpath(@__DIR__, "RSL.jl"))
include(joinpath(@__DIR__, "HK.jl"))
include(joinpath(@__DIR__, "shredder-julia", "bin", "tools.jl"))

is_RSL=false
picture_name = "lower-kananaskis-lake-(200, 300)"
create_picture_data(picture_name, (200,300); is_resize = true)

# die()
graph = build_graph(joinpath(@__DIR__, "shredder-julia", "tsp", "instances", picture_name * ".tsp"))
println("build graph done ✅")

root_node = nodes(graph)[findfirst(n -> name(n) == "1", nodes(graph))]
cycle, cycle_weight = is_RSL ? rsl(graph, root_node) : hk(graph)[3:4]
tour = zeros(Int, length(nodes(cycle)) + 1)
tour[1] = -1
tour[2] = 1
next_node = "1"
for i in 3:length(nodes(cycle)) + 1 
    idx = findfirst(e -> next_node in nodes(e) && !(tour[i-2] in [parse(Int, name) for name in nodes(e)]), edges(cycle))
global  next_node = next_node == nodes(edges(cycle)[idx])[1] ? nodes(edges(cycle)[idx])[2] : nodes(edges(cycle)[idx])[1]
    tour[i] = parse(Int, next_node)
end
tour = tour[2: end]


tour = tour .- 1
tour_filename = joinpath(@__DIR__, "shredder-julia", "tsp", "tours", picture_name * ".tour")
input_filename = joinpath(@__DIR__, "shredder-julia", "images", "shuffled", picture_name * ".png")
output_filename = joinpath(@__DIR__, "shredder-julia", "images", "reconstructed", picture_name * "FINAL.png")
write_tour(tour_filename, tour, cycle_weight)

println("write tour done ✅")

reconstruct_picture(tour_filename, input_filename, output_filename; view=true)

println("Best cycle weight found: $cycle_weight")