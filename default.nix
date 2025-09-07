{ fzf, stdenv, tmux, ... }:

stdenv.mkDerivation {
  pname = "fzf-tmux";
  version = "0.0.1";

  src = ./.;

  buildInputs = [ fzf tmux ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/share/fzf-tmux.sh/

    install -D ./fzf-tmux.fish $out/share/fzf-tmux.sh/
    install -D ./fzf-tmux.sh   $out/share/fzf-tmux.sh/

    runHook postInstall
  '';

  outputs = [ "out" ];
}
