{ pkgs, inputs, system, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.file = {
    ".local/bin" = {
      source = ./bin;
      recursive = true;
    };
  };

  home.shellAliases = {
    g = "gitdefault";
    v = "visual";
    e = "editor";
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    enableSyntaxHighlighting = true;
    history = {
      extended = true;
      expireDuplicatesFirst = true;
    };
    initExtra = ''
      # Allow backspace/CTRL-H to delete past the point insert mode was entered
      bindkey -M viins '^?' backward-delete-char
      bindkey -M viins '^H' backward-delete-char

      # Press v to edit command line in text editor
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd v edit-command-line
    '';
  };

  programs.bat.enable = true;
  programs.autojump.enable = true;
  programs.fzf.enable = true;
  programs.jq.enable = true;

  programs.tmux = {
    enable = true;
    prefix = "C-Space";
    escapeTime = 0;
    baseIndex = 1;
    # TODO: Theme
  };

  home.packages = with pkgs; [ git-open unzip p7zip ffmpeg tree age ];

  programs.git = {
    enable = true;
    aliases = {
      co = "checkout";
      ci = "commit";
      di = "diff";
      dc = "diff --cached";
      fa = "fetch --all";
      pf = "push --force-with-lease";
      amend = "commit --amend";
    };
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      merge = {
        ff = "only";
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoSquash = true;
        autoStash = true;
      };
      commit = {
        verbose = true;
      };

      # Clone shorthands e.g. git clone gh:NixOS/nix -> git clone ssh://git@github.com/NixOS/nix
      url = {
        "ssh://git@github.com/" = {
          insteadOf = [ "github:" "gh:" ];
        };
      };
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;
    };
  };

  programs.readline = {
    enable = true;
    extraConfig = ''
      set editing-mode vi

      set keymap vi-insert
      Control-l: clear-screen

      set keymap vi-command
      "daw": "lbdW"
      "yaw": "lbyW"
      "caw": "lbcW"
      "diw": "lbdw"
      "yiw": "lbyw"
      "ciw": "lbcw"
      "da\"": "lF\"df\""
      "di\"": "lF\"lmtf\"d`t"
      "ci\"": "di\"i"
      "ca\"": "da\"i"
      "da'": "lF'df'"
      "di'": "lF'lmtf'd`t"
      "ci'": "di'i"
      "ca'": "da'i"
      "da`": "lF\`df\`"
      "di`": "lF\`lmtf\`d`t"
      "ci`": "di`i"
      "ca`": "da`i"
      "da(": "lF(df)"
      "di(": "lF(lmtf)d`t"
      "ci(": "di(i"
      "ca(": "da(i"
      "da)": "lF(df)"
      "di)": "lF(lmtf)d`t"
      "ci)": "di(i"
      "ca)": "da(i"
      "da{": "lF{df}"
      "di{": "lF{lmtf}d`t"
      "ci{": "di{i"
      "ca{": "da{i"
      "da}": "lF{df}"
      "di}": "lF{lmtf}d`t"
      "ci}": "di}i"
      "ca}": "da}i"
      "da[": "lF[df]"
      "di[": "lF[lmtf]d`t"
      "ci[": "di[i"
      "ca[": "da[i"
      "da]": "lF[df]"
      "di]": "lF[lmtf]d`t"
      "ci]": "di]i"
      "ca]": "da]i"
      "da<": "lF<df>"
      "di<": "lF<lmtf>d`t"
      "ci<": "di<i"
      "ca<": "da<i"
      "da>": "lF<df>"
      "di>": "lF<lmtf>d`t"
      "ci>": "di>i"
      "ca>": "da>i"
    '';
  };

  services.lorri.enable = true;
  programs.direnv.enable = true;
}
