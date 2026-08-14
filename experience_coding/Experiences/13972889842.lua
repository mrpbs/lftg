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

local g = getgenv()
local Raw_Version = "V1.1.9"
getgenv().Script_Version = tostring(Raw_Version).."-BillberryCityRP"
if not g.GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://pastebin.com/raw/T25mDhBZ"))()
   wait(0.1)
   g.GlobalEnvironmentFramework_Initialized = true
end
wait(0.25)
local function blank_function(...) return ... end
local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local ReplicatedStorage = g.ReplicatedStorage or cloneref and cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
local LocalPlayer = g.LocalPlayer or Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local speaker = LocalPlayer
local UserInputService = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local MarketplaceService = g.MarketplaceService or cloneref and cloneref(game:GetService("MarketplaceService")) or game:GetService("MarketplaceService")
local AvatarEditorService = g.AvatarEditorService or cloneref and cloneref(game:GetService("AvatarEditorService")) or game:GetService("AvatarEditorService")
local game_name_str = tostring(MarketplaceService:GetProductInfo(game.PlaceId).Name)
local PlayerGui = g.PlayerGui or LocalPlayer:FindFirstChildWhichIsA("PlayerGui") or LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 1)
local httprequest = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
local Is_Mobile = UserInputService.TouchEnabled
local FlamesLibrary = getgenv().FlamesLibrary
g.all_vehicles_collected = {} -- keep it dynamic because they may add more.
g.all_jobs_collected = {} -- keep it dynamic because they may add more.
g.RP_Text_Changer_Enabled = g.RP_Text_Changer_Enabled or false
g.RP_Text_Changer_Index = g.RP_Text_Changer_Index or 1
g.RP_Text_Changer_Interval = g.RP_Text_Changer_Interval or 0.1
g.RP_Text_Changer_Elapsed = g.RP_Text_Changer_Elapsed or 0
local function wait(num)
	num = (typeof(num) == "number" and num > 0) and num or 0
	local success, result = pcall(task.wait, num)
	if success and typeof(result) == "number" then return result end
	local heartbeat_success, heartbeat_result = pcall(function()
		local elapsed = 0
		local start = os.clock()
		while elapsed < num do
			RunService.Heartbeat:Wait()
			elapsed = os.clock() - start
		end
		return elapsed
	end)
	if heartbeat_success and typeof(heartbeat_result) == "number" then return heartbeat_result end
	local legacy_success, legacy_result = pcall(function()
		local has_rawget = rawget ~= nil and typeof(rawget) == "function"
		local legacy_wait = nil
		if has_rawget then
			legacy_wait = rawget(_G, "wait")
		end
		if not legacy_wait or typeof(legacy_wait) ~= "function" then
			legacy_wait = _G.wait
		end
		if not legacy_wait or typeof(legacy_wait) ~= "function" then
			legacy_wait = coroutine.yield
		end
		return legacy_wait(num)
	end)

	if legacy_success then return typeof(legacy_result) == "number" and legacy_result or num end
	return num
end

g.all_current_asset_types = {
	[41] = "HairAccessory",
	[42] = "FaceAccessory",
	[43] = "NeckAccessory",
	[44] = "ShoulderAccessory",
	[45] = "FrontAccessory",
	[46] = "BackAccessory",
	[47] = "WaistAccessory",
	[8]  = "Hat",
	[11] = "Shirt",
	[12] = "Pants",
}

local ASSET_TYPE_ID_TO_ENUM = {
	[8]  = Enum.AvatarAssetType.Hat,
	[41] = Enum.AvatarAssetType.HairAccessory,
	[42] = Enum.AvatarAssetType.FaceAccessory,
	[43] = Enum.AvatarAssetType.NeckAccessory,
	[44] = Enum.AvatarAssetType.ShoulderAccessory,
	[45] = Enum.AvatarAssetType.FrontAccessory,
	[46] = Enum.AvatarAssetType.BackAccessory,
	[47] = Enum.AvatarAssetType.WaistAccessory,
	[11] = Enum.AvatarAssetType.Shirt,
	[12] = Enum.AvatarAssetType.Pants,
}

local ASSET_TYPE_ID_TO_NAME = {
	[8]  = "Hat",
	[41] = "HairAccessory",
	[42] = "FaceAccessory",
	[43] = "NeckAccessory",
	[44] = "ShoulderAccessory",
	[45] = "FrontAccessory",
	[46] = "BackAccessory",
	[47] = "WaistAccessory",
	[11] = "Shirt",
	[12] = "Pants",
}

g.colors = g.colors or {
	Color3.fromRGB(255,255,255),
	Color3.fromRGB(128,128,128),
	Color3.fromRGB(0,0,0),
	Color3.fromRGB(0,0,255),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,255,255),
	Color3.fromRGB(255,165,0),
	Color3.fromRGB(139,69,19),
	Color3.fromRGB(255,255,0),
	Color3.fromRGB(50,205,50),
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(255,155,172),
	Color3.fromRGB(128,0,128),
}

g.colors_color_three = g.colors_color_three or {
	Color3.new(1, 1, 1),
	Color3.new(0.5019607843137255, 0.5019607843137255, 0.5019607843137255),
	Color3.new(0, 0, 0),
	Color3.new(0, 0, 1),
	Color3.new(0, 1, 0),
	Color3.new(0, 1, 1),
	Color3.new(1, 0.6470588235294118, 0),
	Color3.new(0.5450980392156862, 0.27058823529411763, 0.07450980392156863),
	Color3.new(1, 1, 0),
	Color3.new(0.19607843137254902, 0.803921568627451, 0.19607843137254902),
	Color3.new(1, 0, 0),
	Color3.new(1, 0.6078431372549019, 0.6745098039215686),
	Color3.new(0.5019607843137255, 0, 0.5019607843137255),
}

g.posts_text_data_tbl = {
	"lol",
	"?",
	"wsp",
	"yo",
	"wsg yall",
	"Flames Hub on top.",
	"ayy",
	"Lol",
	"whats yall favorite color?",
	"yall know Flames Hub is the best script?",
	"Flames got the best features.",
	"come on now bro.",
	"we know, Flames Hub is just better, we know.",
	"wss yall",
	"we so back."
}

local words_list = {
	"root_access","packet_inject","xor_key","decrypting",
	"init_stealth","spoof_id","kernel_hook","bruteforce",
	"sys_reboot","net_breach","ghost_mode","backdoor_init"
}
g.LocalPlayer = g.LocalPlayer or Players.LocalPlayer or game.Players.LocalPlayer
local has_gethui = (typeof(get_hui) == "function") or (typeof(g.get_hui) == "function")
local has_gethidden = (typeof(get_hidden_gui) == "function") or (typeof(g.get_hidden_gui) == "function")
if not has_gethui and not has_gethidden and not g.roblox_hidden_gui_location then
	g.roblox_hidden_gui_location = g.roblox_hidden_gui_location or nil
	if not g.roblox_hidden_gui_location then
		for _, v in ipairs(CoreGui:GetChildren()) do
			if v:IsA("ScreenGui") and v.Name == "RobloxGui" then
				g.roblox_hidden_gui_location = v
			end
		end
	end

	g.get_hui = function()
		if g.roblox_hidden_gui_location and g.roblox_hidden_gui_location:IsA("ScreenGui") then
			return g.roblox_hidden_gui_location
		else
			return CoreGui
		end
	end

	g.get_hidden_gui = function()
		if g.roblox_hidden_gui_location and g.roblox_hidden_gui_location:IsA("ScreenGui") then
			return g.roblox_hidden_gui_location
		else
			return CoreGui
		end
	end
end
wait(0.25)
g.all_available_jobs = {
	"Lifeguard",
	"Car Washer",
	"Waste Collector",
	"Hospital",
	"Diner",
	"Gardener",
	"Racer",
	"Bodyguard",
	"Club",
	"Star",
	"Student",
	"Gamer",
	"Firefighter",
	"Detective",
	"Babysitter",
	"Chef",
	"Security",
	"Barista",
	"Repairman",
	"Clothing",
	"Ghost Hunter",
	"Daycare",
	"Dentist",
	"Nail Artist",
	"At-home Mom",
	"Fitness Trainer",
	"Teacher",
	"UTuber",
	"Actor",
	"Movies",
	"Driver",
	"Librarian",
	"Priest",
	"Athlete",
	"Office Worker",
	"Principal",
	"Mayor",
	"Adoption Worker",
	"Ice Cream",
	"Military Police",
	"Pizza",
	"Referee",
	"Flight Attendant",
	"Realtor",
	"Writer",
	"SWAT",
	"Taxi Driver",
	"Federal Officer",
	"Spy",
	"Burger",
	"Singer",
	"Sheriff",
	"Volunteer",
	"Patient",
	"Postal Worker",
	"Police",
	"Dancer",
	"Barber",
	"Military",
	"Bank",
	"Receptionist",
	"Park Ranger",
	"News",
	"Musician",
	"Photographer",
	"Criminal",
	"Grocery",
	"Maid",
	"Businessperson",
	"Judge",
	"At-home Dad",
	"Farmer",
	"Janitor",
	"Doctor",
	"Lawyer",
	"Pilot",
}

g.titles = {
	"Flames | On",
	"Flames | All Stealers Blocked",
	"Flames | Anti Stealer Is Enabled",
	"Flames | Full Protection Currently Active",
	"Flames | Anti Stealer Fully Operational Right Now",
	"Flames | Every Layer Of Defense Is Online And Watching Closely",
}

g.check_private_server = g.check_private_server or function()
	for _, v in ipairs(workspace:GetChildren()) do
		if v:IsA("NumberValue") and v.Name:lower():find("private") and v.Name:lower():find("server") and v.Name:lower():find("owner") and v.Name:lower():find("id") then
			return v
		end
	end

	return nil
end

