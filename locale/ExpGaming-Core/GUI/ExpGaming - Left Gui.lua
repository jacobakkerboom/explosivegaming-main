--[[
Explosive Gaming

This file can be used with permission but this and the credit below must remain in the file.
Contact a member of management on our discord to seek permission to use our code.
Any changes that you may make to the code are yours but that does not make the script yours.
Discord: https://discord.gg/XSsBV6b

The credit below may be used by another script do not remove.
]]
local credits = {{
	name='ExpGaming - Left Gui',
	owner='Explosive Gaming',
	dev='Cooldude2606',
	description='A simple way to add toggle menus to the left',
	factorio_version='0.15.23',
	show=false
	}}
local function credit_loop(reg) for _,cred in pairs(reg) do table.insert(credits,cred) end end
--Please Only Edit Below This Line-----------------------------------------------------------
local add_frame = ExpGui.add_frame
local frames = ExpGui.frames
local draw_frame = ExpGui.draw_frame
--left GUIs are always present and only have their visibility toggled
--Add a frame to the left bar; event(player,frame) must be present for left GUIs as there is no default
--vis should be true or false based on the player join game state of the GUI
function add_frame.left(name,default_display,default_tooltip,restriction,vis,event)
	if not name then error('Frame requires a name') end
	if not event or type(event) ~= 'function' then error('Frame requires a draw function') end
	local vis = vis or false
	table.insert(frames.left,{name,default_display,event,vis})
	ExpGui.toolbar.add_button(name,default_display,default_tooltip,restriction,draw_frame.left)
end
--draw the left GUI for the player; called via script, only call manually when update is true and element is the name of the GUI
function draw_frame.left(player,element,update)
	local frame = nil
	local frame_data = nil
	local left = mod_gui.get_frame_flow(player)
	if not update then
		for _,frame in pairs(frames.left) do if element.name == frame[1] then frame_data = frame break end end
		if left[frame_data[1]] then ExpGui.toggle_visible(left[frame_data[1]]) return end
		frame = left.add{name=frame_data[1],type='frame',caption=frame_data[2],direction='vertical',style=mod_gui.frame_style}
	else
		for _,frame in pairs(frames.left) do if element == frame[1] then frame_data = frame break end end
		frame = left[frame_data[1]] 
	end
	if frame then frame.clear() frame_data[3](player,frame) end
end
--used to load all left GUIs
Event.register(defines.events.on_player_joined_game,function(event)
	local player = game.players[event.player_index]
	for _,frame_data in pairs(frames.left) do
		local left = mod_gui.get_frame_flow(player)
		if left[frame_data[1]] then left[frame_data[1]].style.visible = frame_data[4]
		else
			local frame = left.add{name=frame_data[1],type='frame',caption=frame_data[2],direction='vertical',style=mod_gui.frame_style}
			frame_data[3](player,frame)
			frame.style.visible = frame_data[4]
		end
	end
end)

Event.register(Event.rank_change,function(event)
	for _,frame_data in pairs(frames.left) do
		local left = mod_gui.get_frame_flow(event.player)
		if left[frame_data[1]] then left[frame_data[1]].style.visible = frame_data[4] end
	end
end)
--Please Only Edit Above This Line-----------------------------------------------------------
return credits