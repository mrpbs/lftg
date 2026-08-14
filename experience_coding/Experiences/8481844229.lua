if not game:IsLoaded() then game.Loaded:Wait() end
local Raw_Version = "1.4.7"
local Script_Version = tostring(Raw_Version).."-BerryAveAdmin"
local NotifyLib = loadstring(game:HttpGet("https://pastebin.com/raw/tg4tu73Y"))()
local valid_titles = {success="Success",info="Info",warning="Warning",error="Error",succes="Success",sucess="Success",eror="Error",erorr="Error",warnin="Warning"}
local function format_title(str)
	if typeof(str) ~= "string" then return "Info" end
	local key = str:lower()
	return valid_titles[key] or "Info"
end

getgenv().FlamesLibrary = getgenv().FlamesLibrary or {}
getgenv().FlamesLibrary._connections = getgenv().FlamesLibrary._connections or {}
getgenv().FlamesLibrary.connect = function(name, connection)
	getgenv().FlamesLibrary._connections[name] = getgenv().FlamesLibrary._connections[name] or {}
	table.insert(getgenv().FlamesLibrary._connections[name], connection)
	return connection
end

getgenv().FlamesLibrary.disconnect = function(name)
	local list = getgenv().FlamesLibrary._connections[name]

	if list then
		for _, item in ipairs(list) do
			if typeof(item) == "RBXScriptConnection" then
				item:Disconnect()
			elseif type(item) == "thread" then
				pcall(task.cancel, item)
			end
		end
		getgenv().FlamesLibrary._connections[name] = nil
	end
end

getgenv().FlamesLibrary.spawn = function(name, mode, func, ...)
	if not name or not mode or type(func) ~= "function" then return end
	if getgenv().FlamesLibrary._connections[name] then getgenv().FlamesLibrary.disconnect(name) end
	getgenv().FlamesLibrary._connections[name] = {}
	local thread

	if mode == "spawn" then
		thread = task.spawn(func, ...)
	elseif mode == "defer" then
		thread = task.defer(func, ...)
	elseif mode == "delay" then
		local delay_time = ...
		thread = task.delay(delay_time, func)
	elseif mode == "wrap" then
		thread = coroutine.create(func)
		coroutine.resume(thread, ...)
	else
		return
	end

	table.insert(getgenv().FlamesLibrary._connections[name], thread)
	return thread
end

getgenv().FlamesLibrary.is_thread_alive = function(input)
   local lib = getgenv().FlamesLibrary

   if type(input) == "thread" then
      local ok, status = pcall(coroutine.status, input)
      if not ok then
         return false
      end
      return status ~= "dead"
   end

   if type(input) == "string" then
      local list = lib._connections[input]
      if not list then
         return false
      end

      for _, item in ipairs(list) do
         if type(item) == "thread" then
            local ok, status = pcall(coroutine.status, item)
            if ok and status ~= "dead" then
               return true
            end
         end
      end

      return false
   end

   return false
end

getgenv().FlamesLibrary.is_alive = function(name)
   local lib = getgenv().FlamesLibrary
   local list = lib._connections[name]

   if not list then
      return false
   end

   for _, item in ipairs(list) do
      if typeof(item) == "RBXScriptConnection" then
         if item.Connected then
            return true
         end
      elseif type(item) == "thread" then
         if lib.is_thread_alive(item) then
            return true
         end
      end
   end

   return false
end

getgenv().FlamesLibrary.cleanup_all = function()
	for name in pairs(getgenv().FlamesLibrary._connections) do
		getgenv().FlamesLibrary.disconnect(name)
	end

   if getgenv().notify then
      getgenv().notify("Success", "Cleaned up all concurrent threads/connections.", 7)
   end
end

if not getgenv().GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://pastebin.com/raw/T25mDhBZ"))()
   wait(0.1)
   getgenv().GlobalEnvironmentFramework_Initialized = true
end

getgenv().notify = getgenv().notify or function(title, msg, dur)
   local fixed_title = format_title(title)
   NotifyLib:External_Notification(fixed_title, tostring(msg), tonumber(dur))
end

local function retrieve_executor()
   local name
   if identifyexecutor then
      name = identifyexecutor()
   end
   return { Name = name or "Unknown Executor" }
end

local function identify_executor()
   local executorDetails = retrieve_executor()
   return tostring(executorDetails.Name)
end

local executor_string = identify_executor()
local function executor_contains(substr)
   if type(executor_string) ~= "string" then
      return false
   end

   return string.find(string.lower(executor_string), string.lower(substr), 1, true) ~= nil
end

local config_path = "Flames_BerryAve_Admin_Config.json"
getgenv().Script_Version_GlobalGenv = Script_Version
local Script_Creator = "computerbinaries"
local Announcement_Message = "Welcome to our NEWEST admin script! Berry Avenue Admin, enjoy!!!"
local displayTimeMax = 15
local cmdsString = [[
   {prefix}rgbcar - Enables RGB/Rainbow Vehicle (FE).
   {prefix}unrgbcar - Disables RGB/RainbowVehicle.
   {prefix}hlspam - Flashes your Headlights (FE).
   {prefix}unhlspam - Disables headlight flasher.
   {prefix}fly Speed - Enables Fly (FE).
   {prefix}unfly - Disables Fly.
   {prefix}nosit - Enables 'anti-sit' (FE).
   {prefix}unnosit - Disables 'anti-sit' (FE).
   {prefix}spawn CarName - Spawns the requested Vehicle (FE).
   {prefix}spawnhouse HouseName - Allows you to spawn a house (FE).
   {prefix}delhouse - Deletes/removes your house (FE).
   {prefix}tphouse Player - Teleports you to the target players house (FE).
   {prefix}jobspam - Enables Job Spammer (FE).
   {prefix}unjobspam - Disables Job Spammer (FE).
   {prefix}gotohouse - Teleports you to your house (if you have one, FE).
   {prefix}lockcar - Locks your Vehicle (FE).
   {prefix}unlockcar - Unlocks your Vehicle (FE).
   {prefix}despawn - Despawns your currently spawned Vehicle (FE).
   {prefix}modcar - Mods your Vehicle making it faster (FE).
   {prefix}cmds - Lists/shows all the available commands.
]]
wait(0.1)
getgenv().cmdsString = cmdsString

local function decodeHTMLEntities(str)
   return str:gsub("&gt;", ">")
            :gsub("&lt;", "<")
            :gsub("&amp;", "&")
            :gsub("&quot;", '"')
            :gsub("&#39;", "'")
end
wait(0.1)
getgenv().decodeHTMLEntities = decodeHTMLEntities

if not executor_contains("LX63") then
   local set_fps = setfpscap or setfps
   if setfpscap or setfps then set_fps(999) end
end

if executor_contains("JJSploit") then
   getgenv().notify("Error", "You cannot run this script, sorry!", 30)
   return getgenv().notify("Error", "Try executors like Potassium, Volcano, Seliware, Delta, Codex, Cryptic, ChocoSploit, Volt, Bunni.lol, etc.", 35)
end
if executor_contains("Xeno") then
   getgenv().notify("Error", "You cannot run this script, sorry! (support soon, maybe...)", 30)
   return getgenv().notify("Error", "Try executors like Potassium, Volcano, Seliware, Delta, Codex, Cryptic, ChocoSploit, Volt, Bunni.lol, etc.", 35)
end
if executor_contains("Solara") then
   getgenv().notify("Error", "You cannot run this script, sorry!", 30)
   return getgenv().notify("Error", "Try executors like Potassium, Volcano, Seliware, Delta, Codex, Cryptic, ChocoSploit, Volt, Bunni.lol, etc..", 35)
end

if getgenv().Game.PlaceId ~= 8481844229 then
   return getgenv().notify("Error", "This is not Berry Avenue RP! You cannot run this here!", 6)
end
if getgenv().BerryAvenue_Admin_Has_Loaded then
   return getgenv().notify("Warning", "You already have Berry Avenue Admin loaded, you cannot load it again.", 8)
end
task.wait(0.1)
getgenv().Script_Loaded_Correctly_BerryAve_Admin_Flames_Hub = getgenv().Script_Loaded_Correctly_BerryAve_Admin_Flames_Hub or false

if getgenv().BerryAvenue_Admin_Has_Loaded and getgenv().Script_Loaded_Correctly_BerryAve_Admin_Flames_Hub == false then
   getgenv().BerryAvenue_Admin_Has_Loaded = false
   return getgenv().notify("Error", "Berry Avenue RP Admin appears to not have loaded correctly, try re-running the script and trying again.", 8)
elseif getgenv().BerryAvenue_Admin_Has_Loaded and getgenv().Script_Loaded_Correctly_BerryAve_Admin_Flames_Hub then
   return getgenv().notify("Warning", "Berry Avenue RP Admin is already running!", 5)
end

local UIS = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local TS = cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
local run_service = getgenv().RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")

getgenv().flowrgb = getgenv().flowrgb or function(conn_name, speed, obj, toggle)
   if toggle == false then
      if getgenv()[conn_name] then
         pcall(function()
            getgenv()[conn_name]:Disconnect()
         end)
         getgenv()[conn_name] = nil
      end
      return
   end

   if not obj or typeof(obj) ~= "Instance" then
      return
   end

   if getgenv()[conn_name] then
      pcall(function()
         getgenv()[conn_name]:Disconnect()
      end)
      getgenv()[conn_name] = nil
   end

   speed = tonumber(speed) or 1
   local hue = 0

   getgenv()[conn_name] = run_service.RenderStepped:Connect(function(dt)
      if not obj or not obj.Parent then
         if getgenv()[conn_name] then
            getgenv()[conn_name]:Disconnect()
            getgenv()[conn_name] = nil
         end
         return
      end

      hue = (hue + (dt * speed)) % 1

      local color = Color3.fromHSV(hue, 1, 1)

      TS:Create(
         obj,
         TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
         { BackgroundColor3 = color }
      ):Play()
   end)
