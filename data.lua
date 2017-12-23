local vcp = table.deepcopy(data.raw.container["steel-chest"])
vcp.type = "infinity-container"
vcp.name = "void-chest"
vcp.icon = "__VoidChestPlus__/graphics/icon/voidchest.png"
vcp.icon_size = 32
vcp.minable.result = "void-chest"
vcp.order = "a[items]-c[void-chest]"
vcp.picture =
{
  filename = "__VoidChestPlus__/graphics/voidchest.png",
  priority = "extra-high",
  width = 38,
  height = 32,
  shift = {0.1, 0}
}
vcp.gui_mode = "none" -- all, none, admins
vcp.erase_contents_when_mined = true
vcp.logistic_mode = nil
vcp.logistic_slots_count = 12

data:extend({
  vcp,
  {
    type = "item",
    name = "void-chest",
    icon = "__VoidChestPlus__/graphics/icon/voidchest.png",
    icon_size = 32,
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

})