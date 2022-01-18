{ appimageTools, fetchurl, ... }:
appimageTools.wrapType2 rec {
  pname    = "ledger-live-desktop";
  version  = "2.36.3";
  name     = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/LedgerHQ/${pname}/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
    sha256 = "1sxsr70nm86fyx2m3wf694x1p6kvmkwxw6fqnslpbyjpyi9x73cd";
  };
}
