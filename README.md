# Overlay

Personal Gentoo overlay I use for some basic testing and development.

## Installation (Layman)

1. Add the overlay's repository list xml file and add it to the repository.

    ```bash
    sudo layman -o https://raw.githubusercontent.com/pdemonaco/overlay/master/repositories.xml -f -a pdemon
    ```
2. Accept the fact that this is a "dirty" overlay
