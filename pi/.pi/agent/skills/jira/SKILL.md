---
name: jira
description:
  Interact with Jira using the acli CLI. Search, view, create, edit, and
  transition work items. List comments, boards, sprints, and projects. Use when
  the user asks about Jira tickets, tasks, or project management.
---

# Jira

Use `acli jira` via bash to interact with Jira. All commands are under
`acli jira`.

Run `acli jira [command] --help` for full flag details on any command.

## View a work item

```bash
acli jira workitem view KEY-123
acli jira workitem view KEY-123 --fields "summary,comment"
acli jira workitem view KEY-123 --fields "*all"
```

Default fields: `key,issuetype,summary,status,assignee,description`.

## Search work items

```bash
acli jira workitem search --jql "project = PROJ AND status = 'In Progress'"
acli jira workitem search --jql "assignee = currentUser()" --limit 10
acli jira workitem search --jql "project = PROJ" --fields "key,summary,status"
```

Default fields: `issuetype,key,assignee,priority,status,summary`.

## Comments

```bash
acli jira workitem comment list --key KEY-123
acli jira workitem comment list --key KEY-123 --limit 10
acli jira workitem comment create --key KEY-123 --description "Comment text"
```

## Create a work item

```bash
acli jira workitem create --summary "Title" --project "PROJ" --type "Task"
acli jira workitem create --summary "Bug title" --project "PROJ" --type "Bug" --assignee "user@example.com" --description "Details"
```

## Edit a work item

```bash
acli jira workitem edit --key KEY-123 --summary "New summary"
acli jira workitem edit --key KEY-123 --assignee "user@example.com"
acli jira workitem edit --key KEY-123 --description "Updated description"
```

## Transition a work item

```bash
acli jira workitem transition --key KEY-123 --status "Done"
acli jira workitem transition --key KEY-123 --status "In Progress"
```

## Boards

```bash
acli jira board search
acli jira board search --name "My Board"
acli jira board list-sprints --id 123
acli jira board list-sprints --id 123 --state "active"
acli jira board list-projects --id 123
```

## Sprints

```bash
acli jira sprint view --id 123
acli jira sprint list-workitems --sprint 1 --board 6
acli jira sprint list-workitems --sprint 1 --board 6 --fields "key,summary,status"
```

## Projects

```bash
acli jira project list
acli jira project view KEY
```

## Tips

- Use `--json` on most commands for machine-readable output
- Use `--csv` on list/search commands for tabular output
- Use `--paginate` to fetch all results beyond the default limit
- Use `--web` on view/search to open in browser
