# nvim-gh-reviews
![Neovim](https://img.shields.io/badge/NeoVim-%2357A143.svg?&style=for-the-badge&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/lua-%232C2D72.svg?style=for-the-badge&logo=lua&logoColor=white)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white&style=for-the-badge)](https://conventionalcommits.org)
![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg?style=for-the-badge)

Fetches and shows GitHub PR comments. Works with Neovim's quickfix list for easy navigation. You can also use it with plugins like [nvim-bqf](https://github.com/kevinhwang91/nvim-bqf) for a better quickfix experience.

To use this plugin, switch to the branch where you got feedback or reviews from your team and run the `:GhReviews` command. It will automatically 
open the quickfix list. 
To close the quicklist, you can use `:cclose`.  

**Nvim**
![Screen Recording 2025-02-22 at 20 43 42](https://github.com/user-attachments/assets/0152040f-b6b8-46d2-8542-90ee2238066e)

Here the example of PR: https://github.com/adefirmanf/blog-v2/pull/1

Be careful! This plugin will replace the existing quickfix list. If you're using quickfix for LSP or other integrations, running the command will likely overwrite it.


# 🔥 Installation 
`nvim-gh-reviews` requires the GitHub CLI (gh) to function properly.
## Prerequisites
* [Neovim](https://neovim.io/) >= v0.8
* [Github-CLI](https://cli.github.com/)

## Usage
### Lazy.nvim
```lua
return {
  "adefirmanf/nvim-gh-reviews",
  opts = {}
}

```

# ⌨️ Commands
> [:h nvim-gh-reviews-commands]()
- `:GhReviews` - Fetch PR comments and display them in the quickfix list.


# 🌃 Todo
 - [ ] Resolve and reply to the PR comments. 
 - [ ] Display the PR comments from the base PR. `In progress`
 - [ ] More configuration! `In progress`
 - [ ] Window integration. `In progress`
 - [ ] Unit test.

# Contributions
Any contribution is welcome! 

# Only test from Coderabbit
