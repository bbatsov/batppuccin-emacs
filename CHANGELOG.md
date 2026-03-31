# Changelog

## main (unreleased)

- Support `minibuffer-nonselected-mode`

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
