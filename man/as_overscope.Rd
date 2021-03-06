% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eval-tidy.R
\name{as_overscope}
\alias{as_overscope}
\alias{new_overscope}
\alias{overscope_eval_next}
\alias{overscope_clean}
\title{Create a dynamic scope for tidy evaluation}
\usage{
as_overscope(quo, data = NULL)

new_overscope(bottom, top = NULL, enclosure = base_env())

overscope_eval_next(overscope, quo, env = base_env())

overscope_clean(overscope)
}
\arguments{
\item{quo}{A \link{quosure}.}

\item{data}{Additional data to put in scope.}

\item{bottom}{This is the environment (or the bottom of a set of
environments) containing definitions for overscoped symbols. The
bottom environment typically contains pronouns (like \code{.data})
while its direct parents contain the overscoping bindings. The
last one of these parents is the \code{top}.}

\item{top}{The top environment of the overscope. During tidy
evaluation, this environment is chained and rechained to lexical
enclosures of self-evaluating formulas (or quosures). This is the
mechanism that ensures hygienic scoping: the bindings in the
overscope have precedence, but the bindings in the dynamic
environment where the tidy quotes were created in the first place
are in scope as well. If \code{NULL} (the default), \code{bottom} is also the top of
the overscope.}

\item{enclosure}{The default enclosure. After a quosure is done
self-evaluating, the overscope is rechained to the default
enclosure.}

\item{overscope}{A valid overscope containing bindings for \code{~},
\code{.top_env} and \code{_F} and whose parents contain overscoped bindings
for tidy evaluation.}

\item{env}{The lexical enclosure in case \code{quo} is not a validly
scoped quosure. This is the \link[=base_env]{base environment} by
default.}
}
\value{
An overscope environment.

A valid overscope: a child environment of \code{bottom}
containing the definitions enabling tidy evaluation
(self-evaluating quosures, formula-unguarding, ...).
}
\description{
Tidy evaluation works by rescoping a set of symbols (column names
of a data frame for example) to custom bindings. While doing this,
it is important to keep the original environment of captured
expressions in scope. The gist of tidy evaluation is to create a
dynamic scope containing custom bindings that should have
precedence when expressions are evaluated, and chain this scope
(set of linked environments) to the lexical enclosure of formulas
under evaluation. During tidy evaluation, formulas are transformed
into formula-promises and will self-evaluate their RHS as soon as
they are called. The main trick of tidyeval is to consistently
rechain the dynamic scope to the lexical enclosure of each tidy
quote under evaluation.
}
\details{
These functions are useful for embedding the tidy evaluation
framework in your own DSLs with your own evaluating function. They
let you create a custom dynamic scope. That is, a set of chained
environments whose bottom serves as evaluation environment and
whose top is rechained to the current lexical enclosure. But most
of the time, you can just use \code{\link[=eval_tidy_]{eval_tidy_()}} as it will take
care of installing the tidyeval components in your custom dynamic
scope.
\itemize{
\item \code{as_overscope()} is the function that powers \code{\link[=eval_tidy]{eval_tidy()}}. It
could be useful if you cannot use \code{eval_tidy()} for some reason,
but serves mostly as an example of how to build a dynamic scope
for tidy evaluation. In this case, it creates pronouns \code{.data}
and \code{.env} and buries all dynamic bindings from the supplied
\code{data} in new environments.
\item \code{new_overscope()} is called by \code{as_overscope()} and
\code{\link[=eval_tidy_]{eval_tidy_()}}. It installs the definitions for making
formulas self-evaluate and for formula-guards. It also installs
the pronoun \code{.top_env} that helps keeping track of the boundary
of the dynamic scope. If you evaluate a tidy quote with
\code{\link[=eval_tidy_]{eval_tidy_()}}, you don't need to use this.
\item \code{eval_tidy_()} is useful when you have several quosures to
evaluate in a same dynamic scope. That's a simple wrapper around
\code{\link[=eval_bare]{eval_bare()}} that updates the \code{.env} pronoun and rechains the
dynamic scope to the new formula enclosure to evaluate.
\item Once an expression has been evaluated in the tidy environment,
it's a good idea to clean up the definitions that make
self-evaluation of formulas possible \code{overscope_clean()}.
Otherwise your users may face unexpected results in specific
corner cases (e.g. when the evaluation environment is leaked, see
examples). Note that this function is automatically called by
\code{\link[=eval_tidy_]{eval_tidy_()}}.
}
}
\examples{
# Evaluating in a tidy evaluation environment enables all tidy
# features:
expr <- quote(list(.data$cyl, ~letters))
f <- as_quosure(expr)
overscope <- as_overscope(f, data = mtcars)
overscope_eval_next(overscope, f)

# However you need to clean up the environment after evaluation.
overscope_clean(overscope)
}
