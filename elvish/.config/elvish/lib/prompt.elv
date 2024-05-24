fn right {
  if (not (has-env SSH_CONNECTION)) {
    return
  }

  if (eq (get-env SSH_CONNECTION) "") {
    return
  }

  use platform

  put (whoami) @ (platform:hostname &strip-domain=$true)
}

fn left {

}
