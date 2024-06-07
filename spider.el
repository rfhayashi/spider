;; -*- lexical-binding: t; -*-

;; TODO setup proper dependency
(use-package webdriver)

(defvar spider-session nil)

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



