---
name: gitlab
description:
  Interact with GitLab using the glab CLI. Manage merge requests, issues,
  CI/CD pipelines, and repositories. Use when the user asks about MRs,
  GitLab issues, pipelines, CI jobs, or GitLab projects.
---

# GitLab

Use `glab` via bash to interact with GitLab. Most commands auto-detect the
repository from the current git directory. Use `-R OWNER/REPO` to target a
different project.

Run `glab <command> --help` for full flag details on any command.

## Merge Requests

### List MRs

```bash
glab mr list
glab mr list --state merged
glab mr list --label "bug" --assignee @me
glab mr list --search "query"
```

### View an MR

```bash
glab mr view 123
glab mr view 123 --web          # Open in browser
glab mr view branch-name
```

### Create an MR

```bash
glab mr create --fill                              # Auto-fill from commits
glab mr create --title "Title" --description "Desc"
glab mr create --fill --label bugfix --assignee @me
glab mr create --target-branch main --draft
```

### Update an MR

```bash
glab mr update 123 --title "New title"
glab mr update 123 --add-label "review" --remove-label "wip"
glab mr update 123 --assignee "username"
glab mr update 123 --ready                         # Mark as ready (undraft)
```

### MR actions

```bash
glab mr merge 123                    # Merge
glab mr merge 123 --squash           # Squash merge
glab mr approve 123                  # Approve
glab mr revoke 123                   # Revoke approval
glab mr close 123                    # Close
glab mr reopen 123                   # Reopen
glab mr rebase 123                   # Rebase
glab mr checkout 123                 # Check out locally
glab mr diff 123                     # View diff
```

### MR comments

```bash
# View all comments on an MR
glab mr view 123 --comments                # Show MR with all comments
glab api "projects/:id/merge_requests/123/notes" | jq '.[] | {author: .author.name, body: .body, created_at: .created_at}'

# Add a comment to an MR
glab mr note 123 -m "Comment text"

# Add a comment and resolve a discussion
glab mr note 123 -m "Comment text" --resolve-discussion
```

## Issues

### List issues

```bash
glab issue list
glab issue list --label "bug" --assignee @me
glab issue list --milestone "v1.0"
glab issue list --search "query"
```

### View an issue

```bash
glab issue view 42
glab issue view 42 --web
```

### Create an issue

```bash
glab issue create --title "Title" --description "Details"
glab issue create --title "Bug" --label "bug" --assignee "user"
```

### Update an issue

```bash
glab issue update 42 --title "New title"
glab issue update 42 --add-label "priority::high"
glab issue update 42 --assignee "user"
```

### Issue actions

```bash
glab issue close 42
glab issue reopen 42
glab issue note 42 -m "Comment text"
```

## CI/CD Pipelines

### View pipeline status

```bash
glab ci status                       # Current branch pipeline status
glab ci status -b main               # Specific branch
glab ci list                         # List recent pipelines
glab ci get                          # Get current pipeline as JSON
```

### Run and manage pipelines

```bash
glab ci run                          # Trigger pipeline on current branch
glab ci run -b main                  # Trigger on specific branch
glab ci cancel                       # Cancel running pipeline
glab ci delete 12345                 # Delete a pipeline
```

### Jobs

```bash
glab ci view                         # Interactive pipeline viewer
glab ci trace <job-id>               # Stream job log in real time
glab ci trace <job-name>             # Stream by job name
glab ci retry <job-id>               # Retry a failed job
glab ci trigger <job-id>             # Trigger a manual job
glab ci artifact <ref> <job-name>    # Download artifacts
```

### Lint CI config

```bash
glab ci lint                         # Validate .gitlab-ci.yml
```

## Repositories

```bash
glab repo view                       # View current project info
glab repo list                       # List your repositories
glab repo search --search "query"    # Search projects
glab repo clone GROUP/PROJECT        # Clone a project
```

## Tips

- Most commands work with the repo detected from the current git directory
- Use `-R OWNER/REPO` or `-R GROUP/NAMESPACE/REPO` to target another project
- Use `--web` on view commands to open in the browser
- Use `-o json` or `--output json` where supported for machine-readable output
- Use `glab api <endpoint>` for direct GitLab API calls when a specific
  command is not available
