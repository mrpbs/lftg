if not game:IsLoaded() then game.Loaded:Wait() end
wait(0.25)
local g = getgenv()
if not g.GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://pastebin.com/raw/T25mDhBZ"))()
   wait(0.1)
   g.GlobalEnvironmentFramework_Initialized = true
end

local Raw_Version = "1.3.1"
getgenv().Script_Version = tostring(Raw_Version).."-MainStreetRP"
local g = getgenv()
local function service_wrapper(service)
	local pascal = service:sub(1, 1):upper() .. service:sub(2)
	if g[pascal] then
		return g[pascal]
	elseif cloneref then
		return cloneref(game:GetService(pascal))
	else
		return game:GetService(pascal)
	end
end
local MarketplaceService = service_wrapper("MarketplaceService")
local game_name = MarketplaceService:GetProductInfo(game.PlaceId).Name
local Players = service_wrapper("Players")
local HttpService = service_wrapper("HttpService")
local LocalPlayer = g.LocalPlayer or Players.LocalPlayer or game.Players.LocalPlayer
local PlayerGui = g.PlayerGui or LocalPlayer:FindFirstChildWhichIsA("PlayerGui") or LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 1)
local ReplicatedStorage = service_wrapper("ReplicatedStorage")
local StarterGui = service_wrapper("StarterGui")
if not g.turned_off_jobs_screen_gui then
	for _, v in ipairs(PlayerGui:GetDescendants()) do
		if v:IsA("ScreenGui") and v.Name:lower():find("jobs") then
			v.Enabled = false
			g.turned_off_jobs_screen_gui = true
			break
		end
	end
end
local colors = {
   "Black",
   "NardoGrey",
   "MidGrey",
   "Silver",
   "LightGrey",
   "Cream",
   "Clay",
   "SandyBiege",
   "SchoolBusYellow",
   "RawOrange",
   "WineRed",
   "Red",
   "BloodOrange",
   "NeonPink",
   "RoseRed",
   "Lavender",
   "BrightGreen",
   "BritishRacingGreen",
   "BottleGreen",
   "Lilac",
   "PaleRose",
   "Bronze",
   "DeepBlue",
   "HazelBrown",
}

local Body_Skintones = {
   "ColorA1",
   "ColorA2",
   "ColorA3",
   "ColorA4",
   "ColorA5",
   "ColorA6",
   "ColorA7",
   "ColorB1",
   "ColorB2",
   "ColorB3",
   "ColorB4",
   "ColorB5",
   "ColorB6",
   "ColorB7",
}

local Ages = {
   "Baby",
   "Child",
   "Teen",
   "Adult"
}

local function is_valid_instance(value) return value ~= nil and typeof(value) == "Instance" and value.Parent ~= nil and value:IsDescendantOf(game) end
local function is_valid_function(value) return value ~= nil and typeof(value) == "function" end
local Network = g.FuzzyFindDescendantWithClass(ReplicatedStorage, "network", "Folder")
local Vehicle_Color = Network and g.FuzzyFindChildWithClass(Network, "setcolor", "RemoteEvent")
local Vehicle_Rims = Network and g.FuzzyFindChildWithClass(Network, "setrims", "RemoteEvent")
local Vehicle_Trails = Network and g.FuzzyFindChildWithClass(Network, "settrail", "RemoteEvent")
local Vehicle_Wraps = Network and g.FuzzyFindChildWithClass(Network, "setwrap", "RemoteEvent")
local Lock_Car = Network and g.FuzzyFindChildWithClass(Network, "invokecontrol", "RemoteFunction")
local Skintone = Network and g.FuzzyFindChildWithClass(Network, "settone", "RemoteEvent")
local Age = Network and g.FuzzyFindChildWithClass(Network, "setage", "RemoteEvent")
local Avatar_Change = Network and g.FuzzyFindChildWithClass(Network, "toggleassets", "RemoteEvent")
local Request_Player = Network and g.FuzzyFindChildWithClass(Network, "invokep", "RemoteFunction")
local JobData = g.FuzzyFindDescendantWithClass(ReplicatedStorage, "jobdat", "ModuleScript")
local Set_Job_RE = Network and g.FuzzyFindChildWithClass(Network, "job_setreq", "RemoteEvent")
local HttpService = cloneref and cloneref(game:GetService("HttpService")) or game:GetService("HttpService")
local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
getgenv().cars_cache = getgenv().cars_cache or {}
getgenv().owner_index = getgenv().owner_index or {}
getgenv().car_index_inited = getgenv().car_index_inited or false
local cars_cache = getgenv().cars_cache
local owner_index = getgenv().owner_index
local vehicles_folder = workspace:FindFirstChild("Vehicles")
local function safe_wait(...)
	local current = ReplicatedStorage
	for _, part in pairs({...}) do
		current = current:WaitForChild(part, 5)
		if not current then
			return getgenv().notify("Error", "Missing: " .. tostring(part), 6)
		end
	end
	return current
