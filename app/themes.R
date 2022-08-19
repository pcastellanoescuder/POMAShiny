# This file is part of POMAShiny.

# POMAShiny is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# POMAShiny is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with POMAShiny. If not, see <https://www.gnu.org/licenses/>.

poma_theme <- create_theme(
  # navbar
  bs4dash_vars(
    navbar_dark_color = "#FFFFFF",
    navbar_dark_active_color = "#EA8620",
    navbar_dark_hover_color = "#EA8620"
  ),
  # main bg
  bs4dash_layout(
    main_bg = "#FFFFFF"
  ),
  # sidebar
  bs4dash_sidebar_dark(
    bg = "#336B87",
    color = "#FFFFFF",
    hover_color = "#EA8620",
    active_color = "000000",
    # submenu
    submenu_bg = "#336B87",
    submenu_active_color = "#000000",
    submenu_active_bg = "#EA8620",
    submenu_color = "#FFFFFF",
    submenu_hover_color = "#EA8620"
  ),
  # status
  bs4dash_status(
    primary = "#336B87", warning = "#EA8620"
  )
)