g.is_localplayer_server_owner = g.is_localplayer_server_owner or function()
	local check_one = g.check_private_server()
	if not check_one then return g.notify("Error", "This is not a private server / NumberValue not found.", 5) end
	if check_one.Value == g.LocalPlayer.UserId then return true end
	return false
end

g.get_catalog_system_screen_gui = function()
	local cache = g.catalog_system_GUI_found
	if cache and cache.Parent and cache:IsA("ScreenGui") then return cache end

	for _, v in ipairs(PlayerGui:GetDescendants()) do
		if v:IsA("ScreenGui") and v.Name:lower():find("catalog") and v.Name:lower():find("system") then
			g.catalog_system_GUI_found = v
			return v
		end
	end

	return nil
end
wait(0.1)
if not g.catalog_system_GUI_found then pcall(function() g.get_catalog_system_screen_gui() end) end

g.toggle_catalog_system_gui = function(state)
	local main_gui = g.catalog_system_GUI_found or g.get_catalog_system_screen_gui()
	if not main_gui or not main_gui:IsA("ScreenGui") then return g.notify("Error", "ScreenGui: CatalogSystem not found or is not a ScreenGui.", 3) end
	if main_gui and main_gui:IsA("ScreenGui") then main_gui.Enabled = state end
end

g.get_windows_screen_gui_for_vehicles = function()
	local cache = g.windows_screen_gui_found
	if cache and cache.Parent and cache:IsA("ScreenGui") then return cache end

	for _, v in ipairs(PlayerGui:GetDescendants()) do
		if v:IsA("ScreenGui") and v.Name:lower():find("windows") then
			g.windows_screen_gui_found = v
			return v
		end
	end
	
	return nil
end
wait(0.1)
if not g.windows_screen_gui_found then pcall(function() g.get_windows_screen_gui_for_vehicles() end) end

g.get_color_changed_Remote_Event = function()
	local cache = g.color_changed_RE_found
	if cache and cache.Parent and cache:IsA("RemoteEvent") then return cache end

	for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
		if v:IsA("RemoteEvent") and v.Name:lower():find("color") and v.Name:lower():find("change") then
			g.color_changed_RE_found = v
			return v
		end
	end

	return nil
end
wait(0.1)
if not g.color_changed_RE_found then pcall(function() g.get_color_changed_Remote_Event() end) end
if g.windows_screen_gui_found and g.windows_screen_gui_found:IsA("ScreenGui") then g.windows_screen_gui_found.Enabled = true end
g.find_annoying_shop_GUI_Button = function()
	local cache = g.shop_gui_button_top_left_corner
	if cache and cache.Parent and cache:IsA("TextButton") then return cache end

	for _, v in ipairs(PlayerGui:GetDescendants()) do
		if v:IsA("TextButton") and v.Name:lower():find("shop") then
			g.shop_gui_button_top_left_corner = v
			return v
		end
	end

	return nil
end
wait(0.1)
if not g.shop_gui_button_top_left_corner then pcall(function() g.find_annoying_shop_GUI_Button() end) end

g.toggle_shop_button_corner = function(state)
	local button = g.shop_gui_button_top_left_corner or g.find_annoying_shop_GUI_Button()
	if not button or not button:IsA("TextButton") then return g.notify("Error", "TextButton: Shop not found or is not a TextButton.", 3) end
	button.Visible = state or false
end

-- [[ 😈 😮‍💨 ]] --
g.get_vehicle_spawner_RE = function()
	local cache = g.vehicle_spawner_Remote_Event_found
	if cache and cache.Parent and cache:IsA("RemoteEvent") then return cache end
	local excluded = {"game", "pass"}
	for _, v in ipairs(PlayerGui:GetDescendants()) do
		if v:IsA("RemoteEvent") and v.Parent:IsA("Frame") then
			local name = v.Parent.Name:lower()
			if name:find("vehicle") then
				local blocked = false
				for _, word in ipairs(excluded) do
					if name:find(word) then
						blocked = true
						break
					end
				end

				if not blocked then
					g.vehicle_spawner_Remote_Event_found = v
					return v
				end
			end
		end
	end

	return nil
end
wait(0.1)
if not g.vehicle_spawner_Remote_Event_found then pcall(function() g.get_vehicle_spawner_RE() end) end

g.get_all_jobs_Scrolling_Frame = function()
	local cache = g.job_changer_main_Frame_found
	if cache and cache.Parent and cache:IsA("Frame") then return cache end
	for _, v in ipairs(PlayerGui:GetDescendants()) do
		if v:IsA("ScrollingFrame") and v.Parent.Parent.Name:lower():find("role") then -- riskier, but what ever.
			g.job_changer_main_Frame_found = v
			return v
		end
	end

	return nil
end
wait(0.1)
if not g.job_changer_main_Frame_found then pcall(function() g.get_all_jobs_Scrolling_Frame() end) end

g.get_vehicle_spawner_frame = function()
	local cache = g.vehicle_spawner_frame_found
	if cache and cache.Parent and cache:IsA("Frame") then return cache end
	local excluded = {"game", "pass"}
	local fuzzy_keywords = {"vehicle"}

	for _, v in ipairs(PlayerGui:GetDescendants()) do
		if not v:IsA("Frame") then continue end
		local name = v.Name:lower()
		local matched = false
		for _, keyword in ipairs(fuzzy_keywords) do
			if name:find(keyword) then
				matched = true
				break
			end
		end

		if not matched then continue end
		local blocked = false
		for _, word in ipairs(excluded) do
			if name:find(word) then
				blocked = true
				break
			end
		end

		if not blocked then
			g.vehicle_spawner_frame_found = v
			return v
		end
	end

	return nil
end
wait(0.1)
if not g.vehicle_spawner_frame_found then pcall(function() g.get_vehicle_spawner_frame() end) end
if g.vehicle_spawner_frame_found and g.vehicle_spawner_frame_found.Parent and g.vehicle_spawner_frame_found:IsA("Frame") then
	for _, v in ipairs(g.vehicle_spawner_frame_found:GetChildren()) do
		if v:IsA("ScrollingFrame") then
			for _, car in ipairs(v:GetChildren()) do
				if car:IsA("ImageButton") then
					table.insert(g.all_vehicles_collected, car.Name)
				end
			end
		end
	end
end

if g.job_changer_main_Frame_found and g.job_changer_main_Frame_found.Parent and g.job_changer_main_Frame_found:IsA("ScrollingFrame") then
	local index = 0
	for _, v in ipairs(g.job_changer_main_Frame_found:GetChildren()) do
		if v:IsA("ImageButton") then
			index += 1
			table.insert(g.all_jobs_collected, index)
		end
	end
end

g.spawn_vehicle_from_Remote_Event = function(vehicle)
	local remote = g.vehicle_spawner_Remote_Event_found or g.get_vehicle_spawner_RE()
	if not remote or not remote:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: SpawnVehicle was not found or is not a RemoteEvent.", 3) end
	if not vehicle or vehicle == nil then vehicle = "8" end
	remote:FireServer(tostring(vehicle))
end

g.get_all_vehicles_folder = function(timeout)
	local cache = g.currently_cached_vehicles_folder
	if cache and cache:IsA("Folder") and cache.Parent then return cache end
	timeout = timeout or 5
	local Start_Time = os.clock()
	local Lowered_UserId = tostring(speaker.UserId):lower()
	local User_Folder
	local Is_Private_Server = g.is_localplayer_server_owner()

	local Folder_Contains_Character = function(folder)
		for _, v in ipairs(folder:GetDescendants()) do
			if v:IsA("Humanoid") then return true end
		end
		return false
	end

	repeat
		for _, v in ipairs(workspace:GetDescendants()) do
			if v:IsA("Folder") and v.Name:lower():find(Lowered_UserId, 1, true) then
				if Is_Private_Server ~= true and Folder_Contains_Character(v) then
					continue
				end

				User_Folder = v
				local stored_vehicles_folder = FuzzyFindDescendantWithClass(v, "vehicle", "Folder")
				if stored_vehicles_folder then
					g.currently_cached_vehicles_folder = stored_vehicles_folder
					return stored_vehicles_folder
				end
			end
		end
		task.wait(0.1)
	until os.clock() - Start_Time >= timeout

	local new_vehicles_folder = Instance.new("Folder")
	new_vehicles_folder.Name = "Vehicle"
	new_vehicles_folder.Parent = User_Folder
	g.currently_cached_vehicles_folder = new_vehicles_folder
	g.notify("Info", "Could not find existing Vehicles Folder, created a new one under: "..tostring(new_vehicles_folder.Parent and new_vehicles_folder.Parent:GetFullName() or "nil"), 5)
	if User_Folder then
		FlamesLibrary.connect("Real_Vehicle_Folder_Watcher", User_Folder.ChildAdded:Connect(function(child)
			if child ~= new_vehicles_folder and child:IsA("Folder") and child.Name:lower():find("vehicle") then
				task.wait(0.1)
				if new_vehicles_folder and new_vehicles_folder.Parent then new_vehicles_folder:Destroy() end
				g.currently_cached_vehicles_folder = child
				FlamesLibrary.disconnect("Real_Vehicle_Folder_Watcher")
			end
		end))
	end

	return new_vehicles_folder
end
wait(0.15)
if not g.currently_cached_vehicles_folder then pcall(function() g.get_all_vehicles_folder() end) end

g.get_vehicle = function()
	local vehicles_folder = g.get_all_vehicles_folder()
	if not vehicles_folder then return g.notify("Error", "Could not find Vehicles Folder.", 3) end
	local player_storage = vehicles_folder.Parent
	if not player_storage then return g.notify("Error", "Could not find player storage folder.", 3) end
	for _, v in ipairs(player_storage:GetChildren()) do
		if v:IsA("Model") and v:GetAttribute("playerid") == speaker.UserId then
			return v
		end
	end

	for _, v in ipairs(player_storage:GetDescendants()) do
		if v:IsA("Model") and v:GetAttribute("playerid") == speaker.UserId then
			return v
		end
	end

	return nil
