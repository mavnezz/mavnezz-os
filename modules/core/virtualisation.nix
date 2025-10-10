{pkgs, ...}: {
  # Only enable either docker or podman -- Not both
  virtualisation = {
    docker = {
      enable = true;
    };

    podman.enable = false;

    libvirtd = {
      enable = true;
      onBoot = "start";
      onShutdown = "shutdown";
      qemu = {
        runAsRoot = false;
        ovmf = {
          enable = true;
          packages = [pkgs.OVMFFull.fd]; # UEFI firmware for VMs
        };
        swtpm.enable = true; # TPM emulation
        verbatimConfig = ''
          user = "qemu-libvirtd"
          group = "kvm"
          dynamic_ownership = 1
          remember_owner = 0
        '';
      };
      allowedBridges = [
        "virbr0" # Default NAT bridge
        "br0" # Custom bridge if needed
      ];
    };

    # Kernel modules for better VM performance
    spiceUSBRedirection.enable = true;
  };

  programs = {
    virt-manager.enable = true;
    dconf.enable = true; # Required for virt-manager settings
  };

  environment.systemPackages = with pkgs; [
    virt-viewer # View Virtual Machines
    lazydocker
    docker-client
    qemu_kvm # KVM support
    OVMF # UEFI firmware
    swtpm # TPM emulation
    libguestfs # VM disk tools
    virt-top # Monitor VM performance
    spice # SPICE protocol support
    spice-gtk # SPICE client GTK
    spice-protocol # SPICE protocol headers
    virglrenderer # Virtual GPU support
    mesa # OpenGL support for VMs
  ];

  # Enable necessary kernel modules for VM performance
  boot.kernelModules = ["kvm-amd" "kvm-intel" "vfio-pci"];

  # Add boot kernel parameters for better graphics support
  boot.kernelParams = [
    "intel_iommu=on"
    "iommu=pt"
  ];

  # Enable OpenGL support
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Create default ISO and VM directories with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/libvirt/isos 0755 qemu-libvirtd kvm -"
    "d /var/lib/libvirt/images 0755 qemu-libvirtd kvm -"
  ];
}
