local M = {}

-- Runs a shell command and returns the output
local function run_command(cmd)
	local result = vim.fn.systemlist(cmd)
	if vim.v.shell_error ~= 0 then
		error("Command failed: " .. cmd .. "\nError: " .. table.concat(result, "\n"))
	end
	return table.concat(result, "\n"):gsub("%s+$", "") -- Trim trailing spaces/newlines
end

-- Returns the PR number for the current branch
local function get_pr_number()
	local ok, current_branch = pcall(run_command, "git branch --show-current")
	if not ok then
		error("Error: Not a Git repository or Git command failed.")
		return
	end

	local pr_command =
		"gh pr list --state all --json number,headRefName,baseRefName --jq '.[] | select(.headRefName == \""
		.. current_branch
		.. "\") | .number'"
	local ok, pr_number = pcall(run_command, pr_command)

	if not ok or pr_number == "" then
		vim.notify("Erorr: No open PR found for branch. " .. current_branch, vim.log.levels.WARN)
		return
	end

	return pr_number
end

-- Returns the owner and repo for the current Git repository
local function get_repo_info()
	local url = vim.fn.systemlist("git remote get-url origin")[1]
	if vim.v.shell_error ~= 0 or not url then
		error("Not a Git repository or failed to get remote URL.")
		return nil, nil
	end

	-- Extract owner and repo from URL
	local owner, repo = url:match("github.com[:/](.-)/(.+)%.git")
	if not owner or not repo then
		error("Failed to extract GitHub repo info.")
		return nil, nil
	end

	return owner, repo
end

-- Fetches and displays PR comments
function M.get_pr_reviews()
	vim.notify("Fetching PR Comments...", vim.log.levels.INFO)

	local owner, repo = get_repo_info()

	if not owner or not repo then
		return
	end

	local pr_number = get_pr_number()

	if not pr_number then
		return
	end

	local cmd = string.format(
		"gh api "
		.. '-H "Accept: application/vnd.github.v3+json" '
		.. '-H "X-GitHub-Api-Version: 2022-11-28" '
		.. '"/repos/%s/%s/pulls/%s/comments" | '
		..
		"jq '[group_by(.path)[] | {filename: .[0].path, id: .[0].pull_request_review_id, line: .[0].line, url: .[0].html_url, comments: [ .[] | { user: .user.login, comment: .body } ]}]'",
		owner,
		repo,
		pr_number
	)
	local result = run_command(cmd)

	-- Parse JSON result
	local reviews = vim.fn.json_decode(result)
	if not reviews or #reviews == 0 then
		vim.notify("No PR comments found", vim.log.levels.WARN)
		return
	end
	-- Get Git root directory (for monorepos)
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

	-- Convert to Quickfix List format
	local qflist = {}
	for _, review in ipairs(reviews) do
		local full_path = git_root .. "/" .. review.filename
		local line_number = tonumber(review.line) or 1
		-- Ensure file exists in the repo before adding to quickfix
		if vim.fn.filereadable(full_path) == 1 then
			for _, comment in ipairs(review.comments) do
				table.insert(qflist, {
					filename = full_path,
					lnum = line_number,
					col = 1,
					type = "I",
					text = string.format("@%s: %s", comment.user, comment.comment),
				})
			end
		else
			vim.notify("Skipping missing file: " .. full_path, vim.log.levels.WARN)
		end
	end -- Set Quickfix List

	vim.notify("Found. Total Comments: " .. #qflist, vim.log.levels.INFO)
	vim.fn.setqflist(qflist, "r") -- "r" replaces the list
	vim.cmd("copen")
end

return M
