return { -- docstrings / annotation comments
  "danymat/neogen",
  opts = true,
  keys = {
    {
      "qf",
      function() require("neogen").generate { type = "func" } end,
      desc = " Function Annotation",
    },
    {
      "qF",
      function() require("neogen").generate { type = "file" } end,
      desc = " File Annotation",
    },
    {
      "qt",
      function() require("neogen").generate { type = "type" } end,
      desc = " Type Annotation",
    },
  },
}
