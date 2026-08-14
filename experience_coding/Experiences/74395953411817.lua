if not game:IsLoaded() then
   local msg_instance = Instance.new("Message")
   local hint_instance = Instance.new("Hint")
   msg_instance.Text = "Flames Hub is waiting for the current experience to load fully."
   hint_instance.Text = "Flames Hub is currently waiting for the game to load."
   msg_instance.Parent = workspace
   hint_instance.Parent = workspace
   game.Loaded:Wait()
   task.wait(0.1)
   msg_instance:Destroy()
   hint_instance:Destroy()
end

local Raw_Version = "V1.1.9"
getgenv().Script_Version = tostring(Raw_Version).."-DreamvilleRP"
local g = getgenv()
if not g.GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://pastebin.com/raw/T25mDhBZ"))()
   wait(0.1)
   g.GlobalEnvironmentFramework_Initialized = true
end
wait(0.2)
if getgenv().Dreamville_RP_Hub_Loaded then return end
getgenv().Dreamville_RP_Hub_Loaded = true
function FuzzyFindChild(parent, query, timeout)
   if not parent or typeof(parent) ~= "Instance" then return nil end
   if not query or query == "" then return nil end
   timeout = timeout or 3
   local Lowered_Query = query:lower()
   local Start_Time = os.clock()

   repeat
      for _, Child in ipairs(parent:GetChildren()) do if Child.Name:lower():find(Lowered_Query, 1, true) then return Child end end
      task.wait(0.1)
   until os.clock() - Start_Time >= timeout
   return nil
end

local words = {
   "root_access","packet_inject","xor_key","decrypting",
   "init_stealth","spoof_id","kernel_hook","bruteforce",
   "sys_reboot","net_breach","ghost_mode","backdoor_init"
}
task.wait(0.15)
local Packages = FuzzyFindChild(ReplicatedStorage, "packages")
local Flux = Packages and FuzzyFindChild(Packages, "flux")
local Services = Flux and FuzzyFindChild(Flux, "services")
local RoleService = Services and FuzzyFindChild(Services, "roleservice")
local Role_RF = RoleService and FuzzyFindChild(RoleService, "rf")
local VehicleService = Services and FuzzyFindChild(Services, "vehicleservice")
local Vehicle_RF = VehicleService and FuzzyFindChild(VehicleService, "rf")
local Vehicle_Color = Vehicle_RF and FuzzyFindChild(Vehicle_RF, "setvehiclecolor")
local Set_Name = Role_RF and FuzzyFindChild(Role_RF, "setname")
local Set_Description = Role_RF and FuzzyFindChild(Role_RF, "setdescription")
local AvatarService = Services and FuzzyFindChild(Services, "avatarservice")
local Avatar_RF = AvatarService and FuzzyFindChild(AvatarService, "rf")
local Save_Outfit_RF = Avatar_RF and FuzzyFindChild(Avatar_RF, "createoutfit")
local Set_Body_Colors = Avatar_RF and FuzzyFindChild(Avatar_RF, "setbodycolors")
local Set_Vehicle_Locked = Vehicle_RF and FuzzyFindChild(Vehicle_RF, "setvehiclelocked")
local ActionRequestService = Services and FuzzyFindChild(Services, "actionrequestservice")
local Actions_RF_Folder = ActionRequestService and FuzzyFindChild(ActionRequestService, "rf")
local Request_Action_RF = Actions_RF_Folder and FuzzyFindChild(Actions_RF_Folder, "requestaction")
local SetRole_RF = Role_RF and FuzzyFindChild(Role_RF, "setrole")
local Vehicles = FuzzyFindChild(Workspace, "vehicles")
local cmdp = Players
local cmdlp = cmdp.LocalPlayer
local fileName = "Dreamville_Admin_Configuration.json"
local Admins = { [getgenv().LocalPlayer.Name] = true }
local function loadPrefix()
   if isfile and isfile(fileName) then
      local raw = readfile(fileName)
      local success, decoded = pcall(function()
         return HttpService:JSONDecode(raw)
      end)
      if success and decoded and decoded.prefix then
         return tostring(decoded.prefix)
      end
   end
   return ";"
end
wait(0.3)
function findplr(args)
   local tbl = cmdp:GetPlayers()

   if args == "me" or args == cmdlp.Name or args == cmdlp.DisplayName then
      return warn("Failure!", "You cannot target yourself!")
   end

   if args == "random" then
      local validPlayers = {}
      for _, v in pairs(tbl) do
         if v ~= cmdlp then
            table.insert(validPlayers, v)
         end
      end
      return #validPlayers > 0 and validPlayers[math.random(1, #validPlayers)] or nil
   end

   if args == "new" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v.AccountAge < 30 and v ~= cmdlp then
            table.insert(vAges, v)
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "old" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v.AccountAge > 30 and v ~= cmdlp then
            table.insert(vAges, v)
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "bacon" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v ~= cmdlp and (v.Character:FindFirstChild("Pal Hair") or v.Character:FindFirstChild("Kate Hair")) then
            table.insert(vAges, v)
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "friend" then
      local friendList = {}
      for _, v in pairs(tbl) do
         if v:IsFriendsWith(cmdlp.UserId) and v ~= cmdlp then
            table.insert(friendList, v)
         end
      end
      return #friendList > 0 and friendList[math.random(1, #friendList)] or nil
   end

   if args == "notfriend" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if not v:IsFriendsWith(cmdlp.UserId) and v ~= cmdlp then
            table.insert(vAges, v)
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "ally" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v.Team == cmdlp.Team and v ~= cmdlp then
            table.insert(vAges, v)
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "enemy" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v.Team ~= cmdlp.Team and v ~= cmdlp then
            table.insert(vAges, v)
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "near" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v ~= cmdlp and v.Character and cmdlp.Character then
            local vRootPart = v.Character:FindFirstChild("HumanoidRootPart")
            local cmdlpRootPart = cmdlp.Character:FindFirstChild("HumanoidRootPart")
            if vRootPart and cmdlpRootPart then
               local distance = (vRootPart.Position - cmdlpRootPart.Position).magnitude
               if distance < 30 then
                  table.insert(vAges, v)
               end
            end
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   if args == "far" then
      local vAges = {}
      for _, v in pairs(tbl) do
         if v ~= cmdlp and v.Character and cmdlp.Character then
            local vRootPart = v.Character:FindFirstChild("HumanoidRootPart")
            local cmdlpRootPart = cmdlp.Character:FindFirstChild("HumanoidRootPart")
            if vRootPart and cmdlpRootPart then
               local distance = (vRootPart.Position - cmdlpRootPart.Position).magnitude
               if distance > 30 then
                  table.insert(vAges, v)
               end
            end
         end
      end
      return #vAges > 0 and vAges[math.random(1, #vAges)] or nil
   end

   for _, v in pairs(tbl) do
      if (v.Name:lower():find(args:lower()) or v.DisplayName:lower():find(args:lower())) and v ~= cmdlp then
         return v
      end
   end
end

getgenv().ConvertRGBToColor3 = function(r, g, b)
   if typeof(r) ~= "number" or typeof(g) ~= "number" or typeof(b) ~= "number" then return notify("Error", "ConvertRGBToColor3: r, g, b must be numbers", 5) end
   r = math.clamp(r, 0, 255)
   g = math.clamp(g, 0, 255)
   b = math.clamp(b, 0, 255)
   return Color3.new(r / 255, g / 255, b / 255)
end

local colors = {
   Color3.fromRGB(255, 255, 255),
   Color3.fromRGB(128, 128, 128),
   Color3.fromRGB(0, 0, 0),
   Color3.fromRGB(0, 0, 255),
   Color3.fromRGB(0, 255, 0),
   Color3.fromRGB(0, 255, 255),
   Color3.fromRGB(255, 165, 0),
   Color3.fromRGB(139, 69, 19),
   Color3.fromRGB(255, 255, 0),
   Color3.fromRGB(50, 205, 50),
   Color3.fromRGB(255, 0, 0),
   Color3.fromRGB(255, 155, 172),
   Color3.fromRGB(128, 0, 128),
}

