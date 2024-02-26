using Revise
using GridSpacing
using Plots

x0 = -1.0
x1 = 1.0
n = 30
type_cosine = :single
type_conical = :bi

x_cosine = cosine(x0, x1, n; type=type_cosine)
x_geometric = geometric(x0, x1, n; shrinkage=1 / 1.1)
x_conical = conical(x0, x1, n; type=type_conical, coeff=2)

ids = LinRange(x0, x1, n)

p = plot(
    layout=(1, 1),
    size=(600, 300),
    xlabel="x",
)

plot!(p, ids, LinRange(1, 1, n), label="uniform", marker=:circle, ms=2)
plot!(p, x_cosine, LinRange(2, 2, n), label="cosine $type_cosine", marker=:circle, ms=2)
plot!(p, x_conical, LinRange(3, 3, n), label="conical $type_conical", marker=:circle, ms=2)
plot!(p, x_geometric, LinRange(4, 4, n), label="geometric", marker=:circle, ms=2)

savefig(p, "docs/src/assets/spacing.png")