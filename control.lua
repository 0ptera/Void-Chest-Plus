local update_interval = settings.global["vcp-update-interval"].value

---- Events ----
script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if not event then return end
  if event.setting == "vcp-update-interval" then update_interval = settings.global["vcp-update-interval"].value end  
end)

function OnEntityCreated(event)
	if event.created_entity.name == "void-chest" then	
    table.insert(global.VoidChests, event.created_entity)
    if #global.VoidChests == 1 then
      script.on_event(defines.events.on_tick, OnTick)
      script.on_event({defines.events.on_preplayer_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, OnEntityRemoved)
    end
	end
end

function OnEntityRemoved(event)
	if event.entity.name == "void-chest" then		
    for i=#global.VoidChests, 1, -1 do    
      if global.VoidChests[i].unit_number == event.entity.unit_number then
        table.remove(global.VoidChests, i)
      end
    end    
    if #global.VoidChests == 0 then
      script.on_event(defines.events.on_tick, nil)
      script.on_event({defines.events.on_preplayer_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, nil)
    end
  end
end

function OnTick(event)
	local tick = game.tick
	for i=1, #global.VoidChests do		
		if (i + tick) % update_interval == 0 then
			global.VoidChests[i].get_inventory(defines.inventory.chest).clear()
		end
	end
end

---- Bootstrap ----
function init_events()
	script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, OnEntityCreated)
	if global.VoidChests and next(global.VoidChests) then
		script.on_event(defines.events.on_tick, OnTick)
		script.on_event({defines.events.on_preplayer_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, OnEntityRemoved)
	end
end

script.on_init(function()
  global.VoidChests = global.VoidChests or {}
  init_events()
end)

script.on_load(function()
  init_events()
end)

script.on_configuration_changed(function(data)
	global.VoidChests = {}
   for _, surface in pairs(game.surfaces) do
    chests = surface.find_entities_filtered {
      name = "void-chest",
    }
    for _, chest in pairs(chests) do
      table.insert(global.VoidChests, chest)
    end
  end
	init_events()
end)
