# Levenshtein Arguments

**Levenshtein Arguments** is a small Bash utility that helps improve the user experience of command-line applications by suggesting the closest matching argument or subcommand based on Levenshtein distance. This is useful in cases where users may mistype commands.

## Features

- Suggests the closest match from a predefined list of valid options
- Accepts and preserves additional arguments
- Does not execute the command automatically; the user can copy and run the suggested command
- Pure Bash implementation with no external dependencies

## Usage

```bash
./levenshtein-arguments.sh <option> [extra arguments...]
```

Example
```bash
./levenshtein-arguments.sh srart --port 8080
```

Output:
```bash
Suggested command:
./myapp start --port 8080
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
