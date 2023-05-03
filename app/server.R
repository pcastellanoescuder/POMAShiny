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

shinyServer(function(input, output, session) {
  
  source("server-rightsidebar.R",local = TRUE)
  source("server-inputdata.R",local = TRUE)
  source("server-imputevalues.R",local=TRUE)
  source("server-normalization.R",local = TRUE)
  source("server-outliers.R",local = TRUE)
  source("server-volcano.R",local = TRUE)
  source("server-boxplot.R",local = TRUE)
  source("server-density.R",local = TRUE)
  source("server-heatmap.R",local = TRUE)
  source("server-univariate.R",local = TRUE)
  # source("server-multivariate.R",local = TRUE)
  # source("server-cluster.R",local = TRUE)
  # source("server-correlations.R",local = TRUE)
  # source("server-featureselection.R",local = TRUE)
  # source("server-random_forest.R",local = TRUE)
  # source("server-rankprod.R",local = TRUE)
  # source("server-odds.R",local = TRUE)
  }
)

