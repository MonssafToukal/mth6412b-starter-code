### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ e222eeae-fdcb-11ea-18d4-85725dcdfef7
begin
	using Pkg
	using PlutoUI
	using Test
	import Base.show
	using Plots
	using LinearAlgebra
	using Random, FileIO, Images, ImageView, ImageMagick
	@enum Version slow_convergence = 1 lin_kernighan = 2
end

# ╔═╡ 68718350-ff8e-11ea-3da4-57a5b1b41c72
include("exceptions.jl")

# ╔═╡ 472da810-fdd4-11ea-2627-af24b931e523
begin
	include("node.jl")
end

# ╔═╡ 5314a490-fdd3-11ea-25ef-2d1f7fc1e992
begin
	include("edge.jl")
end

# ╔═╡ db19e470-fdd5-11ea-2975-41ca92f2cb6d
include( "graph.jl")

# ╔═╡ 64c277b0-04b5-11eb-0750-b320f1b4196e
begin 
	include("connected_component.jl")
end

# ╔═╡ 346e3af2-1d5f-11eb-1ec8-671bdd1ab73d
include("heuristics.jl")

# ╔═╡ 58045670-1d5f-11eb-3f41-956faefc6410
include("kruskal.jl")

# ╔═╡ 5db82560-1d5f-11eb-3cc8-3f0f181a3748
include("prim.jl")

# ╔═╡ 961d7820-3e33-11eb-3198-c9aee6e7f418
include("tree.jl")

# ╔═╡ da262800-3e33-11eb-385b-239589b2e1e8
include("RSL.jl")


# ╔═╡ 6082dd70-3e35-11eb-05ec-29b946444532
include("HK.jl")

# ╔═╡ 6bd9d980-3e35-11eb-2b52-ffc36bf99f8c
include(joinpath("shredder-julia", "bin", "tools.jl"))

# ╔═╡ 0be9edd0-fdcb-11ea-2e0b-99438dea97c4
md"""
# MTH6412B Project: Phase 5
"""

# ╔═╡ 85678ae0-3de6-11eb-1a26-89c4980af902


# ╔═╡ f37e7e90-ff88-11ea-1f2c-0ff0dac33bd4
md"""
## Authors: Monssaf Toukal (1850319) and Matteo Cacciola (2044855)
"""

# ╔═╡ 8ad5b910-ff8f-11ea-3835-734df59563c6
md"""
- The code is available by clicking [here](https://github.com/MonssafToukal/mth6412b-starter-code)
"""

# ╔═╡ a8aeedb0-3e34-11eb-37a2-4940e4330f48
pwd()

# ╔═╡ 11961ed0-fdcf-11ea-2e24-6fe10bafe291
pwd()

# ╔═╡ e03085f0-3e34-11eb-3fbe-e3549bfe51c6
cd(joinpath(@__DIR__, "projet", "phase5"))

# ╔═╡ 5b511e60-fdcc-11ea-2574-fd7e50a08873
Pkg.activate("mth6412b")

# ╔═╡ d1eaae90-fdce-11ea-38ab-070f79ea4f78
md"""
### Here are some functions to display results in the notebook
* `display(filename)` displays the whole file in the notebook
* `display(filename, line1, line2)` displays thelines between the two given lines of the file

"""

# ╔═╡ 20241830-3e34-11eb-1b50-4feabf26b7f0
begin
	function display(filename)
	  with_terminal() do
		open(filename, "r") do file
		  for line in readlines(file)
			println(stdout, line)
		  end
		end
	  end
	end

	function display(filename, line1, line2)
	  with_terminal() do
		open(filename, "r") do file
		  lines = readlines(file)
		  for i in line1:line2
			println(stdout, lines[i])
		  end
		end
	  end
	end
end

# ╔═╡ ceccea60-2d0e-11eb-28ff-3125e7ec774c
md"""
To run the main program, one must:
1. go to the mth-starter-code/projet/phase5 folder
2. run `julia main.jl`

**If one is using VS Code, make sure that you are not running the `main.jl` file with the Julia extension. We encountered problems doing so.**
"""

