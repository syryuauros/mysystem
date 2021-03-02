{ pkgs, ... }:

{

  programs.mbsync.enable = true;
  programs.msmtp.enable = true;
  programs.notmuch = {
    enable = true;
    hooks = {
      preNew = "mbsync --all";
    };
    new.ignore = [
      ".mbsyncstate"
      ".mbsyncstate.lock"
      ".mbsyncstate.new"
      ".mbsyncstate.journal"
      ".uidvalidity"
    ];
  };

  accounts.email = {

    maildirBasePath = "Mail";

    accounts.wavetojj = {
      flavor = "gmail.com";
      address = "wavetojj@gmail.com";
      realName = "JJ Kim";
      gpg = {
        key = "6A9DC1FC403B1F49";
        signByDefault = false;
      };
      mbsync = {
        enable = true;
        create = "maildir";
      };
      msmtp.enable = true;
      notmuch.enable = true;
      primary = true;
      passwordCommand = "pass email/wavetojj@gmail.com";
      # imap.host = "imap.gmail.com";
      # smtp.host = "smtp.gmail.com";
      signature = {
        text = ''
          JJ Kim
        '';
        showSignature = "append";
      };
    };
  };

}
