library(shiny)
library(bs4Dash)
library(RSQLite)
library(rhandsontable)



ui <- dashboardPage(
  header = dashboardHeader(
    title = dashboardBrand(
      title = "App",
      color = "primary"
    )
    
  ),
  sidebar = dashboardSidebar(
    sidebarUserPanel(
      name = "Welcome"
    ),
    sidebarMenu(
      sidebarHeader("Pages"),
      menuItem(
        "Page 1",
        tabName = "page_1"
      )
    )
  ),
  body = dashboardBody(
    tabItems(
      tabItem(
        tabName = "page_1",
        fluidRow(
          textInput("db_dir",label = "Database directory",width = "20%"),
          textInput("df_name",label = "Dataframe Name",width = "20%")
        ),
        fluidRow(
        actionButton("sub_button","Import",width = "20%")
        ),
        fluidRow(
          textInput("col_name",label = "New Column Name",width = "20%"),
          textInput("row_name",label = "New Row Name",width = "20%"),
          textInput("del_col",label = "Delete Column",width = "20%"),
          textInput("del_row",label = "Delete Row",width = "20%")
          
        ),
        fluidRow(
          selectInput("select_col_type",
                      label = "Column Type",
                      choices = c("integer","character"), width = "20%")
        ),
        fluidRow(
          actionButton("add_col", "Add Column", icon("plus"),width = "20%"),
          actionButton("add_row", "Add Row", icon("plus"), width = "20%"),
          actionButton("delete_col", "Delete", icon("minus"), width = "20%"),
          actionButton("delete_row", "Delete", icon("minus"), width = "20%")
        ),
        br(),
        fluidRow(width="100%",
                 rHandsontableOutput("table_1", width = "100%")
        ),
        actionButton("save_button","Save",icon("save"),
                     style = "float:right")
      )
    )
  ),
  
)



