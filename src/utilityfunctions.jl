

##### some useful functions
"""
    get_BBox(ax;
        margin = (7.0, 7.0, 7.0, 7.0),
        position = :rt,
        width = 100,
        height = 100,
        kwargs...)
This function returns a BBox object which can be used to place a new axis.
"""
function get_BBox(ax;
    position=:rt,
    width=100,
    height=100,
    kwargs...)

    haskey(kwargs, :margin) ? margin = kwargs[:margin] : margin = ax.blockscene.theme[:Legend][:margin][]

    ax_bbox = ax.layoutobservables.computedbbox[]
    l = left(ax_bbox) + margin[1]
    r = right(ax_bbox) - margin[2]
    b = bottom(ax_bbox) + margin[3]
    t = top(ax_bbox) - margin[4]

    # if legend is given update l or r
    if haskey(kwargs, :legend)
        legend = kwargs[:legend]
        leg_bbox = leg.layoutobservables.computedbbox[]

        if MakieLayout.center(leg_bbox)[1] > MakieLayout.center(ax_bbox)[1]
            r = left(leg_bbox) + legend.margin[][1] - margin[2]
        else
            l = right(leg_bbox) - legend.margin[][2] + margin[1]
        end
    end

    occursin("l", (position |> string)) && (r = l + width)
    occursin("r", (position |> string)) && (l = r - width)
    occursin("b", (position |> string)) && (t = b + height)
    occursin("t", (position |> string)) && (b = t - height)

    BBox(l, r, b, t)
end

"""
    SysSizeLeg(ax, Ls;
        kwargs...)

#### kwargs:
- markersize
- marker
- colors
- labels
- position
- margin
- title
"""
function SysSizeLeg(ax, Ls, colors;
    kwargs...)

    haskey(kwargs, :markersize) ? markersize = kwargs[:markersize] : markersize = 6.5
    haskey(kwargs, :marker) ? marker = kwargs[:marker] : marker = :circle
    haskey(kwargs, :strokewidth) ? strokewidth = kwargs[:strokewidth] : strokewidth = 0.7
    haskey(kwargs, :linewidth) ? linewidth = kwargs[:linewidth] : linewidth = 2.0
    haskey(kwargs, :linestyle) ? linestyle = kwargs[:linestyle] : linestyle = :solid
    haskey(kwargs, :labels) ? labels = kwargs[:labels] : labels =
        begin
            # get the number of characters in an integer
            function get_n_digits(n)
                floor(Int, log10(n)) + 1
            end
            res = Vector{Makie.LaTeXString}(undef, length(Ls))
            for (i, L) in enumerate(Ls)
                n_spaces = get_n_digits(Ls[end]) - get_n_digits(L)
                res[end+1-i] = "L = " * "\\;"^(2 * n_spaces) * "$(L)" |> Makie.latexstring
            end
            res
        end
    haskey(kwargs, :position) ? position = kwargs[:position] : position = :rt
    haskey(kwargs, :margin) ? margin = kwargs[:margin] : margin = ax.blockscene.theme[:Legend][:margin][]
    haskey(kwargs, :title) ? title = kwargs[:title] : title = "System Sizes"
    haskey(kwargs, :element) ? element = kwargs[:element] : element = :scatter

    elements = [
        if element == :scatter
            MarkerElement(
                color=colors[i],
                markersize=markersize,
                marker=marker,
                strokewidth=strokewidth
            )
        elseif element == :line
            LineElement(
                color=colors[i],
                linewidth=linewidth,
                linestyle=linestyle,
            )
        elseif element == :scatterline
            [
                LineElement(
                    color=colors[i],
                    linewidth=linewidth,
                    linestyle=linestyle,
                ),
                MarkerElement(
                    color=colors[i],
                    markersize=markersize,
                    marker=marker,
                    strokewidth=strokewidth
                )
            ]
        else
            throw(ArgumentError("element must be one of [:scatter, :line, :scatterline]"))
        end
        for i in length(Ls):-1:1
    ]


    if typeof(position) == Array{Int64,1}
        Legend(
            ax.parent[position[1], position[2]],
            elements,
            labels,
            title;
            margin=margin
        )

        haskey(kwargs, :setgap) ? (setgap = kwargs[:setgap]) : (setgap = true)
        if setgap
            colgap!(ax.parent.layout, 5.0)
            rowgap!(ax.parent.layout, 5.0)
        end

    else
        axislegend(
            ax,
            elements,
            labels,
            title;
            position=position,
            margin=margin
        )
    end
end
