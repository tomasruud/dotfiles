fn sync-paths {||
	use path
	use store

	for dir [(find ~/work/a2755 -name .git -type d -prune)] { 
		store:add-dir (path:dir $dir)
	}
}
