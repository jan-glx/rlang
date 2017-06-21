#include "rlang.h"

SEXP r_eval(SEXP expr, SEXP env) {
  return Rf_eval(expr, env);
}

static
SEXP base_tilde_eval(SEXP tilde, SEXP env) {
  if (r_f_has_env(tilde))
    return tilde;

  static SEXP tilde_sym;
  static SEXP tilde_prim;
  if (!tilde_sym)
    tilde_sym = r_sym("~");
  if (!tilde_prim)
    tilde_prim = base_obj("~");

  // Inline the base primitive because overscopes override `~` to make
  // quosures self-evaluate
  tilde = PROTECT(r_new_language(tilde_prim, r_node_cdr(tilde)));
  tilde = PROTECT(r_eval(tilde, env));

  // Change it back because the result still has the primitive inlined
  r_mut_node_car(tilde, tilde_sym);

  UNPROTECT(2);
  return tilde;
}

SEXP rlang_tilde_eval(SEXP tilde, SEXP overscope, SEXP overscope_top) {
  if (!r_inherits(tilde, "quosure"))
    return base_tilde_eval(tilde, overscope);

  if (r_quo_is_missing(tilde))
    return(r_missing_arg());

  SEXP env = r_f_env(tilde);
  SEXP prev_env = r_env_get(overscope, r_sym(".env"));
  if (r_is_null(env))
    env = prev_env;

  // Swap enclosures temporarily by rechaining the top of the dynamic
  // scope to the enclosure of the new formula, if it has one
  r_mut_env_parent(overscope_top, env);

  SEXP out = PROTECT(r_eval(r_f_rhs(tilde), overscope));
  r_mut_env_parent(overscope_top, prev_env);

  UNPROTECT(1);
  return out;
}
