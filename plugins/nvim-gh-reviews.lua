vim.api.nvim_create_user_command("GhReviews", function()
	require("nvim-gh-reviews").get_pr_reviews();
end, {})
