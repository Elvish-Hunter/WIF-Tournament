local helper = wesnoth.require "lua/helper.lua"
local wml_actions = wesnoth.wml_actions

function wml_actions.wif_store_teleport_location( cfg )
	local starting_loc = wesnoth.get_locations( cfg )[1] --get only the first matching location

	-- offset_x and offset_y are two comma separated lists in WML
	-- so we need to split them, then convert them as tables
	local offset_x = {}
	for value in cfg.offset_x:gmatch( "[^,]*" ) do
		table.insert( offset_x, tonumber( value ) ) -- value is a string
	end
	local offset_y = {}
	for value in cfg.offset_y:gmatch( "[^,]*" ) do
		table.insert( offset_y, tonumber( value ) )
	end

	-- verify that both lists have equal length
	if not #offset_x == #offset_y then helper.wml_error "[wif_store_teleport_location]: offset_x and offset_y have a different number of elements" end

	local final_loc = starting_loc -- locations are stored as tables with two elements

	-- for each offset, calculate the resulting location and verify that's empty
	for i = 1, #offset_x do
		local new_x = starting_loc[1] + offset_x[i]
		local new_y = starting_loc[2] + offset_y[i]

		if wesnoth.match_location( new_x, new_y, { { "not", { { "filter", {} } } } } ) then
			final_loc = { new_x, new_y }
		end
	end

	-- store the result in a WML variable
	wesnoth.set_variable( cfg.variable or "teleport_location", { x = final_loc[1], y = final_loc[2] } )
end
