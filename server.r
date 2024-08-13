library(shiny)
library(bs4Dash)
library(RSQLite)
library(rhandsontable)

server <- function(input, output, session) {
  
  observeEvent(input$sub_button,{
    db_1 <- dbConnect(SQLite(),input$db_dir)
    if(length(dbListTables(db_1))==0){
      df_1 <- data.frame(First_Col=0)
      table_data <- reactiveVal(df_1)
      
    }else{
      if(input$df_name %in% dbListTables(db_1)){
      df_1 <- dbReadTable(conn = db_1, input$df_name)
      table_data <- reactiveVal(df_1)
      }else{
        df_1 <- data.frame(Names=0)
        table_data <- reactiveVal(df_1)
      }
    }
    output$table_1 <- renderRHandsontable({
      rhandsontable(table_data())
    })
    
    observeEvent(input$add_col,{
      current_data <- table_data()
      if(input$col_name %in% colnames(current_data)){
        showNotification("Duplicate Column!")
      }else{
        for (i in ncol(current_data)+1) {
          if(input$select_col_type=="character"){
            new_col <- as.character(rep(0,nrow(current_data)))
            current_data$newcol <- new_col
            colnames(current_data)[i] <- input$col_name
          }else{
            new_col <- rep(0,nrow(current_data))
          current_data$newcol <- new_col
          colnames(current_data)[i] <- input$col_name
          }
          
        }
        
        table_data(current_data)
      }
      
    })
    
    observeEvent(input$add_row,{ 
      current_data <- table_data()
      if(input$row_name %in% rownames(current_data)){
        showNotification("Duplicate Row!")
      }else{
        for(i in nrow(current_data)+1){
          new_row <- rep(0,ncol(current_data))
          current_data <- current_data |> rbind(new_row)
          rownames(current_data)[i] <- input$row_name
        }
        table_data(current_data)
      }
    }
    )
    
    observeEvent(input$delete_col,{
      current_data <- table_data()
      if(as.numeric(input$del_col)<=ncol(as.data.frame(current_data))){
        current_data <- current_data[,-as.numeric(input$del_col)]
        table_data(as.data.frame(current_data))
      }else{
        showNotification("Bigger Than Column Numbers!")
      }
    })
    
    observeEvent(input$delete_row,{
      current_data <- table_data()
      if(as.numeric(input$del_row)<=nrow(as.data.frame(current_data))){
        current_data <- current_data[-as.numeric(input$del_row),]
        table_data(as.data.frame(current_data))
      }else{
        showNotification("Bigger Than Row Numbers!")
      }
    })
    
    observeEvent(input$table_1, {
      table_data(hot_to_r(input$table_1))
    })
    
    observeEvent(input$save_button,{
      save_data <- table_data()
      dbWriteTable(conn = db_1, input$df_name, save_data,overwrite = TRUE)
      showNotification("The data has been saved")
    })
    
  })
  
  
}