local Jobs = {
   "None",
   "Artist",
   "Banker",
   "Basketball Player",
   "Bodybuilder",
   "Cashier",
   "Chef",
   "Construction",
   "Criminal",
   "Dancer",
   "Dj",
   "Doctor",
   "Driver",
   "EMT",
   "Filmer",
   "Firefighter",
   "Hacker",
   "Hair Stylist",
   "Hospital",
   "Inmate",
   "Janitor",
   "Mayor",
   "Mechanic",
   "Nurse",
   "Police",
   "Reporter",
   "Robber",
   "Sheriff",
   "Singer",
   "Soccer Player",
   "Soldier",
   "Student",
   "Teacher",
}

function fire_remote(remote, ...)
   if not remote or (not remote:IsA("RemoteEvent") and not remote:IsA("RemoteFunction")) then return notify("Error", "Provided method is not a RemoteEvent or RemoteFunction!", 5) end
   local args = {...}
   if #args == 1 and typeof(args[1]) == "table" then args = args[1] end

   if remote:IsA("RemoteEvent") then
      remote:FireServer(unpack(args))
   else
      return remote:InvokeServer(unpack(args))
   end
end

local function Get_Title_Color()
   local Player_Details_Billboard = Character:FindFirstChild("PlayerDetails") or Character:WaitForChild("PlayerDetails", 3)
   if not Player_Details_Billboard then return notify("Error", "PlayerDetails not found in Character (prob patched).", 5) end
   local Container = Player_Details_Billboard and Player_Details_Billboard:FindFirstChild("Container") or Player_Details_Billboard:WaitForChild("Container", 3)
   if not Container then return notify("Error", "Container not found in PlayerDetails (prob patched).", 5) end
   local Display_Name = Container and Container:FindFirstChild("DisplayName") or Container:WaitForChild("DisplayName", 3)
   if not Display_Name then return notify("Error", "DisplayName not found in Container (prob patched).", 5) end

   return Display_Name.TextColor3
end

local function Get_Bio_Color()
   local Player_Details_Billboard = Character:FindFirstChild("PlayerDetails") or Character:WaitForChild("PlayerDetails", 3)
   if not Player_Details_Billboard then return notify("Error", "PlayerDetails not found in Character (prob patched).", 5) end
   local Container = Player_Details_Billboard and Player_Details_Billboard:FindFirstChild("Container") or Player_Details_Billboard:WaitForChild("Container", 3)
   if not Container then return notify("Error", "Container not found in PlayerDetails (prob patched).", 5) end
   local Description = Container and Container:FindFirstChild("Description") or Container:WaitForChild("Description", 3)
   if not Description then return notify("Error", "Description not found in Container (prob patched).", 5) end

   return Description.TextColor3
end

function change_vehicle_color(color_input)
   Vehicle_Color:InvokeServer(color_input)
end

local function get_vehicle()
   for i, v in pairs(Vehicles:GetChildren()) do
      if v:GetAttribute("OwnerId") == LocalPlayer.UserId then
         return v
      end
   end

   return nil
end

function lock_vehicle(bool)
   if bool == true then
      Set_Vehicle_Locked:InvokeServer(true)
   else
      Set_Vehicle_Locked:InvokeServer(false)
   end
end

function name_tag(Text)
   local NameTag_Color = Get_Title_Color()

   Set_Name:InvokeServer(tostring(Text), NameTag_Color)
end

function bio_tag(Text)
   local BioTag_Color = Get_Bio_Color()

   Set_Description:InvokeServer(tostring(Text), BioTag_Color)
end

function rainbow_vehicle(boolean)
   if boolean == true then
      getgenv().Rainbow_Vehicle_FE = true
      while getgenv().Rainbow_Vehicle_FE == true do
      task.wait(0)
         for _, color in ipairs(colors) do
            change_vehicle_color(color)
            task.wait(0)
         end
      end
   else
      getgenv().Rainbow_Vehicle_FE = false
   end
end

function change_to_job(job)
   SetRole_RF:InvokeServer(tostring(job))
end
wait(0.1)
function all_jobs_spam(bool)
   if bool == true then
      getgenv().Job_Spamming = true
      while getgenv().Job_Spamming == true do
      task.wait()
         for _, job in ipairs(Jobs) do
            change_to_job(job)
            task.wait(0)
         end
      end
   elseif bool == false then
      getgenv().Job_Spamming = false
   else
      return notify("Error", "Please provide all arguments for this to work!", 5)
   end
end

function save_out(Name)
   local args = {
      "main"
   }
   game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Flux"):WaitForChild("Services"):WaitForChild("AvatarService"):WaitForChild("RF"):WaitForChild("CreateOutfit"):InvokeServer(unpack(args))
end

local function Is_Car_Locked()
   local Main_GUI = PlayerGui:FindFirstChild("Main") or PlayerGui:WaitForChild("Main", 3) or nil
   if not Main_GUI then return notify("Error", "Main GUI not found inside of PlayerGui!", 5) end
   local Screens_Frame = Main_GUI and Main_GUI:FindFirstChild("Screens") or Main_GUI and Main_GUI:WaitForChild("Screens", 3) or nil
   if not Screens_Frame then return notify("Error", "Screens Frame not found inside of Main GUI!", 5) end
   local HUD_Frame = Screens_Frame and Screens_Frame:FindFirstChild("HUD") or Screens_Frame and Screens_Frame:WaitForChild("HUD", 3) or nil
   if not HUD_Frame then return notify("Error", "HUD Frame not found inside of Screens Frame!", 5) end
   local Right_Frame = HUD_Frame and HUD_Frame:FindFirstChild("Right") or HUD_Frame and HUD_Frame:WaitForChild("Right", 3) or nil
   if not Right_Frame then return notify("Error", "Right Frame not found inside of HUD Frame!", 5) end
   local Phone_Canvas = Right_Frame and Right_Frame:FindFirstChild("Phone") or Right_Frame and Right_Frame:WaitForChild("Phone", 3) or nil
   if not Phone_Canvas then return notify("Error", "Phone Canvas not found inside of Right Frame!", 5) end
   local Container_Frame = Phone_Canvas and Phone_Canvas:FindFirstChild("Container") or Phone_Canvas and Phone_Canvas:WaitForChild("Container", 3) or nil
   if not Container_Frame then return notify("Error", "Container Frame not found inside of Phone Canvas!", 5) end
   local Menus_Frame = Container_Frame and Container_Frame:FindFirstChild("Menus") or Container_Frame and Container_Frame:WaitForChild("Menus", 3) or nil
   if not Menus_Frame then return notify("Error", "Menus Frame not found inside of Container Frame!", 5) end
   local Vehicles_Frame = Menus_Frame and Menus_Frame:FindFirstChild("Vehicles") or Menus_Frame and Menus_Frame:WaitForChild("Vehicles", 3) or nil
   if not Vehicles_Frame then return notify("Error", "Vehicles Frame not found inside of Menus Frame!", 5) end
   local LockVehicle_ImageButton = Vehicles_Frame and Vehicles_Frame:FindFirstChild("LockVehicle") or Vehicles_Frame and Vehicles_Frame:WaitForChild("LockVehicle", 3) or nil
   if not LockVehicle_ImageButton then return notify("Error", "LockVehicle ImageButton not found inside of Vehicles Frame!", 5) end
   local Emoji_TextLabel = LockVehicle_ImageButton and LockVehicle_ImageButton:FindFirstChild("Emoji") or LockVehicle_ImageButton and LockVehicle_ImageButton:WaitForChild("Emoji", 3) or nil

   if Emoji_TextLabel then
      if Emoji_TextLabel.Text == "🔒" then
         return "Locked"
      elseif Emoji_TextLabel.Text == "🔓" then
         return "Unlocked"
      else
         return "Unknown"
      end
   else
      return notify("Error", "Emoji TextLabel not found inside of Lock Vehicle ImageButton!", 5)
   end

   return nil
end

