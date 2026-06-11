# GPU profile selection. Each variant module declares its own
# `workstation.gpu.<kind>.enable` flag; devices opt in to one (or more
# for hybrid setups like NVIDIA Prime).
{ ... }: {
  imports = [
    ./intel.nix
  ];
}
