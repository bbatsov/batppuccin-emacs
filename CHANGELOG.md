# Changelog

## main (unreleased)

- [#20](https://github.com/bbatsov/batppuccin-emacs/pull/20): Add appearance options: customizable heading scale factors (`batppuccin-height-1` through `-height-3` and `-height-doc-title`), `batppuccin-use-variable-pitch`, `batppuccin-italic-comments` and `batppuccin-flat-mode-line`.
- [#22](https://github.com/bbatsov/batppuccin-emacs/pull/22): Fix `batppuccin-get-color`,
  `batppuccin-with-colors`, `batppuccin-reload` and `batppuccin-list-colors` failing with
  "No Batppuccin theme is active" on Emacs 27 and 28, which never recorded the active variant.
- [#22](https://github.com/bbatsov/batppuccin-emacs/pull/22): Make face text readable on its
  own background; `show-paren-match` was 1.64:1 in Latte and `show-paren-mismatch` 2.70:1 in Frappe.
- [#22](https://github.com/bbatsov/batppuccin-emacs/pull/22): Stop `bookmark-face`,
  `gnus-summary-cancelled`, `ido-indicator` and `whitespace-empty` sitting on the buffer
  background, which lifted nothing and hid `hl-line` underneath.

## 1.1.0 (2026-07-26)

- [#19](https://github.com/bbatsov/batppuccin-emacs/pull/19): Add face support for breadcrumb.
- [#19](https://github.com/bbatsov/batppuccin-emacs/pull/19): Add face support for gptel.
- [#18](https://github.com/bbatsov/batppuccin-emacs/pull/18): Expand face coverage to anzu, jinx, completion-preview, dictionary, asciidoc-mode, vundo, volatile-highlights, easy-kill, clojure-mode, copilot, git-timemachine, haskell-mode, keycast, mistty, erlang and inf-ruby.
- [#18](https://github.com/bbatsov/batppuccin-emacs/pull/18): Round out the cider section (eval result, fringe states, debug prompt) and add the nREPL message log and `corfu-popupinfo` faces.
- Add face for built-in which-func package.
- Fix `batppuccin-scale-headings` not affecting org-mode and other outline-based headings.
- Give `markdown-code-face` an explicit background so code blocks no longer pick up a dark fallback when using Latte.
- Add face coverage for the `diredfl` package.
- Add face for Emacs 31 `minibuffer-nonselected-mode`.
- Set `ns-appearance` to match each flavor on macOS so the Latte title bar text stays readable.

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
