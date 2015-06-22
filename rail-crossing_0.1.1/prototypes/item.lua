data:extend(
{
  {
    type = "recipe",
    name = "rail-crossing",
    enabled = "false",
    energy_required = 2,
    ingredients =
    {
		{"straight-rail", 2},
		{"stone-brick", 2},
		{"steel-plate", 2}
    },
    result = "rail-crossing"
  },
   {
    type = "item",
    name = "rail-crossing",
    icon = "__rail-crossing__/graphics/icon-crossing.png",
    flags = {"goes-to-quickbar"},
    subgroup = "transport",
    order = "a[train-system]-c[rail-crossing]",
    place_result = "rail-crossing",
    stack_size = 10
  },
})

local tech = data.raw["technology"]["rail-signals"]
table.insert(tech.effects, { type = "unlock-recipe", recipe = "rail-crossing"})