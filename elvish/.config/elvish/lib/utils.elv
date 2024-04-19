fn do-in-dir {|dir next~|
  var current-dir = (pwd)
  try {
    cd $dir
    next
  } finally {
    cd $current-dir
  }
}

fn open-url {|in|
	use str
	for f [(str:fields $in)] {
		if (str:has-prefix $f 'https://') {
			open $f
			return
		}
	}
}

fn ssh-to-https {|in|
	use str
	str:replace ':' '/' $in | str:replace 'git@' 'https://' (all) | str:replace '.git' '' (all)
}
