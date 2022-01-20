;;; config.el -*- lexical-binding: t; -*-

(setq user-full-name "Petr Kozorezov"
      user-mail-address "petr.kozorezov@gmail.com")

(setq doom-theme 'doom-monokai-classic)

(map!
  "C-<prior>"  'centaur-tabs-backward
  "C-<next>"   'centaur-tabs-forward
)

(cua-mode +1)
(define-key evil-insert-state-map (kbd "C-c") (lambda () (interactive) (cua-copy-region nil)))
(define-key evil-insert-state-map (kbd "C-v") (lambda () (interactive) (cua-paste nil)))
(define-key evil-insert-state-map (kbd "C-x") (lambda () (interactive) (cua-cut-region nil)))
(define-key evil-insert-state-map (kbd "C-z") 'evil-undo)
(define-key evil-insert-state-map (kbd "C-S-Z") 'evil-redo)
(setq cua-keep-region-after-copy t)

;; (global-set-key   (kbd "C-S-l"           ) 'mc/edit-lines              )
;; (global-set-key   (kbd "C-d"             ) 'mc/mark-next-like-this-word)
;; (global-set-key   (kbd "C-d"             ) 'mc/mark-all-dwim           )
;; (global-unset-key (kbd "C-<down-mouse-1>")                             )
;; (global-set-key   (kbd "C-<mouse-1>"     ) 'mc/add-cursor-on-click     )

(map!
 "<mouse-4>" (lambda () (interactive) (scroll-down 3))
 "<mouse-5>" (lambda () (interactive) (scroll-up   3))
)
