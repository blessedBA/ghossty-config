if status is-interactive
    set -g fish_greeting

    set -gx EDITOR vim
    set -gx VISUAL $EDITOR
    set -gx PAGER less

    set -x CDPATH . ~ ~/Documents ~/Documents/GitHub

    # hybrid vi: vi + emacs бинды поверх
    function fish_user_key_bindings
        fish_default_key_bindings -M insert
        fish_vi_key_bindings --no-erase insert
    end

    # формы курсора по режимам
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_replace underscore
    set fish_cursor_visual block
    set fish_cursor_external line

    # aliases
    alias ll="ls -lah"
    alias la="ls -A"
    alias ..="cd .."
    alias ...="cd ../.."

    alias gs="git status -sb"
    alias ga="git add"
    alias gc="git commit"
    alias gca="git commit --amend"
    alias gp="git push"
    alias gl="git pull --rebase"
    alias gd="git diff"
    alias lg="git log --oneline --graph --decorate --all -30"
    
    alias ta="tmux attach -t main || tmux new -s main"
    alias tls="tmux ls"

    alias iwyu="include-what-you-use"

    # abbreviations: разворачиваются во время набора
    abbr --add gco git checkout
    abbr --add gcb git checkout -b
    abbr --add gst git status -sb
    abbr --add v nvim
end

function mkcd --description "mkdir and cd"
    test (count $argv) -ge 1; or begin
        echo "usage: mkcd <dir>"
        return 1
    end
    mkdir -p -- $argv[1]; and cd -- $argv[1]
end

function fish_git_branch
    command -sq git; or return
    git rev-parse --is-inside-work-tree >/dev/null 2>/dev/null; or return

    set -l branch (git symbolic-ref --quiet --short HEAD 2>/dev/null)
    if test -z "$branch"
        set branch (git rev-parse --short HEAD 2>/dev/null)
    end

    test -n "$branch"; and echo -n " [$branch]"
end

function fish_prompt
    set -l last_status $status

    set_color brcyan
    echo -n (prompt_pwd)

    set_color bryellow
    fish_git_branch

    if test -n "$TMUX"
        set_color magenta
        echo -n " [tmux]"
    end

    if test $last_status -eq 0
        set_color brgreen
        echo -n " ❯ "
    else
        set_color brred
        echo -n " ✗ ❯ "
    end

    set_color normal
end
