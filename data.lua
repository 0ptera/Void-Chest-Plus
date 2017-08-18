data:extend {
  {
    type = "container",
    name = "void-chest",
    icon = "__VoidChestPlus__/graphics/icon/voidchest.png",
    flags = {"placeable-neutral", "player-creation"},
    minable = {mining_time = 1, result = "void-chest"},
    max_health = 200,
    corpse = "small-remnants",
    open_sound = { filename = "__base__/sound/metallic-chest-open.ogg", volume=0.65 },
    close_sound = { filename = "__base__/sound/metallic-chest-close.ogg", volume = 0.7 },
    resistances =
    {
      {
        type = "fire",
        percent = 90
      }
    },
    collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
    selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
    fast_replaceable_group = "container",
    inventory_size = 48,
    picture =
    {
      filename = "__VoidChestPlus__/graphics/voidchest.png",
      priority = "extra-high",
      width = 38,
      height = 32,
      shift = {0.1, 0}
    }
	},
  {
    type = "item",
    name = "void-chest",
    icon = "__VoidChestPlus__/graphics/icon/voidchest.png",
    flags = {"goes-to-quickbar"},
    subgroup = "storage",
    order = "a[items]-c[void-chest]",
    place_result = "void-chest",
    stack_size = 50
	},
  {
    type = "recipe",
    name = "void-chest",
    enabled = "true",
    ingredients =
    {
      {"steel-chest", 1},
      {"steel-furnace", 1},
      {"electronic-circuit", 3}
    },
    result = "void-chest"
	},

}