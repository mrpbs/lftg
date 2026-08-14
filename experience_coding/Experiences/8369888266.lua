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
local Raw_Version = "V1.2.0"
g.Script_Version = tostring(Raw_Version).."-RedcliffRP"
local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local localPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local UserInputService = g.UserInputService or cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local lib = getgenv().FlamesLibrary
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
g.LocalPlayer = g.LocalPlayer or localPlayer
if not g.GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://pastebin.com/raw/T25mDhBZ"))()
   wait(0.1)
   g.GlobalEnvironmentFramework_Initialized = true
end

local has_gethui = (typeof(get_hui) == "function") or (typeof(g.get_hui) == "function")
local has_gethidden = (typeof(get_hidden_gui) == "function") or (typeof(g.get_hidden_gui) == "function")
local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
if not has_gethui and not has_gethidden and not g.roblox_hidden_gui_location then
	local CoreGui = g.CoreGui or cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
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

g.toggleable_body_parts = {
	"LeftArmAmputee",
	"RightArmAmputee",
	"LeftLegAmputee",
	"RightLegAmputee"
}

g.titles = {
	"Flames | On",
	"Flames | All Stealers Blocked",
	"Flames | Anti Stealer Is Enabled",
	"Flames | Full Protection Currently Active",
	"Flames | Anti Stealer Fully Operational Right Now",
	"Flames | Every Layer Of Defense Is Online And Watching Closely",
}

g.npc_asset_ids = {
	"rbxassetid://9504547330",
	"rbxassetid://9504550484",
	"rbxassetid://9504551226",
	"rbxassetid://9504552063",
	"rbxassetid://9504548892",
	"rbxassetid://9504549094",
	"rbxassetid://9504552379",
	"rbxassetid://9504554007",
	"rbxassetid://9504552648",
	"rbxassetid://9504546803",
}

g.carry_player_options = {
	"Carry2",
	"Piggyback",
	"Shoulder",
	"Carry1",
}

local function AntiRagdollTick()
	local Character = g.Character or LocalPlayer.Character or g.get_char(LocalPlayer, 10)
	if not Character then return end
	local Humanoid = g.Humanoid or Character:FindFirstChildOfClass("Humanoid") or g.get_human(LocalPlayer, 10)
	if not Humanoid then return end
	local HRP = g.HumanoidRootPart or Character:FindFirstChild("HumanoidRootPart") or g.get_root(LocalPlayer, 10)
	if not HRP then return end
	local Weld = HRP:FindFirstChild("HrpLowerTorsoWeld")
	if Weld then Weld.Enabled = false end
	local state = Humanoid:GetState()
	if state == Enum.HumanoidStateType.Ragdoll then
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		task.wait()
		Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end

	Humanoid:SetStateEnabled(Enum.HumanoidStateType.GettingUp, true)
	Humanoid:ChangeState(Enum.HumanoidStateType.Running)
	for _, v in ipairs(CoreGui:GetDescendants()) do
		if v:IsA("ModuleScript") and v.Name:lower():find("ragdoll") then
			v:Destroy()
		end
	end
	task.wait(0.15)
	for _, v in ipairs(g.Character:GetDescendants()) do
		if v:IsA("PackageLink") and v:IsDescendantOf(g.Character:FindFirstChildOfClass("Folder")) then
			v:Destroy()
		end
	end
end

if not lib.is_alive("AntiRagdoll_Heartbeat") then
	lib.connect("AntiRagdoll_Heartbeat", RunService.Heartbeat:Connect(function()
		pcall(AntiRagdollTick)
	end))
	g.notify("Success", "Anti Ragdoll is now running.", 5)
