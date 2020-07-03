library(shiny)
library(bs4Dash)

shiny::shinyApp(
  ui = bs4DashPage(
    old_school = FALSE,
    sidebar_collapsed = FALSE,
    controlbar_collapsed = TRUE,
    title = "POMA",
    navbar = bs4DashNavbar(
      skin = "dark",
      status = "gray-light",
      border = TRUE,
      sidebarIcon = "bars",
      controlbarIcon = "th",
      fixed = FALSE,
      leftUi = bs4DropdownMenu(
        show = TRUE,
        align = "left",
        status = "warning",
        menuIcon = "envelope-open",
        src = NULL
      ),
      rightUi = bs4DropdownMenu(
        show = FALSE,
        status = "danger",
        src = "https://www.google.fr",
        bs4DropdownMenuItem(
          message = "message 1",
          from = "Divad Nojnarg",
          src = "https://adminlte.io/themes/v3/dist/img/user3-128x128.jpg",
          time = "today",
          status = "danger",
          type = "message"
        ),
        bs4DropdownMenuItem(
          message = "message 2",
          from = "Nono Gueye",
          src = "https://adminlte.io/themes/v3/dist/img/user3-128x128.jpg",
          time = "yesterday",
          status = "success",
          type = "message"
        )
      )
    ),
    sidebar = bs4DashSidebar(
      skin = "dark",
      status = "primary",
      title = "POMA",
      brandColor = "primary",
      url = "https://pcastellanoescuder.github.io/POMA/",
      src = "https://github.com/pcastellanoescuder/POMA/blob/master/man/figures/logo.png?raw=true",
      elevation = 3,
      opacity = 0.8,
      # bs4SidebarUserPanel(
      #   img = "home",
      #   text = "Home"
      # ),
      bs4SidebarMenu(
        bs4SidebarMenuItem(
          "Home",
          tabName = "home",
          icon = "home"
        ),
        
        # ---------------------------------------
        
        bs4SidebarHeader("Pre-processing"),
        bs4SidebarMenuItem(
          "Imputation",
          tabName = "item1",
          icon = "wrench"
        ),
        bs4SidebarMenuItem(
          "Normalization",
          tabName = "item2",
          icon = "wrench"
        ),
        bs4SidebarMenuItem(
          "Outlier Detection",
          tabName = "item2",
          icon = "wrench"
        ),
        # ---------------------------------------
        
        bs4SidebarHeader("Statistical Analysis"),
        bs4SidebarMenuItem(
          "Univariate analysis",
          tabName = "item1",
          icon = "sliders"
        ),
        bs4SidebarMenuItem(
          "Multivariate analysis",
          tabName = "item2",
          icon = "sliders"
        ),
        bs4SidebarMenuItem(
          "Limma",
          tabName = "item2",
          icon = "sliders"
        ),
        # ---------------------------------------
        
        bs4SidebarMenuItem(
          "Help",
          tabName = "item1",
          icon = "question"
        ),
        bs4SidebarMenuItem(
          "Terms & Conditions",
          tabName = "item1",
          icon = "clipboard"
        ),
        bs4SidebarMenuItem(
          "About Us",
          tabName = "item1",
          icon = "user"
        ),
        bs4SidebarMenuItem(
          "Give us feedback",
          tabName = "item1",
          icon = "backward"
        )
      )
    ),
    controlbar = bs4DashControlbar(
      skin = "light",
      title = "My right sidebar",
      sliderInput(
        inputId = "obs",
        label = "Number of observations:",
        min = 0,
        max = 1000,
        value = 500
      ),
      column(
        width = 12,
        align = "center",
        radioButtons(
          inputId = "dist",
          label = "Distribution type:",
          c("Normal" = "norm",
            "Uniform" = "unif",
            "Log-normal" = "lnorm",
            "Exponential" = "exp")
        )
      )
    ),
    footer = bs4DashFooter(
      copyrights = a(
        href = "https://twitter.com/divadnojnarg",
        target = "_blank", "@DivadNojnarg"
      ),
      right_text = "2018"
    ),
    body = bs4DashBody(
      bs4TabItems(
        bs4TabItem(
          tabName = "item1",
          fluidRow(
            lapply(1:3, FUN = function(i) {
              bs4Sortable(
                width = 4,
                p(class = "text-center", paste("Column", i)),
                lapply(1:2, FUN = function(j) {
                  bs4Card(
                    title = paste0("I am the ", j,"-th card of the ", i, "-th column"),
                    width = 12,
                    "Click on my header"
                  )
                })
              )
            })
          )
        ),
        bs4TabItem(
          tabName = "item2",
          bs4Card(
            title = "Card with messages",
            width = 9,
            userMessages(
              width = 12,
              status = "success",
              userMessage(
                author = "Alexander Pierce",
                date = "20 Jan 2:00 pm",
                src = "https://adminlte.io/themes/AdminLTE/dist/img/user1-128x128.jpg",
                side = NULL,
                "Is this template really for free? That's unbelievable!"
              ),
              userMessage(
                author = "Dana Pierce",
                date = "21 Jan 4:00 pm",
                src = "https://adminlte.io/themes/AdminLTE/dist/img/user5-128x128.jpg",
                side = "right",
                "Indeed, that's unbelievable!"
              )
            )
          )
        )
      )
    )
  ),
  server = function(input, output) {}
)