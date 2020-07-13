# This file is part of POMA.

# POMA is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# POMA is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with POMA. If not, see <https://www.gnu.org/licenses/>.

fluidRow(
  column(width = 10,
         
         includeMarkdown("instructions/feedback.md"),
         HTML('<a href="mailto:pomapackage@gmail.com?">
              <input type = "button" 
              style = "background-color: #EA8620; 
                       border: none;
                       color: white; width: 150px; 
                       height: 40px; 
                       border-radius: 8px;" 
                       value = "Send us an email!">
              </a>')
         )
  )
         