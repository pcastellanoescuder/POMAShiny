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

tabPanel("Give us feedback",
         fluidRow(
           column(width = 10,
                  
                  h1("Give us feedback"),
                  
                  h4("Dear user,"),
                  h4("POMA is in a continous development. 
                     According to this, we are totally open to user 
                     bug reports to keep improving our app."), 
                  h4("Please, notice us if you have found some error in 
                     POMA or if you have any suggerence to improve our app."),
                  h4("Thank you,"),
                  h4(HTML("<b>POMA team.</b>")),
                  br(),
                  HTML('<a href="mailto:pomapackage@gmail.com?">
                       <button>
                       Send us an email!
                       </button>
                       </a>'
                       )
                  )))

