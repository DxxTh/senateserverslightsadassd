local cached_materials = {}

function registerMaterial(png)
	if png and png ~= "" then
		file.CreateDir("lordtylersservers")
		if not cached_materials[png] then
			if file.Exists("data/lordtylersservers/" .. png, "DATA") then
				local name = string.sub(png, 1, string.len(png) - 4)
				local path = "data/"..png
				local vmt = {
					["$basetexture"] = path,
					["$surfaceprop"] = "gravel",
					["$model"] = 1,
					["$model"] = 1,
					["$vertexcolor"] = 1,
					["$envmap"] =  "",
					["$translucent"] = 1,
					["$vertexalpha"] = 1,
					["$reflectivity"] = "[1 1 1]"
				}
				local material = CreateMaterial(name,"VertexLitGeneric",vmt)
				material:SetTexture("$basetexture",Material(path," noclamp"):GetName())
				material:SetInt("$flags",(32+2097152)*0)
				cached_materials = material
			else
				--print("https://www.lordtyler.com/lordtylersservers/" .. png)
				http.Fetch("https://www.lordtyler.com/lordtylersservers/" .. png,function(body,_,headers)
					local name = string.sub(png, 1, string.len(png) - 4)
					local path = "data/"..png
					file.Write(png,body)
					local vmt = {
						["$basetexture"] = path,
						["$surfaceprop"] = "gravel",
						["$model"] = 1,
						["$model"] = 1,
						["$vertexcolor"] = 1,
						["$envmap"] =  "",
						["$translucent"] = 1,
						["$vertexalpha"] = 1,
						["$reflectivity"] = "[1 1 1]"
					}
					local material = CreateMaterial(name,"VertexLitGeneric",vmt)
					material:SetTexture("$basetexture",Material(path," noclamp"):GetName())
					material:SetInt("$flags",(32+2097152)*0)
					cached_materials = material
				end)
			end
		end
	end
end