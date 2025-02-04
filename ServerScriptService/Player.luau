--[[

  Hardly advanced CFrame detection method to flag most necessities like Teleports, WalkSpeed, Flight, etc.
  I know of a few ways to very easily bypass these checks, but for my second Anti-Cheat ever, I'd say that's pretty alright!
  Also, this was sort of made because I got bored and I wanted to go against my friend, don't expect good code at ALL.

  Includes:
    - Finding differences in past and present CFrame by using basic calculations.
    - Kills player upon flagging them, as a warning, lagbacks are dumb.
    - Includes `CharacterAdded` logic to prevent breaking loops.
    - My first attempt at using the modulus operator lol.

  Please don't judge this bad attempt at an Anti Cheat.. It could be so much better, but at the current state,
  I'd say it's pretty fine!

  > NOTE: This doesn't take in account for games that teleport, increase speed, use flight, or more!
          at the moment, this is just a fun thing I have made, with exploits and vulnerabilities!

  More updates could come in the future if I'm ever interested again! Who knows?!

]]

local Players = game:GetService("Players")
local Modules = script.Parent:WaitForChild("Modules")

local Return = require(Modules:WaitForChild("Return"))
local CharacterData = require(Modules:WaitForChild("CharacterData"))

local function calculateAcceleration(player: Player, current: CFrame, previous: CFrame)
	Return.state(current ~= nil, "Player's current position may not be nil")
	Return.state(previous ~= nil, "Player's last position may not be nil")
	
	local oldPositions = {x = previous.X, z = previous.Z}
	local nowPositions = {x = current.X, z = current.Z}
	
	local xSub = math.round((nowPositions.x - oldPositions.x) * 100) / 100
	local zSub = math.round((nowPositions.z - oldPositions.z) * 100) / 100
	
	local cap = 1.5
	
	local speedMessage = `{player.Name} has been flagged for speed exploits`
	
	if xSub > cap or -xSub < -cap then
		return Return.serve(200, speedMessage .. ' on "X" axis!', {
			x = xSub
		})
	end
	
	if zSub > cap or -zSub < -cap then
		return Return.serve(200, speedMessage .. ' on "Z" axis!', {
			z = zSub
		})
	end
	
	return Return.serve(404, `{player.Name} passed the speed test`, {
		x = xSub,
		z = zSub
	})
end

local function assignBasics(player: Player)
	local character = CharacterData.fetchCharacter(player).attachments.character
	local rootPart = CharacterData.fetchRoot(character)
	
	if rootPart.code == 200 then
		local playerRoot = rootPart.attachments.rootPart
		local humanoid = CharacterData.fetchHumanoid(character)
		
		if humanoid.code == 200 then
			return Return.serve(200, "All stuff identified successfully!", {
				character = character,
				rootPart = rootPart,
				playerRoot = playerRoot,
				humanoid = humanoid
			})
		else
			return Return.serve(404, `Failed to fetch Humanoid "Humanoid"`, nil)
		end
	else
		return Return.serve(404, `Failed to fetch BasePart "HumanoidRootPart"`, nil)
	end
end

Players.PlayerAdded:Connect(function(player: Player)
	print(`Player Connected : Name = {player.Name}`)
	
	local basics = assignBasics(player)
	
	if basics.attachments.rootPart.code == 200 then
		local frame = 0
		
		local current = basics.attachments.playerRoot.CFrame
		local previous = current
		
		task.spawn(function()
			local function beginLoop()
				local basics = assignBasics(player)
				
				if basics.attachments.rootPart.code == 200 then
					frame = 0
					
					current = basics.attachments.playerRoot.CFrame
					previous = current
					
					task.spawn(function()
						repeat
							current = basics.attachments.playerRoot.CFrame
							frame += 1

							if frame % 2 == 0 then
								previous = current
							end

							local flagged = calculateAcceleration(player, current, previous)

							if flagged.code == 200 then
								basics.attachments.humanoid.attachments.humanoid:TakeDamage(math.huge)
							end

							task.wait(0.05)
						until basics.attachments.humanoid.attachments.humanoid.Health <= 0
					end)
				end
			end
			
			beginLoop()
			
			player.CharacterAdded:Connect(beginLoop)
		end)
	end
end)