end

g.get_all_vehicles = function()
	local vehicles_folder = g.get_all_vehicles_folder()
	if not vehicles_folder then return {} end
	local player_storage = vehicles_folder.Parent
	if not player_storage then return {} end

	local Found_Vehicles = {}
	for _, v in ipairs(player_storage:GetDescendants()) do
		if v:IsA("Model") and v:GetAttribute("playerid") == speaker.UserId then
			table.insert(Found_Vehicles, v)
		end
	end

	return Found_Vehicles
end

g.find_car_colors_model = function(veh)
	if not veh or not veh:IsA("Model") then return nil end

	for _, v in ipairs(veh:GetDescendants()) do
		if v:IsA("Model") and v.Name:lower():find("car") and v.Name:lower():find("color") then
			return v
		end
	end

	return nil
end

g.change_vehicle_color = function(veh, new_color)
	local color_changer_RE = g.color_changed_RE_found or g.get_color_changed_Remote_Event()
	if not color_changer_RE or not color_changer_RE:IsA("RemoteEvent") then
		g.rainbow_vehicle_toggled = false
		FlamesLibrary.disconnect("rainbow_vehicle")
		if getgenv().Toggle_Rainbow_Vehicle_UI then getgenv().Toggle_Rainbow_Vehicle_UI:Set(false, false) end
		return g.notify("Error", "RemoteEvent: ColorChanged was not found or is not a RemoteEvent.", 3)
	end

	local vehicle_body_color = g.find_car_colors_model(veh)
	if not vehicle_body_color or not vehicle_body_color:IsA("Model") then
		return
	end

	color_changer_RE:FireServer(vehicle_body_color, new_color)
end

g.rainbow_vehicle_toggle_func = function(state)
	if state == true then
		g.rainbow_vehicle_toggled = true
		FlamesLibrary.spawn("rainbow_vehicle", "spawn", function()
			while g.rainbow_vehicle_toggled == true do
				for _, color in ipairs(g.colors) do
					if not g.rainbow_vehicle_toggled then break end
					local all_vehicles = g.get_all_vehicles()
					if #all_vehicles == 0 then
						g.rainbow_vehicle_toggled = false
						FlamesLibrary.disconnect("rainbow_vehicle")
						if getgenv().Toggle_Rainbow_Vehicle_UI then getgenv().Toggle_Rainbow_Vehicle_UI:Set(false, false) end
						return g.notify("Error", "No Vehicles found to apply Rainbow to.", 3)
					end

					for _, veh in ipairs(all_vehicles) do
						if not g.rainbow_vehicle_toggled then break end
						g.change_vehicle_color(veh, color)
					end
					task.wait(0)
				end
			end
		end)
	elseif state == false then
		g.rainbow_vehicle_toggled = false
		FlamesLibrary.disconnect("rainbow_vehicle")
	else
		return
	end
end

g.find_catalog_equip_Remote_Function = g.find_catalog_equip_Remote_Function or function()
	local cache = g.catalog_equip_RF_Found
	if cache and cache:IsA("RemoteFunction") and cache.Parent then return cache end
	for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
		if v:IsA("RemoteFunction") and v.Name:lower():find("catalog") and v.Name:lower():find("equip") then
			g.catalog_equip_RF_Found = v
			return v
		end
	end

	return nil
end
wait(0.1)
if not g.catalog_equip_RF_Found then pcall(function() g.find_catalog_equip_Remote_Function() end) end

g.find_car_constraint_chassis = function()
	local vehicle = g.get_vehicle()
	if not vehicle or not vehicle:IsA("Model") then return g.notify("Error", "You do not have a Vehicle spawned or it is not a Model.", 3) end
	for _, v in ipairs(vehicle:GetDescendants()) do
		if v:IsA("Model") and v.Name:lower():find("constrain") and v.Name:lower():find("chass") then
			return v
		end
	end

	return nil
end

g.modify_car_setting = function(setting, new_value)
	setting = setting:lower()
	local constrained_chassis = g.find_car_constraint_chassis()
	if not constrained_chassis or not constrained_chassis:IsA("Model") then return g.notify("Error", "Model: ConstraintChassis not found in Vehicle or is not a Model.", 3) end
	if setting:find("max") and setting:find("speed") then
		local ok, res = pcall(function()
			return constrained_chassis:GetAttribute("MaxSpeed")
		end)

		if ok and res ~= nil then
			constrained_chassis:SetAttribute("MaxSpeed", new_value)
		end
	elseif setting:find("turn") and setting:find("speed") then
		local ok, res = pcall(function()
			return constrained_chassis:GetAttribute("TurnSpeed")
		end)

		if ok and res ~= nil then
			constrained_chassis:SetAttribute("TurnSpeed", new_value)
		end
	elseif setting:find("height") or setting:find("suspension") then
		local ok, res = pcall(function()
			return constrained_chassis:GetAttribute("SuspensionHeight")
		end)

		if ok and res ~= nil and new_value <= 10 then
			constrained_chassis:SetAttribute("SuspensionHeight", new_value)
		end
	end
end

g.change_height_of_character = function(new_height)
	local cached_RF = g.catalog_equip_RF_Found or g.find_catalog_equip_Remote_Function()
	if not cached_RF or not cached_RF:IsA("RemoteFunction") then return g.notify("Error", "RemoteFunction: CatalogEquipFunction not found or is not a RemoteFunction.", 5) end
	local args = {"Scale", {HeightScale = new_height}}
	local success, result = pcall(function() return cached_RF:InvokeServer(unpack(args)) end)
	if not success then return g.notify("Error", "InvokeServer failed: " .. tostring(result), 3) end
	return result
end

g.vehicle_spin_speed = g.vehicle_spin_speed or 10
g.vehicle_spinning = g.vehicle_spinning or false
g.start_vehicle_spin = function(speed)
	g.vehicle_spin_speed = speed or g.vehicle_spin_speed
	g.vehicle_spinning = true
	FlamesLibrary.spawn("vehicle_spin", "spawn", function()
		while g.vehicle_spinning do
			local chassis = g.find_car_constraint_chassis()
			if not chassis or not chassis:IsA("Model") then
				g.vehicle_spinning = false
				FlamesLibrary.disconnect("vehicle_spin")
				if getgenv().Toggle_Vehicle_Spin_UI then getgenv().Toggle_Vehicle_Spin_UI:Set(false, false) end
				return g.notify("Error", "ConstraintChassis not found or is not a Model.", 3)
			end
			local root = chassis:FindFirstChild("VehicleSeat", true) or chassis.PrimaryPart
			if not root then
				g.vehicle_spinning = false
				FlamesLibrary.disconnect("vehicle_spin")
				if getgenv().Toggle_Vehicle_Spin_UI then getgenv().Toggle_Vehicle_Spin_UI:Set(false, false) end
				return g.notify("Error", "VehicleSeat or PrimaryPart not found in ConstraintChassis.", 3)
			end
			local existing = root:FindFirstChild("VehicleSpinning")
			if existing then existing:Destroy() end
			local spin = Instance.new("BodyAngularVelocity")
			spin.Name = "VehicleSpinning"
			spin.MaxTorque = Vector3.new(0, math.huge, 0)
			spin.AngularVelocity = Vector3.new(0, g.vehicle_spin_speed, 0)
			spin.Parent = root
			task.wait(0)
		end
	end)
end

g.stop_vehicle_spin = function()
	g.vehicle_spinning = false
	FlamesLibrary.disconnect("vehicle_spin")
	local chassis = g.find_car_constraint_chassis()
	if chassis and chassis:IsA("Model") then
		local root = chassis:FindFirstChild("VehicleSeat", true) or chassis.PrimaryPart
		if root then
			local existing = root:FindFirstChild("VehicleSpinning")
			if existing then existing:Destroy() end
		end
	end
end

g.Noclip_Enabled = g.Noclip_Enabled or false
g.Noclip_Connection = g.Noclip_Connection or nil
g.noclip_parts = g.noclip_parts or {}
local function refresh_parts()
   table.clear(g.noclip_parts)
   local Character = g.Character or LocalPlayer.Character or g.get_char(LocalPlayer, 10)
   if not Character then return end
   for _, inst in ipairs(Character:GetDescendants()) do if inst:IsA("BasePart") then table.insert(g.noclip_parts, inst) end end
end

local function noclip_step()
   local parts = g.noclip_parts
   for i = 1, #parts do
      local p = parts[i]
      if p and p.Parent and p.CanCollide then p.CanCollide = false end
   end
end

g.ToggleNoclip = function(state)
   local lib = getgenv().FlamesLibrary
   local key = "noclip_stepped"
   if state == true then
      if g.Noclip_Enabled then
         if g.notify then return g.notify("Warning", "Noclip is already enabled!", 1) end
         return
      end

      if lib.is_alive(key) then lib.disconnect(key) end
      refresh_parts()
      lib.connect(key, RunService.Stepped:Connect(noclip_step))
      g.Noclip_Enabled = true
      if g.notify then g.notify("Success", "Noclip has been enabled.", 1) end
   elseif state == false then
      if not g.Noclip_Enabled then
         if g.notify then return g.notify("Error", "Noclip is not enabled!", 1) end
         return
      end

      lib.disconnect(key)
      for i = 1, #g.noclip_parts do
         local part = g.noclip_parts[i]
         if part and part.Parent then part.CanCollide = true end
      end

      table.clear(g.noclip_parts)
      g.Noclip_Enabled = false
      if g.notify then g.notify("Success", "Noclip has been disabled.", 5) end
   else
      if g.notify then return g.notify("Error", "Invalid arg, expected true/false", 5) end
   end
end

