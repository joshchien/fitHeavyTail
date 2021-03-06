
EstimateMoments_MedianKendalltau <- function(X) {
  #first, compute (and remove mean)
  #mu <- colMeans(X)
  mu <- apply(X, 2, median)
  X <- sweep(X, 2, FUN="-", STATS=mu)

  #second, compute correlation matrix
  Ktau <- pcaPP::cor.fk(X)  #faster algorithm than the base cor(X, method="kendall")
  C_Ktau <- sin(pi/2*Ktau)

  #finally, recover covariance from correlation matrix
  sigma <- sqrt( apply(X, 2, var) )
  R_Ktau <- sigma * C_Ktau * rep(sigma, each = ncol(X))  # diag(sigma) %*% C_Ktau %*% diag(sigma)

  return( list(mu=mu, cov=R_Ktau) )
}


EstimateMoments_MinskerWei <- function(X) {
  #error control
  if(anyNA(X)) stop("This function cannot handle NAs.")
  X <- as.matrix(X)
  T <- nrow(X)
  N <- ncol(X)
  if(T==1) stop("Only T=1 sample!!")
  if(N==1) stop("Data is univariate!")

  #first, compute (and remove mean)
  beta <- 2
  k <- min(floor(3.5*beta)+1, floor(T/2))
  mu <- Gmedian_of_means(X, k=k)
  X_ <- X - rep(mu, each=T)

  #second, estimate the covariance matrix
  #row_norms2 <- apply(X_^2, 1, "sum")
  #S0 <- (1/T) * crossprod( sqrt(row_norms2)*X_ )
  #sigma02 <- norm(S0)
  sigma2 <- 1e5
  theta <- (1/sqrt(sigma2))*sqrt(beta/T)
  psi <- function(x) { min(1, abs(x))*sign(x) }
  row_norms2 <- apply(X_^2, 1, "sum")
  weights <- sapply(theta*row_norms2, psi) / row_norms2 / theta
  Sigma <- (1/T) * crossprod( sqrt(weights)*X_ )  # (1/T) * t(X_) %*% diag(weights) %*% X_

  return( list(mu=mu, cov=Sigma) )
}
