# Custom workstation.mavnezz.* layer — software groups that are specific to
# this user's setup (3D printers, business comms, dev stack, etc.).
#
# Each sub-module declares its own `workstation.mavnezz.<group>.enable` flag.
# Devices opt in to whatever groups they need from devices/<class>/<name>/default.nix.
{ ... }: {
  imports = [
    ./browsers.nix
    ./comms.nix
    ./dev.nix
    ./media.nix
    ./printers3d.nix
    ./printing.nix
    ./security.nix
    ./steam.nix
    ./syncthing.nix
  ];
}
