# Claude

This file should be followed strictly. Please read it and make sure you handle
everything that is mentioned and referenced.

Everything in this document and referenced documents are equally important,
meaning you should not at any point skip, ignore, or feel free to interpret them
as optional.

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
parse the command output. Please also note that this only works for the AWS CLI
described here and is not a general reccomendation for other CLIs.

If you need help navigating the CLI, use "aws help" to read the docs.

When you find interesting log lines in AWS, you can usually use the
"aws_request_id" if present to connect related log lines for a single request.

## Gitlab and the glab CLI

You have access to Gitlab through the `glab` CLI. Whenever you are asked to do
something in Gitlab, you can use this CLI to perform the task.

If you need help navigating the CLI, use "glab --help" to read the docs.

## Jira and the Atlassian acli CLI

You have access to Jira through the `acli jira` CLI. Whenever you are asked to
do something in Jira, you can use this CLI to perform the task.

The acli does not have any options for specifying output type or format, so do
not bother to include that in commands unless the help page shows an option for
it, and it is needed.

To tag people in Jira comments, use the `@username` notation.

If you need help navigating the CLI, use "acli jira --help" to read the docs.

## Learning CLIs

Whenever you learn something new about a CLI, by using `--help` options or
`help` commands for instance, make sure you make a note of it in the global
`~/AGENTS.md` so you can refer back to it later and do not have to go through
the same cycle every time you use a CLI.
