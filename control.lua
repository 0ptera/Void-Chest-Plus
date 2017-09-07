
---- Mod Settings ----
local update_interval = settings.global["vcp-update-interval"].value

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if not event then return end
  if event.setting == "vcp-update-interval" then
    update_interval = settings.global["vcp-update-interval"].value
    ResetStride()
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

    ResetStride()
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

    ResetStride()
  end
end

-- stepping from tick modulo with stride by eradicator
-- tested with 480 chests over 100.000 ticks: 11776.126 ms
function OnTick(event)
  local offset = game.tick % update_interval
  for i=#global.VoidChests - offset, 1, -1 * update_interval do
    global.VoidChests[i].clear_items_inside()
    -- log("[VCP] "..game.tick.." clearing chest id "..global.VoidChests[i].unit_number)
  end
end

-- tested with 480 chests over 100.000 ticks: 11805.281 ms
-- function OnTick(event)
  -- global.tickCount = global.tickCount or 1
  -- global.chestIndex = global.chestIndex or 1

  -- -- only work if index is within bounds
  -- if global.chestIndex <= #global.VoidChests then
    -- local stopIndex = global.chestIndex + global.VoidChestStride - 1
    -- if stopIndex >= #global.VoidChests then
      -- stopIndex = #global.VoidChests
    -- end

    -- -- log("[VCP] "..global.tickCount.." / "..game.tick.." clearing chest ids "..global.chestIndex.." to "..stopIndex)
    -- for i=global.chestIndex, stopIndex do
      -- global.VoidChests[i].get_inventory(defines.inventory.chest).clear()
    -- end
    -- global.chestIndex = stopIndex + 1
  -- end

  -- -- reset clock and chest index
  -- if global.tickCount < update_interval then
    -- global.tickCount = global.tickCount + 1
  -- else
    -- global.tickCount = 1
    -- global.chestIndex = 1
  -- end
-- end

-- function OnTick(event)
	-- local tick = game.tick
	-- for i=1, #global.VoidChests do
		-- if (i + tick) % update_interval == 0 then
			-- global.VoidChests[i].get_inventory(defines.inventory.chest).clear()
		-- end
	-- end
-- end

-- recalculates how many chests are updated each tick
function ResetStride()
  if #global.VoidChests > update_interval then
    global.VoidChestStride =  math.ceil(#global.VoidChests/update_interval)
  else
    global.VoidChestStride = 1
  end
  -- log("[VCP] stride = "..global.VoidChestStride)
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

  ResetStride()
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