function rainbow_name_tag(state)
   if state == true then
      getgenv().Rainbow_Name_Tag_FE = true
      while getgenv().Rainbow_Name_Tag_FE == true do
         for _, color in ipairs(colors) do
            local random_word = words[math.random(1, #words)]
            local args = {
               tostring(random_word),
               color
            }

            Set_Name:InvokeServer(unpack(args))
            Set_Description:InvokeServer(unpack(args))
            task.wait(0)
         end
      end
   else
      getgenv().Rainbow_Name_Tag_FE = false
   end
end

function annoy_player(bool, Target)
   if bool == true then
      if not Request_Action_RF or not Request_Action_RF:IsA("RemoteFunction") then return g.notify("Error", "RequestActionRF does not exist or is not a RemoteFunction.", 3) end
      getgenv().Annoying_Player = true
      while getgenv().Annoying_Player == true do
      task.wait(0)
         Request_Action_RF:InvokeServer(Target, "Carry", {})
         task.wait(0)
         Request_Action_RF:InvokeServer(Target, "Shoulders", {})
         task.wait(0)
         Request_Action_RF:InvokeServer(Target, "Piggyback", {})
      end
   elseif bool == false then
      getgenv().Annoying_Player = false
   else
      return 
   end
end

function toggle_name_func(boolean)
   if boolean == true then
      Set_Name:InvokeServer("ADMIN", Color3.new(0, 0, 1))
      Set_Description:InvokeServer("ADMIN", Color3.new(0, 0, 1))
   elseif boolean == false then
      Set_Name:InvokeServer("", Color3.new(0, 0, 0))
      Set_Description:InvokeServer("", Color3.new(0, 0, 0))
   else
      return 
   end
end

function flashy_name(Toggle)
   if Toggle == true then
      getgenv().Flashing_Name_Title = true
      while getgenv().Flashing_Name_Title == true do
      task.wait(0)
         toggle_name_func(true)
         task.wait(0)
         toggle_name_func(false)
      end
   elseif Toggle == false then
      getgenv().Flashing_Name_Title = false
      wait(1.5)
      toggle_name_func(false)
   else
      return notify("Error", "Invalid argument(s) provided.", 5)
   end
end

local Flames_Library = getgenv().FlamesLibrary
local Local_Player = g.LocalPlayer or Players.LocalPlayer
g.anti_sit_enabled = g.anti_sit_enabled or false
g.anti_sit_cache = g.anti_sit_cache or {}
g.anti_sit_initialized = g.anti_sit_initialized or false
local function is_seat(object) return object and (object:IsA("Seat") or object:IsA("VehicleSeat")) end
local function get_sit_key(humanoid) return "AntiSit_Sit_" .. humanoid:GetDebugId() end
local function neutralizar_asiento(asiento)
	if not is_seat(asiento) then return end
	if g.anti_sit_cache[asiento] then return end
	g.anti_sit_cache[asiento] = true
	local character = g.Character or Local_Player.Character or g.get_char(LocalPlayer, 5)
	local humanoid = g.Humanoid or character and character:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.Sit then humanoid.Sit = false end
	asiento.Disabled = true
	asiento.CanTouch = false
	local weld = asiento:FindFirstChildOfClass("Weld")
	if weld then weld.Enabled = false end
	local no_collision_constraint = asiento:FindFirstChildOfClass("NoCollisionConstraint")
	if no_collision_constraint then no_collision_constraint.Enabled = false end
end

local function bind_humanoid_sit(humanoid)
	local key = get_sit_key(humanoid)
	if humanoid:GetAttribute("AntiSitBound") then return end
	humanoid:SetAttribute("AntiSitBound", true)
	humanoid:SetAttribute("AntiSitKey", key)
	Flames_Library.connect(key, humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
      if not g.anti_sit_enabled then return end
      if humanoid.Sit then
         humanoid.Sit = false
      end
   end))
end

local function setup_character_hook()
	if g._anti_sit_character_hooked then return end
	g._anti_sit_character_hooked = true
	local function handle_character(character)
		local humanoid = character:WaitForChild("Humanoid", 5)
		if humanoid then bind_humanoid_sit(humanoid) end
	end

	if LocalPlayer.Character then handle_character(g.Character or LocalPlayer.Character) end
	Flames_Library.connect("AntiSit_CharacterAdded", LocalPlayer.CharacterAdded:Connect(function(character)
		if not g.anti_sit_enabled then return end
		handle_character(character)
	end))
end

local function init_anti_sit()
	if g.anti_sit_initialized then return end
	g.anti_sit_initialized = true
	for _, object in ipairs(Workspace:GetDescendants()) do neutralizar_asiento(object) end
	Flames_Library.connect("AntiSit_DescendantAdded", Workspace.DescendantAdded:Connect(function(object)
		if not g.anti_sit_enabled then return end
		neutralizar_asiento(object)
	end))
	setup_character_hook()
end

local function unbind_humanoid_sit(humanoid)
	local key = humanoid:GetAttribute("AntiSitKey")
	if key then Flames_Library.disconnect(key) end
	humanoid:SetAttribute("AntiSitBound", nil)
	humanoid:SetAttribute("AntiSitKey", nil)
end

g.anti_sit_func = g.anti_sit_func or function(state)
	init_anti_sit()
	if state == true then
		if g.anti_sit_enabled then return end
		g.anti_sit_enabled = true
		g.notify("Success", "Flames Hub | Anti Sit is now enabled.", 3)
		for _, object in ipairs(Workspace:GetDescendants()) do
			if is_seat(object) then
				neutralizar_asiento(object)
			end
		end
		Flames_Library.connect("AntiSit_Heartbeat_Conn", RunService.Heartbeat:Connect(function(object)
			if not g.anti_sit_enabled then return end
			local human = g.Humanoid or g.Character:FindFirstChildWhichIsA("Humanoid") or g.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
			if human then human.Sit = false end
			pcall(function() g.Humanoid.Sit = false end)
		end))
	elseif state == false then
		if not g.anti_sit_enabled then return end
		g.anti_sit_enabled = false
		for seat in pairs(g.anti_sit_cache) do
			pcall(function()
				seat.Disabled = false
				seat.CanTouch = true
			end)
		end

		g.notify("Success", "Flames Hub | Anti Sit is now disabled.", 3)
		FlamesLibrary.disconnect("AntiSit_Heartbeat_Conn")
		FlamesLibrary.disconnect("AntiSit_DescendantAdded")
		FlamesLibrary.disconnect("AntiSit_CharacterAdded")
		table.clear(g.anti_sit_cache)
		local character = g.Character or Local_Player.Character or g.get_char(LocalPlayer or game.Players.LocalPlayer, 10)
		if character then for _, obj in ipairs(character:GetDescendants()) do if obj:IsA("Humanoid") then unbind_humanoid_sit(obj) end end end
	else
		return 
	end
end

function change_skin_tone(color) Set_Body_Colors:InvokeServer({ "HeadColor","TorsoColor","LeftArmColor","RightLegColor","RightArmColor","LeftLegColor" },color) end
local function decodeHTMLEntities(str) return str:gsub("&gt;", ">"):gsub("&lt;", "<"):gsub("&amp;", "&"):gsub("&quot;", '"'):gsub("&#39;", "'") end
wait(0.25)
function CreateCreditsLabel()
   if getgenv().CreditsLabelGui then getgenv().CreditsLabelGui:Destroy() end
   wait(0.25)
   local credits_gui = Instance.new("ScreenGui")
   credits_gui.Name = "PrefixCreditsGui_LifeTogether"
   credits_gui.ResetOnSpawn = false
   credits_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
   credits_gui.Parent = g.CoreGui

   local label = Instance.new("TextLabel")
   label.Name = "CreditsLabel"
   label.AnchorPoint = Vector2.new(0.5, 1)
   label.Position = UDim2.new(0.5, 0, 1, -10)
   label.Size = UDim2.new(0.6, 0, 0, 28)
   label.BackgroundColor3 = Color3.fromRGB(0, 172, 175)
   label.TextColor3 = Color3.fromRGB(0, 0, 0)
   label.Text = tostring(Script_Version).." | https://discord.gg/MTYKxQfpNJ"
   label.Font = Enum.Font.GothamBold
   label.TextScaled = true
   label.RichText = false
   label.TextStrokeTransparency = 1
   label.BackgroundTransparency = 0
   label.ZIndex = 10
   label.Parent = credits_gui

   local corner = Instance.new("UICorner")
   corner.CornerRadius = UDim.new(0, 10)
   corner.Parent = label
   getgenv().CreditsLabelGui = credits_gui
   getgenv().CreditsLabelText = label
end
wait(0.2)
CreateCreditsLabel()
local Old_Skintone = getgenv().Character:FindFirstChildOfClass("BodyColors").TorsoColor3
wait(0.2)
function rainbow_skin(boolean)
   if boolean == true then
      getgenv().Rainbow_FE_Skin = true
      while getgenv().Rainbow_FE_Skin == true do
      task.wait(0)
         for _, color in ipairs(colors) do
            change_skin_tone(color)
            task.wait(0)
         end
      end
   elseif boolean == false then
      getgenv().Rainbow_FE_Skin = false
      wait(1)
      if getgenv().Rainbow_FE_Skin == false then
         change_skin_tone(Old_Skintone)
      else
         repeat task.wait() until getgenv().Rainbow_FE_Skin == false
         if getgenv().Rainbow_FE_Skin == false then change_skin_tone(Old_Skintone) end
      end
   end
end

function modify_vehicle_setting(Vehicle, setting, value)
   local Vehicle_Config = Vehicle and Vehicle:FindFirstChild("Settings") or Vehicle and Vehicle:WaitForChild("Settings", 3) or Vehicle and Vehicle:FindFirstChildOfClass("Configuration") or nil
   if not Vehicle_Config then return notify("Error", "Vehicle Configuration/Settings not found!", 5) end
   local Setting_To_Modify = Vehicle_Config and Vehicle_Config:FindFirstChild(setting) or nil
   if not Setting_To_Modify then return notify("Error", "Failed to find correct setting to modify!", 5) end
   local Converted_Value = tonumber(value)
   if Setting_To_Modify.ClassName == "NumberValue" then Setting_To_Modify.Value = Converted_Value else return notify("Error", "Value is not a number!", 5) end
end

g.FlyEnabled = g.FlyEnabled or false
g.FlySpeed = g.FlySpeed or 1
g.QEfly = (g.QEfly == nil) and true or g.QEfly
g.flyKeyDown = g.flyKeyDown or nil
g.flyKeyUp = g.flyKeyUp or nil
g.mobileFlyConn = g.mobileFlyConn or nil
g.pcFlyConn = g.pcFlyConn or nil
local UIS = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
g.EnableFly = g.EnableFly or function(state, speed, vfly)
   if g.FlyEnabled then
      if speed and tonumber(speed) then
         g.FlySpeed = tonumber(speed)
         return notify("Success", "Fly speed updated to: " .. tostring(g.FlySpeed), 4)
      end
      return notify("Warning", "Fly is already enabled! Provide a speed to update it.", 5)
   end

   local plr = g.LocalPlayer or g.Players.LocalPlayer or game.Players.LocalPlayer
   local char = g.get_char(plr) or g.Character or plr.Character
   local hrp = g.HumanoidRootPart or char:FindFirstChild("HumanoidRootPart") or get_root(plr)
   local hum = g.Humanoid or char:FindFirstChildOfClass("Humanoid") or get_human(plr)
   local cam = workspace.CurrentCamera
   if not hrp or not hum then return g.notify("Error", "Character is not ready or Humanoid doesn't exist.", 6) end
   if not state then
      g.DisableFly()
      return
   end

   if speed and tonumber(speed) then g.FlySpeed = tonumber(speed) end
   g.FlyEnabled = true
   if g.flyKeyDown then g.flyKeyDown:Disconnect() g.flyKeyDown = nil end
   if g.flyKeyUp then g.flyKeyUp:Disconnect() g.flyKeyUp = nil end
   if g.pcFlyConn then g.pcFlyConn:Disconnect() g.pcFlyConn = nil end
   if g.mobileFlyConn then g.mobileFlyConn:Disconnect() g.mobileFlyConn = nil end
   if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
   if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end

   local BG = Instance.new("BodyGyro")
   BG.P = 9e4
   BG.MaxTorque = Vector3.new(9e9,9e9,9e9)
   BG.CFrame = hrp.CFrame
   BG.Name = "FlyGyro"
   BG.Parent = hrp

   local BV = Instance.new("BodyVelocity")
   BV.MaxForce = Vector3.new(9e9,9e9,9e9)
   BV.Velocity = Vector3.zero
   BV.Name = "FlyVelocity"
   BV.Parent = hrp

   hum.PlatformStand = true
   if not isMobile then
      local CONTROL = {F=0,B=0,L=0,R=0,Q=0,E=0}
      g.pcFlyConn = RunService.RenderStepped:Connect(function(dt)
         if not g.FlyEnabled then return end
         if not cam or not hrp or not hum then return end
         local speedNow = ((vfly and (g.VehicleFlySpeed or g.FlySpeed)) or g.FlySpeed) * 50
         local look = cam.CFrame
         local move_vec = ((look.LookVector * (CONTROL.F + CONTROL.B)) + ((look * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.Q + CONTROL.E) * 0.2, 0).p) - look.p))
         if move_vec.Magnitude > 0 then
            move_vec = move_vec.Unit
            BV.Velocity = move_vec * speedNow
         else
            BV.Velocity = BV.Velocity * 0.9
         end

         BG.CFrame = cam.CFrame
      end)

      g.flyKeyDown = UIS.InputBegan:Connect(function(input, gp)
         if gp then return end
         if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 1 end
         if input.KeyCode == Enum.KeyCode.S then CONTROL.B = -1 end
         if input.KeyCode == Enum.KeyCode.A then CONTROL.L = -1 end
         if input.KeyCode == Enum.KeyCode.D then CONTROL.R = 1 end
         if g.QEfly then
            if input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 1 end
            if input.KeyCode == Enum.KeyCode.Q then CONTROL.E = -1 end
         end
         pcall(function() cam.CameraType = Enum.CameraType.Track end)
      end)

      g.flyKeyUp = UIS.InputEnded:Connect(function(input)
         if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0 end
         if input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0 end
         if input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0 end
         if input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0 end
         if input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0 end
         if input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0 end
      end)

      g.notify("Success", "Fly-1 is now enabled | with speed: "..tostring(g.FlySpeed), 5)
      return
   end

   local ok, control_module = pcall(function()
      return require(plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
   end)
   if not ok or not control_module then
      notify("Warning", "ControlModule unavailable; using simple touch fallback.", 5)
      g.mobileFlyConn = RunService.RenderStepped:Connect(function()
         if not g.FlyEnabled then return end
         BG.CFrame = cam.CFrame
         BV.Velocity = Vector3.zero
      end)
      return
   end

   g.mobileFlyConn = RunService.RenderStepped:Connect(function()
      if not g.FlyEnabled then return end
      if not hrp or not hum or not cam then return end
      BG.CFrame = cam.CFrame
      local direction = control_module:GetMoveVector()
      local speed_scaled = ((vfly and (g.VehicleFlySpeed or g.FlySpeed)) or g.FlySpeed) * 50
      if direction.Magnitude > 0 then
         BV.Velocity = (cam.CFrame.LookVector * -direction.Z + cam.CFrame.RightVector * direction.X) * speed_scaled
      else
         BV.Velocity = Vector3.zero
      end
   end)

   notify("Success", "Fly-1 is now enabled | with speed: "..tostring(g.FlySpeed), 3)
end

g.DisableFly = g.DisableFly or function()
   if not g.FlyEnabled then return notify("Warning", "Flames Hub | Fly-1 is not enabled!", 3) end
   g.FlyEnabled = false
   if g.flyKeyDown then g.flyKeyDown:Disconnect() g.flyKeyDown = nil end
   if g.flyKeyUp then g.flyKeyUp:Disconnect() g.flyKeyUp = nil end
   if g.pcFlyConn then g.pcFlyConn:Disconnect() g.pcFlyConn = nil end
   if g.mobileFlyConn then g.mobileFlyConn:Disconnect() g.mobileFlyConn = nil end
   local plr = g.LocalPlayer
   local char = g.Character or plr.Character or g.get_char(plr, 3)
   local hrp = g.HumanoidRootPart or char:FindFirstChild("HumanoidRootPart") or g.get_root(plr, 3)
   local hum = g.Humanoid or char:FindFirstChildWhichIsA("Humanoid") or g.get_human(plr, 3)
   if hrp and hrp.Parent and hrp:IsDescendantOf(game) then if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end end
   if hum then hum.PlatformStand = false end
   g.notify("Success", "Flames Hub | Fly-1 is now disabled.", 3)
end

function toggle_noclip(state)
   if state == true then
      if getgenv().Noclip_Enabled then return g.notify("Error", "Noclip is already enabled!", 3) end
      getgenv().Noclip_Enabled = true
      getgenv()._noclipModifiedParts = {}
      local function NoclipLoop()
         if getgenv().Character then
            for _, part in ipairs(getgenv().Character:GetDescendants()) do
               if part:IsA("BasePart") and part.CanCollide then
                  part.CanCollide = false
                  if getgenv()._noclipModifiedParts then getgenv()._noclipModifiedParts[part] = true end
               end
            end
         end
      end
      getgenv().Noclip_Connection = RunService.Stepped:Connect(NoclipLoop)
      g.notify("Success", "Noclip has been enabled.", 5)
   else
      if not getgenv().Noclip_Enabled then return g.notify("Error", "Flames Hub | Noclip is not enabled!", 5) end
      if getgenv().Noclip_Connection then getgenv().Noclip_Connection:Disconnect() getgenv().Noclip_Connection = nil end
      getgenv().Noclip_Enabled = false
      if getgenv()._noclipModifiedParts then
         for part in pairs(getgenv()._noclipModifiedParts) do if part and part:IsA("BasePart") then part.CanCollide = true end end
         getgenv()._noclipModifiedParts = nil
      end
      g.notify("Success", "Disabled Noclip successfully.", 5)
   end
end

function toggle_antifling(state)
   if state == true then
      if getgenv().antiFlingEnabled then return g.notify("Error", "Anti Fling is already enabled!", 3) end
      getgenv().antiFlingEnabled = true
      getgenv().antiKnockbackEnabled = true
      local function Clean_Up_Forces()
         local hrp = HumanoidRootPart
         if not hrp then return end
         for _, obj in ipairs(hrp:GetChildren()) do if obj:IsA("BodyMover") or obj:IsA("VectorForce") or obj:IsA("Torque") or obj:IsA("LinearVelocity") then obj:Destroy() end end
      end

      local function Clean_Up_Forces_2()
         local char = getgenv().Character
         if not char then return end
         for _, obj in ipairs(char:GetChildren()) do if obj:IsA("BodyMover") or obj:IsA("VectorForce") or obj:IsA("Torque") or obj:IsA("LinearVelocity") then obj:Destroy() end end
      end

      local function On_Heartbeat()
         if not (getgenv().antiKnockbackEnabled or getgenv().antiFlingEnabled) then return end
         local hrp = HumanoidRootPart
         local humanoid = Humanoid
         if not hrp or not humanoid then return end
         local Max_Speed = 45
         local Max_Angular_Speed = 60
         if hrp.AssemblyLinearVelocity.Magnitude > Max_Speed then hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity.Unit * Max_Speed end
         if hrp.AssemblyAngularVelocity.Magnitude > Max_Angular_Speed then hrp.AssemblyAngularVelocity = Vector3.zero end
         if humanoid.PlatformStand then humanoid.PlatformStand = false end
         Clean_Up_Forces()
         Clean_Up_Forces_2()
      end

      if getgenv().anti_knockback_connection then getgenv().anti_knockback_connection:Disconnect() getgenv().anti_knockback_connection = nil end
      getgenv().anti_knockback_connection = RunService.Heartbeat:Connect(On_Heartbeat)
      g.notify("Success", "Flames Hub | Anti-Fling is now active.", 3)
   else
      getgenv().antiFlingEnabled = false
      getgenv().antiKnockbackEnabled = false
      if getgenv().anti_knockback_connection then getgenv().anti_knockback_connection:Disconnect() getgenv().anti_knockback_connection = nil end
      g.notify("Success", "Flames Hub | Anti-Fling is now in-active.", 3)
   end
end

g.Enabled_Flying = g.Enabled_Flying or false
g.Fly2Speed = g.Fly2Speed or 5
g.Fly2Control = nil
g.fly2InputBegan = nil
g.fly2InputEnded = nil
g.fly2Heartbeat = nil
g.fly2MobileConn = nil
g.EnableFly2 = g.EnableFly2 or function(speed)
   if g.Enabled_Flying then return notify("Warning", "Flames Hub | Rainbow Fly is already enabled.", 5) end
   local UIS = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
   local plr = g.LocalPlayer or game.Players.LocalPlayer
   local char = g.Character or plr.Character or get_char(plr, 10)
   local HRP = g.HumanoidRootPart or char and char:FindFirstChild("HumanoidRootPart") or get_root(plr, 5)
   local Humanoid = g.Humanoid or char and char:FindFirstChildOfClass("Humanoid") or get_human(plr, 5)
   local Workspace = g.Workspace or cloneref and cloneref(game:GetService("Workspace")) or game:GetService("Workspace")
   local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
   local Debris = g.Debris or cloneref and cloneref(game:GetService("Debris")) or game:GetService("Debris")
   if not HRP or not Humanoid then return notify("Error", "Character is not ready or Humanoid is missing.", 5) end
   g.Enabled_Flying = true
   g.Fly2Speed = tonumber(speed) or 10
   g.Fly2Control = {F=0,B=0,L=0,R=0}
   local flyY, lastPos = 0, nil
   local gyro = Instance.new("BodyGyro")
   gyro.P = 9e4
   gyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
   gyro.CFrame = HRP.CFrame
   gyro.Name = "Fly2Gyro"
   gyro.Parent = HRP

   local vel = Instance.new("BodyVelocity")
   vel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
   vel.Velocity = Vector3.zero
   vel.Name = "Fly2Velocity"
   vel.Parent = HRP

   Humanoid.PlatformStand = true
   if not isMobile then
      if g.fly2InputBegan then g.fly2InputBegan:Disconnect() end
      if g.fly2InputEnded then g.fly2InputEnded:Disconnect() end
      if g.fly2Heartbeat then g.fly2Heartbeat:Disconnect() end

      g.fly2InputBegan = UIS.InputBegan:Connect(function(input, gp)
         if gp then return end
         local s = g.Fly2Speed
         if input.KeyCode == Enum.KeyCode.W then g.Fly2Control.F = s end
         if input.KeyCode == Enum.KeyCode.S then g.Fly2Control.B = -s end
         if input.KeyCode == Enum.KeyCode.A then g.Fly2Control.L = -s end
         if input.KeyCode == Enum.KeyCode.D then g.Fly2Control.R = s end
         if input.KeyCode == Enum.KeyCode.Space then flyY = s end
         if input.KeyCode == Enum.KeyCode.LeftShift then flyY = -s end
      end)

      g.fly2InputEnded = UIS.InputEnded:Connect(function(input)
         if input.KeyCode == Enum.KeyCode.W then g.Fly2Control.F = 0 end
         if input.KeyCode == Enum.KeyCode.S then g.Fly2Control.B = 0 end
         if input.KeyCode == Enum.KeyCode.A then g.Fly2Control.L = 0 end
         if input.KeyCode == Enum.KeyCode.D then g.Fly2Control.R = 0 end
         if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then flyY = 0 end
      end)

      g.fly2Heartbeat = RunService.RenderStepped:Connect(function()
         if not g.Enabled_Flying then return end
         local C, cam, SPEED = g.Fly2Control, Workspace.CurrentCamera, g.Fly2Speed * 50
         if C.F~=0 or C.B~=0 or C.L~=0 or C.R~=0 or flyY~=0 then
            local moveVec = ((cam.CFrame.LookVector * (C.F + C.B)) + ((cam.CFrame * CFrame.new(C.L + C.R, flyY * 0.5, 0).p) - cam.CFrame.p))
            if moveVec.Magnitude > 0 then vel.Velocity = moveVec.Unit * SPEED end
         else
            vel.Velocity = vel.Velocity * 0.9
         end

         gyro.CFrame = cam.CFrame

         local pos = HRP.Position
         if not lastPos or (pos - lastPos).Magnitude > 1 then
            local part = Instance.new("Part")
            part.Anchored = true
            part.CanCollide = false
            part.Material = Enum.Material.Neon
            part.Size = Vector3.new(1,1,(pos - (lastPos or pos)).Magnitude + 2)
            part.CFrame = CFrame.new((lastPos or pos) + ((pos - (lastPos or pos)) / 2), pos)
            part.Color = colors[math.random(1, #colors)]
            part.Parent = Workspace
            Debris:AddItem(part, 1)
            lastPos = pos
         end
      end)

      g.notify("Success", "Fly-2 is now enabled | with speed: "..tostring(g.Fly2Speed), 5)
      return
   end

   local controlModule
   local ok, result = pcall(function()
      return require(plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
   end)
   if ok then controlModule = result end
   g.fly2MobileConn = RunService.RenderStepped:Connect(function()
      if not g.Enabled_Flying then return end
      local cam = Workspace.CurrentCamera
      local s = g.Fly2Speed * 50
      local move = controlModule and controlModule:GetMoveVector() or Vector3.zero
      if move.Magnitude > 0 then
         vel.Velocity = (cam.CFrame.LookVector * -move.Z + cam.CFrame.RightVector * move.X) * s
      else
         vel.Velocity = Vector3.zero
      end

      gyro.CFrame = cam.CFrame
      local pos = HRP.Position
      if not lastPos or (pos - lastPos).Magnitude > 1 then
         local part = Instance.new("Part")
         part.Anchored = true
         part.CanCollide = false
         part.Material = Enum.Material.Neon
         part.Size = Vector3.new(1,1,(pos - (lastPos or pos)).Magnitude + 2)
         part.CFrame = CFrame.new((lastPos or pos) + ((pos - (lastPos or pos)) / 2), pos)
         part.Color = colors[math.random(1, #colors)]
         part.Parent = Workspace
         Debris:AddItem(part, 1)
         lastPos = pos
      end
   end)

   notify("Success", "Fly-2 is now enabled | with speed: "..tostring(g.Fly2Speed), 5)
end

g.DisableFly2 = g.DisableFly2 or function()
   g.Enabled_Flying = false
   if g.fly2InputBegan then g.fly2InputBegan:Disconnect() end
   if g.fly2InputEnded then g.fly2InputEnded:Disconnect() end
   if g.fly2Heartbeat then g.fly2Heartbeat:Disconnect() end
   if g.fly2MobileConn then g.fly2MobileConn:Disconnect() end
   local HRP = g.HumanoidRootPart or g.Character:FindFirstChild("HumanoidRootPart") or get_root(g.LocalPlayer, 10)
   local Humanoid = g.Humanoid or g.Character:FindFirstChildOfClass("Humanoid") or get_human(g.LocalPlayer, 10)
   if HRP then for _, v in ipairs(HRP:GetChildren()) do if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end end end
   if Humanoid then Humanoid.PlatformStand = false end
   g.notify("Success", "Fly-2 is now disabled.", 5)
end

local Atlas = loadstring(game:HttpGet("https://gitlab.com/greatest-group/experience_coding/-/raw/main/UIs/Atlas.lua?ref_type=heads", true))()
local UI = Atlas.new({
   Name = "Flames Hub | Dreamville RP",
   ConfigFolder = "FlamesHub_Dreamville_RP_Menu_Configuration",
   Color = Color3.fromRGB(21, 103, 251),
   Credit = "Flames Hub",
   Bind = "RightShift",
})
wait(0.25)
g.create_ui_element = g.create_ui_element or function(element_type, parent, config, global_name, flag)
   local creators = {
      Tab         = function() return parent:CreateTab(config) end,
      Section     = function() return parent:CreateSection(config) end,
      Toggle      = function() return parent:CreateToggle(config, flag) end,
      Slider      = function() return parent:CreateSlider(config, flag) end,
      Button      = function() return parent:CreateButton(config, flag) end,
      ColorPicker = function() return parent:CreateColorPicker(config, flag) end,
      Input       = function() return parent:CreateTextBox(config, flag) end,
      Dropdown    = function() return parent:CreateDropdown(config, flag) end,
      Label       = function() return parent:CreateLabel(config, flag) end,
   }

   local creator = creators[element_type]
   if not creator then return g.notify("Error", "Unknown element type: " .. tostring(element_type), 3) end
   local element
   local done = false
   task.defer(function() element = creator() done = true end)
   while not done do task.wait() end
   if global_name then getgenv()[global_name] = element end
   return element
end
wait(0.25)
getgenv().notify("Success", "Now loading UI elements...", 5)
local Home_Page = UI:CreatePage("Main")
local Home_Section = Home_Page:CreateSection("Main")
local LocalPlayer_Section = Home_Page:CreateSection("LocalPlayer")
local Vehicle_Section = Home_Page:CreateSection("Vehicle")
local Players_Section = Home_Page:CreateSection("Players")
local Extras_Section = Home_Page:CreateSection("Extras")
wait(0.25)
g.create_ui_element("Toggle", Home_Section, {
Name = "RGB Vehicle (FE)",
Default = getgenv().Rainbow_Vehicle_FE or false,
Flag = "RGB_Vehicle_Toggle",
Callback = function(state)
   rainbow_vehicle(state)
end}, "RGB_Vehicle_Toggle")

g.create_ui_element("Toggle", Home_Section, {
Name = "RGB Skin (FE)",
Default = getgenv().Rainbow_FE_Skin or false,
Flag = "RGB_Skin_Toggle",
Callback = function(state)
   rainbow_skin(state)
end}, "RGB_Skin_Toggle")

g.create_ui_element("Toggle", Home_Section, {
Name = "Rainbow Name/Bio (FE)",
Default = getgenv().Rainbow_Name_Tag_FE or false,
Flag = "Rainbow_Name_Tag_Toggle",
Callback = function(state)
   rainbow_name_tag(state)
end}, "Rainbow_Name_Tag_Toggle")

g.create_ui_element("Toggle", Home_Section, {
Name = "Flash Name/Bio (FE)",
Default = getgenv().Flashing_Name_Title or false,
Flag = "Flash_Name_Toggle",
Callback = function(state)
   flashy_name(state)
end}, "Flash_Name_Toggle")

g.create_ui_element("Toggle", Home_Section, {
Name = "Job Spammer (FE)",
Default = getgenv().Job_Spamming or false,
Flag = "All_Jobs_Toggle",
Callback = function(state)
   all_jobs_spam(state)
end}, "All_Jobs_Toggle")

g.create_ui_element("Button", Home_Section, {
Name = "Mini-Games GUI",
Callback = function()
   g.open_minigame_menu()
end})

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Fly (FE)",
Default = getgenv().FlyEnabled or false,
Flag = "Fly_Toggle",
Callback = function(state)
   if state == true then
      local fly_speed = getgenv().Fly_Speed_Slider and getgenv().Fly_Speed_Slider.Value or 75
      EnableFly(fly_speed)
   else
      DisableFly()
   end
end}, "Fly_Toggle")

g.create_ui_element("Slider", LocalPlayer_Section, {
Name = "Fly Speed",
Min = 1,
Max = 100,
Default = getgenv().FlySpeed or 5,
Flag = "Fly_Speed_Slider",
Callback = function(value)
   if getgenv().FlyEnabled then getgenv().FlySpeed = value end
end}, "Fly_Speed_Slider")

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Rainbow Fly",
Default = getgenv().Enabled_Flying or false,
Flag = "Rainbow_Fly_Toggle",
Callback = function(state)
   if state == true then
      local fly_speed = getgenv().Rainbow_Fly_Speed_Slider and getgenv().Rainbow_Fly_Speed_Slider.Value or 10
      g.EnableFly2(fly_speed)
   else
      g.DisableFly2()
   end
end}, "Rainbow_Fly_Toggle")

g.create_ui_element("Slider", LocalPlayer_Section, {
Name = "Rainbow Fly Speed",
Min = 1,
Max = 100,
Default = getgenv().Fly2Speed or 5,
Flag = "Rainbow_Fly_Speed_Slider",
Callback = function(value)
   if getgenv().Enabled_Flying then getgenv().Fly2Speed = value end
end}, "Rainbow_Fly_Speed_Slider")

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Noclip (FE)",
Default = getgenv().Noclip_Enabled or false,
Flag = "Noclip_Toggle",
Callback = function(state)
   toggle_noclip(state)
end}, "Noclip_Toggle")

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Anti-Sit (may break) (FE)",
Default = getgenv().anti_sit_enabled or false,
Flag = "Anti_Sit_Toggle",
Callback = function(state)
   g.anti_sit_func(state)
