local crossingFloorFile = "__rail-crossing__/graphics/crossing.png"
local crossingFloorInternal = function(elems)
  local keys = {{"straight_rail", "horizontal", 64, 64},
                {"straight_rail", "vertical", 64, 64},
                {"straight_rail", "diagonal", 64, 64},
                {"curved_rail", "vertical", 0, 0},
                {"curved_rail" ,"horizontal", 0, 0}}
  local res = {}
  for _ , key in ipairs(keys) do
    part = {}
    dashkey = key[1]:gsub("_", "-")
    for _ , elem in ipairs(elems) do
      part[elem[1]] = {
        filename = crossingFloorFile,
        priority = "extra-high",
        width = key[3],
        height = key[4]
      }
    end
    res[key[1] .. "_" .. key[2]] = part
  end
  res["rail_endings"] = {
    sheet =
    {
      filename = "__base__/graphics/entity/rail-endings/rail-endings.png",
      priority = "high",
      width = 0,
      height = 0
    }
  }
  return res
end

crossingRailsInternal = function(elems)
  local keys = {{"straight_rail", "horizontal", 64, 64},
                {"straight_rail", "vertical", 64, 64},
                {"straight_rail", "diagonal", 0, 0},
                {"curved_rail", "vertical", 0, 0},
                {"curved_rail" ,"horizontal", 0, 0}}
  local res = {}
  for _ , key in ipairs(keys) do
    part = {}
    dashkey = key[1]:gsub("_", "-")
    for _ , elem in ipairs(elems) do
      part[elem[1]] = {
        filename = string.format("__base__/graphics/entity/%s/%s-%s-%s.png", dashkey, dashkey, key[2], elem[2]),
        priority = "extra-high",
        width = key[3],
        height = key[4]
      }
    end
    res[key[1] .. "_" .. key[2]] = part
  end
  res["rail_endings"] = {
    sheet =
    {
      filename = "__base__/graphics/entity/rail-endings/rail-endings.png",
      priority = "high",
      width = 88,
      height = 82
    }
  }
  return res
end


local crossingFloor = function()
  return crossingFloorInternal({{"metals", "metals"}, {"backplates", "backplates"}, {"ties", "ties"}, {"stone_path", "stone-path"}})
end

local crossingRails = function()
  return crossingRailsInternal({{"metals", "metals"}, {"backplates", "backplates"}, {"ties", "ties"}, {"stone_path", "stone-path"}})
end

for _,obj in pairs(data.raw["locomotive"]) do
	obj.collision_mask = { }
end

for _,obj in pairs(data.raw["cargo-wagon"]) do
	obj.collision_mask = { }
end


data:extend(
{
  {
    type = "rail",
    name = "rail-crossing",
    icon = "__rail-crossing__/graphics/icon-crossing.png",
    flags = {"placeable-neutral", "player-creation", "building-direction-8-way"},
    minable = {mining_time = 1, result = "rail-crossing"},
    max_health = 100,
    corpse = "medium-remnants",
    collision_box = {{-0.7, -0.8}, {0.7, 0.8}},
    selection_box = {{-0.7, -0.8}, {0.7, 0.8}},
    bending_type = "straight",
    rail_category = "regular",
    pictures = crossingFloor()
  },
  {
    type = "simple-entity",
    name = "rail-crossing-placed",
    flags = { "placeable-off-grid", "player-creation"}, 
	minable = {mining_time = 1, result = "rail-crossing"}, 
    icon = "__rail-crossing__/graphics/icon-crossing.png",
    --subgroup = "grass",
    --order = "b[decorative]-k[stone-rock]-a[big]",
	collision_box = {{-0.7, -0.7}, {0.7, 0.7}},
	selection_box = {{-0.9, -0.9}, {0.9, 0.9}},
    corpse = "medium-remnants",
    render_layer = "remnants",
    max_health = 100,
    pictures = {{filename = crossingFloorFile, width = 64, height = 64}}
  },
  {
    type = "rail",
    name = "internal-rail",
    flags = { },
    max_health = 100,
    corpse = "straight-rail-remnants",
    bending_type = "straight",
    rail_category = "regular",
    pictures = crossingRails()
  },
})

