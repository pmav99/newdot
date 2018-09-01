# Instructions

In order to use this you need GNU stow.

# Zsh

## Setting up Zsh with zprezto.

According to
[this](https://github.com/hlecuanda/prezto/blob/5d2b2a776e3ae1145c25d147869371c3ddf1b274/runcoms/README.md)
PR the proper way to setup `zsh` with `prezto` requires that you do the following steps:

1. Install `zsh`
2. `git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"`
3. `git clone --recursive https://github.com/belak/prezto-contrib "${ZDOTDIR:-$HOME}/.zprezto/contrib"`
4. Copy (and not link!) the Runcoms into your `${ZDOTDIR:-$HOME} (the official documentation says
   that you should link but this makes it hard to update prezto). So:
   ```
    setopt EXTENDED_GLOB
    cd "${ZDOTDIR:-$HOME}"
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      cp "$rcfile" ".${rcfile:t}"
    done
   ```
5. Edit the Runcoms to your liking
6. Profit!

If you want to update you run:

1. `cd ${ZPREZTODIR}`
2. `git pull`
3. `git submodule update --init --recursive`
4. `cd ${ZPREZTODIR}/contrib`
5. `git pull`
6. `git submodule update --init --recursive`
7.  You compare/merge the updated runcoms with the ones that you copied when you installed prezto.

## What's next

In this repo we have several `zsh` directories:

- `zsh_vanilla` contains the vanilla Runcoms as of `7bb7a7cb6fe02cce77ad3` (I keep this to make it
   easier to find upstream changes.
- `zsh_desktop` contains the runcoms that I use on my own PCs (desktop and laptop).
- `zsh_remote` contains the runcoms that I use on various VPSs that I manage.


So, no matter which machine I use, I am able to create the appropriate symlinks using git stow. E.g.

```
cd zsh_remote
git stow
```