end}, "Anti_Sit_Toggle")

g.create_ui_element("Toggle", Vehicle_Section, {
Name = "Lock Vehicle (FE)",
Default = false,
Flag = "Lock_Car_Toggle",
Callback = function(state)
   local Current_Car = get_vehicle()
   if not Current_Car then return g.notify("Error", "You do not have a vehicle spawned!", 5) end
   lock_vehicle(state)
end}, "Lock_Car_Toggle")

g.create_ui_element("Input", LocalPlayer_Section, {
Name = "Set RP Name (FE)",
PlaceholderText = "Enter new name",
Flag = "RP_Name_Input",
Callback = function(text)
   if text == "" then return end
   local max_len = 19
   if #text > max_len and writefile then
      g.notify("Info", "Your roleplay Name exceeds 19 characters, we're saving it for you, it'll be automatically set back once you reload the script.", 15)
      writefile("Dreamville_RP_Name_Text.txt", text)
   end
   name_tag(text)
end}, "RP_Name_Input")

g.create_ui_element("Input", LocalPlayer_Section, {
Name = "Set RP Bio (FE)",
PlaceholderText = "Enter new bio",
Flag = "RP_Bio_Input",
Callback = function(text)
   if text == "" then return end
   local max_len = 19
   if #text > max_len and writefile then
      g.notify("Info", "Your roleplay Bio exceeds 19 characters, we're saving it for you, it'll be automatically set back once you reload the script.", 15)
      writefile("Dreamville_RP_Bio_Text.txt", text)
   end
   bio_tag(text)
end}, "RP_Bio_Input")

