-- find-save.yazi/main.lua
-- Prompts for a search term, saves it to disk, then runs find.
-- This replaces the default '/' bind.

local CACHE = os.getenv("HOME") .. "/.cache/yazi/last-search"

local function entry()
	local value, event = ya.input {
		title = "Find:",
		position = { "top-center", y = 2, w = 40 },
	}

	if event ~= 1 or value == "" then return end

	-- Save the term to disk
	local file = io.open(CACHE, "w")
	if file then
		file:write(value)
		file:close()
	end

	ya.emit("find", { value, smart = true })
end

return { entry = entry }
