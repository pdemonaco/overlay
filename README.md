# Overlay

Personal Gentoo overlay I use for some basic testing and development.

## Installation (Layman)

1. Add the overlay's repository list xml file and add it to the repository.

    ```bash
    sudo layman -o https://github.com/pdemonaco/overlay/blob/master/repositories.xml
    ```
2. Accept the fact that this is a "dirty" overlay

    ```bash
    sudo layman -f -a pdemon
    ```