g.create_ui_element("Button", Vehicle_Section, {
Name = "Bring Car (FE)",
Callback = function()
   local Vehicle = get_vehicle()
   if not Vehicle then return g.notify("Error", "You do not have a vehicle spawned!", 5) end
   local Old_CF_BringCar = getgenv().Character:FindFirstChild("HumanoidRootPart").CFrame
   local seat = Vehicle:FindFirstChild("VehicleSeat")
   if seat and getgenv().Humanoid then
      getgenv().Character:PivotTo(seat.CFrame)
      task.wait(0.2)
      seat:Sit(getgenv().Humanoid)
   end
   wait(0.1)
   Vehicle:PivotTo(Old_CF_BringCar * CFrame.new(0, 10, 0))
   g.notify("Success", "Brung car to player.", 5)
end}, "Bring_Car_Button")

g.create_ui_element("Button", Vehicle_Section, {
Name = "Goto Car (FE)",
Callback = function()
   local Vehicle = get_vehicle()
   if not Vehicle then return g.notify("Error", "You do not have a vehicle spawned!", 5) end
   if getgenv().Character and getgenv().Character:FindFirstChild("HumanoidRootPart") then getgenv().Character:PivotTo(Vehicle:GetPivot() * CFrame.new(0, 5, 0)) end
end}, "Goto_Car_Button")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Set Acceleration (FE)",
Min = 0,
Max = 100,
Default = 20,
Flag = "Acceleration_Slider",
Callback = function(value)
   local Vehicle = get_vehicle()
   if not Vehicle then return g.notify("Error", "You do not have a vehicle spawned!", 5) end
   modify_vehicle_setting(Vehicle, "Acceleration", value)
