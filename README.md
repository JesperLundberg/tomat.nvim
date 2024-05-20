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
},
config = function()
    require("tomat").setup({
        session_time_in_minutes = 50,
    })
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

- [ ] Implement the functionality for automatically starting a new pomodoro session
  - [ ] Add break time

#### Local development

To run tests:

```bash
nvim --headless --noplugin -u tests/minimal.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}"
```

#### Credits