g.vehicle_fly = g.vehicle_fly or false
g.vehicle_fly_speed = g.vehicle_fly_speed or 3
g.vehiclefly_conns = g.vehiclefly_conns or {}
g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
g.vehiclefly_noclip = g.vehiclefly_noclip or false
g.vehiclefly_collisions = g.vehiclefly_collisions or {}
local controlModule
if Is_Mobile then controlModule = require(Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule")) end
g.get_vehicle_platform = function()
	local car = g.get_vehicle()
	if not car or not car:IsA("Model") then return nil end
	local chassis = nil
	for _, v in ipairs(car:GetDescendants()) do
		if v:IsA("Model") and v.Name:lower():find("constrain") and v.Name:lower():find("chass") then
			chassis = v
			break
		end
	end
	if not chassis then return nil end
	local platform = chassis:FindFirstChild("Platform")
	if platform and platform:IsA("BasePart") then return platform end
	return chassis.PrimaryPart
end

g.cleanup = function()
	for _, c in pairs(g.vehiclefly_conns) do pcall(function() c:Disconnect() end) end
	g.vehiclefly_conns = {}
	if g.vehiclefly_bv then
		pcall(function() g.vehiclefly_bv.Velocity = Vector3.zero end)
		pcall(function() g.vehiclefly_bv:Destroy() end)
		g.vehiclefly_bv = nil
	end
	if g.vehiclefly_bg then
		pcall(function() g.vehiclefly_bg:Destroy() end)
		g.vehiclefly_bg = nil
	end
end

g.enable_vehicle_noclip = function()
	if g.vehiclefly_noclip then return end
	g.vehiclefly_noclip = true
	g.vehiclefly_collisions = {}
	local car = g.get_vehicle()
	if not car then return end
	local wheels_model = car:FindFirstChild("Wheels")
	for _, v in ipairs(car:GetDescendants()) do
		if v:IsA("BasePart") and v.CanCollide then
			if wheels_model and v:IsDescendantOf(wheels_model) then continue end
			g.vehiclefly_collisions[v] = true
			v.CanCollide = false
		end
	end
	g.ToggleNoclip(true)
	for _, v in ipairs(car:GetDescendants()) do
		if v:IsA("Seat") then
			local occupant = v.Occupant
			if not occupant then continue end
			local character = occupant.Parent
			if not character or not character:IsDescendantOf(workspace) then continue end
			for _, part in ipairs(character:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide then
					g.vehiclefly_collisions[part] = true
					part.CanCollide = false
				end
			end
		end
	end
end

g.disable_vehicle_noclip = function()
	if not g.vehiclefly_noclip then return end
	g.vehiclefly_noclip = false
	g.ToggleNoclip(false)
	for part, _ in pairs(g.vehiclefly_collisions) do
		if part and part.Parent and part:IsDescendantOf(workspace) then
			part.CanCollide = true
		end
	end
	g.vehiclefly_collisions = {}
end

g.start_vehicle_fly = function()
	if g.vehiclefly_bg or g.vehiclefly_bv then return end
	local local_char = g.Character or g.LocalPlayer.Character or g.get_char(LocalPlayer, 10)
	if not local_char then
		if g.main_vehicle_fly_UI_toggle then g.main_vehicle_fly_UI_toggle:Set(false, false) end
		g.notify("Error", "Your Character does not exist yet, please wait until you respawn.", 3)
		return 
	end
	local car = g.get_vehicle()
	if not car then
		if g.main_vehicle_fly_UI_toggle then g.main_vehicle_fly_UI_toggle:Set(false, false) end
		g.notify("Error", "You are not in a vehicle.", 5)
		return
	end
	local seated = false
	for _, v in ipairs(car:GetDescendants()) do
		if v:IsA("VehicleSeat") and v.Occupant and v.Occupant.Parent == local_char then
			seated = true
			break
		end
	end
	if not seated then
		if g.main_vehicle_fly_UI_toggle then g.main_vehicle_fly_UI_toggle:Set(false, false) end
		g.notify("Error", "You must be seated in the vehicle to use Vehicle Fly.", 5)
		return
	end
	local platform = g.get_vehicle_platform()
	if not platform then
		g.disable_vehicle_noclip()
		task.wait()
		g.cleanup()
		if g.main_vehicle_fly_UI_toggle then g.main_vehicle_fly_UI_toggle:Set(false, false) end
		g.notify("Error", "Platform not found in ConstraintChassis.", 5)
		return
	end

	local bg = Instance.new("BodyGyro")
	bg.P = 3e4
	bg.D = 1e3
	bg.MaxTorque = Vector3.new(0, 9e9, 0)
	bg.CFrame = platform.CFrame
	bg.Parent = platform

	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.Velocity = Vector3.zero
	bv.Parent = platform

	g.vehiclefly_bg = bg
	g.vehiclefly_bv = bv
	g.vehiclefly_conns.render = RunService.Heartbeat:Connect(function()
		if not g.vehicle_fly or not platform.Parent then
			bv.Velocity = Vector3.zero
			g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
			if not platform.Parent then
				if g.main_vehicle_fly_UI_toggle then g.main_vehicle_fly_UI_toggle:Set(false, false) end
				g.stop_vehicle_fly()
			end
			return
		end

		local still_seated = false
		for _, v in ipairs(car:GetDescendants()) do
			if v:IsA("VehicleSeat") and v.Occupant and v.Occupant.Parent == local_char then
				still_seated = true
				break
			end
		end
		if not still_seated then
			if g.main_vehicle_fly_UI_toggle then g.main_vehicle_fly_UI_toggle:Set(false, false) end
			g.notify("Warning", "You left the vehicle, Vehicle Fly has been disabled.", 1.75)
			g.stop_vehicle_fly()
			return
		end

		platform.AssemblyAngularVelocity = Vector3.zero
		local cam = workspace.CurrentCamera
		if Is_Mobile then
			bg.CFrame = cam.CFrame
			local mv = controlModule:GetMoveVector()
			local vel = Vector3.zero
			if mv.X ~= 0 then vel = vel + cam.CFrame.RightVector * (mv.X * (45 * g.vehicle_fly_speed)) end
			if mv.Z ~= 0 then vel = vel - cam.CFrame.LookVector * (mv.Z * (45 * g.vehicle_fly_speed)) end
			bv.Velocity = vel
		else
			local look = cam.CFrame.LookVector
			local yaw = math.atan2(-look.X, -look.Z)
			bg.CFrame = CFrame.new(platform.Position) * CFrame.Angles(0, yaw, 0)
			local c = g.vehiclefly_control
			local forward = (c.f or 0) + (c.b or 0)
			local right = (c.l or 0) + (c.r or 0)
			local up = (c.q or 0) + (c.e or 0)
			bv.Velocity = (cam.CFrame.LookVector * forward + cam.CFrame.RightVector * right + Vector3.new(0, up, 0)) * (45 * g.vehicle_fly_speed)
		end
	end)

	if not Is_Mobile then
		g.vehiclefly_conns.down = UserInputService.InputBegan:Connect(function(i, game_processed)
			if game_processed then return end
			if i.KeyCode == Enum.KeyCode.W then g.vehiclefly_control.f = 1  end
			if i.KeyCode == Enum.KeyCode.S then g.vehiclefly_control.b = -1 end
			if i.KeyCode == Enum.KeyCode.A then g.vehiclefly_control.l = -1 end
			if i.KeyCode == Enum.KeyCode.D then g.vehiclefly_control.r = 1  end
			if i.KeyCode == Enum.KeyCode.E then g.vehiclefly_control.q = 1  end
			if i.KeyCode == Enum.KeyCode.Q then g.vehiclefly_control.e = -1 end
		end)
		g.vehiclefly_conns.up = UserInputService.InputEnded:Connect(function(i)
			if i.KeyCode == Enum.KeyCode.W then g.vehiclefly_control.f = 0 end
			if i.KeyCode == Enum.KeyCode.S then g.vehiclefly_control.b = 0 end
			if i.KeyCode == Enum.KeyCode.A then g.vehiclefly_control.l = 0 end
			if i.KeyCode == Enum.KeyCode.D then g.vehiclefly_control.r = 0 end
			if i.KeyCode == Enum.KeyCode.E then g.vehiclefly_control.q = 0 end
			if i.KeyCode == Enum.KeyCode.Q then g.vehiclefly_control.e = 0 end
		end)
	end
end

g.stop_vehicle_fly = function()
	g.vehicle_fly = false
	g.disable_vehicle_noclip()
	g.cleanup()
	g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
	if g.main_vehicle_fly_UI_toggle then g.main_vehicle_fly_UI_toggle:Set(false, false) end
end

g.toggle_vehicle_fly = function()
	if g.vehicle_fly then
		g.stop_vehicle_fly()
	else
		g.vehicle_fly = true
		g.enable_vehicle_noclip()
		g.start_vehicle_fly()
	end
end

g.infinite_premium = g.infinite_premium or function()
	if g.GET_LOADED_IY then return end
	if g.IY_LOADED then return end
	loadstring(game:HttpGet('https://pastefy.app/b052AUgc/raw'))()
end

g.infinite_yield = g.infinite_yield or function()
	if g.IY_LOADED then return end
	if g.GET_LOADED_IY then return end
	loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end

g.find_job_updater_Remote_Function = function()
	local cache = g.job_updater_RF_found
	if cache and cache.Parent and cache:IsA("RemoteFunction") then return cache end
	for _, v in ipairs(PlayerGui:GetDescendants()) do
		if v:IsA("RemoteFunction") and v.Name:lower():find("remote") and v.Parent.Name:lower():find("role") then
			g.job_updater_RF_found = v
			return v
		end
	end

	return nil
end
wait(0.1)
if not g.job_updater_RF_found then pcall(function() g.find_job_updater_Remote_Function() end) end

g.find_RP_Text_Function_Remote_Function = function()
	local cached = g.rp_text_function_RF
	if cached and cached:IsA("RemoteFunction") and cached.Parent then return cached end
	for _, v in ipairs(PlayerGui:GetDescendants()) do
		if v:IsA("RemoteFunction") and v.Name:lower():find("text") and v.Parent.Name:lower():find("role") then
			g.rp_text_function_RF = v
			return v
		end
	end

	return nil
end
wait(0.1)
if not g.rp_text_function_RF then pcall(function() g.find_RP_Text_Function_Remote_Function() end) end

g.rainbow_RP_text_changer = function(state)
	local Text_Function_RF = g.rp_text_function_RF or g.find_RP_Text_Function_Remote_Function()
	if not Text_Function_RF or not Text_Function_RF:IsA("RemoteFunction") then return g.notify("Error", "RP Text Function RemoteFunction not found.", 3) end

	g.RP_Text_Changer_Enabled = state
	if state == true then
		FlamesLibrary.connect("RP_Text_Changer", RunService.Heartbeat:Connect(function(Delta_Time)
			g.RP_Text_Changer_Elapsed += Delta_Time
			if g.RP_Text_Changer_Elapsed < g.RP_Text_Changer_Interval then return end
			g.RP_Text_Changer_Elapsed = 0
			g.RP_Text_Changer_Index += 1
			local Color_Index = ((g.RP_Text_Changer_Index - 1) % #g.colors_color_three) + 1
			local Word_Index = ((g.RP_Text_Changer_Index - 1) % #words_list) + 1
			local Rainbow_Color = g.colors_color_three[Color_Index]
			local Rainbow_Word = words_list[Word_Index]
			local Name_Args = { "RP", Rainbow_Word, Rainbow_Color }
			local Bio_Args = { "Bio", Rainbow_Word, Rainbow_Color }
			pcall(function() Text_Function_RF:InvokeServer(unpack(Name_Args)) end)
			pcall(function() Text_Function_RF:InvokeServer(unpack(Bio_Args)) end)
		end))
		g.notify("Success", "Flames Hub | RP Text Changer is now enabled.", 3)
	elseif state == false then
		FlamesLibrary.disconnect("RP_Text_Changer")
		g.notify("Success", "Flames Hub | RP Text Changer is now disabled.", 3)
	else
		return 
	end
end

g.job_spammer_toggle = function(state)
	local tbl = g.all_jobs_collected
	if not tbl or next(tbl) == nil then
		if g.main_job_spammer_UI_toggle then g.main_job_spammer_UI_toggle:Set(false, false) end
		return g.notify("Error", "Table does not exist or is empty!", 3)
	end
	local job_changer_RF = g.job_updater_RF_found or g.find_job_updater_Remote_Function()
	if not job_changer_RF or not job_changer_RF:IsA("RemoteFunction") then
		if g.main_job_spammer_UI_toggle then g.main_job_spammer_UI_toggle:Set(false, false) end
		return g.notify("Error", "RemoteFunction: JobChanger not found or is not a RemoteFunction.", 3)
	end
	if state == true then
		if g.job_spammer_currently_enabled then return end
		g.job_spammer_currently_enabled = true
		FlamesLibrary.spawn("job_spammer_loop", "spawn", function()
			local index = 1
			while g.job_spammer_currently_enabled do
				local job_index = tbl[index]
				if job_index then job_changer_RF:InvokeServer(job_index) end
				index = index + 1
				if index > #tbl then index = 1 end
				FlamesLibrary.wait(0)
			end
		end)
	elseif state == false then
		g.job_spammer_currently_enabled = false
		FlamesLibrary.disconnect("job_spammer_loop")
	else
		return
	end
end

g.catalog_debug_lines = g.catalog_debug_lines or {}
local function dbg(msg)
	table.insert(g.catalog_debug_lines, tostring(msg))
	if setclipboard then
		pcall(function()
			setclipboard(table.concat(g.catalog_debug_lines, "\n"))
		end)
	end
end

g.catalog_equip_RF_Found    = g.catalog_equip_RF_Found or nil
g.catalog_search_results    = g.catalog_search_results or {}
g.catalog_current_cursor    = g.catalog_current_cursor or ""
g.catalog_current_page      = g.catalog_current_page or 1
g.catalog_current_category  = g.catalog_current_category or nil
g.catalog_current_query     = g.catalog_current_query or ""
g.catalog_is_fetching       = g.catalog_is_fetching or false
g.catalog_cursor_history    = g.catalog_cursor_history or {}
g.catalog_gui_visible       = g.catalog_gui_visible or false
local accessory_types = {
	Hat=true, HairAccessory=true, FaceAccessory=true, NeckAccessory=true,
	ShoulderAccessory=true, FrontAccessory=true, BackAccessory=true,
	WaistAccessory=true, TShirtAccessory=true, ShirtAccessory=true,
	PantsAccessory=true, JacketAccessory=true, SweaterAccessory=true,
	ShortsAccessory=true, LeftShoeAccessory=true, RightShoeAccessory=true,
	DressSkirtAccessory=true, EyebrowAccessory=true, EyelashAccessory=true,
}

g.catalog_equip_asset = function(asset_type_name, asset_id, extra_data)
	local rf = g.catalog_equip_RF_Found or g.find_catalog_equip_Remote_Function()
	if not rf or not rf:IsA("RemoteFunction") then
		dbg("ERROR: CatalogEquipFunction not found.")
		g.notify("Error", "CatalogEquipFunction not found.", 3)
		return false
	end

	dbg("ENTER equip_asset | type=" .. tostring(asset_type_name) .. " | id=" .. tostring(asset_id))

	local ok, err = pcall(function()
		if accessory_types[asset_type_name] then
			dbg("branch = Accessory")
			rf:InvokeServer("Accessory", {
				SaleLocationType = "NotApplicable",
				FavoriteCount    = extra_data and extra_data.FavoriteCount or 0,
				ItemType         = "Asset",
				Id               = asset_id,
				AssetType        = asset_type_name,
				PurchaseCount    = 0,
				Name             = extra_data and extra_data.Name or "",
				ProductId        = 0,
				ItemRestrictions = {},
				ItemStatus       = {},
				Price            = extra_data and extra_data.Price or 0,
			})

		elseif asset_type_name == "Shirt" or asset_type_name == "Pants"
			or asset_type_name == "TShirt" or asset_type_name == "Face"
			or asset_type_name == "Gear" then
			dbg("branch = ShirtPantsTShirtFaceGear")
			rf:InvokeServer(asset_type_name, {
				SaleLocationType = "NotApplicable",
				FavoriteCount    = extra_data and extra_data.FavoriteCount or 0,
				ItemType         = "Asset",
				Id               = asset_id,
				AssetType        = asset_type_name,
				PurchaseCount    = 0,
				Name             = extra_data and extra_data.Name or "",
				ProductId        = 0,
				ItemRestrictions = {},
				ItemStatus       = {},
				Price            = extra_data and extra_data.Price or 0,
			})

		elseif asset_type_name == "Head" then
			dbg("branch = Head")
			rf:InvokeServer("BodyPart", { AssetType = "Head", Id = asset_id })
		elseif asset_type_name == "Torso" or asset_type_name == "LeftArm"
			or asset_type_name == "RightArm" or asset_type_name == "LeftLeg"
			or asset_type_name == "RightLeg" or asset_type_name == "DynamicHead" then
			dbg("branch = BodyParts")
			rf:InvokeServer("BodyParts", { { Id = asset_id, Type = "Asset", Name = extra_data and extra_data.Name or "" } })
		elseif asset_type_name == "Animation" or asset_type_name == "AnimationBundle" then
			dbg("branch = Animation")
			rf:InvokeServer("Animations", {
				{
					Id        = asset_id,
					Type      = "Asset",
					Name      = extra_data and extra_data.Name or "",
					AssetType = extra_data and extra_data.SubAnimationType or "IdleAnimation",
				},
			})
		elseif asset_type_name == "Package" then
			dbg("branch = Package")
			rf:InvokeServer("Package", { { Id = asset_id, Type = "Asset", Name = extra_data and extra_data.Name or "" } })
		else
			dbg("NO BRANCH MATCHED for type=" .. tostring(asset_type_name))
		end
	end)

	dbg("pcall ok=" .. tostring(ok) .. " err=" .. tostring(err))

	if not ok then
		g.notify("Error", "Equip failed: " .. tostring(err), 3)
		return false
	end
	return true
end

g.catalog_fetch_page = function(query, asset_type_id, cursor)
	if g.catalog_is_fetching then return nil end
	g.catalog_is_fetching = true
	local params = CatalogSearchParams.new()
	params.SearchKeyword   = query or ""
	params.CategoryFilter  = Enum.CatalogCategoryFilter.None
	params.SalesTypeFilter = Enum.SalesTypeFilter.All
	params.IncludeOffSale  = true
	params.SortType        = Enum.CatalogSortType.Relevance
	params.Limit           = 30

	if asset_type_id and ASSET_TYPE_ID_TO_ENUM[asset_type_id] then
		params.AssetTypes = { ASSET_TYPE_ID_TO_ENUM[asset_type_id] }
	else
		params.AssetTypes = {
			Enum.AvatarAssetType.Hat,
			Enum.AvatarAssetType.HairAccessory,
			Enum.AvatarAssetType.FaceAccessory,
			Enum.AvatarAssetType.NeckAccessory,
			Enum.AvatarAssetType.ShoulderAccessory,
			Enum.AvatarAssetType.FrontAccessory,
			Enum.AvatarAssetType.BackAccessory,
			Enum.AvatarAssetType.WaistAccessory,
			Enum.AvatarAssetType.Shirt,
			Enum.AvatarAssetType.Pants,
		}
	end

	local page_number = math.max(1, g.catalog_current_page or 1)
	local ok, pages = pcall(function()
		return AvatarEditorService:SearchCatalog(params)
	end)

	if not ok or not pages then
		g.catalog_is_fetching = false
		g.notify("Error", "AvatarEditorService search failed.", 3)
		return nil
	end

	for i = 2, page_number do
		if pages.IsFinished then break end
		local adv_ok, adv_err = pcall(function()
			pages:AdvanceToNextPageAsync()
		end)
		if not adv_ok then break end
	end

	local list_ok, list = pcall(function()
		return pages:GetCurrentPage()
	end)

	if not list_ok or not list then
		g.catalog_is_fetching = false
		g.notify("Error", "Failed to get catalog page.", 3)
		return nil
	end

	local items = {}
	for _, item in ipairs(list) do
		local type_id = 0
		local type_name = "Asset"
		local type_id = 0
		local type_name = "Asset"

		if typeof(item.AssetType) == "EnumItem" then
			type_id   = item.AssetType.Value
			type_name = ASSET_TYPE_ID_TO_NAME[type_id] or item.AssetType.Name or "Asset"
		elseif type(item.AssetType) == "number" then
			type_id   = item.AssetType
			type_name = ASSET_TYPE_ID_TO_NAME[type_id] or "Asset"
		elseif type(item.AssetType) == "string" and item.AssetType ~= "" then
			type_name = item.AssetType
			local enum_ok, enum_item = pcall(function()
				return Enum.AvatarAssetType[item.AssetType]
			end)
			if enum_ok and enum_item then
				type_id = enum_item.Value
			end
		end

		local creator_name = ""
		if type(item.CreatorName) == "string" and item.CreatorName ~= "" then
			creator_name = item.CreatorName
		elseif type(item.Creator) == "table" then
			creator_name = item.Creator.Name or item.Creator.CreatorName or ""
		end

		table.insert(items, {
			id             = item.Id            or item.AssetId or 0,
			name           = item.Name          or "?",
			asset_type     = type_name,
			asset_type_id  = type_id,
			price          = item.Price         or 0,
			favorite_count = item.FavoriteCount or 0,
			creator        = creator_name,
		})
	end

	g.catalog_is_fetching = false
	if #items == 0 then
		g.notify("Info", "No results found.", 3)
		return nil
	end

	return {
		data           = items,
		nextPageCursor = not pages.IsFinished and tostring(page_number + 1) or "",
	}
end

g.catalog_build_item_list = function(data)
	if not data or not data.data then return {} end
	local items = {}
	for _, item in ipairs(data.data) do
		table.insert(items, {
			id             = item.id             or 0,
			name           = item.name           or "?",
			asset_type     = item.asset_type     or "Asset",
			asset_type_id  = item.asset_type_id  or 0,
			price          = item.price          or 0,
			favorite_count = item.favorite_count or 0,
			creator        = item.creator        or "",
		})
	end
	return items
end

local function make_corner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 8)
	c.Parent = parent
	return c
end

local function make_stroke(parent, color, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(60, 60, 80)
	s.Thickness = thickness or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

g.Modern_Catalog_Screen_Gui_System = function(state)
	local existing = CoreGui:FindFirstChild("Flames_Hub_Catalog_GUI")

	if state == false then
		if existing then
			local main_frame = existing:FindFirstChild("Main")
			if main_frame then
				TweenService:Create(main_frame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
					Size = UDim2.new(0, main_frame.AbsoluteSize.X, 0, 0),
				}):Play()
			end
			task.delay(0.26, function() if existing then existing:Destroy() end end)
		end
		g.catalog_gui_visible = false
		return
	end

	if state == true and existing then return end
	g.catalog_gui_visible = true
	local viewport    = workspace.CurrentCamera.ViewportSize
	local gui_width   = math.min(580, viewport.X - 20)
	local gui_height  = math.min(660, viewport.Y - 20)
	local screen_gui = Instance.new("ScreenGui")
	screen_gui.Name           = "Flames_Hub_Catalog_GUI"
	screen_gui.ResetOnSpawn   = false
	screen_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screen_gui.DisplayOrder   = 999
	screen_gui.Parent         = CoreGui

	local backdrop = Instance.new("Frame")
	backdrop.Size                   = UDim2.new(1, 0, 1, 0)
	backdrop.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
	backdrop.BackgroundTransparency = 0.55
	backdrop.BorderSizePixel        = 0
	backdrop.ZIndex                 = 1
	backdrop.Parent                 = screen_gui

	local main = Instance.new("Frame")
	main.Name             = "Main"
	main.AnchorPoint      = Vector2.new(0.5, 0.5)
	main.Size             = UDim2.new(0, gui_width, 0, 0)
	main.Position         = UDim2.new(0.5, 0, 0.5, 0)
	main.BackgroundColor3 = Color3.fromRGB(13, 13, 19)
	main.BorderSizePixel  = 0
	main.ClipsDescendants = true
	main.ZIndex           = 2
	main.Parent           = screen_gui
	make_corner(main, 14)
	make_stroke(main, Color3.fromRGB(45, 45, 70), 1.5)

	TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, gui_width, 0, gui_height),
	}):Play()

	if g.dragify and typeof(g.dragify) == "function" then
		g.dragify(main)
	end

	local title_bar = Instance.new("Frame")
	title_bar.Name             = "TitleBar"
	title_bar.Size             = UDim2.new(1, 0, 0, 48)
	title_bar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
	title_bar.BorderSizePixel  = 0
	title_bar.ZIndex           = 3
	title_bar.Parent           = main
	make_corner(title_bar, 14)

	local title_fix = Instance.new("Frame")
	title_fix.Size             = UDim2.new(1, 0, 0.5, 0)
	title_fix.Position         = UDim2.new(0, 0, 0.5, 0)
	title_fix.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
	title_fix.BorderSizePixel  = 0
	title_fix.ZIndex           = 3
	title_fix.Parent           = title_bar

	local title_label = Instance.new("TextLabel")
	title_label.Text                   = "🔥 Flames Catalog 🔥"
	title_label.Size                   = UDim2.new(1, -100, 1, 0)
	title_label.Position               = UDim2.new(0, 16, 0, 0)
	title_label.BackgroundTransparency = 1
	title_label.TextColor3             = Color3.fromRGB(255, 255, 255)
	title_label.Font                   = Enum.Font.GothamBold
	title_label.TextSize               = 15
	title_label.TextXAlignment         = Enum.TextXAlignment.Left
	title_label.ZIndex                 = 4
	title_label.Parent                 = title_bar

	local close_btn = Instance.new("TextButton")
	close_btn.Text             = "X"
	close_btn.Size             = UDim2.new(0, 30, 0, 30)
	close_btn.Position         = UDim2.new(1, -40, 0.5, -15)
	close_btn.BackgroundColor3 = Color3.fromRGB(190, 45, 45)
	close_btn.TextColor3       = Color3.fromRGB(255, 255, 255)
	close_btn.Font             = Enum.Font.GothamBold
	close_btn.TextSize         = 13
	close_btn.BorderSizePixel  = 0
	close_btn.ZIndex           = 4
	close_btn.Parent           = title_bar
	make_corner(close_btn, 8)

	local search_row = Instance.new("Frame")
	search_row.Size                   = UDim2.new(1, -24, 0, 36)
	search_row.Position               = UDim2.new(0, 12, 0, 56)
	search_row.BackgroundTransparency = 1
	search_row.ZIndex                 = 3
	search_row.Parent                 = main

	local search_box = Instance.new("TextBox")
	search_box.Size              = UDim2.new(1, -92, 1, 0)
	search_box.BackgroundColor3  = Color3.fromRGB(22, 22, 34)
	search_box.TextColor3        = Color3.fromRGB(220, 220, 220)
	search_box.PlaceholderText   = "Search the catalog..."
	search_box.PlaceholderColor3 = Color3.fromRGB(90, 90, 115)
	search_box.Font              = Enum.Font.Gotham
	search_box.Text              = "Search the catalog..."
	search_box.TextSize          = 13
	search_box.BorderSizePixel   = 0
	search_box.ClearTextOnFocus  = false
	search_box.ZIndex            = 4
	search_box.Parent            = search_row
	make_corner(search_box, 8)
	make_stroke(search_box, Color3.fromRGB(45, 45, 72), 1)

	local search_pad = Instance.new("UIPadding")
	search_pad.PaddingLeft = UDim.new(0, 10)
	search_pad.Parent      = search_box

	local search_btn = Instance.new("TextButton")
	search_btn.Text             = "Search"
	search_btn.Size             = UDim2.new(0, 82, 1, 0)
	search_btn.Position         = UDim2.new(1, -82, 0, 0)
	search_btn.BackgroundColor3 = Color3.fromRGB(55, 95, 245)
	search_btn.TextColor3       = Color3.fromRGB(255, 255, 255)
	search_btn.Font             = Enum.Font.GothamBold
	search_btn.TextSize         = 13
	search_btn.BorderSizePixel  = 0
	search_btn.ZIndex           = 4
	search_btn.Parent           = search_row
	make_corner(search_btn, 8)

	local cat_scroll = Instance.new("ScrollingFrame")
	cat_scroll.Size                   = UDim2.new(1, -24, 0, 30)
	cat_scroll.Position               = UDim2.new(0, 12, 0, 100)
	cat_scroll.CanvasSize             = UDim2.new(0, 0, 0, 0)
	cat_scroll.AutomaticCanvasSize    = Enum.AutomaticSize.X
	cat_scroll.ScrollBarThickness     = 0
	cat_scroll.ScrollingDirection     = Enum.ScrollingDirection.X
	cat_scroll.BackgroundTransparency = 1
	cat_scroll.ZIndex                 = 3
	cat_scroll.Parent                 = main

	local cat_layout = Instance.new("UIListLayout")
	cat_layout.FillDirection = Enum.FillDirection.Horizontal
	cat_layout.SortOrder     = Enum.SortOrder.LayoutOrder
	cat_layout.Padding       = UDim.new(0, 5)
	cat_layout.Parent        = cat_scroll

	local selected_cat_btn = nil
	local function do_search()
		g.catalog_current_cursor = ""
		g.catalog_current_page   = 1
		g.catalog_cursor_history = {}
		local data = g.catalog_fetch_page(g.catalog_current_query, g.catalog_current_category, "")
		if data then
			g.catalog_search_results = g.catalog_build_item_list(data)
			g.catalog_current_cursor = data.nextPageCursor or ""
			g.catalog_refresh_list()
		end
	end

	local function make_cat_btn(label, value, order)
		local btn = Instance.new("TextButton")
		btn.Text             = label
		btn.Size             = UDim2.new(0, math.max(52, #label * 7 + 16), 1, 0)
		btn.BackgroundColor3 = Color3.fromRGB(24, 24, 36)
		btn.TextColor3       = Color3.fromRGB(160, 160, 185)
		btn.Font             = Enum.Font.Gotham
		btn.TextSize         = 11
		btn.BorderSizePixel  = 0
		btn.LayoutOrder      = order
		btn.ZIndex           = 4
		btn.Parent           = cat_scroll
		make_corner(btn, 6)
		make_stroke(btn, Color3.fromRGB(42, 42, 65), 1)

		btn.MouseButton1Click:Connect(function()
			if selected_cat_btn and selected_cat_btn ~= btn then
				selected_cat_btn.BackgroundColor3 = Color3.fromRGB(24, 24, 36)
				selected_cat_btn.TextColor3       = Color3.fromRGB(160, 160, 185)
			end
			selected_cat_btn           = btn
			btn.BackgroundColor3       = Color3.fromRGB(55, 95, 245)
			btn.TextColor3             = Color3.fromRGB(255, 255, 255)
			g.catalog_current_category = value
			do_search()
		end)

		return btn
	end

	local all_btn = make_cat_btn("All", nil, 0)
	all_btn.BackgroundColor3 = Color3.fromRGB(55, 95, 245)
	all_btn.TextColor3       = Color3.fromRGB(255, 255, 255)
	selected_cat_btn         = all_btn

	local sorted_cats = {}
	for id, name in pairs(g.all_current_asset_types) do
		table.insert(sorted_cats, { id = id, name = name })
	end
	table.sort(sorted_cats, function(a, b) return a.name < b.name end)
	for i, cat in ipairs(sorted_cats) do
		make_cat_btn(cat.name, cat.id, i)
	end

	local divider = Instance.new("Frame")
	divider.Size             = UDim2.new(1, -24, 0, 1)
	divider.Position         = UDim2.new(0, 12, 0, 138)
	divider.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
	divider.BorderSizePixel  = 0
	divider.ZIndex           = 3
	divider.Parent           = main

	local results_label = Instance.new("TextLabel")
	results_label.Text                   = "Loading..."
	results_label.Size                   = UDim2.new(1, -24, 0, 18)
	results_label.Position               = UDim2.new(0, 12, 0, 146)
	results_label.BackgroundTransparency = 1
	results_label.TextColor3             = Color3.fromRGB(100, 100, 130)
	results_label.Font                   = Enum.Font.Gotham
	results_label.TextSize               = 11
	results_label.TextXAlignment         = Enum.TextXAlignment.Left
	results_label.ZIndex                 = 3
	results_label.Parent                 = main

	local scroll = Instance.new("ScrollingFrame")
	scroll.Name                   = "ResultsScroll"
	scroll.Size                   = UDim2.new(1, -24, 1, -216)
	scroll.Position               = UDim2.new(0, 12, 0, 168)
	scroll.CanvasSize             = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize    = Enum.AutomaticSize.Y
	scroll.ScrollBarThickness     = 4
	scroll.ScrollBarImageColor3   = Color3.fromRGB(55, 95, 245)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel        = 0
	scroll.ZIndex                 = 3
	scroll.Parent                 = main

	local list_layout = Instance.new("UIListLayout")
	list_layout.SortOrder = Enum.SortOrder.LayoutOrder
	list_layout.Padding   = UDim.new(0, 5)
	list_layout.Parent    = scroll

	local bottom_bar = Instance.new("Frame")
	bottom_bar.Size             = UDim2.new(1, 0, 0, 44)
	bottom_bar.Position         = UDim2.new(0, 0, 1, -44)
	bottom_bar.BackgroundColor3 = Color3.fromRGB(16, 16, 24)
	bottom_bar.BorderSizePixel  = 0
	bottom_bar.ZIndex           = 3
	bottom_bar.Parent           = main

	local prev_btn = Instance.new("TextButton")
	prev_btn.Text             = "◀ Prev"
	prev_btn.Size             = UDim2.new(0, 100, 0, 30)
	prev_btn.Position         = UDim2.new(0, 10, 0.5, -15)
	prev_btn.BackgroundColor3 = Color3.fromRGB(24, 24, 36)
	prev_btn.TextColor3       = Color3.fromRGB(160, 160, 185)
	prev_btn.Font             = Enum.Font.GothamBold
	prev_btn.TextSize         = 12
	prev_btn.BorderSizePixel  = 0
	prev_btn.ZIndex           = 4
	prev_btn.Parent           = bottom_bar
	make_corner(prev_btn, 6)
	make_stroke(prev_btn, Color3.fromRGB(42, 42, 65), 1)

	local page_label = Instance.new("TextLabel")
	page_label.Text                   = "Page 1"
	page_label.Size                   = UDim2.new(0, 120, 1, 0)
	page_label.Position               = UDim2.new(0.5, -60, 0, 0)
	page_label.BackgroundTransparency = 1
	page_label.TextColor3             = Color3.fromRGB(160, 160, 185)
	page_label.Font                   = Enum.Font.Gotham
	page_label.TextSize               = 12
	page_label.ZIndex                 = 4
	page_label.Parent                 = bottom_bar

	local next_btn = Instance.new("TextButton")
	next_btn.Text             = "Next ▶"
	next_btn.Size             = UDim2.new(0, 100, 0, 30)
	next_btn.Position         = UDim2.new(1, -110, 0.5, -15)
	next_btn.BackgroundColor3 = Color3.fromRGB(55, 95, 245)
	next_btn.TextColor3       = Color3.fromRGB(255, 255, 255)
	next_btn.Font             = Enum.Font.GothamBold
	next_btn.TextSize         = 12
	next_btn.BorderSizePixel  = 0
	next_btn.ZIndex           = 4
	next_btn.Parent           = bottom_bar
	make_corner(next_btn, 6)

	g.catalog_refresh_list = function()
		for _, child in ipairs(scroll:GetChildren()) do
			if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
				child:Destroy()
			end
		end

		page_label.Text = "Page " .. tostring(g.catalog_current_page)
		local count = #g.catalog_search_results
		results_label.Text = count > 0 and (tostring(count) .. " items") or "No results"

		if count == 0 then
			local empty = Instance.new("TextLabel")
			empty.Text                   = "No items found. Try a different search or category."
			empty.Size                   = UDim2.new(1, 0, 0, 60)
			empty.BackgroundTransparency = 1
			empty.TextColor3             = Color3.fromRGB(110, 110, 140)
			empty.Font                   = Enum.Font.Gotham
			empty.TextSize               = 13
			empty.TextWrapped            = true
			empty.ZIndex                 = 4
			empty.Parent                 = scroll
			return
		end

		for i, item in ipairs(g.catalog_search_results) do
			local row = Instance.new("Frame")
			row.Size             = UDim2.new(1, 0, 0, 58)
			row.BackgroundColor3 = Color3.fromRGB(20, 20, 31)
			row.BorderSizePixel  = 0
			row.LayoutOrder      = i
			row.ZIndex           = 4
			row.Parent           = scroll
			make_corner(row, 8)
			make_stroke(row, Color3.fromRGB(36, 36, 56), 1)

			local name_lbl = Instance.new("TextLabel")
			name_lbl.Text                   = item.name
			name_lbl.Size                   = UDim2.new(1, -160, 0, 24)
			name_lbl.Position               = UDim2.new(0, 12, 0, 7)
			name_lbl.BackgroundTransparency = 1
			name_lbl.TextColor3             = Color3.fromRGB(225, 225, 225)
			name_lbl.Font                   = Enum.Font.GothamBold
			name_lbl.TextSize               = 13
			name_lbl.TextXAlignment         = Enum.TextXAlignment.Left
			name_lbl.TextTruncate           = Enum.TextTruncate.AtEnd
			name_lbl.ZIndex                 = 5
			name_lbl.Parent                 = row

			local meta_lbl = Instance.new("TextLabel")
			meta_lbl.Text                   = item.asset_type .. "  •  " .. (item.creator ~= "" and item.creator .. "  •  " or "") .. (item.price > 0 and "R$" .. tostring(item.price) or "Free")
			meta_lbl.Size                   = UDim2.new(1, -160, 0, 18)
			meta_lbl.Position               = UDim2.new(0, 12, 0, 32)
			meta_lbl.BackgroundTransparency = 1
			meta_lbl.TextColor3             = Color3.fromRGB(105, 105, 135)
			meta_lbl.Font                   = Enum.Font.Gotham
			meta_lbl.TextSize               = 11
			meta_lbl.TextXAlignment         = Enum.TextXAlignment.Left
			meta_lbl.TextTruncate           = Enum.TextTruncate.AtEnd
			meta_lbl.ZIndex                 = 5
			meta_lbl.Parent                 = row

			local equip_btn = Instance.new("TextButton")
			equip_btn.Text             = "Equip"
			equip_btn.Size             = UDim2.new(0, 82, 0, 36)
			equip_btn.Position         = UDim2.new(1, -94, 0.5, -18)
			equip_btn.BackgroundColor3 = Color3.fromRGB(55, 95, 245)
			equip_btn.TextColor3       = Color3.fromRGB(255, 255, 255)
			equip_btn.Font             = Enum.Font.GothamBold
			equip_btn.TextSize         = 12
			equip_btn.BorderSizePixel  = 0
			equip_btn.ZIndex           = 5
			equip_btn.Parent           = row
			make_corner(equip_btn, 7)

			local captured = item
			equip_btn.MouseButton1Click:Connect(function()
				equip_btn.Text             = "..."
				equip_btn.BackgroundColor3 = Color3.fromRGB(36, 65, 180)

				g.notify("Info", "type=" .. tostring(captured.asset_type) .. " id=" .. tostring(captured.id), 4)

				local success = g.catalog_equip_asset(captured.asset_type, captured.id, {
					Name          = captured.name,
					Price         = captured.price,
					FavoriteCount = captured.favorite_count,
				})
				task.wait(0.35)
				equip_btn.Text             = success and "✓ Done" or "✗ Fail"
				equip_btn.BackgroundColor3 = success and Color3.fromRGB(36, 148, 72) or Color3.fromRGB(170, 45, 45)
				task.wait(1.2)
				equip_btn.Text             = "Equip"
				equip_btn.BackgroundColor3 = Color3.fromRGB(55, 95, 245)
			end)
		end
	end

	search_btn.MouseButton1Click:Connect(function()
		g.catalog_current_query = search_box.Text or ""
		do_search()
	end)

	search_box.FocusLost:Connect(function(enter)
		if enter then
			g.catalog_current_query = search_box.Text or ""
			do_search()
		end
	end)

	next_btn.MouseButton1Click:Connect(function()
		if g.catalog_current_cursor == "" then return end
		g.catalog_cursor_history[g.catalog_current_page + 1] = g.catalog_current_cursor
		local data = g.catalog_fetch_page(g.catalog_current_query, g.catalog_current_category, g.catalog_current_cursor)
		if data then
			g.catalog_search_results = g.catalog_build_item_list(data)
			g.catalog_current_cursor = data.nextPageCursor or ""
			g.catalog_current_page   = g.catalog_current_page + 1
			g.catalog_refresh_list()
		end
	end)

	prev_btn.MouseButton1Click:Connect(function()
		if g.catalog_current_page <= 1 then return end
		local prev_cursor = g.catalog_cursor_history[g.catalog_current_page] or ""
		local data = g.catalog_fetch_page(g.catalog_current_query, g.catalog_current_category, prev_cursor)
		if data then
			g.catalog_search_results = g.catalog_build_item_list(data)
			g.catalog_current_page   = g.catalog_current_page - 1
			g.catalog_current_cursor = g.catalog_cursor_history[g.catalog_current_page + 1] or ""
			g.catalog_refresh_list()
		end
	end)

	close_btn.MouseButton1Click:Connect(function()
		g.Modern_Catalog_Screen_Gui_System(false)
	end)

	task.spawn(function()
		results_label.Text = "Loading..."
		local init_data = g.catalog_fetch_page("", nil, "")
		if init_data then
			g.catalog_search_results = g.catalog_build_item_list(init_data)
			g.catalog_current_cursor = init_data.nextPageCursor or ""
			g.catalog_refresh_list()
		else
			results_label.Text = "Failed to load."
		end
	end)
end

local Atlas = loadstring(game:HttpGet("https://gitlab.com/greatest-group/experience_coding/-/raw/main/UIs/Atlas.lua?ref_type=heads", true))()
local UI = Atlas.new({
	Name = "Flames Hub | "..tostring(getgenv().Script_Version),
	ConfigFolder = "Flames_Hub_Menu_Configuration",
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
	if not creator then return g.notify("Error", "Unknown element type: " .. tostring(element_type), 10) end
	local element
	local done = false
	task.defer(function()
		element = creator()
		done = true
	end)

	while not done do task.wait() end
	if global_name then getgenv()[global_name] = element end
	return element
end

local Main_Page = UI:CreatePage("Main")
local Home_Section = Main_Page:CreateSection("Home")
local Local_Player_Section = Main_Page:CreateSection("LocalPlayer")
local Vehicle_Section = Main_Page:CreateSection("Vehicle")
local Extras_Section = Main_Page:CreateSection("Extras")

g.create_ui_element("Toggle", Vehicle_Section, {
Name = "Rainbow Vehicle (FE)",
Default = g.rainbow_vehicle_toggled or false,
Flag = "Toggle_Rainbow_Vehicle_UI",
Callback = function(state)
	g.rainbow_vehicle_toggle_func(state)
end}, "Toggle_Rainbow_Vehicle_UI")

g.create_ui_element("Input", Local_Player_Section, {
Name = "Change Height (FE)",
PlaceholderText = "Number...",
Flag = "Height_Number_Input_UI",
Callback = function(num)
	g.change_height_of_character(num)
end}, "Height_Number_Input_UI")

g.create_ui_element("Toggle", Home_Section, {
Name = "Toggle Shop Button (top left)",
Default = g.shop_gui_button_top_left_corner and g.shop_gui_button_top_left_corner.Visible or false,
Flag = "Shop_Button_Toggle_UI",
Callback = function(state)
	g.toggle_shop_button_corner(state)
end}, "Shop_Button_Toggle_UI")

g.create_ui_element("Toggle", Home_Section, {
Name = "Toggle Catalog System GUI (while moving)",
Default = g.catalog_system_GUI_found and g.catalog_system_GUI_found.Enabled or false,
Flag = "Catalog_System_Screen_Gui_Toggle_UI",
Callback = function(state)
	g.toggle_catalog_system_gui(state)
end}, "Catalog_System_Screen_Gui_Toggle_UI")

g.create_ui_element("Toggle", Local_Player_Section, {
Name = "Rainbow Name/Bio (FE)",
Default = g.RP_Text_Changer_Enabled or false,
Flag = "RainbowRolePlayNameAndBio_UI_Toggle",
Callback = function(state)
	g.rainbow_RP_text_changer(state)
end}, "RainbowRolePlayNameAndBio_UI_Toggle")

g.create_ui_element("Dropdown", Vehicle_Section, {
Name = "Spawn Any Vehicle (FE)",
Options = g.all_vehicles_collected or {},
DefaultItemSelected = tostring(getgenv().Selected_Vehicle) or "None",
ItemSelecting = true,
Flag = "SpawnAnyVehicleDropdown_UI",
Callback = function(selected)
	getgenv().Selected_Vehicle = selected
	g.spawn_vehicle_from_Remote_Event(selected)
	g.notify("Success", "Selected and spawned vehicle: "..tostring(selected), 1)
end}, "SpawnAnyVehicleDropdown_UI")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Max Speed (FE)",
Min = 1,
Max = 300,
Default = 50,
Flag = "Max_Speed_Slider",
Callback = function(value)
	g.modify_car_setting("max speed", value)
end}, "Max_Speed_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Turn Speed (FE)",
Min = 5,
Max = 100,
Default = 50,
Flag = "Turn_Speed_Slider",
Callback = function(value)
	g.modify_car_setting("turn speed", value)
end}, "Turn_Speed_Slider")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Suspension Height",
Min = 3,
Max = 10,
Default = 7,
Flag = "Suspension_Height_Slider",
Callback = function(value)
	g.modify_car_setting("suspension height", value)
end}, "Suspension_Height_Slider")

