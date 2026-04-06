;;; batppuccin-macchiato-theme.el --- Batppuccin theme (Macchiato variant) -*- lexical-binding: t; -*-

;; Copyright (C) 2026 Bozhidar Batsov

;; Author: Bozhidar Batsov <bozhidar@batsov.dev>

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

;; The "Macchiato" variant of Batppuccin -- dark flavor.
;; See `batppuccin.el' for the shared infrastructure.

;;; Code:

(require 'batppuccin)

(deftheme batppuccin-macchiato "A soothing pastel dark theme.")

(batppuccin--apply-theme 'batppuccin-macchiato batppuccin-macchiato-colors-alist)

;;;###autoload
(and load-file-name
     (boundp 'custom-theme-load-path)
     (add-to-list 'custom-theme-load-path
                  (file-name-as-directory
                   (file-name-directory load-file-name))))

(provide-theme 'batppuccin-macchiato)

(provide 'batppuccin-macchiato-theme)

;; Local Variables:
;; no-byte-compile: t
;; indent-tabs-mode: nil
;; End:

;;; batppuccin-macchiato-theme.el ends here
