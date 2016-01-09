;;; packages.el --- ecmascript Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2015 Sylvain Benner
;; Copyright (c) 2014-2015 Andrea Moretti & Contributors
;;
;; Author: Andrea Moretti <axyzxp@gmail.com>
;; URL: https://github.com/axyz
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq ecmascript-packages
      '(
        company
        company-tern
        flycheck
        js-doc
        js2-mode
        js2-refactor
        tern
        web-beautify
        web-mode
        ))

(when (configuration-layer/layer-usedp 'auto-completion)
  (defun ecmascript/post-init-company ()
    (spacemacs|add-company-hook ecmascript-mode))

  (defun ecmascript/post-init-company-tern ()
    (push 'company-tern company-backends-ecmascript-mode)))

(defun ecmascript/pre-init-flycheck ()
  (spacemacs|use-package-add-hook flycheck
    :post-config
    (progn
      (flycheck-add-mode 'javascript-eslint 'ecmascript-mode)

      (defun ecmascript/disable-jshint ()
        (push 'javascript-jshint flycheck-disabled-checkers))

      (add-hook 'ecmascript-mode-hook #'ecmascript/disable-jshint))))

(defun ecmascript/post-init-flycheck ()
  (spacemacs/add-flycheck-hook 'ecmascript-mode-hook))

(defun ecmascript/post-init-js-doc ()
  (add-hook 'ecmascript-mode-hook 'spacemacs/js-doc-require)
  (spacemacs/js-doc-set-key-bindings 'ecmascript-mode))

(defun ecmascript/post-init-js2-mode ()
  (add-hook 'ecmascript-mode-hook 'js2-imenu-extras-mode)
  (add-hook 'ecmascript-mode-hook 'js2-minor-mode))

(defun ecmascript/post-init-js2-refactor ()
  (add-hook 'ecmascript-mode-hook 'spacemacs/js2-refactor-require)
  (spacemacs/js2-refactor-set-key-bindings 'ecmascript-mode))

(defun ecmascript/post-init-tern ()
  (add-hook 'ecmascript-mode-hook 'tern-mode))

(defun ecmascript/post-init-web-beautify ()
  (spacemacs/set-leader-keys-for-major-mode 'ecmascript-mode  "=" 'web-beautify-js))

(defun ecmascript/post-init-web-mode ()
  (define-derived-mode ecmascript-mode web-mode "ecmascript")
  (add-to-list 'auto-mode-alist '("\\.jsx\\'" . ecmascript-mode))
  (add-to-list 'auto-mode-alist '("\\.react.js\\'" . ecmascript-mode))
  (add-to-list 'auto-mode-alist '("\\index.android.js\\'" . ecmascript-mode))
  (add-to-list 'auto-mode-alist '("\\index.ios.js\\'" . ecmascript-mode))
  (add-to-list 'magic-mode-alist '("/** @jsx React.DOM */" . ecmascript-mode))
  (defun spacemacs//setup-ecmascript-mode ()
    "Adjust web-mode to accommodate ecmascript-mode"
    (emmet-mode 0)
    ;; See https://github.com/CestDiego/emmet-mode/commit/3f2904196e856d31b9c95794d2682c4c7365db23
    (setq-local emmet-expand-jsx-className? t)
    ;; Enable js-mode snippets
    (yas-activate-extra-mode 'js-mode)
    ;; Force jsx content type
    (web-mode-set-content-type "jsx")
    ;; Why do we do this ?
    (defadvice web-mode-highlight-part (around tweak-jsx activate)
      (let ((web-mode-enable-part-face nil))
        ad-do-it)))
  (add-hook 'ecmascript-mode-hook 'spacemacs//setup-ecmascript-mode))
