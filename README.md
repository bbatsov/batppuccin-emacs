# Batppuccin

Batppuccin is an opinionated Emacs port of the [Catppuccin](https://github.com/catppuccin/catppuccin) color scheme. It aims to follow the official Catppuccin style guide closely while being structured idiomatically for Emacs.

The name is a play on my last name ([Batsov](https://batsov.com/)) + Catppuccin (cat -> bat). So, that's essentially `@bbatsov`'s take on Catppuccin.[^1]

## Why Another Catppuccin Theme?

The [official catppuccin/emacs](https://github.com/catppuccin/emacs) port has some fundamental issues that are hard to fix incrementally:

### Architectural Problems

- Registers a single `catppuccin` theme and switches flavors via a global variable + reload function. This breaks standard `load-theme` workflows, theme-switching packages like `circadian.el`, and any tooling that expects one theme = one entry in `custom-theme-load-path`. Batppuccin defines four proper themes (`batppuccin-mocha`, `batppuccin-latte`, etc.) that work with `load-theme` out of the box.
- Loads color definitions from an external file using `load-file-name`, which is nil in certain `load-theme` code paths (e.g., when Emacs hasn't marked the theme as safe yet). This causes the theme to fail to load entirely for some users.
- No semantic color layer -- faces reference raw palette colors directly, making it hard to reason about color assignments or adjust them systematically.

### Style Guide Deviations

- `font-lock-variable-name-face` is set to the default text color, making variables indistinguishable from surrounding text. The style guide assigns distinct colors to variables and properties.
- All `outline-*` levels use the same blue, so org-mode headings and any outline-based hierarchy look flat. The style guide specifies a rainbow cycle (red, peach, yellow, green, sapphire, lavender).
- `org-block` forces a green foreground on all unstyled code inside source blocks, instead of inheriting the default text color.
- Search match highlighting uses aggressive red backgrounds where the style guide calls for teal.
- Minibuffer prompt uses a subdued gray (`subtext0`) instead of a prominent color.

### Placeholder Colors in Production

Multiple faces (dired+, diredfl, tree-sitter, whitespace, helm) are set to `#ff00ff` magenta as a "TODO" placeholder. These show up as literal hot pink in real usage.

### Missing Face Coverage

No support for vertico, marginalia, embark, transient, flycheck, doom-modeline, cider, corfu, or several other widely-used packages.

## Approach

Batppuccin follows the conventions established in [zenburn-emacs](https://github.com/bbatsov/zenburn-emacs) and [emacs-tokyo-night-theme](https://github.com/bbatsov/emacs-tokyo-night-theme):

- **One theme file per flavor.** Each variant (`batppuccin-mocha-theme.el`, `batppuccin-latte-theme.el`, etc.) is a thin wrapper that loads the shared infrastructure and applies its palette. Standard Emacs theme machinery works without any special glue.
- **Shared infrastructure in `batppuccin-themes.el`.** Color palettes for all four flavors, the face application function, and a `defcustom` for user color overrides all live in one file. Adding a new variant means defining a color alist and a ~10-line wrapper.
- **All 26 canonical Catppuccin colors** with exact hex values from the spec, plus derived colors for diff backgrounds, selection, cursor line, and the heading rainbow cycle.
- **Follows the Catppuccin style guide** for syntax highlighting (mauve for keywords, green for strings, blue for functions, peach for constants, sky for operators, yellow for types, overlay2 for comments, rosewater for the cursor) and editor UI (lavender for active line numbers, teal for search backgrounds, red/green/blue at low opacity for diffs).
- **Broad face coverage** out of the box -- built-in Emacs faces plus magit, vertico, corfu, marginalia, embark, orderless, consult, transient, flycheck, flymake, cider, company, doom-modeline, treemacs, web-mode, and more.

## Installation

### From Source

Clone the repo and add it to your load path:

```elisp
(add-to-list 'custom-theme-load-path "/path/to/batppuccin-emacs")
```

Then load any flavor:

```elisp
(load-theme 'batppuccin-mocha t)
```

### package-vc-install

```elisp
(package-vc-install "https://github.com/bbatsov/batppuccin-emacs")
(load-theme 'batppuccin-mocha t)
```

### use-package (with package-vc)

```elisp
(use-package batppuccin-mocha-theme
  :vc (:url "https://github.com/bbatsov/batppuccin-emacs" :rev :newest)
  :config
  (load-theme 'batppuccin-mocha t))
```

## Flavors

| Flavor | Description |
|--------|-------------|
| `batppuccin-mocha` | The darkest variant |
| `batppuccin-macchiato` | Dark |
| `batppuccin-frappe` | Medium-dark |
| `batppuccin-latte` | Light |

## Customization

Override any color across all flavors:

```elisp
(setq batppuccin-themes-override-colors-alist
      '(("bat-base" . "#000000")
        ("bat-text" . "#ffffff")))
```

The override alist takes precedence over the built-in palette. Color names match the canonical Catppuccin names with a `bat-` prefix (e.g., `bat-rosewater`, `bat-mauve`, `bat-surface0`).

## License

GNU General Public License v3.0. See [COPYING](COPYING) for details.

[^1]: Naming is hard, but it should also be fun!
