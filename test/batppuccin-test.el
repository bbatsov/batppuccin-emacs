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

(defconst batppuccin-test--source-file
  (expand-file-name
   "../batppuccin.el"
   (file-name-directory (or load-file-name buffer-file-name default-directory)))
  "Path to the theme source, for the checks that read it as text.")

(defun batppuccin-test--palette (variant)
  "Return the colors-alist for VARIANT."
  (symbol-value (intern (format "%s-colors-alist" variant))))

(defun batppuccin-test--luminance (hex)
  "Return the WCAG relative luminance of the color HEX."
  (let ((channels (mapcar
                   (lambda (offset)
                     (let ((v (/ (string-to-number
                                  (substring hex offset (+ offset 2)) 16)
                                 255.0)))
                       (if (<= v 0.04045) (/ v 12.92)
                         (expt (/ (+ v 0.055) 1.055) 2.4))))
                   '(1 3 5))))
    (+ (* 0.2126 (nth 0 channels))
       (* 0.7152 (nth 1 channels))
       (* 0.0722 (nth 2 channels)))))

(defun batppuccin-test--contrast (a b)
  "Return the WCAG contrast ratio between the colors A and B."
  (let* ((la (batppuccin-test--luminance a))
         (lb (batppuccin-test--luminance b))
         (lighter (max la lb)) (darker (min la lb)))
    (/ (+ lighter 0.05) (+ darker 0.05))))

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

    (it "scales asciidoc titles"
      (expect (batppuccin-test--face-attr 'asciidoc-document-title-face 'batppuccin-mocha :height) :to-equal 1.4)
      (expect (batppuccin-test--face-attr 'asciidoc-title-1-face 'batppuccin-mocha :height) :to-equal 1.3)
      (expect (batppuccin-test--face-attr 'asciidoc-title-2-face 'batppuccin-mocha :height) :to-equal 1.2)
      (expect (batppuccin-test--face-attr 'asciidoc-title-3-face 'batppuccin-mocha :height) :to-equal 1.1))

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
        (expect (batppuccin-test--face-attr face 'batppuccin-mocha :height) :to-equal 1.0))))

  (describe "with custom scale factors"
    (before-each
      (let ((batppuccin-scale-headings t)
            (batppuccin-height-1 2.0)
            (batppuccin-height-doc-title 2.5))
        (batppuccin-test--reload 'batppuccin-mocha)))

    (it "honors the per-level height factors"
      (expect (batppuccin-test--face-attr 'outline-1 'batppuccin-mocha :height) :to-equal 2.0)
      (expect (batppuccin-test--face-attr 'markdown-header-face-1 'batppuccin-mocha :height) :to-equal 2.0)
      (expect (batppuccin-test--face-attr 'org-document-title 'batppuccin-mocha :height) :to-equal 2.5))))

;;; Appearance options

(describe "italic comments"
  (after-each
    (dolist (v batppuccin-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  (it "renders comments italic by default"
    (batppuccin-test--reload 'batppuccin-mocha)
    (expect (batppuccin-test--face-attr 'font-lock-comment-face 'batppuccin-mocha :slant) :to-equal 'italic)
    (expect (batppuccin-test--face-attr 'font-lock-doc-face 'batppuccin-mocha :slant) :to-equal 'italic))

  (it "drops the italic when disabled"
    (let ((batppuccin-italic-comments nil))
      (batppuccin-test--reload 'batppuccin-mocha))
    (expect (batppuccin-test--face-attr 'font-lock-comment-face 'batppuccin-mocha :slant) :to-equal 'normal)
    (expect (batppuccin-test--face-attr 'font-lock-doc-face 'batppuccin-mocha :slant) :to-equal 'normal)))

(describe "flat mode line"
  (after-each
    (dolist (v batppuccin-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  (it "boxes the mode line by default"
    (batppuccin-test--reload 'batppuccin-mocha)
    (expect (batppuccin-test--face-attr 'mode-line 'batppuccin-mocha :box) :not :to-be nil))

  (it "drops the box when flat"
    (let ((batppuccin-flat-mode-line t))
      (batppuccin-test--reload 'batppuccin-mocha))
    (expect (batppuccin-test--face-attr 'mode-line 'batppuccin-mocha :box) :to-be nil)
    (expect (batppuccin-test--face-attr 'mode-line-inactive 'batppuccin-mocha :box) :to-be nil)))

(describe "variable-pitch headings"
  (after-each
    (dolist (v batppuccin-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  (it "leaves headings fixed-pitch by default"
    (batppuccin-test--reload 'batppuccin-mocha)
    (expect (batppuccin-test--face-attr 'outline-1 'batppuccin-mocha :inherit) :to-equal 'default))

  (it "switches headings to variable-pitch when enabled"
    (let ((batppuccin-use-variable-pitch t))
      (batppuccin-test--reload 'batppuccin-mocha))
    (dolist (face '(outline-1 org-document-title markdown-header-face-1
                    asciidoc-title-1-face shr-h1 info-title-1))
      (expect (batppuccin-test--face-attr face 'batppuccin-mocha :inherit) :to-equal 'variable-pitch))))

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

;;; Text has to be readable on its own background

(defconst batppuccin-test--dim-colors
  '("bat-overlay0" "bat-overlay1" "bat-overlay2"
    "bat-surface0" "bat-surface1" "bat-surface2")
  "Palette entries Catppuccin hands to de-emphasized text.
A face reaching for one of these is asking to recede, so it opts out of
the contrast floor rather than needing an entry in an exception list.")

(defconst batppuccin-test--legibility-floor 3.0
  "Contrast a face's own text must reach against its own background.")

(defconst batppuccin-test--latte-legibility-floor 2.3
  "The same floor for Latte, which the palette holds back.
Catppuccin's light accents are mid-luminance pastels, so text on an
accent background cannot reach 3:1 whichever direction it goes: dark text
on Latte's red manages 1.47 and light text 2.34.  That is the palette
rather than the mapping, so this pins the current worst value instead of
demanding a number the colors cannot deliver.")

(defun batppuccin-test--dim-p (variant color)
  "Return non-nil if COLOR is one of VARIANT's de-emphasized entries."
  (let ((palette (batppuccin-test--palette variant)))
    (seq-some (lambda (name) (equal color (cdr (assoc name palette))))
              batppuccin-test--dim-colors)))

(describe "text on its own background"
  (after-each
    (dolist (v batppuccin-test--variants)
      (when (custom-theme-enabled-p v) (disable-theme v))))

  (dolist (variant batppuccin-test--variants)
    (it (format "stays readable in %s" variant)
      (batppuccin-test--reload variant)
      (let ((floor (if (eq variant 'batppuccin-latte)
                       batppuccin-test--latte-legibility-floor
                     batppuccin-test--legibility-floor))
            (illegible '()))
        (mapatoms
         (lambda (sym)
           (let ((fg (batppuccin-test--face-attr sym variant :foreground))
                 (bg (batppuccin-test--face-attr sym variant :background)))
             (when (and (stringp fg) (stringp bg)
                        ;; ansi and term color faces set foreground and
                        ;; background alike on purpose
                        (not (string-match-p "\\`\\(ansi\\|term\\)-color-" (symbol-name sym)))
                        (not (batppuccin-test--dim-p variant fg))
                        (< (batppuccin-test--contrast fg bg) floor))
               (push (list sym (batppuccin-test--contrast fg bg)) illegible)))))
        (expect illegible :to-equal '())))))

;;; Backgrounds that match the buffer background

(defconst batppuccin-test--flat-background-faces
  '(default fringe term
    line-number line-number-current-line
    line-number-major-tick line-number-minor-tick
    centaur-tabs-selected centaur-tabs-selected-modified
    tab-bar-tab tab-bar-tab-group-current tab-line-tab tab-line-tab-current)
  "Faces allowed to set `:background' to the variant's own `bat-base'.
Setting it elsewhere lifts nothing and punches through whatever is
underneath, such as `hl-line' or `region'.")

(describe "faces sitting on the buffer background"
  (after-each
    (dolist (v batppuccin-test--variants)
      (when (custom-theme-enabled-p v) (disable-theme v))))

  (dolist (variant batppuccin-test--variants)
    (it (format "only lets the allowed faces match bat-base in %s" variant)
      (batppuccin-test--reload variant)
      (let ((bg (cdr (assoc "bat-base" (batppuccin-test--palette variant))))
            (offenders '()))
        (mapatoms
         (lambda (sym)
           (when (and (assoc variant (get sym 'theme-face))
                      (equal (batppuccin-test--face-attr sym variant :background) bg)
                      (not (memq sym batppuccin-test--flat-background-faces)))
             (push sym offenders))))
        (expect offenders :to-equal '())))))

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

;;; Package coverage smoke tests

(describe "diredfl face coverage"
  (after-each
    (dolist (v batppuccin-test--variants)
      (when (custom-theme-enabled-p v)
        (disable-theme v))))

  (dolist (variant batppuccin-test--variants)
    (it (format "defines every diredfl-* face in %s" variant)
      (batppuccin-test--reload variant)
      (dolist (face '(diredfl-file-name diredfl-file-suffix
                      diredfl-compressed-file-name diredfl-compressed-file-suffix
                      diredfl-ignored-file-name diredfl-deletion-file-name
                      diredfl-deletion diredfl-dir-heading diredfl-dir-name
                      diredfl-dir-priv diredfl-symlink diredfl-link-priv
                      diredfl-executable-tag diredfl-exec-priv diredfl-read-priv
                      diredfl-write-priv diredfl-no-priv diredfl-other-priv
                      diredfl-rare-priv diredfl-date-time diredfl-number
                      diredfl-flag-mark diredfl-flag-mark-line
                      diredfl-autofile-name diredfl-tagged-autofile-name))
        (expect (assoc variant (get face 'theme-face)) :not :to-be nil)))))

(defconst batppuccin-test--package-faces
  '((anzu anzu-mode-line anzu-match-1 anzu-match-2 anzu-match-3
          anzu-replace-highlight anzu-replace-to)
    (jinx jinx-misspelled jinx-highlight jinx-save jinx-key jinx-annotation)
    (keycast keycast-key keycast-command)
    (completion-preview completion-preview completion-preview-common
                        completion-preview-exact)
    (dictionary dictionary-word-entry-face dictionary-word-definition-face
                dictionary-reference-face dictionary-button-face)
    (asciidoc-mode asciidoc-document-title-face asciidoc-title-1-face
                   asciidoc-title-5-face asciidoc-markup-face
                   asciidoc-code-face asciidoc-link-face asciidoc-url-face
                   asciidoc-metadata-key-face asciidoc-highlight-face
                   asciidoc-admonition-note-label-face
                   asciidoc-admonition-note-face
                   asciidoc-admonition-tip-label-face
                   asciidoc-admonition-important-label-face
                   asciidoc-admonition-caution-label-face
                   asciidoc-admonition-warning-label-face
                   asciidoc-admonition-warning-face)
    (cider cider-repl-result-face cider-fringe-bad-face
           cider-fringe-stale-face cider-reader-conditional-face
           cider-debug-prompt-face nrepl-message-1-face nrepl-message-8-face)
    (corfu corfu-popupinfo)
    (inf-ruby inf-ruby-result-overlay-face)
    (volatile-highlights vhl/default-face)
    (vundo vundo-node vundo-stem vundo-branch-stem vundo-highlight
           vundo-saved vundo-last-saved vundo-diff-highlight)
    (easy-kill easy-kill-selection easy-kill-origin)
    (copilot copilot-overlay-face)
    (mistty mistty-fringe-face)
    (clojure-mode clojure-keyword-face clojure-character-face
                  clojure-discard-face)
    (git-timemachine git-timemachine-commit
                     git-timemachine-minibuffer-author-face
                     git-timemachine-minibuffer-detail-face)
    (haskell-mode haskell-keyword-face haskell-type-face
                  haskell-constructor-face haskell-definition-face
                  haskell-operator-face haskell-pragma-face
                  haskell-hole-face haskell-error-face haskell-warning-face
                  haskell-interactive-face-prompt
                  haskell-interactive-face-compile-error
                  haskell-interactive-face-result)
    (erlang erlang-font-lock-exported-function-name-face
            erlang-edoc-heading erlang-edoc-tag erlang-edoc-macro
            erlang-edoc-verbatim erlang-edoc-todo)
    (breadcrumb breadcrumb-face breadcrumb-imenu-leaf-face
                breadcrumb-imenu-crumbs-face breadcrumb-imenu-base-face
                breadcrumb-project-leaf-face breadcrumb-project-crumbs-face
                breadcrumb-project-base-face)
    (gptel gptel-context-highlight-face gptel-context-deletion-face
           gptel-rewrite-highlight-face gptel-response-highlight
           gptel-response-fringe-highlight))
  "Alist of (PACKAGE . FACES) the theme is expected to cover.")

(describe "package face coverage"
  (before-all
    (batppuccin-test--reload 'batppuccin-mocha))
  (after-all
    (disable-theme 'batppuccin-mocha))

  (dolist (entry batppuccin-test--package-faces)
    (let ((package (car entry))
          (faces (cdr entry)))
      (it (format "themes %s" package)
        (dolist (face faces)
          (expect (assq 'batppuccin-mocha (get face 'theme-face))
                  :to-be-truthy)))))

  (it "gives jinx-misspelled the same underline as flyspell-incorrect"
    (expect (batppuccin-test--face-attr 'jinx-misspelled 'batppuccin-mocha :underline)
            :to-equal
            (batppuccin-test--face-attr 'flyspell-incorrect 'batppuccin-mocha :underline)))

  (it "styles inf-ruby's result overlay like cider's"
    (dolist (attr '(:foreground :background :box))
      (expect (batppuccin-test--face-attr 'inf-ruby-result-overlay-face 'batppuccin-mocha attr)
              :to-equal
              (batppuccin-test--face-attr 'cider-result-overlay-face 'batppuccin-mocha attr)))))
;;; The shape of the source itself

(defun batppuccin-test--face-body ()
  "Return the part of the source holding the face definitions."
  (with-temp-buffer
    (insert-file-contents batppuccin-test--source-file)
    (goto-char (point-min))
    (search-forward "batppuccin--apply-theme")
    (buffer-substring-no-properties (point) (point-max))))

(defun batppuccin-test--matches (regexp string &optional group)
  "Return every GROUP match of REGEXP in STRING."
  (let ((start 0) (found '()))
    (while (string-match regexp string start)
      (push (match-string (or group 1) string) found)
      (setq start (match-end 0)))
    (nreverse found)))

(describe "the source"
  (it "defines each face exactly once"
    (let* ((faces (batppuccin-test--matches
                   "`(\\([^ ()]+\\) ((,class" (batppuccin-test--face-body)))
           (seen (make-hash-table :test 'equal)) (dupes '()))
      (dolist (face faces)
        (when (gethash face seen) (push face dupes))
        (puthash face t seen))
      (expect (delete-dups dupes) :to-equal '())))

  (it "takes every color from the palette rather than hardcoding it"
    (expect (batppuccin-test--matches
             ":\\(?:fore\\|back\\)ground \\(\"#[0-9a-fA-F]\\{6\\}\"\\)"
             (batppuccin-test--face-body))
            :to-equal '()))

  (it "only refers to colors the palette defines"
    (let* ((defined (mapcar #'car (batppuccin-test--palette 'batppuccin-mocha)))
           (used (delete-dups (batppuccin-test--matches
                               ",\\(bat-[a-z0-9-]+\\)" (batppuccin-test--face-body)))))
      (expect (seq-remove (lambda (name) (member name defined)) used)
              :to-equal '()))))

;;; Package headers

(defconst batppuccin-test--source-files
  (let ((dir (file-name-directory batppuccin-test--source-file)))
    (mapcar (lambda (name) (expand-file-name name dir))
            '("batppuccin.el" "batppuccin-mocha-theme.el" "batppuccin-macchiato-theme.el"
              "batppuccin-frappe-theme.el" "batppuccin-latte-theme.el")))
  "Every hand-written file that ships in the package.")

(defun batppuccin-test--file-text (file)
  (with-temp-buffer (insert-file-contents file) (buffer-string)))

(describe "package headers"
  (dolist (file batppuccin-test--source-files)
    (let ((name (file-name-nondirectory file)))
      (it (format "%s opens with a summary and a lexical-binding cookie" name)
        (expect (car (split-string (batppuccin-test--file-text file) "\n"))
                :to-match (rx-to-string '(seq ";;; " (1+ nonl) " --- " (1+ nonl)
                                              "-*- lexical-binding: t; -*-"))))
      (it (format "%s closes with the conventional footer" name)
        (expect (string-trim-right (batppuccin-test--file-text file))
                :to-match (rx-to-string `(seq ";;; " ,name " ends here" eos))))))

  (it "declares the headers a package needs"
    (let ((text (batppuccin-test--file-text batppuccin-test--source-file)))
      (dolist (header '("Author" "URL" "Version" "Package-Requires" "Keywords"))
        (expect (string-match-p (concat "^;; " header ": ") text) :not :to-be nil))))

  (it "declares a Package-Requires that reads back as an alist"
    (let* ((text (batppuccin-test--file-text batppuccin-test--source-file))
           (_ (string-match "^;; Package-Requires: \\(.*\\)$" text))
           (deps (car (read-from-string (match-string 1 text)))))
      (expect (assq 'emacs deps) :not :to-be nil))))

;;; Emphasis restraint

(describe "emphasis"
  (after-each
    (dolist (v batppuccin-test--variants)
      (when (custom-theme-enabled-p v) (disable-theme v))))

  (it "never stacks three emphasis attributes on one face"
    (batppuccin-test--reload 'batppuccin-mocha)
    (let ((overwrought '()))
      (mapatoms
       (lambda (sym)
         (when (assoc 'batppuccin-mocha (get sym 'theme-face))
           (when (> (seq-count (lambda (attr)
                                 (batppuccin-test--face-attr sym 'batppuccin-mocha attr))
                               '(:weight :slant :underline :box :overline :strike-through))
                    2)
             (push sym overwrought)))))
      (expect overwrought :to-equal '()))))

;;; Public API

(describe "the public API"
  (after-each
    (dolist (v batppuccin-test--variants)
      (when (custom-theme-enabled-p v) (disable-theme v)))
    (setq batppuccin-override-colors-alist '()))

  (it "reads a color from the active variant"
    (batppuccin-test--reload 'batppuccin-mocha)
    (expect (batppuccin-get-color "bat-base") :to-equal "#1e1e2e"))

  (it "reads a color from a variant that isn't active"
    (batppuccin-test--reload 'batppuccin-mocha)
    (expect (batppuccin-get-color "bat-base" 'batppuccin-latte) :to-equal "#eff1f5"))

  ;; `enable-theme-functions' only exists from Emacs 29.  Without this, every
  ;; command reading the active variant fails on 27 and 28, which the package
  ;; claims to support.
  (it "knows the active variant without enable-theme-functions"
    (let ((enable-theme-functions nil) (disable-theme-functions nil))
      (setq batppuccin--current nil)
      (batppuccin-test--reload 'batppuccin-frappe)
      (expect batppuccin--current :to-be 'batppuccin-frappe)
      (expect (batppuccin-get-color "bat-base") :to-equal "#303446")))

  (it "binds palette colors inside batppuccin-with-colors"
    (batppuccin-test--reload 'batppuccin-mocha)
    (expect (batppuccin-with-colors bat-base) :to-equal "#1e1e2e"))

  (it "lets batppuccin-override-colors-alist win"
    (batppuccin-test--reload 'batppuccin-mocha)
    (setq batppuccin-override-colors-alist '(("bat-base" . "#000000")))
    (expect (batppuccin-get-color "bat-base") :to-equal "#000000"))

  (it "reapplies an override on reload"
    (batppuccin-test--reload 'batppuccin-mocha)
    (setq batppuccin-override-colors-alist '(("bat-base" . "#010203")))
    (batppuccin-reload)
    (expect (batppuccin-test--face-attr 'default 'batppuccin-mocha :background)
            :to-equal "#010203"))

  (it "renders the palette buffer without error"
    (batppuccin-test--reload 'batppuccin-mocha)
    (batppuccin-list-colors)
    (expect (get-buffer "*Batppuccin Palette: batppuccin-mocha*") :not :to-be nil)))

;;; Switching between variants

(describe "batppuccin-select"
  (after-each
    (dolist (v batppuccin-test--variants)
      (when (custom-theme-enabled-p v) (disable-theme v))))

  (it "leaves exactly one variant enabled"
    (batppuccin-test--reload 'batppuccin-mocha)
    (spy-on 'completing-read :and-return-value "batppuccin-latte")
    (batppuccin-select)
    (expect (seq-filter #'custom-theme-enabled-p batppuccin-test--variants)
            :to-equal '(batppuccin-latte)))

  (it "runs batppuccin-after-load-hook with the chosen variant"
    (let* ((seen '())
           (batppuccin-after-load-hook (list (lambda (theme) (push theme seen)))))
      (spy-on 'completing-read :and-return-value "batppuccin-frappe")
      (batppuccin-select)
      (expect seen :to-equal '(batppuccin-frappe)))))

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
