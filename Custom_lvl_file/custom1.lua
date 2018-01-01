
-- print out a table's members
function dump(obj)
	if type(obj) == 'table' then
		for k,v in pairs(obj) do
			print( type(v)..':'..tostring(k)) 
		end
	else
		print( type(v) ..': ' .. tostring(obj))
	end
end
