#' Helpers for pairlist and language nodes
#'
#' @description
#'
#' Like any [parse tree](https://en.wikipedia.org/wiki/Parse_tree), R
#' expressions are structured as trees of nodes. Each node has two
#' components: the head and the tail (though technically there is
#' actually a third component for argument names, see details). Due to
#' R's [lisp roots](https://en.wikipedia.org/wiki/CAR_and_CDR), the
#' head of a node (or cons cell) is called the CAR and the tail is
#' called the CDR (pronounced _car_ and _cou-der_). While R's ordinary
#' subsetting operators have builtin support for indexing into these
#' trees and replacing elements, it is sometimes useful to manipulate
#' the nodes more directly. This is the purpose of functions like
#' `node_car()` and `mut_node_car()`. They are particularly useful to
#' prototype algorithms for your C-level functions.
#'
#' * `node_car()` and `mut_node_car()` access or change the head of a node.
#'
#' * `node_cdr()` and `mut_node_cdr()` access or change the tail of a node.
#'
#' * Variants like `node_caar()` or `mut_node_cdar()` deal with the
#'   CAR of the CAR of a node or the CDR of the CAR of a node
#'   respectively. The letters in the middle indicate the type (CAR or
#'   CDR) and order of access.
#'
#' * `node_tag()` and `mut_node_tag()` access or change the tag of a
#'   node. This is meant for argument names and should only contain
#'   symbols (not strings).
#'
#' * `node()` creates a new node from two components.
#'
#' @details
#'
#' R has two types of nodes to represent parse trees: language nodes,
#' which represent function calls, and pairlist nodes, which represent
#' arguments in a function call. These are the exact same data
#' structures with a different name. This distinction is helpful for
#' parsing the tree: the top-level node of a function call always has
#' _language_ type while its arguments have _pairlist_ type.
#'
#' Note that it is risky to manipulate calls at the node level. First,
#' the calls are changed inplace. This is unlike base R operators
#' which create a new copy of the language tree for each modification.
#' To make sure modifying a language object does not produce
#' side-effects, rlang exports the `duplicate()` function to create
#' deep copy (or optionally a shallow copy, i.e. only the top-level
#' node is copied). The second danger is that R expects language trees
#' to be structured as a `NULL`-terminated list. The CAR of a node is
#' a data slot and can contain anything, including another node (which
#' is how you form trees, as opposed to mere linked lists). On the
#' other hand, the CDR has to be either another node, or `NULL`. If it
#' is terminated by anything other than the `NULL` object, many R
#' commands will crash, including functions like `str()`. It is up to
#' you to ensure that the language list you have modified is
#' `NULL`-terminated.
#'
#' Finally, all nodes can contain metadata in the TAG slot. This is
#' meant for argument names and R expects tags to contain a symbol
#' (not a string).
#'
#' @param x A language or pairlist node. Note that these functions are
#'   barebones and do not perform any type checking.
#' @param newcar,newcdr The new CAR or CDR for the node. These can be
#'   any R objects.
#' @param newtag The new tag for the node. This should be a symbol.
#' @return Setters like `mut_node_car()` invisibly return `x` modified
#'   in place. Getters return the requested node component.
#' @seealso [duplicate()] for creating copy-safe objects and
#'   [base::pairlist()] for an easier way of creating a linked list of
#'   nodes.
#' @examples
#' # Changing a node component happens in place and can have side
#' # effects. Let's create a language object and a copy of it:
#' lang <- quote(foo(bar))
#' copy <- lang
#'
#' # Using R's builtin operators to change the language tree does not
#' # create side effects:
#' copy[[2]] <- quote(baz)
#' copy
#' lang
#'
#' # On the other hand, the CAR and CDR operators operate in-place. Let's
#' # create new objects since the previous examples triggered a copy:
#' lang <- quote(foo(bar))
#' copy <- lang
#'
#' # Now we change the argument pairlist of `copy`, making sure the new
#' # arguments are NULL-terminated:
#' mut_node_cdr(copy, node(quote(BAZ), NULL))
#'
#' # Or equivalently:
#' mut_node_cdr(copy, pairlist(quote(BAZ)))
#' copy
#'
#' # The original object has been changed in place:
#' lang
#' @name pairlist
NULL

#' @rdname pairlist
#' @export
node <- function(newcar, newcdr) {
  .Call(rlang_new_node, newcar, newcdr)
}

#' @rdname pairlist
#' @export
node_car <- function(x) {
  .Call(rlang_node_car, x)
}
#' @rdname pairlist
#' @export
node_cdr <- function(x) {
  .Call(rlang_node_cdr, x)
}
#' @rdname pairlist
#' @export
node_caar <- function(x) {
  .Call(rlang_node_caar, x)
}
#' @rdname pairlist
#' @export
node_cadr <- function(x) {
  .Call(rlang_node_cadr, x)
}
#' @rdname pairlist
#' @export
node_cdar <- function(x) {
  .Call(rlang_node_cdar, x)
}
#' @rdname pairlist
#' @export
node_cddr <- function(x) {
  .Call(rlang_node_cddr, x)
}