end}, "Acceleration_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Set Nitro Acceleration  (FE)",
Min = 0,
Max = 100,
Default = 20,
Flag = "Nitro_Accel_Slider",
Callback = function(value)
   local Vehicle = get_vehicle()
   if not Vehicle then return g.notify("Error", "You do not have a vehicle spawned!", 5) end
   modify_vehicle_setting(Vehicle, "NitroAcceleration", value)
end}, "Nitro_Accel_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Set Nitro Recharge Time (FE)",
Min = 0,
Max = 60,
Default = 5,
Flag = "Nitro_Charge_Slider",
Callback = function(value)
   local Vehicle = get_vehicle()
   if not Vehicle then return g.notify("Error", "You do not have a vehicle spawned!", 5) end
   modify_vehicle_setting(Vehicle, "NitroRechargeTime", value)
end}, "Nitro_Charge_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Set Nitro Amount (FE)",
Min = 0,
Max = 100,
Default = 100,
Flag = "Nitro_Amount_Slider",
Callback = function(value)
   local Vehicle = get_vehicle()
   if not Vehicle then return g.notify("Error", "You do not have a vehicle spawned!", 5) end
   modify_vehicle_setting(Vehicle, "NitroTime", value)
end}, "Nitro_Amount_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Set Braking Setting (FE)",
Min = 0,
Max = 20,
Default = 2,
Flag = "Braking_Slider",
Callback = function(value)
   local Vehicle = get_vehicle()
   if not Vehicle then return g.notify("Error", "You do not have a vehicle spawned!", 5) end
   modify_vehicle_setting(Vehicle, "Braking", value)
