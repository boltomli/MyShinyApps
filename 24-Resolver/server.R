shinyServer(
  function(input, output) {

    library(gtools)
    solver <- reactive({
      vals <- c(as.double(input$a),
                as.double(input$b),
                as.double(input$c),
                as.double(input$d))
      goal <- as.double(input$t)
      ops <- c(unlist(strsplit(input$o, "")))
      
      result <- "DONE"
      val.perms <- as.data.frame(t(
        permutations(length(vals), length(vals))))
      
      nop <- length(vals)-1
      op.perms <- as.data.frame(t(
        do.call(expand.grid,
                replicate(nop, list(ops)))))
      
      ord.perms <- as.data.frame(t(
        do.call(expand.grid,
                replicate(n <- nop, 1:((n <<- n-1)+1)))))
      
      for (val.perm in val.perms)
        for (op.perm in op.perms)
          for (ord.perm in ord.perms)
          {
            expr <- as.list(vals[val.perm])
            for (i in 1:nop) {
              expr[[ ord.perm[i] ]] <- call(as.character(op.perm[i]),
                                            expr[[ ord.perm[i]   ]],
                                            expr[[ ord.perm[i]+1 ]])
              expr <- expr[ -(ord.perm[i]+1) ]
            }
            if (identical(eval(expr[[1]]), goal))
            result = paste(c(deparse(expr[[1]]), "<br />", result))
          }
      
      return(result)})
    
    output$result <- renderUI({HTML(solver())})
  }
)