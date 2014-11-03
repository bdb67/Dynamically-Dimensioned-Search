# Returns numIter length list of entries to be peturbed
probPeturb<-function(x, numIter){
  # Input is xBounds & numIter.  
  # Returns numIter entry list with the indices which will be peturbed
  xDims<-nrow(x)
  probabilityVector<-1-log(1:numIter)/log(numIter)
  peturbIdx<-apply(matrix(unlist(lapply(probabilityVector, function(x) as.logical(rbinom(xDims, 1, x)))), byrow=TRUE, ncol=xDims), 1, which)
  return(peturbIdx)
}

dds<-function(xBounds.df, numIter, OBJFUN){
  # INPUTS:
  # xBounds.df must be a dataframe with 1st column as minimum, 2nd column as maximum
  # numIter is an integer
  # OBJFUN is a function which returns a scalar value, for which we are trying to minimize.  
  #
  # OUTPUTS:
  # outputs.df is a two entry list, containing x_best and y_best, as they evolve over numIter iterations.
  
  # Format xBounds.df colnames
  colnames(xBounds.df)<-c("min", "max")
  # Generate initial first guess
  #xBounds.df<-data.frame(col1 = rep(10,10), col2=rep(100, 10))
  x_init<-apply(xBounds.df, 1, function(x) runif(1, x[1], x[2]))
  x_best<-data.frame(x=x_init)
  
  # Evaluate first cost function
  y_init<-OBJFUN(x_init)
  y_best<-y_init
  
  r= 0.2
  # Select which entry to peturb at each iteration
  
  peturbIdx<-probPeturb(xBounds.df, numIter)
  # Peturb each entry by N(0,1)*r(x_max - x_min) reflecting if @ boundaries
  sigma<-xBounds.df$max - xBounds.df$min


  for (i in 2:numIter){
    # Set up test x
    x_test<-as.matrix(x_best[i-1])
  
    # Get entries we will peturb
    idx<-peturbIdx[[i]]
  
    # Initialize vector of peturbations initially zeros with same length of x so we will add this vector to peturb x
    peturbVec<-rep(0, length(x_test))
    # Generate the required number of random normal variables
    N<-rnorm(length(x_test), mean=0, sd=1)
  
    # Set up vector of peturbations
    peturbVec[idx]<-r*N[idx]*sigma[idx]
  
    # Temporary resulting x value if we peturbed it
    testPeturb<-x_test + peturbVec  
    # Find the values in testPeturb that have boundary violations.  Store the indices in boundaryViolationsIdx
    boundaryViolationIdx<-which(testPeturb<xBounds.df$min | testPeturb > xBounds.df$max)
  
    # Reset those violated indices to the opposite peturbation direction
    peturbVec[boundaryViolationIdx]<-(-1*r*N[boundaryViolationIdx]*sigma[boundaryViolationIdx])
  
    # Find values still at violations of min or max and set them to the minimum or maximum values
    testPeturb<-x_test + peturbVec
    minViolationIdx<-which(testPeturb<xBounds.df$min)
    maxViolationIdx<-which(testPeturb>xBounds.df$max)
    testPeturb[minViolationIdx]<-xBounds.df$min[minViolationIdx]
    testPeturb[maxViolationIdx]<-xBounds.df$max[maxViolationIdx]
  
    # Peturb the test vector
    x_test<-x_test + peturbVec  
    # Evaluate objective function
    y_test<-OBJFUN(x_test)
  
    y_best[i]<-min(c(y_test, y_best[i-1]))
    bestIdx<-which.min(c(y_test, y_best[i-1]))
    x_choices<-cbind(x_test, as.matrix(x_best[i-1]))
    x_best[i]<-x_choices[,bestIdx]
}
  
  output.list<-list(t(x_best), y_best) 
  return(output.list)
}
