#!/usr/bin/env elvish

use path

var fname = $args[0]
var ext = (path:ext $fname)

if (has-value [.png .jpeg .jpg .bmp] $ext) {
  dog $fname
} else {
  bat --plain --color=always --theme=ansi $fname
}
