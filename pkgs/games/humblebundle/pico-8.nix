{ stdenv, fetchHumbleBundle, SDL2, unzip, xorg, libudev, alsaLib, dbus
, libpulseaudio, libdrm, libvorbis, json_c }:

stdenv.mkDerivation rec {
  name = "pico-8-${version}";
  version = "0.1.12c";

  src = fetchHumbleBundle {
    name = "pico8_linux";
    machineName = "pico8_linux";
    downloadName = {
      "x86_64-linux" = "64-bit";
      "i686-linux"   = "32-bit";
    }.${stdenv.system};
    md5 = {
      "x86_64-linux" = "8d4fbe66ceb1528987841a6743f132db";
      "i686-linux"   = "1e8633fb52c18e803ff7eebe6ddc76f9";
    }.${stdenv.system};
  };

  unpackCmd = ''
    ${unzip}/bin/unzip -qq -d . "$src" || :
  '';

  phases = [ "unpackPhase" "buildPhase" "installPhase" ];

  buildPhase = let
    rpath = stdenv.lib.makeLibraryPath [
      stdenv.cc.cc SDL2 xorg.libXxf86vm xorg.libXcursor xorg.libXi
      xorg.libXrandr libudev alsaLib dbus
      libpulseaudio libdrm libvorbis json_c
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${rpath}" pico8
  '';

  installPhase = ''
    install -vD pico8 "$out/share/pico8"
    install -vD pico8.dat "$out/share/pico8.dat"
    install -vD pico-8.txt "$out/share/pico-8.txt"
    install -vD license.txt "$out/share/license.txt"
    install -vD lexaloffle-pico8.png "$out/share/lexaloffle-pico8.png"

    mkdir -p "$out/bin"
    ln -s "$out/share/pico8" "$out/bin/pico8"
  '';

  dontPatchELF = true;
}
