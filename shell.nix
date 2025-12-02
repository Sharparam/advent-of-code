{pkgs ? import <nixpkgs> {}, ...}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    ruby_3_4
    openssl # Needed to build some Ruby native extensions
  ];
}
