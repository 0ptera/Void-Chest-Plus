---- runtime Events ----
function OnEntityCreated(event)
	if event.created_entity.name == "void-chest" then

    event.created_entity.infinity_filters = {}
    event.created_entity.remove_unfiltered_items = true
	end
end


do---- Init ----
local function init_chests()
  -- gather all void chests on every surface in case another mod added some
	global.VoidChests = nil
   for _, surface in pairs(game.surfaces) do
    chests = surface.find_entities_filtered {
      name = "void-chest",
    }
    for _, chest in pairs(chests) do
      chest.infinity_filters = {}
      chest.remove_unfiltered_items = true
    end
  end
end

local function init_events()
	script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, OnEntityCreated)
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