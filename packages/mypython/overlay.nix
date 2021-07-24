final: prev: with final; {

  python3 = let

    overrides = self: super: {

      mytensorflow         = super.tensorflow_2.override { cudaSupport = false; };
      mytensorflowWithCuda = super.tensorflow_2.override { cudaSupport = true; };

    };

  in prev.python38.override (old: {
    packageOverrides =
      lib.composeExtensions
        (old.packageOverrides or (_: _: {}))
        overrides;
  });

  mypythonPackageSelectFrom = rec {

    default = p: with p; [
      numpy
      scipy
      pandas
      scikitlearn

      altair
      matplotlib
      vega_datasets
      seaborn

      ipython
      entrypoints
      jsonschema
      toolz
      jinja2
      sphinx
      pygments
      mutagen

      python-language-server
    ];

    ml-nocuda = p: with p; [
      Keras
      mytensorflow
      pytorch
    ];

    ml-cuda = p: with p; [
      Keras
      mytensorflowWithCuda
      pytorchWithCuda
    ];

    full = p:
      (  (default p)
      ++ (ml-nocuda p)
      );

    full-cuda = p:
      (  (default p)
      ++ (ml-cuda p)
      );

  };

  mypython-common = python3.withPackages (p: mypythonPackageSelectFrom.default p);

  mypython-full = python3.withPackages (p: mypythonPackageSelectFrom.full p);

  mypython-full-cuda = python3.withPackages (p: mypythonPackageSelectFrom.full-cuda p);

  mypython = if stdenv.isLinux
               then mypython-common
               else mypython-common;

}
