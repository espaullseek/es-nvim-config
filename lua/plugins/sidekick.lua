return {
  "folke/sidekick.nvim",
  opts = {
    nes = {
      enabled = false,
    },
    cli = {
      prompts = {
        test_file = {
          msg = "Can you run the tests for this file please. Use the command 'pnx test <file_name>.test.ts'",
          location = {
            row = false,
            col = false,
          },
        },
        tests = {
          msg = "Can you create tests for this file please. Use the name of the file and add '.test.ts' to the end of it",
          location = {
            row = false,
            col = false,
          },
        },
        optimize = {
          msg = "Can you suggest any optimisations or improvements for this file?",
          location = {
            row = false,
            col = false,
          },
        },
        fix = {
          msg = "Can you fix these errors in this file please, and then run 'pnx lint <file_name> from the root to make sure they are fixed.",
          location = {
            row = false,
            col = false,
          },
        },
      },
    },
  },
}
