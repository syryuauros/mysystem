{  }:

let

  mywallpapers-1366-overlay = import "${builtins.fetchGit {
    url = "git+ssh://git@gitlab.com/wavetojj/mywallpapers-1366";
  }}/overlay.nix" {};

  overlays =  [
              mywallpapers-1366-overlay
              (import ./overlay.nix {})
             ];

in import <nixpkgs> { inherit overlays; }