end

local function to_username(v)
	for _, p in ipairs(Players:GetPlayers()) do
		if string.lower(p.Name) == string.lower(v) then return p.Name end
		if string.lower(p.DisplayName) == string.lower(v) then return p.Name end
	end
	return v
end

local function removecar(m)
	for o, x in pairs(owner_index) do
		if x == m then owner_index[o] = nil end
	end
end

local function indexcar(m)
	local raw = m:GetAttribute("57")
	if not raw then return end
	local ok, d = pcall(function() return HttpService:JSONDecode(raw) end)
	if not ok or not d or not d.Owner then return end
	owner_index[string.lower(d.Owner)] = m
end

local function setup_model(m)
	cars_cache[m] = true
	indexcar(m)
	m.AttributeChanged:Connect(function(a)
		if a == "57" then removecar(m) indexcar(m) end
	end)
end

local function carbyusername(v)
	local r = to_username(v)
	return owner_index[string.lower(r)] or nil
end

local function should_lock_car(car_model)
	local raw = car_model:GetAttribute("48")
	if not raw then return true end
	local success, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
	if success and typeof(decoded) == "table" then
		return decoded.IsLocked ~= true
	end
	return true
end

local function return_correct_age()
	local Menus_GUI = PlayerGui:FindFirstChild("Menus")
	if not Menus_GUI then return notify("Error", "Menus GUI missing", 5) end
	local Avatar = Menus_GUI:FindFirstChild("Avatar")
	if not Avatar then return notify("Error", "Avatar Frame missing", 5) end
	local Menus_Frame = Avatar:FindFirstChild("Menus")
	if not Menus_Frame then return notify("Error", "Menus Frame missing", 5) end
	local Body1 = Menus_Frame:FindFirstChild("Body")
	if not Body1 then return notify("Error", "Body_Frame_1 missing", 5) end
	local Body2 = Body1:FindFirstChild("Body")
	if not Body2 then return notify("Error", "Body_Frame_2 missing", 5) end
	local Ages_Frame = Body2:FindFirstChild("Ages")
	if not Ages_Frame then return notify("Error", "Ages Frame missing", 5) end
	for _, age_name in ipairs(Ages) do
		local btn = Ages_Frame:FindFirstChild(age_name)
		if btn and btn:FindFirstChild("Body") then
			local bg = btn.Body:FindFirstChild("Background")
			if bg then
				local ui_stroke = bg:FindFirstChild("UIStroke")
				if ui_stroke and typeof(ui_stroke.Enabled) == "boolean" and ui_stroke.Enabled then
					return age_name
				end
			end
		end
	end
	return notify("Error", "No age has UIStroke enabled.", 5)
end

if not getgenv().car_index_inited then
	getgenv().car_index_inited = true
	if vehicles_folder then
		for _, v in ipairs(vehicles_folder:GetDescendants()) do
			if v:IsA("Model") then
				if v:GetAttribute("57") then setup_model(v) end
				v.AttributeChanged:Connect(function(a)
					if a == "57" then setup_model(v) end
				end)
			end
		end
		vehicles_folder.DescendantAdded:Connect(function(v)
			if v:IsA("Model") then
				if v:GetAttribute("57") then setup_model(v) end
				v.AttributeChanged:Connect(function(a)
					if a == "57" then setup_model(v) end
				end)
			end
		end)
		vehicles_folder.DescendantRemoving:Connect(function(v)
			if cars_cache[v] then
				cars_cache[v] = nil
				removecar(v)
			end
		end)
	end
end


