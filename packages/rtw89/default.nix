{ stdenv, lib, fetchFromGitHub, kernel }:

let
  modDestDir = "$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/realtek/rtw89";
  # modDestDir = "$out/lib/modules/${kernel.modDirVersion}";
in
stdenv.mkDerivation {
  pname = "rtw89";
  version = "unstable-2021-02-23";

  src = fetchFromGitHub {
    owner = "lwfinger";
    repo = "rtw89";
    rev = "e382af1822acd3defccdee553f2ed97508da0908";
    sha256 = "1l6qj5f11wrkbh2rwv5gf46v7qzqrrhpck9v6v4q3q6m11hnacaf";
  };

  makeFlags = [ "KSRC=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p ${modDestDir}
    find . -name '*.ko' -exec cp --parents {} ${modDestDir} \;
    find ${modDestDir} -name '*.ko' -exec xz -f {} \;

    runHook postInstall
  '';

  meta = with lib; {
    description = "The newest Realtek rtlwifi codes";
    homepage = "https://github.com/lwfinger/rtw89";
    license = with licenses; [ bsd3 gpl2Only ];
    maintainers = with maintainers; [ jj ];
    platforms = platforms.linux;
    broken = kernel.kernelOlder "5.7";
    priority = -1;
  };
}
