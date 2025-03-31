# Packages Installer

> Please note: The script is currently in BETA. Several tests are running on different Linux distributions.

Create an enhanced and multiplatform installation script for your favorite package collection, dependencies for your dotfiles configuration or for a single flatpak app. This is possible with the Packges Installer script.

The script will detect automatically your available Linux package manager and will install the packages directly or with a custom installation command for full flexibility.

![image](https://github.com/user-attachments/assets/c05677e6-33e5-4bce-9e0b-7dbade67c87d)

In addition, you can offer an optional set of packages where the user can choose from, e.g. browsers, terminals, file managers, etc.

You can provide installation configurations with compressed .pkginst file on your webserver or remote Git Repository like GitHub or GitLab or can install and test a local configuration.

You can find examples here: https://github.com/mylinuxforwork/packages-installer/tree/main/examples

The following package managers are currently supported:
- apt (e.g. for Ubuntu)
- dnf (e.g. for Fedora)
- pacman (e.g. for Arch Linux)
- zypper (e.g. for openSuse)
- flatpak

> With custom installations you can also use yay, paru, add repos for dnf, etc.

Is your package manager currently not supported, your can export a list of packages from the configuration and suggest to install the packages manually.

You can find more information in the Wiki. https://github.com/mylinuxforwork/packages-installer/wiki

> The Packages Installer Editor will support you with an UI to create your installation configurations even faster. The Packages Installer Editor is currently in development and a first BETA will be available soon.

## Installation

You can install a local developement environment with the following command:

```
bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/packages-installer/main/install.sh)

```