g.create_ui_element("Toggle", Vehicle_Section, {
Name = "Vehicle Spin (FE)",
Default = g.vehicle_spinning or false,
Flag = "Toggle_Vehicle_Spin_UI",
Callback = function(state)
	if state then
		g.start_vehicle_spin(g.vehicle_spin_speed)
	else
		g.stop_vehicle_spin()
	end
end}, "Toggle_Vehicle_Spin_UI")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Spin Speed",
Min = 1,
Max = 100,
Default = g.vehicle_spin_speed or 20,
Flag = "Vehicle_Spin_Speed_Slider",
Callback = function(value)
	g.vehicle_spin_speed = value
	if g.vehicle_spinning then
		g.stop_vehicle_spin()
		g.start_vehicle_spin(value)
	end
end}, "Vehicle_Spin_Speed_Slider")

g.create_ui_element("Toggle", Vehicle_Section, {
Name = "Vehicle Fly (FE)",
Default = g.vehicle_fly or false,
Flag = "Toggle_Vehicle_Fly_UI",
Callback = function(state)
	if state then
		g.vehicle_fly = true
		g.enable_vehicle_noclip()
		g.start_vehicle_fly()
	else
		g.stop_vehicle_fly()
	end
end}, "main_vehicle_fly_UI_toggle")

