#!/bin/bash
# Ensure Docker is installed and updated, and the buildx plugin is configured properly.

WSL_DISTRO="wsl-build"
WSL_FILENAME="${WSL_DISTRO}.tar.gz"
WSL_WIN_TARGET_PATH="$(wslvar USERPROFILE)\\.wsl\\${WSL_DISTRO}"
WSL_LIN_BUILD_PATH="./"
WSL_LIN_TARGET_PATH="$(wslpath ${WSL_WIN_TARGET_PATH})"

INSTALL_WSL=false

# Check for --install argument
for arg in "$@"; do
    case $arg in
        --install)
            INSTALL_WSL=true
            shift # Remove --install from processing
            ;;
        *)
            # Unknown option
            ;;
    esac
done

# Ensure Dockerfile exists at ./
docker buildx build --network host --tag "${WSL_DISTRO}" --file ./Dockerfile .

    if $INSTALL_WSL; then

    # Create a container from the built image.
    CONTAINER_ID=$(docker create "${WSL_DISTRO}")

    # Export the container's filesystem as a gzipped tarball.
    docker export "${CONTAINER_ID}" | gzip > "${WSL_FILENAME}"

    # Remove the temporary container.
    docker container rm "${CONTAINER_ID}"

    # List the exported file.
    ls -la "${WSL_FILENAME}"

    wsl.exe --unregister "${WSL_DISTRO}"
    mkdir -p "${WSL_LIN_TARGET_PATH}"
    cp "${WSL_LIN_BUILD_PATH}/${WSL_FILENAME}" "${WSL_LIN_TARGET_PATH}"
    wsl.exe --import "${WSL_DISTRO}" --version 2 "${WSL_WIN_TARGET_PATH}" "${WSL_WIN_TARGET_PATH}\\${WSL_FILENAME}"
fi
