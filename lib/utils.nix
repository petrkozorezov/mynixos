#
# TODO:
#  - add 'try' to testAssert
#
{ lib, ... }: {
  evalOpt = file: type: value:
    (lib.evalOptionValue [] (lib.mkOption { inherit type; }) [{ inherit file value; }] ).value;

  boolToString =
    bool: if bool then "true" else "false";

}