g.create_ui_element("Slider", Vehicle_Section, {
Name = "Vehicle Fly Speed",
Min = 1,
Max = 100,
Default = getgenv().vehicle_fly_speed or false,
Flag = "Vehicle_Fly_Speed",
Callback = function(val)
   if g.vehicle_fly then g.vehicle_fly_speed = val end
end}, "Vehicle_Fly_Speed")

g.create_ui_element("Toggle", Local_Player_Section, {
Name = "Job Spammer",
Default = g.job_spammer_currently_enabled or false,
Flag = "Toggle_Job_Spammer_UI",
Callback = function(state)
	g.job_spammer_toggle(state)
end}, "main_job_spammer_UI_toggle")

g.create_ui_element("Toggle", Extras_Section, {
Name = "Catalog GUI (FE!)",
Default = false,
Flag = "Toggle_Custom_Catalog_GUI",
Callback = function(state)
	g.Modern_Catalog_Screen_Gui_System(state)
end}, "Toggle_Custom_Catalog_GUI")

g.create_ui_element("Button", Extras_Section, {
Name = "Infinite Premium",
Callback = function()
	g.infinite_premium()
end,})

g.create_ui_element("Button", Extras_Section, {
Name = "Infinite Yield",
Callback = function()
	g.infinite_yield()
end,})