# tomat.nvim

#### Demo

#### Why?

#### Required system dependencies

You also need nerdfonts patched version installed to get proper symbols.
Get fonts from [here](https://github.com/ryanoasis/nerd-fonts).

#### How to install

Using lazy package manager:

```lua
"JesperLundberg/tomat.nvim
```

#### Available commands

Example (To start a session):

```
:tomat start
```

| Command | Description     |
| ------- | --------------- |
| Start   | Start a session |
| Stop    | Stop a session  |
| Show    | Show timer      |

#### TODO

#### Local development

To run tests:

```bash
nvim --headless --noplugin -u tests/minimal.vim -c "PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal.vim'}"
```

#### Credits
