use path
use str

fn -prompt-dir {
	try {
		# Attempt to find a git repo root
		var git-root = (git rev-parse --show-toplevel 2>/dev/null)
		var pre = (path:dir $git-root)
		put (str:trim-prefix $pwd $pre/)
	} catch err {
		# Probably not a repo
		put (tilde-abbr $pwd)
	}
}

set edit:rprompt = (constantly (whoami)@(hostname))

set edit:prompt = {
	put (-prompt-dir) '$ '
}
