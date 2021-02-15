# * Nix for Emacs
{ stdenv, runCommand, fetchFromGitHub, fetchurl
, emacs, emacsPackages
, myHunspell, languagetool, openjdk
}
:
rec {

# ** myDefault.org
  myDefault = let
    name    = "myDefault";
    env     = { buildInputs = [ emacs ]; };
    command = ''
      mkdir -p $out && cd $out
      cp ${./myDefault.org} myDefault.org
      for orgFile in *.org
      do
        emacs \
          --batch -l ob-tangle                              \
          --eval "(defun expand-tangle-path(f)              \
                    (replace-regexp-in-string \" \" \"/\"   \
                    (concat                                 \
                      (org-entry-get nil \"tangle-dir\" t)  \
                      \"/\" f)))"                           \
          --eval "(setq org-confirm-babel-evaluate nil)"    \
          --eval "(org-babel-tangle-file \"$orgFile\")"
      done
      rm *.org
    '';
  in runCommand name env command;

# ** mySnippets
  mySnippets = let
    name    = "mySnippets";
    env     = { };
    command = ''
      mkdir -p $out && cd $out
      cp -r ${myDefault}/mySnippets/* .
    '';
  in runCommand name env command;

# ** myDefault-el
  myDefault-el = let
    name    = "default.el";
    env     = { };
    command = ''
      target=$out/share/emacs/site-lisp/default.el
      mkdir -p "$(dirname "$target")"
      cp ${myDefault}/default.el "$target"
      substituteInPlace "$target" \
        --subst-var-by mySnippets ${mySnippets} \
        --subst-var-by myHunspell ${myHunspell} \
        --subst-var-by languagetool ${languagetool} \
        --subst-var-by openjdk ${openjdk}
    '';
  in runCommand name env command;

# ** My Emacs Packages
  myEmacsPackages = emacsPackages.overrideScope' (eself: esuper: {

# *** Base Emacs depending on OS
    emacs = emacs;  # inherit from the argument

# *** evil-plugins
    evil-plugins = esuper.trivialBuild {
      pname = "evil-plugins";
      src = fetchFromGitHub {
        owner = "tarao";
        repo = "evil-plugins";
        rev = "d9094d238756300ac4ca1050d6a71d302e120ca1";
        sha256 = "03inaswz46p66f0f6j82x0hgr9jxcn41kyjf8qxrx97smijlb39w";
        # date 2015-04-06T21:33:10+09:00                                        |
      };
      phases = [ "unpackPhase" "installPhase" ];
      installPhase = ''
        LISPDIR=$out/share/emacs/site-lisp
        install -d $LISPDIR
        install *.el *.elc $LISPDIR
      '';
    };

  });

# ** Emacs Definition with package list

  myEmacs = let

    packageList = epkgs :
    (with epkgs; [
      myDefault-el
      evil-plugins
    ]) ++
    # ORG packages
    (with epkgs.orgPackages; [
      org
      # org-plus-contrib
    ]) ++
    # MELPA packages
    (with epkgs.melpaPackages; [
      use-package
      benchmark-init

      avy
      ivy
      ivy-rich
      ivy-hydra
      counsel
      ivy-rich
      ivy-bibtex
      ivy-prescient
      ivy-prescient
      hydra
      swiper
      counsel
      counsel-projectile
      projectile
      prescient
      perspective
      # persp-mode

      dired-single
      dired-open
      dired-hide-dotfiles
      dired-ranger
      treemacs
      treemacs-evil
      treemacs-projectile
      treemacs-icons-dired
      treemacs-magit
      treemacs-perspective

      fzf
      rg
      direnv
      envrc
      multi-term
      vterm
      vterm-toggle

      ws-butler
      magit
      winum
      windsize
      diminish
      helpful
      simpleclip
      default-text-scale
      rainbow-delimiters
      string-inflection
      command-log-mode

      doom-modeline
      doom-themes
      spacegray-theme
      color-theme-sanityinc-tomorrow
      material-theme
      all-the-icons
      all-the-icons-dired
      all-the-icons-ivy-rich
      minions
      fira-code-mode
      mixed-pitch
      perfect-margin
      visual-fill-column
      multiple-cursors

      evil
      evil-collection
      evil-magit
      evil-surround
      evil-org
      evil-commentary
      evil-lion
      evil-exchange
      evil-indent-plus
      evil-goggles
      evil-snipe
      evil-mc
      evil-visualstar
      evil-multiedit

      general
      which-key

      company
      company-lsp
      company-box
      company-math
      company-prescient
      company-ghc
      company-ghci
      company-cabal
      company-posframe
      company-quickhelp
      company-math
      company-irony
      company-c-headers
      company-prescient

      yasnippet
      yasnippet-snippets
      haskell-snippets

      dap-mode
      lsp-mode
      lsp-ui
      lsp-ivy
      lsp-jedi
      lsp-julia
      lsp-treemacs
      lsp-latex
      lsp-haskell

      nix-mode
      haskell-mode
      kotlin-mode
      gnuplot-mode
      writegood-mode
      pandoc-mode

      nix-update
      nix-sandbox

      flycheck
      flycheck-haskell
      flycheck-kotlin
      flycheck-elm
      flycheck-pos-tip
      flycheck-guile

      org-bullets
      org-tree-slide
      org-present
      outshine


    ]) ++
    # ELPA packages
    (with epkgs.elpaPackages; [
      undo-tree
      darkroom
    ]);

  in myEmacsPackages.emacsWithPackages packageList;

}
