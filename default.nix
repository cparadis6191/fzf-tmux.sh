{ fzf, stdenv, tmux, ... }:

stdenv.mkDerivation {
  pname = "fzf-tmux";
  version = "0.0.1";

  src = ./.;

  buildInputs = [ fzf tmux ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin/

    install -D ./bin/__fzf_tmux_fzf               $out/bin/
    install -D ./bin/_fzf_tmux_capture_pane_lines $out/bin/
    install -D ./bin/_fzf_tmux_capture_pane_words $out/bin/

    mkdir --parents $out/share/fzf-tmux/

    install -D ./fzf-tmux.fish    $out/share/fzf-tmux/
    install -D ./fzf-tmux.inputrc $out/share/fzf-tmux/

    runHook postInstall
  '';

  outputs = [ "out" ];
}
