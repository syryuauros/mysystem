{

  mylib = final: prev: {
    mylib = import ../lib final;
  };

}
# { inputs, system }:

# let

#   pkgs = import inputs.nixpkgs { inherit system; };

#   inherit (pkgs)
#     lib
#     callPackage
#     writeShellScriptBin;

#   inherit (inputs)
#     nur peerix nix-doom-emacs agenix deploy-rs
#     jupyter_contrib_core
#     jupyter_nbextensions_configurator;
# in
# {


#   # nix-doom-emacs = nix-doom-emacs.overlay;
#   agenix = agenix.overlay;
#   deploy-rs = deploy-rs.overlay;
#   nur = nur.overlay;
#   peerix = peerix.overlay;
#   default = lib.composeManyExtensions (with inputs; [
#         (import ../packages/myemacs/overlay.nix)
#         (import ../packages/myvim/overlay.nix)
#         (import ../packages/mytmux/overlay.nix)
#         (import ../packages/myfonts/overlay.nix)
#         (import ../packages/mylockscreen/overlay.nix)
#         (import ../packages/mywallpapers-1366/overlay.nix)
#         (import ../packages/mynitrogen/overlay.nix)
#         # (import ./packages/myflow/overlay.nix)
#         # (import ./packages/myplot/overlay.nix)
#         (import ../packages/mytex/overlay.nix)
#         (import ../packages/myscripts/overlay.nix)
#         # (import ../packages/myhaskell/overlay.nix)
#         (import ../packages/mypython/overlay.nix)
#         (import ../packages/myjupyter/overlay.nix)
#         (import ../packages/myjupyter/jupyter-overlay.nix {
#           inherit jupyter_contrib_core jupyter_nbextensions_configurator;
#         })
#       ]);

# }