local ok_job, Job_Data = pcall(require, JobData)
if ok_job and Job_Data and Job_Data.Jobs then
	g.every_job = {}
	for _, job in ipairs(Job_Data.Jobs) do table.insert(g.every_job, job.Name) end
else
	g.every_job = {
		"Student", "Teacher", "Principal", "Librarian", "Pastor", "Mayor",
		"Doctor", "Nurse", "Dentist", "Paramedic", "Veterinarian", "Patient",
		"Babysitter", "PoliceOfficer", "SWATOfficer", "Sheriff", "Detective",
		"FBIAgent", "Firefighter", "Soldier", "SecretServiceAgent", "Bodyguard",
		"Spy", "Lawyer", "Judge", "Prisoner", "Burglar", "Mobster", "CEO",
		"BusinessExecutive", "Banker", "Employee", "Cashier", "Baker", "Barista",
		"Chef", "Waiter", "Janitor", "GarbageCollector", "Builder", "Mechanic",
		"Farmer", "Gardener", "Fisherman", "Hunter", "Pilot", "Sailor", "Trucker",
		"RaceCarDriver", "MotorcycleDriver", "Scientist", "Inventor", "Gamer",
		"Journalist", "Photographer", "FilmDirector", "Actor", "Artist", "Celebrity",
		"FashionDesigner", "HairStylist", "Influencer", "MakeupArtist", "Model",
		"NailTechnician", "TattooArtist", "Dancer", "DJ", "Musician", "Singer",
		"Athlete", "Coach", "Referee", "BaseballPlayer", "BasketballPlayer",
		"Bodybuilder", "Boxer", "Cheerleader", "FootballPlayer", "SoccerPlayer",
		"Swimmer", "TennisPlayer", "Lifeguard"
	}
end

local rims_path = safe_wait("Assets", "Content", "Vehicles", "Rims")
local AllRims = {}
if rims_path then
	for _, rim in ipairs(rims_path:GetChildren()) do
		if rim:IsA("Model") and string.find(rim.Name:lower(), "rimpremium") then
			table.insert(AllRims, rim.Name)
		end
	end
end

local wraps_path = safe_wait("Assets", "Content", "Vehicles", "Wraps")
local AllWraps = {}
if wraps_path then
	for _, wrap in ipairs(wraps_path:GetChildren()) do
		if wrap:IsA("SurfaceAppearance") and string.find(wrap.Name:lower(), "wrap") then
			table.insert(AllWraps, wrap.Name)
		end
	end
end

local trails_path = safe_wait("Assets", "Content", "Vehicles", "Trails")
local AllTrails = {}
if trails_path then
	for _, trail in ipairs(trails_path:GetChildren()) do
		if trail:IsA("Part") and string.find(trail.Name:lower(), "trail") then
			table.insert(AllTrails, trail.Name)
		end
	end
end

local function get_save_controller_module()
	local cache = g.save_controller_module_found
	if cache and cache.Parent and cache:IsA("ModuleScript") then return cache end
	for _, v in ipairs(ReplicatedFirst:GetDescendants()) do
		if v:IsA("ModuleScript") and v.Name:lower():find("save") and v.Name:lower():find("control") then
			g.save_controller_module_found = v
			return v
		end
	end
	
	return nil
end
wait(0.15)
if not g.save_controller_module_found then pcall(function() get_save_controller_module() end) end

local function get_weave_module_script()
	local cache = g.weave_module_found
	if cache and cache.Parent and cache:IsA("ModuleScript") then return cache end
	
	for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
		if v:IsA("ModuleScript") and v.Name:lower():find("weave") then
			g.weave_module_found = v
			return v
		end
	end

	return nil
end
wait(0.15)
if not g.weave_module_found then pcall(function() get_weave_module_script() end) end

