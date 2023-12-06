package main

import "testing"

const sample = `Enumerating objects: 7, done.
Counting objects: 100% (7/7), done.
Delta compression using up to 10 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 2.53 KiB | 2.53 MiB/s, done.
Total 4 (delta 3), reused 0 (delta 0), pack-reused 0
remote:
remote: To create a merge request for some-fancy-branch, visit:
remote:   https://gitlab.com/some-repo/-/merge_requests/new?merge_request%5Bsource_branch%5D=some-fancy-branch
remote:
To gitlab.com:some-repo.git
 * [new branch]      some-fancy-branch -> some-fancy-branch
branch 'some-fancy-branch' set up to track 'origin/some-fancy-branch'.
`

func TestMain(t *testing.T) {
	got, err := parseURL(sample)
	if err != nil {
		t.Errorf("parseURL(sample) wanted no err, got = %q", err)
	}

	want := "https://gitlab.com/some-repo/-/merge_requests/new?merge_request%5Bsource_branch%5D=some-fancy-branch"
	if got != want {
		t.Errorf("parseURL(sample) wanted = %q, got = %q", want, got)
	}
}
