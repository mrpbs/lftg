if not game:IsLoaded() then game.Loaded:Wait() end
local g = getgenv()
if not g.GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://pastebin.com/raw/T25mDhBZ"))()
   wait(0.1)
   g.GlobalEnvironmentFramework_Initialized = true
end
wait(1)
local function_init_timeout = 30 -- in seconds.
if not getgenv().notify then
	local start = os.clock()
	repeat
		task.wait()
	until (getgenv().notify and typeof(getgenv().notify) == "function") or os.clock() - start > function_init_timeout or 30
end

local MarketplaceService = getgenv().MarketplaceService or cloneref and cloneref(game:GetService("MarketplaceService")) or game:GetService("MarketplaceService")
local game_name = MarketplaceService:GetProductInfo(game.PlaceId).Name
local flames_ui = loadstring(game:HttpGet("https://gitlab.com/greatest-group/experience_coding/-/raw/main/UIs/Luna.lua?ref_type=heads"))()
local Window = flames_ui:CreateWindow({
	Name = "Flames Hub | Southern Mudding.",
	Subtitle = "Welcome to: Flames Hub | SM.",
	LogoID = "0",
	LoadingEnabled = true,
	LoadingTitle = "Flames Hub | Presents",
	LoadingSubtitle = "by Flames Hub.",
	ConfigSettings = {
		RootFolder = nil,
		ConfigFolder = "FlamesHub_Main_Menu_Configuration"
	},
	KeySystem = false,
	KeySettings = {
		Title = "Flames Hub | Key System",
		Subtitle = "",
		Note = "Welcome to Flames Hub | Southern Mudding!",
		SaveInRoot = false,
		SaveKey = true,
		Key = {"Example Key"},
		SecondAction = {
			Enabled = false,
			Type = "Link",
			Parameter = ""
		}
	}
})

local VehiclesTab = Window:CreateTab({Name = "🏎️ Vehicles 🏎️", Icon = "view_in_ar", ImageSource = "Material", ShowTitle = true})
local VehiclesSection = VehiclesTab:CreateSection("Section | Vehicles Page")
local LocalPlayer_Tab = Window:CreateTab({Name = "👤 LocalPlayer 👤", Icon = "view_in_ar", ImageSource = "Material", ShowTitle = true})
local LocalPlayer_Section = LocalPlayer_Tab:CreateSection("Section | LocalPlayer Page")
local Config_Tab = Window:CreateTab({Name = "✏️ Config ✏️", Icon = "view_in_ar", ImageSource = "Material", ShowTitle = true})
local Config_Section = Config_Tab:CreateSection("Section | Configuration Page")
getgenv().SouthernMudding_Script_Hub_Loaded_Already = true
getgenv().car_wraps = {
	"CarbonFiber",
	"Camo",
	"GreenYellowedPaintSplashes",
	"BlueYellowArrows1",
	"RedGreyPattern",
	"BluePixelCamo",
	"GreenPixelCamo",
	"PatrioticStars",
	"BrownHexoCamo",
	"GreenHexoCamo",
	"Rust"
}

getgenv().colors = getgenv().colors or {
	black = Color3.fromRGB(0, 0, 0),
	white = Color3.fromRGB(255, 255, 255),
	red = Color3.fromRGB(255, 0, 0),
	lime = Color3.fromRGB(0, 255, 0),
	blue = Color3.fromRGB(0, 0, 255),
	yellow = Color3.fromRGB(255, 255, 0),
	cyan = Color3.fromRGB(0, 255, 255),
	magenta = Color3.fromRGB(255, 0, 255),
	gray = Color3.fromRGB(128, 128, 128),
	darkgray = Color3.fromRGB(64, 64, 64),
	lightgray = Color3.fromRGB(192, 192, 192),
	orange = Color3.fromRGB(255, 165, 0),
	pink = Color3.fromRGB(255, 192, 203),
	purple = Color3.fromRGB(128, 0, 128),
	brown = Color3.fromRGB(139, 69, 19),
	maroon = Color3.fromRGB(128, 0, 0),
	olive = Color3.fromRGB(128, 128, 0),
	green = Color3.fromRGB(0, 128, 0),
	teal = Color3.fromRGB(0, 128, 128),
	navy = Color3.fromRGB(0, 0, 128),
	gold = Color3.fromRGB(255, 215, 0),
	silver = Color3.fromRGB(192, 192, 192),
	bronze = Color3.fromRGB(205, 127, 50),
	skyblue = Color3.fromRGB(135, 206, 235),
	deepskyblue = Color3.fromRGB(0, 191, 255),
	royalblue = Color3.fromRGB(65, 105, 225),
	indigo = Color3.fromRGB(75, 0, 130),
	violet = Color3.fromRGB(238, 130, 238),
	crimson = Color3.fromRGB(220, 20, 60),
	coral = Color3.fromRGB(255, 127, 80),
	salmon = Color3.fromRGB(250, 128, 114),
	beige = Color3.fromRGB(245, 245, 220),
	ivory = Color3.fromRGB(255, 255, 240),
	khaki = Color3.fromRGB(240, 230, 140),
	turquoise = Color3.fromRGB(64, 224, 208),
	aqua = Color3.fromRGB(0, 255, 255),
	lavender = Color3.fromRGB(230, 230, 250),
	plum = Color3.fromRGB(221, 160, 221),
	charcoal = Color3.fromRGB(54, 69, 79),
	mint = Color3.fromRGB(189, 252, 201),
	peach = Color3.fromRGB(255, 218, 185)
}

