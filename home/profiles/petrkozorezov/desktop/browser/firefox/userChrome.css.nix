{ deps, lib, ... }: ''
  @import url(${deps.inputs.firefox-csshacks}/chrome/autohide_sidebar.css);
  #TabsToolbar{ visibility: collapse !important }
  ''
