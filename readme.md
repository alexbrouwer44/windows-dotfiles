# Setup
1.) Install neovim <br />
2.) Install a nerd font from https://www.nerdfonts.com/. This will have file icons and programming ligitures <br />
3.) Install chocolatey on windows <br />
4.) Install windows terminal preview (personal preference) https://apps.microsoft.com/store/detail/windows-terminal-preview/9N8G5RFZ9XK3 <br />
5.) You can set the font in the settings of windows terminal preview and that is the font + symbols that nvim will use <br />
6.) Install zig on via chocolatey `choco install zig` <br />
7.) From the dotfiles directory use a bash terminal and run `touch .install` and then `chmod +x install` <br />
8.) Run `./install` - this will setup the nvim app data directories and files <br />
9.) Run `nvim` - this will open neovim <br />
10.) Within nvim normal mode, you can enter commands by entering :. Enter the command `:PackerSync` - this will install all of your plugins <br />
11.) To ensure your treesitter is working correctly, run `:TSUpdate` <br />
12.) Change keymaps in `keymaps.lua` to fit your liking. <br />
