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
