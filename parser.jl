module WWParser

using Printf
using Dates
@enum ApplicationState Interview NothingYet NotSelected

Base.@ccallable function julia_main(ARGS::Vector{String})::Cint
    println("Ctrl+A and Ctrl+C on WaterlooWorks, then paste here and press Ctrl+D:")
    # Read until EOF (Ctrl+D) in terminal and parse input
    jobs = map(parseLine, readlines())

    # Filter out all the nothings
    filter!(job -> job != nothing, jobs)

    # Calculate stats
    interviews  = length(findall(job -> job == Interview, jobs))
    nothingyets = length(findall(job -> job == NothingYet, jobs))
    rejections  = length(findall(job -> job == NotSelected, jobs))

    # Pretty print output
    print("Interviews:\t $interviews\t"); @printf("%.1f%%\n", (interviews / length(jobs)) * 100)
    print("Waiting:\t $nothingyets\t");   @printf("%.1f%%\n", (nothingyets / length(jobs)) * 100)
    print("Rejections:\t $rejections\t"); @printf("%.1f%%\n", (rejections / length(jobs)) * 100)
    println()
    print("Conversion rate: \t"); @printf("%.1f%%\n", (interviews / (interviews + rejections)) * 100)
    println("Total applications:\t$(length(jobs))")

    # Write stats to file for later analysis
    open("/home/emil/cloud/projects/WaterlooWorksParser.jl/f2018_stats.tsv", "a") do f
        write(f, "$(Dates.now())\t$interviews\t$nothingyets\t$rejections\n")
    end
    return 0
end

# Parse a line of WaterlooWorks input. Lines that don't contain job state are ignored
function parseLine(line)
    if occursin("Selected for Interview", line)
        return Interview
    elseif occursin("Applied", line) && occursin("Expired - Apps Available", line)
        return NothingYet
    elseif occursin("Applied", line)
        # If the state is "Applied" but wasn't caught earlier -> not selected
        return NotSelected
    end
end

end
