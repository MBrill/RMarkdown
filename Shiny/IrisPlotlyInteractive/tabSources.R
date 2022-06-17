IDSRC <- "sources"

uiSources <- function(id = IDSRC){
  tagList(
    p(
      a("https://upload.wikimedia.org/wikipedia/commons/5/5e/Logo_of_Hochschule_Kaiserslautern.png", align = "center"),
      br(),
      a("https://www.kaggle.com/datasets/uciml/iris")
    )

  )
}

serverSources <- function(id = IDSRC){
  moduleServer(id, function(input, output, session) {

  })
}