# ╔═╡ 7a83ac0e-2d08-11eb-02f4-034f05af6062
md"""
- First we include all the old files we wrote in the previous phases that we will need
"""

# ╔═╡ 42dd0570-0591-11eb-02d8-238f137cf89c
display("exceptions.jl")

# ╔═╡ 145b79d0-1d5f-11eb-07cf-b55cdb5a5fc7
display("Node.jl")

# ╔═╡ 955e1c00-0599-11eb-21fe-0db2e4a54261
display("Edge.jl")

# ╔═╡ facebcc0-0599-11eb-2f85-ffa3dee4d629
display("Connected_component.jl", 1, 18)

# ╔═╡ 6be4617e-1d5f-11eb-2d65-f5bb4f7de7f5
display("kruskal.jl", 1, 29)

# ╔═╡ 6cca2da0-1d5f-11eb-00d3-69943a0ca28b
display("prim.jl")

# ╔═╡ c2ad3760-3e36-11eb-0616-e75f72aa7493
md"""
- The function `create_picture_data` takes a picture as an argument and resizes it, if needed. Then, it generates its own tsp file from a shuffled version. 
"""

# ╔═╡ 898c1ff0-3e36-11eb-33a2-1f9cb8ff884d
display(joinpath("shredder-julia", "bin", "tools.jl"), 99, 148)

# ╔═╡ 1fcfd650-3e37-11eb-2f05-99599b2ee2f1
md"""
## Building the graph of the image
- Let's create a smaller picture of the original and its tsp file using `create_picture_data`:
- The first variable defines which algorithm we will be using to unshred an image (i.e HK or RSL). 

1. We first choose which picture to unshred.
2. we choose the new dimension of the resized image.
"""

# ╔═╡ 818f6b12-3e39-11eb-1126-dbc85ba45f8d


# ╔═╡ 4ed1fc80-3e37-11eb-01a9-6f495e767e0f
is_RSL=false

# ╔═╡ abc463b0-3e37-11eb-23a4-bb116e54dd61
begin
	original_picture_name = "pizza-food-wallpaper"
	dims = (100, 150)
end

# ╔═╡ e2d69850-3e37-11eb-14e6-23a0bb3903d6
create_picture_data(original_picture_name, dims; is_resize = true)

# ╔═╡ f4b99ae0-3e37-11eb-2eef-c5cb818f5bb1
md"""
If you don't want to resize, simply use it like so :

`create_picture_data(original_picture_name;is_resize = false)`

- We now change the picture name to the newly created image: 
"""

# ╔═╡ 15c254c0-3e38-11eb-02b4-1d1ca1b998e4
picture_name = "pizza-food-wallpaper-$(dims)"

# ╔═╡ b07f5e40-3e38-11eb-0767-0fbfb898e0ea
md"""
Now, we build the graph of the image using the tsp file. 

**Note: This step is quite intensive on the computer. The bigger the image, the longer this step will take. We suggest to downsize images to run the code in more reasonable time.** 
"""

# ╔═╡ 7ebbce20-3e38-11eb-2dd7-d3954cf9e66f
graph = build_graph(joinpath("shredder-julia", "tsp", "instances", picture_name * ".tsp"))


# ╔═╡ ab4cf450-3e38-11eb-330a-63cf8fbad5b0
md"""

## Finding a tour 

- The code below finds a tour and write a corresponding tour file
"""

# ╔═╡ 9dcabe62-3e39-11eb-27bb-d910f55b81c0
begin

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
	tour_filename = joinpath("shredder-julia", "tsp", "tours", picture_name * ".tour")
	input_filename = joinpath( "shredder-julia", "images", "shuffled", picture_name * ".png")
	output_filename = joinpath("shredder-julia", "images", "reconstructed", picture_name * "FINAL.png")
	write_tour(tour_filename, tour, cycle_weight)
end

# ╔═╡ ab4eac90-3e39-11eb-2564-6b294f20d1e6
md"""
## Image reconstruction

- We reconstruct the image
"""

