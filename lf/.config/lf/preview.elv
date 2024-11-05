#!/usr/bin/env elvish

use path

var fname = $args[0]
bat --plain $fname
