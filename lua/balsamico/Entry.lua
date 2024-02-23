--- @class Entry
---
--- @field type Entry.Type
--- @field name string
--- @field path string
--- @field children Entry[] | nil
--- @field symlink_target string | nil
local M = {};

--- @enum Entry.Type
local Type = {
	File = 0,
	Dir = 1,
}

M.Type = Type

--- @param path Path
--- @return Entry
function M:new_file(path)
	return {
		parent = self,
		type = Type.File,
		path = path,
		children = nil
	};
end

--- @param path Path
--- @return Entry
function M:new_dir(path)
	return {
		parent = self,
		type = Type.Dir,
		path = path,
		children = nil
	}
end

--- @param target string | nil
function M:symlink(target)
	self.symlink_target = target
end

--- @param children Entry[]
function M:set_expanded(children)
	self.children = children
end

function M:set_collapsed()
	self.children = nil
end

--- @return boolean
function M:is_expanded()
	return self.children ~= nil
end

--- @return boolean
function M:is_dir()
	return self.type == Type.Dir
end

--- @return boolean
function M:is_file()
	return self.type == Type.File
end

return M
