using BenchmarkTools
using StaticArrays
using Random

struct CellList{D,T}
    pos_min::SVector{D,T}
    pos_max::SVector{D,T}
    cell_width::T
    head::Array{Int,D}
    list::Vector{Int}
end
function CellList(pos_min::AbstractVector{T}, pos_max::AbstractVector{T}, cell_width::T, n_particles::Int=0) where {T}
    n_cells = @. Int(fld(pos_max - pos_min, cell_width)) + 1
    D = length(n_cells)
    head = Array{Int}(undef, n_cells...)
    list = Vector{Int}(undef, n_particles)
    CellList(SVector{D}(pos_min), SVector{D}(pos_max), cell_width, head, list)
end

function update!(cl::CellList{D,T}, pos::Vector{MVector{D,T}}) where {D,T}
    n = length(pos)
    n != length(cl.list) && resize!(cl.head, n)
    for i = 1:n
        i_cell = @. Int(fld(pos_max - pos_min, cell_width)) + 1
        cl.list[i] = cl.head[i]
        cl.head[i_cell] = i
    end
end