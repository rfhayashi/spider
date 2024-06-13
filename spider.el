;; -*- lexical-binding: t; -*-

;; TODO setup proper dependency
(use-package webdriver)

(defvar spider-session nil)

(defmacro with-spider-session (session-bind &rest body)
  (declare (indent 1))
  `(progn
     (spider-open)
     (let ((,session-bind spider-session))
       ,@body)))

(defun spider-open ()
  (interactive)
  (unless spider-session
    (setq spider-session (make-instance 'webdriver-session))
    (webdriver-session-start spider-session)))

(defun spider-close ()
  (interactive)
  (when spider-session
    (webdriver-session-stop spider-session)
    (setq spider-session nil)))

(defun spider-goto-url (url)
  (interactive "M") ; TODO offer completion
  (with-spider-session s
    (webdriver-goto-url s url)))

(defun spider-scroll-down ()
  (interactive)
  (with-spider-session s
    (webdriver-execute-synchronous-script s "window.scrollByLines(1)" [])))

(defun spider-scroll-up ()
  (interactive)
  (with-spider-session s
    (webdriver-execute-synchronous-script s "window.scrollByLines(-1)" [])))

(defun spider-scroll-top ()
  (interactive)
  (with-spider-session s
    (webdriver-execute-synchronous-script s "window.scroll(0, 0)" [])))

(defun spider-scroll-bottom ()
  (interactive)
  (with-spider-session s
    (webdriver-execute-synchronous-script s "window.scroll(0, document.body.scrollHeight)" [])))

(defun spider-go-back ()
  (interactive)
  (with-spider-session s
    (webdriver-go-back s)))

(defun spider-go-forward ()
  (interactive)
  (with-spider-session s
    (webdriver-go-forward s)))

;; TODO
(defun spider-follow-link ())

;; evil key bindings
;; TODO avoid that non mapped keys insert characters in current buffer

(evil-define-state spider
  "Spider state"
  :tag "<Spider>")

;; TODO do not use general
(evil-global-set-key 'spider (kbd "ESC") 'evil-normal-state)
(evil-global-set-key 'spider (kbd "j") 'spider-scroll-down)
(evil-global-set-key 'spider (kbd "k") 'spider-scroll-up)
(evil-global-set-key 'spider (kbd "gg") 'spider-scroll-top)
(evil-global-set-key 'spider (kbd "G") 'spider-scroll-bottom)

;; REMOVE temporary for testing

(define-key space-key-map (kbd "s") 'evil-spider-state)

(defun spider-execute-buffer-js ()
  (interactive)
  (with-spider-session s
    (webdriver-execute-synchronous-script s (buffer-string) [])))

(define-minor-mode spider-js-mode "Spider JS"
  :init-value nil
  :lighter "SpiderJs"
  (when spider-js-mode
    (evil-local-set-key 'normal ",e" 'spider-execute-buffer-js)))

;; REMOVE temporary for testing
