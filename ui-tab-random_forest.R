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
  column(width = 3,
                wellPanel(
                  
                  numericInput("rf_test", "Test partition (%):", value = 20),
                  
                  sliderInput("rf_ntrees","Number of trees:",min=10,max=500,value=300,step = 1),
                  
                  sliderInput("rf_mtry", "Number of variables randomly sampled as candidates at each split:",min=1,max=20,value=5,step = 1),
                  
                  sliderInput("rf_nodesize","Node Size:",min=1,max=30,value=5,step = 1),
                  
                  numericInput("rf_numvar","Number of Selected Features:", value=15),
                  
                  actionButton("plot_rf","Analyze", icon("step-forward"),
                               style="color: #fff; background-color: #00b300; border-color: #009900") %>% helper(type = "markdown",
                                                                                                                 title = "Random forest helper",
                                                                                                                 content = "random_forest",
                                                                                                                 icon = "question",
                                                                                                                 colour = "green")
  )),
  
  column(width = 9,
         
         fluidPage(tabsetPanel(
           tabPanel("Confusion Matrix", dataTableOutput("confusion")),
           tabPanel("OOB Error Rate Plot", plotlyOutput("oob_error")),
           tabPanel("OOB Error Rate Table", dataTableOutput("oob_error_table")),
           tabPanel("MeanDecreaseGini Plot", plotlyOutput("Gini")),
           tabPanel("MeanDecreaseGini Table", dataTableOutput("gini_table"))
           
         ))
                   
  ))
         
