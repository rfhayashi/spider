;; -*- lexical-binding: t; -*-

;; TODO setup proper dependency
(use-package s)
(use-package websocket)

(require 'json)

(defvar spider--ws nil)

(defvar spider--ws-server
  (websocket-server
   9999
   :host 'local
   :on-open (lambda (ws)
	      (setq spider--ws ws))))

(defun spider--send-command (command params)
  (websocket-send-text spider--ws (json-encode (list :command command :params params))))

(defun spider-goto-url (url)
  (interactive "M")
  (spider--send-command "goto-url" (list :url url))) ; TODO offer completion

(defun spider-scroll-down ()
  (interactive)
  (spider--send-command "scroll-down" nil))

(defun spider-scroll-up ()
  (interactive)
  (spider--send-command "scroll-up" nil))

(defun spider-scroll-top ()
  (interactive)
  (spider--send-command "scroll-top" nil))

(defun spider-scroll-bottom ()
  (interactive)
  (spider--send-command "scroll-bottom" nil))

(defun spider-go-back ()
  (interactive)
  (spider--send-command "go-back" nil))

(defun spider-go-forward ()
  (interactive)
  (spider--send-command "go-forward" nil))

(defun spider-reload-page ()
  (interactive)
  (spider--send-command "reload-page" nil))

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

(defun spider-test-extension ()
  (interactive)
  (let ((default-directory (expand-file-name "web" default-directory)))
    (start-process "spider" "spider" "web-ext" "run" "--url" "https://example.org")))

;; REMOVE temporary for testing