getgenv().fromrgb_to_new = function(col)
	return Color3.new(col.r, col.g, col.b)
end

local function random_color()
	local keys = {}
	for k in pairs(getgenv().colors) do
		keys[#keys + 1] = k
	end
	return getgenv().colors[keys[math.random(1, #keys)]]
end

getgenv().resolve_userid = getgenv().resolve_userid or function(who)
	if typeof(who) == "number" then
		return who
	end

	if typeof(who) == "Instance" and who:IsA("Player") then
		return who.UserId
	end

	if typeof(who) == "string" then
		local plr = Players:FindFirstChild(who)
		if plr then
			return plr.UserId
		end

		local id
		pcall(function()
			id = Players:GetUserIdFromNameAsync(who)
		end)
		return id
	end
end

getgenv().get_vehicle = function(name, method)
	local lp = getgenv().LocalPlayer or game.Players.LocalPlayer
	local vehicles = workspace:FindFirstChild("Vehicles")
	if not vehicles then
		getgenv().notify("Error", "Vehicles Folder was not found inside Workspace.", 5)
		return nil
	end

	local use_method = method or "1"
	if use_method == 1 then use_method = "1" end
	if use_method == 2 then use_method = "2" end

	if use_method == "1" or use_method == "method1" then
		local char = getgenv().Character or lp.Character
		if not char then return nil end
		local hum = getgenv().Humanoid or char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10)
		if not hum then return nil end
		local seat = hum.SeatPart
		if not seat or seat.Name ~= "DriveSeat" then
			if getgenv().Rainbow_Vehicle_UI_Toggle then getgenv().Rainbow_Vehicle_UI_Toggle:Set({ CurrentValue = false }) end
			getgenv().notify("Error", "You're not sitting down in your vehicle, please sit down in a Vehicle first.", 10)
			return nil
		end
		local vehicle = seat:FindFirstAncestorOfClass("Model")
		if not vehicle then return nil end
		local ownerId = resolve_userid(lp)
		if vehicle:GetAttribute("OwnerId") ~= ownerId then return nil end
		if vehicle:GetAttribute("Preview") then return nil end
		if not vehicle:FindFirstChild("Body") or not vehicle.Body:FindFirstChild("CarBody") then return nil end
		local owner_folder = vehicles:FindFirstChild(lp.Name)
		if not owner_folder or not vehicle:IsDescendantOf(owner_folder) then return nil end
		if name and vehicle.Name ~= name then return nil end
		return vehicle

	elseif use_method == "2" or use_method == "method2" then
		local AChassisInterface = lp.PlayerGui:FindFirstChild("A-Chassis Interface")
		if not AChassisInterface then
			getgenv().notify("Error", "A-Chassis Interface was not found, are you in a vehicle?", 5)
			return nil
		end
		local Car_OV = AChassisInterface:FindFirstChild("Car")
		if not Car_OV or not Car_OV:IsA("ObjectValue") or not Car_OV.Value then
			getgenv().notify("Error", "Car ObjectValue is missing or empty.", 5)
			return nil
		end
		local vehicle = Car_OV.Value
		if not vehicle or not vehicle:IsA("Model") then return nil end
		if vehicle:GetAttribute("Preview") then return nil end
		local owner_folder = vehicles:FindFirstChild(lp.Name)
		if not owner_folder or not vehicle:IsDescendantOf(owner_folder) then return nil end
		if name and vehicle.Name ~= name then return nil end
		return vehicle
	end

	return nil
end

getgenv().vehicle_speed_boost_toggle = function(toggled)
	if toggled == true then
		if getgenv().vehicle_speed_boost_active then return getgenv().notify("Warning", "Vehicle Speed Boost is already enabled!", 5) end
		local current_vehicle = getgenv().get_vehicle(nil, "2")
		if not current_vehicle then
			if getgenv().Vehicle_Speed_Boost_Toggle then getgenv().Vehicle_Speed_Boost_Toggle:Set({CurrentValue = false}) end
			return getgenv().notify("Error", "No vehicle found.", 5)
		end
		local DriveSeat = current_vehicle:FindFirstChildOfClass("VehicleSeat")
		if not DriveSeat then
			if getgenv().Vehicle_Speed_Boost_Toggle then getgenv().Vehicle_Speed_Boost_Toggle:Set({CurrentValue = false}) end
			return getgenv().notify("Error", "No VehicleSeat found.", 5)
		end
		local Player = cloneref(game:GetService("Players")).LocalPlayer
		local Current_Speed = 0
		local S_Hold_Start = nil
		local Is_Mobile = cloneref(game:GetService("UserInputService")).TouchEnabled
		local BV = DriveSeat:FindFirstChild("FlamesSpeedBoost") or Instance.new("BodyVelocity")
		BV.Name = "FlamesSpeedBoost"
		BV.MaxForce = Vector3.new(9e9, 0, 9e9)
		BV.Velocity = Vector3.new(0, 0, 0)
		BV.Parent = DriveSeat
		local BG = DriveSeat:FindFirstChild("FlamesSpeedGyro") or Instance.new("BodyGyro")
		BG.Name = "FlamesSpeedGyro"
		BG.P = 9e4
		BG.MaxTorque = Vector3.new(0, 9e9, 0)
		BG.CFrame = DriveSeat.CFrame
		BG.Parent = DriveSeat
		getgenv().vehicle_speed_boost_active = true
		getgenv().vehicle_speed_boost_max_forward = getgenv().vehicle_speed_boost_max_forward or 425
		getgenv().vehicle_speed_boost_max_backward = getgenv().vehicle_speed_boost_max_backward or 125
		getgenv().vehicle_speed_boost_acceleration = getgenv().vehicle_speed_boost_acceleration or 10
		getgenv().notify("Success", "Vehicle Speed Boost is now enabled.", 1.5)
		getgenv().FlamesLibrary.spawn("vehicle_speed_boost_loop", "spawn", function()
			while getgenv().vehicle_speed_boost_active do
				if not current_vehicle or not current_vehicle.Parent then
					getgenv().vehicle_speed_boost_active = false
					if getgenv().Apply_Best_Vehicle_Settings then getgenv().Apply_Best_Vehicle_Settings:Set({CurrentValue = false}) end
					break
				end
				local Max_Forward_Speed = getgenv().vehicle_speed_boost_max_forward or 425
				local Max_Backward_Speed = getgenv().vehicle_speed_boost_max_backward or 125
				local Acceleration = getgenv().vehicle_speed_boost_acceleration or 10
				local Throttle = DriveSeat.Throttle
				if Is_Mobile then
					local ControlModule = require(Player.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
					local Direction = ControlModule:GetMoveVector()
					Throttle = -Direction.Z
				end
				if Throttle > 0 then
					S_Hold_Start = nil
					Current_Speed = math.min(Current_Speed + Acceleration, Max_Forward_Speed)
					BV.Velocity = DriveSeat.CFrame.LookVector * Current_Speed
					BG.CFrame = DriveSeat.CFrame
				elseif Throttle < 0 then
					if not S_Hold_Start then S_Hold_Start = tick() end
					if tick() - S_Hold_Start >= 0.45 then
						Current_Speed = math.max(Current_Speed - Acceleration, -Max_Backward_Speed)
						BV.Velocity = DriveSeat.CFrame.LookVector * Current_Speed
					else
						Current_Speed = math.max(Current_Speed - Acceleration * 3, 0)
						BV.Velocity = DriveSeat.CFrame.LookVector * Current_Speed
					end
				else
					S_Hold_Start = nil
					Current_Speed = math.max(Current_Speed - Acceleration * 2, 0)
					BV.Velocity = DriveSeat.CFrame.LookVector * Current_Speed
				end
				task.wait(0.03)
			end
			BV:Destroy()
			BG:Destroy()
		end)
	elseif toggled == false then
		getgenv().vehicle_speed_boost_active = false
		local current_vehicle = getgenv().get_vehicle(nil, "2")
		if not current_vehicle then return end
		local DriveSeat = current_vehicle:FindFirstChildOfClass("VehicleSeat")
		if not DriveSeat then return end
		local BV = DriveSeat:FindFirstChild("FlamesSpeedBoost")
		local BG = DriveSeat:FindFirstChild("FlamesSpeedGyro")
		if BV then BV:Destroy() end
		if BG then BG:Destroy() end
		getgenv().notify("Success", "Vehicle Speed Boost is now disabled.", 1.5)
	else
		return 
	end
end

local function find_customize_vehicle_remote()
	local cache = getgenv().customize_vehicle_RE_obj
	if cache and cache:IsA("RemoteEvent") then
		return cache
	end

	for _, v in ipairs(getgenv().ReplicatedStorage:GetDescendants()) do
		if v:IsA("RemoteEvent") then
			local name = v.Name:lower()
			if name:find("customize") and name:find("vehicle") then
				getgenv().customize_vehicle_RE_obj = v
				return v
			end
		end
	end

	return nil
end

getgenv().find_a_chassis_gui_ez = function()
	if not PlayerGui then return end
	for _, v in ipairs(PlayerGui:GetDescendants()) do
		if v:IsA("ScreenGui") and v.Name:lower():find("chassis") then
			local obj_val = v:FindFirstChildOfClass("ObjectValue")
			if obj_val then
				if obj_val.Name:lower():find("car") or obj_val.Name:lower():find("vehicle") then
					return v
				end
			end
		end
	end

	return nil
end

getgenv().is_current_vehicle_engine_on = function()
	local v_1 = getgenv().get_vehicle(nil, "2")
	if not v_1 then return false end
	local gui = find_a_chassis_gui_ez()
	if not gui then return false end
	local is_on_bool = gui:FindFirstChild("IsOn")
	if not is_on_bool or not is_on_bool:IsA("BoolValue") then return false end
	return is_on_bool.Value
end

getgenv().toggle_car_engine_state = function(engine_state)
	getgenv().car_engine_is_enabled = engine_state

	if engine_state == true then
		local v_1 = getgenv().get_vehicle(nil, "2")
		if not v_1 then return getgenv().notify("Error", "You do not have a Vehicle spawned or it was destroyed.", 5) end
		local gui = find_a_chassis_gui_ez()
		if not gui then return getgenv().notify("Error", "A-Chassis Interface ScreenGui not found or does not exist.", 5) end
		local is_on_bool = gui:FindFirstChild("IsOn")
		if not is_on_bool then return getgenv().notify("Error", "IsOn BoolValue does not exist, cannot toggle vehicle engine.", 5) end

		if v_1 and v_1:IsA("Model") then
			is_on_bool.Value = true
		end
	elseif engine_state == false then
		local v_1 = getgenv().get_vehicle(nil, "2")
		if not v_1 then return getgenv().notify("Error", "You do not have a Vehicle spawned or it was destroyed.", 5) end
		local gui = find_a_chassis_gui_ez()
		if not gui then return getgenv().notify("Error", "A-Chassis Interface ScreenGui not found or does not exist.", 5) end
		local is_on_bool = gui:FindFirstChild("IsOn")
		if not is_on_bool then return getgenv().notify("Error", "IsOn BoolValue does not exist, cannot toggle vehicle engine.", 5) end

		if v_1 and v_1:IsA("Model") then
			is_on_bool.Value = false
		end
	else
		return 
	end
end

local function find_jump_attempt_get_out_of_vehicle_RE()
	local cache = getgenv().jump_attempt_Remote_Event_instance
	if cache and cache:IsA("RemoteEvent") and cache.Parent then
		return cache
	end

	for _, v in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
		if v:IsA("RemoteEvent") and v.Name:lower():find("jump") and v.Name:lower():find("attempt") then
			getgenv().jump_attempt_Remote_Event_instance = v
			return v
		end
	end

	return nil
end

if not getgenv().jump_attempt_Remote_Event_instance then find_jump_attempt_get_out_of_vehicle_RE() end
getgenv().AutoEject_Enabled = getgenv().AutoEject_Enabled or false
getgenv().AutoEject_Thread = getgenv().AutoEject_Thread or nil
getgenv().AutoEject_Toggle = function(state)
	if state == true then
		if getgenv().AutoEject_Enabled then return end
		getgenv().AutoEject_Enabled = true
		if getgenv().AutoEject_Thread then
			task.cancel(getgenv().AutoEject_Thread)
			getgenv().AutoEject_Thread = nil
		end
		wait(0.25)
		getgenv().AutoEject_Thread = task.spawn(function()
			local JumpAttempt = getgenv().jump_attempt_Remote_Event_instance or find_jump_attempt_get_out_of_vehicle_RE()
			if not JumpAttempt then
				getgenv().AutoEject_Enabled = false
				getgenv().AutoEject_Thread = nil
				return getgenv().notify("Error", "JumpAttempt RemoteEvent was not found, cannot run Auto Eject.", 5)
			end
			while getgenv().AutoEject_Enabled == true do
				local char = getgenv().Character or game.Players.LocalPlayer.Character
				if not char then
					getgenv().AutoEject_Enabled = false
					getgenv().AutoEject_Thread = nil
					return getgenv().notify("Error", "Character is nil, stopping Auto Eject.", 5)
				end
				local hum = getgenv().Humanoid or char:FindFirstChildOfClass("Humanoid")
				if not hum then
					getgenv().AutoEject_Enabled = false
					getgenv().AutoEject_Thread = nil
					return getgenv().notify("Error", "Humanoid is nil, stopping Auto Eject.", 5)
				end
				if hum and hum.SeatPart and hum.SeatPart.Name:lower():find("driveseat") then
					repeat
						JumpAttempt:FireServer()
						task.wait(0.1)
					until not hum.SeatPart or not hum.SeatPart.Name:lower():find("driveseat") or not getgenv().AutoEject_Enabled
				end
				task.wait(0.1)
			end
		end)
	elseif state == false then
		getgenv().AutoEject_Enabled = false
		if getgenv().AutoEject_Thread then
			task.cancel(getgenv().AutoEject_Thread)
			getgenv().AutoEject_Thread = nil
		end
	end
end

getgenv().change_veh_color_func = function(new_color, random)
	local selected_color

	if random then
		local keys = {}
		for k in pairs(getgenv().colors) do
			keys[#keys + 1] = k
		end
		selected_color = getgenv().colors[keys[math.random(1, #keys)]]
	else
		selected_color = new_color
	end

	local args = {
		{
			VehicleModel = get_vehicle(),
			NewModification = {
				PaintColor = selected_color,
				WindowColor = selected_color,
				PaintWrap = "Camo",
				RimColor = selected_color,
				Attachments = {}
			},
			TrailerOriginalModification = {},
			OriginalModification = {
				PaintColor = selected_color,
				WindowColor = selected_color,
				WindowReflectance = 0.029999999329447746,
				PaintReflectance = 0.019999999552965164,
				SuperChargers = 0,
				TurboChargers = 0,
				SuspensionHeight = 0,
				WindowTransparency = 0.699999988079071,
				SuspensionStiffness = 0,
				PaintWrap = "Camo",
				SuspensionDamping = 0,
				RimColor = selected_color
			},
			TrailerNewModification = {}
		}
	}

	find_customize_vehicle_remote():FireServer(unpack(args))
end

getgenv().rainbow_vehicle_functionality = function(state)
	if state == true then
		local vehicle = getgenv().get_vehicle(nil, "2")
		if not vehicle then
			if getgenv().Rainbow_Vehicle_UI_Toggle then getgenv().Rainbow_Vehicle_UI_Toggle:Set({ CurrentValue = false }) end
			return getgenv().notify("Error", "You do not have a Vehicle, spawn one.", 5)
		end

		if getgenv().RainbowVehicleEnabledFunc then
			getgenv().RainbowVehicleEnabledFunc = false
			if getgenv().Rainbow_Car_Task_Loop then
				pcall(task.cancel, getgenv().Rainbow_Car_Task_Loop)
				getgenv().Rainbow_Car_Task_Loop = nil
			end
		end
		wait(0.2)
		getgenv().RainbowVehicleEnabledFunc = true
		local color_keys = {}
		for k in pairs(getgenv().colors) do color_keys[#color_keys + 1] = k end
		getgenv().Rainbow_Car_Task_Loop = task.spawn(function()
			local index = 1
			while getgenv().RainbowVehicleEnabledFunc == true do
				local color = getgenv().colors[color_keys[index]]
				getgenv().change_veh_color_func(color, false)
				index = index + 1
				if index > #color_keys then
					index = 1
				end
				task.wait(0)
			end
		end)
	elseif state == false then
		getgenv().RainbowVehicleEnabledFunc = false
		if getgenv().Rainbow_Car_Task_Loop then
			pcall(task.cancel, getgenv().Rainbow_Car_Task_Loop)
			getgenv().Rainbow_Car_Task_Loop = nil
		end
	end
end

local function read_current_fuel_value()
	local current_vehicle = getgenv().get_vehicle(nil, "2")
	if not current_vehicle then return nil end
	local drive_seat

	for _, v in ipairs(current_vehicle:GetDescendants()) do
		if v:IsA("VehicleSeat") and v.Name:lower():find("driver") then
			drive_seat = v
			break
		end
	end

	if drive_seat then
		return drive_seat:GetAttribute("Fuel")
	else
		getgenv().notify("Error", "Could not find VehicleSeat or it is not a VehicleSeat.", 5)
		return nil
	end
end

local function find_horn_toggle_remote()
	local current_vehicle = getgenv().get_vehicle(nil, "2")
	if not current_vehicle then return nil end
	local horn_toggle

	for _, v in ipairs(current_vehicle:GetDescendants()) do
		if v:IsA("RemoteEvent") and v.Name:lower():find("horn") then
			horn_toggle = v
			break
		end
	end

	if horn_toggle then
		return horn_toggle
	else
		getgenv().notify("Error", "Could not find ToggleHorn or it is not a RemoteEvent.", 5)
		return nil
	end
end

local function find_change_settings_remote()
	local cache = getgenv().change_settings_RE_main
	if cache and cache:IsA("RemoteEvent") then
		return cache
	end

	for _, v in ipairs(getgenv().ReplicatedStorage:GetDescendants()) do
		if v:IsA("RemoteEvent") then
			local name = v.Name:lower()
			if name:find("change") and name:find("settings") then
				getgenv().change_settings_RE_main = v
				return v
			end
		end
	end

	return nil
end

if not getgenv().change_settings_RE_main then find_change_settings_remote() end
wait(0.1)
getgenv().lock_vehicle_func = function(locked_state)
	if locked_state == true then
		local args = {
			"General",
			"LockVehicle",
			true
		}

		getgenv().currently_locked_vehicle = true
		local change_car_settings_remote_found = getgenv().change_settings_RE_main or find_change_settings_remote()
		if change_car_settings_remote_found and change_car_settings_remote_found:IsA("RemoteEvent") then
			change_car_settings_remote_found:FireServer(unpack(args))
		end
	elseif locked_state == false then
		local args = {
			"General",
			"LockVehicle",
			false
		}

		getgenv().currently_locked_vehicle = false
		local change_car_settings_remote_found = getgenv().change_settings_RE_main or find_change_settings_remote()
		if change_car_settings_remote_found and change_car_settings_remote_found:IsA("RemoteEvent") then
			getgenv().currently_locked_vehicle = false
			change_car_settings_remote_found:FireServer(unpack(args))
		end
	else
		return 
	end
end

getgenv().vehicle_fly_speed = getgenv().vehicle_fly_speed or 30
getgenv().vehicle_fly_vertical_speed = getgenv().vehicle_fly_vertical_speed or 45
getgenv().vehicle_fly_enabled = getgenv().vehicle_fly_enabled or false
local FL = getgenv().FlamesLibrary
local CAS = cloneref and cloneref(game:GetService("ContextActionService")) or game:GetService("ContextActionService")
local lp = getgenv().LocalPlayer or Players.LocalPlayer
local IsOnMobile = UserInputService.TouchEnabled
local att, lv, orient, root
local up = 0
local binds = false
local velocityHandlerName = "vf_bv_" .. tostring(math.random(1e6))
local gyroHandlerName = "vf_bg_" .. tostring(math.random(1e6))
local function get_vehicle_root()
	local vehicles = workspace:FindFirstChild("Vehicles")
	if not vehicles then return end
	local folder = vehicles:FindFirstChild(lp.Name)
	if not folder then return end
	for _, v in ipairs(folder:GetChildren()) do
		if v:IsA("Model") then
			local body = v:FindFirstChild("Body")
			if body then
				local w = body:FindFirstChild("#Weight")
				if w and w:IsA("BasePart") then
					return w
				end
			end
		end
	end
end

local function unbind()
	if not binds then return end
	binds = false
	CAS:UnbindAction("vf_up")
	CAS:UnbindAction("vf_down")
	up = 0
end

local function bind()
	if binds then return end
	binds = true
	CAS:BindAction("vf_up", function(_, state)
		up = (state == Enum.UserInputState.Begin) and 1 or 0
	end, false, Enum.KeyCode.E)
	CAS:BindAction("vf_down", function(_, state)
		up = (state == Enum.UserInputState.Begin) and -1 or 0
	end, false, Enum.KeyCode.Q)
end

local function disable_mobile_fly()
	FL.disconnect("vf_mobile_conn")
	pcall(function()
		local r = get_vehicle_root()
		if r then
			local bv = r:FindFirstChild(velocityHandlerName)
			local bg = r:FindFirstChild(gyroHandlerName)
			if bv then bv:Destroy() end
			if bg then bg:Destroy() end
		end
	end)
end

local function enable_mobile_fly()
	disable_mobile_fly()
	root = get_vehicle_root()
	if not root then return end
	local controlModule = require(lp.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	local v3zero = Vector3.new(0, 0, 0)
	local v3inf = Vector3.new(9e9, 9e9, 9e9)
	local bv = Instance.new("BodyVelocity")
	bv.Name = velocityHandlerName
	bv.MaxForce = v3inf
	bv.Velocity = v3zero
	bv.Parent = root

	local bg = Instance.new("BodyGyro")
	bg.Name = gyroHandlerName
	bg.MaxTorque = v3inf
	bg.P = 1000
	bg.D = 50
	bg.Parent = root

	FL.connect("vf_mobile_conn", RunService.RenderStepped:Connect(function()
		if not getgenv().vehicle_fly_enabled or not root or not root.Parent then
			disable_mobile_fly()
			if getgenv().Fly_Vehicle_Toggle_FE then getgenv().Fly_Vehicle_Toggle_FE:Set({ CurrentValue = false }) end
			return
		end

		local cam = workspace.CurrentCamera
		local dir = controlModule:GetMoveVector()
		bg.CFrame = cam.CoordinateFrame
		bv.Velocity = v3zero
		if dir.X ~= 0 then bv.Velocity = bv.Velocity + cam.CFrame.RightVector * (dir.X * getgenv().vehicle_fly_speed) end
		if dir.Z ~= 0 then bv.Velocity = bv.Velocity - cam.CFrame.LookVector * (dir.Z * getgenv().vehicle_fly_speed) end
	end))
end

local function disable_desktop_fly()
	FL.disconnect("vf_desktop_conn")
	unbind()
	if lv then lv:Destroy() lv = nil end
	if orient then orient:Destroy() orient = nil end
	if att then att:Destroy() att = nil end
	root = nil
end

local function enable_desktop_fly()
	disable_desktop_fly()
	root = get_vehicle_root()
	if not root then return end
	local control = require(lp.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	att = Instance.new("Attachment")
	att.Parent = root

	lv = Instance.new("LinearVelocity")
	lv.Attachment0 = att
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
	lv.MaxForce = math.huge
	lv.VectorVelocity = Vector3.zero
	lv.Parent = root

	orient = Instance.new("AlignOrientation")
	orient.Attachment0 = att
	orient.Mode = Enum.OrientationAlignmentMode.OneAttachment
	orient.Responsiveness = 25
	orient.MaxTorque = math.huge
	orient.Parent = root

	bind()

	FL.connect("vf_desktop_conn", RunService.RenderStepped:Connect(function()
		if not getgenv().vehicle_fly_enabled or not root or not root.Parent then
			disable_desktop_fly()
			if getgenv().Fly_Vehicle_Toggle_FE then getgenv().Fly_Vehicle_Toggle_FE:Set({ CurrentValue = false }) end
			return
		end

		local cam = workspace.CurrentCamera
		local move = control:GetMoveVector()
		local fixedMove = Vector3.new(move.X, 0, -move.Z)
		local look = cam.CFrame.LookVector
		local flatLook = Vector3.new(look.X, 0, look.Z)
		if flatLook.Magnitude > 0 then orient.CFrame = CFrame.lookAt(root.Position, root.Position + flatLook) end
		local forward = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
		local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
		local horizontal = forward * fixedMove.Z + right * fixedMove.X
		if horizontal.Magnitude > 0 then horizontal = horizontal.Unit end

		lv.VectorVelocity =
			horizontal * getgenv().vehicle_fly_speed
			+ Vector3.new(0, up * getgenv().vehicle_fly_vertical_speed, 0)
	end))
end

local function enable_fly() if IsOnMobile then enable_mobile_fly() else enable_desktop_fly() end end
local function disable_fly() if IsOnMobile then disable_mobile_fly() else disable_desktop_fly() end end
if not getgenv().vehicle_fly_init_main then
	getgenv().vehicle_fly_init_main = true
	getgenv().polling_vehicle_fly_toggled_task = task.spawn(function()
		while task.wait(0.10) do
			local active = IsOnMobile and FL.is_alive("vf_mobile_conn") or FL.is_alive("vf_desktop_conn")
			if getgenv().vehicle_fly_enabled then
				if not active then enable_fly() end
			else
				if active then disable_fly() end
			end
		end
	end)
end

local lp = getgenv().LocalPlayer or Players.LocalPlayer
local PlayerGui = getgenv().PlayerGui or lp:WaitForChild("PlayerGui")
local function find_notifications_gui_main()
	local cache = getgenv().found_notifications_gui_in_plr_gui
	if cache and cache:IsA("ScreenGui") then
		return cache
	end

	for _, v in ipairs(PlayerGui:GetDescendants()) do
		if v:IsA("ScreenGui") and v.Name:lower():find("notification") and v.Name:lower():find("gui") then
			getgenv().found_notifications_gui_in_plr_gui = v
			return v
		end
	end

	return nil
end

if not getgenv().found_notifications_gui_in_plr_gui then find_notifications_gui_main() end
local NotificationsGui = getgenv().found_notifications_gui_in_plr_gui or find_notifications_gui_main()
getgenv().CreateNotification = function(text, duration, textColor, soundName, bgColor, persistent, notifId)
	if not NotificationsGui then return end
	duration = duration or 2
	textColor = textColor or Color3.new(1, 1, 1)

	task.spawn(function()
		local n = NotificationsGui:FindFirstChild("NotificationTemplate"):Clone()
		n.TextLabel.Text = text
		n.TextLabel.TextColor3 = textColor
		n.Size = UDim2.fromScale(0, 0)
		n.Visible = true

		if bgColor then
			n.BackgroundColor3 = bgColor
		end

		if notifId then
			n:SetAttribute("NotifId", notifId)
		end

		n.Parent = NotificationsGui.List

		if soundName then
			local ui = SoundService:FindFirstChild("UI")
			if ui then
				local s = ui:FindFirstChild(soundName)
				if s then s:Play() end
			end
		end

		n.TextButton.MouseButton1Click:Connect(function()
			n:Destroy()
		end)

		TweenService:Create(n, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
			Size = UDim2.fromScale(0.7, 0.08)
		}):Play()

		if not persistent then
			task.wait(duration + 0.2)
			TweenService:Create(n, TweenInfo.new(0.2), {
				Size = UDim2.fromScale(0, 0)
			}):Play()
			task.wait(0.2)
			n:Destroy()
		end
	end)
end

getgenv().CreateOptionNotification = function(text, duration, onYes)
	if not NotificationsGui then return end
	duration = duration or 5

	task.spawn(function()
		local n = NotificationsGui.NotificationOptionTemplate:Clone()
		n.TextLabel.Text = text
		n.TextLabel.TextColor3 = Color3.new(1, 1, 1)
		n.Size = UDim2.fromScale(0, 0)
		n.Visible = true
		n.Parent = NotificationsGui.List

		n.Buttons.Yes.MouseButton1Click:Connect(function()
			if onYes then task.spawn(onYes) end
			n:Destroy()
		end)

		n.Buttons.No.MouseButton1Click:Connect(function()
			n:Destroy()
		end)

		TweenService:Create(n, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
			Size = UDim2.fromScale(0.7, 0.2)
		}):Play()

		task.wait(duration + 0.2)

		TweenService:Create(n, TweenInfo.new(0.2), {
			Size = UDim2.fromScale(0, 0)
		}):Play()

		task.wait(0.2)
		n:Destroy()
	end)
end

getgenv().DestroyNotificationWithId = function(id)
	if not NotificationsGui then return end
	for _, v in ipairs(NotificationsGui:FindFirstChild("List"):GetChildren()) do
		if v:IsA("Frame") and v:GetAttribute("NotifId") == id then
			v:Destroy()
		end
	end
end

getgenv().ShowNotificationWithId = function(id, visible)
	if not NotificationsGui then return end
	for _, v in ipairs(NotificationsGui:FindFirstChild("List"):GetChildren()) do
		if v:IsA("Frame") and v:GetAttribute("NotifId") == id then
			v.Visible = visible
		end
	end
end

getgenv().HasNotificationWithId = function(id)
	if not NotificationsGui then return end
	for _, v in ipairs(NotificationsGui:FindFirstChild("List"):GetChildren()) do
		if v:IsA("Frame") and v:GetAttribute("NotifId") == id then
			return true
		end
	end
	return false
end

getgenv().CreateNotification("Welcome to: Flames Hub | Southern Mudding!", 5, Color3.fromRGB(255, 0, 0), nil, Color3.fromRGB(0, 0, 0), false, "Notification-1")
getgenv().Auto_Eject_Anti_Sit_Toggle_UI = LocalPlayer_Tab:CreateToggle({
Name = "Anti Vehicle Sit (FE)",
Description = "Prevents you from sitting in Vehicles.",
CurrentValue = getgenv().AutoEject_Enabled or false,
Callback = function(state)
	getgenv().AutoEject_Toggle(state)
end}, "AntiVehicleSitToggledUIFE")

getgenv().Rainbow_Vehicle_UI_Toggle = VehiclesTab:CreateToggle({
Name = "Rainbow Vehicle (FE)",
Description = "Turns your vehicle RGB, other players can see it.",
CurrentValue = getgenv().RainbowVehicleEnabledFunc or false,
Callback = function(state)
	rainbow_vehicle_functionality(state)
end}, "CurrentRainbowVehicleUIToggle")

getgenv().Set_Vehicle_Fly_Speed = Config_Tab:CreateSlider({
Name = "Vehicle Fly Speed",
Range = {10, 300},
Increment = 10,
CurrentValue = getgenv().vehicle_fly_speed or 50,
Callback = function(new_fly_speed)
   getgenv().vehicle_fly_speed = new_fly_speed
end}, "Vehicle_Fly_Speed_Slider")

getgenv().Fly_Vehicle_Toggle_FE = VehiclesTab:CreateToggle({
	Name = "Vehicle Fly (FE)",
	Description = "Allows you to fly your current Vehicle smoothly.",
	CurrentValue = getgenv().vehicle_fly_enabled or false,
	Callback = function(state)
		getgenv().vehicle_fly_enabled = state
		if not state then
			if getgenv().Fly_Vehicle_Toggle_FE then
				getgenv().Fly_Vehicle_Toggle_FE:Set({ CurrentValue = false })
			end
		end
	end
}, "CurrentVehicleFlyUIToggle")

getgenv().Lock_Vehicle_Toggle_FE = VehiclesTab:CreateToggle({
Name = "Lock Vehicle (FE)",
Description = "Toggles the lock/unlock state on your Vehicle.",
CurrentValue = getgenv().currently_locked_vehicle or false,
Callback = function(state)
	getgenv().lock_vehicle_func(state)
end}, "LockVehicleCurrentUIToggle")

getgenv().Toggle_Vehicle_Started = VehiclesTab:CreateToggle({
	Name = "Toggle Vehicle Engine (FE)",
	Description = "Allows you to fully control your Vehicles engine state.",
	CurrentValue = (function()
		local ok, result = pcall(getgenv().is_current_vehicle_engine_on)
		if ok and result ~= nil then
			return result
		end
		return getgenv().car_engine_is_enabled or false
	end)(),
	Callback = function(state)
		getgenv().toggle_car_engine_state(state)
	end
}, "IsVehicleCurrentlyStartedUIToggle")

getgenv().Vehicle_Speed_Boost_Toggle = VehiclesTab:CreateToggle({
Name = "Custom Speed System (FE)",
Description = "Makes your Vehicle speed and braking a whole lot better and easier, and WAY faster.",
CurrentValue = getgenv().vehicle_speed_boost_active or false,
Callback = function(state)
	getgenv().vehicle_speed_boost_toggle(state)
end}, "VehicleSpeedBoostSystemToggleUI")

getgenv().Set_System_Forward_Speed = Config_Tab:CreateSlider({
Name = "Set 'Better System' Forward Speed (FE)",
Range = {50, 550},
Increment = 10,
CurrentValue = getgenv().vehicle_speed_boost_max_forward or 300,
Callback = function(new_forward_speed)
   getgenv().vehicle_speed_boost_max_forward = new_forward_speed
end}, "Slider_Value_Forward_Speed")

getgenv().Set_System_Backward_Speed = Config_Tab:CreateSlider({
Name = "Set 'Better System' Backward Speed (FE)",
Range = {50, 175},
Increment = 10,
CurrentValue = getgenv().vehicle_speed_boost_max_backward or 125,
Callback = function(new_backward_speed)
   getgenv().vehicle_speed_boost_max_backward = new_backward_speed
end}, "Slider_Value_Backward_Speed")

getgenv().Set_System_Acceleration = Config_Tab:CreateSlider({
Name = "Set 'Better System' Acceleration (FE)",
Range = {10, 100},
Increment = 10,
CurrentValue = getgenv().vehicle_speed_boost_acceleration or 10,
Callback = function(new_boost_acceleration)
   getgenv().vehicle_speed_boost_acceleration = new_boost_acceleration
end}, "Slider_Value_Acceleration")

getgenv().Change_Vehicle_Color_Random = VehiclesTab:CreateButton({
Name = "Randomize Vehicle Color (FE)",
Description = "Randomizes your vehicle color.",
Callback = function()
	getgenv().change_veh_color_func(nil, true)
end})