g.rainbow_skin_toggled = g.rainbow_skin_toggled or function(state)
	if state == true then
		if g.Rainbow_Skin_Enabled then return end
		if g.rainbow_skin_reset_busy then
			if g.rainbow_skin_toggle_UI then g.rainbow_skin_toggle_UI:Set(false, false) end
			return g.notify("Warning", "Wait! Rainbow Skin is still resetting!", 5)
		end
		local weave_module = g.weave_module_found or get_weave_module_script()
		if not is_valid_instance(weave_module) or not weave_module:IsA("ModuleScript") then
			if g.rainbow_skin_toggle_UI then g.rainbow_skin_toggle_UI:Set(false, false) end
			return g.notify("Error", "ModuleScript: 'Weave' not found or does not exist.", 5)
		end
		local save_module = g.save_controller_module_found or get_save_controller_module()
		if not is_valid_instance(save_module) or not save_module:IsA("ModuleScript") then
			if g.rainbow_skin_toggle_UI then g.rainbow_skin_toggle_UI:Set(false, false) end
			return g.notify("Error", "ModuleScript: 'SaveController' not found or does not exist.", 5)
		end
		local ok_weave, Weave = pcall(require, weave_module)
		if not ok_weave or not Weave then
			if g.rainbow_skin_toggle_UI then g.rainbow_skin_toggle_UI:Set(false, false) end
			return g.notify("Error", "Failed to require 'Weave'.", 5)
		end
		local ok_save, SaveController = pcall(require, save_module)
		if not ok_save or not SaveController then
			if g.rainbow_skin_toggle_UI then g.rainbow_skin_toggle_UI:Set(false, false) end
			return g.notify("Error", "Failed to require 'SaveController'.", 5)
		end
		if not is_valid_function(SaveController.GetData) then
			if g.rainbow_skin_toggle_UI then g.rainbow_skin_toggle_UI:Set(false, false) end
			return g.notify("Error", "SaveController.GetData is not a valid function.", 5)
		end
		if not is_valid_function(Weave.FireServer) then
			if g.rainbow_skin_toggle_UI then g.rainbow_skin_toggle_UI:Set(false, false) end
			return g.notify("Error", "Weave.FireServer is not a valid function.", 5)
		end
		g.Rainbow_Skin_Cached_Tone = SaveController.GetData("Avatar/Tone")
		if not g.Rainbow_Skin_Cached_Tone then
			if g.rainbow_skin_toggle_UI then g.rainbow_skin_toggle_UI:Set(false, false) end
			return g.notify("Error", "Could not read current skin tone!", 5)
		end
		g.Rainbow_Skin_Enabled = true
		g.notify("Success", "Rainbow Skin enabled.", 5)
		FlamesLibrary.spawn("rainbow_skin", "spawn", function()
			while g.Rainbow_Skin_Enabled == true do
				for _, skintone in ipairs(Body_Skintones) do
					if not g.Rainbow_Skin_Enabled then break end
					Weave.FireServer("Avatar_SetToneRequest", skintone)
					FlamesLibrary.wait(0.1)
				end
			end
		end)
	elseif state == false then
		if not g.Rainbow_Skin_Enabled then return end
		local weave_module = g.weave_module_found or get_weave_module_script()
		if not is_valid_instance(weave_module) or not weave_module:IsA("ModuleScript") then
			return g.notify("Error", "ModuleScript: 'Weave' not found or does not exist.", 5)
		end
		local ok_weave, Weave = pcall(require, weave_module)
		if not ok_weave or not Weave then
			return g.notify("Error", "Failed to require 'Weave'.", 5)
		end
		g.Rainbow_Skin_Enabled = false
		FlamesLibrary.disconnect("rainbow_skin")
		g.rainbow_skin_reset_busy = true
		repeat FlamesLibrary.wait(0.05) until not FlamesLibrary.is_thread_alive("rainbow_skin")
		if g.notify then g.notify("Success", "Resetting skin tone...", 5) end
		local cached = g.Rainbow_Skin_Cached_Tone
		if not cached then
			g.rainbow_skin_reset_busy = false
			return
		end
		Weave.FireServer("Avatar_SetToneRequest", cached)
		g.Rainbow_Skin_Cached_Tone = nil
		g.rainbow_skin_reset_busy = false
	else
		return
	end
end

