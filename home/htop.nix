{ ... }:
{
  programs.htop = {
    enable            = true ;
    hideKernelThreads = false;
    showThreadNames   = true ;
    highlightThreads  = true ;
    #treeView          = true ;
    detailedCpuTime   = true ;
    delay             = 15   ;
    showProgramPath   = false;
  };
}
