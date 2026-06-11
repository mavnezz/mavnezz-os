{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.ssh;
in
{
  options.workstation.ssh.enable = lib.mkEnableOption "Default SSH configuration";
  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        AllowUsers = [ "sirjuls44" ];
      };
    };
    users.users."sirjuls44".openssh.authorizedKeys.keys = [
      # Add your authorized SSH keys here when enabling this module.
    ];
    networking.firewall.allowedTCPPorts = [ 22 ];
  };
}
