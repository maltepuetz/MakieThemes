struct CustomTheme
    name::Symbol
    size_inches::Tuple{Int,Int}
    type::String
    pt_per_unit::Float64
    theme::Attributes


    function CustomTheme(;
        name::Symbol=:MyTheme,
        size_inches::Tuple{Int,Int}=(5, 3),
        type::String="svg",
        pt_per_unit::Float64=1.3
    )

        # set the size of the figure
        size_pt = 72 .* size_inches

        # load the font
        LaTeX_font = (@__DIR__) * "/fonts/cmunrm.ttf"

        theme = Theme(
            figure_padding=2,
            resolution=size_pt,
            fontsize=10,
            fonts=(; LaTeX=LaTeX_font),
            Lines=(
                linewidth=2.0,
            ),
            Scatter=(
                markersize=5.0,
                strokewidth=0.7,
                marker=:circle
            ),
            Errorbars=(
                linewidth=0.7,
                whiskerwidth=6.0
            ),
            Axis=(
                # change all fonts to LaTeX
                subtitlefont=:LaTeX,
                titlefont=:LaTeX,
                xlabelfont=:LaTeX,
                xticklabelfont=:LaTeX,
                ylabelfont=:LaTeX,
                yticklabelfont=:LaTeX,
            ),
            Axis3=(
                # change all fonts to LaTeX
                subtitlefont=:LaTeX,
                titlefont=:LaTeX,
                xlabelfont=:LaTeX,
                xticklabelfont=:LaTeX,
                ylabelfont=:LaTeX,
                yticklabelfont=:LaTeX,
            ),
            Legend=(
                labelfont=:LaTeX,
                padding=(8.0f0, 8.0f0, 5.0f0, 5.0f0), # The additional space between the legend content and the border.
                patchlabelgap=5, # The gap between the patch and the label of each legend entry. 
                patchsize=(11, 6), # The size of the rectangles containing the legend markers.
                rowgap=2, # The gap between the entry rows.
                titlefont=:LaTeX,
                titlegap=3,
                margin=(7.0f0, 7.0f0, 7.0f0, 7.0f0),
            ),
        )

        # create the theme
        return new(name, size_inches, type, pt_per_unit, theme)
    end
end


function update_theme!(custom_theme::CustomTheme)
    # change appearance in a jupyter notebook
    CairoMakie.activate!(type=custom_theme.type, pt_per_unit=custom_theme.pt_per_unit)

    # update theme
    update_theme!(custom_theme.theme)
end


function set_theme!(custom_theme::CustomTheme)
    # change appearance in a jupyter notebook
    CairoMakie.activate!(type=custom_theme.type, pt_per_unit=custom_theme.pt_per_unit)

    # set theme
    set_theme!(custom_theme.theme)
end
