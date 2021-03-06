% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/eval-tidy.R
\name{eval_tidy}
\alias{eval_tidy}
\title{Evaluate an expression tidily}
\usage{
eval_tidy(expr, data = NULL, env = caller_env())
}
\arguments{
\item{expr}{An expression.}

\item{data}{A list (or data frame). This is passed to the
\code{\link[=as_dictionary]{as_dictionary()}} coercer, a generic used to transform an object
to a proper data source. If you want to make \code{eval_tidy()} work
for your own objects, you can define a method for this generic.}

\item{env}{The lexical environment in which to evaluate \code{expr}.}
}
\description{
\code{eval_tidy()} is a variant of \code{\link[base:eval]{base::eval()}} and \code{\link[=eval_bare]{eval_bare()}} that
powers the \href{http://rlang.tidyverse.org/articles/tidy-evaluation.html}{tidy evaluationframework}.
It evaluates \code{expr} in an \link[=as_overscope]{overscope} where the
special definitions enabling tidy evaluation are installed. This
enables the following features:
\itemize{
\item Overscoped data. You can supply a data frame or list of named
vectors to the \code{data} argument. The data contained in this list
has precedence over the objects in the contextual environment.
This is similar to how \code{\link[base:eval]{base::eval()}} accepts a list instead of
an environment.
\item Self-evaluation of quosures. Within the overscope, quosures act
like promises. When a quosure within an expression is evaluated,
it automatically invokes the quoted expression in the captured
environment (chained to the overscope). Note that quosures do not
always get evaluated because of lazy semantics, e.g. \code{TRUE || ~never_called}.
\item Pronouns. \code{eval_tidy()} installs the \code{.env} and \code{.data}
pronouns. \code{.env} contains a reference to the calling environment,
while \code{.data} refers to the \code{data} argument. These pronouns lets
you be explicit about where to find values and throw errors if
you try to access non-existent values.
}
}
\examples{
# Like base::eval() and eval_bare(), eval_tidy() evaluates quoted
# expressions:
expr <- expr(1 + 2 + 3)
eval_tidy(expr)

# Like base::eval(), it lets you supply overscoping data:
foo <- 1
bar <- 2
expr <- quote(list(foo, bar))
eval_tidy(expr, list(foo = 100))

# The main difference is that quosures self-evaluate within
# eval_tidy():
quo <- quo(1 + 2 + 3)
eval(quo)
eval_tidy(quo)

# Quosures also self-evaluate deep in an expression not just when
# directly supplied to eval_tidy():
expr <- expr(list(list(list(!! quo))))
eval(expr)
eval_tidy(expr)

# Self-evaluation of quosures is powerful because they
# automatically capture their enclosing environment:
foo <- function(x) {
  y <- 10
  quo(x + y)
}
f <- foo(1)

# This quosure refers to `x` and `y` from `foo()`'s evaluation
# frame. That's evaluated consistently by eval_tidy():
f
eval_tidy(f)


# Finally, eval_tidy() installs handy pronouns that allows users to
# be explicit about where to find symbols. If you supply data,
# eval_tidy() will look there first:
cyl <- 10
eval_tidy(quo(cyl), mtcars)

# To avoid ambiguity and be explicit, you can use the `.env` and
# `.data` pronouns:
eval_tidy(quo(.data$cyl), mtcars)
eval_tidy(quo(.env$cyl), mtcars)

# Note that instead of using `.env` it is often equivalent and may be
# preferred to unquote a value. There are two differences. First unquoting
# happens earlier, when the quosure is created. Secondly, subsetting `.env`
# with the `$` operator may be brittle because `$` does not look through
# the parents of the environment. Using `.env$name` in a magrittr pipeline
# is an instance where this poses problem, because the magrittr pipe
# currently (as of v1.5.0) evaluates its operands in a *child* of the
# current environment (this child environment is where it defines the
# pronoun `.`).

eval_tidy(quo(!! cyl), mtcars)  # 10
\dontrun{
  mtcars \%>\% eval_tidy(quo(!! cyl), .)  # 10
  mtcars \%>\% eval_tidy(quo(.env$cyl), .)  # NULL
}
}
\seealso{
\code{\link[=quo]{quo()}}, \link{quasiquotation}
}