local Correct_Age = return_correct_age()
local Atlas = loadstring(game:HttpGet("https://gitlab.com/greatest-group/experience_coding/-/raw/main/UIs/Atlas.lua?ref_type=heads"))()
local UI = Atlas.new({
	Name = "Flames Hub | "..tostring(getgenv().Script_Version),
	ConfigFolder = "FlamesHub",
	Color = Color3.fromRGB(21, 103, 251),
	Bind = "RightShift",
})
local Main_Page = UI:CreatePage("Main")
local Vehicle_Section = Main_Page:CreateSection("Vehicle")
local Player_Section = Main_Page:CreateSection("Players")
local UI_Section = Main_Page:CreateSection("UI")
task.wait(0.25)
g.rainbow_vehicle_toggle_UI = Vehicle_Section:CreateToggle({
Name = "Rainbow Vehicle (FE)",
Flag = "Rainbow_Vehicle_FE",
Default = g.RGB_Vehicle or false,
Callback = function(state)
	g.RGB_Vehicle = state
	g.notify(state and "Success" or "Info", "Rainbow Vehicle " .. (state and "enabled" or "disabled") .. ".", 3)
	if state then
		FlamesLibrary.spawn("rainbow_vehicle", "spawn", function()
			while g.RGB_Vehicle do
				if not is_valid_instance(Vehicle_Color) then
					g.RGB_Vehicle = false
					if g.rainbow_vehicle_toggle_UI then g.rainbow_vehicle_toggle_UI:Set(false, false) end
					g.notify("Error", "RemoteEvent: Vehicle_Color not found or does not exist.", 3)
					break
				end
				for _, color in ipairs(colors) do
					if not g.RGB_Vehicle then break end
					if not is_valid_instance(Vehicle_Color) then
						g.RGB_Vehicle = false
						if g.rainbow_vehicle_toggle_UI then g.rainbow_vehicle_toggle_UI:Set(false, false) end
						g.notify("Error", "RemoteEvent: Vehicle_Color not found or does not exist.", 3)
						break
					end
					Vehicle_Color:FireServer("Primary", color)
					FlamesLibrary.wait(0)
				end
			end
		end)
	else
		FlamesLibrary.disconnect("rainbow_vehicle")
	end
end,})

g.flash_rims_toggle_UI = Vehicle_Section:CreateToggle({
Name = "Flash Rims (FE)",
Flag = "Flash_Rims_FE",
Default = g.Flashing_Rims or false,
Callback = function(state)
	g.Flashing_Rims = state
	g.notify(state and "Success" or "Info", "Flash Rims " .. (state and "enabled" or "disabled") .. ".", 3)
	if state then
		FlamesLibrary.spawn("flash_rims", "spawn", function()
			while g.Flashing_Rims do
				for _, rim in ipairs(AllRims) do
					if not g.Flashing_Rims then break end
					if not is_valid_instance(Vehicle_Rims) or not Vehicle_Rims:IsA("RemoteEvent") then
						g.Flashing_Rims = false
						if g.flash_rims_toggle_UI then g.flash_rims_toggle_UI:Set(false, false) end
						g.notify("Error", "RemoteEvent: Vehicle_Rims not found or does not exist.", 3)
						return
					end
					Vehicle_Rims:FireServer(rim)
					FlamesLibrary.wait(0.1)
				end
			end
		end)
	else
		FlamesLibrary.disconnect("flash_rims")
	end
end,})

g.flash_trail_toggle_UI = Vehicle_Section:CreateToggle({
Name = "Flash Trail (FE)",
Flag = "Flash_Trail_FE",
Default = g.Flashing_Trails or false,
Callback = function(state)
	g.Flashing_Trails = state
	g.notify(state and "Success" or "Info", "Flash Trail " .. (state and "enabled" or "disabled") .. ".", 3)
	if state then
		FlamesLibrary.spawn("flash_trail", "spawn", function()
			while g.Flashing_Trails do
				for _, trail in ipairs(AllTrails) do
					if not g.Flashing_Trails then break end
					if not is_valid_instance(Vehicle_Trails) or not Vehicle_Trails:IsA("RemoteEvent") then
						g.Flashing_Trails = false
						if g.flash_trail_toggle_UI then g.flash_trail_toggle_UI:Set(false, false) end
						g.notify("Error", "RemoteEvent: Vehicle_Trails not found or does not exist.", 3)
						return
					end
					Vehicle_Trails:FireServer(trail)
					FlamesLibrary.wait(0.1)
				end
			end
		end)
	else
		FlamesLibrary.disconnect("flash_trail")
	end
end,})

