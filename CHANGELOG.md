# Changelog

## main (unreleased)

- Add face for built-in which-func package.
- Fix `batppuccin-scale-headings` not affecting org-mode and other outline-based headings.
- Give `markdown-code-face` an explicit background so code blocks no longer pick up a dark fallback when using Latte.
- Add face coverage for the `diredfl` package.
- Add face for Emacs 31 `minibuffer-nonselected-mode`.

## 1.0.0 (2026-04-21)

- Published on [MELPA](https://melpa.org/#/batppuccin); package renamed from the shared-infrastructure file to `batppuccin` for MELPA namespace compliance.
- Face coverage expanded to mu4e, notmuch, evil, plus 12 additional packages.
- Fix rainbow-delimiters depth color collisions and give mismatched delimiters a distinct red box outline.
- Refine several face colors: `hi-pink`, `show-paren-mismatch`, `hl-todo`, and `font-lock-property-*`.
- Documentation: new section on automatic light/dark theme switching.

## 0.1.0 (2026-03-29)

Initial release.

- Four separate themes: `batppuccin-mocha`, `batppuccin-macchiato`, `batppuccin-frappe`, `batppuccin-latte`
- All 26 canonical Catppuccin colors with exact hex values from the spec
- Syntax highlighting following the official Catppuccin style guide
- Rainbow heading cycle (red, peach, yellow, green, sapphire, lavender) for outline, org, markdown, shr, and info
- Configurable heading scaling (`batppuccin-scale-headings`)
- Color override mechanism (`batppuccin-override-colors-alist`)
- Interactive commands: `batppuccin-select`, `batppuccin-reload`, `batppuccin-list-colors`
- Palette API: `batppuccin-get-color`, `batppuccin-with-colors` macro
- `batppuccin-after-load-hook` for post-load customization
- Broad face coverage for built-in and third-party packages (magit, vertico, corfu, marginalia, embark, orderless, consult, transient, flycheck, cider, company, doom-modeline, treemacs, web-mode, and more)
