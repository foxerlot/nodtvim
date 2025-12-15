# NodtVim

A lightweight neovim configuration that includes tabline, statusline, file explorer, and splash-screen features. 
NodtVim ships with no external plugins making it easy to set up.
all extensions in NodtVim are written entirely in lua

### 📦 installation

Just set your init.lua file to the NodtVim init.lua file and then add the lua directory to your neovim config directory.
Your neovim config directory should look something like this:
```bash
~/.config/nvim
    init.lua
    src/
```

### 📁 Built‑in File Explorer

A simple, fast file explorer written directly for NodtVim.

**Keybindings inside the explorer:**

|     Key | Action                               |
| ------: | ------------------------------------ |
|     `q` | Quit the file explorer               |
|     `p` | Preview the selected file in a popup |
| `Enter` | Open the selected file               |
