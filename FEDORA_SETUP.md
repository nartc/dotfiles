# Fedora Setup and Recovery

This repository manages shared configuration through `nartcdotfiles`, the
idempotent setup runner. It owns package installation, Chezmoi application,
plugin bootstraps, and verification as repeatable phases.

## First setup

1. Install the bootstrap prerequisites:

   ```bash
   sudo dnf install chezmoi age
   ```

2. Restore the age identity at `~/.config/chezmoi/key.txt`.
3. Clone the source without applying it:

   ```bash
   chezmoi init nartc
   ```

4. Run the runner from the cloned source:

   ```bash
   bash ~/.local/share/chezmoi/dot_local/bin/executable_nartcdotfiles apply
   ```

After the first successful application, use `nartcdotfiles apply` from a new
shell. The runner installs only missing Fedora RPMs, applies Chezmoi, creates
TPM at its pinned commit, synchronizes LazyVim plugins, and verifies the shared
configuration. `sudo` is requested only when DNF has missing packages.

## If setup stops midway

Do not reset Chezmoi or delete configuration directories. Run:

```bash
nartcdotfiles apply
```

Every automated phase is safe to retry from the beginning:

- the Fedora package phase checks every desired RPM first and asks DNF for only the
  missing packages;
- the tmux phase creates TPM in a temporary directory, moves it into place
  only after checkout succeeds, and retries plugin installation on every
  run;
- the remaining phases check their current state before changing it, or use an
  idempotent package/configuration manager.

The most recent log and failure metadata live in
`~/.local/state/nartcdotfiles/`.

For inspection without changes:

```bash
nartcdotfiles check
chezmoi status
chezmoi diff
chezmoi apply --dry-run --verbose
```

If DNF itself reports a transaction problem, resolve it with the command DNF
prints, then rerun `nartcdotfiles apply`. If TPM is incomplete, the script saves
that directory as `~/.config/tmux/plugins/tpm.incomplete.<timestamp>` and
creates a fresh checkout on the next run.

## Scope

Shared configuration is Linux-generic where possible. Fedora-specific behavior
is limited to this DNF package bootstrap. A future Ubuntu setup should reuse
the same configs and add a separate `apt` bootstrap script.
