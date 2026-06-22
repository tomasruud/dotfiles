---
name: redshift
description:
  Connect to Amazon Redshift with psql using the pre-configured service definition
  (`psql service=redshift`). Run ad-hoc SQL, inspect schemas and tables, and check
  query activity. Use when the user asks to query Redshift, explore Redshift tables,
  or run SQL against the analytics cluster.
---

# Redshift (psql)

Connection details are automatically handled, so no need to worry about it.

## Connect

```bash
psql service=redshift                 # interactive session
```

## Run a one-off query

Always pass `< /dev/null` (or `-c`) so the command never blocks on stdin.

```bash
# Pretty table output
psql service=redshift -c "select 1;" < /dev/null

# Tuples-only, unaligned, no headers (good for scripting / piping)
psql service=redshift -tAc "select current_user, current_database();" < /dev/null

# Run a query from a file
psql service=redshift -f query.sql < /dev/null
```

Useful flags: `-tA` (raw output), `-F','` (CSV field separator), `--csv` (CSV
mode), `-P pager=off` (no pager). `\timing` is on per the service env; add
`-q` to silence it.

## Inspect schemas and tables

Redshift is wire-compatible with PostgreSQL 8.0.2, so `psql` backslash commands
work, but the richest metadata is in Redshift system views.

```bash
# List schemas
psql service=redshift -c "\dn" < /dev/null

# List tables in a schema
psql service=redshift -c "\dt public.*" < /dev/null

# Table sizes, row counts, skew, sort/dist keys (Redshift-specific)
psql service=redshift -c "select schema, \"table\", size, tbl_rows, diststyle
  from svv_table_info order by size desc limit 30;" < /dev/null

# Column definitions for one table (pg_table_def needs the schema on search_path)
psql service=redshift -c "set search_path to '\$user', public, myschema;
  select schemaname, tablename, \"column\", type, distkey, sortkey
  from pg_table_def where tablename='my_table';" < /dev/null
```

## Query activity & troubleshooting

```bash
# Currently running queries
psql service=redshift -c "select pid, user_name, starttime, query
  from stv_recents where status='Running';" < /dev/null

# Recent query history (most recent first)
psql service=redshift -c "select query, starttime, substring(querytxt,1,80) as sql
  from stl_query order by starttime desc limit 20;" < /dev/null

# Cancel a running query by pid
psql service=redshift -c "cancel <pid>;" < /dev/null
```

## Tips

- Redshift system views by prefix: `svv_` (metadata snapshots), `stv_` (live
  state), `stl_` (logged history), `svl_` (aggregated logs).
- It is an analytics warehouse: prefer `LIMIT` on exploratory queries and avoid
  `select *` on wide tables.
- DDL/identity differs from Postgres (no `serial`; uses `IDENTITY`, `DISTKEY`,
  `SORTKEY`, `ENCODE`). Don't assume Postgres 14+ features exist.
- For larger result sets, pipe to a file: `psql service=redshift --csv -c "..."
  < /dev/null > out.csv`.
