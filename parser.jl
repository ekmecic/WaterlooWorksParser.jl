module WWParser

@enum ApplicationState Interview NothingYet NotSelected

function main()
    # Slurp file into s
    f = open("input.txt")

    # Holds all the state of all jobs
    jobs = []

    # Parse each line
    lines = readlines(f)
    for line in lines
        jobState = parseLine(line)
        if jobState != nothing
            push!(jobs, jobState)
        end
    end

    # Calculate stats
    interviews  = length(findall(job -> job == Interview, jobs))
    nothingyets = length(findall(job -> job == NothingYet, jobs))
    rejections  = length(findall(job -> job == NotSelected, jobs))

    # Pretty print output
    println("Interviews:\t $interviews \t$(interviews / length(jobs) * 100)")
    println("Waiting:\t $nothingyets \t$(nothingyets / length(jobs) * 100)")
    println("Rejections:\t $rejections \t$(rejections / length(jobs) * 100)")
    println()
end

# Parse a line of WaterlooWorks input
# Garbage lines that don't contain job state are ignored
function parseLine(line)
    if occursin("Selected for Interview", line)
        return Interview
    elseif occursin("Applied", line) && occursin("Expired - Apps Available", line)
        return NothingYet
    elseif occursin("Applied", line)
        # If the the state is "Applied" but wasn't caught by the prev. condition
        # then you weren't selected
        return NotSelected
    end
end

end
