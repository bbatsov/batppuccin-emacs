;;; batppuccin-test.el --- Tests for batppuccin -*- lexical-binding: t -*-

;;; Commentary:
;;
;; Buttercup test suite for the batppuccin theme family.
;;
;; Face assertions read directly from the `theme-face' property rather
;; than going through `face-attribute' - in batch mode, faces aren't
;; recomputed to reflect theme specs, so `face-attribute' would miss
;; what the theme actually sets.  `theme-face' is the source of truth.
;;

;;; Code:

(require 'buttercup)
(require 'batppuccin)

;; Make theme files loadable.
(let ((dir (file-name-directory
            (or load-file-name buffer-file-name default-directory))))
  (add-to-list 'custom-theme-load-path
               (expand-file-name ".." dir)))

(defvar batppuccin-test--variants
  '(batppuccin-mocha batppuccin-macchiato batppuccin-frappe batppuccin-latte)
  "All theme variants exercised by the suite.")

(defun batppuccin-test--reload (variant)
  "Disable any active Batppuccin theme and (re-)load VARIANT.
Reloading re-evaluates the theme file, which picks up any let-bound
`batppuccin-scale-headings' the caller wants to exercise."
  (dolist (v batppuccin-test--variants)
    (when (custom-theme-enabled-p v)
      (disable-theme v))
    ;; Force the theme file to be re-read on the next `load-theme'.
    (put v 'theme-settings nil)
    (setq custom-known-themes (delq v custom-known-themes)))
  (load-theme variant t))

(defun batppuccin-test--face-attr (face variant attr)
  "Return ATTR from FACE's theme-face spec for VARIANT, or nil.
Reads directly from the theme-face property so we don't depend on
frame-side face recomputation (which is unreliable in batch)."
  (let* ((theme-face (get face 'theme-face))
         (entry     (assoc variant theme-face))
         (specs     (cadr entry))
         (first     (car specs))
         (props     (cadr first)))
    (plist-get props attr)))

;;; Heading scaling

(describe "batppuccin-scale-headings"
  (after-each
    (dolist (v batppuccin-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  (describe "when enabled (default)"
    (before-each
      (let ((batppuccin-scale-headings t))
        (batppuccin-test--reload 'batppuccin-mocha)))

    (it "scales outline-1..3"
      (expect (batppuccin-test--face-attr 'outline-1 'batppuccin-mocha :height) :to-equal 1.3)
      (expect (batppuccin-test--face-attr 'outline-2 'batppuccin-mocha :height) :to-equal 1.2)
      (expect (batppuccin-test--face-attr 'outline-3 'batppuccin-mocha :height) :to-equal 1.1))

    (it "leaves outline-4..8 without a :height"
      (dolist (face '(outline-4 outline-5 outline-6 outline-7 outline-8))
        (expect (batppuccin-test--face-attr face 'batppuccin-mocha :height) :to-be nil)))

    (it "scales org-document-title via h-doc"
      (expect (batppuccin-test--face-attr 'org-document-title 'batppuccin-mocha :height) :to-equal 1.4))

    (it "scales info-title-1..3"
      (expect (batppuccin-test--face-attr 'info-title-1 'batppuccin-mocha :height) :to-equal 1.3)
      (expect (batppuccin-test--face-attr 'info-title-2 'batppuccin-mocha :height) :to-equal 1.2)
      (expect (batppuccin-test--face-attr 'info-title-3 'batppuccin-mocha :height) :to-equal 1.1))

    (it "scales shr-h1..3"
      (expect (batppuccin-test--face-attr 'shr-h1 'batppuccin-mocha :height) :to-equal 1.3)
      (expect (batppuccin-test--face-attr 'shr-h2 'batppuccin-mocha :height) :to-equal 1.2)
      (expect (batppuccin-test--face-attr 'shr-h3 'batppuccin-mocha :height) :to-equal 1.1))

    (it "does not set :height on org-level-N (org inherits via outline)"
      ;; We leave org-level-N as a plain :inherit so that outline scaling
      ;; flows through. Setting :height directly would override the
      ;; inheritance chain.
      (dolist (face '(org-level-1 org-level-2 org-level-3))
        (expect (batppuccin-test--face-attr face 'batppuccin-mocha :height) :to-be nil))))

  (describe "when disabled"
    (before-each
      (let ((batppuccin-scale-headings nil))
        (batppuccin-test--reload 'batppuccin-mocha)))

    (it "leaves outline-1..3 at 1.0"
      (expect (batppuccin-test--face-attr 'outline-1 'batppuccin-mocha :height) :to-equal 1.0)
      (expect (batppuccin-test--face-attr 'outline-2 'batppuccin-mocha :height) :to-equal 1.0)
      (expect (batppuccin-test--face-attr 'outline-3 'batppuccin-mocha :height) :to-equal 1.0))

    (it "leaves org-document-title at 1.0"
      (expect (batppuccin-test--face-attr 'org-document-title 'batppuccin-mocha :height) :to-equal 1.0))

    (it "leaves info / shr top levels at 1.0"
      (dolist (face '(info-title-1 info-title-2 info-title-3
                      shr-h1 shr-h2 shr-h3))
        (expect (batppuccin-test--face-attr face 'batppuccin-mocha :height) :to-equal 1.0)))))

;;; Palette integrity

(describe "color palettes"
  (it "define the same set of color keys across all variants"
    (let ((mocha (sort (mapcar #'car batppuccin-mocha-colors-alist)      #'string<))
          (mach  (sort (mapcar #'car batppuccin-macchiato-colors-alist)  #'string<))
          (frap  (sort (mapcar #'car batppuccin-frappe-colors-alist)     #'string<))
          (latte (sort (mapcar #'car batppuccin-latte-colors-alist)      #'string<)))
      (expect mach  :to-equal mocha)
      (expect frap  :to-equal mocha)
      (expect latte :to-equal mocha)))

  (it "contain all 26 canonical Catppuccin colors"
    (dolist (alist (list batppuccin-mocha-colors-alist
                         batppuccin-macchiato-colors-alist
                         batppuccin-frappe-colors-alist
                         batppuccin-latte-colors-alist))
      (dolist (name '("bat-rosewater" "bat-flamingo" "bat-pink" "bat-mauve"
                      "bat-red" "bat-maroon" "bat-peach" "bat-yellow"
                      "bat-green" "bat-teal" "bat-sky" "bat-sapphire"
                      "bat-blue" "bat-lavender"
                      "bat-text" "bat-subtext1" "bat-subtext0"
                      "bat-overlay2" "bat-overlay1" "bat-overlay0"
                      "bat-surface2" "bat-surface1" "bat-surface0"
                      "bat-base" "bat-mantle" "bat-crust"))
        (expect (assoc name alist) :not :to-be nil))))

  (it "have hex-formatted color values"
    (dolist (alist (list batppuccin-mocha-colors-alist
                         batppuccin-macchiato-colors-alist
                         batppuccin-frappe-colors-alist
                         batppuccin-latte-colors-alist))
      (dolist (entry alist)
        (expect (cdr entry) :to-match "\\`#[0-9a-fA-F]\\{6\\}\\'")))))

;;; Code-block backgrounds

(describe "markdown-code-face background"
  (after-each
    (dolist (v batppuccin-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  ;; Regression for #10: without an explicit :background, code blocks in
  ;; Latte could end up dark via inheritance / user customization. We
  ;; anchor the background to bat-mantle in every variant.
  (dolist (variant batppuccin-test--variants)
    (it (format "sets an explicit :background in %s" variant)
      (batppuccin-test--reload variant)
      (let ((bg (batppuccin-test--face-attr 'markdown-code-face variant :background))
            (mantle (cdr (assoc "bat-mantle"
                                (symbol-value
                                 (intern (format "%s-colors-alist" variant)))))))
        (expect bg :to-equal mantle)))))

;;; Variant loading smoke tests

(describe "theme loading"
  (after-each
    (dolist (v batppuccin-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  (dolist (variant batppuccin-test--variants)
    (it (format "loads %s without error" variant)
      (expect (load-theme variant t) :to-be-truthy)
      (expect (custom-theme-enabled-p variant) :to-be-truthy))))

;;; batppuccin-test.el ends here
