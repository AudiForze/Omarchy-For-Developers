return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg         = "#171723",
        dark_bg    = "#11111a",
        darker_bg  = "#0c0c12",
        lighter_bg = "#2e2e39",

        fg         = "#bdc9f1",
        dark_fg    = "#8e97b5",
        light_fg   = "#c7d1f3",
        bright_fg  = "#ced7f5",
        muted      = "#383948",

        red        = "#f17598",
        yellow     = "#f7d997",
        orange     = "#f38aa7",
        green      = "#93dd8d",
        cyan       = "#84decf",
        blue       = "#71a5f9",
        purple     = "#bd8df5",
        brown      = "#925364",

        bright_red    = "#f17598",
        bright_yellow = "#f7d997",
        bright_green  = "#93dd8d",
        bright_cyan   = "#84decf",
        bright_blue   = "#71a5f9",
        bright_purple = "#bd8df5",

        accent               = "#71a5f9",
        cursor               = "#bdc9f1",
        foreground           = "#bdc9f1",
        background           = "#171723",
        selection             = "#2e2e39",
        selection_foreground = "#bdc9f1",
        selection_background = "#2e2e39",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
