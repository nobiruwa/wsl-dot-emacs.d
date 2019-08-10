;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
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

;;;;;;;;;;;;; 以下、ELispファイルを追加する必要があるものを設定 ;;;;;;
;;;;;;;;;;;;; アルファベット順になるよう努力 ;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;
;; skk
;;;;;;;;
(setq skk-large-jisyo "/usr/share/skk/SKK-JISYO.L")
