# Mise Assessment and Adoption Plan

> Assessed: 2026-07-16
> Status: approved direction; not implemented yet

## Decision

Adopt [mise](https://github.com/jdx/mise) as the cross-platform manager for
developer language runtimes and selected portable CLI tools. Keep Homebrew and
DNF for operating-system packages, desktop applications, fonts, system
libraries, and the bootstrap tools required before Mise is available.

Keep Chezmoi as the source of configuration and secrets, and keep
`nartcdotfiles` as the machine-level reconciliation command. Its runtime phase
should eventually install Mise-managed tools rather than invoking fnm, pyenv,
the Bun installer, or Homebrew JDK/Go formulae.

## Why Mise

Mise has first-party core backends for Bun, Elixir, Erlang, Go, Java, Node.js,
Python, Rust, and other major runtimes. It supports macOS on Apple Silicon and
Linux, including Fedora. A global config provides personal defaults while a
committed `mise.toml` in a project overrides them as the shell enters that
project.

It also provides:

- shell activation that changes `PATH` and environment values such as
  `JAVA_HOME` and `GOROOT` as directories change;
- project-scoped environment variables and optional task definitions;
- version lockfiles, including platform-specific artifacts;
- core, Aqua, GitHub, npm, cargo, Go, and other installation backends;
- trust prompts for project configuration, which matters because configuration
  can define environment directives, hooks, and tasks.

## Scope

| Category | Direction |
| --- | --- |
| Node.js | Replace fnm with Mise core Node. Keep 20.19.0 as the initial global default; projects declare their own version. |
| Python | Replace pyenv for interpreter versions. Keep uv for virtual environments and Python package workflows. |
| Bun | Replace the direct `bun.sh` installation and `$BUN_INSTALL` shell setup. |
| Go | Replace Homebrew Go and manual `GOROOT` path handling. |
| Rust | Use Mise to select/install Rust toolchains, targets, and components; retain rustup as Mise's underlying installer. |
| Java | Replace Homebrew JDKs and the brew-specific `setjava` helper. Prefer a named vendor such as Temurin rather than the short `openjdk` alias. |
| pnpm | Remove Homebrew pnpm. Prefer Corepack and each project's `packageManager` pin; do not depend on one global pnpm version. |
| Maven and Gradle | Prefer `./mvnw` and `./gradlew` in projects. Do not make a global Gradle installation the project contract. |
| Erlang and Elixir | Strong follow-up candidate; replace the hand-managed `.elixir-install` paths after the core runtime migration is stable. |
| Portable CLI binaries | Migrate selectively with core or `aqua:` backends. Prefer Aqua/GitHub artifacts over legacy asdf plugins and over language-package-manager installs where practical. |
| GUI apps, fonts, OS tools, system libraries | Keep in Homebrew/DNF. |
| Chezmoi, age, git, curl, shell, tmux, Kitty, Neovim, compilers | Keep as system/bootstrap dependencies. |

## Current Baseline and Drift

The current setup mixes fnm, pyenv, the Bun installer, rustup, and Homebrew:

- fnm tracks Node 20.19.0 as default and has Node 22.14.0 and 24.x installed.
  The runtime bootstrap source requests 24.12.0, while the current machine also
  has 24.15.0; reconcile that version drift before migration.
- pyenv tracks Python 3.12.12, while an unactivated `python3` resolved to
  3.14.4 during assessment. Mise can make the selected interpreter explicit.
- Go is Homebrew-managed (1.26.4 at assessment time).
- Java is Homebrew OpenJDK 21.0.11; the source also declares OpenJDK 17.
- rustup owns stable Rust 1.95.0 and an additional 1.82.0 toolchain.
- Bun is installed at `~/.bun` (1.3.13 at assessment time).
- Homebrew pnpm 11.0.6 currently fails under the fnm-selected Node 20.19.0
  because that pnpm release requires Node 22.13 or newer. This is a concrete
  compatibility problem to resolve through project-level package-manager pins.

## Java and Gradle Caveat

Mise sets `JAVA_HOME` only with shell activation; shims alone do not set it.
Applications launched outside the shell may need a restart or macOS Java-home
integration.

Gradle currently does not auto-detect Java installations managed by Mise. For
Gradle projects, prefer the Foojay toolchain resolver where supported. The
documented fallback is an asdf-layout compatibility symlink from
`~/.asdf/installs/java` to Mise's Java install directory. Validate IDE and
Gradle toolchain detection before removing Homebrew JDKs.

## Target Architecture

```text
Homebrew / DNF
  ├─ bootstrap dependencies, system packages, desktop apps, and fonts
  └─ mise binary

Chezmoi
  ├─ ~/.config/mise/config.toml and any shared global lockfile
  ├─ shell activation
  └─ nartcdotfiles runner

nartcdotfiles apply
  ├─ install mise through the platform package manager
  ├─ apply Chezmoi configuration
  ├─ run mise install and verification
  └─ reconcile tmux and LazyVim separately
```

On macOS, install Mise with Homebrew. On Fedora 41+, the documented DNF path
enables the `jdxcode/mise` COPR before installing the `mise` package. Adding a
COPR is an external repository configuration change and requires explicit
approval when the migration is implemented.

## Configuration and Security Policy

- Manage personal defaults through `~/.config/mise/config.toml` with Chezmoi.
- Commit a `mise.toml` and `mise.lock` for each project that adopts Mise.
- Use exact versions, or constrained versions with lockfiles, for reproducible
  installs across macOS ARM and Fedora/Linux.
- Do not globally enable automatic installation when entering a directory.
  Use explicit `mise install` during setup and in project onboarding.
- Keep Mise's project-config trust behavior enabled. Treat unfamiliar project
  configs as executable configuration.
- Prefer core backends first, then Aqua or GitHub. Avoid asdf/vfox plugins
  unless a tool needs behavior unavailable through modern backends.
- Set a minimum release age for globally resolved tools (for example seven
  days) after testing the resulting update workflow.
- Do not enable strict `locked` mode globally without testing: it applies to
  all resolved tools, including global ones. Aqua has stronger lockfile
  provenance support than most core, npm, cargo, and pipx backends.

## Migration Sequence

1. Install Mise only; retain all existing managers.
2. Add a Chezmoi-managed global Mise config for Node, Python, Bun, Go, Rust,
   and Java, then run `mise install`, `mise current`, and `mise doctor`.
3. Update the `nartcdotfiles` runtime phase to use Mise and test on macOS.
4. Add Fedora installation support and validate the same config there.
5. Migrate representative Node, Rust, Go, and Java/Gradle projects to
   project-local `mise.toml` files and lockfiles.
6. Remove fnm, pyenv, Homebrew Go/JDK/Python/pnpm, Bun's standalone install,
   and their shell setup only after tool, IDE, and CI verification succeeds.
7. Evaluate Elixir/Erlang and selected standalone developer CLIs as a separate
   follow-up.

## Shell Migration Requirements

Once Mise owns the relevant tools, remove the shell's fnm activation, pyenv
wrappers, Bun path, manual Go path, Homebrew Java setup, and brew-only Java
switcher. Add `eval "$(mise activate zsh)"` after static `PATH` setup so that
Mise is authoritative for the active runtime.

For non-interactive scripts, use `mise exec` or `mise run`; interactive shell
activation only updates the environment at prompts.

## Sources

- [Mise repository and llms.txt](https://github.com/jdx/mise/blob/main/llms.txt)
- [Installing Mise](https://mise.jdx.dev/installing-mise.html)
- [Core tools](https://mise.jdx.dev/core-tools.html)
- [Configuration](https://mise.jdx.dev/configuration.html)
- [Node](https://mise.jdx.dev/lang/node.html), [Go](https://mise.jdx.dev/lang/go.html), [Rust](https://mise.jdx.dev/lang/rust.html), [Java](https://mise.jdx.dev/lang/java.html), and [Bun](https://mise.jdx.dev/lang/bun.html)
- [Lockfiles and supply-chain controls](https://mise.jdx.dev/dev-tools/mise-lock.html)
- [Backends](https://mise.jdx.dev/dev-tools/backends/) and [Aqua backend](https://mise.jdx.dev/dev-tools/backends/aqua.html)
- [Tasks](https://mise.jdx.dev/tasks/) and [configuration trust/paranoid mode](https://mise.jdx.dev/paranoid.html)
