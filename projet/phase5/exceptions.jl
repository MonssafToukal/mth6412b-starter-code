import Base.showerror

struct NodeError <: Exception
    var::String
end
Base.showerror(io::IO, e::NodeError) = println(io, "Node error:", e.var, "!")

struct EdgeError <: Exception
    var::String
end
Base.showerror(io::IO, e::EdgeError) = println(io, "Edge error:", e.var, "!")
