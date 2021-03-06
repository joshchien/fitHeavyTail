% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fit_mvt.R
\name{fit_mvt}
\alias{fit_mvt}
\title{Estimate parameters of a multivariate Student's t distribution to fit data}
\usage{
fit_mvt(
  X,
  na_rm = TRUE,
  nu = c("kurtosis", "MLE-diag", "MLE-diag-resampled", "iterative"),
  nu_iterative_method = c("ECME-diag", "ECME", "ECM", "ECME-cov", "trace-fitting"),
  initial = NULL,
  factors = ncol(X),
  max_iter = 100,
  ptol = 0.001,
  ftol = Inf,
  return_iterates = FALSE,
  verbose = FALSE
)
}
\arguments{
\item{X}{Data matrix containing the multivariate time series (each column is one time series).}

\item{na_rm}{Logical value indicating whether to remove observations with some NAs (default) or not, in which
case they will be imputed at a higher computational cost.}

\item{nu}{Degrees of freedom of the \eqn{t} distribution. Either a number (\code{>2}) or a string indicating the
method to compute it:
\itemize{\item{\code{"kurtosis"}: based on the kurtosis obtained from the sampled moments (default method);}
         \item{\code{"MLE-diag"}: based on the MLE assuming a diagonal sample covariance;}
         \item{\code{"MLE-diag-resampled"}: method "MLE-diag" resampled for better stability;}
         \item{\code{"iterative"}: iterative estimation with the rest of the parameters via the EM algorithm.}}}

\item{nu_iterative_method}{String indicating the method for iteratively estimating \code{nu} (in case \code{nu = "iterative"}):
\itemize{\item{\code{"ECM"}: maximization of the Q function;}
         \item{\code{"ECME"}: maximization of the log-likelihood function;}
         \item{\code{"ECME-diag"}: maximization of the log-likelihood function assuming
                                   a digonal scatter matrix (default method).}}
This argument is used only when there are no NAs in the data and no factor model is chosen.}

\item{initial}{List of initial values of the parameters for the iterative EM estimation method (in case \code{nu = "iterative"}).
Possible elements include:
\itemize{\item{\code{mu}: default is the data sample mean,}
         \item{\code{cov}: default is the data sample covariance matrix,}
         \item{\code{scatter}: default follows from the scaled sample covariance matrix,}
         \item{\code{nu}: can take the same values as argument \code{nu}, default is \code{4},}
         \item{\code{B}: default is the top eigenvectors of \code{initial$cov}
                                   multiplied by the sqrt of the eigenvalues,}
         \item{\code{psi}: default is
                          \code{diag(initial$cov - initial$B \%*\% t(initial$B)).}}}}

\item{factors}{Integer indicating number of factors (default is \code{ncol(X)}, so no factor model assumption).}

\item{max_iter}{Integer indicating the maximum number of iterations for the iterative estimation
method (default is \code{100}).}

\item{ptol}{Positive number indicating the relative tolerance for the change of the variables
to determine convergence of the iterative method (default is \code{1e-3}).}

\item{ftol}{Positive number indicating the relative tolerance for the change of the log-likelihood
value to determine convergence of the iterative method (default is \code{Inf}, so it is
not active). Note that using this argument might have a computational cost as a convergence
criterion due to the computation of the log-likelihood (especially when \code{X} is high-dimensional).}

\item{return_iterates}{Logical value indicating whether to record the values of the parameters (and possibly the
log-likelihood if \code{ftol < Inf}) at each iteration (default is \code{FALSE}).}

\item{verbose}{Logical value indicating whether to allow the function to print messages (default is \code{FALSE}).}
}
\value{
A list containing possibly the following elements:
        \item{\code{mu}}{Mean vector estimate.}
        \item{\code{cov}}{Covariance matrix estimate.}
        \item{\code{scatter}}{Scatter matrix estimate.}
        \item{\code{nu}}{Degrees of freedom estimate.}
        \item{\code{converged}}{Boolean denoting whether the algorithm has converged (\code{TRUE}) or the maximum number
                                of iterations \code{max_iter} has been reached (\code{FALSE}).}
        \item{\code{num_iterations}}{Number of iterations executed.}
        \item{\code{cpu_time}}{Elapsed CPU time.}
        \item{\code{B}}{Factor model loading matrix estimate according to \code{cov = (B \%*\% t(B) + diag(psi)}
                        (only if factor model requested).}
        \item{\code{psi}}{Factor model idiosynchratic variances estimates according to \code{cov = (B \%*\% t(B) + diag(psi)}
                          (only if factor model requested).}
        \item{\code{log_likelihood}}{Value of log-likelihood after converge of the estimation algorithm (if \code{ftol < Inf}).}
        \item{\code{iterates_record}}{Iterates of the parameters (\code{mu}, \code{scatter}, \code{nu},
                                      and possibly \code{log_likelihood} (if \code{ftol < Inf})) along the iterations
                                      (if \code{return_iterates = TRUE}).}
}
\description{
Estimate parameters of a multivariate Student's t distribution to fit data,
namely, the mean vector, the covariance matrix, the scatter matrix, and the degrees of freedom.
The data can contain missing values denoted by NAs.
It can also consider a factor model structure on the covariance matrix.
The estimation is based on the maximum likelihood estimation (MLE) and the algorithm is
obtained from the expectation-maximization (EM) method.
}
\details{
This function estimates the parameters of a multivariate Student's t distribution (\code{mu},
         \code{cov}, \code{scatter}, and \code{nu}) to fit the data via the expectation–maximization (EM) algorithm.
         The data matrix \code{X} can contain missing values denoted by NAs.
         The estimation of \code{nu} if very flexible: it can be directly passed as an argument (without being estimated),
         it can be estimated with several one-shot methods (namely, \code{"kurtosis"}, \code{"MLE-diag"},
         \code{"MLE-diag-resampled"}), and it can also be iteratively estimated with the other parameters via the EM
         algorithm.
}
\examples{
library(mvtnorm)       # to generate heavy-tailed data
library(fitHeavyTail)

X <- rmvt(n = 1000, df = 6)  # generate Student's t data
fit_mvt(X)

}
\references{
Chuanhai Liu and Donald B. Rubin, “ML estimation of the t-distribution using EM and its extensions, ECM and ECME,”
Statistica Sinica (5), pp. 19-39, 1995.

Rui Zhou, Junyan Liu, Sandeep Kumar, and Daniel P. Palomar, "Robust factor analysis parameter estimation,"
Lecture Notes in Computer Science (LNCS), 2019. <https://arxiv.org/abs/1909.12530>
}
\seealso{
\code{\link{fit_Tyler}} and \code{\link{fit_Cauchy}}
}
\author{
Daniel P. Palomar and Rui Zhou
}
