module MakieThemes

using CairoMakie
import CairoMakie: set_theme!, update_theme!

include("customtheme.jl")
include("utilityfunctions.jl")

export CustomTheme, set_theme!, update_theme!
export get_BBox, SysSizeLeg

end
