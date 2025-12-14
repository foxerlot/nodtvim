i made this readme with chatgpt btw
# nodtvim

A lightweight, opinionated **Neovim configuration** focused on speed, clarity, and built‑in functionality — with minimal external dependencies.

nodtvim ships with its own file explorer, statusline, and tabline, designed to feel native to Neovim and easy to understand or extend.

---

## ✨ Features

### 📁 Built‑in File Explorer

A simple, fast file explorer written directly for nodtvim.

**Keybindings inside the explorer:**

|     Key | Action                               |
| ------: | ------------------------------------ |
|     `q` | Quit the file explorer               |
|     `p` | Preview the selected file in a popup |
| `Enter` | Open the selected file               |

The explorer is implemented as a UI (non‑file) buffer and integrates cleanly with Neovim windows.

---

### 📊 Built‑in Statusline

A custom statusline included by default, providing essential editor information without relying on third‑party plugins.

* Lightweight
* Minimal
* Fully controlled by the config

---

### 📑 Built‑in Tabline

nodtvim also includes its own tabline for managing buffers and tabs in a clean, consistent way.

---

## 📦 Installation

> **Recommended:** Use this config as a standalone Neovim setup.

```bash
# Backup existing config (optional)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone nodtvim
git clone https://github.com/yourusername/nodtvim ~/.config/nvim
```

Then start Neovim:

```bash
nvim
```

---

## 🎯 Philosophy

nodtvim aims to:

* Prefer **built‑in Lua** over heavy plugin stacks
* Be **readable and hackable**
* Avoid unnecessary abstraction
* Feel like *Neovim*, not a framework on top of it

If you enjoy understanding how your editor works, nodtvim is meant to be explored and modified.

---

## 🛠 Customization

All components (file explorer, statusline, tabline) are implemented in Lua and can be customized directly.

Feel free to fork, modify, or strip things down to suit your workflow.

Happy hacking ✨
