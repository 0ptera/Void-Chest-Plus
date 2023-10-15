--[[ Copyright (c) 2017 Optera
* Part of Void Chest Plus
*
* See LICENSE.md in the project directory for license information.
--]]

local vcp = table.deepcopy(data.raw.container["steel-chest"])
vcp.type = "infinity-container"
vcp.name = "void-chest"
vcp.icon = "__VoidChestPlus__/graphics/icon/voidchest.png"
vcp.icon_size = 64
vcp.icon_mipmaps = 4
vcp.minable.result = "void-chest"
vcp.order = "a[items]-c[void-chest]"
vcp.picture =
{
  layers =
  {
    {
      filename = "__VoidChestPlus__/graphics/voidchest.png",
      priority = "extra-high",
      width = 33,
      height = 37,
      shift = util.by_pixel(0, -2),
      hr_version =
      {
        filename = "__VoidChestPlus__/graphics/hr-voidchest.png",
        priority = "extra-high",
        width = 66,
        height = 74,
        shift = util.by_pixel(0, -2),
        scale = 0.5
      }
    },
    {
      filename = "__VoidChestPlus__/graphics/voidchest-shadow.png",
      priority = "extra-high",
      width = 56,
      height = 24,
      shift = util.by_pixel(12, 5),
      draw_as_shadow = true,
      hr_version =
      {
        filename = "__VoidChestPlus__/graphics/hr-voidchest-shadow.png",
        priority = "extra-high",
        width = 112,
        height = 46,
        shift = util.by_pixel(12, 4.5),
        draw_as_shadow = true,
        scale = 0.5
      }
    }
  }
}
vcp.gui_mode = "none" -- all, none, admins
vcp.erase_contents_when_mined = true
vcp.logistic_mode = nil
vcp.inventory_size = 1

data:extend({
  vcp,
  {
    type = "item",
    name = "void-chest",
    icon = "__VoidChestPlus__/graphics/icon/voidchest.png",
    icon_size = 64,
    icon_mipmaps = 4,
    subgroup = "storage",
    order = "a[items]-c[void-chest]",
    place_result = "void-chest",
    stack_size = 50
  },
  {
    type = "recipe",
    name = "void-chest",
    enabled = false,
    ingredients =
    {
      {"steel-chest", 1},
      {"steel-furnace", 1},
      {"electronic-circuit", 3}
    },
    result = "void-chest"
  },
})

table.insert(data.raw["technology"]["advanced-material-processing"].effects, { type = "unlock-recipe", recipe = "void-chest" } )