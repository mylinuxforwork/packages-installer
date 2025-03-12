# Packages Installer

> Please note that the Packages Installer is still in the ALPHA Phase and errors can occure. Please feel free to share your observations as an issue here on GitHub.

Create portable bash installation scripts for your favorite packages collection.

![image](https://github.com/user-attachments/assets/9781a097-e0a5-4c37-ad27-7e6502e4bbba)

## Installation & Update

```
bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/packages-installer/master/setup.sh)
```

Please check the Wiki for more information how to use the app: https://github.com/mylinuxforwork/packages-installer/wiki

## Demonstration

The following installation scripts haven been created with the Packages Installer.

### Hyprland Base Installation

The script will install the core packages for Hyprland on pacman (Arch), dnf (Fedora) and zypper (openSuse) distributions.

https://github.com/mylinuxforwork/packages-installer/tree/main/demo/hyprland-base

You can execute it directly on your system with:

pacman:

```
bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/packages-installer/master/demo/hyprland-base/pacman-hyprland-base.sh)
```

dnf:

```
bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/packages-installer/master/demo/hyprland-base/pacman-hyprland-base.sh)
```

zypper:

```
bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/packages-installer/master/demo/hyprland-base/pacman-hyprland-base.sh)
```

You can load the Remote Configuration into the Packages Installer from:

```
https://raw.githubusercontent.com/mylinuxforwork/packages-installer/master/demo/hyprland-base/hyprland-base.pkginst
```


