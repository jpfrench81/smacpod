# Non-rejection envelopes for log ratio of spatial
# densities.
#
# \code{nrenv} determines non-rejection envelopes for the
# log ratio of spatial densities of cases and controls.
# Specifically, the function identifies where the observed
# log ratio of spatial densities exceeds what is expected
# under the random labeling hypothesis.  Results can be
# easily plotted using the contour or image functions.
#
# \code{alternative ="two.sided"} identifies locations where
# the observed log ratio of spatial densities is below and
# above, respectively, the (1-level)/2 and 1 - (1-level)/2
# quantiles of log ratios of spatial densities simulated
# under the random labeling hypothesis.  "greater" finds
# where the observed ratio exceeds the "level" quantile.
# "lower" finds where the observed ratio exceeds the 1 -
# level quantile.
#
# The \code{z} argument of the \code{\link[spatstat]{im}}
# returns has a -1 for locations where the observed log
# ratio of spatial densities is below the non-rejection
# envelope, a 0 for locations within the non-rejection envelope,
# and a 1 for locations where the log ratio of spatial
# densities exceeds the non-rejection envelope.
#
# @param object An \code{im} object from the \code{logrr}
#   function.
# @param level Confidence level.  Should be a number between
#   0 and 1.  Default is 0.95.
# @param alternative Default is "two.sided".  Can also be
#   "greater" or "lower".
#
# @return Returns a \code{link[spatstat]{im}} object
#   representing a two-dimensional pixel image.
# @author Joshua French
# @references Waller, L.A. and Gotway, C.A. (2005).  Applied
#   Spatial Statistics for Public Health Data.  Hoboken, NJ:
#   Wiley.
nrenv = function(object, level = 0.90, alternative = "two.sided") {
  alpha = 1 - level
  alternative = match.arg(alternative, choices = c("two.sided", "lower", "upper"))
  if (alternative == "two.sided")   {
    tol = apply(object$simr, c(1, 2), stats::quantile, 
                prob = c(alpha/2, 1 - alpha/2), na.rm = TRUE)
  } else if (alternative == "lower") {
    tol = apply(object$simr, c(1, 2), stats::quantile, 
                prob = c(1 - level, 1), na.rm = TRUE)
  } else {
    tol = apply(object$simr, c(1, 2), stats::quantile, 
                prob = c(0, level), na.rm = TRUE)
  }
  # 1 if it's above the upper non-rejection limit
  above = (object$simr[,,1] > tol[2,,]) + 0
  # -1 if it's below the lower non-rejection limit
  below = -1*(object$simr[,,1] < tol[1,,])
  # returns -1 if below, 0 if between, 1 if above non-rejection limits
  both = above + below
  return(spatstat::im(mat = both, xcol = object$xcol, yrow = object$yrow))
}