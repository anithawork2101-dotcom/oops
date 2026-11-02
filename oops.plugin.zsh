# oops: zsh plugin file, for plugin managers (zinit, antidote, zgenom,
# Oh My Zsh custom plugins, ...). It runs oops from this clone, so no gem
# install is needed, only Ruby 3.3 or later on PATH when it is loaded.
# Load it without deferring (no zinit `wait` / turbo): the shell is started
# again under `oops record`, which is best done before the first prompt.

# Find this file even when the plugin manager evals it (Zsh Plugin Standard).
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

() {
  local exe_dir=${1:A:h}/exe snippet
  # The recorded shell loads this again with PATH inherited; add exe/ once.
  path=("$exe_dir" ${path:#$exe_dir})
  # A Ruby too old for oops fails here, and nothing runs: the shell starts
  # as usual, just without recording.
  if snippet=$("$exe_dir/oops" init zsh 2>/dev/null) && [[ -n "$snippet" ]]; then
    eval "$snippet"
  else
    print -ru2 -- "oops: $exe_dir/oops init zsh failed (oops needs Ruby 3.3 or later); recording disabled"
  fi
} "$0"
