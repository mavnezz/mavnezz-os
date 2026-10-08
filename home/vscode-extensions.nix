# Shared editor extension set, used by both VSCodium (home/vscode.nix) and the
# official VS Code build (modules/mavnezz/dev.nix) so the two stay in sync.
# Add an extension here and it lands in both editors.
pkgs:
with pkgs.vscode-extensions;
[
  anthropic.claude-code
  jnoortheen.nix-ide
  jeff-hykin.better-nix-syntax
  mads-hartmann.bash-ide-vscode
  tamasfe.even-better-toml
  zainchen.json
  ms-python.python
  ms-dotnettools.csharp
  bmewburn.vscode-intelephense-client
  ms-azuretools.vscode-docker
  esbenp.prettier-vscode
]
