# item data :r =, f = setup cost, s =, h = inventory cost
mutable struct DataSmMiLs
    nbitems::Int
    nbperiods::Int
    nbscenarios::Int
    setupcost::Array{Int,2}
    prodcost::Array{Int,2}
    demand::Array{Int,3}
end

function data(filename::AbstractString)
    data = Int[]
    filepath = string(@__DIR__ , "/instances/" , filename)
    # nbitems nbperiods
    # demand setupcost prodcost
    open(filepath) do file
        for line in eachline(file)
            for pieceofdata in split(line)
                push!(data, parse(Int, pieceofdata))
            end
        end
    end
    # nbitems nbperiods nbscenarios
    nbitems = data[1]
    nbperiods = data[2]
    nbscenarios = data[3]
    offset = 4

    @show nbitems nbperiods nbscenarios 

    # demand setupcost prodcost demand2
    demand = zeros(Int, nbitems, nbperiods, nbscenarios)
    @show demand
    
    setupcost = zeros(Int, nbitems, nbperiods)
    @show setupcost
    
    prodcost = zeros(Int, nbitems, nbperiods)
    @show prodcost
    
    for t = 1:nbperiods
        for i = 1:nbitems
            demand[i,t,1] = data[offset]
            offset += 1
            setupcost[i,t] = data[offset]
            offset += 1
            prodcost[i,t] = data[offset]
            offset += 1
            for o = 2:nbscenarios
                demand[i,t,o] = data[offset]
                offset += 1
            end
        end
    end

    nbitems = 2
    nbperiods = 5
    
    @show demand
    @show setupcost
    @show prodcost
    

    # demand setupcost prodcost demand2
    return DataSmMiLs(nbitems, nbperiods, nbscenarios, setupcost, prodcost, demand)
end

function d(data::DataSmMiLs, item::Int, period::Int, scenario::Int)
    return data.demand[item, period, scenario]
    #return data.data[1, (period - 1) * data.nbitems * * nbscenarios  + item]
end

function s(data::DataSmMiLs, item::Int, period::Int)
    return data.setupcost[item, period]
    #[2, (period - 1) * data.nbitems + item]
end

function c(data::DataSmMiLs, item::Int, period::Int)
    return data.prodcost[item, period]
    #return data.data[3, (period - 1) * data.nbitems + item]
end

function show(io::IO, data::DataSmMiLs)
    println(io, "nbperiods = ", data.nbperiods, "  nbitems = ", data.nbitems)
    for i in 1:data.nbitems
        println(io, "> item ", i)
        for p in 1:data.nbperiods
            println(io, "\t > period ", p, " : demand = ", d(data,i,p), "  setupcost = ", s(data,i,p), "  prodcost = ", p(data, i, p))
        end
    end
end
