;;; edit-at-point.el --- edit current things(word,symbol..) under cursor

;;; Commentary:

;; copy/cut/delete/paste : word,symbol,string,line,parenthesis((),[], {}),function definition
;; duplicate : line,paren,defun
;; move up/down : line

;; sample keybinding config:
;; (require 'edit-at-point)
;; (require 'bind-key)
;; (bind-keys
;;   ("C-S-a". ep/word-copy)
;;   ("C-S-b". ep/word-cut)
;;   ("C-S-c". ep/word-delete)
;;   ("C-S-d". ep/word-paste)
;;   ("C-S-e". ep/symbol-copy)
;;   ("C-S-f". ep/symbol-cut)
;;   ("C-S-g". ep/symbol-delete)
;;   ("C-S-h". ep/symbol-paste)
;;   ("C-S-i". ep/str-copy)
;;   ("C-S-i". ep/str-cut)
;;   ("C-S-i". ep/str-delete)
;;   ("C-S-i". ep/str-paste)
;;   ("C-S-m". ep/line-copy)
;;   ("C-S-n". ep/line-cut)
;;   ("C-S-o". ep/line-delete)
;;   ("C-S-p". ep/line-paste)
;;   ("C-S-q". ep/line-dup)
;;   ("C-S-r". ep/line-up)
;;   ("C-S-s". ep/line-down)
;;   ("C-S-t". ep/paren-copy)
;;   ("C-S-u". ep/paren-cut)
;;   ("C-S-v". ep/paren-delete)
;;   ("C-S-w". ep/paren-paste)
;;   ("C-S-x". ep/paren-dup)
;;   ("C-S-y". ep/defun-copy)
;;   ("C-S-z". ep/defun-cut)
;;   ("C-{"  . ep/defun-delete)
;;   ("C-:"  . ep/defun-paste)
;;   ("C-\"" . ep/defun-dup))

;; Author: <e.enoson@gmail.com>
;; URL: http://github.com/enoson/edit-at-point.el
;; Version: 1.0

;;; Code:
(require 'thingatpt) ;bounds-of-thing-at-point

(defun edit-at-point (thing action)
  (while (not (setq b (bounds-of-thing-at-point thing)))
    (backward-char))
  (funcall action (car b) (cdr b)))

(defun ep/word-copy ()
  (interactive)
  (edit-at-point 'word 'kill-ring-save))

(defun ep/word-cut ()
  (interactive)
  (edit-at-point 'word 'kill-region))

(defun ep/word-delete ()
  (interactive)
  (edit-at-point 'word 'delete-region))

(defun ep/word-paste ()
  (interactive)
  (ep/word-delete)
  (yank))

(defun ep/symbol-copy ()
  (interactive)
  (edit-at-point 'symbol 'kill-ring-save))

(defun ep/symbol-cut ()
  (interactive)
  (edit-at-point 'symbol 'kill-region))

(defun ep/symbol-delete ()
  (interactive)
  (edit-at-point 'symbol 'delete-region))

(defun ep/symbol-paste ()
  (interactive)
  (ep/symbol-delete)
  (yank))

(defun edit-str-at-point (action)
  (setq p (point))
  (forward-char)
  (ignore-errors
    (while (not (nth 3 (syntax-ppss)))
      (backward-char)))
  (if (= 1 (point))
      (goto-char p)
    (goto-char (nth 8 (syntax-ppss)))
    (edit-at-point 'sexp action)))

(defun ep/str-copy ()
  (interactive)
  (edit-str-at-point 'kill-ring-save))

(defun ep/str-cut ()
  (interactive)
  (edit-str-at-point 'kill-region))

(defun ep/str-delete ()
  (interactive)
  (edit-str-at-point 'delete-region))

(defun ep/str-paste ()
  (interactive)
  (ep/str-delete)
  (yank))

(defun ep/line-copy ()
  (interactive)
  (edit-at-point 'line 'kill-ring-save))

(defun ep/line-cut ()
  (interactive)
  (setq c (current-column))
  (edit-at-point 'line 'kill-region)
  (move-to-column c))

(defun ep/line-delete ()
  (interactive)
  (setq c (current-column))
  (edit-at-point 'line 'delete-region)
  (move-to-column c))

(defun ep/line-paste ()
  (interactive)
  (setq c (current-column))
  (edit-at-point 'line 'delete-region)
  (yank)
  (move-to-column c))

(defun ep/line-dup ()
  (interactive)
  (save-excursion
    (ep/line-copy)
    (beginning-of-line)
    (yank)))

(defun ep/line-down (arg)
  (interactive "p")
  (setq c (current-column))
  (ep/line-cut)
  (forward-line arg)
  (yank)
  (if arg (forward-line -1))
  (move-to-column c))

(defun ep/line-up ()
  (interactive)
  (ep/line-down -1))

(defun is-newline-at-point ()
  (or (not (char-after)) (= 10 (char-after))))

(defun goto-str-beg ()
  (interactive)
  (let ((s (syntax-ppss)))
    (if (nth 3 s)
        (goto-char (nth 8 s)))))

(defun edit-paren-at-point (action)
  (setq char (char-after))
  (if (member char (string-to-list "([{"))
      (forward-char))
  (goto-str-beg)
  (edit-at-point 'list action))

(defun ep/paren-copy ()
  (interactive)
  (save-excursion (edit-paren-at-point 'kill-ring-save)
                  (princ (list-at-point))))

(defun ep/paren-cut ()
  (interactive)
  (edit-paren-at-point 'kill-region))

(defun ep/paren-delete ()
  (interactive)
  (edit-paren-at-point 'delete-region))

(defun ep/paren-paste ()
  (interactive)
  (ep/paren-delete)
  (yank))

(defun ep/paren-dup ()
  (interactive)
  (if (is-newline-at-point)
      (setq nl t))
  (ep/paren-copy)
  (goto-str-beg)
  (ignore-errors (up-list))
  (newline-and-indent)
  (if (boundp 'nl) (newline-and-indent))
  (yank))

(defun ep/defun-copy ()
  (interactive)
  (edit-at-point 'defun 'kill-ring-save))

(defun ep/defun-cut ()
  (interactive)
  (edit-at-point 'defun 'kill-region))

(defun ep/defun-delete ()
  (interactive)
  (edit-at-point 'defun 'delete-region))

(defun ep/defun-paste ()
  (interactive)
  (ep/defun-delete)
  (yank))

(defun ep/defun-dup ()
  (interactive)
  (ep/defun-copy)
  (end-of-thing 'defun)
  (newline-and-indent)
  (yank))

(provide 'edit-at-point)

;;; edit-at-point.el ends here