end

getgenv().dragify = getgenv().dragify or function(Frame)
   local dragging = false
   local dragStart = nil
   local startPos = nil
   local dragInput = nil
   local function update(input)
      local delta = input.Position - dragStart
      local pos = UDim2.new(
         startPos.X.Scale,
         startPos.X.Offset + delta.X,
         startPos.Y.Scale,
         startPos.Y.Offset + delta.Y
      )

      TS:Create(Frame, TweenInfo.new(0.15), {Position = pos}):Play()
   end

   Frame.InputBegan:Connect(function(input)
      if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
         and UIS:GetFocusedTextBox() == nil then

         dragging = true
         dragStart = input.Position
         startPos = Frame.Position

         input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
               dragging = false
            end
         end)
      end
   end)

   Frame.InputChanged:Connect(function(input)
      if input.UserInputType == Enum.UserInputType.MouseMovement
         or input.UserInputType == Enum.UserInputType.Touch then

         dragInput = input
      end
   end)

   UIS.InputChanged:Connect(function(input)
      if input == dragInput and dragging then
         update(input)
      end
   end)
end

getgenv().isProperty = getgenv().isProperty or function(inst, prop)
	local s, r = pcall(function() return inst[prop] end)
	if not s then return nil end
	return r
end

local HttpService = cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
local fileName = "BerryAvenue_Admin_Configuration.json"
-- [[ Now we have an allowed Prefix system, so we can correctly modify your Prefix if it's broken. ]] --
local Allowed_Prefixes = {
   "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "=", "_", "+", ",",
   ".", "/", ">", "<", "?", "~", "`", "}", "{", "[", "]", ":", "1", "2", "3", "4", "5", "·", "•", "∙", "⋅", "£"
}
getgenv().isAllowedPrefix = getgenv().isAllowedPrefix or function(prefix)
   for _, p in ipairs(Allowed_Prefixes) do
      if prefix == p then
         return true
      end
   end
   return false
end

getgenv().loadPrefix = getgenv().loadPrefix or function()
   local defaultPrefix = "."
   local data = { prefix = defaultPrefix }

   if isfile and isfile(fileName) then
      local success, decoded = pcall(function()
         return HttpService:JSONDecode(readfile(fileName))
      end)

      if success and type(decoded) == "table" and decoded.prefix then
         local prefix = tostring(decoded.prefix)
         if prefix == "symbol" or not isAllowedPrefix(prefix) then
            getgenv().notify("Info", "We've automatically modified your Prefix, it was broken or not an allowed Prefix.", 7)
            decoded.prefix = defaultPrefix
            writefile(fileName, HttpService:JSONEncode(decoded))
            return defaultPrefix
         else
            return prefix
         end
      end
   end

   writefile(fileName, HttpService:JSONEncode(data))
   return defaultPrefix
end

getgenv().savePrefix = getgenv().savePrefix or function(newPrefix)
   if writefile then
      local data = { prefix = newPrefix }
      writefile(fileName, HttpService:JSONEncode(data))
   end
end

getgenv().hasProp = getgenv().hasProp or function(inst, prop)
   return inst and isProperty(inst, prop) ~= nil
end

getgenv().setProperty = getgenv().setProperty or function(inst, prop, v)
	local s, _ = pcall(function() inst[prop] = v end)
	return s
end

getgenv().safeSet = getgenv().safeSet or function(inst, prop, val)
   if inst and hasProp(inst, prop) then setProperty(inst, prop, val) end
end

getgenv().anti_sit_enabled = getgenv().anti_sit_enabled or false
local local_player = getgenv().LocalPlayer or Players.LocalPlayer
local tag_name = "anti_sit_system"
local function hook_character(character)
   if not character or not character:FindFirstChild("HumanoidRootPart") then character:WaitForChild("HumanoidRootPart") end
   local humanoid = getgenv().Humanoid or character:WaitForChild("Humanoid")
   local seated_connection
   seated_connection = humanoid.Seated:Connect(function(active)
      if not getgenv().anti_sit_enabled then
         return 
      end

      if active then
         task.wait()
         humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
         humanoid.Sit = false
      end
   end)

   getgenv().FlamesLibrary.connect(tag_name, seated_connection)
end

local function start_anti_sit()
   if getgenv().FlamesLibrary.is_alive(tag_name) then
      return getgenv().notify("Warning", "Anti-Sit is already running!", 6)
   end

   if local_player.Character then
      hook_character(local_player.Character)
   end

   local char_connection = local_player.CharacterAdded:Connect(function(character)
      hook_character(character)
   end)

   getgenv().notify("Success", "Flames Anti-Sit is now enabled.", 5)
   getgenv().FlamesLibrary.connect(tag_name, char_connection)
end

local function stop_anti_sit()
   if not getgenv().FlamesLibrary.is_alive(tag_name) then
      return getgenv().notify("Warning", "Anti-Sit is not enabled.", 5)
   end

   getgenv().FlamesLibrary.disconnect(tag_name)
   getgenv().notify("Success", "Flames Anti-Sit is now disabled.", 5)
end

getgenv().toggle_anti_sit = function(state)
   getgenv().anti_sit_enabled = state

   if state then
      start_anti_sit()
   else
      stop_anti_sit()
   end
end
wait(0.1)
getgenv().get_knit_and_services_parents = getgenv().get_knit_and_services_parents or function()
   if getgenv().main_services_folder and getgenv().main_services_folder:IsA("Folder") then
      return getgenv().main_services_folder
   end
   
   for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
      if v:IsA("Folder") and v.Name:lower():find("services") and v.Parent.ClassName == "ModuleScript" and v.Parent.Name:lower():find("knit") then
         getgenv().main_services_folder = v
         return v
      end
   end
end

local find_services_folder_remotes = getgenv().get_knit_and_services_parents()
wait(1)
if not find_services_folder_remotes then
   if getgenv().notify then
      return getgenv().notify("Error", "Services Folder could not be located at runtime, this script cannot run.", 15)
   else
      return warn("Services Folder could not be located at runtime, this script cannot run.")
   end
end

getgenv().ServicesFolder = getgenv().ServicesFolder or find_services_folder_remotes
wait(0.5)
local function safeInvoke(remote)
   local ok, result = pcall(function()
      return remote:InvokeServer()
   end)
   if ok and type(result) == "table" then
      return result
   else
      getgenv().notify("Error", "Failed to invoke PlayerService.GetData: "..tostring(result), 10)
      return {}
   end
end

-- define all services and their subfolders before-hand --
if not getgenv()._KnitServices_Initialized then
   local total = 0

   for _, service in ipairs(ServicesFolder:GetChildren()) do
      if service:IsA("Folder") then
         local baseName = service.Name
         getgenv()[baseName] = service

         local RF = service:FindFirstChild("RF")
         local RE = service:FindFirstChild("RE")

         if RF and RF:IsA("Folder") then
            getgenv()[baseName .. "_RF"] = RF
            total += #RF:GetChildren()
         end

         if RE and RE:IsA("Folder") then
            getgenv()[baseName .. "_RE"] = RE
            total += #RE:GetChildren()
         end
      end
   end

   getgenv().notify("Success", "Knit services initialized (" .. total .. " remotes)", 5)
   getgenv()._KnitServices_Initialized = true
end

getgenv().flowrgb = getgenv().flowrgb or function(connname,speed,obj,toggle)
   local ts = getgenv().TweenService or game:GetService("TweenService")
   local rs = getgenv().RunService or game:GetService("RunService")
   if toggle==false then
      if getgenv()[connname] then
         pcall(function() getgenv()[connname]:Disconnect() end)
         getgenv()[connname]=nil
      end
   else
      if getgenv()[connname] then
         pcall(function() getgenv()[connname]:Disconnect() end)
         getgenv()[connname]=nil
      end
      local hue=0
      getgenv()[connname]=rs.RenderStepped:Connect(function(dt)
         hue=(hue+(dt*speed))%1
         local col=Color3.fromHSV(hue,1,1)
         ts:Create(obj,TweenInfo.new(0.15,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut),{BackgroundColor3=col}):Play()
      end)
   end
end

-- service finder function --
getgenv().find_service = function(service_name, subfolder) -- keep it dynamic.
   local s = ServicesFolder:FindFirstChild(tostring(service_name) .. "Service", true)
   if not s then
      if getgenv().notify then
         getgenv().notify("Error", "Service not found: " .. tostring(service_name), 5)
      end
      return nil
   end
   if subfolder and (subfolder == "RF" or subfolder == "RE") then
      return s:FindFirstChild(subfolder, true)
   end
   return s
end

getgenv().Network_Sender = function(remoteName, ...) -- keep it dynamic.
   local args = {...}
   local remoteInstance = nil

   if typeof(remoteName) ~= "string" then
      return 
   end

   for _, service in ipairs(getgenv().ServicesFolder:GetChildren()) do
      if service:IsA("Folder") then
         local rf = service:FindFirstChild("RF", true)
         local re = service:FindFirstChild("RE", true)

         if rf then
            local found = rf:FindFirstChild(remoteName, true)
            if found then
               remoteInstance = found
               break
            end
         end

         if re and not remoteInstance then
            local found = re:FindFirstChild(remoteName, true)
            if found then
               remoteInstance = found
               break
            end
         end
      end
   end

   if not remoteInstance then
      getgenv().notify("Error", "⚠️ Remote not found in any Knit service ⚠️: "..tostring(remoteName), 65)
      return nil
   end

   if remoteInstance:IsA("RemoteEvent") then
      local ok, err = pcall(function()
         remoteInstance:FireServer(unpack(args))
      end)
      if not ok then
         getgenv().notify("Error", "⚠️ Failed to FireServer ⚠️: "..tostring(err), 5)
      end
   elseif remoteInstance:IsA("RemoteFunction") then
      local ok, result = pcall(function()
         return remoteInstance:InvokeServer(unpack(args))
      end)
      if not ok then
         getgenv().notify("Error", "⚠️ Failed to InvokeServer ⚠️: "..tostring(result), 5)
         return nil
      end

      return result
   else
      getgenv().notify("Error", "⚠️ Found instance is not a RemoteEvent or RemoteFunction ⚠️: "..tostring(remoteInstance), 6)
   end
end
wait(1)
local Plots = {
   "Plot1",
   "Plot2",
   "Plot3",
   "Plot4",
   "Plot5",
   "Plot6",
   "Plot7",
   "Plot8",
   "Plot9",
   "Plot10",
   "Plot11",
   "Plot12",
   "Plot13",
   "Plot14",
   "Plot15",
   "Plot16",
   "Plot17",
   "Plot18",
   "Plot19",
   "Plot20",
   "Plot21",
   "Plot22",
}
wait(0.2)
getgenv().AllPlotNames = getgenv().AllPlotNames or Plots -- local tables and global tables are not the same of course.

if not getgenv().AllVehicleNames then -- notifies if the process of getting all the vehicle names was successful, so keep this here.
   getgenv().AllVehicleNames = {
      "Chevy3100",
      "PumpkinCarriage",
      "ATV",
      "Ambulance",
      "BasketBike",
      "Bug",
      "Bugatti",
      "Bus",
      "C1Barbie",
      "C4Barbie",
      "Caddy",
      "CadillacV16",
      "ChargerBaby",
      "Convertible",
      "ExplorerPolice",
      "Fiat",
      "Firetruck",
      "GWagon",
      "GolfCart",
      "Helicopter",
      "IceCreamVan",
      "Impala",
      "Jeep",
      "KiddyBike",
      "KidsBike",
      "Lambo",
      "Lawnmower",
      "Limo",
      "LittleTikes",
      "MailVan",
      "Merc",
      "Merc107",
      "Model3Baby",
      "Moped",
      "Motorhome",
      "Odyssey",
      "Phantom",
      "Polaris",
      "PoliceBike",
      "PoliceCharger",
      "Porsche",
      "RamRTX",
      "RangeRover",
      "SamuraiBaby",
      "SportBike",
      "Spy",
      "Taxi",
      "Taycan",
      "Tesla",
      "Testa",
      "VWBus",
      "Volkswaggy",
      "Z8"
   }

   getgenv().notify("Success", "Initialized all: "..tostring(#getgenv().AllVehicleNames).." vehicles.", 5)
end

getgenv().AllVehicleColors = getgenv().AllVehicleColors or { -- doesn't have to be used for just vehicles.
   Color3.new(0, 0, 0),
   Color3.new(1, 1, 1),
   Color3.new(0.5, 0.5, 0.5),
   Color3.new(0.2, 0.2, 0.2),
   Color3.new(0.8, 0.8, 0.8),
   Color3.new(1, 0, 0),
   Color3.new(0.5, 0, 0),
   Color3.new(1, 0.4, 0.7),
   Color3.new(1, 0.5, 0),
   Color3.new(0.8, 0.3, 0),
   Color3.new(1, 1, 0),
   Color3.new(1, 0.84, 0),
   Color3.new(0, 1, 0),
   Color3.new(0, 0.5, 0),
   Color3.new(0.7, 1, 0),
   Color3.new(0.5, 0.5, 0),
   Color3.new(0, 0, 1),
   Color3.new(0, 0, 0.5),
   Color3.new(0.4, 0.7, 1),
   Color3.new(0, 1, 1),
   Color3.new(0, 0.5, 0.5),
   Color3.new(0.5, 0, 0.5),
   Color3.new(0.6, 0.2, 1),
   Color3.new(1, 0, 1),
   Color3.new(0.4, 0.2, 0),
   Color3.new(0.82, 0.71, 0.55),
   Color3.new(0.96, 0.96, 0.86),
   Color3.new(0, 0, 0.3),
   Color3.new(0.53, 0.81, 0.92),
   Color3.new(0.98, 0.5, 0.45),
   Color3.new(0.29, 0, 0.51),
   Color3.new(0.6, 1, 0.6)
}
wait(0.2)
function rainbow_vehicle(state)
   if state == true then
      if getgenv().RainbowVehicleToggled then
         return getgenv().notify("Warning", "Rainbow Vehicle is already enabled.", 5)
      end
      wait()
      getgenv().RainbowVehicleToggled = true

      getgenv().Rainbow_Vehicle_Loop_Toggle_Task = getgenv().Rainbow_Vehicle_Loop_Toggle_Task or task.spawn(function()
         while getgenv().RainbowVehicleToggled == true do
         task.wait()
            for _, color in pairs(getgenv().AllVehicleColors) do
               getgenv().Network_Sender("VehicleRequestPromise", "SetColor", color)
               task.wait(0)
            end
         end
      end)
   elseif state == false then
      if not getgenv().RainbowVehicleToggled then
         return getgenv().notify("Warning", "Rainbow Vehicle is not enabled.", 5)
      end

      if getgenv().Rainbow_Vehicle_Loop_Toggle_Task then
         task.cancel(getgenv().Rainbow_Vehicle_Loop_Toggle_Task)
         getgenv().Rainbow_Vehicle_Loop_Toggle_Task = nil
      end
      task.wait()
      getgenv().RainbowVehicleToggled = false
   else
      return 
   end
end

local Admins = {
   [getgenv().LocalPlayer.Name] = true
}
wait()
getgenv().AdminPrefix = loadPrefix() or ";"

if getgenv().IY_LOADED and getgenv().AdminPrefix == ";" then
   getgenv().notify("Warning", "Hey! You have Infinite Yield loaded and your prefix is ; | change it! or it'll make you execute IY's commands!", 13)
elseif getgenv().GET_LOADED_IY and getgenv().AdminPrefix == ";" then
   getgenv().notify("Warning", "Hey! You have Infinite Premium loaded and your prefix is ; | change it! or it'll make you execute IY's commands!", 13)
end

getgenv().seatLockEnabled = getgenv().seatLockEnabled or false
getgenv().seatLockCons = getgenv().seatLockCons or {}
getgenv().seatLockPrompts = getgenv().seatLockPrompts or {}
local ProximityPromptService = cloneref and cloneref(game:GetService("ProximityPromptService")) or game:GetService("ProximityPromptService")
local function isSeatPrompt(prompt)
   local obj = prompt.Parent
   while obj do
      if obj:IsA("Seat") or obj:IsA("VehicleSeat") then
         return true
      end
      obj = obj.Parent
   end
   return false
end

local function disablePrompt(prompt)
   if getgenv().seatLockPrompts[prompt] then
      return
   end
   getgenv().seatLockPrompts[prompt] = {
      Enabled = prompt.Enabled,
      ClickablePrompt = prompt.ClickablePrompt,
      MaxActivationDistance = prompt.MaxActivationDistance
   }
   prompt.Enabled = false
   prompt.ClickablePrompt = false
   prompt.MaxActivationDistance = 0
end

local function restoreAllPrompts()
   for prompt, state in pairs(getgenv().seatLockPrompts) do
      if prompt and prompt.Parent then
         prompt.Enabled = state.Enabled
         prompt.ClickablePrompt = state.ClickablePrompt
         prompt.MaxActivationDistance = state.MaxActivationDistance
      end
   end
   table.clear(getgenv().seatLockPrompts)
end

getgenv().toggle_vehicle_seats = function()
   getgenv().seatLockEnabled = not getgenv().seatLockEnabled

   if getgenv().seatLockEnabled then
      local c1 = ProximityPromptService.PromptShown:Connect(function(prompt)
         if isSeatPrompt(prompt) then
            disablePrompt(prompt)
         end
      end)
      getgenv().seatLockCons[#getgenv().seatLockCons + 1] = c1
   else
      for _, c in ipairs(getgenv().seatLockCons) do
         pcall(function()
            c:Disconnect()
         end)
      end
      table.clear(getgenv().seatLockCons)
      restoreAllPrompts()
   end
end

getgenv().get_main_gui = getgenv().get_main_gui or function()
   for _, v in ipairs(getgenv().PlayerGui:GetChildren()) do
      if v:IsA("ScreenGui") and v.Name == "Gui" then
         return v
      end
   end

   return nil
end
wait(0.3)
getgenv().get_gui_frame = getgenv().get_gui_frame or function(name)
   local allocate_gui = get_main_gui()
   if not allocate_gui then return getgenv().notify("Error", "Gui doesn't exist inside PlayerGui!", 5) end
   local frame_name = tostring(name)
   
   for _, v in ipairs(allocate_gui:GetChildren()) do
      if v:IsA("Frame") and v.Name == frame_name then
         return v
      end
   end
   
   return nil
end
wait(0.2)
local House_Frame = get_gui_frame("House")
local HouseSelectionMenu = House_Frame:FindFirstChild("SelectMenu", true) or House_Frame:WaitForChild("SelectMenu", 5)
local HouseListMenu = HouseSelectionMenu:FindFirstChild("List", true) or HouseSelectionMenu:WaitForChild("List", 5)
local PackagesFolder = getgenv().ReplicatedStorage:FindFirstChild("Packages", true) or getgenv().ReplicatedStorage:WaitForChild("Packages", 5)
local Knit_Module = PackagesFolder:FindFirstChild("Knit", true) or PackagesFolder:WaitForChild("Knit", 5)
local KnitModule = require and require(Knit_Module)
local PlayerScripts = getgenv().LocalPlayer:FindFirstChildOfClass("PlayerScripts") or getgenv().LocalPlayer:FindFirstChildWhichIsA("PlayerScripts") or getgenv().LocalPlayer:WaitForChild("PlayerScripts", 5)
local ControllersFolder = PlayerScripts:FindFirstChild("Controllers", true) or PlayerScripts:WaitForChild("Controllers", 5)
local VehicleController = require and require(ControllersFolder:FindFirstChild("VehicleController"))
getgenv().small_notify_initialized = getgenv().small_notify_initialized or true
getgenv().small_gui_state = getgenv().small_gui_state or {}
getgenv().small_gui_refs = getgenv().small_gui_refs or {}
local UIS = getgenv().UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local is_touch = UIS.TouchEnabled and not UIS.MouseEnabled

getgenv().resolveSmallRoot = getgenv().resolveSmallRoot or function()
   local refs = getgenv().small_gui_refs
   if refs.root and refs.root.Parent then
      return refs.root
   end
   local small

   for _, v in ipairs(PlayerGui:GetDescendants()) do
      if v:IsA("Frame") and v.Name:lower():find("small") and v.Parent.Name:lower():find("notif") then
         small = v
      end
   end

   refs.root = small
   return small
end

getgenv().killSmallNotify = getgenv().killSmallNotify or function()
   local state = getgenv().small_gui_state
   if state.delay_task then
      task.cancel(state.delay_task)
      state.delay_task = nil
   end
   if state.active then
      pcall(function()
         state.active:Destroy()
      end)
      state.active = nil
   end
end

getgenv().openSmallNotify = getgenv().openSmallNotify or function(title_text, duration_time)
   local smallRoot = getgenv().resolveSmallRoot()
   if not smallRoot then return end

   getgenv().killSmallNotify()

   local template = smallRoot:FindFirstChild("Template") or smallRoot:FindFirstChildOfClass("Frame")
   if not template then return end

   local frame_obj = template:Clone()
   frame_obj.Name = tostring(tick())
   frame_obj.Visible = true
   frame_obj.Parent = smallRoot

   if is_touch then
      local ui_scale = frame_obj:FindFirstChildOfClass("UIScale")
      if not ui_scale then
         ui_scale = Instance.new("UIScale")
         ui_scale.Parent = frame_obj
      end
      ui_scale.Scale = 1.35
   end

   frame_obj.Size = UDim2.new(1, 0, 1, 0)
   frame_obj.Title.Text = tostring(title_text)
   frame_obj.Size = UDim2.new(0.02, frame_obj.Title.TextBounds.X, 1, 0)
   frame_obj.Position = UDim2.new(0.5, 0, -1, 0)

   getgenv().small_gui_state.active = frame_obj

   frame_obj:TweenPosition(
      UDim2.new(0.5, 0, 0, 0),
      Enum.EasingDirection.InOut,
      Enum.EasingStyle.Sine,
      0.5,
      true
   )

   getgenv().small_gui_state.delay_task = task.delay(duration_time or 4, function()
      if frame_obj ~= getgenv().small_gui_state.active then return end
      getgenv().small_gui_state.active = nil
      frame_obj:TweenPosition(
         UDim2.new(0.5, 0, -1, 0),
         Enum.EasingDirection.InOut,
         Enum.EasingStyle.Sine,
         0.25,
         true,
         function()
            frame_obj:Destroy()
         end
      )
   end)
end

function berry_ave_notif(content, duration)
   if not duration then
      duration = 5
   end

   if getgenv().openSmallNotify then
      getgenv().openSmallNotify(tostring(content), tonumber(duration))
   else
      return getgenv().notify("Info", tostring(content), tonumber(duration))
   end
end

getgenv().current_vehicle = getgenv().current_vehicle or nil
task.wait(0.2)
local function set_current_vehicle(v)
	if typeof(v) == "Instance" then
		getgenv().current_vehicle = v
	else
		getgenv().current_vehicle = nil
	end
end

local tag_name = "vehicle_watcher"

if not getgenv().FlamesLibrary.is_alive(tag_name) then
   getgenv().FlamesLibrary.spawn(tag_name, "spawn", function()

      local vehicle_event = getgenv().VehicleService_RE:FindFirstChild("VehicleSpawned")

      if vehicle_event then
         local connection = vehicle_event.OnClientEvent:Connect(function(vehicle)
            if typeof(vehicle) == "Instance" then
               set_current_vehicle(vehicle)
            end
         end)

         getgenv().FlamesLibrary.connect(tag_name, connection)
      end

      while task.wait(0.2) do
         local current_vehicle = getgenv().current_vehicle

         if current_vehicle and typeof(current_vehicle) ~= "Instance" then
            set_current_vehicle(nil)
         elseif current_vehicle and not current_vehicle.Parent then
            set_current_vehicle(nil)
         end
      end
   end)
end

local function collect_houses()
   if getgenv().HouseList then
      return getgenv().HouseList
   end

   local list = HouseListMenu
   local houses = {}

   for _, btn in ipairs(list:GetChildren()) do
      if btn:IsA("ImageButton") then
         local robux_label = btn:FindFirstChild("Robux")
         local cost_robux = "No"

         if robux_label and robux_label.Visible then
            cost_robux = "Yes"
         end

         table.insert(houses, {
            Name = btn.Name,
            ["Cost Robux?"] = cost_robux
         })
      end
   end

   getgenv().HouseList = houses
   return houses
end

local function find_house_by_name(name)
   local houses = collect_houses()
   local target

   for _, info in ipairs(houses) do
      if info.Name == tostring(name) then
         target = info
         break
      end
   end

   if target then
      return target.Name
   end
end

getgenv().get_vehicle = getgenv().get_vehicle or function()
   if getgenv().current_vehicle == nil then
      return getgenv().notify("Error", "You do not have a car spawned!", 5)
   else
      return getgenv().current_vehicle
   end
end

getgenv().spawn_any_vehicle = getgenv().spawn_any_vehicle or function(name)
   local car_name = tostring(name)

   if car_name then
      getgenv().Network_Sender("SpawnVehicle", car_name)
   end
end

function pickup_plr(target)
   if target then
      getgenv().Network_Sender("PerformAction", "PickupPlayer", target)
   end
end

function drop_plr(target)
   if target then
      getgenv().Network_Sender("UnperformAction", "PickupPlayer", target)
   end
end

function annoy_plr(toggled, target)
   if toggled then
      if getgenv().annoying_a_plr then
         return getgenv().notify("Warning", "Annoy player is already enabled, turn it off first!", 8)
      end

      getgenv().annoying_a_plr = true
      getgenv().annoying_players_loop_task = task.spawn(function()
         while getgenv().annoying_a_plr == true do
            task.wait()
            pickup_plr(target)
            task.wait(0)
            drop_plr(target)
         end
      end)
      getgenv().notify("Success", "Annoy player started!", 3)
   else
      if not getgenv().annoying_a_plr then
         return getgenv().notify("Warning", "Annoy player is not enabled, turn it on first!", 7)
      end

      if getgenv().annoying_players_loop_task then
         task.cancel(getgenv().annoying_players_loop_task)
         getgenv().annoying_players_loop_task = nil
      end
      getgenv().annoying_a_plr = false
      getgenv().notify("Info", "Annoy player stopped.", 3)
   end
end

function sit_in_vehicle(vehicle)
   if vehicle then
      local VehicleSeats = vehicle and vehicle:FindFirstChild("Seats", true)
      if not VehicleSeats then return getgenv().notify("Error", "'Seats' is not a valid member of Model 'Vehicle'.", 5) end
      local DriverSeat = VehicleSeats:FindFirstChild("Driver", true)
      if not DriverSeat then return getgenv().notify("Error", "'Driver' is not a valid member of Seats 'Folder'.", 5) end

      getgenv().Network_Sender("PerformAction", "Sit", DriverSeat)
   end
end

function spam_headlights(toggled)
   if toggled == true then
      if getgenv().HeadlightsSpammerEnabled then
         return getgenv().notify("Warning", "Headlights Spammer is already enabled.", 5)
      end

      getgenv().HeadlightsSpammerEnabled = true
      getgenv().Headlights_Spammer_Loop_Task = getgenv().Headlights_Spammer_Loop_Task or task.spawn(function()
         while getgenv().HeadlightsSpammerEnabled == true do
         task.wait()
            getgenv().Network_Sender("VehicleRequest", "Headlights") -- only works while in the fucking vehicle btw.
         end
      end)
   elseif toggled == false then
      if not getgenv().HeadlightsSpammerEnabled then
         return getgenv().notify("Warning", "Headlights Spammer is not enabled.", 5)
      end

      if getgenv().Headlights_Spammer_Loop_Task then
         task.cancel(getgenv().Headlights_Spammer_Loop_Task)
         getgenv().Headlights_Spammer_Loop_Task = nil
      end
      getgenv().HeadlightsSpammerEnabled = false
   else
      return 
   end
end

local function get_house()
   local PlotsFolder = getgenv().Workspace:FindFirstChild("Plots", true)
   if not PlotsFolder then return nil end

   for _, plot in ipairs(PlotsFolder:GetChildren()) do
      if plot:IsA("Model") then
         for _, house in ipairs(plot:GetChildren()) do
            if house:IsA("Model") and (house:GetAttribute("Owner") == getgenv().LocalPlayer.Name or house:GetAttribute("Owner") == getgenv().LocalPlayer) then
               return house
            end
         end
      end
   end

   return nil
end

wait(0.2)
function spawn_house(plot, house_name)
   local House = get_house()
   if House then
      return getgenv().notify("Warning", "You already have a house spawned!", 5)
   end

   local args = {
      tostring(plot) or "Plot"..tostring(plot),
      tostring(house_name) or "BeachHouse"
   }

   getgenv().Network_Sender("LoadHouse", args)
end

getgenv().All_Jobs_BerryAve = getgenv().All_Jobs_BerryAve or {}
getgenv().all_job_names = getgenv().all_job_names or {}

getgenv().get_phone_frame = function(Gui)
   if not Gui or typeof(Gui) ~= "Instance" then
      return nil
   end

   for _, v in next, Gui:GetDescendants() do
      if v.ClassName == "Frame" and v.Name == "Phone" then
         local parent = v.Parent
         if parent and parent.Name == "Phone" then
            return v
         end
      end
   end

   return nil
end

getgenv().get_all_jobs = function()
   local PlayerGui = getgenv().PlayerGui or getgenv().LocalPlayer:FindFirstChildOfClass("PlayerGui") or getgenv().LocalPlayer:WaitForChild("PlayerGui", 5)
   local MainGui = PlayerGui:FindFirstChild("Gui") or PlayerGui:WaitForChild("Gui", 5)
   if not MainGui then
      return getgenv().notify("Error", "Could not find main ScreenGui!", 5)
   end

   local Phone_Frame = getgenv().get_phone_frame(MainGui)
   if not Phone_Frame then
      return getgenv().notify("Error", "Could not find Phone Frame!", 5)
   end

   local AppsFrame = Phone_Frame:FindFirstChild("Apps", true)
   if not AppsFrame then
      AppsFrame = Phone_Frame:WaitForChild("Apps", 5)
   end
   if not AppsFrame then
      return getgenv().notify("Error", "Apps Frame not found!", 5)
   end

   local JobsFrame = AppsFrame:FindFirstChild("Jobs", true)
   if not JobsFrame then
      JobsFrame = AppsFrame:WaitForChild("Jobs", 5)
   end
   if not JobsFrame then
      return getgenv().notify("Error", "Jobs Frame not found!", 5)
   end

   local MenuScrollingFrame = JobsFrame:FindFirstChild("Menu", true)
   if not MenuScrollingFrame then
      MenuScrollingFrame = JobsFrame:WaitForChild("Menu", 5)
   end
   if not MenuScrollingFrame then
      return getgenv().notify("Error", "Menu ScrollingFrame not found!", 5)
   end

   table.clear(getgenv().All_Jobs_BerryAve)

   for _, v in next, MenuScrollingFrame:GetChildren() do
      if v.ClassName == "ImageButton" and v.Name ~= "Template" then
         table.insert(getgenv().All_Jobs_BerryAve, v.Name)
      end
   end

   return getgenv().All_Jobs_BerryAve
end
wait(0.1)
getgenv().get_all_jobs()

function teleport_to_plot(plot, tp_random)
   if tp_random and not plot then
      local RandomNum = math.random(1, 22)
      getgenv().Network_Sender("CallHouseMethod", "TeleportToPlot", RandomNum)
   elseif plot and not tp_random then
      if typeof(numberchosen) ~= "number" then
         return getgenv().notify("Error", "Input provided is not a number.", 5)
      end

      getgenv().Network_Sender("CallHouseMethod", "TeleportToPlot", tonumber(plot))
   else
      getgenv().notify("Warning", "Number not specified and random not chosen.", 5)
   end
end

function teleport_to_player(player, tp_random)
   if not player or typeof(player) ~= "Instance" or not player:IsA("Player") then
      return getgenv().notify("Error", "Invalid player provided.", 5)
   end
   if not getgenv().Character or not getgenv().Character.PivotTo then
      return getgenv().notify("Error", "Character not found or invalid.", 5)
   end
   if not getgenv().get_char or typeof(getgenv().get_char) ~= "function" then
      return getgenv().notify("Error", "Global get_char() function missing.", 5)
   end

   local targetChar = getgenv().get_char(player)
   if not targetChar or not targetChar:IsDescendantOf(workspace) then
      return getgenv().notify("Error", "Target's character not found in workspace.", 5)
   end

   local success, err = pcall(function()
      local targetCFrame = targetChar:GetPivot() + Vector3.new(0, 3, 0)
      getgenv().Character:PivotTo(targetCFrame)
   end)

   if not success then
      return getgenv().notify("Error", "Teleport failed: " .. tostring(err), 5)
   end

   getgenv().notify("Success", "Teleported to Player: "..tostring(player.Name)..".", 5)
end

local Prefix = getgenv().AdminPrefix
wait(0.1)
local function CommandsMenu()
   if getgenv().CommandsMenuGUI and getgenv().CommandsMenuGUI.Parent and getgenv().CommandsMenuGUI:IsA("ScreenGui") then
      getgenv().CommandsMenuGUI.Enabled = true
      return
   end

   local cmdsUI = Instance.new("ScreenGui")
   getgenv().CommandsMenuGUI = cmdsUI
   cmdsUI.Name = "AdminCommandList_BerryAve_RP"
   cmdsUI.ResetOnSpawn = false
   cmdsUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
   cmdsUI.Parent = CoreGui or getgenv().CoreGui

   local mainFrame = Instance.new("Frame")
   mainFrame.Size = UDim2.new(0, 600, 0, 500)
   mainFrame.Position = UDim2.new(0.5, -300, 0.5, -250)
   mainFrame.BackgroundColor3 = Color3.fromRGB(75, 151, 75)
   mainFrame.BorderSizePixel = 0
   mainFrame.Active = true
   mainFrame.Parent = cmdsUI

   dragify(mainFrame)
   flowrgb(mainFrame)

   Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

   local uiStroke = Instance.new("UIStroke")
   uiStroke.Thickness = 1.3
   uiStroke.Color = Color3.fromRGB(255, 255, 255)
   uiStroke.Parent = mainFrame

   local closeButton = Instance.new("TextButton")
   closeButton.Text = "X"
   closeButton.Font = Enum.Font.GothamBold
   closeButton.TextSize = 16
   closeButton.Size = UDim2.new(0, 30, 0, 30)
   closeButton.Position = UDim2.new(1, -35, 0, 5)
   closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
   closeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
   closeButton.Parent = mainFrame

   Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)

   local scrollFrame = Instance.new("ScrollingFrame")
   scrollFrame.Size = UDim2.new(1, -20, 1, -70)
   scrollFrame.Position = UDim2.new(0, 10, 0, 40)
   scrollFrame.BackgroundTransparency = 1
   scrollFrame.ScrollBarThickness = 6
   scrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
   scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
   scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
   scrollFrame.Parent = mainFrame

   local layout = Instance.new("UIListLayout")
   layout.Padding = UDim.new(0, 6)
   layout.SortOrder = Enum.SortOrder.LayoutOrder
   layout.Parent = scrollFrame

   local padding = Instance.new("UIPadding")
   padding.PaddingTop = UDim.new(0, 5)
   padding.PaddingLeft = UDim.new(0, 5)
   padding.PaddingRight = UDim.new(0, 5)
   padding.PaddingBottom = UDim.new(0, 5)
   padding.Parent = scrollFrame

   local currentPrefix = getgenv().AdminPrefix
   local channel = getgenv().TextChatService:FindFirstChild("TextChannels"):FindFirstChild("RBXGeneral")
   
   cmdsString = string.gsub(cmdsString, "{prefix}", currentPrefix)

   for line in string.gmatch(cmdsString, "[^\r\n]+") do
      line = line:match("^%s*(.-)%s*$")
      if line ~= "" then
         local parts = string.split(line, " - ")
         local cmdText = parts[1] or line
         local desc = parts[2] or ""

         local frame = Instance.new("Frame")
         frame.Size = UDim2.new(1, -10, 0, 60)
         frame.BackgroundTransparency = 1
         frame.Parent = scrollFrame

         local label = Instance.new("TextLabel")
         label.AutomaticSize = Enum.AutomaticSize.Y
         label.Size = UDim2.new(1, -110, 0, 20)
         label.Position = UDim2.new(0, 0, 0, 0)
         label.BackgroundTransparency = 1
         label.Font = Enum.Font.GothamSemibold
         label.TextSize = 15
         label.TextColor3 = Color3.fromRGB(0, 0, 0)
         label.TextXAlignment = Enum.TextXAlignment.Left
         label.TextYAlignment = Enum.TextYAlignment.Top
         label.TextWrapped = true
         label.TextScaled = false
         label.RichText = true
         label.Text = cmdText
         label.Parent = frame

         local button = Instance.new("TextButton")
         button.Size = UDim2.new(0, 100, 0, 30)
         button.Position = UDim2.new(1, -100, 0, 15)
         button.Text = "Run"
         button.Font = Enum.Font.GothamBold
         button.TextSize = 14
         button.TextColor3 = Color3.new(1, 1, 1)
         button.BackgroundColor3 = Color3.fromRGB(27, 42, 53)
         button.Parent = frame
         Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

         local commandToSend = cmdText
         local TweenService = getgenv().TweenService
         local UserInputService = getgenv().UserInputService

         local tooltipGui = Instance.new("ScreenGui")
         tooltipGui.Name = "AdminTooltipUI"
         tooltipGui.ResetOnSpawn = false
         tooltipGui.IgnoreGuiInset = true
         tooltipGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
         tooltipGui.DisplayOrder = 9999
         tooltipGui.Parent = CoreGui
         wait()
         local tooltip = Instance.new("TextLabel")
         tooltip.Name = "CommandTooltip"
         tooltip.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
         tooltip.TextColor3 = Color3.new(1, 1, 1)
         tooltip.Font = Enum.Font.GothamSemibold
         tooltip.TextSize = 14
         tooltip.TextWrapped = true
         tooltip.AutomaticSize = Enum.AutomaticSize.XY
         tooltip.BackgroundTransparency = 0.2
         tooltip.Visible = false
         tooltip.ZIndex = 10000
         tooltip.AnchorPoint = Vector2.new(0, 1)
         tooltip.Position = UDim2.new(0, 0, 0, 0)
         tooltip.Parent = tooltipGui

         local corner = Instance.new("UICorner", tooltip)
         corner.CornerRadius = UDim.new(0, 6)
         local padding = Instance.new("UIPadding", tooltip)
         padding.PaddingLeft = UDim.new(0, 6)
         tooltip.TextYAlignment = Enum.TextYAlignment.Top

         local mousePos = Vector2.new()
         getgenv().UserInputService.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
               mousePos = Vector2.new(input.Position.X, input.Position.Y)
            end
         end)

         local runService = getgenv().RunService
         runService.RenderStepped:Connect(function()
            if tooltip.Visible then
               tooltip.Position = UDim2.fromOffset(mousePos.X + 15, mousePos.Y - 10)
            end
         end)

         local function showTooltip()
            tooltip.Text = desc
            tooltip.Visible = true
            TweenService:Create(tooltip, TweenInfo.new(0.15), {BackgroundTransparency = 0.15, TextTransparency = 0}):Play()
         end

         local function hideTooltip()
            TweenService:Create(tooltip, TweenInfo.new(0.15), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            task.delay(0.15, function()
               if tooltip.BackgroundTransparency >= 0.99 then
                  tooltip.Visible = false
               end
            end)
         end

         label.MouseEnter:Connect(showTooltip)
         label.MouseLeave:Connect(hideTooltip)
         button.MouseEnter:Connect(showTooltip)
         button.MouseLeave:Connect(hideTooltip)

         button.MouseButton1Click:Connect(function()
            local hasDirect = getgenv().DirectCommand and typeof(getgenv().DirectCommand) == "function"
            local hasHandle = getgenv().handleCommand and typeof(getgenv().handleCommand) == "function"

            if hasDirect and hasHandle then
               getgenv().DirectCommand(commandToSend)
            elseif hasDirect and not hasHandle then
               getgenv().notify("Error", "getgenv().DirectCommand exists, but getgenv().handleCommand is missing.", 10)
            elseif not hasDirect and hasHandle then
               getgenv().notify("Error", "getgenv().handleCommand exists, but getgenv().DirectCommand is missing.", 10)
            else
               getgenv().notify("Error", "Neither DirectCommand nor handleCommand exist.", 6)
            end
         end)
      end
   end

   closeButton.MouseButton1Click:Connect(function()
      if cmdsUI and cmdsUI:IsA("ScreenGui") then
         pcall(function() cmdsUI.Enabled = false end)
      elseif getgenv().CommandsMenuGUI and getgenv().CommandsMenuGUI:IsA("ScreenGui") then
         pcall(function() getgenv().CommandsMenuGUI.Enabled = false end)
      else
         if CoreGui:FindFirstChild("AdminCommandList_BerryAve_RP") and CoreGui:FindFirstChild("AdminCommandList_BerryAve_RP"):IsA("ScreenGui") then
            pcall(function() CoreGui:FindFirstChild("AdminCommandList_BerryAve_RP").Enabled = false end)
         end
      end
   end)

   getgenv().fix_commands_menu_main_delay = getgenv().fix_commands_menu_main_delay or task.spawn(function()
      local fixDelay = 1
      local runService = getgenv().RunService or game:GetService("RunService")
      local playerGui = getgenv().PlayerGui or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

      while task.wait(fixDelay) do
         local gui = (get_hidden_gui and get_hidden_gui()) or (gethui and gethui()) or getgenv().CoreGui or playerGui
         local menu = gui:FindFirstChild("AdminCommandList_LifeTogether_RP", true)
         if not menu then continue end

         for _, label in ipairs(menu:GetDescendants()) do
            if label:IsA("TextLabel") and label.Text and label.Text ~= "" then
               local parent = label.Parent
               if label.TextScaled or label.Size.Y.Scale > 0 or label.Size.Y.Offset <= 5 then
                  label.TextScaled = false
                  label.TextSize = 15
                  label.AutomaticSize = Enum.AutomaticSize.Y
                  label.Size = UDim2.new(1, -110, 0, 20)
                  label.TextWrapped = true
                  label.RichText = true
                  label.TextColor3 = Color3.fromRGB(0, 0, 0)
                  if parent and parent:IsA("Frame") then
                     parent.AutomaticSize = Enum.AutomaticSize.Y
                  end
               end
               if label.TextTransparency >= 0.9 then
                  label.TextTransparency = 0
               end
            end
         end
      end
   end)
end
wait(0.1)
function CreateCreditsLabel()
   if getgenv().CreditsLabelGui then
      getgenv().CreditsLabelGui:Destroy()
   end

   local creditsGui = Instance.new("ScreenGui")
   creditsGui.Name = "PrefixCreditsGui_BerryAvenue_RP"
   creditsGui.ResetOnSpawn = false
   creditsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
   creditsGui.Parent = CoreGui

   local label = Instance.new("TextLabel")
   label.Name = "CreditsLabel"
   getgenv().MainCreditsLabel_WithPrefix = label
   label.AnchorPoint = Vector2.new(0.5, 1)
   if is_touch then
      label.Position = UDim2.new(0.5, 0, 0.95, -10)
      label.Size = UDim2.new(0.3, 0, 0, 28)
   else
      label.Position = UDim2.new(0.5, 0, 0.949999988, 25)
      label.Size = UDim2.new(0.6, 0, 0, 28)
   end
   label.BackgroundColor3 = Color3.fromRGB(151, 0, 0)
   label.TextColor3 = Color3.fromRGB(0, 0, 0)
   flowrgb("PrefixCreditsLabelConn",0.7,label,true)
   local prefix = decodeHTMLEntities(tostring(getgenv().AdminPrefix))
   local parts = {
      tostring(Script_Version)
   }
   if holiday ~= "" then
      table.insert(parts, holiday)
   end
   table.insert(parts, "Made By: " .. tostring(Script_Creator))
   table.insert(parts, "Current Prefix: " .. prefix)

   label.Text = table.concat(parts, " | ")
   label.Font = Enum.Font.GothamBold
   label.TextScaled = true
   label.RichText = false
   label.TextStrokeTransparency = 1
   label.BackgroundTransparency = 0
   label.ZIndex = 10
   label.Parent = creditsGui

   local corner = Instance.new("UICorner")
   corner.CornerRadius = UDim.new(0, 10)
   corner.Parent = label

   getgenv().CreditsLabelGui = creditsGui
   getgenv().CreditsLabelText = label

   if getgenv()._PrefixUpdateConnection then
      getgenv()._PrefixUpdateConnection:Disconnect()
   end

   if typeof(getgenv().AdminPrefix) == "Instance" and getgenv().AdminPrefix:IsA("StringValue") then
      getgenv()._PrefixUpdateConnection = getgenv().AdminPrefix.Changed:Connect(function()
         lastPrefix = tostring(getgenv().AdminPrefix)
         local prefix = decodeHTMLEntities(tostring(getgenv().AdminPrefix))
         local parts = {
            tostring(Script_Version)
         }
         if holiday ~= "" then
            table.insert(parts, holiday)
         end
         table.insert(parts, "Made By: " .. tostring(Script_Creator))
         table.insert(parts, "Current Prefix: " .. prefix)

         label.Text = table.concat(parts, " | ")
      end)
   else
      getgenv().LastPrefix_Updater_Main_Task_Watcher = getgenv().LastPrefix_Updater_Main_Task_Watcher or task.spawn(function()
         local lastPrefix = tostring(getgenv().AdminPrefix)
         while label and label.Parent do
            task.wait(0.3)
            if tostring(getgenv().AdminPrefix) ~= lastPrefix then
               lastPrefix = tostring(getgenv().AdminPrefix)
               local prefix = decodeHTMLEntities(tostring(getgenv().AdminPrefix))
               local parts = {
                  tostring(Script_Version)
               }
               if holiday ~= "" then
                  table.insert(parts, holiday)
               end
               table.insert(parts, "Made By: " .. tostring(Script_Creator))
               table.insert(parts, "Current Prefix: " .. prefix)

               label.Text = table.concat(parts, " | ")
            end
         end
      end)
   end
end
wait(0.2)
CreateCreditsLabel()

getgenv().has_any_house = getgenv().has_any_house or function()
   local CallBack = getgenv().HouseService_RF:WaitForChild("HasPlot", 0.5):InvokeServer()

   if CallBack == true then
      return true
   elseif CallBack == false then
      return false
   else
      return false
   end
end

function delete_house()
   if not getgenv().has_any_house then
      return getgenv().notify("Error", "You do not have a House, get one first.", 6)
   end

   local args = {
      "Move"
   }

   getgenv().Network_Sender("CallHouseMethod", args)
end

local function get_age(player)
   if not player then
      getgenv().notify("Error", "That player does not exist.", 5)
      return nil
   end

   local Players = getgenv().Players
   local localPlayer = getgenv().LocalPlayer

   if player == localPlayer or player == localPlayer.Name or (typeof(player) == "Instance" and player.Name == localPlayer.Name) then
      local character = getgenv().get_char(localPlayer)
      if character then
         return character:GetAttribute("Age")
      else
         return nil
      end
   end

   local targetPlayer
   if typeof(player) == "string" then
      targetPlayer = Players:FindFirstChild(player)
   elseif typeof(player) == "Instance" and player:IsA("Player") then
      targetPlayer = player
   end

   if not targetPlayer then
      getgenv().notify("Error", "Target player not found.", 5)
      return nil
   end

   local targetChar = getgenv().get_char(targetPlayer)
   if targetChar then
      return targetChar:GetAttribute("Age")
   else
      getgenv().notify("Error", "Target character not found.", 5)
      return nil
   end
end

function job_spammer_toggle(toggle)
   if toggle == true then
      if getgenv().JobSpammer_Enabled then
         return getgenv().notify("Warning", "Job Spammer is already enabled!", 5)
      end

      getgenv().JobSpammer_Enabled = true
      getgenv().Job_Spammer_Main_Loop_Task = getgenv().Job_Spammer_Main_Loop_Task or task.spawn(function()
         while getgenv().JobSpammer_Enabled == true do
         task.wait()
            for _, job in pairs(getgenv().All_Jobs_BerryAve) do
               getgenv().Network_Sender("ChangeRole", tostring(job))
               task.wait(0)
            end
         end
      end)
   elseif toggle == false then
      if not getgenv().JobSpammer_Enabled then
         return getgenv().notify("Warning", "Job Spammer is not enabled!", 5)
      end

      if getgenv().Job_Spammer_Main_Loop_Task then
         task.cancel(getgenv().Job_Spammer_Main_Loop_Task)
         getgenv().Job_Spammer_Main_Loop_Task = nil
      end
      getgenv().JobSpammer_Enabled = false
   else
      return 
   end
end

function tp_to_house()
   if not getgenv().has_any_house then
      return getgenv().notify("Error", "You do not have a House, get one first.", 6)
   end

   local args = {
      "TeleportTo"
   }
   
   getgenv().Network_Sender("CallMethod", args)
end

function mod_vehicle_preset()
   if getgenv().current_vehicle == nil then
      return getgenv().notify("Warning", "You do not have a Vehicle spawned!", 5)
   end

   local CarConfig = require(getgenv().current_vehicle:FindFirstChild("Configuration"))

   if not CarConfig then
      return getgenv().notify("Error", "Configuration was not found inside of Vehicle!", 5)
   end

   CarConfig.MaxSpeed = 350
   CarConfig.ReverseSpeed = 100
   CarConfig.Acceleration = 90
   CarConfig.BrakePower = 999999
end

function despawn_vehicle()
   local vehicle = getgenv().current_vehicle
   if vehicle == nil then
      return getgenv().notify("Warning", "You do not have a Vehicle spawned!", 5)
   end

   getgenv().Network_Sender("SpawnVehicle", tostring(vehicle.Name))
end

getgenv().ToggleLockVehicle = function(state)
   if state == true then
      local car = getgenv().current_vehicle

      if car == nil then
         return getgenv().notify("Warning", "You do not have a Vehicle spawned!", 5)
      end
      if car:GetAttribute("Locked") == true then
         return getgenv().notify("Warning", "Your Vehicle is already locked!", 5)
      end

      getgenv().Network_Sender("VehicleRequest", "Lock")
      getgenv().notify("Success", "Vehicle has been locked.", 5)
   elseif state == false then
      local car = getgenv().current_vehicle

      if car == nil then
         return getgenv().notify("Warning", "You do not have a Vehicle spawned!", 5)
      end
      if car:GetAttribute("Locked") == false then
         return getgenv().notify("Warning", "Your Vehicle is already unlocked!", 5)
      end

      getgenv().Network_Sender("VehicleRequest", "Lock")
      getgenv().notify("Success", "Vehicle has been unlocked.", 5)
   else
      return 
   end
end

getgenv().FlySpeed = getgenv().FlySpeed or 25
getgenv().FlyEnabled = false
getgenv().DefaultGameWS = (getgenv().Humanoid and getgenv().Humanoid.WalkSpeed) or (getgenv().StarterPlayer and getgenv().StarterPlayer.CharacterWalkSpeed) or 16
wait(0.2)
getgenv().StartFlyingMechanic = function(state, speed)
   if type(speed) ~= "number" then speed = 25 end
   getgenv().FlySpeed = speed

   local ControllersFolder = getgenv().LocalPlayer:WaitForChild("PlayerScripts", 1):WaitForChild("Controllers")
   local FlyController = ControllersFolder:FindFirstChild("FlyController")
   if not FlyController then
      return getgenv().notify("Error", "FlyController ModuleScript does not exist!", 5)
   end

   local ControllerModule = require(FlyController)
   getgenv().FlyController = ControllerModule

   if state == true then
      local hum = getgenv().Humanoid
      getgenv().FlyEnabled = true
      if ControllerModule.SetFlying then
         ControllerModule:SetFlying(true)
      end
      wait(0.1)
      if hum then
         hum.WalkSpeed = speed
         getgenv().FlySpeed = getgenv().FlySpeed or speed
      end
   elseif state == false then
      local hum = getgenv().Humanoid
      getgenv().FlyEnabled = false
      if ControllerModule.SetFlying then
         ControllerModule:SetFlying(false)
      end
      wait(0.1)
      if hum then
         hum.WalkSpeed = getgenv().DefaultGameWS or 16
      end
   else
      return 
   end
end

if not executor_contains("LX63") then
   berry_ave_notif("Welcome to the fuckin script bro!", 10)
end

pcall(function()
   getgenv().LocalPlayer.CameraMaxZoomDistance = 100000
   getgenv().LocalPlayer.CameraMinZoomDistance = 0.5
   task.wait(.1)
   if getgenv().LocalPlayer.CameraMaxZoomDistance > 90000 then
      getgenv().notify("Success", "Set CameraMaxZoomDistance to: "..tostring(getgenv().LocalPlayer.CameraMaxZoomDistance), 7)
   else
      getgenv().notify("Warning", "We we're not able to correctly set CameraMaxZoomDistance!", 5)
   end
   if getgenv().LocalPlayer.CameraMinZoomDistance < 5 then
      getgenv().notify("Success", "Set CameraMinZoomDistance to: "..tostring(getgenv().LocalPlayer.CameraMinZoomDistance), 7)
   else
      getgenv().notify("Warning", "We we're not able to correctly set CameraMinZoomDistance!", 5)
   end
   wait(0.1)
   if getgenv().StarterPlayer.CharacterUseJumpPower then
      getgenv().Humanoid.JumpPower = 50
      getgenv().notify("Success", "Spoofed JumpPower to: "..tostring(getgenv().Humanoid.JumpPower))
   else
      getgenv().Humanoid.JumpHeight = 7
      getgenv().notify("Success", "Spoofed JumpHeight to: "..tostring(getgenv().Humanoid.JumpHeight))
   end
   getgenv().StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
   if getgenv().LocalPlayer.Name == "CIippedByAura" then
      getgenv().notify("Success", "Enabled Backpack.", 5)
      getgenv().StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
   end
   getgenv().notify("Success", "Enabled Leaderboard.", 5)
end)

local function handleCommand(sender, message)
   if not Admins[sender.Name] then return end

   getgenv().Known_Admin_Commands = getgenv().Known_Admin_Commands or nil
   wait()
   if not getgenv().Known_Admin_Commands then
      local known = {}
      for cmd in cmdsString:gmatch("{prefix}([%w_%-]+)") do
         table.insert(known, cmd:lower())
      end
      getgenv().Known_Admin_Commands = known
   end

   local function sanitize_message(str)
      local cleaned = str:gsub("%b()", "")
      cleaned = cleaned:gsub("[%z\1-\127\194-\244][\128-\191]*", function(c)
         return (c:match("[%w%s%p]") and c) or ""
      end)
      return cleaned:match("^%s*(.-)%s*$")
   end

   message = sanitize_message(message or "")

   local prefix = tostring(getgenv().AdminPrefix or "-")
   if message:sub(1, #prefix):lower() ~= prefix:lower() then return end
   local function levenshtein(s, t)
      if s == t then return 0 end
      local len_s, len_t = #s, #t
      if len_s == 0 then return len_t end
      if len_t == 0 then return len_s end
      local d = {}
      for i = 0, len_s do d[i] = {[0] = i} end
      for j = 0, len_t do d[0][j] = j end
      for i = 1, len_s do
         for j = 1, len_t do
            local cost = (s:sub(i,i) == t:sub(j,j)) and 0 or 1
            
            d[i][j] = math.min(
               d[i-1][j] + 1,
               d[i][j-1] + 1,
               d[i-1][j-1] + cost
            )
         end
      end
      return d[len_s][len_t]
   end

   local msg_no_prefix = message:sub(#prefix + 1)
   local split = msg_no_prefix:split(" ")
   local raw_cmd = (table.remove(split, 1) or ""):lower()
   local args = split
   local best, bestDist = raw_cmd, math.huge

   for _, real in ipairs(getgenv().Known_Admin_Commands) do
      local dist = levenshtein(raw_cmd, real)
      if dist < bestDist then
         bestDist = dist
         best = real
      end
   end

   local allowedDist = math.max(1, math.floor(#raw_cmd / 3))
   if bestDist <= allowedDist and best ~= raw_cmd then
      getgenv().notify("Info", ("Auto-corrected '%s' → '%s%s'"):format(raw_cmd, prefix, best), 6)
      raw_cmd = best
   end

   local cleanedMessage = raw_cmd
   if #args > 0 then
      cleanedMessage = cleanedMessage .. " " .. table.concat(args, " ")
   end

   if getgenv().LocalPlayer.Name ~= "CIippedByAura" then
      getgenv().CommandAPI.Handle_Command(
         getgenv().LocalPlayer or game.Players.LocalPlayer,
         prefix .. cleanedMessage
      )
   end
   getgenv().Anti_Sit_Connection = nil
   getgenv().anti_knockback_connection = nil
   getgenv().Noclip_Connection = nil
   local Clip = false

   if raw_cmd == "prefix" then
      local new_prefix = tostring(split[1] or ""):gsub("%s+", "")

      local valid = false
      for _, allowedprefix in ipairs(Allowed_Prefixes) do
         if new_prefix == allowedprefix then
            valid = true
            break
         end
      end

      if not valid then
         return getgenv().notify("Warning", "This is not an allowed Prefix, sorry! Please use a regular symbolized prefix.", 7)
      end
      wait(0.1)
      if new_prefix == "" then
         return getgenv().notify("Error", "Invalid prefix! It cannot be empty.", 5)
      end
      getgenv().AdminPrefix = new_prefix
      savePrefix(getgenv().AdminPrefix)
      wait(0.1)
      getgenv().notify("Success", "Prefix has been changed to '" .. new_prefix .. "'", 5)
      return 
   end

   if raw_cmd == "spawn" and split[1] then
      local name = split[1]:lower()

      for _, fullName in pairs(getgenv().AllVehicleNames) do
         if fullName:lower():find(name) then
            spawn_any_vehicle(fullName)
            getgenv().notify("Success", "Spawning requested vehicle: " .. tostring(fullName), 3)
            return
         end
      end

      getgenv().notify("Error", "Name not matched.", 5)
   elseif raw_cmd == "fly" or raw_cmd == "startfly" then
      local speed = tonumber(split[1]) or 10

      getgenv().StartFlyingMechanic(true, speed)
   elseif raw_cmd == "unfly" or raw_cmd == "stopfly" then
      getgenv().StartFlyingMechanic(false)
   elseif raw_cmd == "rgbcar" or raw_cmd == "rgbvehicle" or raw_cmd == "startrgbcar" or raw_cmd == "rainbowcar" then
      rainbow_vehicle(true)
   elseif raw_cmd == "unrgbcar" or raw_cmd == "unrgbvehicle" or raw_cmd == "stoprgbcar" or raw_cmd == "unrainbowcar" then
      rainbow_vehicle(false)
   elseif raw_cmd == "flashhl" or raw_cmd == "spamhl" or raw_cmd == "spamheadlights" or raw_cmd == "headlightsspammer" or raw_cmd == "hlspammer" or raw_cmd == "hlspam" then
      spam_headlights(true)
   elseif raw_cmd == "unflashhl" or raw_cmd == "unspamhl" or raw_cmd == "unspamheadlights" or raw_cmd == "unheadlightspammer" or raw_cmd == "unhlspammer" or raw_cmd == "unhlspam" then
      spam_headlights(false)
   elseif raw_cmd == "gotohouse" then
      tp_to_house()
   elseif raw_cmd == "delhouse" or raw_cmd == "removehouse" or raw_cmd == "unspawnhouse" or raw_cmd == "deletehouse" or raw_cmd == "delhome" then
      delete_house()
   elseif raw_cmd == "antisit" or raw_cmd == "nosit" then
      getgenv().toggle_anti_sit(true)
   elseif raw_cmd == "unantisit" or raw_cmd == "unnosit" then
      getgenv().toggle_anti_sit(false)
   elseif raw_cmd == "jobspam" or raw_cmd == "jobspammer" then
      job_spammer_toggle(true)
   elseif raw_cmd == "unjobspam" or raw_cmd == "unjobspammer" then
      job_spammer_toggle(false)
   elseif raw_cmd == "lockcar" then
      getgenv().ToggleLockVehicle(true)
   elseif raw_cmd == "unlockcar" then
      getgenv().ToggleLockVehicle(false)
   elseif raw_cmd == "despawn" or raw_cmd == "delcar" or raw_cmd == "despawncar" or raw_cmd == "delvehicle" then
      despawn_vehicle()
   elseif raw_cmd == "modcar" or raw_cmd == "modvehicle" or raw_cmd == "fastcar" then
      mod_vehicle_preset()
   elseif raw_cmd == "carry" or raw_cmd == "pickup" then
      local target_plr = findplr(split[1])

      if not target_plr then
         return getgenv().notify("Error", "That player does not exist!", 5)
      end

      pickup_plr(target_plr)
   elseif raw_cmd == "drop" or raw_cmd == "dropplr" then
      local target_plr = findplr(split[1])

      if not target_plr then
         return getgenv().notify("Error", "That player does not exist!", 5)
      end

      drop_plr(target_plr)
   elseif raw_cmd == "annoy" or raw_cmd == "spampickup" or raw_cmd == "spamcarry" then
      local annoy_target = findplr(split[1])
      if not annoy_target then return getgenv().notify("Error", "That player does not exist.", 5) end

      annoy_plr(true, annoy_target)
   elseif raw_cmd == "unannoy" or raw_cmd == "unspampickup" or raw_cmd == "unspamcarry" then
      annoy_plr(false)
   elseif raw_cmd == "cmds" or raw_cmd == "commands" then
      CommandsMenu()
   end
end
wait(0.5)
getgenv().handleCommand = handleCommand
getgenv().ChatMessageHooks = getgenv().ChatMessageHooks or {}
local TextChatService = cloneref and cloneref(game:GetService("TextChatService")) or game:GetService("TextChatService")
local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local function get_general_channel()
   local channels = TextChatService:FindFirstChild("TextChannels")
   if not channels then return nil, "no_text_channels" end
   local general = channels:FindFirstChild("RBXGeneral")
   if not general then return nil, "no_general_channel" end
   return general
end

getgenv().Setup_Chat_Command_Listener = function()
   if getgenv().Chat_MessageReceived_Connection then
      getgenv().Chat_MessageReceived_Connection:Disconnect()
      getgenv().Chat_MessageReceived_Connection = nil
   end
   wait(0.25)
   local general, err = get_general_channel()
   if not general then
      return false, err
   end

   local local_player = getgenv().LocalPlayer or Players.LocalPlayer
   getgenv().Chat_MessageReceived_Connection = general.MessageReceived:Connect(function(msg)
      if not msg.TextSource then return end
      if msg.TextSource.UserId ~= local_player.UserId then return end

      handleCommand(local_player, msg.Text)
   end)

   return true
end

getgenv().Setup_Chat_Command_Listener()
getgenv().global_isinchat_msghooks = function(func)
   for _, v in ipairs(getgenv().ChatMessageHooks) do
      if v == func then
         return true
      end
   end
   return false
end

getgenv().handle_chattercommands = function(sender, msg)
   handleCommand(sender, msg.Text)
end

if not global_isinchat_msghooks(handle_chattercommands) then
   table.insert(getgenv().ChatMessageHooks, handle_chattercommands)
end

getgenv().DirectCommand = function(text)
   local prefix = tostring(getgenv().AdminPrefix or ";")
   text = tostring(text or ""):gsub("^%s+", ""):gsub("%s+$", "")

   if text == "" then return end

   if text:sub(1,#prefix) ~= prefix then
      text = prefix .. text
   end

   local player = getgenv().LocalPlayer or game.Players.LocalPlayer
   getgenv().handleCommand(player, text)
end
wait(0.2)
local CHECK_INTERVAL = 1
local MAX_FAILS_BEFORE_WARN = 5

function Notify(message, duration)
   local NotificationGui = Instance.new("ScreenGui")
   NotificationGui.Name = "CustomErrorGui"
   NotificationGui.ResetOnSpawn = false
   NotificationGui.Parent = CoreGui
   duration = duration or 5

   local Frame = Instance.new("Frame")
   Frame.Name = "ErrorMessage"
   Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
   Frame.BackgroundTransparency = 0.3
   Frame.BorderSizePixel = 0
   Frame.Size = UDim2.new(0, 500, 0, 120)
   Frame.Position = UDim2.new(0, 20, 0, 100)
   Frame.Parent = NotificationGui

   local UICorner = Instance.new("UICorner")
   UICorner.CornerRadius = UDim.new(0, 10)
   UICorner.Parent = Frame

   local Icon = Instance.new("ImageLabel")
   Icon.Name = "ErrorIcon"
   Icon.AnchorPoint = Vector2.new(0, 0.5)
   Icon.BackgroundTransparency = 1
   Icon.Position = UDim2.new(0, 15, 0.5, -25)
   Icon.Size = UDim2.new(0, 50, 0, 50)
   Icon.Image = "rbxasset://textures/ui/Emotes/ErrorIcon.png"
   Icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
   Icon.Parent = Frame

   local Label = Instance.new("TextLabel")
   Label.Name = "ErrorText"
   Label.BackgroundTransparency = 1
   Label.Position = UDim2.new(0, 80, 0, 10)
   Label.Size = UDim2.new(1, -90, 1, -20)
   Label.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json")
   Label.Text = message
   Label.TextColor3 = Color3.fromRGB(255, 255, 255)
   Label.TextSize = 20
   Label.TextWrapped = true
   Label.TextXAlignment = Enum.TextXAlignment.Left
   Label.TextYAlignment = Enum.TextYAlignment.Top
   Label.Parent = Frame

   Frame.BackgroundTransparency = 1
   Icon.ImageTransparency = 1
   Label.TextTransparency = 1
   TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.3}):Play()
   TweenService:Create(Icon, TweenInfo.new(0.3), {ImageTransparency = 0}):Play()
   TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 0}):Play()

   task.delay(duration, function()
      if Frame and Frame.Parent then
         TweenService:Create(Frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
         TweenService:Create(Icon, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
         TweenService:Create(Label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
         task.wait(0.35)
         Frame:Destroy()
         NotificationGui:Destroy()
      end
   end)
end

--[[getgenv().Script_Version_Finding_Main_Updater_Loop_Task = getgenv().Script_Version_Finding_Main_Updater_Loop_Task or task.spawn(function()
   local failCount = 0
   local threadToken = getgenv().__LTA_UPDATE_THREAD

   while getgenv().ConstantUpdate_Checker_Live
      and threadToken == getgenv().__LTA_UPDATE_THREAD do

      task.wait(CHECK_INTERVAL)

      local success, result = pcall(function()
         local json = game:HttpGet(
            "https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Script_Versions_JSON.json?cb=" .. math.random(1, 1e9)
         )
         return getgenv().HttpService:JSONDecode(json)
      end)

      if not success or type(result) ~= "table" then
         failCount += 1
         if failCount >= MAX_FAILS_BEFORE_WARN then
            warn("[Update Checker]: HTTP/JSON failure (" .. failCount .. ")")
            failCount = 0
         end
         continue
      end

      failCount = 0

      local newVersion = result.Berry_Avenue_Admin
      if not newVersion then
         warn("[Update Checker]: Missing Berry_Avenue_Admin JSON.")
         continue
      end

      if Script_Version ~= newVersion
         and not getgenv().__LTA_UPDATE_LOCK
         and getgenv().__LTA_LAST_VERSION ~= newVersion then
         
         getgenv().__LTA_UPDATE_LOCK = true
         getgenv().__LTA_LAST_VERSION = newVersion
         getgenv().ConstantUpdate_Checker_Live = false

         Notify(
            "[BERRY AVENUE - ADMIN]: Update detected!\nNew version: "
            .. tostring(newVersion)
            .. "\nRe-executing automatically...",
            30
         )

         getgenv().Berry_Ave_Admin_Loaded = false
         task.wait(2)
         loadstring(game:HttpGet("https://raw.githubusercontent.com/dudeididntliterally/Main/refs/heads/main/Experiences/8481844229.lua"))()

         break
      end
   end
end)--]]