end}, "Braking_Slider")

if getgenv().Dropdown_For_Target_Players_Refresher_Conn then
   pcall(function() task.cancel(getgenv().Dropdown_For_Target_Players_Refresher_Conn) end)
   getgenv().Dropdown_For_Target_Players_Refresher_Conn = nil
end
wait(0.5)
getgenv().Target_Player_Dropdown = g.create_ui_element("Dropdown", Players_Section, {
Name = "Target Player",
Options = (function()
   local names = {}
   for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer then table.insert(names, plr.Name) end end
   return names
end)(),
DefaultItemSelected = getgenv().Atlas_Selected_Target or "None",
ItemSelecting = true,
Flag = "Target_Player_Dropdown",
Callback = function(selected)
   getgenv().Atlas_Selected_Target = selected
   g.notify("Success", "Selected player: "..tostring(selected), 1)
end}, "Target_Player_Dropdown")
wait(0.5)
getgenv().Dropdown_For_Target_Players_Refresher_Conn = task.spawn(function()
   while true do
      wait(3)
      if getgenv().Target_Player_Dropdown then
         local names = {}
         for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer then table.insert(names, plr.Name) end end
         getgenv().Target_Player_Dropdown:Update(names)
      end
   end
end)

g.create_ui_element("Button", Players_Section, {
Name = "Goto Player",
Callback = function()
   local target = findplr(getgenv().Atlas_Selected_Target or "")
   if not target then return g.notify("Error", "Target player does not exist!", 5) end
   local Target_Char = target.Character or target.CharacterAdded:Wait()
   local Char_Pos = Target_Char:GetPivot() * CFrame.new(0, 5, 0)
   if Target_Char and getgenv().Character and Target_Char:FindFirstChild("HumanoidRootPart") then
      if Humanoid.Sit then
         Humanoid:ChangeState(3)
         wait(0.2)
      end
      Character:PivotTo(Char_Pos)
      g.notify("Success", "Teleported to player: " .. tostring(target), 5)
   end
end}, "Goto_Button")

