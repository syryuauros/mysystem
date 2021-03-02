{ config, pkgs, ... }:

let
  gitConfig = {
    core = {
      editor = "nvim";
      pager  = "diff-so-fancy | less --tabs=4 -RFX";
    };
    merge.tool = "vimdiff";
    mergetool = {
      cmd    = "nvim -f -c \"Gvdiffsplit!\" \"$MERGED\"";
      prompt = false;
    };
    pull.rebase = false;
  };
in
{
  programs.git = {
    enable = true;
    aliases = {
      amend = "commit --amend -m";
      br = "branch";
      co = "checkout";
      st = "status";
      ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
      cm = "commit -m";
      ca = "commit -am";
      dc = "diff --cached";
    };
    extraConfig = gitConfig;
    ignores = [
      ".DS_Store"
      "result"
    ];
    signing = {
      key = "6A9DC1FC403B1F49";
      signByDefault = false;
    };
    userEmail = "wavetojj@gmail.com";
    userName = "JJ Kim";
  };
}
