bio_wsl is a build process in order to create a wsl2 distribution that includes

- ubuntu 22.04 LTS 
- docker

## Easy Install

- The easy install uses the following powershell script...


## Easy Upgrade

- do backup (`c:\Users\{username}\.wsl\wsl-build\home.tar.gz`)
  `wsl -d wsl-build wslhome --backup`
- easy install
- do restore
  `wsl -d wsl-build wslhome --restore`


What is in the backup and restore?

- `~/.ssh`: deals with your ssh keys for git and ssh access.  
- `~/.gitconfig`: saves your git configuration. 
- `.bash_aliases`: saves yoru aliases. See [`.bash_aliases`](./scripts/.bash_aliases) for default config
 .vscode .config/microsoft-edge 

## Building the Project

The `build.sh` bash script is designed to streamline the process of setting up and configuring Docker, alongside the buildx plugin on a Windows Subsystem for Linux (WSL) environment. When executed, the script will ensure Docker is installed and updated, and the buildx plugin is configured correctly. It also enables the user to create, export, and manage Docker containers within the WSL environment. The script provides an optional `--install` argument which, when specified, performs additional steps to install and configure the WSL environment for Docker.

### Requirements

- A system running Windows with WSL enabled and the `wslu` package installed (https://wslutiliti.es/wslu/).
- Docker installed on your machine.
- bash shell available for script execution.


### Usage

1. Open a bash shell.
2. Navigate to the directory containing the script.
3. To execute the script, run the following command:

```bash
./build.sh [--install]
```

The `--install` argument is optional. If specified, the script will perform additional steps to install and configure WSL for Docker.

### Description of Operations

- Checks for the `--install` argument to determine if WSL setup steps should be executed.
- Ensures a Dockerfile exists in the current directory (`./`).
- Utilizes Docker buildx to build an image from the Dockerfile.
- When `--install` is specified:
  - Creates a Docker container from the built image.
  - Exports the container's filesystem as a gzipped tarball (`wsl-build.tar.gz`).
  - Unregisters any existing WSL distribution with the name `wsl-build`.
  - Creates necessary directory structure for the new WSL distribution `c:\Users\{username}\.wsl\wsl-build`.
  - Moves the gzipped tarball to `c:\Users\{username}\.wsl\wsl-build`.
  - Imports the gzipped tarball as a new WSL distribution named `wsl-build`.

### Troubleshooting

Ensure Docker and WSL are properly installed and configured on your machine before running this script. If encountering issues, double-check the path variables and directory structures to ensure they align with your system configuration.
