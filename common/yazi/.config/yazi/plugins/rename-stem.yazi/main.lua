-- rename-stem.yazi/main.lua
-- Clears the filename stem and keeps the extension.
-- Equivalent to ranger's: map cr eval fm.open_console('rename .' + fm.thisfile.extension, position=7)

--- @sync entry
local function entry()
	local h = cx.active.current.hovered
	if not h then return end

	local name = h.url:name()
	if not name then return end

	local ext = name:match("%.[^.]+$")

	if ext then
		ya.emit("rename", { name = ext, cursor = 0 })
	else
		ya.emit("rename", { cursor = "start" })
	end
end

return { entry = entry }