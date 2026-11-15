{ pkgs, ... }:

let
  soapyMinimal = pkgs.soapysdr.override {
    extraPackages = with pkgs; [
      soapyhackrf
      soapyremote
      soapyrtlsdr
    ];
  };

  rtl433 = pkgs.rtl_433.override { soapysdr-with-plugins = soapyMinimal; };
in
{
  home.packages = with pkgs; [
    multimon-ng
    rtl-sdr
    rtl433
  ];
}
