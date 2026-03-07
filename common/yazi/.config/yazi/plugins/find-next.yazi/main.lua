-- find-next.yazi/main.lua
-- Reads the last saved search term and jumps to the next match.
-- Replaces the default 'n' bind.

local CACHE = os.getenv("HOME") .. "/.cache/yazi/last-search"

local function entry(_, job)
	local reverse = job.args[1] == "reverse"

	local file = io.open(CACHE, "r")
	if not file then
		ya.notify { title = "Find", content = "No previous search", timeout = 2, level = "warn" }
		return
	end

	local term = file:read("*l")
	file:close()

	if not term or term == "" then
		ya.notify { title = "Find", content = "No previous search", timeout = 2, level = "warn" }
		return
	end

	ya.emit("find", { term, smart = true })
	ya.emit("find_arrow", { reverse = reverse })
end

return { entry = entry }