# ╔═╡ 8a10bc6e-3e3a-11eb-3072-2dbf1af933ee
reconstruct_picture(tour_filename, input_filename, output_filename; view=false)

# ╔═╡ b3998f30-3e3b-11eb-354e-f3e0ff0a2685
md""" 
## Displaying results
"""

# ╔═╡ bbefa750-3e3b-11eb-14ac-ad3475b50461
begin
	plot1 = plot(ImageView.load(joinpath("shredder-julia", "images", "original", picture_name * ".png")), title = "Original Image")
	
	plot2 = plot(ImageView.load(joinpath("shredder-julia", "images", "reconstructed", picture_name * "FINAL.png")), title = "Reconstructed Image")
println("")
end

# ╔═╡ 621957be-3e3c-11eb-1d83-97e9fe45c55d
plot(plot1, plot2, layout = (1, 2))

# ╔═╡ e57bf1f2-3e3b-11eb-299e-9f9438ee5a37
md"""
- Here is the total weight of the cycle:
"""

# ╔═╡ 351c9720-3e3f-11eb-1f55-43c5894ee98e
cycle_weight

# ╔═╡ 6a6ad4a0-3e3f-11eb-2ac8-b13181e281ee
md"""
Here are other iamges that we reconstructed :
"""

# ╔═╡ 7811db30-3e3f-11eb-3c1d-0bfbb986b1c8
begin
	plot3 = plot(ImageView.load(joinpath("shredder-julia", "images", "original", "nikos-cat-(220, 220).png")), title = "Original Image")
	plot4 = plot(ImageView.load(joinpath("shredder-julia", "images", "reconstructed",  "nikos-cat-(220, 220)FINAL.png")), title = "Reconstructed Image")
	println("")
end

# ╔═╡ d5127330-3e3f-11eb-0910-717da0a006cc
plot(plot3, plot4, layout = (1, 2))

# ╔═╡ fc0e4ef0-3e3f-11eb-38ab-138ce74750ca
begin
	plot5 = plot(ImageView.load(joinpath("shredder-julia", "images", "original", "alaska-railroad-(150, 200).png")), title = "Original Image")
	plot6 = plot(ImageView.load(joinpath("shredder-julia", "images", "reconstructed",  "alaska-railroad-(150, 200)FINAL.png")), title = "Reconstructed Image")
	println("")
end

# ╔═╡ 13c356d0-3e40-11eb-1372-a3beba54c722
plot(plot5, plot6, layout = (1, 2))

# ╔═╡ 2414209e-3e40-11eb-1d9b-5b12da1d0360
begin
	plot7 = plot(ImageView.load(joinpath("shredder-julia", "images", "original", "lower-kananaskis-lake-(200, 300).png")), title = "Original Image")
	plot8 = plot(ImageView.load(joinpath("shredder-julia", "images", "reconstructed",  "lower-kananaskis-lake-(200, 300)FINAL.png")), title = "Reconstructed Image")
	println("")
end

# ╔═╡ 3f7c9390-3e40-11eb-122e-f7605d7df83b
plot(plot7, plot8, layout = (1, 2))

# ╔═╡ d7924840-3de7-11eb-3eb2-d59bae7c882c


