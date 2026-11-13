{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gnuradio
    gqrx
    hackrf
    multimon-ng
    rtl-sdr
    rtl_433
    soapysdr-with-plugins
    soapyrtlsdr
  ];
}
