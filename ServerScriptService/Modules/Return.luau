--[[

  Simple ModuleScript to make handling and returning code that much easier.

  Includes:
    - `state`: Practically just assert with a predefined message.
    - `serve`: An easy way to give a detailed and helpful return statement, good for debugging too.

  Description:
    - `serve`: First argument is "Code", error/response code. Second is "Output", the response message. Final one is "Attachments",
               things you'd like to attach to the response to be used later on.

  Usage:
  ```lua
  local ServerScriptService = game:GetService("ServerScriptService")
  local Modules: Folder = require(ServerScriptService:WaitForChild("Modules")

  local Return: ModuleScript = require(Modules:WaitForChild("Return"))

  local x: number = 1
  local y: number = 2

  local function sum(x: number, y: number): number
    local final = x + y

    return Return.serve(200, "Numbers have been added together!", {
      sum = final
    })
  end
  ```

]]

local Return = {}

Return.state = function(Case: any, Response: string)
	local failure = "Response failure:"
	
	assert(Case, `{failure} {Response}`)
end

Return.serve = function(Code: number, Output: string, Attachments: SharedTable): SharedTable
	Return.state(type(Code) == "number", `Code should be inserted with type "number"`)
	Return.state(type(Output) == "string", `Output should be declared with type "string"`)

	return {
		code = Code,
		output = Output,
		attachments = Attachments
	}
end

return {
	serve = Return.serve,
	state = Return.state
}
