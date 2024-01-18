using Revise
using Sampling
using PyPlot, PyCall
pplt = pyimport("proplot")
pplt.close("all")

x0 = -1.0
x1 = 1.0
n = 30
type_cosine = :single
type_conical = :bi

x_cosine = cosine(x0, x1, n; type=type_cosine)
x_geometric = geometric(x0, x1, n; shrinkage=1 / 1.1)
x_conical = conical(x0, x1, n; type=type_conical, coeff=2)

ids = LinRange(x0, x1, n)

fig, ax = pplt.subplots(figsize=(6, 3))
ax[1].plot(ids, LinRange(1, 1, n), ".", ms=2, label="uniform")
ax[1].plot(x_cosine, LinRange(2, 2, n), ".", ms=2, label="cosine $type_cosine")
ax[1].plot(x_conical, LinRange(3, 3, n), ".", ms=2, label="conical $type_conical")
ax[1].plot(x_geometric, LinRange(4, 4, n), ".", ms=2, label="geometric")
ax[1].set(
    title="Sampling Methods",
    xlabel="x",
)
ax[1].legend(ncols=1)
fig

# fig.savefig("doc/img/sampling.png", dpi=300, bbox_inches="tight")