;; author: Hua Liang [Stupid ET]
;; Time-stamp: <2013-12-20 17:38:13 星期五 by Hua Liang>

;; ==================== flymake ====================
;; flymake
;; 对于c/c++，Makefile需要加上
;; check-syntax:
;;     gcc -Wall -Wextra -pedantic -fsyntax-only $(CHK_SOURCES)



;; I want to see at most the first 4 errors for a line.
(setq flymake-number-of-errors-to-display 4)


;; ==================== temp file ====================
;; Nope, I want my copies in the system temp dir.
(setq flymake-run-in-place nil)
;; This lets me say where my temp dir is.
(setq temporary-file-directory "~/.emacs.d/tmp/")
;; -------------------- temp file --------------------


;; ==================== privilege ====================
;; ;; http://www.emacswiki.org/emacs/FlyMake#toc14
;; (defun cwebber/safer-flymake-find-file-hook ()
;;   "Don't barf if we can't open this flymake file"
;;   (let ((flymake-filename
;;          (flymake-create-temp-inplace (buffer-file-name) "flymake")))
;;     (if (file-writable-p flymake-filename)
;;         (flymake-find-file-hook)
;;       (message
;;        (format
;;         "Couldn't enable flymake; permission denied on %s" flymake-filename)))))

;; (add-hook 'find-file-hook 'cwebber/safer-flymake-find-file-hook)
;; -------------------- privilege --------------------


;; ;; ==================== pylint ====================
;; (when (load "flymake" t)
;;   (defun flymake-pylint-init ()
;;     (let* ((temp-file (flymake-init-create-temp-buffer-copy
;; 		       'flymake-create-temp-inplace))
;;            (local-file (file-relative-name
;;                         temp-file
;;                         (file-name-directory buffer-file-name))))
;;       (list "epylint" (list local-file))))
;;   (add-to-list 'flymake-allowed-file-name-masks
;; 	       '("\\.py\\'" flymake-pylint-init)))
;; ;; -------------------- pylint --------------------

(setq flymake-gui-warnings-enabled nil) ;烦死了
(setq flymake-log-level 0)

(when (load "flymake" t)
  (defun flymake-create-temp-in-system-tempdir (filename prefix)
    (make-temp-file (or prefix "flymake")))

  (defun flymake-pyflakes-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-in-system-tempdir))
	   (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name))))
      (list "pycheckers"  (list local-file))
      ))

  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pyflakes-init))

  ;; python-mode不自动启动flymake
  (add-hook 'find-file-hook '(lambda ()
                               (when (not (equal major-mode 'python-mode))
                                 (flymake-find-file-hook)
                                 )
                               ))

  )


(load-library "flymake-cursor")

(global-set-key "\C-c\C-ep" 'flymake-goto-prev-error)
(global-set-key "\C-c\C-en" 'flymake-goto-next-error)
;; -------------------- flymake --------------------


;; (provide 'my-flymake-settings.el)
