{settings,...}:
{
  default-timeout  = 5000;
  ignore-timeout   = 1;
  font             = "${settings.style.font} 9";
  background-color = "#801a00D0";
  text-color       = "#ffffffD0";
  border-color     = "#cc2900D0";
  progress-color   = "#cc2900D0";
}

map (n: fields.${n}) cfg.fields

# default-timeout=5000
# ignore-timeout=1
# font=Hack 9
# background-color=#801a00D0
# text-color=#ffffffD0
# border-color=#cc2900D0
# progress-color=#cc2900D0
