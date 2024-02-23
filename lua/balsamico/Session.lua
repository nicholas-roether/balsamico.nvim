local Entry = require("lua.balsamico.Entry")

--- @class (exact) SeqItem
---
--- @field depth number
--- @field entry Entry

--- @class Session
---
--- @field path Path
--- @field tree SeqItem[]
--- @field sequence SeqItem[]
local M = {}

--- @param path Path
--- @return SeqItem[]
local function list_dir(path)
	local entries = {}
	for name, type in vim.fs.dir(tostring(path)) do
		local entry
		if type == "directory" then
			entry = Entry:new_dir(path:join(name))
		else
			entry = Entry:new_file(path:join(name))
		end
		entries[#entries + 1] = entry
	end
	return entries
end

--- @param entries Entry[]
--- @param sequence SeqItem[]
local function traverse_tree_impl(entries, sequence, depth)
	for i = 1, #entries do
		sequence[#sequence + 1] = { entry = entries[i], depth = depth }
		if entries[i]:is_dir() and entries[i]:is_expanded() then
			traverse_tree_impl(entries[i].children, sequence, depth + 1)
		end
	end
end

--- @param entries Entry[]
--- @return SeqItem[]
local function traverse_tree(entries)
	local sequence = {}
	traverse_tree_impl(entries, sequence, 0)
	return sequence
end

--- @param path Path
function M:new(path)
	local entries = list_dir(path)
	local sequence = traverse_tree(entries)

	return {
		parent = self,
		path = path,
		entries = entries,
		sequence = sequence
	}
end
