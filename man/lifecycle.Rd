% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lifecycle.R
\name{lifecycle}
\alias{lifecycle}
\title{Life cycle of the rlang package}
\description{
The rlang package is currently maturing. Unless otherwise stated,
this applies to all its exported functions. Maturing functions are
susceptible to API changes. Only use these in packages if you're
prepared to make changes as the package evolves. See sections below
for a list of functions marked as stable.

The documentation pages of retired functions contain life cycle
sections that explain the reasons for their retirements.
}
\section{Stable functions}{


TODO: Review all functions in rlang and mark stable ones as such.
\itemize{
\item \code{\link[=eval_tidy]{eval_tidy()}}
\item \link{!!}, \link{!!!}
\item \code{\link[=enquo]{enquo()}}, \code{\link[=quo]{quo()}}, \code{\link[=quos]{quos()}}
\item \code{\link[=enexpr]{enexpr()}}, \code{\link[=expr]{expr()}}, \code{\link[=exprs]{exprs()}}
\item \code{\link[=sym]{sym()}}, \code{\link[=syms]{syms()}}
\item \code{\link[=new_quosure]{new_quosure()}}, \code{\link[=is_quosure]{is_quosure()}}
\item \code{\link[=quo_get_expr]{quo_get_expr()}}, \code{\link[=quo_set_expr]{quo_set_expr()}}
\item \code{\link[=quo_get_env]{quo_get_env()}}, \code{\link[=quo_set_env]{quo_set_env()}}
\item \code{\link[=set_names]{set_names()}}, \code{\link[=names2]{names2()}}
\item \code{\link[=as_function]{as_function()}}
}
}

\section{Experimental functions}{

\itemize{
\item \code{\link[=type_of]{type_of()}}, \code{\link[=switch_type]{switch_type()}}, \code{\link[=coerce_type]{coerce_type()}}
\item \code{\link[=switch_class]{switch_class()}}, \code{\link[=coerce_class]{coerce_class()}}
\item \code{\link[=lang_type_of]{lang_type_of()}}, \code{\link[=switch_lang]{switch_lang()}}, \code{\link[=coerce_lang]{coerce_lang()}}
\item \code{\link[=set_attrs]{set_attrs()}}, \code{\link[=mut_attrs]{mut_attrs()}}
}
}

\section{Soft-deprecated functions and arguments}{


\strong{Retired in rlang 0.2.0:}
\itemize{
\item \code{\link[=UQ]{UQ()}}
\item \code{\link[=UQS]{UQS()}}
\item \code{\link[=lang_head]{lang_head()}}, \code{\link[=lang_tail]{lang_tail()}}
}

\strong{Renamed in rlang 0.2.0:}
\itemize{
\item \code{\link[=quo_expr]{quo_expr()}} => \code{\link[=quo_squash]{quo_squash()}}
\item \code{\link[=parse_quosure]{parse_quosure()}} => \code{\link[=parse_quo]{parse_quo()}}
\item \code{\link[=parse_quosures]{parse_quosures()}} => \code{\link[=parse_quos]{parse_quos()}}
\item \code{\link[=lang]{lang()}} => \code{\link[=call2]{call2()}}
\item \code{\link[=new_language]{new_language()}} => \code{\link[=call_node]{call_node()}}
\item \code{\link[=is_lang]{is_lang()}} => \code{\link[=is_call]{is_call()}}
\item \code{\link[=is_unary_lang]{is_unary_lang()}} => Use the \code{n} argument of \code{\link[=is_call]{is_call()}}
\item \code{\link[=is_binary_lang]{is_binary_lang()}} => Use the \code{n} argument of \code{\link[=is_call]{is_call()}}
\item \code{\link[=lang_modify]{lang_modify()}} => \code{\link[=call_modify]{call_modify()}}
\item \code{\link[=lang_standardise]{lang_standardise()}} => \code{\link[=call_standardise]{call_standardise()}}
\item \code{\link[=lang_fn]{lang_fn()}} => \code{\link[=call_fn]{call_fn()}}
\item \code{\link[=lang_name]{lang_name()}} => \code{\link[=call_name]{call_name()}}
\item \code{\link[=lang_args]{lang_args()}} => \code{\link[=call_args]{call_args()}}
\item \code{\link[=lang_args_names]{lang_args_names()}} => \code{\link[=call_args_names]{call_args_names()}}
}
}

\section{Deprecated functions and arguments}{


\strong{Retired in rlang 0.2.0:}
\itemize{
\item \code{\link[=UQE]{UQE()}}
\item \code{\link[=is_quosureish]{is_quosureish()}}, \code{\link[=as_quosureish]{as_quosureish()}}
}
}

\section{Defunct functions and arguments}{


\strong{Retired in rlang 0.2.0:}
\itemize{
\item \link[=quasiquotation]{:=}
}
}

