# tomat.nvim

#### Demo

#### Why?

I wanted to work more with writing plugins for neovim and I also wanted to use the pomodoro method more in my daily work flow.

#### Required system dependencies

You also need nerdfonts patched version installed to get proper symbols.
Get fonts from [here](https://github.com/ryanoasis/nerd-fonts).

#### How to install

Using lazy package manager:

```lua
"JesperLundberg/tomat.nvim",
dependencies = {
    "rcarriga/nvim-notify",
    "nvim-lua/plenary.nvim",
},
config = function()
    require("tomat").setup({})
end,
```

#### Available commands

Example (To start a session):

```
:tomat start
```

| Command | Description                           |
| ------- | ------------------------------------- |
| start   | Start a session                       |
| stop    | Stop a session                        |
| show    | Show when the current timer is ending |

#### TODO

- [x] Write session to file so it can be resumed if neovim is restarted
- [ ] Automatically resume session at start up (if it exists)
- [ ] Allow user to set the path for the file themselves
- [ ] Implement the functionality for automatically starting a new pomodoro session
  - [ ] Add break time

#### Local development

To run tests:

```bash
nvim --headless --noplugin -u tests/minimal.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}"
```

#### Credits
