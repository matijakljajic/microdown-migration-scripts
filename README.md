# Microdown Migration Scripts

## Contents

This repository contains shell scripts designed to assist in migrating documents from `.md` to `.md2`:

- [process-md.sh](#process-mdsh)
- [convert-md.sh](#convert-mdsh)
- [format-md.sh](#format-mdsh)

## Introduction

[Foliage](https://github.com/Ducasse/Foliage) depends on file extensions to differentiate between parsers:

- `.md` files: Parsed by [Pillar](https://github.com/pillar-markup/pillar)
- `.md2` files: Parsed by [Microdown](https://github.com/pillar-markup/Microdown)

These scripts automate the conversion process to ensure compatibility with Microdown.

## Explaination

### [process-md.sh](process-md.sh)

- This script converts `.md` files' YAML-like metadata to JSON format suitable for `.md2` files. It also [standardizes carriage returns](#notes).

### [convert-md.sh](convert-md.sh)

- This script enables batch processing of multiple `.md` files in a directory using `process-md.sh`, making it suitable for one-line migrations of entire directories.

### [format-md.sh](format-md.sh)

- This script formats `.md2` files containing embedded HTML to ensure compatibility with line-based parsing by [Microdown](https://github.com/pillar-markup/Microdown). It also supports batch processing of directories.

## Installation

Clone the repository to your local machine:

```sh
git clone https://github.com/matijakljajic/microdown-migration-scripts.git
cd microdown-migration-scripts
```

Don't forget to make the scripts executable:

```
chmod +x *.sh
```

## Usage

Each script comes with a helpful `--help` command that provides usage instructions.

## Notes

Carriage returns are converted to the Unix standard due to the original files being written on legacy Macs.

# License

These scripts are licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
