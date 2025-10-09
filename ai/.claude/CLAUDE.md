# Claude

This file should be followed strictly. Please read it and make sure you handle
everything that is mentioned and referenced.

Everything in this document and referenced documents are equally important,
meaning you should not at any point skip, ignore, or feel free to interpret them
as optional.

## Agent context

Read @~/AGENTS.md

## Motivation

If you ever feel down or demotivated, try asking the motivator agent for a small
pep talk.

## Working with Golang (Go) projects

Please make sure you always use the gopls MCP whenever you are working on a go
project. Go projects are usually recognized by having a go.mod at the root of
the project, and code files use the .go extension. If you start doing Find() or
Search() for .go files, use this as a reminder that it might be a go project.

Always read @go.md for instructions.

## Code Review

When working on code changes, use the CodeRabbit CLI to get feedback and iterate
whenever you are working on a task. Use this feedback to improve and fix code.
Start CodeRabbit in the background using: `coderabbit --prompt-only` when
beginning any code work, and check with the output periodically during
development and especially after completing features or fixes. Fix all
identified issues immediately before moving to the next task. Repeat the review
cycle until CodeRabbit reports no issues.

## AWS and the AWS CLI

You have access to AWS through the "aws" CLI. Whenever you are asked to
investigate something in AWS, make sure you first ask for region and profile to
use to connect. The default region should be eu-north-1, while there should be
no default profile. Use the provided details when you then run the cli, the
profile should be provided with the "--profile" option, while the region should
be provided through the "--region" option. Do not use environment variables for
configuring this as it will mess up permissions.

Make sure that in any case you run the aws cli, that you provide the profile and
region as _options_ to the cli and not by sending them as environment variables.
If you generate a command with env variables, convert them to options.

If you are about to execute something that looks like
`Bash(AWS_PROFILE=<some profile> AWS_REGION=<some region> aws <command args>)`
make sure you translate it into
`Bash(aws --profile <some profile> --region <some region> <command args>)`.

Also make sure the "--output json" option is passed as it makes it easier to
parse the command output.

If you need help navigating the CLI, use "aws help" to read the docs.
