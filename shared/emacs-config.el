;; Disable splash screen on startup
(setq inhibit-startup-screen t)

;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

;; Download God mode
(unless (package-installed-p 'god-mode)
  OB(package-install 'god-mode))

;; Enable Evil
(require 'god-mode)

(global-set-key (kbd "<escape>") #'god-local-mode)
