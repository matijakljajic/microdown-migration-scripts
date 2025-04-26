# Microdown Migration Scripts

## Contents

This repository contains shell scripts designed to assist in migrating documents from `.md` to `.md2`:

- [process-md.sh](#process-mdsh)
- [convert-md.sh](#convert-mdsh)
- [format-md.sh](#format-mdsh)

This repository also contains a workflow template that utilizes these scripts to process `.md` files automatically on every push:
- [GitHub Actions Workflow](#github-actions-workflow)

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

### Github Actions Workflow

This repository also includes a [GitHub Actions workflow](workflow-for-md2-conversion.yml) that automates the conversion of `.md` files to `.md2` format.

#### Workflow Overview

- The workflow is triggered whenever `.md` files are pushed to the repository.
- It processes each new `.md` file by:
  1. Converting it to `.md2` format using [`process-md.sh`](process-md.sh).
  2. Formatting the `.md2` file using [`format-md.sh`](format-md.sh).
  3. Deleting the original `.md` file after successful processing.

#### Workflow Setup

To use the workflow in your repository, follow these steps:

1. Copy the workflow file to your target repository under `.github/workflows/` of your target repository.
2. Rename the file to `process-markdown.yml` (or any other descriptive name you prefer).
3. Configure the `MONITORED_SUBFOLDERS` environment variable in the workflow file:
  - Set it to `.` (default) to monitor the whole repository.
  - Or provide a comma-separated list of directories to monitor specific subfolders (e.g. `site,docs,content`).

Once configured, the workflow will automatically process `.md` files whenever they are pushed to the repository.

## Notes

- Carriage returns are converted to the Unix standard due to the original files being written on legacy Macs.
- The workflow is designed to pull scripts directly from this repository, specifically from the `main` branch, for easier code organization.
- The scripts act as agents for the workflow, so any improvements or updates to the scripts or the workflow should be contributed to this repository.

# License

These scripts are licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
