# PKGNAME

Generated based on the templates:

- flake template: git@github.com:DevInsideYou/scala-seed.git
- g8 template: git@github.com:DevInsideYou/scala3-seed.g8.git

# Setup develop environment

## Nix

### install nix

see the description (https://zero-to-nix.com/start/install)

### enable flake

add teh following to `~/.config/nix/nix.conf`
`experimental-features = nix-command flakes`

### clone the repo for a project setup

`git clone git@github.com:chengzh2008/template-scala.git <your-project-name>`

### config the project

`cd <your-project-name>`
`./wizard.sh` and answer some questions

### install and enable direnv

`echo "use flake" >> .envrc`

### install vscode extentions

- Scala Syntax (official)
- Scala (Metals)

## coursier

### install coursier

https://get-coursier.io/docs/cli-installation

### install vscode extentions

- Scala Syntax (official)
- Scala (Metals)

# How to build and run

## run sbt

## run subcommands