end
if not g.LocalPlayer then g.notify("Warning", "g.LocalPlayer missing or has not been created yet, creating...", 10) end
if not g.LocalPlayer then g.LocalPlayer = g.Players.LocalPlayer or game.Players.LocalPlayer end
local PlayerScripts = g.LocalPlayer:FindFirstChildOfClass("PlayerScripts")
local prefix = "is"
local suffixes = {"bundle", "pass", "slot", "vip"}
local function ends_with_any(name_lower, list)
	for _, suffix in ipairs(list) do
		if name_lower:sub(-#suffix) == suffix then
			return true
		end
	end
	return false
end

local prefix_lower = prefix:lower()
local suffixes_lower = {}
for i, suffix in ipairs(suffixes) do suffixes_lower[i] = suffix:lower() end
for _, v in ipairs(g.LocalPlayer:GetChildren()) do
	if v:IsA("BoolValue") then
		local name_lower = v.Name:lower()
		if name_lower:sub(1, #prefix_lower) == prefix_lower and ends_with_any(name_lower, suffixes_lower) then
			if not v.Value then
				v.Value = true
			end
		end
	end
end

g.check_private_server = g.check_private_server or function()
	local private_server
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
	if check_one and check_one.Value == g.LocalPlayer.UserId then
		return true
	else
		return false
	end

	return nil
end

g.get_vehicle_folder_main = g.get_vehicle_folder_main or function()
	local cache = g.vehicle_folder_path_main
	if cache and cache:IsA("Folder") and cache.Parent then
		return cache
	end

	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Folder") and v.Name:lower():find("vehicles") and v.Parent.Name:lower():find("shared") then
			g.vehicle_folder_path_main = v
			return v
		end
	end

	return nil
end

if not g.vehicle_folder_path_main then pcall(function() g.get_vehicle_folder_main() end) end
wait(0.25)
g.get_vehicle = g.get_vehicle or function()
	local folder = g.vehicle_folder_path_main
	if not folder then return g.notify("Error", "Vehicles Folder not found!", 5) end
	for _, v in ipairs(folder:GetChildren()) do
		if v:FindFirstChild("Owner") and v.Owner.Value == g.LocalPlayer then
			return v
		end
	end

	return nil
end

g.current_vehicle = g.current_vehicle or nil
g.polling_seating_in_Flames_Hub = g.polling_seating_in_Flames_Hub or false
g.refresh_vehicle_cache = g.refresh_vehicle_cache or function() g.current_vehicle = g.get_vehicle() end
g.start_vehicle_seat_tracker = g.start_vehicle_seat_tracker or function()
	g.polling_seating_in_Flames_Hub = true
	getgenv().FlamesLibrary.spawn("vehicle_seat_tracker", "spawn", function()
		local last_sit_state = nil
		local last_seat = nil

		while g.polling_seating_in_Flames_Hub do
			local ok = pcall(function()
				local Humanoid = g.Humanoid or (g.Character and g.Character:FindFirstChildWhichIsA("Humanoid")) or g.get_human(g.LocalPlayer, 10)
				if Humanoid then
					local sit = Humanoid.Sit
					local seat = Humanoid.SeatPart

					if sit ~= last_sit_state or seat ~= last_seat then
						last_sit_state = sit
						last_seat = seat
						g.refresh_vehicle_cache()
					end
				end
			end)

			if not ok then
				last_sit_state = nil
				last_seat = nil
			end

			getgenv().FlamesLibrary.wait(0.25)
		end
	end)
end

g.stop_vehicle_seat_tracker = g.stop_vehicle_seat_tracker or function()
	g.polling_seating_in_Flames_Hub = false
	getgenv().FlamesLibrary.disconnect("vehicle_seat_tracker")
end

g.VehicleDestroyer_Enabled = g.VehicleDestroyer_Enabled or false
g.vehicle_parts_cache = g.vehicle_parts_cache or {}
local lib = getgenv().FlamesLibrary
local _uid = 0
local function make_key(prefix, inst) _uid = _uid + 1 return prefix .. "_" .. tostring(inst):gsub("[^%w]", "") .. "_" .. _uid end
local function is_in_vehicle(obj, vehicle) return vehicle and obj and obj:IsDescendantOf(vehicle) end
local function process_veh_part(part)
	if not part:IsA("BasePart") then return end
	if g.vehicle_parts_cache[part] then return end
	local my_vehicle = get_vehicle and get_vehicle()
	if my_vehicle and is_in_vehicle(part, my_vehicle) then return end
	part.CanCollide = false
	g.vehicle_parts_cache[part] = true

	local key = make_key("VehicleDestroyer_PartCleanup", part)
	lib.connect(key, part.AncestryChanged:Connect(function()
		if not part:IsDescendantOf(game) then
			g.vehicle_parts_cache[part] = nil
			lib.disconnect(key)
		end
	end))
end

local function process_veh_model(model)
	if not model or not model.Parent then
		local elapsed = 0
		repeat task.wait(0.5) elapsed = elapsed + 0.5 until (model and model.Parent) or elapsed >= 10
		if not model or not model.Parent then return end
	end
	local key = make_key("VehicleDestroyer_ModelCleanup", model)
	for _, inst in ipairs(model:GetDescendants()) do
		if inst:IsA("BasePart") then
			process_veh_part(inst)
		end
	end

	lib.connect(make_key("VehicleDestroyer_DescAdded", model), model.DescendantAdded:Connect(function(desc)
		if not g.VehicleDestroyer_Enabled then return end
		if desc:IsA("BasePart") then
			process_veh_part(desc)
		end
	end))
end

local function setup_vehicles_folder(folder)
	for _, child in ipairs(folder:GetChildren()) do
		if child:IsA("Model") then
			process_veh_model(child)
		elseif child:IsA("BasePart") then
			process_veh_part(child)
		end
	end

	if lib.is_alive("VehicleDestroyer_ChildAdded") then lib.disconnect("VehicleDestroyer_ChildAdded") end
	wait(0.25)
	lib.connect("VehicleDestroyer_ChildAdded", folder.ChildAdded:Connect(function(child)
		if not g.VehicleDestroyer_Enabled then return end
		if child:IsA("Model") then
			process_veh_model(child)
		elseif child:IsA("BasePart") then
			process_veh_part(child)
		end
	end))

	if g.notify then g.notify("Success", "Flames Hub | Anti Vehicle Fling is now enabled.", 5) end
end

local function clear_all()
   g.VehicleDestroyer_Enabled = false
   table.clear(g.vehicle_parts_cache)
   lib.cleanup_all()
end

g.anti_car_fling = g.anti_car_fling or function(state)
	if state == true then
		if g.VehicleDestroyer_Enabled then
			if g.notify then
				g.notify("Warning", "Flames Hub | Anti Vehicle Fling is already enabled.", 5)
			end
			return 
		end

		g.VehicleDestroyer_Enabled = true
		table.clear(g.vehicle_parts_cache)
		local vehicles_folder = g.vehicle_folder_path_main or g.get_vehicle_folder_main()
		if vehicles_folder then setup_vehicles_folder(vehicles_folder) end
		lib.connect("VehicleDestroyer_FolderWatch", Workspace.DescendantAdded:Connect(function(desc)
			if not g.VehicleDestroyer_Enabled then return end
			if desc:IsA("Folder") then
				local resolved = g.vehicle_folder_path_main or g.get_vehicle_folder_main()
				if resolved == desc then
					setup_vehicles_folder(desc)
				end
			end
		end))
	elseif state == false then
		if not g.VehicleDestroyer_Enabled then
			if g.notify then
				g.notify("Warning", "Anti Vehicle Fling not enabled.", 5)
			end
			return 
		end

		clear_all()
		if g.notify then g.notify("Success", "Anti Vehicle Fling disabled.", 5) end
	end
end

g.start_vehicle_seat_tracker()
g.get_knit_services_folder = g.get_knit_services_folder or function()
   local cache = g.main_services_folder
	if cache and cache:IsA("Folder") and cache.Parent then
		return cache
	end

	for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
		if v:IsA("Folder") and v.Name:lower():find("services") and v.Parent and v.Parent.ClassName == "ModuleScript" and v.Parent.Name:lower():find("knit") then
			g.main_services_folder = v
			return v
		end
	end

	return nil
end

g.init_knit_services = g.init_knit_services or function()
	if g._knit_services_initialized then
		return true, g._knit_services_registry
	end

	local services_folder = g.get_knit_services_folder()
	if not services_folder then
		return false, "Services folder could not be located"
	end

	g.ServicesFolder = services_folder
	g._knit_services_registry = g._knit_services_registry or {}
	local total_remotes = 0

	for _, service in ipairs(services_folder:GetChildren()) do
		if service:IsA("Folder") then
			local base_name = service.Name
			local entry = {instance = service, RF = nil, RE = nil}
			g[base_name] = service
			local rf = service:FindFirstChild("RF")
			if rf and rf:IsA("Folder") then
				g[base_name .. "_RF"] = rf
				entry.RF = rf
				total_remotes += #rf:GetChildren()
			end

			local re = service:FindFirstChild("RE")
			if re and re:IsA("Folder") then
				g[base_name .. "_RE"] = re
				entry.RE = re
				total_remotes += #re:GetChildren()
			end

			g._knit_services_registry[base_name] = entry
		end
	end

	g._knit_services_initialized = true
	return true, g._knit_services_registry, total_remotes
end

g.get_remote = g.get_remote or function(service_name, remote_type, remote_name)
	local ok, registry, _ = g.init_knit_services()
	if not ok then return nil, registry end
	local entry = registry[service_name]
	if not entry then
		return nil, "service \"" .. service_name .. "\" not found"
	end

	local container = entry[remote_type]
	if not container then
		return nil, "service \"" .. service_name .. "\" has no " .. remote_type .. " folder"
	end

	local remote = container:FindFirstChild(remote_name)
	if not remote then
		return nil, "remote \"" .. remote_name .. "\" not found in " .. service_name .. "." .. remote_type
	end

	return remote
end

local ok, result, total_remotes = g.init_knit_services()
if ok then
	if g.notify then
		g.notify("Success", "Knit services initialized (" .. (total_remotes or 0) .. " remotes)", 5)
	end
else
	if g.notify then
		g.notify("Error", tostring(result), 15)
	else
		warn(tostring(result))
	end
end

g.rainbow_car_enabled = g.rainbow_car_enabled or false
g.rainbow_car_speed = g.rainbow_car_speed or 0
g.set_vehicle_colors_all = g.set_vehicle_colors_all or function(color)
	local vehicle = g.get_vehicle and g.get_vehicle()
	if not vehicle then
		return false, "no current vehicle"
	end

	local colors_container = vehicle:FindFirstChild("Frame") and vehicle.Frame.Colors or vehicle:FindFirstChild("Body") and vehicle.Body.Colors
	if not colors_container then
		return false, "no Colors container found on vehicle"
	end

	local current_colors = {}
	local current_materials = {}
	for _, c in pairs(colors_container:GetChildren()) do
		local idx = tonumber(c.Name)
		if idx then
			current_colors[idx] = color:ToHex()
			local mat = c.Color3:GetAttribute("MaterialEnumString")
			if mat then
				current_materials[idx] = mat
			end
		end
	end

	local remote, err = g.get_remote("VehiclesService", "RE", "RequestSetVehicleColorAndMaterial")
	if not remote then
		return false, err
	end

	remote:FireServer(current_colors, current_materials)
	return true
end

g.toggle_rainbow_car = g.toggle_rainbow_car or function(state)
	if state == nil then state = not g.rainbow_car_enabled end
	g.rainbow_car_enabled = state

	if state then
		FlamesLibrary.spawn("rainbow_car_loop", "spawn", function()
			local color_index = 1
			while g.rainbow_car_enabled == true do
				local color = g.colors[color_index]
				if color then g.set_vehicle_colors_all(color) end
				color_index = color_index % #g.colors + 1
				FlamesLibrary.wait(g.rainbow_car_speed)
			end
		end)
	else
		FlamesLibrary.disconnect("rainbow_car_loop")
	end

	return state
end

g.toggle_all_wheels_on_vehicle = g.toggle_all_wheels_on_vehicle or function(state)
	local car = g.get_vehicle()
	if not car then
		if g.toggle_flash_all_wheels_UI_switch then g.toggle_flash_all_wheels_UI_switch:Set(false, false) end
		return g.notify("Error", "You do not have a Vehicle spawned, spawn one.", 5)
	end
	local Remote_Event = car:FindFirstChildOfClass("RemoteEvent")

	if state == true then
		if g.flash_all_wheels then return end
		g.flash_all_wheels = true
		while g.flash_all_wheels == true do
		task.wait(0)
			if not Remote_Event then g.flash_all_wheels = false end
			for i = 1, 4 do task.wait() Remote_Event:FireServer("ToggleWheel", i) end
		end
	elseif state == false then
		g.flash_all_wheels = false
		wait(0.5)
		if getgenv().notify then getgenv().notify("Success", "Restoring all wheels...", 1) end
		for _, v in ipairs(car:GetDescendants()) do
			if v:IsA("Model") and v.Name:lower():find("wheels") and v.Parent.Name:lower():find("chassis") then
				for _, k in ipairs(v:GetChildren()) do
					if k:IsA("Model") and k:FindFirstChild("DESTROY") then
						Remote_Event:FireServer("ToggleWheel", k.Name)
					end
				end
			end
		end
	else
		return 
	end
end

g.toggle_job_spammer_FE = g.toggle_job_spammer_FE or function(state)
	if state == true then
		g.job_spammer_FE = true
		while g.job_spammer_FE == true do
		task.wait(0)
			for _, job in ipairs(g.all_available_jobs) do
				local remote, err = g.get_remote("PlayersService", "RE", "UpdatePlayerRoleplayJob")
				if not remote or not remote:IsA("RemoteEvent") then g.job_spammer_FE = false return g.notify("Error", "RemoteEvent: UpdatePlayerRoleplayJob does not exist or is not a RemoteEvent!", 5) end
				remote:FireServer(tostring(job))
				task.wait(0)
			end
		end
	elseif state == false then
		g.job_spammer_FE = false
		wait(1)
		local remote, err = g.get_remote("PlayersService", "RE", "UpdatePlayerRoleplayJob")
		if not remote or not remote:IsA("RemoteEvent") then g.job_spammer_FE = false return g.notify("Error", "RemoteEvent: UpdatePlayerRoleplayJob does not exist or is not a RemoteEvent!", 5) end
		remote:FireServer("")
	else
		return 
	end
end

g.toggle_arms_and_legs_instantly = g.toggle_arms_and_legs_instantly or function(state)
	if state == true then
		g.spamming_legs_and_arms_FE = true
		while g.spamming_legs_and_arms_FE == true do
		task.wait(0)
			for _, part in ipairs(g.toggleable_body_parts) do
				local remote, err = g.get_remote("PlayersService", "RE", "UpdatePlayerRoleplayStatus")
				if not remote or not remote:IsA("RemoteEvent") then g.spamming_legs_and_arms_FE = false return g.notify("Error", "RemoteEvent: UpdatePlayerRoleplayStatus does not exist or is not a RemoteEvent!", 5) end
				remote:FireServer(tostring(part))
				task.wait(0)
			end
		end
	elseif state == false then
		g.spamming_legs_and_arms_FE = false
		wait(0.5)
		local Char = g.Character or g.LocalPlayer.Character or g.get_char(LocalPlayer, 5)
		local function is_transparent(part_name)
			local part = Char:FindFirstChild(part_name)
			return part and part:IsA("BasePart") and part.Transparency == 1
		end

		local checks = {
			LeftArmAmputee = {"LeftHand", "LeftLowerArm", "LeftUpperArm"},
			RightArmAmputee = {"RightHand", "RightLowerArm", "RightUpperArm"},
			LeftLegAmputee = {"LeftFoot", "LeftLowerLeg", "LeftUpperLeg"},
			RightLegAmputee = {"RightFoot", "RightLowerLeg", "RightUpperLeg"},
		}

		local remote, err = g.get_remote("PlayersService", "RE", "UpdatePlayerRoleplayStatus")
		if not remote or not remote:IsA("RemoteEvent") then
			return g.notify("Error", "RemoteEvent: UpdatePlayerRoleplayStatus does not exist or is not a RemoteEvent!", 5)
		end

		for status_name, parts in pairs(checks) do
			for _, part_name in ipairs(parts) do
				if is_transparent(part_name) then
					remote:FireServer(status_name)
					break
				end
			end
		end
	else
		return 
	end
end

g.toggle_pregnant_belly_rainbow_colors = g.toggle_pregnant_belly_rainbow_colors or function(state)
	if state == true then
		g.rainbow_pregnant_belly = true
		while g.rainbow_pregnant_belly == true do
		task.wait(0)
			for _, color in ipairs(g.colors_color_three) do
				local remote, err = g.get_remote("PlayersService", "RE", "UpdatePlayerRoleplayStatus")
				if not remote or not remote:IsA("RemoteEvent") then g.rainbow_pregnant_belly = false return g.notify("Error", "RemoteEvent: UpdatePlayerRoleplayStatus does not exist or is not a RemoteEvent!", 5) end
				remote:FireServer("Maternity", color)
				task.wait(0)
			end
		end
	elseif state == false then
		g.rainbow_pregnant_belly = false
		repeat task.wait(1.50) until not g.rainbow_pregnant_belly
		local Char = g.Character or g.LocalPlayer.Character or get_char(LocalPlayer, 5)
		if not Char then return g.notify("Error", "Character does not exist.", 5) end
		for _, v in ipairs(Char:FindFirstChild("LowerTorso"):GetChildren()) do
			if v.Name == "Bump" then
				if g.notify then g.notify("Info", "Removing 'Bump' Part on stomach.", 0.75) end
				local remote, err = g.get_remote("PlayersService", "RE", "UpdatePlayerRoleplayStatus")
				if not remote or not remote:IsA("RemoteEvent") then g.rainbow_pregnant_belly = false return g.notify("Error", "RemoteEvent: UpdatePlayerRoleplayStatus does not exist or is not a RemoteEvent!", 5) end
				remote:FireServer("Maternity")
				break
			end
		end
	else
		return 
	end
end

g.vehicle_fly = g.vehicle_fly or false
g.vehicle_fly_speed = g.vehicle_fly_speed or 3
g.vehiclefly_conns = g.vehiclefly_conns or {}
g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
g.vehiclefly_noclip = g.vehiclefly_noclip or false
g.vehiclefly_collisions = g.vehiclefly_collisions or {}
g.vehiclefly_noclip_parts = g.vehiclefly_noclip_parts or {}
local controlModule
if UserInputService.TouchEnabled then controlModule = require(g.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule")) end

g.get_vehicle_base = g.get_vehicle_base or function(car)
	return car.PrimaryPart
		or car:FindFirstChild("Base")
		or car:FindFirstChildWhichIsA("VehicleSeat", true)
		or car:FindFirstChildWhichIsA("Seat", true)
		or car:FindFirstChildWhichIsA("BasePart", true)
end

g.enable_vehicle_noclip = g.enable_vehicle_noclip or function(car)
	if g.vehiclefly_noclip then return end
	g.vehiclefly_noclip = true
	g.vehiclefly_collisions = {}
	g.vehiclefly_noclip_parts = {}
	car = car or g.get_vehicle()
	if not car then
		if g.vehicle_noclip_switch_UI then g.vehicle_noclip_switch_UI:Set(false, false) end
		return
	end
	local char = g.Character or g.LocalPlayer.Character or get_char(LocalPlayer, 10)

	for _, v in ipairs(car:GetDescendants()) do
		if v:IsA("BasePart") then
			g.vehiclefly_collisions[v] = v.CanCollide
			v.CanCollide = false
			table.insert(g.vehiclefly_noclip_parts, v)
		end
	end

	if char then
		for _, v in ipairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				g.vehiclefly_collisions[v] = v.CanCollide
				v.CanCollide = false
				table.insert(g.vehiclefly_noclip_parts, v)
			end
		end
	end
end

g.disable_vehicle_noclip = g.disable_vehicle_noclip or function()
	if not g.vehiclefly_noclip then return end
	g.vehiclefly_noclip = false
	for part, state in pairs(g.vehiclefly_collisions) do
		if part and part.Parent then
			part.CanCollide = state
		end
	end
	g.vehiclefly_collisions = {}
	g.vehiclefly_noclip_parts = {}
end

g.start_vehicle_fly = g.start_vehicle_fly or function()
	if g.vehiclefly_bg or g.vehiclefly_bv then return end
	local car = g.get_vehicle()
	if not car then
		if g.vehicle_fly_switch_UI then g.vehicle_fly_switch_UI:Set(false, false) end
		getgenv().notify("Error", "You do not have a Vehicle spawned.", 5)
		return
	end
	local base = g.get_vehicle_base(car)
	if not base then
		if g.vehicle_fly_switch_UI then g.vehicle_fly_switch_UI:Set(false, false) end
		getgenv().notify("Error", "Could not find a valid base part on the Vehicle.", 5)
		return
	end
	local cam = workspace.CurrentCamera
	g.vehiclefly_saved_camera_type = cam.CameraType
	g.vehiclefly_saved_camera_subject = cam.CameraSubject
	local char = g.Character or g.LocalPlayer.Character or get_char(LocalPlayer, 10)
	local hum = g.Humanoid or char and char:FindFirstChildOfClass("Humanoid") or g.get_human(LocalPlayer, 10)
	if hum then
		cam.CameraType = Enum.CameraType.Custom
		cam.CameraSubject = hum
	end

	local bg = Instance.new("BodyGyro")
	bg.P = 3e4
	bg.D = 1e3
	bg.MaxTorque = Vector3.new(0, 9e9, 0)
	bg.CFrame = base.CFrame
	bg.Parent = base

	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.Velocity = Vector3.zero
	bv.Parent = base

	g.vehiclefly_bg = bg
	g.vehiclefly_bv = bv
	g.vehiclefly_conns.render = RunService.Heartbeat:Connect(function()
		if not g.vehicle_fly or not base.Parent then
			bv.Velocity = Vector3.zero
			g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
			return
		end

		if not car then
			if g.vehicle_fly_switch_UI then g.vehicle_fly_switch_UI:Set(false, false) end
			bv.Velocity = Vector3.zero
			g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
			return 
		end

		if g.vehiclefly_noclip then
			for _, part in ipairs(g.vehiclefly_noclip_parts) do
				if part and part.Parent and part.CanCollide then
					part.CanCollide = false
				end
			end
		end

		base.AssemblyAngularVelocity = Vector3.zero
		local cam = workspace.CurrentCamera
		if isMobile then
			bg.CFrame = cam.CFrame
			local mv = controlModule:GetMoveVector()
			local vel = Vector3.zero
			if mv.X ~= 0 then vel = vel + cam.CFrame.RightVector * (mv.X * (45 * g.vehicle_fly_speed)) end
			if mv.Z ~= 0 then vel = vel - cam.CFrame.LookVector * (mv.Z * (45 * g.vehicle_fly_speed)) end
			bv.Velocity = vel
		else
			local look = cam.CFrame.LookVector
			local yaw = math.atan2(-look.X, -look.Z)
			bg.CFrame = CFrame.new(base.Position) * CFrame.Angles(0, yaw, 0)
			local c = g.vehiclefly_control
			local forward = (c.f or 0) + (c.b or 0)
			local right = (c.l or 0) + (c.r or 0)
			local up = (c.q or 0) + (c.e or 0)
			bv.Velocity = (cam.CFrame.LookVector * forward + cam.CFrame.RightVector * right + Vector3.new(0, up, 0)) * (45 * g.vehicle_fly_speed)
		end
	end)

	if not isMobile then
		g.vehiclefly_conns.down = UserInputService.InputBegan:Connect(function(i, gp)
			if gp then return end
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

g.cleanup = g.cleanup or function()
	for _, c in pairs(g.vehiclefly_conns) do pcall(function() c:Disconnect() end) end
	g.vehiclefly_conns = {}
	if g.vehiclefly_bv then
		g.vehiclefly_bv.Velocity = Vector3.zero
		g.vehiclefly_bv:Destroy()
		g.vehiclefly_bv = nil
	end

	if g.vehiclefly_bg then
		g.vehiclefly_bg:Destroy()
		g.vehiclefly_bg = nil
	end

	local cam = workspace.CurrentCamera
	if g.vehiclefly_saved_camera_type then
		cam.CameraType = g.vehiclefly_saved_camera_type
		g.vehiclefly_saved_camera_type = nil
	end
	if g.vehiclefly_saved_camera_subject then
		cam.CameraSubject = g.vehiclefly_saved_camera_subject
		g.vehiclefly_saved_camera_subject = nil
	end
end

g.stop_vehicle_fly = g.stop_vehicle_fly or function()
	g.vehicle_fly = false
	g.disable_vehicle_noclip()
	g.cleanup()
	g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
	if g.vehicle_noclip_switch_UI then g.vehicle_noclip_switch_UI:Set(false, false) end
end

g.toggle_vehicle_fly = g.toggle_vehicle_fly or function()
	if g.vehicle_fly then
		g.stop_vehicle_fly()
	else
		local car = g.get_vehicle()
		if not car then
			if g.vehicle_fly_switch_UI then g.vehicle_fly_switch_UI:Set(false, false) end
			return g.notify("Error", "You do not have a Vehicle spawned.", 3)
		end
		local human = g.Humanoid or g.Character:FindFirstChildWhichIsA("Humanoid") or g.get_human(LocalPlayer, 10)
		if not human then
			if g.vehicle_fly_switch_UI then g.vehicle_fly_switch_UI:Set(false, false) end
			return g.notify("Error", "No Humanoid found inside your Character.", 5)
		end
		local vehicle_seat
		local seated_in_the_car
		for _, v in ipairs(car:GetDescendants()) do
			if v:IsA("VehicleSeat") then
				vehicle_seat = v
			end
		end
		wait(0.15)
		if human and human.Sit and human.SeatPart == vehicle_seat then
			seated_in_the_car = true
		else
			seated_in_the_car = false
			if g.vehicle_fly_switch_UI then g.vehicle_fly_switch_UI:Set(false, false) end
			return g.notify("Error", "You need to actually sit in your Vehicle for this to work properly.", 5)
		end
		g.vehicle_fly = true
		g.start_vehicle_fly()
	end
end

g.toggle_vehicle_noclip = g.toggle_vehicle_noclip or function(state)
	if state then
		local car = g.get_vehicle()
		if not car then
			if g.vehicle_noclip_switch_UI then g.vehicle_noclip_switch_UI:Set(false, false) end
			return g.notify("Error", "You do not have a Vehicle spawned.", 5)
		end
		g.enable_vehicle_noclip(car)
	else
		g.disable_vehicle_noclip()
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

	Flames_Library.connect(key,
		humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
			if not g.anti_sit_enabled then return end
			if humanoid.Sit then
				humanoid.Sit = false
			end
		end)
	)
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

g.get_old_name_for_title = g.get_old_name_for_title or function()
	local Head = g.Head or g.Character:FindFirstChild("Head") or g.get_head(LocalPlayer, 10)
	if not Head then return g.notify("Error", "Head does not exist!", 5) end
	local character_billboard = Head:FindFirstChildOfClass("BillboardGui")
	if not character_billboard or not character_billboard:IsA("BillboardGui") then return g.notify("Error", "CharacterBillboardGui does not exist or is not a BillboardGui.", 5) end
	local content_frame = character_billboard:FindFirstChildOfClass("Frame")
	if not content_frame or not content_frame:IsA("Frame") then return g.notify("Error", "Frame: Content does not exist or is not a Frame.", 5) end

	for _, v in ipairs(content_frame:GetChildren()) do
		if v:IsA("Frame") and (v.Name == "Title" or v.Name == "title") then
			local text_label = v:FindFirstChildOfClass("TextLabel")
			if text_label and text_label:IsA("TextLabel") then
				g.cached_title_name_roleplay_name = text_label.Text
				return text_label.Text
			end
		end
	end

	return nil
end

g.get_old_bio_for_title = g.get_old_bio_for_title or function()
	local Head = g.Head or g.Character:FindFirstChild("Head") or g.get_head(LocalPlayer, 10)
	if not Head then return g.notify("Error", "Head does not exist!", 5) end
	local character_billboard = Head:FindFirstChildOfClass("BillboardGui")
	if not character_billboard or not character_billboard:IsA("BillboardGui") then return g.notify("Error", "CharacterBillboardGui does not exist or is not a BillboardGui.", 5) end
	local content_frame = character_billboard:FindFirstChildOfClass("Frame")
	if not content_frame or not content_frame:IsA("Frame") then return g.notify("Error", "Frame: Content does not exist or is not a Frame.", 5) end

	for _, v in ipairs(content_frame:GetChildren()) do
		if v:IsA("Frame") and (v.Name == "Subtitle" or v.Name == "subtitle" or v.Name == "SUBTITLE") then
			local text_label = v:FindFirstChildOfClass("TextLabel")
			if text_label and text_label:IsA("TextLabel") then
				g.cached_title_string_roleplay_bio = text_label.Text
				return text_label.Text
			end
		end
	end

	return nil
end
wait(0.15)
g.cached_title_name_roleplay_name = g.cached_title_name_roleplay_name or g.get_old_name_for_title()
g.cached_title_string_roleplay_bio = g.cached_title_string_roleplay_bio or g.get_old_bio_for_title()
g.rainbow_name_flasher_toggled = g.rainbow_name_flasher_toggled or function(state)
	if state == true then
		g.flash_rainbow_name_enabled = true
		while g.flash_rainbow_name_enabled == true do
			task.wait(0.07)
			for _, color in ipairs(g.colors_color_three) do
				local remote, err = g.get_remote("PlayersService", "RE", "UpdatePlayerRoleplayName")
				if not remote or not remote:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: UpdatePlayerRoleplayName does not exist or is not a RemoteEvent!", 5) end
				local title = g.titles[math.random(#g.titles)]
				remote:FireServer(title, color)
				task.wait(0.05)
			end
		end
	elseif state == false then
		g.flash_rainbow_name_enabled = false
		local old_name = g.cached_title_name_roleplay_name or g.get_old_name_for_title()
		if not old_name then return end
		task.wait(0.15)
		local remote, err = g.get_remote("PlayersService", "RE", "UpdatePlayerRoleplayName")
		if not remote or not remote:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: UpdatePlayerRoleplayName does not exist or is not a RemoteEvent!", 5) end
		remote:FireServer(tostring(old_name), Color3.new(1, 1, 1))
	else
		return
	end
end

g.rainbow_bio_flasher_toggled = g.rainbow_bio_flasher_toggled or function(state)
	if state == true then
		g.flash_rainbow_bio_enabled = true
		while g.flash_rainbow_bio_enabled == true do
			task.wait(0.07)
			for _, color in ipairs(g.colors_color_three) do
				local remote, err = g.get_remote("PlayersService", "RE", "UpdatePlayerRoleplayBio")
				if not remote or not remote:IsA("RemoteEvent") then g.flash_rainbow_bio_enabled = false return g.notify("Error", "RemoteEvent: UpdatePlayerRoleplayBio does not exist or is not a RemoteEvent!", 5) end
				local title = g.titles[math.random(#g.titles)]
				remote:FireServer(title, color)
				task.wait(0.05)
			end
		end
	elseif state == false then
		g.flash_rainbow_bio_enabled = false
		local old_bio = g.cached_title_string_roleplay_bio or g.get_old_bio_for_title()
		if not old_bio then return end
		task.wait(0.15)
		local remote, err = g.get_remote("PlayersService", "RE", "UpdatePlayerRoleplayBio")
		if not remote or not remote:IsA("RemoteEvent") then g.flash_rainbow_bio_enabled = false return g.notify("Error", "RemoteEvent: UpdatePlayerRoleplayBio does not exist or is not a RemoteEvent!", 5) end
		remote:FireServer(tostring(old_bio), Color3.new(1, 1, 1))
	else
		return
	end
end

g.rainbow_name_flasher_toggled = g.rainbow_name_flasher_toggled or function(state)
	if state == true then
		g.flash_rainbow_name_enabled = true
		while g.flash_rainbow_name_enabled == true do
			task.wait(0.07)
			for _, color in ipairs(g.colors_color_three) do
				local remote, err = g.get_remote("PlayersService", "RE", "UpdatePlayerRoleplayName")
				if not remote or not remote:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: UpdatePlayerRoleplayName does not exist or is not a RemoteEvent!", 5) end
				local title = g.titles[math.random(#g.titles)]
				remote:FireServer(title, color)
				task.wait(0.05)
			end
		end
	elseif state == false then
		g.flash_rainbow_name_enabled = false
		local old_name = g.cached_title_name_roleplay_name or g.get_old_name_for_title()
		if not old_name then return end
		task.wait(0.15)
		local remote, err = g.get_remote("PlayersService", "RE", "UpdatePlayerRoleplayName")
		if not remote or not remote:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: UpdatePlayerRoleplayName does not exist or is not a RemoteEvent!", 5) end
		remote:FireServer(tostring(old_name), Color3.new(1, 1, 1))
	else
		return
	end
end

g.noclip_char_collisions = g.noclip_char_collisions or {}
g.noclip_for_character = g.noclip_for_character or function(state)
	if state == true then
		if g.noclip_on_char_enabled then return end
		g.noclip_on_char_enabled = true
		g.noclip_char_collisions = {}
		if g.notify then g.notify("Success", "NoClip has been enabled.", 1) end
		local conn = RunService.Heartbeat:Connect(function()
			if not g.noclip_on_char_enabled then return end
			local char = g.Character or g.LocalPlayer.Character
			if not char then return end

			for _, v in ipairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					if g.noclip_char_collisions[v] == nil then g.noclip_char_collisions[v] = v.CanCollide end
					if v.CanCollide then v.CanCollide = false end
				end
			end
		end)
		getgenv().FlamesLibrary.connect("character_noclip", conn)
	elseif state == false then
		g.noclip_on_char_enabled = false
		getgenv().FlamesLibrary.disconnect("character_noclip")
		if g.notify then g.notify("Success", "NoClip has been disabled.", 1) end
		for part, original_state in pairs(g.noclip_char_collisions) do if part and part.Parent then part.CanCollide = original_state end end
		g.noclip_char_collisions = {}
	else
		return
	end
end

g.color3_to_hex = g.color3_to_hex or function(color) return string.format("%02X%02X%02X", color.R * 255, color.G * 255, color.B * 255) end
g.get_current_body_colors = g.get_current_body_colors or function()
	local char = g.Character or g.LocalPlayer.Character or g.get_char(LocalPlayer, 10)
	if not char then return nil end
	local hum = g.Humanoid or char:FindFirstChildOfClass("Humanoid") or g.get_human(LocalPlayer, 10)
	if not hum then return nil end
	local ok, desc = pcall(function() return hum:GetAppliedDescription() end)
	if not ok or not desc then return nil end
	return {
		HeadColor = g.color3_to_hex(desc.HeadColor),
		TorsoColor = g.color3_to_hex(desc.TorsoColor),
		LeftArmColor = g.color3_to_hex(desc.LeftArmColor),
		RightLegColor = g.color3_to_hex(desc.RightLegColor),
		RightArmColor = g.color3_to_hex(desc.RightArmColor),
		LeftLegColor = g.color3_to_hex(desc.LeftLegColor),
	}
end

g.rainbow_character_color_toggled = g.rainbow_character_color_toggled or function(state)
	if state == true then
		if g.rainbow_char_color_enabled then return end
		if g.coloring_process_resetting_busy then
			if g.rainbow_skin_toggle_UI then g.rainbow_skin_toggle_UI:Set(false, false) end
			return g.notify("Warning", "Wait! SkinColor is still resetting!", 5)
		end
		g.cached_original_body_colors = g.cached_original_body_colors or g.get_current_body_colors()
		if not g.cached_original_body_colors then
			return g.notify("Error", "Could not read current body colors!", 5)
		end

		g.rainbow_char_color_enabled = true
		getgenv().FlamesLibrary.spawn("character_rainbow_color", "spawn", function()
			while g.rainbow_char_color_enabled == true do
				task.wait(0)
				for _, color in ipairs(g.colors_color_three) do
					if not g.rainbow_char_color_enabled then break end
					local remote = g.get_remote("HumanoidDescriptionService", "RE", "LoadCharacterWithHumanoidDescription")
					if not remote or not remote:IsA("RemoteEvent") then
						g.rainbow_char_color_enabled = false
						return g.notify("Error", "RemoteEvent: LoadCharacterWithHumanoidDescription does not exist or is not a RemoteEvent!", 5)
					end

					local hex = g.color3_to_hex(color)
					remote:FireServer({
						HeadColor = hex,
						TorsoColor = hex,
						LeftArmColor = hex,
						RightLegColor = hex,
						RightArmColor = hex,
						LeftLegColor = hex,
					})
					task.wait(0)
				end
			end
		end)
	elseif state == false then
		g.rainbow_char_color_enabled = false
		getgenv().FlamesLibrary.disconnect("character_rainbow_color")
		g.coloring_process_resetting_busy = true
		repeat task.wait(3.75) until not g.rainbow_char_color_enabled
		if g.notify then g.notify("Success", "Resetting character skintone...", 5) end
		local old_colors = g.cached_original_body_colors
		if not old_colors then return end
		local remote = g.get_remote("HumanoidDescriptionService", "RE", "LoadCharacterWithHumanoidDescription")
		if not remote then return g.notify("Error", "RemoteEvent: LoadCharacterWithHumanoidDescription does not exist or is not a RemoteEvent!", 5) end
		for i = 1, 10 do remote:FireServer(old_colors) task.wait(0) end
		g.cached_original_body_colors = nil
		g.coloring_process_resetting_busy = false
	else
		return
	end
end

g.spawn_npcs_flasher = g.spawn_npcs_flasher or function(state)
	if state == true then
		if g.deleting_all_npcs_busy_process then
			if g.spam_npcs_switch_toggle_UI then g.spam_npcs_switch_toggle_UI:Set(false, false) end
			return g.notify("Warning", "Wait! NPC Task still attempting to turn off.", 3)
		end
		wait(0.15)
		g.spawning_random_npc_followers = true
		while g.spawning_random_npc_followers == true do
			task.wait(0.35)
			for _, color in ipairs(g.colors_color_three) do
				local remote, err = g.get_remote("NonPlayerCharactersService", "RE", "RequestNPCAction")
				if not remote or not remote:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: RequestNPCAction does not exist or is not a RemoteEvent!", 5) end
				local npc = g.npc_asset_ids[math.random(#g.npc_asset_ids)]
				remote:FireServer("Spawn", npc)
				task.wait(0.15)
			end
		end
	elseif state == false then
		g.spawning_random_npc_followers = false
		g.deleting_all_npcs_busy_process = true
		repeat task.wait(1.75) until not g.spawning_random_npc_followers
		local remote, err = g.get_remote("NonPlayerCharactersService", "RE", "RequestNPCAction")
		if not remote or not remote:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: RequestNPCAction does not exist or is not a RemoteEvent!", 5) end
		for i = 1, 35 do remote:FireServer("Delete") task.wait(0) end
		g.deleting_all_npcs_busy_process = false
	else
		return
	end
end

g.vehicle_speed_boost_toggle = g.vehicle_speed_boost_toggle or function(toggled)
	if toggled == true then
		if g.vehicle_speed_boost_active then return end
		local current_vehicle = g.get_vehicle()
		if not current_vehicle then
			if g.flames_custom_vehicle_speed_boost_switch_UI then g.flames_custom_vehicle_speed_boost_switch_UI:Set(false) end
			return g.notify("Error", "No vehicle found.", 5)
		end
		local DriveSeat = current_vehicle:FindFirstChild("VehicleSeat", true)
		if not DriveSeat then
			if g.flames_custom_vehicle_speed_boost_switch_UI then g.flames_custom_vehicle_speed_boost_switch_UI:Set(false) end
			return g.notify("Error", "No VehicleSeat found.", 5)
		end

		g.vehicle_speed_boost_original_attrs = {
			MaxForwardSpeed = current_vehicle:GetAttribute("MaxForwardSpeed"),
			CurrentMaxForwardSpeed = current_vehicle:GetAttribute("CurrentMaxForwardSpeed"),
			DefaultMaxReverseSpeed = current_vehicle:GetAttribute("DefaultMaxReverseSpeed"),
			Traction = current_vehicle:GetAttribute("Traction"),
			MaxWheelYawAngle = current_vehicle:GetAttribute("MaxWheelYawAngle"),
			AccelerationTime = current_vehicle:GetAttribute("AccelerationTime"),
		}
		g.vehicle_speed_boost_target = current_vehicle
		local Original_Traction = g.vehicle_speed_boost_original_attrs.Traction or 150
		local Original_Yaw_Angle = g.vehicle_speed_boost_original_attrs.MaxWheelYawAngle or 30
		g.vehicle_speed_boost_active = true
		if g.notify then g.notify("Success", "Vehicle Speed Boost is now enabled.", 1.5) end

		g.FlamesLibrary.spawn("vehicle_speed_boost_tuning_loop", "spawn", function()
			while g.vehicle_speed_boost_active do
				if not current_vehicle or not current_vehicle.Parent or not DriveSeat.Parent then
					g.vehicle_speed_boost_active = false
					if g.flames_custom_vehicle_speed_boost_switch_UI then g.flames_custom_vehicle_speed_boost_switch_UI:Set(false, false) end
					break
				end

				local Boosted_Forward = g.vehicle_speed_boost_max_forward or 250
				local Boosted_Backward = -(g.vehicle_speed_boost_max_backward or 100)
				local Accel_Time = g.vehicle_speed_boost_acceleration_time or 0.1
				current_vehicle:SetAttribute("MaxForwardSpeed", Boosted_Forward)
				current_vehicle:SetAttribute("CurrentMaxForwardSpeed", Boosted_Forward)
				current_vehicle:SetAttribute("DefaultMaxReverseSpeed", Boosted_Backward)
				current_vehicle:SetAttribute("AccelerationTime", Accel_Time)
				local Current_Speed = DriveSeat.AssemblyLinearVelocity.Magnitude
				local Speed_Ratio = math.clamp(Current_Speed / Boosted_Forward, 0, 1)
				local Max_Traction_Mult = g.vehicle_speed_boost_max_traction_mult or 3.5
				local Traction_Mult = 1 + (Max_Traction_Mult - 1) * Speed_Ratio
				current_vehicle:SetAttribute("Traction", Original_Traction * Traction_Mult)
				local Min_Yaw_Mult = g.vehicle_speed_boost_min_yaw_mult or 0.35
				local Yaw_Mult = 1 - (1 - Min_Yaw_Mult) * Speed_Ratio
				current_vehicle:SetAttribute("MaxWheelYawAngle", Original_Yaw_Angle * Yaw_Mult)
				task.wait(0.1)
			end
		end)
	elseif toggled == false then
		g.vehicle_speed_boost_active = false
		local current_vehicle = g.vehicle_speed_boost_target or g.get_vehicle()
		if current_vehicle and g.vehicle_speed_boost_original_attrs then
			for attr_name, value in pairs(g.vehicle_speed_boost_original_attrs) do
				if value ~= nil then
					current_vehicle:SetAttribute(attr_name, value)
				end
			end
		end
		g.vehicle_speed_boost_original_attrs = nil
		g.vehicle_speed_boost_target = nil
		if g.notify then g.notify("Success", "Vehicle Speed Boost is now disabled.", 1.5) end
	else
		return 
	end
end

g.send_random_posts_spammer = g.send_random_posts_spammer or function(state)
	if state == true then
		g.spamming_random_posts_redcliff_phone = true
		if g.notify then g.notify("Success", "Post Spammer is now enabled.", 5) end
		while g.spamming_random_posts_redcliff_phone == true do
		task.wait(0.035)
			local remote, err = g.get_remote("MessageService", "RE", "SendPost")
			if not remote or not remote:IsA("RemoteEvent") then return g.notify("Error", "RemoteEvent: SendPost does not exist or is not a RemoteEvent!", 5) end
			local title_1 = g.posts_text_data_tbl[math.random(#g.posts_text_data_tbl)]
			local title_2 = g.posts_text_data_tbl[math.random(#g.posts_text_data_tbl)]
			remote:FireServer(title_1, title_2)
		end
	elseif state == false then
		g.spamming_random_posts_redcliff_phone = false
		if g.notify then g.notify("Success", "Post Spammer is now disabled.", 5) end
	else
		return 
	end
end

g.spam_carry_requests_all_options = g.spam_carry_requests_all_options or function(state, target)
	if state == true then
		if g.spam_carry_requests_every_option then return end
		local remote, err = g.get_remote("PlayersService", "RE", "RequestCarryPlayer")
		if not remote or not remote:IsA("RemoteEvent") then
			if g.spam_request_carry_UI_toggle then g.spam_request_carry_UI_toggle:Set(false, false) end
			return g.notify("Error", "RemoteEvent: RequestCarryPlayer does not exist or is not a RemoteEvent!", 5)
		end

		local resolved_target = target or g.request_carry_spam_plr_target
		if not resolved_target then
			if g.spam_request_carry_UI_toggle then g.spam_request_carry_UI_toggle:Set(false, false) end
			return g.notify("Error", "Player not found or they have left the game.", 5)
		end

		g.spam_carry_requests_every_option = true
		if g.notify then g.notify("Success", "Carry Request Spammer is now enabled.", 1.5) end
		g.FlamesLibrary.spawn("spam_carry_requests_loop", "spawn", function()
			while g.spam_carry_requests_every_option do
				task.wait(0)
				local current_target = target or g.request_carry_spam_plr_target
				if not current_target or not current_target.Parent then
					g.spam_carry_requests_every_option = false
					if g.spam_request_carry_UI_toggle then g.spam_request_carry_UI_toggle:Set(false, false) end
					if g.notify then g.notify("Error", "Target left the game, spammer stopped.", 5) end
					break
				end

				local carry_option = g.carry_player_options[math.random(#g.carry_player_options)]
				local ok, fire_err = pcall(function()
					remote:FireServer(current_target, carry_option)
				end)
				if not ok then
					g.notify("Error", "spam_carry_requests_all_options FireServer error: "..tostring(fire_err), 5)
				end
			end
		end)
	elseif state == false then
		g.spam_carry_requests_every_option = false
		if g.notify then g.notify("Success", "Carry Request Spammer is now disabled.", 5) end
	else
		return
	end
end

g.toggle_rainbow_character_color = g.toggle_rainbow_character_color or function() g.rainbow_character_color_toggled(not g.rainbow_char_color_enabled) end
g.toggle_noclip_for_character = g.toggle_noclip_for_character or function() g.noclip_for_character(not g.noclip_on_char_enabled) end
local Atlas = loadstring(game:HttpGet("https://gitlab.com/greatest-group/experience_coding/-/raw/main/UIs/Atlas.lua?ref_type=heads"))()
local UI = Atlas.new({
	Name = "RedCliff RP | " .. tostring(getgenv().Script_Version),
	ConfigFolder = "RedCliffRP",
	Color = Color3.fromRGB(21, 103, 251),
	Bind = "RightShift",
})
local Main_Page = UI:CreatePage("Main")
local Home_Section = Main_Page:CreateSection("Home")
local Local_Player_Section = Main_Page:CreateSection("LocalPlayer")
local Vehicle_Section = Main_Page:CreateSection("Vehicle")

Vehicle_Section:CreateToggle({
Name = "Rainbow Car (FE)",
Flag = "Rainbow_Car_FE",
Default = getgenv().rainbow_car_enabled or false,
Callback = function(new_value)
	g.toggle_rainbow_car(new_value)
end,})

Vehicle_Section:CreateToggle({
Name = "Anti Car Fling (FE)",
Flag = "Anti_Car_Fling_FE",
Default = getgenv().VehicleDestroyer_Enabled or false,
Callback = function(state)
	g.anti_car_fling(state)
end,})

Vehicle_Section:CreateSlider({
Name = "Rainbow Speed (FE)",
Flag = "Rainbow_Speed_FE",
Min = 0,
Max = 3,
Default = g.rainbow_car_speed or 0,
Callback = function(new_value)
	g.rainbow_car_speed = new_value
end,})

g.toggle_flash_all_wheels_UI_switch = Vehicle_Section:CreateToggle({
Name = "Flash All Wheels (FE)",
Flag = "Flash_All_Wheels_FE",
Default = g.flash_all_wheels or false,
Callback = function(new_value)
	g.toggle_all_wheels_on_vehicle(new_value)
end,})

Vehicle_Section:CreateButton({
Name = "Despawn Vehicle (FE)",
Callback = function()
	local remote, err = g.get_remote("VehiclesService", "RE", "RequestVehicleByName")
	if not remote or not remote:IsA("RemoteEvent") then
		return g.notify("Error", "RemoteEvent: RequestVehicleByName does not exist or is not a RemoteEvent!", 5)
	end
	remote:FireServer()
end,})

Local_Player_Section:CreateToggle({
Name = "Job Spammer (FE)",
Flag = "Job_Spammer_FE",
Default = g.job_spammer_FE or false,
Callback = function(new_value)
	g.toggle_job_spammer_FE(new_value)
end,})

Local_Player_Section:CreateToggle({
Name = "Flash Arms & Legs (FE)",
Flag = "Flash_Arms_And_Legs_FE",
Default = g.spamming_legs_and_arms_FE or false,
Callback = function(new_value)
	g.toggle_arms_and_legs_instantly(new_value)
end,})

Local_Player_Section:CreateToggle({
Name = "Rainbow Pregnancy (FE)",
Flag = "Rainbow_Pregnancy_FE",
Default = g.rainbow_pregnant_belly or false,
Callback = function(new_value)
	g.toggle_pregnant_belly_rainbow_colors(new_value)
end,})

g.vehicle_fly_switch_UI = Vehicle_Section:CreateToggle({
Name = "Vehicle Fly (FE)",
Flag = "Vehicle_Fly_FE",
Default = g.vehicle_fly or false,
Callback = function(new_value)
	g.toggle_vehicle_fly()
end,})

g.vehicle_noclip_switch_UI = Vehicle_Section:CreateToggle({
Name = "Vehicle Noclip (FE)",
Flag = "Vehicle_Noclip_FE",
Default = g.vehiclefly_noclip or false,
Callback = function(new_value)
	g.toggle_vehicle_noclip(new_value)
end,})

Vehicle_Section:CreateSlider({
Name = "V-Fly Speed",
Flag = "V_Fly_Speed",
Min = 1,
Max = 75,
Default = g.vehicle_fly_speed or 0,
Callback = function(new_value)
	getgenv().vehicle_fly_speed = new_value
end,})

Local_Player_Section:CreateToggle({
Name = "Rainbow Name (FE)",
Flag = "Rainbow_Name_FE",
Default = g.flash_rainbow_name_enabled or false,
Callback = function(new_value)
	g.rainbow_name_flasher_toggled(new_value)
end,})

Local_Player_Section:CreateToggle({
Name = "Rainbow Bio (FE)",
Flag = "Rainbow_Bio_FE",
Default = g.flash_rainbow_bio_enabled or false,
Callback = function(new_value)
	g.rainbow_bio_flasher_toggled(new_value)
end,})

Local_Player_Section:CreateToggle({
Name = "Noclip (FE)",
Flag = "Noclip_FE",
Default = g.noclip_on_char_enabled or false,
Callback = function(new_value)
	g.noclip_for_character(new_value)
end,})

g.rainbow_skin_toggle_UI = Local_Player_Section:CreateToggle({
Name = "Rainbow Skin (FE)",
Flag = "Rainbow_Skin_FE",
Default = g.rainbow_char_color_enabled or false,
Callback = function(new_value)
	g.rainbow_character_color_toggled(new_value)
end,})

g.spam_npcs_switch_toggle_UI = Home_Section:CreateToggle({
Name = "Random NPCs (FE)",
Flag = "Random_NPCs_FE",
Default = g.spawning_random_npc_followers or false,
Callback = function(new_value)
	g.spawn_npcs_flasher(new_value)
end,})

Local_Player_Section:CreateToggle({
Name = "Anti-Sit (FE)",
Flag = "Anti_Sit_FE_Toggle",
Default = g.AntiSit_Enabled or false,
Callback = function(new_value)
	g.anti_sit_func(new_value)
end,})

g.flames_custom_vehicle_speed_boost_switch_UI = Vehicle_Section:CreateToggle({
Name = "Vehicle Boost (FE)",
Flag = "Vehicle_Boost_FE",
Default = g.vehicle_speed_boost_active or false,
Callback = function(new_value)
	g.vehicle_speed_boost_toggle(new_value)
end,})

Vehicle_Section:CreateSlider({
Name = "Speed Boost Max Forward",
Flag = "Speed_Boost_Max_Forward",
Min = 25,
Max = 500,
Default = g.vehicle_speed_boost_max_forward or 250,
Callback = function(new_value)
	g.vehicle_speed_boost_max_forward = new_value
end,})

Vehicle_Section:CreateSlider({
Name = "Speed Boost Max Backward",
Flag = "Speed_Boost_Max_Backward",
Min = 25,
Max = 250,
Default = g.vehicle_speed_boost_max_backward or 100,
Callback = function(new_value)
	g.vehicle_speed_boost_max_backward = new_value
end,})

Vehicle_Section:CreateSlider({
Name = "Acceleration Time",
Flag = "Acceleration_Time",
Min = 0.02,
Max = 1,
Digits = 2,
Default = g.vehicle_speed_boost_acceleration_time or 0.1,
Callback = function(new_value)
	g.vehicle_speed_boost_acceleration_time = new_value
end,})

Vehicle_Section:CreateSlider({
Name = "Max Traction Multiplier",
Flag = "Max_Traction_Multiplier",
Min = 1,
Max = 6,
Digits = 1,
Default = g.vehicle_speed_boost_max_traction_mult or 3.5,
Callback = function(new_value)
	g.vehicle_speed_boost_max_traction_mult = new_value
end,})

Vehicle_Section:CreateSlider({
Name = "Min Turn Angle Multiplier",
Flag = "Min_Turn_Angle_Multiplier",
Min = 0.1,
Max = 1,
Digits = 2,
Default = g.vehicle_speed_boost_min_yaw_mult or 0.35,
Callback = function(new_value)
	g.vehicle_speed_boost_min_yaw_mult = new_value
end,})

g.request_carry_spam_plr_target = nil
Home_Section:CreateTextBox({
Name = "Carry Spam Plr",
Flag = "Carry_Spam_Plr",
DefaultText = "",
PlaceholderText = "User/Display",
Callback = function(inputted_text, enter_pressed)
	local targ = g.findplr(inputted_text)
	if not targ then
		return g.notify("Error", "Target not found or they have left the game.", 5)
	end
	g.request_carry_spam_plr_target = targ
	if g.notify then
		g.notify("Success", "Set Target: " .. tostring(targ.Name), 5)
	end
end,})

g.spam_request_carry_UI_toggle = Home_Section:CreateToggle({
Name = "Request Carry Spam (FE)",
Flag = "Request_Carry_Spam_FE",
Default = g.spam_carry_requests_every_option or false,
Callback = function(new_value)
	if not g.request_carry_spam_plr_target then
		g.spam_carry_requests_every_option = false
		if g.spam_request_carry_UI_toggle then
			g.spam_request_carry_UI_toggle:Set(false, false)
		end
		return g.notify("Error", "Not a valid player, please use the above input to set a target.", 6)
	end
	g.spam_carry_requests_all_options(new_value, g.request_carry_spam_plr_target)
end,})

Home_Section:CreateToggle({
Name = "Posts Spammer (FE)",
Flag = "Posts_Spammer_FE",
Default = g.spamming_random_posts_redcliff_phone or false,
Callback = function(new_value)
	g.send_random_posts_spammer(new_value)
end,})

Home_Section:CreateButton({
Name = "Check Server Ownership",
Callback = function()
	local owner = g.is_localplayer_server_owner()
	if owner then
		g.notify("Success", "You own this private server.", 5)
	else
		g.notify("Error", "You do not own this private server.", 5)
	end
end,})