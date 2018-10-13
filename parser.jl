module WWParser

using Printf

@enum ApplicationState Interview NothingYet NotSelected

function main()
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
    return 0
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
