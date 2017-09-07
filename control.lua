
---- Mod Settings ----
local update_interval = settings.global["vcp-update-interval"].value

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if not event then return end
  if event.setting == "vcp-update-interval" then
    update_interval = settings.global["vcp-update-interval"].value
  end
end)


---- runtime Events ----
function OnEntityCreated(event)
	if event.created_entity.name == "void-chest" then

    table.insert(global.VoidChests, event.created_entity)

    -- register to events after placing the first chest
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

    -- unregister when last chest was removed
    if #global.VoidChests == 0 then
      script.on_event(defines.events.on_tick, nil)
      script.on_event({defines.events.on_preplayer_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, nil)
    end
  end
end

-- stepping from tick modulo with stride by eradicator
-- tested with 480 chests over 100.000 ticks: 11776.126 ms / 10162.627 ms with clear_items_inside()
function OnTick(event)
  local offset = game.tick % update_interval
  for i=#global.VoidChests - offset, 1, -1 * update_interval do
    global.VoidChests[i].clear_items_inside()
    -- log("[VCP] "..game.tick.." clearing chest id "..global.VoidChests[i].unit_number)
  end
end


do---- Init ----
local function init_chests()
  -- gather all void chests on every surface in case another mod added some
	global.VoidChests = {}
   for _, surface in pairs(game.surfaces) do
    chests = surface.find_entities_filtered {
      name = "void-chest",
    }
    for _, chest in pairs(chests) do
      table.insert(global.VoidChests, chest)
    end
  end
end

local function init_events()
	script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, OnEntityCreated)
	if global.VoidChests and next(global.VoidChests) then
		script.on_event(defines.events.on_tick, OnTick)
		script.on_event({defines.events.on_preplayer_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died}, OnEntityRemoved)
	end
end

script.on_load(function()
  init_events()
end)

script.on_init(function()
  init_chests()
  init_events()
end)

script.on_configuration_changed(function(data)
  init_chests()
	init_events()
end)

end