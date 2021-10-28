haedosa0ips: hds0ips: { config, pkgs, lib, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{

  imports = [
    ../../../common
    ../../../linux/common
    ./hardware-configuration.nix
    (import ../../wireguard haedosa0ips hds0ips)
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
  };

  networking = {
    hostName = "legion5";
    networkmanager = {
      enable   = true;
      packages = [
        pkgs.networkmanager
      ];
    };
  };


  services.xserver.xkbOptions = "caps:ctrl_modifier,altwin:swap_lalt_lwin";

  environment.systemPackages = [ nvidia-offload ];

  # services.xserver.xkbOptions = "caps:ctrl_modifier";
  #
  services.xserver.videoDrivers = [ "nvidia"  ];
  # services.xserver = {
  #   videoDrivers = [ "intel" "nvidia" ];

  #   config = ''
  #     Section "Device"
  #         Identifier  "Intel Graphics"
  #         Driver      "intel"
  #         #Option      "AccelMethod"  "sna" # default
  #         #Option      "AccelMethod"  "uxa" # fallback
  #         Option      "TearFree"        "true"
  #         Option      "SwapbuffersWait" "true"
  #         BusID       "PCI:0:2:0"
  #         #Option      "DRI" "2"             # DRI3 is now default
  #     EndSection

  #     Section "Device"
  #         Identifier "nvidia"
  #         Driver "nvidia"
  #         BusID "PCI:1:0:0"
  #         Option "AllowEmptyInitialConfiguration"
  #     EndSection
  #   '';
  #   screenSection = ''
  #     Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
  #     Option         "AllowIndirectGLXProtocol" "off"
  #     Option         "TripleBuffer" "on"
  #   '';
  # };

  hardware.nvidia.prime = {
    sync.enable = true;
    # offload.enable = true;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

  hardware.nvidia.modesetting.enable = true;

  specialisation = {
    external-display.configuration = {
      system.nixos.tags = [ "external-display" ];
      hardware.nvidia.prime.offload.enable = lib.mkForce false;
      hardware.nvidia.powerManagement.enable = lib.mkForce false;
    };
  };

}
