;;; batppuccin.el --- Shared infrastructure for Batppuccin themes -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Bozhidar Batsov

;; Author: Bozhidar Batsov <bozhidar@batsov.dev>
;; URL: https://github.com/bbatsov/batppuccin-emacs
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1"))
;; Keywords: faces themes

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Shared color palettes and face-setting infrastructure for the Batppuccin
;; family of themes.  This file is not a theme itself -- it is required by
;; the individual theme files (batppuccin-mocha-theme.el, etc.).
;;
;; Batppuccin is an opinionated Emacs port of the Catppuccin color scheme,
;; following the official style guide while making Emacs-specific adjustments
;; for proper face usage.
;;
;; See https://github.com/catppuccin/catppuccin for the upstream spec.

;;; Code:

(require 'cl-lib)

(defgroup batppuccin nil
  "Batppuccin theme family."
  :group 'faces
  :prefix "batppuccin-"
  :link '(url-link :tag "GitHub" "https://github.com/bbatsov/batppuccin-emacs")
  :tag "Batppuccin")

(defcustom batppuccin-scale-headings t
  "Whether to scale headings in org, outline, markdown, shr, and info.
Set to nil for uniform heading sizes.  Takes effect on theme load."
  :type 'boolean
  :group 'batppuccin)

(defcustom batppuccin-override-colors-alist '()
  "Alist of color overrides applied to all variants.
Each entry should be a cons cell (NAME . VALUE) where NAME is a
color name from any variant's palette and VALUE is the
replacement hex color string."
  :type '(alist :key-type string :value-type string)
  :group 'batppuccin)

;;; Color Palettes
;;
;; Each palette uses the canonical Catppuccin color names with a "bat-" prefix.
;; The monochromatic scale runs from darkest (crust) to lightest (text) for
;; dark flavors, and is inverted for Latte.
;;
;; In addition to the 26 canonical colors, each palette includes derived
;; colors for diff backgrounds, heading cycle, and selection that follow
;; the Catppuccin style guide recommendations.

(defconst batppuccin-mocha-colors-alist
  '(;; Monochromatic scale (dark -> light)
    ("bat-crust"      . "#11111b")
    ("bat-mantle"     . "#181825")
    ("bat-base"       . "#1e1e2e")
    ("bat-surface0"   . "#313244")
    ("bat-surface1"   . "#45475a")
    ("bat-surface2"   . "#585b70")
    ("bat-overlay0"   . "#6c7086")
    ("bat-overlay1"   . "#7f849c")
    ("bat-overlay2"   . "#9399b2")
    ("bat-subtext0"   . "#a6adc8")
    ("bat-subtext1"   . "#bac2de")
    ("bat-text"       . "#cdd6f4")

    ;; Accent colors
    ("bat-rosewater"  . "#f5e0dc")
    ("bat-flamingo"   . "#f2cdcd")
    ("bat-pink"       . "#f5c2e7")
    ("bat-mauve"      . "#cba6f7")
    ("bat-red"        . "#f38ba8")
    ("bat-maroon"     . "#eba0ac")
    ("bat-peach"      . "#fab387")
    ("bat-yellow"     . "#f9e2af")
    ("bat-green"      . "#a6e3a1")
    ("bat-teal"       . "#94e2d5")
    ("bat-sky"        . "#89dceb")
    ("bat-sapphire"   . "#74c7ec")
    ("bat-blue"       . "#89b4fa")
    ("bat-lavender"   . "#b4befe")

    ;; Derived colors
    ("bat-diff-add-bg"    . "#1a3a2a")
    ("bat-diff-del-bg"    . "#3a1a2a")
    ("bat-diff-chg-bg"    . "#1a2a4a")
    ("bat-selection"      . "#45475a")
    ("bat-cursor-line"    . "#232336")

    ;; Heading cycle: red, peach, yellow, green, sapphire, lavender
    ("bat-heading1"   . "#f38ba8")
    ("bat-heading2"   . "#fab387")
    ("bat-heading3"   . "#f9e2af")
    ("bat-heading4"   . "#a6e3a1")
    ("bat-heading5"   . "#74c7ec")
    ("bat-heading6"   . "#b4befe"))
  "The Batppuccin (Mocha) color palette.
The darkest flavor.")

(defconst batppuccin-macchiato-colors-alist
  '(;; Monochromatic scale
    ("bat-crust"      . "#181926")
    ("bat-mantle"     . "#1e2030")
    ("bat-base"       . "#24273a")
    ("bat-surface0"   . "#363a4f")
    ("bat-surface1"   . "#494d64")
    ("bat-surface2"   . "#5b6078")
    ("bat-overlay0"   . "#6e738d")
    ("bat-overlay1"   . "#8087a2")
    ("bat-overlay2"   . "#939ab7")
    ("bat-subtext0"   . "#a5adcb")
    ("bat-subtext1"   . "#b8c0e0")
    ("bat-text"       . "#cad3f5")

    ;; Accent colors
    ("bat-rosewater"  . "#f4dbd6")
    ("bat-flamingo"   . "#f0c6c6")
    ("bat-pink"       . "#f5bde6")
    ("bat-mauve"      . "#c6a0f6")
    ("bat-red"        . "#ed8796")
    ("bat-maroon"     . "#ee99a0")
    ("bat-peach"      . "#f5a97f")
    ("bat-yellow"     . "#eed49f")
    ("bat-green"      . "#a6da95")
    ("bat-teal"       . "#8bd5ca")
    ("bat-sky"        . "#91d7e3")
    ("bat-sapphire"   . "#7dc4e4")
    ("bat-blue"       . "#8aadf4")
    ("bat-lavender"   . "#b7bdf8")

    ;; Derived colors
    ("bat-diff-add-bg"    . "#1e3d2e")
    ("bat-diff-del-bg"    . "#3d1e2e")
    ("bat-diff-chg-bg"    . "#1e2e4e")
    ("bat-selection"      . "#494d64")
    ("bat-cursor-line"    . "#2a2d42")

    ;; Heading cycle
    ("bat-heading1"   . "#ed8796")
    ("bat-heading2"   . "#f5a97f")
    ("bat-heading3"   . "#eed49f")
    ("bat-heading4"   . "#a6da95")
    ("bat-heading5"   . "#7dc4e4")
    ("bat-heading6"   . "#b7bdf8"))
  "The Batppuccin (Macchiato) color palette.
Dark flavor.")

(defconst batppuccin-frappe-colors-alist
  '(;; Monochromatic scale
    ("bat-crust"      . "#232634")
    ("bat-mantle"     . "#292c3c")
    ("bat-base"       . "#303446")
    ("bat-surface0"   . "#414559")
    ("bat-surface1"   . "#51576d")
    ("bat-surface2"   . "#626880")
    ("bat-overlay0"   . "#737994")
    ("bat-overlay1"   . "#838ba7")
    ("bat-overlay2"   . "#949cbb")
    ("bat-subtext0"   . "#a5adce")
    ("bat-subtext1"   . "#b5bfe2")
    ("bat-text"       . "#c6d0f5")

    ;; Accent colors
    ("bat-rosewater"  . "#f2d5cf")
    ("bat-flamingo"   . "#eebebe")
    ("bat-pink"       . "#f4b8e4")
    ("bat-mauve"      . "#ca9ee6")
    ("bat-red"        . "#e78284")
    ("bat-maroon"     . "#ea999c")
    ("bat-peach"      . "#ef9f76")
    ("bat-yellow"     . "#e5c890")
    ("bat-green"      . "#a6d189")
    ("bat-teal"       . "#81c8be")
    ("bat-sky"        . "#99d1db")
    ("bat-sapphire"   . "#85c1dc")
    ("bat-blue"       . "#8caaee")
    ("bat-lavender"   . "#babbf1")

    ;; Derived colors
    ("bat-diff-add-bg"    . "#1f3a2a")
    ("bat-diff-del-bg"    . "#3a1f2a")
    ("bat-diff-chg-bg"    . "#1f2a4a")
    ("bat-selection"      . "#51576d")
    ("bat-cursor-line"    . "#353848")

    ;; Heading cycle
    ("bat-heading1"   . "#e78284")
    ("bat-heading2"   . "#ef9f76")
    ("bat-heading3"   . "#e5c890")
    ("bat-heading4"   . "#a6d189")
    ("bat-heading5"   . "#85c1dc")
    ("bat-heading6"   . "#babbf1"))
  "The Batppuccin (Frappe) color palette.
Medium-dark flavor.")

(defconst batppuccin-latte-colors-alist
  '(;; Monochromatic scale (inverted: base is light, crust is darker)
    ("bat-crust"      . "#dce0e8")
    ("bat-mantle"     . "#e6e9ef")
    ("bat-base"       . "#eff1f5")
    ("bat-surface0"   . "#ccd0da")
    ("bat-surface1"   . "#bcc0cc")
    ("bat-surface2"   . "#acb0be")
    ("bat-overlay0"   . "#9ca0b0")
    ("bat-overlay1"   . "#8c8fa1")
    ("bat-overlay2"   . "#7c7f93")
    ("bat-subtext0"   . "#6c6f85")
    ("bat-subtext1"   . "#5c5f77")
    ("bat-text"       . "#4c4f69")

    ;; Accent colors
    ("bat-rosewater"  . "#dc8a78")
    ("bat-flamingo"   . "#dd7878")
    ("bat-pink"       . "#ea76cb")
    ("bat-mauve"      . "#8839ef")
    ("bat-red"        . "#d20f39")
    ("bat-maroon"     . "#e64553")
    ("bat-peach"      . "#fe640b")
    ("bat-yellow"     . "#df8e1d")
    ("bat-green"      . "#40a02b")
    ("bat-teal"       . "#179299")
    ("bat-sky"        . "#04a5e5")
    ("bat-sapphire"   . "#209fb5")
    ("bat-blue"       . "#1e66f5")
    ("bat-lavender"   . "#7287fd")

    ;; Derived colors
    ("bat-diff-add-bg"    . "#d5edd5")
    ("bat-diff-del-bg"    . "#edd5d8")
    ("bat-diff-chg-bg"    . "#d5d8ed")
    ("bat-selection"      . "#bcc0cc")
    ("bat-cursor-line"    . "#e6e8ee")

    ;; Heading cycle
    ("bat-heading1"   . "#d20f39")
    ("bat-heading2"   . "#fe640b")
    ("bat-heading3"   . "#df8e1d")
    ("bat-heading4"   . "#40a02b")
    ("bat-heading5"   . "#209fb5")
    ("bat-heading6"   . "#7287fd"))
  "The Batppuccin (Latte) color palette.
The light flavor.")

;;; Face Application

(defun batppuccin--apply-theme (theme-name colors-alist)
  "Apply the Batppuccin face definitions to THEME-NAME using COLORS-ALIST."
  (let* ((merged (append batppuccin-override-colors-alist colors-alist))
         (class '((class color) (min-colors 88))))
    (cl-flet ((c (name) (cdr (assoc name merged))))
      (let ((bat-crust         (c "bat-crust"))
            (bat-mantle        (c "bat-mantle"))
            (bat-base          (c "bat-base"))
            (bat-surface0      (c "bat-surface0"))
            (bat-surface1      (c "bat-surface1"))
            (bat-surface2      (c "bat-surface2"))
            (bat-overlay0      (c "bat-overlay0"))
            (bat-overlay1      (c "bat-overlay1"))
            (bat-overlay2      (c "bat-overlay2"))
            (bat-subtext0      (c "bat-subtext0"))
            (bat-subtext1      (c "bat-subtext1"))
            (bat-text          (c "bat-text"))
            (bat-rosewater     (c "bat-rosewater"))
            (bat-flamingo      (c "bat-flamingo"))
            (bat-pink          (c "bat-pink"))
            (bat-mauve         (c "bat-mauve"))
            (bat-red           (c "bat-red"))
            (bat-maroon        (c "bat-maroon"))
            (bat-peach         (c "bat-peach"))
            (bat-yellow        (c "bat-yellow"))
            (bat-green         (c "bat-green"))
            (bat-teal          (c "bat-teal"))
            (bat-sky           (c "bat-sky"))
            (bat-sapphire      (c "bat-sapphire"))
            (bat-blue          (c "bat-blue"))
            (bat-lavender      (c "bat-lavender"))
            (bat-diff-add-bg   (c "bat-diff-add-bg"))
            (bat-diff-del-bg   (c "bat-diff-del-bg"))
            (bat-diff-chg-bg   (c "bat-diff-chg-bg"))
            (bat-selection     (c "bat-selection"))
            (bat-cursor-line   (c "bat-cursor-line"))
            (bat-heading1      (c "bat-heading1"))
            (bat-heading2      (c "bat-heading2"))
            (bat-heading3      (c "bat-heading3"))
            (bat-heading4      (c "bat-heading4"))
            (bat-heading5      (c "bat-heading5"))
            (bat-heading6      (c "bat-heading6"))
            (h1 (if batppuccin-scale-headings 1.3 1.0))
            (h2 (if batppuccin-scale-headings 1.2 1.0))
            (h3 (if batppuccin-scale-headings 1.1 1.0))
            (h-doc (if batppuccin-scale-headings 1.4 1.0)))

        (custom-theme-set-faces
         theme-name

;;;; Built-in faces
;;;;; basic coloring
         `(default ((,class (:foreground ,bat-text :background ,bat-base))))
         `(cursor ((,class (:background ,bat-rosewater))))
         `(fringe ((,class (:background ,bat-base :foreground ,bat-surface2))))
         `(header-line ((,class (:background ,bat-mantle :foreground ,bat-subtext1))))
         `(highlight ((,class (:background ,bat-surface1))))
         `(success ((,class (:foreground ,bat-green :weight bold))))
         `(warning ((,class (:foreground ,bat-yellow :weight bold))))
         `(error ((,class (:foreground ,bat-red :weight bold))))
         `(link ((,class (:foreground ,bat-blue :underline t))))
         `(link-visited ((,class (:foreground ,bat-lavender :underline t))))
         `(button ((,class (:foreground ,bat-blue :underline t))))
         `(minibuffer-prompt ((,class (:foreground ,bat-blue :weight bold))))
         `(escape-glyph ((,class (:foreground ,bat-pink))))
         `(homoglyph ((,class (:foreground ,bat-pink))))
         `(tooltip ((,class (:foreground ,bat-text :background ,bat-surface0))))
         `(menu ((,class (:foreground ,bat-text :background ,bat-mantle))))
         `(shadow ((,class (:foreground ,bat-overlay1))))
         `(region ((,class (:background ,bat-selection :extend t))))
         `(secondary-selection ((,class (:background ,bat-surface1 :extend t))))
         `(trailing-whitespace ((,class (:background ,bat-red))))
         `(vertical-border ((,class (:foreground ,bat-surface1))))
         `(window-divider ((,class (:foreground ,bat-surface1))))
         `(window-divider-first-pixel ((,class (:foreground ,bat-surface1))))
         `(window-divider-last-pixel ((,class (:foreground ,bat-surface1))))
         `(widget-field ((,class (:background ,bat-surface0 :extend t))))

;;;;; fill-column-indicator
         `(fill-column-indicator ((,class (:foreground ,bat-surface0 :weight normal))))

;;;;; mode-line
         `(mode-line ((,class (:foreground ,bat-text :background ,bat-mantle
                                           :box (:line-width -1 :color ,bat-surface0)))))
         `(mode-line-inactive ((,class (:foreground ,bat-overlay1 :background ,bat-crust
                                                    :box (:line-width -1 :color ,bat-mantle)))))
         `(mode-line-buffer-id ((,class (:foreground ,bat-blue :weight bold))))
         `(mode-line-emphasis ((,class (:foreground ,bat-text :weight bold))))
         `(mode-line-highlight ((,class (:foreground ,bat-mauve))))

;;;;; ansi-colors
         `(ansi-color-black ((,class (:foreground ,bat-surface1 :background ,bat-surface1))))
         `(ansi-color-red ((,class (:foreground ,bat-red :background ,bat-red))))
         `(ansi-color-green ((,class (:foreground ,bat-green :background ,bat-green))))
         `(ansi-color-yellow ((,class (:foreground ,bat-yellow :background ,bat-yellow))))
         `(ansi-color-blue ((,class (:foreground ,bat-blue :background ,bat-blue))))
         `(ansi-color-magenta ((,class (:foreground ,bat-pink :background ,bat-pink))))
         `(ansi-color-cyan ((,class (:foreground ,bat-teal :background ,bat-teal))))
         `(ansi-color-white ((,class (:foreground ,bat-subtext0 :background ,bat-subtext0))))
         `(ansi-color-bright-black ((,class (:foreground ,bat-surface2 :background ,bat-surface2))))
         `(ansi-color-bright-red ((,class (:foreground ,bat-red :background ,bat-red))))
         `(ansi-color-bright-green ((,class (:foreground ,bat-green :background ,bat-green))))
         `(ansi-color-bright-yellow ((,class (:foreground ,bat-yellow :background ,bat-yellow))))
         `(ansi-color-bright-blue ((,class (:foreground ,bat-blue :background ,bat-blue))))
         `(ansi-color-bright-magenta ((,class (:foreground ,bat-pink :background ,bat-pink))))
         `(ansi-color-bright-cyan ((,class (:foreground ,bat-teal :background ,bat-teal))))
         `(ansi-color-bright-white ((,class (:foreground ,bat-subtext1 :background ,bat-subtext1))))

;;;;; font-lock
         `(font-lock-builtin-face ((,class (:foreground ,bat-red))))
         `(font-lock-comment-face ((,class (:foreground ,bat-overlay2 :slant italic))))
         `(font-lock-comment-delimiter-face ((,class (:foreground ,bat-overlay2 :slant italic))))
         `(font-lock-constant-face ((,class (:foreground ,bat-peach))))
         `(font-lock-doc-face ((,class (:foreground ,bat-overlay2 :slant italic))))
         `(font-lock-doc-markup-face ((,class (:foreground ,bat-subtext0))))
         `(font-lock-function-name-face ((,class (:foreground ,bat-blue))))
         `(font-lock-function-call-face ((,class (:foreground ,bat-blue))))
         `(font-lock-keyword-face ((,class (:foreground ,bat-mauve))))
         `(font-lock-negation-char-face ((,class (:foreground ,bat-sky))))
         `(font-lock-number-face ((,class (:foreground ,bat-peach))))
         `(font-lock-operator-face ((,class (:foreground ,bat-sky))))
         `(font-lock-preprocessor-face ((,class (:foreground ,bat-pink))))
         `(font-lock-regexp-grouping-construct ((,class (:foreground ,bat-pink :weight bold))))
         `(font-lock-regexp-grouping-backslash ((,class (:foreground ,bat-pink :weight bold))))
         `(font-lock-string-face ((,class (:foreground ,bat-green))))
         `(font-lock-type-face ((,class (:foreground ,bat-yellow))))
         `(font-lock-variable-name-face ((,class (:foreground ,bat-flamingo))))
         `(font-lock-variable-use-face ((,class (:foreground ,bat-text))))
         `(font-lock-warning-face ((,class (:inherit warning))))
         `(font-lock-property-name-face ((,class (:foreground ,bat-blue))))
         `(font-lock-property-use-face ((,class (:foreground ,bat-blue))))
         `(font-lock-bracket-face ((,class (:foreground ,bat-overlay2))))
         `(font-lock-delimiter-face ((,class (:foreground ,bat-overlay2))))
         `(font-lock-escape-face ((,class (:foreground ,bat-pink))))
         `(font-lock-misc-punctuation-face ((,class (:foreground ,bat-overlay2))))

;;;;; line numbers
         `(line-number ((,class (:foreground ,bat-overlay1 :background ,bat-base))))
         `(line-number-current-line ((,class (:foreground ,bat-lavender :background ,bat-base :weight bold))))
         `(line-number-major-tick ((,class (:foreground ,bat-subtext0 :background ,bat-base))))
         `(line-number-minor-tick ((,class (:foreground ,bat-overlay0 :background ,bat-base))))

;;;;; isearch / replace
         `(isearch ((,class (:foreground ,bat-base :background ,bat-red :weight bold))))
         `(isearch-fail ((,class (:foreground ,bat-red :background ,bat-surface0))))
         `(isearch-group-1 ((,class (:foreground ,bat-base :background ,bat-blue))))
         `(isearch-group-2 ((,class (:foreground ,bat-base :background ,bat-teal))))
         `(lazy-highlight ((,class (:foreground ,bat-text :background ,bat-surface2))))
         `(match ((,class (:foreground ,bat-base :background ,bat-teal :weight bold))))
         `(query-replace ((,class (:foreground ,bat-base :background ,bat-peach :weight bold))))

;;;;; show-paren
         `(show-paren-match ((,class (:foreground ,bat-peach :background ,bat-surface1 :weight bold))))
         `(show-paren-match-expression ((,class (:background ,bat-surface0))))
         `(show-paren-mismatch ((,class (:foreground ,bat-red :background ,bat-base :weight bold :underline t))))

;;;;; completions
         `(completions-annotations ((,class (:foreground ,bat-overlay2))))
         `(completions-common-part ((,class (:foreground ,bat-blue :weight bold))))
         `(completions-first-difference ((,class (:foreground ,bat-peach))))
         `(completions-highlight ((,class (:background ,bat-surface0))))
         `(completions-group-title ((,class (:foreground ,bat-mauve :weight bold :slant italic))))
         `(completions-group-separator ((,class (:foreground ,bat-overlay2 :strike-through t))))

;;;;; compilation
         `(compilation-error ((,class (:foreground ,bat-red :weight bold))))
         `(compilation-warning ((,class (:foreground ,bat-yellow :weight bold))))
         `(compilation-info ((,class (:foreground ,bat-teal))))
         `(compilation-mode-line-exit ((,class (:foreground ,bat-green :weight bold))))
         `(compilation-mode-line-fail ((,class (:foreground ,bat-red :weight bold))))
         `(compilation-mode-line-run ((,class (:foreground ,bat-blue :weight bold))))
         `(compilation-line-number ((,class (:foreground ,bat-overlay1))))
         `(compilation-column-number ((,class (:foreground ,bat-overlay1))))

;;;;; customize
         `(custom-variable-tag ((,class (:foreground ,bat-blue :weight bold))))
         `(custom-group-tag ((,class (:foreground ,bat-blue :weight bold :height 1.2))))
         `(custom-group-tag-1 ((,class (:foreground ,bat-mauve :weight bold :height 1.2))))
         `(custom-state ((,class (:foreground ,bat-green))))
         `(custom-button ((,class (:foreground ,bat-text :background ,bat-surface0
                                               :box (:line-width 2 :color ,bat-surface1 :style released-button)))))
         `(custom-button-mouse ((,class (:foreground ,bat-text :background ,bat-surface1
                                                     :box (:line-width 2 :color ,bat-surface1 :style released-button)))))
         `(custom-button-pressed ((,class (:foreground ,bat-text :background ,bat-surface0
                                                       :box (:line-width 2 :color ,bat-surface1 :style pressed-button)))))

;;;;; diff
         `(diff-added ((,class (:foreground ,bat-green :background ,bat-diff-add-bg :extend t))))
         `(diff-removed ((,class (:foreground ,bat-red :background ,bat-diff-del-bg :extend t))))
         `(diff-changed ((,class (:foreground ,bat-blue :background ,bat-diff-chg-bg :extend t))))
         `(diff-refine-added ((,class (:foreground ,bat-green :background ,bat-diff-add-bg :weight bold :extend t))))
         `(diff-refine-removed ((,class (:foreground ,bat-red :background ,bat-diff-del-bg :weight bold :extend t))))
         `(diff-refine-changed ((,class (:foreground ,bat-blue :background ,bat-diff-chg-bg :weight bold :extend t))))
         `(diff-header ((,class (:foreground ,bat-subtext1 :background ,bat-mantle :extend t))))
         `(diff-file-header ((,class (:foreground ,bat-blue :background ,bat-mantle :weight bold :extend t))))
         `(diff-hunk-header ((,class (:foreground ,bat-peach :background ,bat-mantle :extend t))))
         `(diff-indicator-added ((,class (:foreground ,bat-green))))
         `(diff-indicator-removed ((,class (:foreground ,bat-red))))
         `(diff-indicator-changed ((,class (:foreground ,bat-blue))))
         `(diff-nonexistent ((,class (:foreground ,bat-overlay2))))

;;;;; dired
         `(dired-directory ((,class (:foreground ,bat-blue :weight bold))))
         `(dired-flagged ((,class (:foreground ,bat-red))))
         `(dired-header ((,class (:foreground ,bat-mauve :weight bold))))
         `(dired-ignored ((,class (:foreground ,bat-overlay2))))
         `(dired-mark ((,class (:foreground ,bat-peach :weight bold))))
         `(dired-marked ((,class (:foreground ,bat-mauve :weight bold))))
         `(dired-perm-write ((,class (:foreground ,bat-subtext1))))
         `(dired-symlink ((,class (:foreground ,bat-sky))))
         `(dired-warning ((,class (:foreground ,bat-yellow :weight bold))))
         `(dired-broken-symlink ((,class (:foreground ,bat-red :weight bold))))

;;;;; ediff
         `(ediff-current-diff-A ((,class (:background ,bat-diff-del-bg :extend t))))
         `(ediff-current-diff-B ((,class (:background ,bat-diff-add-bg :extend t))))
         `(ediff-current-diff-C ((,class (:background ,bat-diff-chg-bg :extend t))))
         `(ediff-fine-diff-A ((,class (:foreground ,bat-red :background ,bat-diff-del-bg :weight bold :extend t))))
         `(ediff-fine-diff-B ((,class (:foreground ,bat-green :background ,bat-diff-add-bg :weight bold :extend t))))
         `(ediff-fine-diff-C ((,class (:foreground ,bat-blue :background ,bat-diff-chg-bg :weight bold :extend t))))
         `(ediff-even-diff-A ((,class (:background ,bat-surface0 :extend t))))
         `(ediff-even-diff-B ((,class (:background ,bat-surface0 :extend t))))
         `(ediff-even-diff-C ((,class (:background ,bat-surface0 :extend t))))
         `(ediff-odd-diff-A ((,class (:background ,bat-surface0 :extend t))))
         `(ediff-odd-diff-B ((,class (:background ,bat-surface0 :extend t))))
         `(ediff-odd-diff-C ((,class (:background ,bat-surface0 :extend t))))

;;;;; eshell
         `(eshell-prompt ((,class (:foreground ,bat-blue :weight bold))))
         `(eshell-ls-archive ((,class (:foreground ,bat-mauve))))
         `(eshell-ls-backup ((,class (:foreground ,bat-overlay2))))
         `(eshell-ls-clutter ((,class (:foreground ,bat-overlay2))))
         `(eshell-ls-directory ((,class (:foreground ,bat-blue :weight bold))))
         `(eshell-ls-executable ((,class (:foreground ,bat-green))))
         `(eshell-ls-missing ((,class (:foreground ,bat-red))))
         `(eshell-ls-product ((,class (:foreground ,bat-subtext1))))
         `(eshell-ls-readonly ((,class (:foreground ,bat-overlay1))))
         `(eshell-ls-special ((,class (:foreground ,bat-peach :weight bold))))
         `(eshell-ls-symlink ((,class (:foreground ,bat-sky))))
         `(eshell-ls-unreadable ((,class (:foreground ,bat-overlay2))))

;;;;; flymake
         `(flymake-error ((,class (:underline (:style wave :color ,bat-red)))))
         `(flymake-warning ((,class (:underline (:style wave :color ,bat-yellow)))))
         `(flymake-note ((,class (:underline (:style wave :color ,bat-teal)))))

;;;;; flyspell
         `(flyspell-duplicate ((,class (:underline (:style wave :color ,bat-yellow)))))
         `(flyspell-incorrect ((,class (:underline (:style wave :color ,bat-red)))))

;;;;; gnus
         `(gnus-group-mail-1 ((,class (:foreground ,bat-blue :weight bold))))
         `(gnus-group-mail-1-empty ((,class (:foreground ,bat-blue))))
         `(gnus-group-mail-2 ((,class (:foreground ,bat-teal :weight bold))))
         `(gnus-group-mail-2-empty ((,class (:foreground ,bat-teal))))
         `(gnus-group-mail-3 ((,class (:foreground ,bat-mauve :weight bold))))
         `(gnus-group-mail-3-empty ((,class (:foreground ,bat-mauve))))
         `(gnus-group-mail-low ((,class (:foreground ,bat-overlay2 :weight bold))))
         `(gnus-group-mail-low-empty ((,class (:foreground ,bat-overlay2))))
         `(gnus-group-news-1 ((,class (:foreground ,bat-blue :weight bold))))
         `(gnus-group-news-1-empty ((,class (:foreground ,bat-blue))))
         `(gnus-group-news-2 ((,class (:foreground ,bat-teal :weight bold))))
         `(gnus-group-news-2-empty ((,class (:foreground ,bat-teal))))
         `(gnus-group-news-low ((,class (:foreground ,bat-overlay2 :weight bold))))
         `(gnus-group-news-low-empty ((,class (:foreground ,bat-overlay2))))
         `(gnus-header-content ((,class (:foreground ,bat-subtext1))))
         `(gnus-header-from ((,class (:foreground ,bat-blue :weight bold))))
         `(gnus-header-name ((,class (:foreground ,bat-mauve))))
         `(gnus-header-newsgroups ((,class (:foreground ,bat-teal :weight bold))))
         `(gnus-header-subject ((,class (:foreground ,bat-text :weight bold))))
         `(gnus-summary-cancelled ((,class (:foreground ,bat-red :background ,bat-base))))
         `(gnus-summary-normal-ancient ((,class (:foreground ,bat-overlay2))))
         `(gnus-summary-normal-read ((,class (:foreground ,bat-overlay1))))
         `(gnus-summary-normal-ticked ((,class (:foreground ,bat-subtext1 :slant italic))))
         `(gnus-summary-normal-unread ((,class (:foreground ,bat-text :weight bold))))
         `(gnus-summary-selected ((,class (:foreground ,bat-blue :weight bold :underline t))))

;;;;; grep
         `(grep-context-face ((,class (:foreground ,bat-subtext1))))
         `(grep-error-face ((,class (:foreground ,bat-red :weight bold :underline t))))
         `(grep-hit-face ((,class (:foreground ,bat-blue))))
         `(grep-match-face ((,class (:foreground ,bat-peach :weight bold))))

;;;;; hi-lock
         `(hi-blue ((,class (:foreground ,bat-base :background ,bat-blue))))
         `(hi-green ((,class (:foreground ,bat-base :background ,bat-green))))
         `(hi-pink ((,class (:foreground ,bat-base :background ,bat-red))))
         `(hi-yellow ((,class (:foreground ,bat-base :background ,bat-yellow))))
         `(hi-blue-b ((,class (:foreground ,bat-blue :weight bold))))
         `(hi-green-b ((,class (:foreground ,bat-green :weight bold))))
         `(hi-red-b ((,class (:foreground ,bat-red :weight bold))))

;;;;; hl-line
         `(hl-line ((,class (:background ,bat-cursor-line :extend t))))

;;;;; hl-todo
         `(hl-todo ((,class (:foreground ,bat-flamingo :weight bold))))

;;;;; icomplete
         `(icomplete-first-match ((,class (:foreground ,bat-green :weight bold))))
         `(icomplete-selected-match ((,class (:background ,bat-surface0))))

;;;;; ido
         `(ido-first-match ((,class (:foreground ,bat-green :weight bold))))
         `(ido-only-match ((,class (:foreground ,bat-teal :weight bold))))
         `(ido-subdir ((,class (:foreground ,bat-blue))))
         `(ido-incomplete-regexp ((,class (:foreground ,bat-red))))
         `(ido-indicator ((,class (:foreground ,bat-yellow :background ,bat-base))))
         `(ido-virtual ((,class (:foreground ,bat-overlay2))))

;;;;; info
         `(Info-quoted ((,class (:foreground ,bat-peach :inherit fixed-pitch-serif))))
         `(info-header-node ((,class (:foreground ,bat-blue :weight bold))))
         `(info-header-xref ((,class (:foreground ,bat-teal))))
         `(info-menu-header ((,class (:foreground ,bat-text :weight bold))))
         `(info-menu-star ((,class (:foreground ,bat-red))))
         `(info-node ((,class (:foreground ,bat-blue :weight bold))))
         `(info-title-1 ((,class (:foreground ,bat-heading1 :weight bold :height ,h1))))
         `(info-title-2 ((,class (:foreground ,bat-heading2 :weight bold :height ,h2))))
         `(info-title-3 ((,class (:foreground ,bat-heading3 :weight bold :height ,h3))))
         `(info-title-4 ((,class (:foreground ,bat-heading4 :weight bold))))
         `(info-xref ((,class (:foreground ,bat-blue :underline t))))
         `(info-xref-visited ((,class (:foreground ,bat-lavender :underline t))))

;;;;; message (email composition)
         `(message-cited-text-1 ((,class (:foreground ,bat-teal))))
         `(message-cited-text-2 ((,class (:foreground ,bat-green))))
         `(message-cited-text-3 ((,class (:foreground ,bat-overlay2))))
         `(message-cited-text-4 ((,class (:foreground ,bat-overlay1))))
         `(message-header-cc ((,class (:foreground ,bat-blue))))
         `(message-header-name ((,class (:foreground ,bat-mauve))))
         `(message-header-newsgroups ((,class (:foreground ,bat-teal :weight bold))))
         `(message-header-other ((,class (:foreground ,bat-subtext1))))
         `(message-header-subject ((,class (:foreground ,bat-text :weight bold))))
         `(message-header-to ((,class (:foreground ,bat-blue :weight bold))))
         `(message-header-xheader ((,class (:foreground ,bat-overlay1))))
         `(message-mml ((,class (:foreground ,bat-green))))
         `(message-separator ((,class (:foreground ,bat-overlay2))))

;;;;; org-mode
         `(org-archived ((,class (:foreground ,bat-overlay2))))
         `(org-block ((,class (:background ,bat-mantle :extend t))))
         `(org-block-begin-line ((,class (:foreground ,bat-overlay2 :background ,bat-mantle :extend t :slant italic))))
         `(org-block-end-line ((,class (:inherit org-block-begin-line))))
         `(org-checkbox ((,class (:foreground ,bat-blue :weight bold))))
         `(org-checkbox-statistics-done ((,class (:foreground ,bat-green))))
         `(org-checkbox-statistics-todo ((,class (:foreground ,bat-peach))))
         `(org-code ((,class (:foreground ,bat-teal))))
         `(org-date ((,class (:foreground ,bat-sky :underline t))))
         `(org-document-info ((,class (:foreground ,bat-subtext1))))
         `(org-document-info-keyword ((,class (:foreground ,bat-overlay2))))
         `(org-document-title ((,class (:foreground ,bat-text :weight bold :height ,h-doc))))
         `(org-done ((,class (:foreground ,bat-green :weight bold))))
         `(org-drawer ((,class (:foreground ,bat-overlay2))))
         `(org-ellipsis ((,class (:foreground ,bat-overlay2 :underline nil))))
         `(org-footnote ((,class (:foreground ,bat-teal))))
         `(org-formula ((,class (:foreground ,bat-peach))))
         `(org-headline-done ((,class (:foreground ,bat-overlay2))))
         `(org-hide ((,class (:foreground ,bat-base))))
         `(org-level-1 ((,class (:inherit outline-1))))
         `(org-level-2 ((,class (:inherit outline-2))))
         `(org-level-3 ((,class (:inherit outline-3))))
         `(org-level-4 ((,class (:inherit outline-4))))
         `(org-level-5 ((,class (:inherit outline-5))))
         `(org-level-6 ((,class (:inherit outline-6))))
         `(org-level-7 ((,class (:inherit outline-7))))
         `(org-level-8 ((,class (:inherit outline-8))))
         `(org-link ((,class (:foreground ,bat-blue :underline t))))
         `(org-meta-line ((,class (:foreground ,bat-overlay2))))
         `(org-priority ((,class (:foreground ,bat-peach))))
         `(org-property-value ((,class (:foreground ,bat-subtext1))))
         `(org-quote ((,class (:foreground ,bat-subtext0 :slant italic :extend t))))
         `(org-scheduled ((,class (:foreground ,bat-green))))
         `(org-scheduled-previously ((,class (:foreground ,bat-peach))))
         `(org-scheduled-today ((,class (:foreground ,bat-green))))
         `(org-special-keyword ((,class (:foreground ,bat-overlay2))))
         `(org-table ((,class (:foreground ,bat-subtext0))))
         `(org-tag ((,class (:foreground ,bat-overlay2 :weight normal))))
         `(org-target ((,class (:underline t))))
         `(org-time-grid ((,class (:foreground ,bat-overlay1))))
         `(org-todo ((,class (:foreground ,bat-peach :weight bold))))
         `(org-upcoming-deadline ((,class (:foreground ,bat-red))))
         `(org-verbatim ((,class (:foreground ,bat-green))))
         `(org-verse ((,class (:inherit org-quote))))
         `(org-warning ((,class (:foreground ,bat-yellow :weight bold))))
         `(org-agenda-date ((,class (:foreground ,bat-blue))))
         `(org-agenda-date-today ((,class (:foreground ,bat-blue :weight bold :slant italic))))
         `(org-agenda-date-weekend ((,class (:foreground ,bat-overlay2))))
         `(org-agenda-date-weekend-today ((,class (:foreground ,bat-overlay2 :weight bold))))
         `(org-agenda-done ((,class (:foreground ,bat-green))))
         `(org-agenda-structure ((,class (:foreground ,bat-mauve :weight bold))))
         `(org-agenda-current-time ((,class (:foreground ,bat-sky))))

;;;;; outline
         `(outline-1 ((,class (:foreground ,bat-heading1 :weight bold))))
         `(outline-2 ((,class (:foreground ,bat-heading2 :weight bold))))
         `(outline-3 ((,class (:foreground ,bat-heading3 :weight bold))))
         `(outline-4 ((,class (:foreground ,bat-heading4 :weight bold))))
         `(outline-5 ((,class (:foreground ,bat-heading5 :weight bold))))
         `(outline-6 ((,class (:foreground ,bat-heading6 :weight bold))))
         `(outline-7 ((,class (:foreground ,bat-subtext1 :weight bold))))
         `(outline-8 ((,class (:foreground ,bat-overlay1 :weight bold))))

;;;;; re-builder
         `(reb-match-0 ((,class (:foreground ,bat-base :background ,bat-blue))))
         `(reb-match-1 ((,class (:foreground ,bat-base :background ,bat-teal))))
         `(reb-match-2 ((,class (:foreground ,bat-base :background ,bat-mauve))))
         `(reb-match-3 ((,class (:foreground ,bat-base :background ,bat-peach))))

;;;;; ruler-mode
         `(ruler-mode-default ((,class (:foreground ,bat-overlay2 :background ,bat-mantle))))
         `(ruler-mode-column-number ((,class (:foreground ,bat-subtext1))))
         `(ruler-mode-current-column ((,class (:foreground ,bat-yellow :weight bold))))
         `(ruler-mode-fill-column ((,class (:foreground ,bat-red))))

;;;;; sh-mode
         `(sh-heredoc ((,class (:foreground ,bat-green :slant italic))))
         `(sh-quoted-exec ((,class (:foreground ,bat-peach))))

;;;;; shr (eww/elfeed HTML rendering)
         `(shr-h1 ((,class (:foreground ,bat-heading1 :weight bold :height ,h1))))
         `(shr-h2 ((,class (:foreground ,bat-heading2 :weight bold :height ,h2))))
         `(shr-h3 ((,class (:foreground ,bat-heading3 :weight bold :height ,h3))))
         `(shr-h4 ((,class (:foreground ,bat-heading4 :weight bold))))
         `(shr-h5 ((,class (:foreground ,bat-heading5 :weight bold))))
         `(shr-h6 ((,class (:foreground ,bat-heading6 :weight bold))))
         `(shr-link ((,class (:foreground ,bat-blue :underline t))))
         `(shr-selected-link ((,class (:foreground ,bat-peach :underline t))))
         `(shr-code ((,class (:foreground ,bat-teal :background ,bat-mantle))))
         `(shr-mark ((,class (:foreground ,bat-base :background ,bat-yellow))))

;;;;; tab-bar / tab-line
         `(tab-bar ((,class (:foreground ,bat-subtext1 :background ,bat-crust))))
         `(tab-bar-tab ((,class (:foreground ,bat-text :background ,bat-base :weight bold))))
         `(tab-bar-tab-inactive ((,class (:foreground ,bat-overlay1 :background ,bat-mantle))))
         `(tab-bar-tab-ungrouped ((,class (:foreground ,bat-overlay2 :background ,bat-mantle))))
         `(tab-bar-tab-group-current ((,class (:foreground ,bat-blue :background ,bat-base :weight bold))))
         `(tab-bar-tab-group-inactive ((,class (:foreground ,bat-overlay1 :background ,bat-mantle))))
         `(tab-line ((,class (:foreground ,bat-subtext1 :background ,bat-crust))))
         `(tab-line-tab ((,class (:foreground ,bat-text :background ,bat-base :weight bold))))
         `(tab-line-tab-current ((,class (:foreground ,bat-text :background ,bat-base :weight bold))))
         `(tab-line-tab-inactive ((,class (:foreground ,bat-overlay1 :background ,bat-mantle))))
         `(tab-line-highlight ((,class (:background ,bat-surface0))))

;;;;; term / ansi-term / vterm
         `(term ((,class (:foreground ,bat-text :background ,bat-base))))
         `(term-color-black ((,class (:inherit ansi-color-black))))
         `(term-color-red ((,class (:inherit ansi-color-red))))
         `(term-color-green ((,class (:inherit ansi-color-green))))
         `(term-color-yellow ((,class (:inherit ansi-color-yellow))))
         `(term-color-blue ((,class (:inherit ansi-color-blue))))
         `(term-color-magenta ((,class (:inherit ansi-color-magenta))))
         `(term-color-cyan ((,class (:inherit ansi-color-cyan))))
         `(term-color-white ((,class (:inherit ansi-color-white))))

;;;;; whitespace-mode
         `(whitespace-empty ((,class (:foreground ,bat-red :background ,bat-base))))
         `(whitespace-hspace ((,class (:foreground ,bat-surface1))))
         `(whitespace-indentation ((,class (:foreground ,bat-surface1))))
         `(whitespace-line ((,class (:foreground ,bat-red :background ,bat-surface0))))
         `(whitespace-newline ((,class (:foreground ,bat-surface1))))
         `(whitespace-space ((,class (:foreground ,bat-surface1))))
         `(whitespace-space-after-tab ((,class (:foreground ,bat-surface1))))
         `(whitespace-space-before-tab ((,class (:foreground ,bat-peach))))
         `(whitespace-tab ((,class (:foreground ,bat-surface1))))
         `(whitespace-trailing ((,class (:foreground ,bat-red :background ,bat-diff-del-bg))))
         `(whitespace-big-indent ((,class (:foreground ,bat-peach :background ,bat-surface0))))

;;;;; woman
         `(woman-bold ((,class (:foreground ,bat-blue :weight bold))))
         `(woman-italic ((,class (:foreground ,bat-mauve :slant italic))))

;;;;; xref
         `(xref-file-header ((,class (:foreground ,bat-blue :weight bold))))
         `(xref-line-number ((,class (:foreground ,bat-overlay1))))
         `(xref-match ((,class (:foreground ,bat-peach :weight bold))))

;;;; Built-in packages
;;;;; bookmark
         `(bookmark-face ((,class (:foreground ,bat-yellow :background ,bat-base))))

;;;;; calendar
         `(calendar-today ((,class (:foreground ,bat-blue :weight bold :underline t))))
         `(calendar-weekend-header ((,class (:foreground ,bat-red))))
         `(calendar-weekday-header ((,class (:foreground ,bat-teal))))
         `(calendar-month-header ((,class (:foreground ,bat-mauve :weight bold))))
         `(holiday ((,class (:foreground ,bat-peach))))
         `(diary ((,class (:foreground ,bat-yellow))))

;;;;; eglot
         `(eglot-highlight-symbol-face ((,class (:background ,bat-surface0 :weight bold))))
         `(eglot-diagnostic-tag-unnecessary-face ((,class (:foreground ,bat-overlay2 :underline (:style wave :color ,bat-overlay1)))))
         `(eglot-diagnostic-tag-deprecated-face ((,class (:foreground ,bat-overlay2 :strike-through ,bat-overlay1))))
         `(eglot-inlay-hint-face ((,class (:foreground ,bat-overlay1 :height 0.9))))

;;;;; eldoc
         `(eldoc-highlight-function-argument ((,class (:foreground ,bat-yellow :weight bold))))

;;;;; epa (EasyPG)
         `(epa-field-body ((,class (:foreground ,bat-subtext1 :slant italic))))
         `(epa-field-name ((,class (:foreground ,bat-blue :weight bold))))
         `(epa-mark ((,class (:foreground ,bat-peach :weight bold))))
         `(epa-string ((,class (:foreground ,bat-green))))
         `(epa-validity-disabled ((,class (:foreground ,bat-red :slant italic))))
         `(epa-validity-high ((,class (:foreground ,bat-green :weight bold))))
         `(epa-validity-low ((,class (:foreground ,bat-overlay2))))
         `(epa-validity-medium ((,class (:foreground ,bat-yellow))))

;;;;; eww
         `(eww-invalid-certificate ((,class (:foreground ,bat-red :weight bold))))
         `(eww-valid-certificate ((,class (:foreground ,bat-green :weight bold))))
         `(eww-form-text ((,class (:foreground ,bat-text :background ,bat-surface0
                                               :box (:line-width -1 :color ,bat-surface1)))))
         `(eww-form-textarea ((,class (:foreground ,bat-text :background ,bat-surface0))))
         `(eww-form-checkbox ((,class (:foreground ,bat-blue :weight bold))))
         `(eww-form-select ((,class (:foreground ,bat-text :background ,bat-surface0
                                                 :box (:line-width -1 :color ,bat-surface1)))))
         `(eww-form-submit ((,class (:foreground ,bat-text :background ,bat-surface1
                                                 :box (:line-width -1 :color ,bat-surface2)))))

;;;;; man
         `(Man-overstrike ((,class (:foreground ,bat-blue :weight bold))))
         `(Man-underline ((,class (:foreground ,bat-teal :underline t))))
         `(Man-reverse ((,class (:foreground ,bat-base :background ,bat-text))))

;;;;; proced
         `(proced-mark ((,class (:foreground ,bat-peach :weight bold))))
         `(proced-marked ((,class (:foreground ,bat-mauve :weight bold))))
         `(proced-sort-header ((,class (:foreground ,bat-blue :weight bold :underline t))))

;;;;; pulse
         `(pulse-highlight-start-face ((,class (:background ,bat-surface1))))

;;;;; speedbar
         `(speedbar-button-face ((,class (:foreground ,bat-green))))
         `(speedbar-directory-face ((,class (:foreground ,bat-blue :weight bold))))
         `(speedbar-file-face ((,class (:foreground ,bat-text))))
         `(speedbar-highlight-face ((,class (:background ,bat-surface0))))
         `(speedbar-selected-face ((,class (:foreground ,bat-peach :weight bold))))
         `(speedbar-separator-face ((,class (:foreground ,bat-overlay2 :background ,bat-mantle))))
         `(speedbar-tag-face ((,class (:foreground ,bat-teal))))

;;;;; vc
         `(vc-state-base ((,class (:foreground ,bat-green))))
         `(vc-conflict-state ((,class (:foreground ,bat-red :weight bold))))
         `(vc-edited-state ((,class (:foreground ,bat-yellow))))
         `(vc-locally-added-state ((,class (:foreground ,bat-green))))
         `(vc-locked-state ((,class (:foreground ,bat-peach :weight bold))))
         `(vc-missing-state ((,class (:foreground ,bat-red))))
         `(vc-needs-update-state ((,class (:foreground ,bat-peach))))
         `(vc-removed-state ((,class (:foreground ,bat-red))))
         `(vc-up-to-date-state ((,class (:foreground ,bat-green))))

;;;;; diff-hl
         `(diff-hl-change ((,class (:foreground ,bat-blue :background ,bat-diff-chg-bg))))
         `(diff-hl-delete ((,class (:foreground ,bat-red :background ,bat-diff-del-bg))))
         `(diff-hl-insert ((,class (:foreground ,bat-green :background ,bat-diff-add-bg))))

;;;;; smerge
         `(smerge-base ((,class (:background ,bat-diff-chg-bg :extend t))))
         `(smerge-markers ((,class (:foreground ,bat-overlay2 :background ,bat-mantle :extend t))))
         `(smerge-upper ((,class (:background ,bat-diff-del-bg :extend t))))
         `(smerge-lower ((,class (:background ,bat-diff-add-bg :extend t))))
         `(smerge-refined-added ((,class (:foreground ,bat-green :background ,bat-diff-add-bg :weight bold :extend t))))
         `(smerge-refined-removed ((,class (:foreground ,bat-red :background ,bat-diff-del-bg :weight bold :extend t))))
         `(smerge-refined-changed ((,class (:foreground ,bat-blue :background ,bat-diff-chg-bg :weight bold :extend t))))

;;;; Third-party packages
;;;;; avy
         `(avy-lead-face ((,class (:foreground ,bat-base :background ,bat-red :weight bold))))
         `(avy-lead-face-0 ((,class (:foreground ,bat-base :background ,bat-blue :weight bold))))
         `(avy-lead-face-1 ((,class (:foreground ,bat-base :background ,bat-overlay1 :weight bold))))
         `(avy-lead-face-2 ((,class (:foreground ,bat-base :background ,bat-teal :weight bold))))
         `(avy-background-face ((,class (:foreground ,bat-overlay2))))
         `(avy-goto-char-timer-face ((,class (:foreground ,bat-base :background ,bat-red))))

;;;;; cider
         `(cider-result-overlay-face ((,class (:foreground ,bat-green :background ,bat-mantle
                                                           :box (:line-width -1 :color ,bat-surface0)))))
         `(cider-debug-code-overlay-face ((,class (:background ,bat-surface0))))
         `(cider-deprecated-face ((,class (:foreground ,bat-overlay2 :strike-through ,bat-overlay1))))
         `(cider-enlightened-face ((,class (:foreground ,bat-yellow :weight bold))))
         `(cider-enlightened-local-face ((,class (:foreground ,bat-yellow))))
         `(cider-error-highlight-face ((,class (:underline (:style wave :color ,bat-red)))))
         `(cider-warning-highlight-face ((,class (:underline (:style wave :color ,bat-yellow)))))
         `(cider-fringe-good-face ((,class (:foreground ,bat-green))))
         `(cider-instrumented-face ((,class (:background ,bat-diff-chg-bg))))
         `(cider-repl-input-face ((,class (:weight bold))))
         `(cider-repl-prompt-face ((,class (:foreground ,bat-blue :weight bold))))
         `(cider-repl-stderr-face ((,class (:foreground ,bat-red))))
         `(cider-repl-stdout-face ((,class (:foreground ,bat-green))))
         `(cider-stacktrace-error-class-face ((,class (:foreground ,bat-red :weight bold))))
         `(cider-stacktrace-error-message-face ((,class (:foreground ,bat-red))))
         `(cider-stacktrace-face ((,class (:foreground ,bat-overlay2))))
         `(cider-stacktrace-filter-active-face ((,class (:foreground ,bat-blue :underline t))))
         `(cider-stacktrace-filter-inactive-face ((,class (:foreground ,bat-overlay1))))
         `(cider-stacktrace-fn-face ((,class (:foreground ,bat-blue))))
         `(cider-stacktrace-ns-face ((,class (:foreground ,bat-subtext1))))
         `(cider-test-error-face ((,class (:foreground ,bat-peach :weight bold))))
         `(cider-test-failure-face ((,class (:foreground ,bat-red :weight bold))))
         `(cider-test-success-face ((,class (:foreground ,bat-green :weight bold))))
         `(cider-traced-face ((,class (:background ,bat-diff-chg-bg))))

;;;;; company
         `(company-tooltip ((,class (:foreground ,bat-text :background ,bat-mantle))))
         `(company-tooltip-selection ((,class (:foreground ,bat-text :background ,bat-surface0))))
         `(company-tooltip-deprecated ((,class (:foreground ,bat-overlay2 :strike-through t))))
         `(company-tooltip-search ((,class (:foreground ,bat-red :weight bold))))
         `(company-tooltip-search-selection ((,class (:foreground ,bat-red :background ,bat-surface0 :weight bold))))
         `(company-tooltip-mouse ((,class (:background ,bat-surface0))))
         `(company-tooltip-common ((,class (:foreground ,bat-blue :weight bold))))
         `(company-tooltip-common-selection ((,class (:foreground ,bat-blue :weight bold))))
         `(company-tooltip-annotation ((,class (:foreground ,bat-overlay2))))
         `(company-tooltip-annotation-selection ((,class (:foreground ,bat-overlay2))))
         `(company-scrollbar-bg ((,class (:background ,bat-surface0))))
         `(company-scrollbar-fg ((,class (:background ,bat-surface2))))
         `(company-preview ((,class (:foreground ,bat-overlay1))))
         `(company-preview-common ((,class (:foreground ,bat-blue :weight bold))))

;;;;; consult
         `(consult-file ((,class (:foreground ,bat-subtext1))))
         `(consult-bookmark ((,class (:foreground ,bat-yellow))))
         `(consult-buffer ((,class (:foreground ,bat-text))))
         `(consult-line-number ((,class (:foreground ,bat-overlay1))))
         `(consult-line-number-prefix ((,class (:foreground ,bat-overlay2))))
         `(consult-separator ((,class (:foreground ,bat-overlay0))))
         `(consult-highlight-match ((,class (:foreground ,bat-peach :weight bold))))
         `(consult-preview-match ((,class (:background ,bat-surface0))))
         `(consult-async-split ((,class (:foreground ,bat-mauve))))
         `(consult-key ((,class (:foreground ,bat-mauve))))
         `(consult-imenu-prefix ((,class (:foreground ,bat-overlay2))))

;;;;; corfu
         `(corfu-default ((,class (:foreground ,bat-text :background ,bat-mantle))))
         `(corfu-current ((,class (:foreground ,bat-text :background ,bat-surface0))))
         `(corfu-bar ((,class (:background ,bat-surface2))))
         `(corfu-border ((,class (:background ,bat-surface0))))
         `(corfu-annotations ((,class (:foreground ,bat-overlay2))))
         `(corfu-deprecated ((,class (:foreground ,bat-overlay2 :strike-through t))))

;;;;; doom-modeline
         `(doom-modeline-bar ((,class (:background ,bat-blue))))
         `(doom-modeline-bar-inactive ((,class (:background ,bat-surface0))))
         `(doom-modeline-buffer-file ((,class (:foreground ,bat-text :weight bold))))
         `(doom-modeline-buffer-major-mode ((,class (:foreground ,bat-mauve :weight bold))))
         `(doom-modeline-buffer-minor-mode ((,class (:foreground ,bat-overlay1))))
         `(doom-modeline-buffer-modified ((,class (:foreground ,bat-yellow :weight bold))))
         `(doom-modeline-buffer-path ((,class (:foreground ,bat-blue))))
         `(doom-modeline-evil-emacs-state ((,class (:foreground ,bat-mauve :weight bold))))
         `(doom-modeline-evil-insert-state ((,class (:foreground ,bat-green :weight bold))))
         `(doom-modeline-evil-motion-state ((,class (:foreground ,bat-blue :weight bold))))
         `(doom-modeline-evil-normal-state ((,class (:foreground ,bat-blue :weight bold))))
         `(doom-modeline-evil-operator-state ((,class (:foreground ,bat-sky :weight bold))))
         `(doom-modeline-evil-replace-state ((,class (:foreground ,bat-red :weight bold))))
         `(doom-modeline-evil-visual-state ((,class (:foreground ,bat-mauve :weight bold))))
         `(doom-modeline-info ((,class (:foreground ,bat-teal :weight bold))))
         `(doom-modeline-lsp-error ((,class (:foreground ,bat-red))))
         `(doom-modeline-lsp-running ((,class (:foreground ,bat-peach))))
         `(doom-modeline-lsp-success ((,class (:foreground ,bat-green))))
         `(doom-modeline-lsp-warning ((,class (:foreground ,bat-yellow))))
         `(doom-modeline-project-dir ((,class (:foreground ,bat-blue))))
         `(doom-modeline-warning ((,class (:foreground ,bat-yellow :weight bold))))

;;;;; elfeed
         `(elfeed-log-date-face ((,class (:foreground ,bat-sky))))
         `(elfeed-log-debug-level-face ((,class (:foreground ,bat-mauve))))
         `(elfeed-log-error-level-face ((,class (:foreground ,bat-red))))
         `(elfeed-log-info-level-face ((,class (:foreground ,bat-teal))))
         `(elfeed-log-warn-level-face ((,class (:foreground ,bat-yellow))))
         `(elfeed-search-date-face ((,class (:foreground ,bat-sky))))
         `(elfeed-search-feed-face ((,class (:foreground ,bat-blue))))
         `(elfeed-search-filter-face ((,class (:foreground ,bat-mauve))))
         `(elfeed-search-tag-face ((,class (:foreground ,bat-teal))))
         `(elfeed-search-title-face ((,class (:foreground ,bat-subtext1))))
         `(elfeed-search-unread-count-face ((,class (:foreground ,bat-blue :weight bold))))
         `(elfeed-search-unread-title-face ((,class (:foreground ,bat-text :weight bold))))

;;;;; embark
         `(embark-keybinding ((,class (:foreground ,bat-mauve :weight bold))))
         `(embark-collect-marked ((,class (:foreground ,bat-base :background ,bat-mauve))))
         `(embark-collect-zebra-highlight ((,class (:background ,bat-surface0))))

;;;;; flycheck
         `(flycheck-error ((,class (:underline (:style wave :color ,bat-red)))))
         `(flycheck-warning ((,class (:underline (:style wave :color ,bat-yellow)))))
         `(flycheck-info ((,class (:underline (:style wave :color ,bat-teal)))))
         `(flycheck-error-list-error ((,class (:foreground ,bat-red))))
         `(flycheck-error-list-warning ((,class (:foreground ,bat-yellow))))
         `(flycheck-error-list-info ((,class (:foreground ,bat-teal))))
         `(flycheck-fringe-error ((,class (:foreground ,bat-red))))
         `(flycheck-fringe-warning ((,class (:foreground ,bat-yellow))))
         `(flycheck-fringe-info ((,class (:foreground ,bat-teal))))

;;;;; forge
         `(forge-topic-open ((,class (:foreground ,bat-green))))
         `(forge-topic-closed ((,class (:foreground ,bat-overlay2))))
         `(forge-topic-merged ((,class (:foreground ,bat-mauve))))
         `(forge-topic-unmerged ((,class (:foreground ,bat-yellow))))
         `(forge-issue-open ((,class (:foreground ,bat-green))))
         `(forge-issue-completed ((,class (:foreground ,bat-overlay2))))
         `(forge-pullreq-open ((,class (:foreground ,bat-green))))
         `(forge-pullreq-merged ((,class (:foreground ,bat-mauve))))
         `(forge-pullreq-rejected ((,class (:foreground ,bat-red))))
         `(forge-pullreq-draft ((,class (:foreground ,bat-overlay1 :slant italic))))
         `(forge-topic-label ((,class (:box (:line-width -1 :color ,bat-surface1)))))
         `(forge-post-author ((,class (:foreground ,bat-peach :weight bold))))
         `(forge-post-date ((,class (:foreground ,bat-sky))))
         `(forge-suffix-active ((,class (:foreground ,bat-green :weight bold))))
         `(forge-suffix-active-and-implied ((,class (:foreground ,bat-green))))
         `(forge-suffix-implied ((,class (:foreground ,bat-overlay1))))

;;;;; hydra
         `(hydra-face-red ((,class (:foreground ,bat-red :weight bold))))
         `(hydra-face-blue ((,class (:foreground ,bat-blue :weight bold))))
         `(hydra-face-amaranth ((,class (:foreground ,bat-peach :weight bold))))
         `(hydra-face-pink ((,class (:foreground ,bat-pink :weight bold))))
         `(hydra-face-teal ((,class (:foreground ,bat-teal :weight bold))))

;;;;; ivy
         `(ivy-current-match ((,class (:foreground ,bat-text :background ,bat-surface1 :weight bold))))
         `(ivy-minibuffer-match-face-1 ((,class (:foreground ,bat-overlay2))))
         `(ivy-minibuffer-match-face-2 ((,class (:foreground ,bat-blue :weight bold))))
         `(ivy-minibuffer-match-face-3 ((,class (:foreground ,bat-teal :weight bold))))
         `(ivy-minibuffer-match-face-4 ((,class (:foreground ,bat-peach :weight bold))))
         `(ivy-confirm-face ((,class (:foreground ,bat-green))))
         `(ivy-match-required-face ((,class (:foreground ,bat-red))))
         `(ivy-remote ((,class (:foreground ,bat-mauve))))
         `(ivy-virtual ((,class (:foreground ,bat-overlay2))))

;;;;; lsp-mode
         `(lsp-face-highlight-textual ((,class (:background ,bat-surface0))))
         `(lsp-face-highlight-read ((,class (:background ,bat-surface0))))
         `(lsp-face-highlight-write ((,class (:background ,bat-surface0 :weight bold))))

;;;;; lsp-ui
         `(lsp-ui-doc-background ((,class (:background ,bat-mantle))))
         `(lsp-ui-doc-header ((,class (:foreground ,bat-text :background ,bat-surface1 :weight bold))))
         `(lsp-ui-doc-highlight-hover ((,class (:background ,bat-surface0))))
         `(lsp-ui-doc-url ((,class (:foreground ,bat-blue :underline t))))
         `(lsp-ui-peek-peek ((,class (:background ,bat-mantle))))
         `(lsp-ui-peek-list ((,class (:background ,bat-mantle))))
         `(lsp-ui-peek-filename ((,class (:foreground ,bat-peach :weight bold))))
         `(lsp-ui-peek-line-number ((,class (:foreground ,bat-overlay1))))
         `(lsp-ui-peek-highlight ((,class (:foreground ,bat-red :weight bold :box (:line-width -1 :color ,bat-red)))))
         `(lsp-ui-peek-header ((,class (:foreground ,bat-text :background ,bat-surface1 :weight bold))))
         `(lsp-ui-peek-footer ((,class (:foreground ,bat-text :background ,bat-surface1))))
         `(lsp-ui-peek-selection ((,class (:foreground ,bat-text :background ,bat-surface0 :weight bold))))
         `(lsp-ui-sideline-symbol ((,class (:foreground ,bat-overlay1 :box (:line-width -1 :color ,bat-overlay1)))))
         `(lsp-ui-sideline-current-symbol ((,class (:foreground ,bat-text :weight bold :box (:line-width -1 :color ,bat-text)))))
         `(lsp-ui-sideline-code-action ((,class (:foreground ,bat-yellow))))
         `(lsp-ui-sideline-symbol-info ((,class (:foreground ,bat-overlay2 :slant italic))))
         `(lsp-ui-sideline-global ((,class (:foreground ,bat-overlay2))))

;;;;; magit
;;;;;; magit-bisect
         `(magit-bisect-bad ((,class (:foreground ,bat-red))))
         `(magit-bisect-good ((,class (:foreground ,bat-green))))
         `(magit-bisect-skip ((,class (:foreground ,bat-yellow))))
;;;;;; magit-blame
         `(magit-blame-heading ((,class (:foreground ,bat-subtext1 :background ,bat-mantle :extend t))))
         `(magit-blame-hash ((,class (:foreground ,bat-mauve))))
         `(magit-blame-name ((,class (:foreground ,bat-blue))))
         `(magit-blame-date ((,class (:foreground ,bat-sky))))
         `(magit-blame-summary ((,class (:foreground ,bat-text))))
         `(magit-blame-dimmed ((,class (:foreground ,bat-overlay2))))
         `(magit-blame-margin ((,class (:foreground ,bat-subtext1 :background ,bat-mantle))))
;;;;;; magit-branch
         `(magit-branch-local ((,class (:foreground ,bat-blue))))
         `(magit-branch-remote ((,class (:foreground ,bat-green))))
         `(magit-branch-remote-head ((,class (:foreground ,bat-green :weight bold))))
         `(magit-branch-current ((,class (:foreground ,bat-blue :weight bold :box (:line-width -1 :color ,bat-blue)))))
         `(magit-branch-upstream ((,class (:foreground ,bat-teal))))
         `(magit-branch-warning ((,class (:foreground ,bat-yellow))))
;;;;;; magit-cherry
         `(magit-cherry-equivalent ((,class (:foreground ,bat-mauve))))
         `(magit-cherry-unmatched ((,class (:foreground ,bat-sky))))
;;;;;; magit-diff
         `(magit-diff-added ((,class (:foreground ,bat-green :background ,bat-diff-add-bg :extend t))))
         `(magit-diff-added-highlight ((,class (:foreground ,bat-green :background ,bat-diff-add-bg :weight bold :extend t))))
         `(magit-diff-removed ((,class (:foreground ,bat-red :background ,bat-diff-del-bg :extend t))))
         `(magit-diff-removed-highlight ((,class (:foreground ,bat-red :background ,bat-diff-del-bg :weight bold :extend t))))
         `(magit-diff-base ((,class (:foreground ,bat-peach :background ,bat-diff-chg-bg :extend t))))
         `(magit-diff-base-highlight ((,class (:foreground ,bat-peach :background ,bat-diff-chg-bg :weight bold :extend t))))
         `(magit-diff-context ((,class (:foreground ,bat-overlay2 :extend t))))
         `(magit-diff-context-highlight ((,class (:foreground ,bat-subtext0 :background ,bat-mantle :extend t))))
         `(magit-diff-file-heading ((,class (:foreground ,bat-text :weight bold :extend t))))
         `(magit-diff-file-heading-highlight ((,class (:foreground ,bat-text :background ,bat-surface0 :weight bold :extend t))))
         `(magit-diff-file-heading-selection ((,class (:foreground ,bat-peach :background ,bat-surface0 :extend t))))
         `(magit-diff-hunk-heading ((,class (:foreground ,bat-subtext1 :background ,bat-surface0 :extend t))))
         `(magit-diff-hunk-heading-highlight ((,class (:foreground ,bat-text :background ,bat-surface1 :weight bold :extend t))))
         `(magit-diff-hunk-heading-selection ((,class (:foreground ,bat-peach :background ,bat-surface1 :extend t))))
         `(magit-diff-lines-heading ((,class (:foreground ,bat-base :background ,bat-peach :extend t))))
         `(magit-diff-revision-summary ((,class (:foreground ,bat-blue :weight bold))))
         `(magit-diff-revision-summary-highlight ((,class (:foreground ,bat-blue :weight bold))))
         `(magit-diff-whitespace-warning ((,class (:background ,bat-red))))
         `(magit-diffstat-added ((,class (:foreground ,bat-green))))
         `(magit-diffstat-removed ((,class (:foreground ,bat-red))))
;;;;;; magit-log
         `(magit-log-author ((,class (:foreground ,bat-blue))))
         `(magit-log-date ((,class (:foreground ,bat-sky))))
         `(magit-log-graph ((,class (:foreground ,bat-overlay2))))
;;;;;; magit-process
         `(magit-process-ng ((,class (:foreground ,bat-red :weight bold))))
         `(magit-process-ok ((,class (:foreground ,bat-green :weight bold))))
;;;;;; magit-reflog
         `(magit-reflog-amend ((,class (:foreground ,bat-mauve))))
         `(magit-reflog-checkout ((,class (:foreground ,bat-blue))))
         `(magit-reflog-cherry-pick ((,class (:foreground ,bat-green))))
         `(magit-reflog-commit ((,class (:foreground ,bat-green))))
         `(magit-reflog-merge ((,class (:foreground ,bat-green))))
         `(magit-reflog-other ((,class (:foreground ,bat-sky))))
         `(magit-reflog-rebase ((,class (:foreground ,bat-mauve))))
         `(magit-reflog-remote ((,class (:foreground ,bat-teal))))
         `(magit-reflog-reset ((,class (:foreground ,bat-red))))
;;;;;; magit-section
         `(magit-section-heading ((,class (:foreground ,bat-blue :weight bold))))
         `(magit-section-heading-selection ((,class (:foreground ,bat-peach :weight bold))))
         `(magit-section-highlight ((,class (:background ,bat-surface0 :extend t))))
         `(magit-section-secondary-heading ((,class (:foreground ,bat-mauve :weight bold))))
;;;;;; magit-sequence
         `(magit-sequence-done ((,class (:foreground ,bat-overlay2))))
         `(magit-sequence-drop ((,class (:foreground ,bat-red))))
         `(magit-sequence-head ((,class (:foreground ,bat-blue))))
         `(magit-sequence-onto ((,class (:foreground ,bat-overlay2))))
         `(magit-sequence-part ((,class (:foreground ,bat-yellow))))
         `(magit-sequence-pick ((,class (:foreground ,bat-green))))
         `(magit-sequence-stop ((,class (:foreground ,bat-teal))))
;;;;;; magit-signature
         `(magit-signature-bad ((,class (:foreground ,bat-red :weight bold))))
         `(magit-signature-error ((,class (:foreground ,bat-red))))
         `(magit-signature-expired ((,class (:foreground ,bat-peach))))
         `(magit-signature-expired-key ((,class (:foreground ,bat-peach))))
         `(magit-signature-good ((,class (:foreground ,bat-green))))
         `(magit-signature-revoked ((,class (:foreground ,bat-mauve))))
         `(magit-signature-untrusted ((,class (:foreground ,bat-yellow))))
;;;;;; magit-tag
         `(magit-tag ((,class (:foreground ,bat-yellow))))
;;;;;; magit-misc
         `(magit-dimmed ((,class (:foreground ,bat-overlay2))))
         `(magit-filename ((,class (:foreground ,bat-text))))
         `(magit-hash ((,class (:foreground ,bat-overlay2))))
         `(magit-header-line ((,class (:foreground ,bat-blue :weight bold))))
         `(magit-keyword ((,class (:foreground ,bat-mauve))))
         `(magit-mode-line-process ((,class (:foreground ,bat-peach :weight bold))))
         `(magit-mode-line-process-error ((,class (:foreground ,bat-red :weight bold))))

;;;;; marginalia
         `(marginalia-archive ((,class (:foreground ,bat-mauve))))
         `(marginalia-char ((,class (:foreground ,bat-peach))))
         `(marginalia-date ((,class (:foreground ,bat-sky))))
         `(marginalia-documentation ((,class (:foreground ,bat-overlay2))))
         `(marginalia-file-name ((,class (:foreground ,bat-text))))
         `(marginalia-file-owner ((,class (:foreground ,bat-overlay1))))
         `(marginalia-file-priv-dir ((,class (:foreground ,bat-blue))))
         `(marginalia-file-priv-exec ((,class (:foreground ,bat-green))))
         `(marginalia-file-priv-link ((,class (:foreground ,bat-sky))))
         `(marginalia-file-priv-no ((,class (:foreground ,bat-overlay2))))
         `(marginalia-file-priv-other ((,class (:foreground ,bat-overlay1))))
         `(marginalia-file-priv-rare ((,class (:foreground ,bat-peach))))
         `(marginalia-file-priv-read ((,class (:foreground ,bat-yellow))))
         `(marginalia-file-priv-write ((,class (:foreground ,bat-red))))
         `(marginalia-function ((,class (:foreground ,bat-blue))))
         `(marginalia-installed ((,class (:foreground ,bat-green))))
         `(marginalia-key ((,class (:foreground ,bat-mauve))))
         `(marginalia-lighter ((,class (:foreground ,bat-overlay1))))
         `(marginalia-list ((,class (:foreground ,bat-teal))))
         `(marginalia-mode ((,class (:foreground ,bat-mauve))))
         `(marginalia-modified ((,class (:foreground ,bat-yellow))))
         `(marginalia-null ((,class (:foreground ,bat-overlay2))))
         `(marginalia-number ((,class (:foreground ,bat-peach))))
         `(marginalia-size ((,class (:foreground ,bat-teal))))
         `(marginalia-string ((,class (:foreground ,bat-green))))
         `(marginalia-symbol ((,class (:foreground ,bat-blue))))
         `(marginalia-true ((,class (:foreground ,bat-green))))
         `(marginalia-type ((,class (:foreground ,bat-yellow))))
         `(marginalia-value ((,class (:foreground ,bat-subtext1))))
         `(marginalia-version ((,class (:foreground ,bat-teal))))

;;;;; markdown-mode
         `(markdown-header-face-1 ((,class (:foreground ,bat-heading1 :weight bold :height ,h1))))
         `(markdown-header-face-2 ((,class (:foreground ,bat-heading2 :weight bold :height ,h2))))
         `(markdown-header-face-3 ((,class (:foreground ,bat-heading3 :weight bold :height ,h3))))
         `(markdown-header-face-4 ((,class (:foreground ,bat-heading4 :weight bold))))
         `(markdown-header-face-5 ((,class (:foreground ,bat-heading5 :weight bold))))
         `(markdown-header-face-6 ((,class (:foreground ,bat-heading6 :weight bold))))
         `(markdown-bold-face ((,class (:weight bold))))
         `(markdown-italic-face ((,class (:slant italic))))
         `(markdown-code-face ((,class (:foreground ,bat-teal))))
         `(markdown-inline-code-face ((,class (:foreground ,bat-teal))))
         `(markdown-pre-face ((,class (:foreground ,bat-teal))))
         `(markdown-link-face ((,class (:foreground ,bat-blue :underline t))))
         `(markdown-url-face ((,class (:foreground ,bat-blue :underline t))))
         `(markdown-plain-url-face ((,class (:foreground ,bat-blue :underline t))))
         `(markdown-reference-face ((,class (:foreground ,bat-lavender))))
         `(markdown-blockquote-face ((,class (:foreground ,bat-subtext0 :slant italic))))
         `(markdown-footnote-marker-face ((,class (:foreground ,bat-teal))))
         `(markdown-list-face ((,class (:foreground ,bat-blue))))
         `(markdown-markup-face ((,class (:foreground ,bat-overlay2))))
         `(markdown-metadata-key-face ((,class (:foreground ,bat-overlay2))))
         `(markdown-metadata-value-face ((,class (:foreground ,bat-subtext1))))
         `(markdown-missing-link-face ((,class (:foreground ,bat-red))))
         `(markdown-hr-face ((,class (:foreground ,bat-overlay2))))
         `(markdown-html-attr-name-face ((,class (:foreground ,bat-mauve))))
         `(markdown-html-attr-value-face ((,class (:foreground ,bat-green))))
         `(markdown-html-tag-name-face ((,class (:foreground ,bat-blue))))
         `(markdown-table-face ((,class (:foreground ,bat-subtext0))))

;;;;; orderless
         `(orderless-match-face-0 ((,class (:foreground ,bat-blue :weight bold))))
         `(orderless-match-face-1 ((,class (:foreground ,bat-mauve :weight bold))))
         `(orderless-match-face-2 ((,class (:foreground ,bat-teal :weight bold))))
         `(orderless-match-face-3 ((,class (:foreground ,bat-peach :weight bold))))

;;;;; rainbow-delimiters
         `(rainbow-delimiters-depth-1-face ((,class (:foreground ,bat-red))))
         `(rainbow-delimiters-depth-2-face ((,class (:foreground ,bat-peach))))
         `(rainbow-delimiters-depth-3-face ((,class (:foreground ,bat-yellow))))
         `(rainbow-delimiters-depth-4-face ((,class (:foreground ,bat-green))))
         `(rainbow-delimiters-depth-5-face ((,class (:foreground ,bat-sapphire))))
         `(rainbow-delimiters-depth-6-face ((,class (:foreground ,bat-lavender))))
         `(rainbow-delimiters-depth-7-face ((,class (:foreground ,bat-red))))
         `(rainbow-delimiters-depth-8-face ((,class (:foreground ,bat-peach))))
         `(rainbow-delimiters-depth-9-face ((,class (:foreground ,bat-yellow))))
         `(rainbow-delimiters-unmatched-face ((,class (:foreground ,bat-red :weight bold))))
         `(rainbow-delimiters-mismatched-face ((,class (:foreground ,bat-red :weight bold))))
         `(rainbow-delimiters-base-error-face ((,class (:foreground ,bat-red :weight bold))))

;;;;; smartparens
         `(sp-show-pair-match-face ((,class (:inherit show-paren-match))))
         `(sp-show-pair-mismatch-face ((,class (:inherit show-paren-mismatch))))
         `(sp-pair-overlay-face ((,class (:background ,bat-surface0))))
         `(sp-show-pair-match-content-face ((,class (:background ,bat-surface0))))

;;;;; transient
         `(transient-heading ((,class (:foreground ,bat-blue :weight bold))))
         `(transient-key ((,class (:foreground ,bat-mauve :weight bold))))
         `(transient-argument ((,class (:foreground ,bat-green))))
         `(transient-value ((,class (:foreground ,bat-green))))
         `(transient-inactive-argument ((,class (:foreground ,bat-overlay2))))
         `(transient-inactive-value ((,class (:foreground ,bat-overlay2))))
         `(transient-unreachable ((,class (:foreground ,bat-overlay1))))
         `(transient-unreachable-key ((,class (:foreground ,bat-overlay1))))
         `(transient-enabled-suffix ((,class (:foreground ,bat-green :background ,bat-diff-add-bg))))
         `(transient-disabled-suffix ((,class (:foreground ,bat-red :background ,bat-diff-del-bg))))
         `(transient-separator ((,class (:background ,bat-mantle :extend t))))
         `(transient-amaranth ((,class (:foreground ,bat-peach :weight bold))))
         `(transient-blue ((,class (:foreground ,bat-blue :weight bold))))
         `(transient-pink ((,class (:foreground ,bat-pink :weight bold))))
         `(transient-purple ((,class (:foreground ,bat-mauve :weight bold))))
         `(transient-red ((,class (:foreground ,bat-red :weight bold))))
         `(transient-teal ((,class (:foreground ,bat-teal :weight bold))))

;;;;; treemacs
         `(treemacs-directory-face ((,class (:foreground ,bat-blue :weight bold))))
         `(treemacs-directory-collapsed-face ((,class (:foreground ,bat-blue))))
         `(treemacs-window-background-face ((,class (:background ,bat-mantle))))
         `(treemacs-hl-line-face ((,class (:background ,bat-surface0 :extend t))))
         `(treemacs-file-face ((,class (:foreground ,bat-text))))
         `(treemacs-root-face ((,class (:foreground ,bat-blue :weight bold :height 1.1))))
         `(treemacs-root-unreadable-face ((,class (:foreground ,bat-red :weight bold :height 1.1))))
         `(treemacs-root-remote-face ((,class (:foreground ,bat-mauve :weight bold :height 1.1))))
         `(treemacs-root-remote-unreadable-face ((,class (:foreground ,bat-red :slant italic :height 1.1))))
         `(treemacs-root-remote-disconnected-face ((,class (:foreground ,bat-overlay2 :weight bold :height 1.1))))
         `(treemacs-term-node-face ((,class (:foreground ,bat-subtext1))))
         `(treemacs-git-unmodified-face ((,class (:foreground ,bat-text))))
         `(treemacs-git-modified-face ((,class (:foreground ,bat-yellow))))
         `(treemacs-git-renamed-face ((,class (:foreground ,bat-green))))
         `(treemacs-git-ignored-face ((,class (:foreground ,bat-overlay2))))
         `(treemacs-git-untracked-face ((,class (:foreground ,bat-peach))))
         `(treemacs-git-added-face ((,class (:foreground ,bat-green))))
         `(treemacs-git-conflict-face ((,class (:foreground ,bat-red :weight bold))))
         `(treemacs-tags-face ((,class (:foreground ,bat-teal))))
         `(treemacs-help-title-face ((,class (:foreground ,bat-mauve :weight bold))))
         `(treemacs-help-column-face ((,class (:foreground ,bat-blue))))
         `(treemacs-on-failure-pulse-face ((,class (:background ,bat-diff-del-bg))))
         `(treemacs-on-success-pulse-face ((,class (:background ,bat-diff-add-bg))))
         `(treemacs-fringe-indicator-face ((,class (:foreground ,bat-blue))))
         `(treemacs-header-button-face ((,class (:foreground ,bat-text :background ,bat-surface0 :box (:line-width -1 :color ,bat-surface1)))))
         `(treemacs-marked-file-face ((,class (:foreground ,bat-mauve :weight bold))))
         `(treemacs-git-commit-diff-face ((,class (:foreground ,bat-overlay1))))
         `(treemacs-async-loading-face ((,class (:foreground ,bat-overlay2 :slant italic))))

;;;;; vertico
         `(vertico-current ((,class (:background ,bat-surface0 :extend t))))
         `(vertico-group-title ((,class (:foreground ,bat-mauve :weight bold :slant italic))))
         `(vertico-group-separator ((,class (:foreground ,bat-overlay2 :strike-through t))))
         `(vertico-multiline ((,class (:foreground ,bat-overlay2))))

;;;;; web-mode
         `(web-mode-error-face ((,class (:foreground ,bat-red :underline t))))
         `(web-mode-warning-face ((,class (:foreground ,bat-yellow :underline t))))
         `(web-mode-preprocessor-face ((,class (:foreground ,bat-pink))))
         `(web-mode-block-delimiter-face ((,class (:foreground ,bat-overlay1))))
         `(web-mode-block-control-face ((,class (:foreground ,bat-mauve))))
         `(web-mode-builtin-face ((,class (:foreground ,bat-red))))
         `(web-mode-symbol-face ((,class (:foreground ,bat-peach))))
         `(web-mode-doctype-face ((,class (:foreground ,bat-overlay2))))
         `(web-mode-html-tag-face ((,class (:foreground ,bat-blue))))
         `(web-mode-html-tag-custom-face ((,class (:foreground ,bat-blue))))
         `(web-mode-html-tag-unclosed-face ((,class (:foreground ,bat-red :underline t))))
         `(web-mode-html-tag-namespaced-face ((,class (:foreground ,bat-blue))))
         `(web-mode-html-tag-bracket-face ((,class (:foreground ,bat-overlay2))))
         `(web-mode-html-attr-name-face ((,class (:foreground ,bat-yellow))))
         `(web-mode-html-attr-custom-face ((,class (:foreground ,bat-yellow :slant italic))))
         `(web-mode-html-attr-engine-face ((,class (:foreground ,bat-yellow))))
         `(web-mode-html-attr-equal-face ((,class (:foreground ,bat-overlay2))))
         `(web-mode-html-attr-value-face ((,class (:foreground ,bat-green))))
         `(web-mode-block-attr-name-face ((,class (:foreground ,bat-yellow))))
         `(web-mode-block-attr-value-face ((,class (:foreground ,bat-green))))
         `(web-mode-variable-name-face ((,class (:foreground ,bat-flamingo))))
         `(web-mode-css-selector-face ((,class (:foreground ,bat-teal))))
         `(web-mode-css-selector-class-face ((,class (:foreground ,bat-green))))
         `(web-mode-css-selector-tag-face ((,class (:foreground ,bat-sky))))
         `(web-mode-css-pseudo-class-face ((,class (:foreground ,bat-teal))))
         `(web-mode-css-at-rule-face ((,class (:foreground ,bat-mauve))))
         `(web-mode-css-property-name-face ((,class (:foreground ,bat-blue))))
         `(web-mode-css-color-face ((,class (:foreground ,bat-peach))))
         `(web-mode-css-priority-face ((,class (:foreground ,bat-peach :weight bold))))
         `(web-mode-css-function-face ((,class (:foreground ,bat-sky))))
         `(web-mode-css-variable-face ((,class (:foreground ,bat-flamingo))))
         `(web-mode-function-name-face ((,class (:foreground ,bat-blue))))
         `(web-mode-filter-face ((,class (:foreground ,bat-sky))))
         `(web-mode-function-call-face ((,class (:foreground ,bat-blue))))
         `(web-mode-string-face ((,class (:foreground ,bat-green))))
         `(web-mode-block-string-face ((,class (:inherit web-mode-string-face))))
         `(web-mode-part-string-face ((,class (:inherit web-mode-string-face))))
         `(web-mode-javascript-string-face ((,class (:inherit web-mode-string-face))))
         `(web-mode-css-string-face ((,class (:inherit web-mode-string-face))))
         `(web-mode-json-key-face ((,class (:foreground ,bat-blue))))
         `(web-mode-json-context-face ((,class (:foreground ,bat-mauve))))
         `(web-mode-json-string-face ((,class (:inherit web-mode-string-face))))
         `(web-mode-comment-face ((,class (:foreground ,bat-overlay2 :slant italic))))
         `(web-mode-block-comment-face ((,class (:inherit web-mode-comment-face))))
         `(web-mode-part-comment-face ((,class (:inherit web-mode-comment-face))))
         `(web-mode-json-comment-face ((,class (:inherit web-mode-comment-face))))
         `(web-mode-javascript-comment-face ((,class (:inherit web-mode-comment-face))))
         `(web-mode-css-comment-face ((,class (:inherit web-mode-comment-face))))
         `(web-mode-annotation-face ((,class (:foreground ,bat-overlay2))))
         `(web-mode-annotation-tag-face ((,class (:foreground ,bat-overlay1))))
         `(web-mode-annotation-type-face ((,class (:foreground ,bat-yellow))))
         `(web-mode-annotation-value-face ((,class (:foreground ,bat-green))))
         `(web-mode-annotation-html-face ((,class (:foreground ,bat-overlay2))))
         `(web-mode-constant-face ((,class (:foreground ,bat-peach))))
         `(web-mode-type-face ((,class (:foreground ,bat-yellow))))
         `(web-mode-keyword-face ((,class (:foreground ,bat-mauve))))
         `(web-mode-param-name-face ((,class (:foreground ,bat-maroon))))
         `(web-mode-whitespace-face ((,class (:foreground ,bat-red :background ,bat-diff-del-bg))))
         `(web-mode-inlay-face ((,class (:background ,bat-mantle))))
         `(web-mode-block-face ((,class (:inherit web-mode-inlay-face))))
         `(web-mode-part-face ((,class (:inherit web-mode-inlay-face))))
         `(web-mode-script-face ((,class (:inherit web-mode-inlay-face))))
         `(web-mode-style-face ((,class (:inherit web-mode-inlay-face))))
         `(web-mode-folded-face ((,class (:foreground ,bat-overlay2 :underline t))))
         `(web-mode-current-element-highlight-face ((,class (:background ,bat-surface0))))
         `(web-mode-current-column-highlight-face ((,class (:background ,bat-cursor-line))))
         `(web-mode-comment-keyword-face ((,class (:foreground ,bat-flamingo :weight bold))))
         `(web-mode-sql-keyword-face ((,class (:foreground ,bat-mauve))))
         `(web-mode-html-entity-face ((,class (:foreground ,bat-peach))))

;;;;; which-key
         `(which-key-key-face ((,class (:foreground ,bat-mauve :weight bold))))
         `(which-key-separator-face ((,class (:foreground ,bat-overlay2))))
         `(which-key-note-face ((,class (:foreground ,bat-overlay2))))
         `(which-key-command-description-face ((,class (:foreground ,bat-text))))
         `(which-key-group-description-face ((,class (:foreground ,bat-blue))))
         `(which-key-local-map-description-face ((,class (:foreground ,bat-teal))))
         `(which-key-special-key-face ((,class (:foreground ,bat-peach :weight bold)))))

        (custom-theme-set-variables
         theme-name

;;;;; ansi-color
         `(ansi-color-names-vector
           [,bat-surface1 ,bat-red ,bat-green ,bat-yellow
            ,bat-blue ,bat-pink ,bat-teal ,bat-subtext0])

;;;;; pdf-view
         `(pdf-view-midnight-colors '(,bat-text . ,bat-base)))))))

;;; Hooks

(defcustom batppuccin-after-load-hook nil
  "Hook run after a Batppuccin theme is loaded.
Each function is called with the theme name (a symbol) as its
sole argument.  Useful for applying additional customizations
that depend on theme colors being set."
  :type 'hook
  :group 'batppuccin)

;;; Palette API

(defun batppuccin--palette-for (theme)
  "Return the colors alist for THEME, or nil if unknown."
  (pcase theme
    ('batppuccin-mocha     batppuccin-mocha-colors-alist)
    ('batppuccin-macchiato batppuccin-macchiato-colors-alist)
    ('batppuccin-frappe    batppuccin-frappe-colors-alist)
    ('batppuccin-latte     batppuccin-latte-colors-alist)))

(defun batppuccin-get-color (name &optional theme)
  "Return the hex color value for NAME in the current Batppuccin theme.
NAME is a string like \"bat-blue\".  If THEME is given, look up
colors in that variant's palette instead.  User overrides from
`batppuccin-override-colors-alist' are respected."
  (let* ((variant (or theme batppuccin--current))
         (palette (or (batppuccin--palette-for variant)
                      (error "No Batppuccin theme is active")))
         (merged (append batppuccin-override-colors-alist palette)))
    (cdr (assoc name merged))))

;;;###autoload
(defmacro batppuccin-with-colors (&rest body)
  "Bind all palette colors for the current Batppuccin theme and evaluate BODY.
Inside BODY, each palette color is available as a local variable,
e.g. `bat-blue', `bat-base', etc.

Example:
  (batppuccin-with-colors
    (set-face-attribute \\='some-face nil :foreground bat-blue))"
  (declare (indent 0))
  `(let* ((--bat-palette
           (append batppuccin-override-colors-alist
                   (or (batppuccin--palette-for batppuccin--current)
                       (error "No Batppuccin theme is active"))))
          ,@(mapcar (lambda (entry)
                      `(,(intern (car entry))
                        (cdr (assoc ,(car entry) --bat-palette))))
                    batppuccin-mocha-colors-alist))
     ,@body))

;;; Interactive Palette Viewer

(defun batppuccin-list-colors (&optional theme)
  "Display all palette colors for the current Batppuccin theme.
With prefix argument, prompt for THEME variant."
  (interactive
   (list (when current-prefix-arg
           (intern (completing-read "Variant: "
                                    (mapcar #'symbol-name batppuccin--variants)
                                    nil t)))))
  (let* ((variant (or theme batppuccin--current
                      (error "No Batppuccin theme is active")))
         (palette (or (batppuccin--palette-for variant)
                      (error "Unknown theme: %s" variant)))
         (merged (append batppuccin-override-colors-alist palette))
         (buf (get-buffer-create (format "*Batppuccin Palette: %s*" variant))))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (insert (format "Palette for %s\n\n" variant))
        (dolist (entry merged)
          (let ((name (car entry))
                (color (cdr entry)))
            (insert (format "  %-25s  %s  " name color))
            (insert (propertize "  sample  "
                                'face `(:foreground ,color)))
            (insert (propertize "  sample  "
                                'face `(:background ,color
                                        :foreground ,(if (< (batppuccin--relative-luminance color) 0.5)
                                                         "#ffffff" "#000000"))))
            (insert "\n")))
        (goto-char (point-min)))
      (special-mode))
    (pop-to-buffer buf)))

(defun batppuccin--relative-luminance (hex)
  "Return the relative luminance of HEX color string.
Uses the WCAG 2.0 formula."
  (let* ((rgb (color-name-to-rgb hex))
         (r (nth 0 rgb))
         (g (nth 1 rgb))
         (b (nth 2 rgb))
         (adjust (lambda (c)
                   (if (<= c 0.03928)
                       (/ c 12.92)
                     (expt (/ (+ c 0.055) 1.055) 2.4)))))
    (+ (* 0.2126 (funcall adjust r))
       (* 0.7152 (funcall adjust g))
       (* 0.0722 (funcall adjust b)))))

;;; User Commands

(defvar batppuccin--current nil
  "The currently active Batppuccin theme, or nil.")

(defconst batppuccin--variants
  '(batppuccin-mocha batppuccin-macchiato batppuccin-frappe batppuccin-latte)
  "List of all Batppuccin theme variants.")

;;;###autoload
(defun batppuccin-reload ()
  "Reload the current Batppuccin theme.
Useful after changing `batppuccin-override-colors-alist' or
`batppuccin-scale-headings' without having to call `load-theme'
manually."
  (interactive)
  (if batppuccin--current
      (progn
        (load-theme batppuccin--current t)
        (run-hook-with-args 'batppuccin-after-load-hook batppuccin--current))
    (user-error "No Batppuccin theme is currently active")))

;;;###autoload
(defun batppuccin-select ()
  "Select and load a Batppuccin theme variant interactively."
  (interactive)
  (let* ((names (mapcar #'symbol-name batppuccin--variants))
         (choice (intern (completing-read "Batppuccin theme: " names nil t))))
    (mapc #'disable-theme batppuccin--variants)
    (load-theme choice t)
    (setq batppuccin--current choice)
    (run-hook-with-args 'batppuccin-after-load-hook choice)))

(defun batppuccin--set-current (theme)
  "Record THEME as the active Batppuccin theme.
Called from `enable-theme-functions'."
  (when (memq theme batppuccin--variants)
    (setq batppuccin--current theme)))

(defun batppuccin--clear-current (theme)
  "Clear the active Batppuccin theme if THEME is being disabled.
Called from `disable-theme-functions'."
  (when (eq theme batppuccin--current)
    (setq batppuccin--current nil)))

(when (boundp 'enable-theme-functions)
  (add-hook 'enable-theme-functions #'batppuccin--set-current)
  (add-hook 'disable-theme-functions #'batppuccin--clear-current))

(provide 'batppuccin)

;; Local Variables:
;; no-byte-compile: t
;; indent-tabs-mode: nil
;; End:

;;; batppuccin.el ends here