g.flash_wrap_toggle_UI = Vehicle_Section:CreateToggle({
Name = "Flash Wrap (FE)",
Flag = "Flash_Wrap_FE",
Default = g.Flashing_Wraps or false,
Callback = function(state)
	g.Flashing_Wraps = state
	g.notify(state and "Success" or "Info", "Flash Wrap " .. (state and "enabled" or "disabled") .. ".", 3)
	if state then
		FlamesLibrary.spawn("flash_wrap", "spawn", function()
			while g.Flashing_Wraps do
				for _, wrap in ipairs(AllWraps) do
					if not g.Flashing_Wraps then break end
					if not is_valid_instance(Vehicle_Wraps) or not Vehicle_Wraps:IsA("RemoteEvent") then
						g.Flashing_Wraps = false
						if g.flash_wrap_toggle_UI then g.flash_wrap_toggle_UI:Set(false, false) end
						g.notify("Error", "RemoteEvent: Vehicle_Wraps not found or does not exist.", 3)
						return
					end
					Vehicle_Wraps:FireServer(wrap)
					FlamesLibrary.wait(0.1)
				end
			end
		end)
	else
		FlamesLibrary.disconnect("flash_wrap")
	end
end,})

g.lock_vehicle_toggle_UI = Vehicle_Section:CreateToggle({
Name = "Lock Vehicle (FE)",
Flag = "Lock_Car_FE",
Default = g.Locked_Car or false,
Callback = function(state)
	g.Locked_Car = state
	g.notify(state and "Success" or "Info", "Lock Vehicle " .. (state and "enabled" or "disabled") .. ".", 3)
	if state then
		FlamesLibrary.spawn("lock_vehicle", "spawn", function()
			while g.Locked_Car do
				FlamesLibrary.wait(0.2)
				local my_car = carbyusername(LocalPlayer.DisplayName)
				if not my_car then
					g.Locked_Car = false
					if g.lock_vehicle_toggle_UI then g.lock_vehicle_toggle_UI:Set(false, false) end
					g.notify("Error", "Vehicle not found.", 3)
					break
				end
				if not is_valid_instance(Lock_Car) or not Lock_Car:IsA("RemoteFunction") then
					g.Locked_Car = false
					if g.lock_vehicle_toggle_UI then g.lock_vehicle_toggle_UI:Set(false, false) end
					g.notify("Error", "RemoteFunction: Lock_Car not found or does not exist.", 3)
					break
				end
				if should_lock_car(my_car) then Lock_Car:InvokeServer("ToggleLock") end
			end
		end)
	else
		FlamesLibrary.disconnect("lock_vehicle")
		FlamesLibrary.spawn("lock_vehicle_reset", "spawn", function()
			while FlamesLibrary.is_thread_alive("lock_vehicle") do FlamesLibrary.wait(0.05) end
			if is_valid_instance(Lock_Car) and Lock_Car:IsA("RemoteFunction") then
				Lock_Car:InvokeServer("ToggleLock")
			end
		end)
	end
end,})

g.rainbow_skin_toggle_UI = Player_Section:CreateToggle({
Name = "Rainbow Skin (FE)",
Flag = "Rainbow_Skin_FE",
Default = g.Rainbow_Skin_Enabled or false,
Callback = function(state)
	g.rainbow_skin_toggled(state)
end,})

g.loop_age_toggle_UI = Player_Section:CreateToggle({
Name = "Loop Age (FE)",
Flag = "Loop_Age_FE",
Default = g.Looping_Age_Setter or false,
Callback = function(state)
	g.Looping_Age_Setter = state
	g.notify(state and "Success" or "Info", "Loop Age " .. (state and "enabled" or "disabled") .. ".", 3)
	if state then
		FlamesLibrary.spawn("loop_age", "spawn", function()
			while g.Looping_Age_Setter do
				for _, age in ipairs(Ages) do
					if not g.Looping_Age_Setter then break end
					if not is_valid_instance(Age) or not Age:IsA("RemoteEvent") then
						g.Looping_Age_Setter = false
						if g.loop_age_toggle_UI then g.loop_age_toggle_UI:Set(false, false) end
						g.notify("Error", "RemoteEvent: Age not found or does not exist.", 3)
						FlamesLibrary.disconnect("loop_age")
						return
					end
					Age:FireServer(age)
					FlamesLibrary.wait(0.1)
				end
			end
		end)
	else
		FlamesLibrary.disconnect("loop_age")
		FlamesLibrary.spawn("loop_age_reset", "spawn", function()
			while FlamesLibrary.is_thread_alive("loop_age") do FlamesLibrary.wait(0.05) end
			if is_valid_instance(Age) and Age:IsA("RemoteEvent") then Age:FireServer(Correct_Age) end
		end)
	end
end,})

