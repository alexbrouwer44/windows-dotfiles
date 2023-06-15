# Setup
1.) Install neovim
2.) Install a nerd font from https://www.nerdfonts.com/. This will have file icons and programming ligitures
3.) Install chocolatey on windows
4.) Install windows terminal preview (personal preference) https://apps.microsoft.com/store/detail/windows-terminal-preview/9N8G5RFZ9XK3
5.) You can set the font in the settings of windows terminal preview and that is the font + symbols that nvim will use
6.) Install zig on via chocolatey `choco install zig`
7.) From the dotfiles directory use a bash terminal and run `touch .install` and then `chmod +x install`
8.) Run `./install` - this will setup the nvim app data directories and files
9.) Run `nvim` - this will open neovim
10.) Within nvim normal mode, you can enter commands by entering :. Enter the command `:PackerSync` - this will install all of your plugins
11.) To ensure your treesitter is working correctly, run `:TSUpdate`
12.) Change keymaps in `keymaps.lua` to fit your liking.
