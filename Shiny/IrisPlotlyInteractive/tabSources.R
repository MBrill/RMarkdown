IDSRC <- "sources"

uiSources <- function(id = IDSRC){
  tagList(
    p(
      HTML('<center><h2>Sources</h2></center>'),
      br(),
      HTML('<center><h3><a href="https://upload.wikimedia.org/wikipedia/commons/5/5e/Logo_of_Hochschule_Kaiserslautern.png" target="_blank">HS-KL Logo</a></h3></center>'),
      br(),
      HTML('<center><h3><a href="https://www.kaggle.com/datasets/uciml/iris" target="_blank">Iris Dataset Information</a></h3></center>'),
      br(),
      HTML('<center><h3><a href="https://www.oreilly.com/library/view/python-artificial-intelligence/9781789539462/assets/462dc4fa-fd62-4539-8599-ac80a441382c.png" target="_blank">Picture: Measurements</a></h3></center>'),
      br(),
      HTML('<center><h3><a href="https://www.embedded-robotics.com/wp-content/uploads/2022/01/Iris-Dataset-Classification.png" target="_blank">Picture: Species</a></h3></center>'),
      br(),
      HTML('<center><h3><a href="https://github.com/rstudio/shinythemes/blob/main/R/shinytheme.R" target="_blank">Github: Shiny themes</a></h3></center>'),
    )

  )
}

serverSources <- function(id = IDSRC){
  moduleServer(id, function(input, output, session) {

  })
}
