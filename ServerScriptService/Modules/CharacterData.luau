--[[

  Fairly basic ModuleScript for making fetching Player characteristics on the server WAY easier.

  Includes:
    - `fetchCharacter`: Returns the direct Character (Model) of given Player.
    - `fetchRoot`: Returns said Character's HumanoidRootPart (BasePart).
    - `fetchHumanoid`: Returns the Humanoid (Humanoid) from given Character.

  Description:
    - `fetchCharacter`: Takes in Player (DataModel) and returns a `serve` table (see Return.luau) with attached Model.
    - `fetchRoot`: Takes in argument Character (Model) and attempts to get HumanoidRootPart (BasePart), then returns table with attached object.
    - `fetchHumanoid`: Takes in Character (Model) then attempts to find Humanoid (Humanoid), returns attached if found.

]]

local Return = require(script.Parent:WaitForChild("Return"))

local CharacterData = {}

CharacterData.fetchCharacter = function(player: Player): SharedTable
	local character = player.Character or player.CharacterAdded:Wait()

	if character then
		return Return.serve(200, `Fetched Model "Character" successfully!`, {
			character = character
		})
	end

	return Return.serve(404, `Failed to fetch Model "Character"`, nil)
end

CharacterData.fetchRoot = function(character: Model): SharedTable
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	if rootPart then
		return Return.serve(200, `Fetched BasePart "HumanoidRootPart" successfully!`, {
			rootPart = rootPart
		})
	end

	return Return.serve(404, `Failed to fetch BasePart "HumanoidRootPart"`, nil)
end

CharacterData.fetchHumanoid = function(character: Model): SharedTable
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		return Return.serve(200, `Fetched Humanoid "Humanoid" successfully!`, {
			humanoid = humanoid
		})
	end

	return Return.serve(404, `Failed to fetch Humanoid "Humanoid"`, nil)
end

return CharacterData
