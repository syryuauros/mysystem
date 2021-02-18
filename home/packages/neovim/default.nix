# * vim stuff
{ pkgs } : with pkgs;

let

# ** Packages
  myVimStartPackages = with vimPlugins; [
    fzfWrapper
    fzf-vim
    goyo-vim
    limelight-vim
    fugitive
    surround
    commentary
    vim-nix
    haskell-vim
    vim-hoogle
    zenburn
    airline
    vim-airline-themes
    vim-better-whitespace
    vim-grammarous
    vim-orgmode
    vim-repeat
    easymotion
    vim-sneak
    vim-wordmotion
    vim-expand-region
    vim-indent-object
    vim-exchange
    incsearch-easymotion-vim
    incsearch-vim
    ultisnips
    vim-snippets
    vim-lf
    vim-bclose
    vimagit
    vim-fugitive
    ale
    unite-vim
    unite-haskellimport
  ];

  vim-sneak = vimUtils.buildVimPlugin {
    name = "vim-sneak";
    src = fetchFromGitHub {
      owner = "justinmk";
      repo = "vim-sneak";
      rev = "27cc3ce0fd19f0414024a81ee1eee6b17f155122";
      sha256 = "162gvzm7f0dsgv52ixd79ggzxddgpmrxqsqa41nv72mw61s0pmax";
      # "date": "2019-08-22T01:03:44+02:00",
    };
    phases = [ "unpackPhase" "installPhase" ];
  };

  vim-wordmotion = vimUtils.buildVimPlugin {
    name = "vim-wordmotion";
    src = fetchFromGitHub {
      owner = "chaoren";
      repo = "vim-wordmotion";
      rev = "4c8c4ca0165bc45ec269d1aa300afc36edee0a55";
      sha256 = "1dnvryzqrf9msr81qlmcdf660csp43h19mbx56dnadpsyzadx6vm";
      # "date": "2019-06-14T12:22:17-04:00",
    };
  };

  vim-bclose = vimUtils.buildVimPlugin {
    name = "vim-bclose";
    src = fetchFromGitHub {
      owner = "rbgrouleff";
      repo = "bclose.vim";
      rev = "99018b4a2dd18aea1cbd3aa23565b01a0f8c5b73";
      sha256 = "09a7g0nxn8cbnfz6za8q1p46kb5zbvxl80077hrjpnx4xc82xn2h";
      # "date": "2018-10-10T16:40:06+02:00",
    };
  };

  vim-lf = vimUtils.buildVimPlugin {
    name = "vim-lf";
    src = fetchFromGitHub {
      owner = "ptzz";
      repo = "lf.vim";
      rev = "8ffbae128b8887283b2d4b3a660e5be0de58ea0c";
      sha256 = "0gzj9h31f4synjqfv8dhqihr6fgi3ar06xqjjl5fb4269p9964lb";
      # "date": "2019-10-11T19:33:55+02:00",
    };
  };

  vimagit = vimUtils.buildVimPlugin {
    name = "vimagit";
    src = fetchFromGitHub {
      owner = "jreybert";
      repo = "vimagit";
      rev = "94762b1356ebdcb8ec486a86f45e69ef77a69465";
      sha256 = "0qp21hp9m70dd4804klmzh6xld13hzirx9yvphvqcildvb8kkypb";
      fetchSubmodules = true;
      # "date": "2019-07-24T10:30:41+02:00",
    };
  };

  unite-haskellimport = vimUtils.buildVimPlugin {
    name = "unite-haskellimport";
    src = fetchFromGitHub {
      owner = "ujihisa";
      repo = "unite-haskellimport";
      rev = "440d6051fb71f7cc5d4b4c83f02377bfa48d0acf";
      sha256 = "1qqbb7prm3hyjhzb5hglnyak35gr4dkj34wcklcjg9zxg9qm1mq0";
      # "date": "2019-01-17T20:24:14+09:00",
    };
  };

  vim-exchange = vimUtils.buildVimPlugin {
    name = "vim-exchange";
    src = fetchFromGitHub {
      owner = "tommcdo";
      repo = "vim-exchange";
      rev = "440d6051fb71f7cc5d4b4c83f02377bfa48d0acf";
      sha256 = "09fa156y8pxpzdbngifa7yzg1vjg1fjsgp1h9inj818zbig8mamb";
      # "date": "2017-01-27T10:12:02-08:00",
    };
  };

in
  neovim.override {
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = (builtins.readFile ./vimrc);
      packages.myVimPackage = {
        start = myVimStartPackages;
        opt = [ ];
      };

    };
  }
