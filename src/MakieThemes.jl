module MakieThemes

# Write your package code here.
using CairoMakie
import CairoMakie: set_theme!, update_theme!

include("CustomTheme.jl")

export CustomTheme, set_theme!, update_theme!

end