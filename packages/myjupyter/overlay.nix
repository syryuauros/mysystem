final: prev: with final; {


  jupyter = import ./jupyterWith { pkgs = final; };



  ipython-common = jupyter.kernels.iPythonWith {
    name = "python-common";
    packages = prev.mypythonPackageSelectFrom.common;
  };

  ipython-full = jupyter.kernels.iPythonWith {
    name = "python-full";
    packages = prev.mypythonPackageSelectFrom.full;
  };

  ipython-full-cuda = jupyter.kernels.iPythonWith {
    name = "python-full-cuda";
    packages = prev.mypythonPackageSelectFrom.full-cuda;
  };

  ipython = if prev.stdenv.isLinux
              then ipython-full
              else ipython-common;




  ihaskell-common = jupyter.kernels.iHaskellWith {
    extraIHaskellFlags = "--codemirror Haskell"; # for jupyterlab syntax highlighting
    name = "haskell-common";
    packages = prev.myhaskellPackageSelectFrom.common;
  };

  ihaskell-full = jupyter.kernels.iHaskellWith {
    extraIHaskellFlags = "--codemirror Haskell"; # for jupyterlab syntax highlighting
    name = "haskell-full";
    packages = prev.myhaskellPackageSelectFrom.full;
  };

  ihaskell = if prev.stdenv.isLinux
              then ihaskell-full
              else ihaskell-common;




  myjupyter-common = jupyter.jupyterlabWith {
    kernels = [ ipython-common ihaskell-common ];
  };

  myjupyter-full = jupyter.jupyterlabWith {
    kernels = [ ipython-full ihaskell-full ];
    # extraPackages = p: with p.python3Packages; [
    #   tensorflow
    #   tensorflow-tensorboard ];
  };

  myjupyter-full-cuda = jupyter.jupyterlabWith {
    kernels = [ ipython-full-cuda ihaskell-full ];
  };

  myjupyter = if prev.stdenv.isLinux
                then myjupyter-full
                else myjupyter-common;


}
