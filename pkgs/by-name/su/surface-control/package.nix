{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  udev,
  coreutils,
}:

rustPlatform.buildRustPackage rec {
  pname = "surface-control";
  version = "0.4.3-2";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = "surface-control";
    rev = "v${version}";
    sha256 = "sha256-QgkUxT5Ae0agvalZl1ie+1LwxgaTzMrKpQY3KkpWwG4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BBEdX/VSTYYIusLkqUZOxmf5pTMbF4v7LjlQxy8RV3Y=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [ udev ];

  postInstall = ''
    installShellCompletion \
      $releaseDir/build/surface-*/out/surface.{bash,fish} \
      --zsh $releaseDir/build/surface-*/out/_surface
    install -Dm 0444 -t $out/etc/udev/rules.d \
      etc/udev/40-surface-control.rules
    substituteInPlace $out/etc/udev/rules.d/40-surface-control.rules \
      --replace "/usr/bin/chmod" "${coreutils}/bin/chmod" \
      --replace "/usr/bin/chown" "${coreutils}/bin/chown"
  '';

  meta = with lib; {
    description = "Control various aspects of Microsoft Surface devices on Linux from the Command-Line";
    homepage = "https://github.com/linux-surface/surface-control";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.linux;
    mainProgram = "surface";
  };
}