g.create_ui_element("Toggle", Players_Section, {
Name = "View Player",
Default = getgenv().Viewing_A_Player or false,
Flag = "ViewPlayerToggleTargetUI",
Callback = function(state)
   local Camera = workspace.CurrentCamera
   if state == true then
      if getgenv().Viewing_A_Player then return g.notify("Error", "Your already viewing someone.", 5) end
      local target = findplr(getgenv().Atlas_Selected_Target or "")
      if not target then return g.notify("Error", "Target was not found or does not exist!", 5) end
      local Target_Char = target.Character or target.CharacterAdded:Wait()
      if Target_Char and Target_Char:FindFirstChildOfClass("Humanoid") then
         getgenv().Viewing_A_Player = true
         Camera.CameraSubject = Target_Char:FindFirstChildOfClass("Humanoid")
      end
   else
      if not getgenv().Viewing_A_Player then return g.notify("Error", "Your not viewing anybody!", 5) end
      getgenv().Viewing_A_Player = false
      Camera.CameraSubject = getgenv().Humanoid
   end
end}, "View_Player_Toggle")

g.create_ui_element("Toggle", Players_Section, {
Name = "Annoy Player (FE)",
Default = getgenv().Annoying_Player or false,
Flag = "Annoy_Player_Toggle_UI",
Callback = function(state)
   if state == true then
      local target = findplr(getgenv().Atlas_Selected_Target or "")
      if not target then return g.notify("Error", "Player does not exist!", 5) end
      g.notify("Success", "Now annoying Player: "..tostring(target), 1)
      annoy_player(true, target)
   else
      annoy_player(false)
      g.notify("Success", "Flames Hub | Annoy Player has been disabled.", 1)
   end
end}, "Annoy_Toggle")

g.create_ui_element("Button", Players_Section, {
Name = "TP Car To Player (FE)",
Callback = function()
   local Vehicle = get_vehicle()
   if not Vehicle then return g.notify("Error", "You do not have a vehicle spawned!", 5) end
   local Goto_Player = findplr(getgenv().Atlas_Selected_Target or "")
   if not Goto_Player then return g.notify("Error", "Player does not exist or has left the game.", 5) end
   local Old_CFrame_TP_Car = getgenv().Character:FindFirstChild("HumanoidRootPart").CFrame
   local Target_Char = Goto_Player.Character or Goto_Player.CharacterAdded:Wait()
   local Target_CFrame = Target_Char:GetPivot() * CFrame.new(0, 5, 0)
   local seat = Vehicle:FindFirstChild("VehicleSeat")
   if seat and getgenv().Humanoid then
      getgenv().Character:PivotTo(seat.CFrame)
      task.wait(0.2)
      seat:Sit(getgenv().Humanoid)
   end
   wait(0.1)
   Vehicle:PivotTo(Target_CFrame)
   wait(0.3)
   if getgenv().Humanoid.Sit then
      getgenv().Humanoid:ChangeState(3)
      wait(0.2)
   end
   getgenv().HumanoidRootPart.CFrame = Old_CFrame_TP_Car
   g.notify("Success", "Teleported vehicle to player: " .. tostring(Goto_Player), 5)
end}, "TP_Car_Button")

g.create_ui_element("Button", Extras_Section, {
Name = "Infinite Premium",
Callback = function()
   loadstring(game:HttpGet("https://pastefy.app/b052AUgc/raw"))()
end})

g.create_ui_element("Button", Extras_Section, {
Name = "Infinite Yield",
Callback = function()
   loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end})

g.create_ui_element("Button", Extras_Section, {
Name = "Rejoin",
Callback = function()
   if #getgenv().Players:GetPlayers() <= 1 then
      getgenv().LocalPlayer:Kick("\nRejoining...")
      wait()
      getgenv().TeleportService:Teleport(getgenv().PlaceID, getgenv().LocalPlayer)
   else
      getgenv().TeleportService:TeleportToPlaceInstance(getgenv().PlaceID, getgenv().JobID, getgenv().LocalPlayer)
   end
end}, "Rejoin_Button")
wait(0.25)
notify("Success", "Flames Hub for game: DreamvilleRP, has been loaded successfully.", 3)
wait(0.25)
local function print_bytes(label, s)
   local bytes = {}
   for i = 1, #s do
      table.insert(bytes, string.byte(s, i))
   end
   print(label .. ": " .. table.concat(bytes, ","))
end
--[[local function clean(s) return s:gsub("[%c%z%s]", ""):gsub("[^\32-\126]", "") end
local script_url = ""
local version_url = "https://raw.githubusercontent.com/dudeididntliterally/Backup_Repo/refs/heads/main/Script_Versions_JSON.json"
local function ws_get_version()
   local http_req = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
   if not http_req then return nil end
   local ok, result = pcall(function()
      return http_req({
         Url = version_url .. "?cache=" .. tostring(os.clock()),
         Method = "GET",
         Headers = { ["Content-Type"] = "application/json" }
      })
   end)

   if not ok or not result or result.StatusCode ~= 200 then return nil end
   local ok2, data = pcall(function() return g.HttpService:JSONDecode(result.Body) end)
   if not ok2 or type(data) ~= "table" then return nil end
   local version = data.Dreamville_RP_Hub_Version
   if not version then return nil end
   return tostring(version):gsub("%s+", "")
end

local function Notify(msg, dur)
   dur = dur or 5
   local gui = Instance.new("ScreenGui")
   gui.Name = "CustomNotifyGui"
   gui.ResetOnSpawn = false
   gui.Parent = g.CoreGui

   local frame = Instance.new("Frame")
   frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
   frame.BackgroundTransparency = 1
   frame.BorderSizePixel = 0
   frame.Size = UDim2.new(0, 500, 0, 120)
   frame.Position = UDim2.new(0, 20, 0, 100)
   frame.Parent = gui

   local icon = Instance.new("ImageLabel")
   icon.BackgroundTransparency = 1
   icon.Position = UDim2.new(0, 15, 0.5, -25)
   icon.Size = UDim2.new(0, 50, 0, 50)
   icon.Image = "rbxasset://textures/ui/Emotes/ErrorIcon.png"
   icon.ImageTransparency = 1
   icon.Parent = frame

   local label = Instance.new("TextLabel")
   label.BackgroundTransparency = 1
   label.Position = UDim2.new(0, 80, 0, 10)
   label.Size = UDim2.new(1, -90, 1, -20)
   label.FontFace = Font.new("rbxasset://fonts/families/BuilderSans.json")
   label.Text = msg
   label.TextColor3 = Color3.fromRGB(255, 255, 255)
   label.TextSize = 20
   label.TextWrapped = true
   label.TextXAlignment = Enum.TextXAlignment.Left
   label.TextYAlignment = Enum.TextYAlignment.Top
   label.TextTransparency = 1
   label.Parent = frame

   Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
   g.TweenService:Create(frame, TweenInfo.new(0.3), { BackgroundTransparency = 0.3 }):Play()
   g.TweenService:Create(icon, TweenInfo.new(0.3), { ImageTransparency = 0 }):Play()
   g.TweenService:Create(label, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()

   task.delay(dur, function()
      if not frame.Parent then return end
      g.TweenService:Create(frame, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
      g.TweenService:Create(icon, TweenInfo.new(0.3), { ImageTransparency = 1 }):Play()
      g.TweenService:Create(label, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
      task.wait(0.35)
      gui:Destroy()
   end)
end

g.lta_updater_running = g.lta_updater_running or false
g.lta_updater_thread_id = (g.lta_updater_thread_id or 0) + 1
local thread_id = g.lta_updater_thread_id
if not g.lta_updater_running then
   g.lta_updater_running = true
   task.spawn(function()
      while g.lta_updater_running and thread_id == g.lta_updater_thread_id do
         task.wait(20)
         local local_version = clean(tostring(getgenv().Script_Version))
         if local_version == "" then continue end
         local remote_version = ws_get_version()
         if not remote_version or remote_version == "" then continue end
         if remote_version ~= local_version then
            g.lta_updater_running = false
            Notify("[UPDATE DETECTED]:\nLocal: " .. local_version .. "\nServer: " .. remote_version .. "\nReloading...", 6)
            task.wait(0.6)
            getgenv().Script_Version = nil
            g.Dreamville_RP_Hub_Loaded = false
            pcall(function()
               loadstring(game:HttpGet(script_url .. "?cache=" .. tostring(os.clock())))()
            end)
            break
         end
      end
   end)
end--]]