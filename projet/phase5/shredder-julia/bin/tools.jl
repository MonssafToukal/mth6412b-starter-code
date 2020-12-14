# using Random, FileIO, Images, ImageView, ImageMagick

"""Compute the similarity score between two pixels."""
function compare_pixels(p1, p2)
	r1, g1, b1 = Float64(red(p1)), Float64(green(p1)), Float64(blue(p1))
	r2, g2, b2 = Float64(red(p2)), Float64(green(p2)), Float64(blue(p2))
	return abs(r1-r2) + abs(g1-g2) + abs(b1-b2)
end

"""Compute the similarity score between two columns of pixels in an image."""
function compare_columns(col1, col2)
	score = 0
	nb_row = length(col1)
	for row = 1 : nb_row - 1
		score += compare_pixels(col1[row], col2[row])
	end
	return score
end

"""Compute the overall similarity score of a PNG image."""
function score_picture(filename::String)
	picture = load(filename)
	nb_col = size(picture, 2)
	score = 0
	for col = 1 : nb_col - 1
		println(col,"-",col+1, "->",compare_columns(picture[:,col], picture[:,col+1]))
		score += compare_columns(picture[:,col], picture[:,col+1])
	end
	return score
end

"""Write a tour in TSPLIB format."""
function write_tour(filename::String, tour::Array{Int}, cost::Float64)
	file = open(filename, "w")
	length_tour = length(tour)
	write(file,"NAME : $filename\n")
	write(file,"COMMENT : LENGTH = $cost\n")
	write(file,"TYPE : TOUR\n")
	write(file,"DIMENSION : $length_tour\n")
	write(file,"TOUR_SECTION\n")
	for node in tour
		write(file, "$(node + 1)\n")
	end
	write(file, "-1\nEOF\n")
	close(file)
end

"""Shuffle the columns of an image randomly or using a given permutation."""
function shuffle_picture(input_name::String, output_name::String; view::Bool=false, permutation=[])
	picture = load(input_name)
	nb_row, nb_col = size(picture)
	shuffled_picture = similar(picture)
    if permutation == []
    	permutation = shuffle(1:nb_col)
    end
	for col = 1 : nb_col
		shuffled_picture[:,col] = picture[:,permutation[col]]
	end
	view && imshow(shuffled_picture)
	save(output_name, shuffled_picture)
end

"""Read a tour file and a shuffle image, and output the image reconstructed using the tour."""
function reconstruct_picture(tour_filename::String, input_name::String, output_name::String; view::Bool=false)
	tour = Int[]
	file = open(tour_filename, "r")
	in_tour_section = false
	for line in eachline(file)
		line = strip(line)
		if line == "TOUR_SECTION"
			in_tour_section = true
		elseif in_tour_section
			node = parse(Int, line)
			if node == -1
				break
			else
				push!(tour, node - 1)
			end
		end
	end
	close(file)
	shuffled_picture = load(input_name)
	reconstructed_picture = shuffled_picture[:,tour[2:end]]
	view && imshow(reconstructed_picture)
	save(output_name, reconstructed_picture)
end

function get_edge_matrix(picture::Array{RGB{Normed{UInt8,8}},2})
	nb_row, nb_col = size(picture)
	w = zeros(nb_col, nb_col)
	for j1 =1: nb_col
		for j2 = j1 +1: nb_col
			w[j1, j2]= compare_columns(picture[:, j1], picture[:, j2])
		end
	end
	return w
end

""" generates a  rescaled picture of the image  and its tsp file. 
"""
function create_picture_data(initial_picture::String, new_dims::Tuple{Int64,Int64} = (1,1); is_resize = false)

	# loads the file and resive if needed.
	filepath = joinpath(@__DIR__, "..", "images", "original", initial_picture * ".png")
	img = load(filepath)
	img_small = is_resize ? imresize(img, new_dims) : img

	# string required to rename the file if resizing occurs.
	dim_str = is_resize ? "-$(new_dims)" : "" 

	resized_img_path = joinpath(@__DIR__, "..", "images", "original", initial_picture * dim_str * ".png")
	save(resized_img_path, img_small)

	resized_img_shuffle_path = joinpath(@__DIR__, "..", "images", "shuffled",initial_picture * dim_str * ".png")
	shuffle_picture(resized_img_path, resized_img_shuffle_path; view=false)

	img_small = load(resized_img_shuffle_path)
	w = get_edge_matrix(img_small)

	dims = length(img_small[1, :])

	for i in 1:dims
	    for j in i:dims
	        w[j,i] = w[i,j]
	    end
	end 

	tsp_file = open(joinpath(@__DIR__, "..", "tsp", "instances", initial_picture * dim_str * ".tsp"), "w")
	write(tsp_file,"NAME : $(initial_picture)" * (dim_str) * "\n")
	write(tsp_file,"TYPE : TSP\n")
	write(tsp_file, "COMMENT: Very resized $initial_picture\n")
	write(tsp_file,"DIMENSION : $(dims + 1)\n")
	write(tsp_file,"EDGE_WEIGHT_TYPE : EXPLICIT\n")
	write(tsp_file,"EDGE_WEIGHT_FORMAT : FULL_MATRIX\n")
	write(tsp_file,"DISPLAY_DATA_TYPE : NO_DISPLAY\n")
	write(tsp_file, "EDGE_WEIGHT_SECTION\n")

	[write(tsp_file, "0.0 ") for i in 1:dims + 1]
	write(tsp_file, '\n')
	for i in 1:dims
		write(tsp_file, "0.0 ")
	    for j in 1:dims
	        write(tsp_file, "$(w[i,j]) ")
	    end
	    write(tsp_file, '\n')
	end
	close(tsp_file)
end