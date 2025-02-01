--[[

  Used just to identify which version of Hackless you're using, I basically just made this for debugging.

  This is completely optional lol.

]]

local RunService = game:GetService("RunService")

local isStudio = RunService:IsStudio()

if isStudio then
	print("Roblox Studio is running on Version 1")
else
	print("Roblox Player is running on Version 10")
end
