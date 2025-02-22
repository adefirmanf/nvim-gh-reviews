vim.api.nvim_create_user_command("GhPrReviews", function()
	require("nvim-gh-reviews").get_pr_reviews();
end, {})
