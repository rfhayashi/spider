;; -*- lexical-binding: t; -*-

;; TODO setup proper dependency
(use-package webdriver)
(use-package s)
(use-package websocket)

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

(defun spider-reload-page ()
  (interactive)
  (with-spider-session s
    (webdriver-refresh s)))

(evil-define-state spider-hints
  "Spider Hints state"
  :tag "<SpiderHints>"
  :supress-keymap t)

(defun spider-disable-follow-links ()
  (interactive)
  (setq evil-spider-hints-state-map evil-suppress-map)
  (evil-spider-state))

;; TODO create links
(defun spider-follow-links ()
  (interactive)
  (let ((map (make-sparse-keymap)))
    (set-keymap-parent map evil-suppress-map)
    (define-key map (kbd "ESC") 'spider-disable-follow-links)
    (setq evil-spider-hints-state-map map)
    (evil-spider-hints-state)))

(evil-define-state spider-hints
  "Spider Hints state"
  :tag "<SpiderHints>"
  :supress-keymap t)

(defun spider-message ()
  (interactive)
  (message "hello spider"))

(defun spider-disable-follow-links ()
  (interactive)
  (setq evil-spider-hints-state-map evil-suppress-map)
  (evil-spider-state))

(cl-labels
    ((clickable-elements ()
       (with-spider-session s
	 (webdriver-find-elements s (make-instance 'webdriver-by :strategy "tag name" :selector "a"))))

     (element-rect (el)
       (with-spider-session s
	 (webdriver-get-element-rect s el)))

     (add-hint (el)
       (let* ((rect (element-rect el))
	      (script (s-format (with-temp-buffer
				  (insert-file-contents "js/hints.js")
				  (buffer-string))
				'aget
				`((left . ,(slot-value rect 'x))
				  (top . ,(slot-value rect 'y))
				  (keybinding "A"))) ))
	 (with-spider-session s script []))))
  (defun spider-follow-links ()
    (interactive)
    (with-spider-session s
      (webdriver-execute-synchronous-script s "var hints = document.createElement('div');\nhints.id = 'spider-hints';\ndocument.body.appendChild(hints);" []))
    (seq-doseq (el (clickable-elements))
      (message (prin1-to-string el))
      (add-hint el)) 
    (let ((map (make-sparse-keymap)))
      (set-keymap-parent map evil-spider-state-map)
      (define-key map (kbd "ESC") 'spider-disable-follow-links)
      (setq evil-spider-hints-state-map map)
      (evil-spider-hints-state))))

;; evil key bindings

(evil-define-state spider
  "Spider state"
  :tag "<Spider>"
  :suppress-keymap t)

(evil-global-set-key 'spider (kbd "ESC") 'evil-normal-state)
(evil-global-set-key 'spider (kbd "j") 'spider-scroll-down)
(evil-global-set-key 'spider (kbd "k") 'spider-scroll-up)
(evil-global-set-key 'spider (kbd "gg") 'spider-scroll-top)
(evil-global-set-key 'spider (kbd "G") 'spider-scroll-bottom)
(evil-global-set-key 'spider (kbd "r") 'spider-reload-page)
(evil-global-set-key 'spider (kbd "f") 'spider-follow-links)

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
