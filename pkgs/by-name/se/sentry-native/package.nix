{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  breakpad,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "sentry-native";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "getsentry";
    repo = "sentry-native";
    tag = version;
    hash = "sha256-9jsn7oydaOYOAq6XYYlPjzzy6LSiKOpRtp+PxMlzwz0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    breakpad
  ];

  cmakeBuildType = "RelWithDebInfo";

  cmakeFlags = [
    "-DSENTRY_BREAKPAD_SYSTEM=On"
    "-DSENTRY_BACKEND=breakpad"
  ];

  meta = with lib; {
    homepage = "https://github.com/getsentry/sentry-native";
    description = "Sentry SDK for C, C++ and native applications";
    changelog = "https://github.com/getsentry/sentry-native/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      wheelsandmetal
      daniel-fahey
    ];
  };
}
