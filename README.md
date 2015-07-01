# edit-at-point.el
edit(copy,cut...) things(word,symbol..) under cursor, if failed to find the thing, move backward until buffer beginning.

# sample keybinding config
(require 'edit-at-point)
(require 'bind-key)
(bind-keys
  ("C-S-a". ep/word-copy)
  ("C-S-b". ep/word-cut)
  ("C-S-c". ep/word-delete)
  ("C-S-d". ep/word-paste)
  ("C-S-e". ep/symbol-copy)
  ("C-S-f". ep/symbol-cut)
  ("C-S-g". ep/symbol-delete)
  ("C-S-h". ep/symbol-paste)
  ("C-S-i". ep/str-copy)
  ("C-S-i". ep/str-cut)
  ("C-S-i". ep/str-delete)
  ("C-S-i". ep/str-paste)
  ("C-S-m". ep/line-copy)
  ("C-S-n". ep/line-cut)
  ("C-S-o". ep/line-delete)
  ("C-S-p". ep/line-paste)
  ("C-S-q". ep/line-dup)
  ("C-S-r". ep/line-up)
  ("C-S-s". ep/line-down)
  ("C-S-t". ep/paren-copy)
  ("C-S-u". ep/paren-cut)
  ("C-S-v". ep/paren-delete)
  ("C-S-w". ep/paren-paste)
  ("C-S-x". ep/paren-dup)
  ("C-S-y". ep/defun-copy)
  ("C-S-z". ep/defun-cut)
  ("C-{"  . ep/defun-delete)
  ("C-:"  . ep/defun-paste)
  ("C-\"" . ep/defun-dup))

# license
Released under the MIT license
