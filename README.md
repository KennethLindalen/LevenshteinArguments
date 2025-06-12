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
