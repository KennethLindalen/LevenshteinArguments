# Levenshtein Arguments

**Levenshtein Arguments** is a Bash utility that suggests the closest valid arguments for a CLI app when users make typos.

## Features

- Supports multiple fuzzy-typed arguments in one line
- Suggests the corrected command without running it
- Accepts and preserves all extra arguments (e.g. `--env dev`)
- Written in pure Bash with no external dependencies
- Easy to integrate into existing CLI wrappers


## TODO:
  - Caching of already calculated strings, reducing memory usage
  - 
## Usage

```bash
./levenshtein-arguments.sh <arg1> [arg2 ...] -- [extra arguments...]
```
Example
```bash
./levenshtein-arguments.sh srart stp -- --env dev
```

Output:
```bash
Suggested command:
./myapp start stop --env dev

```

Configuration

The script has two sections that can be adjusted to fit your specific application:
Base command

```bash
base_command="./myapp"

Change this to the name or path of your application’s main entry point.
Valid options
```bash
valid_options=(
  start
  stop
  restart
  status
  setup
  config
  help
  version
)
```
Edit this list to include the valid arguments or subcommands your application supports.
Installation

Make the script executable:
```bash
chmod +x levenshtein-arguments.sh
```
Optionally rename it to match your application:
```bash
mv levenshtein-arguments.sh myapp
```

Then use it as:
```bash
./myapp srart --env dev
```
