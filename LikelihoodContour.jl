using DifferentialEquations
using CSV
using DiffEqSensitivity
using Random
using Distributions
using StatsBase
using Plots
using StatsPlots
using LaTeXStrings
using Colors
using Tables
using DataFrames
using Dates

plotlyjs()

include("src/MyColours.jl")

a ⊕ b = reduce(+, view(a .* b, 1:length(a)), init=0.0)

function seir_ode!(du, u, p, t)
    (α, β, γ) = p
    @inbounds begin
        du[1] = - β * u[1] * u[3]
        du[2] = β * u[1] * u[3] - α * u[2]
        du[3] = α * u[2] - γ * u[3]
        du[4] = γ * u[3]
    end
    nothing
end

function seir_binom_likelihood(nDays, nPrisoners,  nCount, α, β, γ, ρ)
    p = [α, β, γ]
    u0 = [1.0, ρ, 0.0, 0.0]

    if nDays < 21
        tspan = (0.0, nDays)
        prob = ODEProblem(seir_ode!, u0, tspan, p)
        times = [0.0, nDays]
        sol = solve(prob, Tsit5(), saveat = times)
        sol_S = Array(sol)[1,:]
        binom_prob = 1 - sol_S[2]
    else
        tspan = (0.0, nDays)
        prob = ODEProblem(seir_ode!, u0, tspan, p)
        times = [nDays-21.0, nDays]
        sol = solve(prob, Tsit5(), saveat = times, save_end = true)
        sol_S = Array(sol)[1,:]
        binom_prob = sol_S[1] - sol_S[2]
    end
    return logpdf(Binomial(nPrisoners, binom_prob), nCount)
end

function seir_contour_data(nPrisoners, nCount; dt=0.1)
    R0 = 1.01:dt:25.1
    days = 10:1:125
    α = log(2)/5.1
    γ = 1/5.6
    ρ = 1/nPrisoners
    contour_data = DataFrame(R0 = Float64[], nDays = Int64[], Loglikelihood = Float64[], Likelihood = Float64[])
    for r in R0
        for d in days
            β = r * γ
            l = seir_binom_likelihood(d, nPrisoners,  nCount, α, β, γ, ρ)
            push!(contour_data, (r, d, l, exp(l)))
        end
    end
    return contour_data
end

datafilename = "MCI_PCI_FMC.csv"
prison_data = CSV.read("data/" * datafilename)

MCI_df = DataFrame(Date = prison_data.Date, CumulativeCounts = prison_data.MCI)
MCI_df.DailyNewCases = pushfirst!(diff(MCI_df.CumulativeCounts),0)

MCI_testing_day = Date(2020, 04, 16)

α = log(2)/5.1
γ = 1/5.6

first_date = minimum(Date.(MCI_df.Date))
days_to_count = ["2020-04-16", "2020-04-17", "2020-04-18", "2020-04-19", "2020-04-20", "2020-04-21", "2020-04-22", "2020-04-23"]
MCI_testing_day_counts = sum(filter(:Date => x -> x in Date.(days_to_count), MCI_df).DailyNewCases)
nDays = Dates.value(MCI_testing_day - first_date)

MCI_nPrisoners = 2453
ρ = 1/MCI_nPrisoners

contour_data = seir_contour_data(MCI_nPrisoners, MCI_testing_day_counts)

truncate_at(x; cutoff = 1500) = x <= - cutoff ? - cutoff : x
date_subtract(x; from_date = MCI_testing_day) = from_date - Dates.Day(x)

contour_data[!, :RevisedLogLikelihood] = truncate_at.(contour_data.Loglikelihood) 
contour_data[!, :OnsetDate] = date_subtract.(contour_data.nDays; from_date = MCI_testing_day)

finer_contour_data = seir_contour_data(MCI_nPrisoners, MCI_testing_day_counts; dt=0.01)
finer_contour_data[!, :RevisedLogLikelihood] = truncate_at.(finer_contour_data.Loglikelihood) 

days = 10:1:125
onset_dates = date_subtract.(days; from_date = MCI_testing_day)
max_likelihood = Array{Float64, size(days)}
max_likelihood = Float64[]
r0_mle = Float64[]

for d in days
    filtered_df = filter(:nDays => x -> x == d, finer_contour_data)
    best_likelihood = maximum(filtered_df.Loglikelihood)
    push!(max_likelihood, best_likelihood)
    r0_mle_df = filter(:Loglikelihood => x -> x >= best_likelihood - 0.1 && x <= best_likelihood + 0.1 , filtered_df)
    push!(r0_mle, minimum(r0_mle_df.R0))
end 

pl1 = contourf(contour_data.OnsetDate, contour_data.R0, contour_data.RevisedLogLikelihood, nlevels = 50, fill=true, w=3)
xlabel!("Onset date")
# ylabel!(L"R_0")
ylabel!("R0")
fname = "MCI_LikelihoodContours"
savefig(pl1, "plots/" * fname * ".pdf")
savefig(pl1, "plots/" * fname * ".svg")
savefig(pl1, "plots/" * fname * ".png")

pl2 = plot(onset_dates, r0_mle, label="Most likely R0", color=cyans[3], linewidth=4, grid=true)
xlabel!("Onset date")
# ylabel!(L"\mathcal{R}_0")
# ylabel!("Most likely R_0")
fname = "MCI_MostlikelyR0"
savefig(pl2, "plots/" * fname * ".pdf")
savefig(pl2, "plots/" * fname * ".svg")
savefig(pl2, "plots/" * fname * ".png")

l = @layout [a{0.45w} b{0.45w}]
pl = plot(pl1, pl2, layout = l, size=(1500, 500))

fname = "MCI_LikelihoodContoursR0Combined"
savefig(pl, "plots/" * fname * ".pdf")
savefig(pl, "plots/" * fname * ".svg")
savefig(pl, "plots/" * fname * ".png")











