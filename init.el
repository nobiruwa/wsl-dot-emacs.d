;;;;;;;;
;; basic confiurationの前に実行するスクリプト
;;;;;;;;
;;;
;; package.elの設定
;;;
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;;;;;;;;
;; basic configuration
;;;;;;;;
(let ((file (expand-file-name "~/.emacs.d/init_nobiruwa.el")))
  (if (file-exists-p file)
      (load-file file)))

;;;;;;;;
;; Clipbard
;;;;;;;;
;; xclip.elの代替
;; Ref: http://garin.jp/doc/unix/xwindow_clipboard
(defvar win32yank "/mnt/c/wslhome/bin/win32yank.exe")

(defun my-cut-function (text)
  "Copy TEXT to clipboard selection of Windows.
TEXT should be UTF-8.
This requires win32yank.exe."
  (interactive)
  (let ((process-connection-type nil)
        (coding-system-for-write 'utf-8))
    (let ((proc (start-process win32yank "*Messages*" win32yank "-i")))
      (process-send-string proc text)
      (process-send-eof proc))))

(defun my-paste-function ()
  "Paste the text from the Windows clipboard to the current buffer.
This requires win32yank.exe command."
  (interactive)
  (let ((process-connection-type nil)
        (coding-system-for-write 'utf-8))
    (let* ((command (concat win32yank " -o"))
          (clip-output (shell-command-to-string command)))
      (unless (string= (car kill-ring) clip-output)
        (insert clip-output)))))

(global-set-key (kbd "C-c C-y") 'my-paste-function)

;; pasteをセットすると、yank時に同内容のテキストが2つずつ入っているように見える
;; pasteはM-x my-xclip-paste-functionかShift-Insertで行えばよいのでnilとする
;; 前者はM-x my-p TABで展開できるうちはキーの割り当ては不要だろう
(when (and (not window-system)
           (executable-find win32yank))
  (setq interprogram-cut-function 'my-cut-function)
  (setq interprogram-paste-function nil))

;;;;;;;;
;; font
;; Xを使用する場合に有効な設定
;;;;;;;;
;; https://qiita.com/styzo/items/28d5d994a293fa704476 にある設定から抜粋
;; http://misohena.jp/blog/2017-09-26-symbol-font-settings-for-emacs25.html
(setq use-default-font-for-symbols nil)
(set-face-attribute 'default nil :family "VL Gothic" :foundry "VL  " :slant 'normal :weight 'normal :height 120 :width 'normal)
(set-fontset-font t 'japanese-jisx0208 (font-spec :family "VL Gothic"))
(set-fontset-font t 'japanese-jisx0208-1978 (font-spec :family "VL Gothic"))
(set-fontset-font t 'japanese-jisx0212 (font-spec :family "VL Gothic"))
(set-fontset-font t 'japanese-jisx0213-1 (font-spec :family "VL Gothic"))
(set-fontset-font t 'japanese-jisx0213-2 (font-spec :family "VL Gothic"))
(set-fontset-font t 'japanese-jisx0213.2004-1 (font-spec :family "VL Gothic"))
(set-fontset-font t 'jisx0201 (font-spec :family "VL Gothic"))
(set-fontset-font t 'kana (font-spec :family "VL Gothic"))

;;;;;;;;;;;;; 以下、ELispファイルを追加する必要があるものを設定 ;;;;;;
;;;;;;;;;;;;; アルファベット順になるよう努力 ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;
;; skk
;;;;;;;;
(setq skk-large-jisyo "/usr/share/skk/SKK-JISYO.L")

;;;;;;;;
;; Custom
;;;;;;;;
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(blink-cursor-mode nil)
 '(browse-url-browser-function 'browse-url-firefox)
 '(browse-url-netscape-program "netscape")
 '(column-number-mode t)
 '(custom-safe-themes
   '("0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" default))
 '(line-number-mode t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(ac-slime bash-completion browse-kill-ring cargo ccls clang-format coffee-mode company-dict company-lsp counsel ddskk dockerfile-mode elm-mode elpy emmet-mode f flycheck flycheck-pyflakes flymake god-mode gradle-mode graphviz-dot-mode groovy-mode haskell-mode howm idomenu jedi js2-mode lsp-haskell lsp-java lsp-mode lsp-ui lua-mode magit markdown-mode navi2ch nginx-mode plantuml-mode powershell purescript-mode restclient rust-mode shakespeare-mode slime solarized-theme swiper tidal treemacs typescript-mode undo-tree vue-mode web-mode wgrep xclip yaml-mode yasnippet yasnippet-classic-snippets yasnippet-snippets))
 '(safe-local-variable-values
   '((haskell-process-use-ghci . t)
     (haskell-indent-spaces . 4)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flymake-error ((t (:underline "red"))))
 '(flymake-warning ((t (:underline "yellow")))))
