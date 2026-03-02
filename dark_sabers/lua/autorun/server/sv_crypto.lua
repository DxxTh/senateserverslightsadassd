lts = lts or {}
function lts.generateHash(a)
	a=a or 128
	local c = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
	local r = ''
	math.randomseed(os.time())
	for i = 1,a do
		local randIndex = math.random(#c)
		r = r .. c:sub(randIndex, randIndex)
	end
	return r
end

function lts.freshKey(p)
    p=p or ""
    local a = lts.generateHash()
    while getData(p..a,nil) do
        a = lts.generateHash()
    end
    return a
end
