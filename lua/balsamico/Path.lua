--- @class Path
--- @field [number] string
local M = {}

--- @return Path
function M:new()
	return { parent = self }
end

--- @param path_str string
--- @return Path
function M:from(path_str)
	local path = self:new()
	path:join(path_str)
	return path
end

--- @param segment string
function M:push(segment)
	for i = 1, #segment do
		if segment[i] == "/" then
			error("Path segment contains illegal character '/'", 2)
		end
	end

	if segment == "." or segment == "" then
		return
	elseif segment == ".." then
		self[#self] = nil
	else
		self[#self + 1] = segment
	end
end

--- @param path_str string
--- @return Path
function M:join(path_str)
	local path = M:new()
	for i = 1, #self do
		path:push(self[i])
	end

	local start = 1
	if path_str[1] == "/" then
		self = M:new()
		start = 2
	end
	local segment = ""
	for i = start, #path_str do
		if path_str[i] == "/" then
			self:push(segment)
			segment = ""
		else
			segment = segment .. path_str[i]
		end
	end
	path:push(segment)
	return path
end

function M:filename()
	return self[#self]
end

function M:__tostring()
	local str = ""
	for segment_num = 1, #self do
		str = str .. "/" .. self[segment_num]
	end
	return str
end

return M
