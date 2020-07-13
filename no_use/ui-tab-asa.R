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

fluidRow(column(width = 4,
                
                radioButtons("from",  h3("Automatic Statistical Analysis:"),
                             choices = c("Default 'Pre-processing' by POMA"= 'beginning', 
                                         "Selected 'Pre-processing' by user" = 'userpre'),
                             selected = 'beginning'
                ),
                
                radioButtons("paired22",  h4("Is your data paired?"),
                             choices = c("TRUE" = 'TRUE', 
                                         "FALSE" = 'FALSE'),
                             selected = 'FALSE'),
                
                downloadButton("report2", "Generate automatic statistical report", 
                               style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                                 title = "Automatic Statistical Analysis helper",
                                                                                                                 content = "isa",
                                                                                                                 icon = "question",
                                                                                                                 colour = "green")
))

