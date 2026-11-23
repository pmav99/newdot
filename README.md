# Instructions

In order to use this you need GNU `stow`.

Before running stow you probably want to create the directory structure beforehand so that stow
creates symlinks only for files. More info [here](https://stackoverflow.com/a/4073999/592289)

# Shell prompt

Bash and desktop Zsh share `common/.config/oh-my-posh/prompt.omp.json`.
Install `oh-my-posh` on each host and deploy `common` with Stow. Bash falls
back to its legacy prompt if the executable or shared configuration is missing.

- Apptainer and Singularity sessions show the image name, e.g. `APPTAINER:sea.sif`
  or `SINGULARITY:sea.sif`. The label is hidden outside those runtimes.
- Local identity: green; SSH identity: amber, with an `SSH` label.
- Hosts whose `hostname -f` ends in `.meluxina.lxp.lu`: magenta, with a
  `MELUXINA` label (the actual node name remains visible).
- Root: red identity and a `#` prompt symbol.
- Commands longer than two seconds show elapsed time; failures show `exit:N`.

Host classification runs once during shell initialization. Compute nodes must
use the same DNS suffix to receive the MeluXina styling. No Nerd Font is required.
The duration threshold is the `executiontime` segment's `options.threshold`, in
milliseconds; set it to `0` to show all command durations.

The theme previously lived under `zsh_desktop/.config/oh-my-posh`. On existing
installations, retarget any directory symlink at `~/.config/oh-my-posh` to
`common/.config/oh-my-posh` before re-stowing. Start a new shell after deploying.

# Zsh

## Setting up Zsh with zprezto.

According to
[this](https://github.com/hlecuanda/prezto/blob/5d2b2a776e3ae1145c25d147869371c3ddf1b274/runcoms/README.md)
PR the proper way to setup `zsh` with `prezto` requires that you do the following steps:

1. Install `zsh`
2. `git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"`
3. `git clone --recursive https://github.com/belak/prezto-contrib "${ZDOTDIR:-$HOME}/.zprezto/contrib"`
4. Open a zsh shell.
5. Copy (and not link!) the Runcoms into your `${ZDOTDIR:-$HOME} (the official documentation says
   that you should link but this makes it hard to update prezto). So:
   ```
    setopt EXTENDED_GLOB
    cd "${ZDOTDIR:-$HOME}"
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
      cp "$rcfile" ".${rcfile:t}"
    done
   ```
6. Edit the Runcoms to your liking
7. Profit!

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

- `zsh_upstream` contains the upstream Runcoms as of `7bb7a7cb6fe02cce77ad3`. We keep this directory
  here just for convenience when updating.
- `zsh_desktop` contains the runcoms that I use on my own PCs (desktop and laptop).
- `zsh_remote` contains the runcoms that I use on various VPSs that I manage.


So, no matter which machine I use, I am able to create the appropriate symlinks using git stow. E.g.

```
git clone https://github.com/pmav99/newdot ~/.dotfiles
cd .dotfiles
stow zsh_remote
```

# Awesome4

For archlinux, this requires the following packages (aur):

- lain-git
