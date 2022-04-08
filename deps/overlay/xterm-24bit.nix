{ runCommand, ncurses, ... }:
let
  name         = "xterm-24bit";
  terminfo     = "${name}.terminfo";
  terminfoFile = ./. + "/${terminfo}";
  terminfoDir  = "$out/share/terminfo";
in runCommand name {} ''
  mkdir -p "${terminfoDir}"
  echo '${builtins.readFile terminfoFile}' > ${terminfo}
  ${ncurses}/bin/tic -x -o "${terminfoDir}" ${terminfo}
''
