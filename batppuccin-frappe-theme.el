;;; batppuccin-frappe-theme.el --- Batppuccin theme (Frappe variant) -*- lexical-binding: t; -*-

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

;; The "Frappe" variant of Batppuccin -- medium-dark flavor.
;; See `batppuccin-themes.el' for the shared infrastructure.

;;; Code:

(require 'batppuccin-themes)

(deftheme batppuccin-frappe "A soothing pastel medium-dark theme.")

(batppuccin--apply-theme 'batppuccin-frappe batppuccin-frappe-colors-alist)

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(provide-theme 'batppuccin-frappe)

;; Local Variables:
;; no-byte-compile: t
;; indent-tabs-mode: nil
;; End:

;;; batppuccin-frappe-theme.el ends here
