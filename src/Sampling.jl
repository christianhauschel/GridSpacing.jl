module Sampling

using LinearAlgebra

export cosine, geometric, conical


"""
    cosine(start, last, n; type=:single)

Return a cosine-spaced vector of length `n` between `start` and `last`.

# Arguments
- `start::Number`: The first value of the vector.
- `last::Number`: The last value of the vector.
- `n::Int`: The length of the vector.
- `type::Symbol`: The type of cosine spacing. Can be `:single` or `:double`.
"""
function cosine(start::Number, last::Number, n::Int; type::Symbol=:single)::Vector
    if type == :single
        return _conical(start, last, n; m=π / 2)
    else
        return _conical(start, last, n; m=π)
    end
end

"""
    geometric(start, last, n; shrinkage=1 / 1.2)

Defines a geometric spacing between `start` and `last` with `n` points.

The width of the elements shrink by a factor of `shrinkage`.
"""
function geometric(start, last, n; shrinkage=1 / 1.2)
    widths = zeros(n)
    widths[1] = 1.0
    for i = 2:(n-1)
        widths[i] = widths[i-1] * shrinkage
    end

    sampling = zeros(n)
    for i = 2:n
        sampling[i] = sum(widths[1:i-1])
    end

    # scaling 
    sampling = sampling ./ sampling[end]
    sampling = sampling .* (last - start) .+ start

    return sampling
end

"""
    conical(start, last, n; type=:single, coeff=1)

Return a conical-spaced vector of length `n` between `start` and `last`.

# Arguments
- `start::Number`: The first value of the vector.
- `last::Number`: The last value of the vector.
- `n::Int`: The length of the vector.
- `type::Symbol`: The type of conical spacing. Can be `:single` or `:bi`.
- `coeff::Number`: The coefficient of the conical spacing. Must be greater than 0.
"""
function conical(start, last, n; type=:single, coeff=1)
    bad_edge = false
    if type == :single
        return _conical(start, last, n; m=π / 2, coeff=coeff, bad_edge=bad_edge)
    else
        return _conical(start, last, n; m=π, coeff=coeff, bad_edge=bad_edge)
    end
end

function _conical(start, last, n; m=π, coeff=1, bad_edge=false)::Vector
    b = coeff

    if bad_edge
        x = Vector(range(m, stop=0, length=n + 2))
        x = filter!(i -> !(i == 2 || i == n + 1), x)
    else
        x = Vector(range(m, stop=0, length=n))
    end

    if b >= 1
        s = (1 .+ 1 ./ sqrt.(cos.(x) .^ 2 .+ sin.(x) .^ 2 / b^2) .* cos.(x)) * 0.5
    else
        cos_vals = cos.(x)
        s = ((cos_vals .+ 1) ./ 2 - x[end:-1:1] ./ π) .* b .+ x[end:-1:1] ./ π
    end

    sampling = s .* (last .- start) .+ start

    sampling = sampling .- sampling[1]
    fct_scaling = (sampling[end] - sampling[1]) / (last - start)
    sampling = sampling / fct_scaling .+ start
    return sampling
end

end