require "defines"

function removeRailsAt(pos)
	local t = game.findentitiesfiltered{area = {{pos.x - 0.1, pos.y - 0.1}, {pos.x + 0.1, pos.y + 0.1}}, name = "internal-rail"}
	for _,v in pairs(t) do
		v.destroy()
	end
end

function numOccupyingRail(area, entityType)
	local t = game.findentitiesfiltered{area = area, type = entityType}
	return #t
end

crossingRemoved = function (entity, playerindex)
	local pos = entity.position
	local area = {{pos.x - 0.9, pos.y - 0.9}, {pos.x + 0.9, pos.y + 0.9}}
	local numOccupying = numOccupyingRail(area, "locomotive") + numOccupyingRail(area, "cargo-wagon")
	if numOccupying > 0 then
		if playerindex ~= nil then
			game.players[playerindex].print("Unable to remove rail crossing (occupied by train)")
			game.players[playerindex].removeitem{ name = "rail-crossing", count = 1 }
		end
		game.createentity{name = "rail-crossing-placed", position = pos, force = entity.force}
	else
		removeRailsAt(entity.position)
	end
end

crossingBuilt = function (entity, playerindex)
	local pos = entity.position
	local dir = entity.direction
	local fce = entity.force
	entity.destroy()
	
	if game.canplaceentity{name = "rail-crossing-placed", position = pos} then
	
		game.createentity{name = "internal-rail", position = pos, direction = 0}
		game.createentity{name = "internal-rail", position = pos, direction = 2}
		game.createentity{name = "rail-crossing-placed", position = pos, force = fce}
		
	else
		game.players[playerindex].print("Unable to place rail crossing (obstructed)")
		game.players[playerindex].insert{ name = "rail-crossing", count = 1 }
	end
end



function isValid(entity)
	return entity ~= nil and entity.valid
end

entityRemoved = function (event) 
	if isValid(event.entity) then
		if event.entity.name == "rail-crossing-placed" then
			crossingRemoved(event.entity, event.playerindex) 
		end
	end
end

entityRemovedPlayerless = function (event) 
	if isValid(event.entity) then
		if event.entity.name == "rail-crossing-placed" then
			crossingRemoved(event.entity, nil) 
		end
	end
end


trainBuilt = function (entity, playerindex)
	local pos = entity.position
	local area = {{pos.x - 2.5, pos.y - 2.5}, {pos.x + 2.5, pos.y + 2.5}}
	local numOccupying = numOccupyingRail(area, "locomotive") + numOccupyingRail(area, "cargo-wagon")
	if numOccupying > 1 then
		game.players[playerindex].insert{ name = entity.name, count = 1 }
		entity.destroy()
	end
end



entityBuilt = function (event) 
	if isValid(event.createdentity) then 
		if event.createdentity.name == "rail-crossing" then
			crossingBuilt(event.createdentity, event.playerindex) 
		elseif event.createdentity.type == "locomotive" or event.createdentity.type == "cargo-wagon" then
			trainBuilt(event.createdentity, event.playerindex) 
		end
	end 
end



game.onevent(defines.events.onpreplayermineditem, entityRemoved)
game.onevent(defines.events.onrobotpremined, entityRemovedPlayerless)
game.onevent(defines.events.onentitydied, entityRemovedPlayerless)

game.onevent(defines.events.onbuiltentity, entityBuilt)
game.onevent(defines.events.onrobotbuiltentity, entityBuilt)
