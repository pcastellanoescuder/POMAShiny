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

#### This file creates a random dataset to test the 
#### "Combine features" option in the POMAShiny software
#### CSV files available at: https://github.com/pcastellanoescuder/POMAShiny/tree/master/example_data

library(tidyverse)

features <- tibble(feature1 = c(rnorm(3, mean = 3, sd = 0.5), rnorm(3, mean = 2.5, sd = 0.5)),
                   feature2 = c(rnorm(3, mean = 1, sd = 0.5), rnorm(3, mean = 1, sd = 0.5)),
                   feature3 = c(rnorm(3, mean = 2, sd = 0.5), rnorm(3, mean = 2, sd = 0.5)),
                   feature4 = c(rnorm(3, mean = 2, sd = 0.5), rnorm(3, mean = 2.5, sd = 0.5)),
                   feature5 = c(rnorm(3, mean = 14, sd = 0.5), rnorm(3, mean = 20, sd = 0.5)),
                   feature6 = c(rnorm(3, mean = 8, sd = 0.5), rnorm(3, mean = 9, sd = 0.5)))

target <- tibble(ID = c("sample1", "sample2", "sample3", "sample4", "sample5", "sample6"),
                 group = c(rep("control", 3), rep("case", 3)))

grouping <- tibble(feature = c("feature1", "feature2", "feature3", "feature4", "feature5", "feature6"),
                   grouping_factor = c(1, 1, 2, 3, 4, 4),
                   new_name = c("features1_2", "features1_2", "feature3", "feature4", "features5_6", "features5_6"))