getgenv()._carry_spam_target = nil
Player_Section:CreateTextBox({
Name = "Spam Carry Request Player",
Flag = "Spam_Carry_Target",
DefaultText = getgenv()._carry_spam_target or "",
PlaceholderText = "User/Display",
Callback = function(text, focuslost)
	local target = g.findplr(text)
	if not target then return g.notify("Error", "Player/Target was not found.", 5) end
	getgenv()._carry_spam_target = target
	g.notify("Success", "Target set: " .. tostring(target.Name), 5)
end,})

g.spam_carry_player_toggle_UI = Player_Section:CreateToggle({
Name = "Spam Carry (FE)",
Flag = "Spam_Carry_FE",
Default = g.loop_request_carry or false,
Callback = function(state)
	g.loop_request_carry = state
	g.notify(state and "Success" or "Info", "Spam Carry " .. (state and "enabled" or "disabled") .. ".", 3)
	if state then
		local target = g._carry_spam_target
		if not target then
			g.loop_request_carry = false
			if g.spam_carry_player_toggle_UI then g.spam_carry_player_toggle_UI:Set(false, false) end
			return g.notify("Error", "No target set. Use the textbox above first.", 3)
		end
		local player_name = target.Name
		local emotes = {
			"Characters_Emotes_Joint_CarryBack_Invokee",
			"Characters_Emotes_Joint_CarryHurt_Invokee",
			"Characters_Emotes_Joint_Hug_Invokee",
			"Characters_Emotes_Joint_Handshake_Invokee",
			"Characters_Emotes_Joint_CarryShoulders_Invokee",
		}
		FlamesLibrary.spawn("spam_carry_loop", "spawn", function()
			while g.loop_request_carry do
				for _, emote in ipairs(emotes) do
					if not g.loop_request_carry then break end
					if not target then
						g.loop_request_carry = false
						if g.spam_carry_player_toggle_UI then g.spam_carry_player_toggle_UI:Set(false, false) end
						g.notify("Error", "Target is no longer valid.", 3)
						return
					end
					if not is_valid_instance(Request_Player) or not Request_Player:IsA("RemoteEvent") then
						g.loop_request_carry = false
						if g.spam_carry_player_toggle_UI then g.spam_carry_player_toggle_UI:Set(false, false) end
						g.notify("Error", "RemoteEvent: Request_Player not found or does not exist.", 3)
						return
					end
					if player_name ~= LocalPlayer.Name then Request_Player:FireServer(player_name, emote) end
					FlamesLibrary.wait(0.1)
				end
			end
		end)
	else
		FlamesLibrary.disconnect("spam_carry_loop")
	end
end,})

g.job_spammer_toggle_UI = Player_Section:CreateToggle({
Name = "Job Spammer (FE)",
Flag = "Job_Spammer_FE",
Default = g.Job_Spammer_Enabled or false,
Callback = function(state)
	g.Job_Spammer_Enabled = state
	g.notify(state and "Success" or "Info", "Job Spammer " .. (state and "enabled" or "disabled") .. ".", 3)
	if state then
		FlamesLibrary.spawn("job_spammer", "spawn", function()
			while g.Job_Spammer_Enabled do
				for _, job in ipairs(g.every_job) do
					if not g.Job_Spammer_Enabled then break end
					if not is_valid_instance(Set_Job_RE) or not Set_Job_RE:IsA("RemoteEvent") then
						g.Job_Spammer_Enabled = false
						if g.job_spammer_toggle_UI then g.job_spammer_toggle_UI:Set(false, false) end
						g.notify("Error", "RemoteEvent: Set_Job_RE not found or does not exist.", 3)
						return
					end
					Set_Job_RE:FireServer(job)
					FlamesLibrary.wait(0)
				end
			end
		end)
	else
		FlamesLibrary.disconnect("job_spammer")
	end
end,})

UI_Section:CreateButton({
Name = "Destroy GUI",
Callback = function()
	if Atlas then Atlas:Destroy() else pcall(function() Atlas:Destroy() end) end
end,})