#' @rdname pairlist
#' @export
mut_node_car <- function(x, newcar) {
  invisible(.Call(rlang_node_poke_car, x, newcar))
}
#' @rdname pairlist
#' @export
mut_node_cdr <- function(x, newcdr) {
  invisible(.Call(rlang_node_poke_cdr, x, newcdr))
}
#' @rdname pairlist
#' @export
mut_node_caar <- function(x, newcar) {
  invisible(.Call(rlang_node_poke_caar, x, newcar))
}
#' @rdname pairlist
#' @export
mut_node_cadr <- function(x, newcar) {
  invisible(.Call(rlang_node_poke_cadr, x, newcar))
}
#' @rdname pairlist
#' @export
mut_node_cdar <- function(x, newcdr) {
  invisible(.Call(rlang_node_poke_cdar, x, newcdr))
}
#' @rdname pairlist
#' @export
mut_node_cddr <- function(x, newcdr) {
  invisible(.Call(rlang_node_poke_cddr, x, newcdr))
}

#' @rdname pairlist
#' @export
node_tag <- function(x) {
  .Call(rlang_node_tag, x)
}
#' @rdname pairlist
#' @export
mut_node_tag <- function(x, newtag) {
  invisible(.Call(rlang_node_poke_tag, x, newtag))
}

#' Coerce to pairlist
#'
#' This transforms vector objects to a linked pairlist of nodes. See
#' [pairlist] for information about the pairlist type.
#'
#' @param x An object to coerce.
#' @seealso [pairlist]
#' @export
as_pairlist <- function(x) {
  if (!is_vector(x)) {
    abort_coercion(x, "pairlist")
  }
  as.vector(x, "pairlist")
}

#' Is object a node or pairlist?
#'
#' @description
#'
#' * `is_pairlist()` checks that `x` has type `pairlist`.
#'
#' * `is_node()` checks that `x` has type `pairlist` or `language`.
#'    It tests whether `x` is a node that has a CAR and a CDR,
#'    including callable nodes (language objects).
#'
#' * `is_node_list()` checks that `x` has type `pairlist` or `NULL`.
#'   `NULL` is the empty node list.
#'
#' @param x Object to test.
#' @seealso [is_call()] tests for language nodes.
#' @export
is_pairlist <- function(x) {
  typeof(x) == "pairlist"
}
#' @rdname is_pairlist
#' @export
is_node <- function(x) {
  typeof(x) %in% c("pairlist", "language")
}
#' @rdname is_pairlist
#' @export
is_node_list <- function(x) {
  typeof(x) %in% c("pairlist", "NULL")
}


#' Duplicate an R object
#'
#' In R semantics, objects are copied by value. This means that
#' modifying the copy leaves the original object intact. Since,
#' copying data in memory is an expensive operation, copies in R are
#' as lazy as possible. They only happen when the new object is
#' actually modified. However, some operations (like [mut_node_car()]
#' or [mut_node_cdr()]) do not support copy-on-write. In those cases,
#' it is necessary to duplicate the object manually in order to
#' preserve copy-by-value semantics.
#'
#' Some objects are not duplicable, like symbols and environments.
#' `duplicate()` returns its input for these unique objects.
#'
#' @param x Any R object. However, uncopyable types like symbols and
#'   environments are returned as is (just like with `<-`).
#' @param shallow This is relevant for recursive data structures like
#'   lists, calls and pairlists. A shallow copy only duplicates the
#'   top-level data structure. The objects contained in the list are
#'   still the same.
#' @seealso pairlist
#' @export
duplicate <- function(x, shallow = FALSE) {
  .Call(rlang_duplicate, x, shallow)
}

# Shallow copy of node trees
node_tree_clone <- function(x) {
  .Call(rlang_node_tree_clone, x);
}

node_walk <- function(.x, .f, ...) {
  cur <- .x
  while (!is.null(cur)) {
    .f(cur, ...)
    cur <- node_cdr(cur)
  }
  NULL
}
node_walk_nonnull <- function(.x, .f, ...) {
  cur <- .x
  out <- NULL
  while (!is.null(cur) && is.null(out)) {
    out <- .f(cur, ...)
    cur <- node_cdr(cur)
  }
  out
}
node_walk_last <- function(.x, .f, ...) {
  cur <- .x
  while (!is.null(node_cdr(cur))) {
    cur <- node_cdr(cur)
  }
  .f(cur, ...)
}

node_append <- function(.x, .y) {
  node_walk_last(.x, function(l) mut_node_cdr(l, .y))
  .x
}


# FIXME: Deprecate `mut_` variants properly with lifecycle package and
# replace them with these:
node_poke_car <- mut_node_car
node_poke_cdr <- mut_node_cdr
node_poke_caar <- mut_node_caar
node_poke_cadr <- mut_node_cadr
node_poke_cdar <- mut_node_cdar
node_poke_cddr <- mut_node_cddr
node_poke_tag <- mut_node_tag


#' Create a new call from components
#'
#' @param car The head of the call. It should be a
#'   [callable][is_callable] object: a symbol, call, or literal
#'   function.
#' @param cdr The tail of the call, i.e. a [node list][pairlist] of
#'   arguments.
#'
#' @keywords internal
#' @export
call_node <- function(car, cdr = NULL) {
  .Call(rlang_new_call, car, cdr)
}
