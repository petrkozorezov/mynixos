{ lib, file, slib, ... }:
with lib;
with builtins;
rec {
  types = with lib.types; rec {
    attrs = attrsOf (oneOf [ str int float bool ]);
    declaration = submodule { options = {
      attrs   = mkOption { type = attrs; };
    };};
    element = submodule { options = {
      tag     = mkOption { type = str; };
      attrs   = mkOption { type = attrs; };
      content = mkOption { type = nullOr (oneOf [ elements str int float bool ]); };
    };};
    elements = listOf element;
    document = submodule { options = {
      declaration = mkOption { type = declaration; };
      rootElement = mkOption { type = element;     };
    };};
  };

  format = {
    attrs = attrs:
      concatStringsSep " " (mapAttrsToList (name: value: "${name}=\"${utils.toString value}\"") attrs);
    declaration = { attrs }:
      "<?xml ${format.attrs attrs}?>";
    element = indent: { tag, attrs, content }:
      let
        attrsStr =
          if attrs != {} then
            " ${format.attrs attrs}"
          else
            "";
        elementTail =
          if isNull content then " />" else let
            contentStr =
              if isList content then
                (if content == [] then "" else "\n${format.elements (indent + "  ") content}") + "\n${indent}"
              else
                utils.toString content;
          in
            ">${contentStr}</${tag}>";
      in "${indent}<${tag}${attrsStr}${elementTail}";
    elements = indent: elements:
      concatStringsSep "\n" (map (format.element indent) elements);
    document = { declaration, rootElement }:
      ''
        ${format.declaration    declaration}
        ${format.element     "" rootElement}
      '';
  };

  dsl = {
    declaration = attrs: { attrs = { version = "1.0"; encoding = "UTF-8"; } // attrs; };
    element     = tag: attrs: content: { inherit tag attrs content; };
    document    = declaration: rootElement: { inherit declaration rootElement; };
  };

  evalOpt = slib.utils.evalOpt file;

  utils.toString =
    value: with slib.utils;
      if isString value then value              else
      if isBool   value then boolToString value else
      if isInt    value then toString     value else
      if isFloat  value then toString     value else
      abort "Bad toString";

  tests =
    {
      simple =
        slib.testing.assertVal
          (format.document (
            evalOpt types.document (with dsl;
              document
                (declaration {})
                (element "rootNode" { attr = "42"; } [
                  (element "subNode1" {} null)
                  (element "subNode2" { attr1 = 42; attr2 = true; } null)
                  (element "subNode3" { attr1 = "hello"; attr2 = "world"; } "hello world!!!")
                  (element "subNode4" {} [])
                  (element "subNode5" {} true)
                ])
            )
          ))
          ''
            <?xml encoding="UTF-8" version="1.0"?>
            <rootNode attr="42">
              <subNode1 />
              <subNode2 attr1="42" attr2="true" />
              <subNode3 attr1="hello" attr2="world">hello world!!!</subNode3>
              <subNode4>
              </subNode4>
              <subNode5>true</subNode5>
            </rootNode>
          '';
    };
}
