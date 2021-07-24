{ jupyter_contrib_core , jupyter_nbextensions_configurator }: _: prev:
let

  pythonPackageOverrides = selfPythonPackages: pythonPackages: {

    inherit
      jupyter_contrib_core
      jupyter_nbextensions_configurator
    ;

  };

in

{
  python3 = prev.python3.override (old: {
    packageOverrides =
      prev.lib.composeExtensions
        (old.packageOverrides or (_: _: {}))
        pythonPackageOverrides;
  });
}