# ╔═╡ Cell order:
# ╠═0be9edd0-fdcb-11ea-2e0b-99438dea97c4
# ╟─85678ae0-3de6-11eb-1a26-89c4980af902
# ╟─f37e7e90-ff88-11ea-1f2c-0ff0dac33bd4
# ╟─8ad5b910-ff8f-11ea-3835-734df59563c6
# ╠═e222eeae-fdcb-11ea-18d4-85725dcdfef7
# ╠═a8aeedb0-3e34-11eb-37a2-4940e4330f48
# ╟─11961ed0-fdcf-11ea-2e24-6fe10bafe291
# ╠═e03085f0-3e34-11eb-3fbe-e3549bfe51c6
# ╠═5b511e60-fdcc-11ea-2574-fd7e50a08873
# ╠═d1eaae90-fdce-11ea-38ab-070f79ea4f78
# ╠═20241830-3e34-11eb-1b50-4feabf26b7f0
# ╠═ceccea60-2d0e-11eb-28ff-3125e7ec774c
# ╠═7a83ac0e-2d08-11eb-02f4-034f05af6062
# ╠═68718350-ff8e-11ea-3da4-57a5b1b41c72
# ╟─42dd0570-0591-11eb-02d8-238f137cf89c
# ╠═472da810-fdd4-11ea-2627-af24b931e523
# ╟─145b79d0-1d5f-11eb-07cf-b55cdb5a5fc7
# ╠═5314a490-fdd3-11ea-25ef-2d1f7fc1e992
# ╟─955e1c00-0599-11eb-21fe-0db2e4a54261
# ╠═db19e470-fdd5-11ea-2975-41ca92f2cb6d
# ╠═64c277b0-04b5-11eb-0750-b320f1b4196e
# ╟─facebcc0-0599-11eb-2f85-ffa3dee4d629
# ╠═346e3af2-1d5f-11eb-1ec8-671bdd1ab73d
# ╠═58045670-1d5f-11eb-3f41-956faefc6410
# ╟─6be4617e-1d5f-11eb-2d65-f5bb4f7de7f5
# ╠═5db82560-1d5f-11eb-3cc8-3f0f181a3748
# ╠═6cca2da0-1d5f-11eb-00d3-69943a0ca28b
# ╠═961d7820-3e33-11eb-3198-c9aee6e7f418
# ╠═da262800-3e33-11eb-385b-239589b2e1e8
# ╠═6082dd70-3e35-11eb-05ec-29b946444532
# ╠═6bd9d980-3e35-11eb-2b52-ffc36bf99f8c
# ╠═c2ad3760-3e36-11eb-0616-e75f72aa7493
# ╠═898c1ff0-3e36-11eb-33a2-1f9cb8ff884d
# ╠═1fcfd650-3e37-11eb-2f05-99599b2ee2f1
# ╠═818f6b12-3e39-11eb-1126-dbc85ba45f8d
# ╠═4ed1fc80-3e37-11eb-01a9-6f495e767e0f
# ╠═abc463b0-3e37-11eb-23a4-bb116e54dd61
# ╠═e2d69850-3e37-11eb-14e6-23a0bb3903d6
# ╠═f4b99ae0-3e37-11eb-2eef-c5cb818f5bb1
# ╠═15c254c0-3e38-11eb-02b4-1d1ca1b998e4
# ╠═b07f5e40-3e38-11eb-0767-0fbfb898e0ea
# ╠═7ebbce20-3e38-11eb-2dd7-d3954cf9e66f
# ╠═ab4cf450-3e38-11eb-330a-63cf8fbad5b0
# ╠═9dcabe62-3e39-11eb-27bb-d910f55b81c0
# ╠═ab4eac90-3e39-11eb-2564-6b294f20d1e6
# ╠═8a10bc6e-3e3a-11eb-3072-2dbf1af933ee
# ╠═b3998f30-3e3b-11eb-354e-f3e0ff0a2685
# ╠═bbefa750-3e3b-11eb-14ac-ad3475b50461
# ╠═621957be-3e3c-11eb-1d83-97e9fe45c55d
# ╠═e57bf1f2-3e3b-11eb-299e-9f9438ee5a37
# ╠═351c9720-3e3f-11eb-1f55-43c5894ee98e
# ╠═6a6ad4a0-3e3f-11eb-2ac8-b13181e281ee
# ╠═7811db30-3e3f-11eb-3c1d-0bfbb986b1c8
# ╠═d5127330-3e3f-11eb-0910-717da0a006cc
# ╠═fc0e4ef0-3e3f-11eb-38ab-138ce74750ca
# ╠═13c356d0-3e40-11eb-1372-a3beba54c722
# ╠═2414209e-3e40-11eb-1d9b-5b12da1d0360
# ╠═3f7c9390-3e40-11eb-122e-f7605d7df83b
# ╟─d7924840-3de7-11eb-3eb2-d59bae7c882c
