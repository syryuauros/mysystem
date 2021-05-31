{ stdenvNoCC, lib, linuxPackages }:

stdenvNoCC.mkDerivation {
  pname = "rtw89-firmware";
  inherit (linuxPackages.rtw89) version src;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/firmware/rtw89
    cp *.bin $out/lib/firmware/rtw89

    runHook postInstall
  '';

  meta = with lib; {
    description = "Firmware for the newest Realtek rtlwifi codes";
    homepage = "https://github.com/lwfinger/rtw89";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ jj ];
    platforms = platforms.linux;
  };
}
