if not game:IsLoaded() then game.Loaded:Wait() end
local g = getgenv()
if not g.GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://pastebin.com/raw/T25mDhBZ"))()
   wait(0.1)
   g.GlobalEnvironmentFramework_Initialized = true
end
wait(0.5)
local Raw_Version = "V2.0.7"
local Script_Version = tostring(Raw_Version).."-DE"
local ReplicatedStorage = g.ReplicatedStorage or cloneref and cloneref(game:GetService("ReplicatedStorage")) or game:GetService("ReplicatedStorage")
local Players = g.Players or cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local Workspace = g.Workspace or cloneref and cloneref(game:GetService("Workspace")) or game:GetService("Workspace")
local RunService = g.RunService or cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
local TweenService = g.TweenService or cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
local MarketplaceService = g.MarketplaceService or cloneref and cloneref(game:GetService("MarketplaceService")) or game:GetService("MarketplaceService")
local Game_Name = MarketplaceService:GetProductInfo(game.PlaceId).Name
local LocalPlayer = g.LocalPlayer or g.Players.LocalPlayer or game.Players.LocalPlayer
g.get_vehicles_folder = g.get_vehicles_folder or function()
	local cache = g.vehicles_folder_cache
	if cache and cache:IsA("Folder") and cache.Parent then return cache end
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("Folder") and v.Name:lower():find("vehicles") then
			g.vehicles_folder_cache = v
			return v
		end
	end

	warn("get_vehicles_folder(): Vehicles folder not found.")
	return nil
end
wait(0.1)
if not g.vehicles_folder_cache then pcall(function() g.get_vehicles_folder() end) end

g.get_remotes_folder = g.get_remotes_folder or function()
	local cache = g.remotes_folder_cache
	if cache and cache:IsA("Folder") and cache.Parent then return cache end
	for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
		if v:IsA("Folder") and v.Name:lower():find("remotes") then
			g.remotes_folder_cache = v
			return v
		end
	end

	warn("get_remotes_folder(): Remotes folder not found.")
	return nil
end
wait(0.1)
if not g.remotes_folder_cache then pcall(function() g.get_remotes_folder() end) end

g.get_game_folder = g.get_game_folder or function()
	local cache = g.game_folder_cache
	if cache and cache:IsA("Folder") and cache.Parent then return cache end
	for _, v in ipairs(Workspace:GetDescendants()) do
		if v:IsA("Folder") and v.Name:lower():find("game") then
			g.game_folder_cache = v
			return v
		end
	end

	warn("get_game_folder(): Game folder not found.")
	return nil
end
wait(0.1)
if not g.game_folder_cache then pcall(function() g.get_game_folder() end) end

g.get_races_folder = g.get_races_folder or function()
	local cache = g.races_folder_cache
	if cache and cache:IsA("Folder") and cache.Parent then return cache end
	local Game_Folder = g.get_game_folder and g.get_game_folder()
	if not Game_Folder then
		warn("get_races_folder(): Game folder unavailable.")
		return nil
	end

	for _, v in ipairs(Game_Folder:GetDescendants()) do
		if v:IsA("Folder") and v.Name:lower():find("races") then
			g.races_folder_cache = v
			return v
		end
	end

	warn("get_races_folder(): Races folder not found.")
	return nil
end
wait(0.1)
if not g.races_folder_cache then pcall(function() g.get_races_folder() end) end

g.get_localsession_folder = g.get_localsession_folder or function()
	local cache = g.localsession_folder_cache
	if cache and cache:IsA("Folder") and cache.Parent then return cache end
	local Races = g.get_races_folder and g.get_races_folder()
	if not Races then
		warn("get_localsession_folder(): Races folder unavailable.")
		return nil
	end

	for _, v in ipairs(Races:GetDescendants()) do
		if v:IsA("Folder") and v.Name:lower():find("localsession") then
			g.localsession_folder_cache = v
			return v
		end
	end

	warn("get_localsession_folder(): LocalSession folder not found.")
	return nil
end
wait(0.1)
if not g.localsession_folder_cache then pcall(function() g.get_localsession_folder() end) end

g.get_custompurchase_rf = g.get_custompurchase_rf or function()
	local cache = g.custompurchase_rf_cache
	if cache and cache:IsA("RemoteFunction") and cache.Parent then return cache end
	local Remotes = g.get_remotes_folder and g.get_remotes_folder()
	if not Remotes then
		warn("get_custompurchase_rf(): Remotes folder unavailable.")
		return nil
	end

	for _, v in ipairs(Remotes:GetDescendants()) do
		if v:IsA("RemoteFunction") and v.Name:lower():find("customization") and v.Name:lower():find("purchase") then
			g.custompurchase_rf_cache = v
			return v
		end
	end

	warn("get_custompurchase_rf(): CustomizationPurchase RemoteFunction not found.")
	return nil
end
wait(0.1)
if not g.custompurchase_rf_cache then pcall(function() g.get_custompurchase_rf() end) end

g.get_racestart_re = g.get_racestart_re or function()
	local cache = g.racestart_re_cache
	if cache and cache:IsA("RemoteEvent") and cache.Parent then return cache end
	local Remotes = g.get_remotes_folder and g.get_remotes_folder()
	if not Remotes then
		warn("get_racestart_re(): Remotes folder unavailable.")
		return nil
	end

	for _, v in ipairs(Remotes:GetDescendants()) do
		if v:IsA("RemoteEvent") and v.Name:lower():find("racestart") then
			g.racestart_re_cache = v
			return v
		end
	end

	warn("get_racestart_re(): RaceStartTimeTrial RemoteEvent not found.")
	return nil
end
wait(0.1)
if not g.racestart_re_cache then pcall(function() g.get_racestart_re() end) end

g.get_teleport_re = g.get_teleport_re or function()
	local cache = g.teleport_re_cache
	if cache and cache:IsA("RemoteEvent") and cache.Parent then return cache end
	local Remotes = g.get_remotes_folder and g.get_remotes_folder()
	if not Remotes then
		warn("get_teleport_re(): Remotes folder unavailable")
		return nil
	end

	for _, v in ipairs(Remotes:GetDescendants()) do
		if v:IsA("RemoteEvent") and v.Name:lower():find("teleport") then
			g.teleport_re_cache = v
			return v
		end
	end

	warn("get_teleport_re(): Teleport RemoteEvent not found")
	return nil
end
wait(0.1)
if not g.teleport_re_cache then pcall(function() g.get_teleport_re() end) end

g.get_checkpoint_rf = g.get_checkpoint_rf or function()
	local cache = g.checkpoint_rf_cache
	if cache and cache:IsA("RemoteFunction") and cache.Parent then return cache end
	local Remotes = g.get_remotes_folder and g.get_remotes_folder()
	if not Remotes then
		warn("get_checkpoint_rf(): Remotes folder unavailable")
		return nil
	end

	for _, v in ipairs(Remotes:GetDescendants()) do
		if v:IsA("RemoteFunction") and v.Name:lower():find("checkpoint") then
			g.checkpoint_rf_cache = v
			return v
		end
	end

	warn("get_checkpoint_rf(): RaceCheckpoint RemoteFunction not found")
	return nil
end
wait(0.1)
if not g.checkpoint_rf_cache then pcall(function() g.get_checkpoint_rf() end) end

local Vehicles = g.vehicles_folder_cache or g.get_vehicles_folder()
local Remotes = g.remotes_folder_cache or g.get_remotes_folder()
local Game_Folder = g.game_folder_cache or g.get_game_folder()
local Races = g.races_folder_cache or g.get_races_folder()
local LocalSession = g.localsession_folder_cache or g.get_localsession_folder()
local CustomPurchase_RF = g.custompurchase_rf_cache or g.get_custompurchase_rf()
local RaceStart_RE = g.racestart_re_cache or g.get_racestart_re()
local Teleport_RE = g.teleport_re_cache or g.get_teleport_re()
local Checkpoint_RF = g.checkpoint_rf_cache or g.get_checkpoint_rf()

if not getgenv().HasSeen_Loading_Screen then
    local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
    local player = Players.LocalPlayer
    local player_name = player.DisplayName
    local TweenService = cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
    local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    local parent_gui = (get_hidden_gui and get_hidden_gui()) or (gethui and gethui()) or CoreGui
    local scramble_time = 4.5
    local scramble_speed = 0.05
    local fade_out_text_time = 10
    local fade_out_background_time = 10

    local screen_gui = Instance.new("ScreenGui")
    screen_gui.Name = "fullscreenscramblegui"
    screen_gui.Parent = parent_gui
    screen_gui.IgnoreGuiInset = true
    screen_gui.ResetOnSpawn = false

    local background_frame = Instance.new("Frame")
    background_frame.Size = UDim2.new(1, 0, 1, 0)
    background_frame.Position = UDim2.new(0, 0, 0, 0)
    background_frame.BackgroundTransparency = 1
    background_frame.Parent = screen_gui

    local ui_gradient = Instance.new("UIGradient")
    ui_gradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 0, 100)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 200))
    }
    ui_gradient.Rotation = 45
    ui_gradient.Parent = background_frame

    local fadein_info = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
    TweenService:Create(background_frame, fadein_info, {BackgroundTransparency = 0}):Play()

    local welcome_label = Instance.new("TextLabel")
    welcome_label.Size = UDim2.new(1, 0, 0.1, 0)
    welcome_label.Position = UDim2.new(0, 0, 0.35, 0)
    welcome_label.BackgroundTransparency = 1
    welcome_label.TextColor3 = Color3.fromRGB(0, 0, 0)
    welcome_label.Font = Enum.Font.Garamond
    welcome_label.TextScaled = true
    welcome_label.Text = "Welcome, " .. tostring(player_name)
    welcome_label.Parent = screen_gui

    local text_label = Instance.new("TextLabel")
    text_label.Size = UDim2.new(1, 0, 0.2, 0)
    text_label.Position = UDim2.new(0, 0, 0.5, 0)
    text_label.BackgroundTransparency = 1
    text_label.TextColor3 = Color3.fromRGB(255, 255, 255)
    text_label.Font = Enum.Font.SourceSansBold
    text_label.TextScaled = true
    text_label.TextTransparency = 1
    text_label.Parent = screen_gui

    local copyright_label = Instance.new("TextLabel")
    copyright_label.Size = UDim2.new(1, 0, 0.1, 0)
    if getgenv().UserInputService.TouchEnabled then
        copyright_label.Position = UDim2.new(0, 0, 0.7, 0)
    else
        copyright_label.Position = UDim2.new(0, 0, 0.8, 0)
    end
    copyright_label.BackgroundTransparency = 1
    copyright_label.TextColor3 = Color3.fromRGB(50, 50, 50)
    copyright_label.Font = Enum.Font.SourceSans
    copyright_label.TextScaled = true
    copyright_label.Text = "© Flames Hub | 2025 | Powerful Services | Enjoyable utilities | ©"
    copyright_label.Parent = screen_gui

    local function scramble_text(t)
        local s = ""
        for i = 1, #t do
            local c = string.char(math.random(48, 122))
            while not (c:match("%a") or c:match("%d")) do
                c = string.char(math.random(48, 122))
            end
            s = s .. c
        end
        return s
    end

    local function reveal_text(scramble_time, main_text, label)
        local time = 0
        while time < scramble_time do
            label.Text = scramble_text(main_text)
            label.TextTransparency = 0
            time = time + scramble_speed
            task.wait(scramble_speed)
        end
        label.Text = main_text
    end

    local function fade_out_text(label)
        TweenService:Create(label, TweenInfo.new(fade_out_text_time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {TextTransparency = 1}):Play()
    end

    local function move_out_text()
        TweenService:Create(text_label, TweenInfo.new(fade_out_text_time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 0)}):Play()
    end

    local function rgb_cycle(label)
        local t = 0.7
        local list = {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 165, 0),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(255, 0, 255)
        }

        getgenv().rgb_running_background_fading_tween = true
        while getgenv().rgb_running_background_fading_tween do
            for _, col in ipairs(list) do
                TweenService:Create(label, TweenInfo.new(t, Enum.EasingStyle.Linear), {TextColor3 = col}):Play()
                task.wait(t)
            end
        end
    end

    task.spawn(function()
        reveal_text(scramble_time, welcome_label.Text, welcome_label)
        rgb_cycle(welcome_label)
    end)

    task.spawn(function()
        reveal_text(scramble_time, "You are now tuning into 'Flames Hub | Services', Enjoy!", text_label)
        rgb_cycle(text_label)
    end)

    task.wait(scramble_time + 1)

    getgenv().rgb_running_background_fading_tween = false

    fade_out_text(welcome_label)
    fade_out_text(text_label)
    fade_out_text(copyright_label)
    move_out_text()

    TweenService:Create(background_frame, TweenInfo.new(fade_out_background_time, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {BackgroundTransparency = 1}):Play()

    task.wait(fade_out_background_time + 1)
    screen_gui:Destroy()
    getgenv().HasSeen_Loading_Screen = true
end

getgenv().convert_color3 = function(r, g, b)
    return Color3.new(r/255, g/255, b/255)
end

local colors = {
   Color3.new(0.6392157077789307, 0.6352941393852234, 0.6470588445663452),
   Color3.new(0.4588235318660736, 0, 0),
   Color3.new(0.20000000298023224, 0.3450980484485626, 0.5098039507865906),
   Color3.new(0.06666667014360428, 0.06666667014360428, 0.06666667014360428),
   Color3.new(1, 0.6901960968971252, 0),
   Color3.new(0.1568627506494522, 0.1568627506494522, 0.1568627506494522),
   Color3.new(0.8313725590705872, 0, 0),
   Color3.new(0.1725490242242813, 0.3960784375667572, 0.11372549086809158),
   Color3.new(0, 0.125490203499794, 0.3764705955982208),
   Color3.new(0.3803921639919281, 0.3764705955982208, 0.3843137323856354),
   Color3.new(0.9725490212440491, 0.9725490212440491, 0.9725490212440491),
   Color3.new(0.6274510025978088, 0.5176470875740051, 0.30980393290519714),
   Color3.new(1, 0.8352941274642944, 0),
   Color3.new(0.8352941274642944, 0.45098039507865906, 0.239215686917305),
   Color3.new(0.03529411926865578, 0.5372549295425415, 0.8117647171020508),
   Color3.new(0.9098039269447327, 0.3137255012989044, 0.0313725508749485),
   Color3.new(0.33725491166114807, 0.1411764770746231, 0.1411764770746231),
   Color3.new(0.3137255012989044, 0.529411792755127, 0.25882354378700256),
   Color3.new(0.15294118225574493, 0.27450981736183167, 0.1764705926179886),
   Color3.new(0.8549019694328308, 0.5215686559677124, 0.2549019753932953),
   Color3.new(0.48235294222831726, 0, 0.48235294222831726),
   Color3.new(0.4156862795352936, 0.6117647290229797, 0.886274516582489),
   Color3.new(0.41960784792900085, 0.19607843458652496, 0.48627451062202454),
   Color3.new(0.48627451062202454, 0.3607843220233917, 0.27450981736183167),
   Color3.new(0, 1, 0),
   Color3.new(0, 0, 0)
}

local Vehicle_Calipers = {"FL", "FR", "RL", "RR"}
local function Get_Vehicle()
	local Vehicles = workspace:FindFirstChild("Vehicles")
	if not Vehicles then
		g.notify("Error", "Vehicles folder not found in workspace.", 3)
		return nil
	end

	if not LocalPlayer then
		g.notify("Error", "LocalPlayer not found.", 3)
		return nil
	end

	g.vehicles_folder_cache = Vehicles
	local targetName = LocalPlayer.Name
	local model = nil
	local debug_names = {}
	for _, v in ipairs(Vehicles:GetChildren()) do
		table.insert(debug_names, v.Name .. "(" .. v.ClassName .. ")")
		if v.Name == targetName then
			model = v
			break
		end
	end

	if not model then
		print("[Get_Vehicle] target='" .. targetName .. "'")
		print("[Get_Vehicle] children=" .. table.concat(debug_names, ", "))
		g.notify("Error", "Get_Vehicle(): You do not have a Vehicle spawned.", 3)
		return nil
	end

	local success, vehicleId = pcall(function()
		return model:GetAttribute("VehicleId")
	end)

	if not success then
		g.notify("Error", "Failed to read VehicleId.", 3)
		return nil
	end

	return vehicleId or nil
end

local function Get_Vehicle_Model()
	local Vehicles = g.vehicles_folder_cache or g.get_vehicles_folder and g.get_vehicles_folder()
	if not Vehicles then
		g.notify("Error", "Vehicles folder not found.", 3)
		return nil
	end

	if not LocalPlayer then
		g.notify("Error", "LocalPlayer not found.", 3)
		return nil
	end

	local model = Vehicles:FindFirstChild(LocalPlayer.Name)
	if not model then
		g.notify("Error", "Get_Vehicle_Model(): You do not have a Vehicle spawned.", 3)
		return nil
	end

	return model
end
wait(0.1)
g.get_vehicle = Get_Vehicle_Model

function Fire_F(RemoteF, Args)
	if not RemoteF or not RemoteF:IsA("RemoteFunction") then
		g.notify("Error", "RemoteFunction not provided!", 3)
		return nil
	end

	return RemoteF:InvokeServer(unpack(Args))
end

function Fire_E(RemoteE, Args)
	if not RemoteE or not RemoteE:IsA("RemoteEvent") then
		g.notify("Error", "RemoteEvent not provided!", 3)
		return nil
	end

	RemoteE:FireServer(unpack(Args))
end

function change_car_color(color)
    local Vehicle = Get_Vehicle()
    if not Vehicle then return g.notify("Error", "Vehicle: "..tostring(Vehicle).." is not a Vehicle or does not exist.", 3) end
    local args = {
        "Paint",
        "Primary",
        Get_Vehicle(),
        {
            Color = color,
            Reflectance = 0
        }
    }
    
    Fire_F(CustomPurchase_RF, args)
end

function change_rim_color(color)
    local Vehicle = Get_Vehicle()
    if not Vehicle then return end
    for i, caliper in pairs(Vehicle_Calipers) do
        local args = {
            "Paint",
            "WheelRim"..caliper,
            Get_Vehicle(),
            {
                Color = color,
                Reflectance = 0
            }
        }
        
        Fire_F(CustomPurchase_RF, args)
    end
end

function change_headlights_color(color)
    local Vehicle = Get_Vehicle()
    if not Vehicle then return end
    local args = {
        "Paint",
        "Headlights",
        Get_Vehicle(),
        {
            Color = color
        }
    }

    Fire_F(CustomPurchase_RF, args)
end

function change_interior_color(color)
    local Vehicle = Get_Vehicle()
    if not Vehicle then return end
    local args = {
        "Paint",
        "Interior",
        Get_Vehicle(),
        {
            Color = color
        }
    }

    Fire_F(CustomPurchase_RF, args)
end

function change_caliper_color(color)
    local Vehicle = Get_Vehicle()
    if not Vehicle then return end
    for i, caliper in pairs(Vehicle_Calipers) do
        local args = {
            "Paint",
            "WheelCaliper"..caliper,
            Get_Vehicle(),
            {
                Color = color
            }
        }

        Fire_F(CustomPurchase_RF, args)
    end
end

function change_nitro_color(color)
    local Vehicle = Get_Vehicle()
    if not Vehicle then return end
    local args = {
        "Paint",
        "NitrousPrimary",
        Get_Vehicle(),
        {
            Color = color
        }
    }
    local args_2 = {
        "Paint",
        "NitrousSecondary",
        Get_Vehicle(),
        {
            Color = color
        }
    }

    Fire_F(CustomPurchase_RF, args)
    Fire_F(CustomPurchase_RF, args_2)
end

-- Not in use right now, costs money, but we'll see how I implement it.
function change_suspension(Suspension)
    local Vehicle = Get_Vehicle()
    if not Vehicle then return end
    local args = {
        "Suspension",
        "Height",
        Get_Vehicle(),
        {
            RL = tonumber(Suspension),
            RR = tonumber(Suspension),
            FR = tonumber(Suspension),
            FL = tonumber(Suspension)
        }
    }
    
    Fire_F(CustomPurchase_RF, args)
end

g.vehicle_fly = g.vehicle_fly or false
g.vehicle_fly_speed = g.vehicle_fly_speed or 3
g.vehiclefly_conns = g.vehiclefly_conns or {}
g.vehiclefly_control = {f=0,b=0,l=0,r=0,q=0,e=0}
g.vehiclefly_noclip = g.vehiclefly_noclip or false
g.vehiclefly_collisions = g.vehiclefly_collisions or {}
local controlModule
if UserInputService.TouchEnabled then controlModule = require(g.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule")) end
g.cleanup = g.cleanup or function()
    for _, c in pairs(g.vehiclefly_conns) do
        pcall(function() c:Disconnect() end)
    end
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
end

g.enable_vehicle_noclip = function()
    if g.vehiclefly_noclip then return end
    g.vehiclefly_noclip = true
    g.vehiclefly_collisions = {}
    local car = g.get_vehicle()
    if not car then return end
    if g.ToggleNoclip and typeof(g.ToggleNoclip) == "function" then g.ToggleNoclip(true) end
    for _, v in ipairs(car:GetDescendants()) do
        if v:IsA("BasePart") then
            g.vehiclefly_collisions[v] = v.CanCollide
            v.CanCollide = false
        end
    end
end

g.disable_vehicle_noclip = function()
    if not g.vehiclefly_noclip then return end
    g.vehiclefly_noclip = false
    if g.ToggleNoclip and typeof(g.ToggleNoclip) == "function" then g.ToggleNoclip(false) end
    for part, state in pairs(g.vehiclefly_collisions) do
        if part and part.Parent then
            part.CanCollide = state
        end
    end
    g.vehiclefly_collisions = {}
end

g.start_vehicle_fly = function()
    if g.vehiclefly_bg or g.vehiclefly_bv then return end
    local car = g.get_vehicle()
    if not car then
        g.disable_vehicle_noclip()
        task.wait()
        g.cleanup()
        g.notify("Error", "You do not have a Vehicle spawned.", 5)
        return
    end

    local base = car:FindFirstChild("Base")
        or car.PrimaryPart
        or car:FindFirstChildWhichIsA("BasePart")

    if not base then
        g.notify("Error", "No usable root part found in vehicle: " .. tostring(car), 3)
        return
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
            if not base.Parent then
                if g.main_vehicle_fly_UI_toggle then
                    g.main_vehicle_fly_UI_toggle:Set(false, false)
                end
                if g.stop_vehicle_fly then
                    g.stop_vehicle_fly()
                else
                    g.cleanup()
                end
            end
            return
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
            bv.Velocity = (
                cam.CFrame.LookVector * forward
                + cam.CFrame.RightVector * right
                + Vector3.new(0, up, 0)
            ) * (45 * g.vehicle_fly_speed)
        end
    end)

    if not isMobile then
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

getgenv().vehicle_speed_boost_toggle = function(toggled)
    if toggled == true then
        if getgenv().vehicle_speed_boost_active then return end
        local current_vehicle = g.get_vehicle()
        if not current_vehicle then return getgenv().notify("Error", "No vehicle found.", 3) end
        local DriveSeat = current_vehicle:FindFirstChildOfClass("VehicleSeat")
        if not DriveSeat then return getgenv().notify("Error", "No VehicleSeat found.", 3) end
        local Player = g.LocalPlayer or cloneref and cloneref(game:GetService("Players")).LocalPlayer or game.Players.LocalPlayer
        local Current_Speed = 0
        local S_Hold_Start = nil
        local Is_Mobile = g.UserInputService.TouchEnabled or cloneref and cloneref(game:GetService("UserInputService")).TouchEnabled or game:GetService("UserInputService").TouchEnabled
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
        local current_vehicle = g.get_vehicle()
        if not current_vehicle then return end
        local DriveSeat = current_vehicle:FindFirstChildOfClass("VehicleSeat")
        if not DriveSeat then return end
        local BV = DriveSeat:FindFirstChild("FlamesSpeedBoost")
        local BG = DriveSeat:FindFirstChild("FlamesSpeedGyro")
        if BV then BV:Destroy() end
        if BG then BG:Destroy() end
        getgenv().notify("Success", "Vehicle Speed Boost is now disabled.", 1.5)
    end
end

local function get_executor()
    local name
    if identifyexecutor then
        name = identifyexecutor()
    end

    return { Name = name or "Unknown Executor"}
end

local function detect_executor()
    local executor_details = get_executor()
    return string.format("%s", executor_details.Name)
end
wait(0.1)
local executor_Name = detect_executor()

function low_level_executor()
    if executor_Name == "Solara" or string.find(executor_Name, "JJSploit") or executor_Name == "Xeno" then
        return true
    else
        return false
    end
end

local function LocalPlayer_loaded()
    local player = Players.LocalPlayer
    if not player then
        repeat task.wait() until Players.LocalPlayer
        player = Players.LocalPlayer
    end

    if not player.Character or not player.Character:FindFirstChild("Humanoid") then
        player.CharacterAdded:Wait()
        repeat task.wait() until player.Character:FindFirstChild("Humanoid")
    end
end

local function render_safe()
    RunService.RenderStepped:Wait()
    task.wait(0.2)
end

local function load_rayfield()
    local attempts = 0
    local maxAttempts = 10
    local success = false
    local result

    repeat
        attempts += 1
        success, result = pcall(function()
            local raw = game:HttpGet("https://pastefy.app/oH3cwZUj/raw")
            local func = loadstring(raw)
            return func()
        end)

        if not success or not result then
            task.wait(1)
        end
    until (success and result) or attempts >= maxAttempts

    return result
end

local Window
LocalPlayer_loaded()
render_safe()

Rayfield = load_rayfield()
if typeof(Rayfield) == "table" and Rayfield.CreateWindow then
    Window = Rayfield:CreateWindow({
        Name = tostring(Game_Name).." | "..tostring(Script_Version).." | "..tostring(executor_Name),
        LoadingTitle = "Welcome, "..tostring(LocalPlayer),
        LoadingSubtitle = "Driving Empire | Hub.",
        ConfigurationSaving = {
            Enabled = false,
            FolderName = "DrivingEmpire-Config",
            FileName = "DrivingEmpire_ScriptHub"
        },
        Discord = {
            Enabled = false,
            Invite = "",
            RememberJoins = false
        },
        KeySystem = false,
        KeySettings = {
            Title = "None",
            Subtitle = "No key system is provided.",
            Note = "lmao.",
            FileName = "Key",
            SaveKey = false,
            GrabKeyFromSite = false,
            Key = {""}
        }
    })
end
wait(1)
function R_Notify(title, content, duration)
    if getgenv().notify then
        getgenv().notify(tostring(title), tostring(content), tonumber(duration))
    end
end
wait(0.2)
local Tab1 = Window:CreateTab("🏡 Main 🏡", 0)
local Section1 = Tab1:CreateSection("| 🏡 Main 🏡 |")
local Tab2 = Window:CreateTab("⭐ Extras ⭐", 0)
local Section2 = Tab2:CreateSection("| ⭐ Extra Content ⭐ |")
local Tab3 = Window:CreateTab("🏎️ Vehicle 🏎️", 0)
local Section3 = Tab3:CreateSection("| 🏎️ Vehicle Content 🏎️ |")
wait(0.2)
getgenv().RainbowVehicleToggle = Tab3:CreateToggle({
Name = "Rainbow Vehicle (FE)",
CurrentValue = getgenv().Rainbow_Vehicle_Toggle or false,
Flag = "RainbowCarFEToggle",
Callback = function(Rainbow_Vehicle_Enabled)
    if Rainbow_Vehicle_Enabled then
        getgenv().Rainbow_Vehicle_Toggle = true
        while getgenv().Rainbow_Vehicle_Toggle == true do
        task.wait(0)
            for _, color_change in pairs(colors) do
                change_car_color(color_change)
                task.wait()
            end
        end
    else
        getgenv().Rainbow_Vehicle_Toggle = false
    end
end,})

getgenv().RainbowRimsToggle = Tab3:CreateToggle({
Name = "Rainbow Rims (FE)",
CurrentValue = getgenv().Rainbow_Rims_Toggle or false,
Flag = "RainbowRimsFEToggle",
Callback = function(Rainbow_Rims_Enabled)
    if Rainbow_Rims_Enabled then
        getgenv().Rainbow_Rims_Toggle = true
        while getgenv().Rainbow_Rims_Toggle == true do
        task.wait(0)
            for _, color_change in pairs(colors) do
                change_rim_color(color_change)
                task.wait()
            end
        end
    else
        getgenv().Rainbow_Rims_Toggle = false
    end
end,})

getgenv().RainbowHeadlightsToggle = Tab3:CreateToggle({
Name = "Rainbow Headlights (FE)",
CurrentValue = getgenv().Rainbow_Headlights_Toggle or false,
Flag = "RainbowHeadlightsFEToggle",
Callback = function(Rainbow_Headlights_Enabled)
    if Rainbow_Headlights_Enabled then
        getgenv().Rainbow_Headlights_Toggle = true
        while getgenv().Rainbow_Headlights_Toggle == true do
        task.wait(0)
            for _, color_change in pairs(colors) do
                change_headlights_color(color_change)
                task.wait()
            end
        end
    else
        getgenv().Rainbow_Headlights_Toggle = false
    end
end,})

getgenv().RainbowInteriorToggle = Tab3:CreateToggle({
Name = "Rainbow Interior (FE)",
CurrentValue = getgenv().Rainbow_Interior_Toggle or false,
Flag = "RainbowInteriorFEToggle",
Callback = function(Rainbow_Interior_Enabled)
    if Rainbow_Interior_Enabled then
        getgenv().Rainbow_Interior_Toggle = true
        while getgenv().Rainbow_Interior_Toggle == true do
        task.wait(0)
            for _, color_change in pairs(colors) do
                change_interior_color(color_change)
                task.wait()
            end
        end
    else
        getgenv().Rainbow_Interior_Toggle = false
    end
end,})

getgenv().RainbowCalipersToggle = Tab3:CreateToggle({
Name = "Rainbow Calipers (FE)",
CurrentValue = getgenv().Rainbow_Calipers_Toggle or false,
Flag = "RainbowCalipersFEToggle",
Callback = function(Rainbow_Calipers_Enabled)
    if Rainbow_Calipers_Enabled then
        getgenv().Rainbow_Calipers_Toggle = true
        while getgenv().Rainbow_Calipers_Toggle == true do
        task.wait(0)
            for _, color_change in pairs(colors) do
                change_caliper_color(color_change)
                task.wait()
            end
        end
    else
        getgenv().Rainbow_Calipers_Toggle = false
    end
end,})

getgenv().RainbowNitroToggle = Tab3:CreateToggle({
Name = "Rainbow Nitro (FE)",
CurrentValue = getgenv().Rainbow_Nitro_Toggle or false,
Flag = "RainbowNitroFEToggle",
Callback = function(Rainbow_Nitro_Enabled)
    if Rainbow_Nitro_Enabled then
        getgenv().Rainbow_Nitro_Toggle = true
        while getgenv().Rainbow_Nitro_Toggle == true do
        task.wait(0)
            for _, color_change in pairs(colors) do
                change_nitro_color(color_change)
                task.wait()
            end
        end
    else
        getgenv().Rainbow_Nitro_Toggle = false
    end
end,})

local Result = low_level_executor()
if Result == false then
    getgenv().TurnRadius = Tab1:CreateSlider({ 
    Name = "Turn Radius",
    Range = {0, 250},
    Increment = 1,
    Suffix = "",
    CurrentValue = 30,
    Flag = "SlidingTurnRadiusValue",
    Callback = function(Turn_Radius)
        local Vehicle = Get_Vehicle_Model()
        if not Vehicle then return  end
        local Tuning_Module_S = Vehicle and Vehicle:FindFirstChild("Tune") or Vehicle and Vehicle:WaitForChild("Tune", 3)
        if not Tuning_Module_S then return end
        local Req_TuneModule = require(Tuning_Module_S)
        if not Req_TuneModule then return end
        Req_TuneModule["TurnRadius"] = tonumber(Turn_Radius)
    end,})

    getgenv().TurnSpeed = Tab1:CreateSlider({ 
    Name = "Turn Speed",
    Range = {0, 20},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 1,
    Flag = "SlidingTurnSpeedValue",
    Callback = function(Turn_Speed)
        local Vehicle = Get_Vehicle_Model()
        if not Vehicle then return  end
        local Tuning_Module_S = Vehicle and Vehicle:FindFirstChild("Tune") or Vehicle and Vehicle:WaitForChild("Tune", 3)
        if not Tuning_Module_S then return end
        local Req_TuneModule = require(Tuning_Module_S)
        if not Req_TuneModule then return end
        Req_TuneModule["TurnSpeed"] = tonumber(Turn_Speed)
    end,})

    getgenv().BrakeTorque = Tab1:CreateSlider({ 
    Name = "Brake Torque",
    Range = {50, 100000},
    Increment = 100,
    Suffix = "",
    CurrentValue = 5000,
    Flag = "SlidingBrakeTorqueValue",
    Callback = function(Brake_Torque)
        local Vehicle = Get_Vehicle_Model()
        if not Vehicle then return  end
        local Tuning_Module_S = Vehicle and Vehicle:FindFirstChild("Tune") or Vehicle and Vehicle:WaitForChild("Tune", 3)
        if not Tuning_Module_S then return end
        local Req_TuneModule = require(Tuning_Module_S)
        if not Req_TuneModule then return end
        Req_TuneModule["BrakeTorque"] = tonumber(Brake_Torque)
    end,})

    getgenv().EngineTop = Tab1:CreateSlider({ 
    Name = "Engine Top",
    Range = {100, 25000},
    Increment = 5,
    Suffix = "",
    CurrentValue = 5000,
    Flag = "SlidingEngineTopValue",
    Callback = function(Engine_Top)
        local Vehicle = Get_Vehicle_Model()
        if not Vehicle then return  end
        local Tuning_Module_S = Vehicle and Vehicle:FindFirstChild("Tune") or Vehicle and Vehicle:WaitForChild("Tune", 3)
        if not Tuning_Module_S then return end
        local Req_TuneModule = require(Tuning_Module_S)
        if not Req_TuneModule then return end
        Req_TuneModule["EngineTop"] = tonumber(Engine_Top)
    end,})

    getgenv().Turbo = Tab1:CreateToggle({ 
    Name = "Turbo",
    CurrentValue = false,
    Flag = "TurboChargersVehicleToggle",
    Callback = function(Turbo_Enabled)
        if Turbo_Enabled then
            getgenv().Turbo_Chargers_Enabled = true
            local Vehicle = Get_Vehicle_Model()
            if not Vehicle then return notify("Error", "No Vehicle available, spawn one!", 3) end
            local Tuning_Module_S = Vehicle and Vehicle:FindFirstChild("Tune") or Vehicle and Vehicle:WaitForChild("Tune", 3)
            if not Tuning_Module_S then return notify("Error", "No Vehicle available, spawn one!", 3) end
            local Req_TuneModule = require(Tuning_Module_S)
            if not Req_TuneModule then return notify("Error", "No Vehicle available, spawn one!", 3) end
            Req_TuneModule["Turbo"] = true
        else
            getgenv().Turbo_Chargers_Enabled = false
            local Vehicle = Get_Vehicle_Model()
            if not Vehicle then
                return notify("Error", "No Vehicle available, spawn one!", 3)
            end
            local Tuning_Module_S = Vehicle and Vehicle:FindFirstChild("Tune") or Vehicle and Vehicle:WaitForChild("Tune", 3)
            if not Tuning_Module_S then return notify("Error", "No Vehicle available, spawn one!", 3) end
            local Req_TuneModule = require(Tuning_Module_S)
            if not Req_TuneModule then return notify("Error", "No Vehicle available, spawn one!", 3) end
            Req_TuneModule["Turbo"] = false
        end
    end,})

    getgenv().Superchargers = Tab1:CreateToggle({ 
    Name = "Supercharger",
    CurrentValue = false,
    Flag = "SuperChargersVehicleToggle",
    Callback = function(Supercharger_Enabled)
        if Supercharger_Enabled then
            getgenv().Supercharger_Chargers_Enabled = true
            local Vehicle = Get_Vehicle_Model()
            if not Vehicle then return notify("Error", "No Vehicle available, spawn one!", 3) end
            local Tuning_Module_S = Vehicle and Vehicle:FindFirstChild("Tune") or Vehicle and Vehicle:WaitForChild("Tune", 3)
            if not Tuning_Module_S then return notify("Error", "No Vehicle available, spawn one!", 3) end
            local Req_TuneModule = require(Tuning_Module_S)
            if not Req_TuneModule then return notify("Error", "No Vehicle available, spawn one!", 3) end
            Req_TuneModule["SuperCharger"] = true
        else
            getgenv().Supercharger_Chargers_Enabled = false
            local Vehicle = Get_Vehicle_Model()
            if not Vehicle then return notify("Error", "No Vehicle available, spawn one!", 3) end
            local Tuning_Module_S = Vehicle and Vehicle:FindFirstChild("Tune") or Vehicle and Vehicle:WaitForChild("Tune", 3)
            if not Tuning_Module_S then return notify("Error", "No Vehicle available, spawn one!", 3) end
            local Req_TuneModule = require(Tuning_Module_S)
            if not Req_TuneModule then return notify("Error", "No Vehicle available, spawn one!", 3) end
            Req_TuneModule["SuperCharger"] = false
        end
    end,})
else
    g.notify("Error", "Vehicle modification not enabled, low level executor detected.", 5)
end
wait(0.2)
local StartPosition = CFrame.new(4940.19775, 61.0195084, -1933.99927)
local EndPosition   = CFrame.new(1827.3407, 61.0150146, -658.946655)
local function TP(cframe)
    local car = Get_Vehicle_Model()
    if car and car.PrimaryPart then
        car:SetPrimaryPartCFrame(cframe)
    end
end

local function DriveForward(duration, speed)
    local car = Get_Vehicle_Model()
    if not car then return end
    local Weight = car:FindFirstChild("Weight")
    if not Weight then return end

    Weight.Anchored = false
    Weight.AssemblyLinearVelocity = car.PrimaryPart.CFrame.LookVector * speed
    task.wait(duration)
    Weight.AssemblyLinearVelocity = Vector3.new(0,0,0)
end

local function VelocityTP(cframe)
    local car = Get_Vehicle_Model()
    if not car or not car.PrimaryPart then getgenv().AutoFarm_Running = false return end
    local TeleportSpeed = 300
    local BodyGyro = Instance.new("BodyGyro", car.PrimaryPart)
    BodyGyro.P = 3000
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = car.PrimaryPart.CFrame
    local BodyVelocity = Instance.new("BodyVelocity", car.PrimaryPart)
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.Velocity = CFrame.new(car.PrimaryPart.Position, cframe.Position).LookVector * TeleportSpeed
    wait((car.PrimaryPart.Position - cframe.Position).Magnitude / TeleportSpeed)
    BodyVelocity.Velocity = Vector3.new()
    wait(0.1)
    BodyVelocity:Destroy()
    BodyGyro:Destroy()
end
wait(0.2)
getgenv().AutoFarm_Running = getgenv().AutoFarm_Running or false
local function StartAutoFarm()
    if getgenv().AutoFarm_Running then return g.notify("Error", "Auto Farm is already enabled!", 1) end
    getgenv().AutoFarm_Running = true
    task.spawn(function()
        while getgenv().AutoFarm_Running == true do
            pcall(function()
                local car = Get_Vehicle_Model()
                if not car then return end
                DriveForward(1, math.random(250,600))
                car:SetPrimaryPartCFrame(EndPosition + Vector3.new(0,3,0))
                DriveForward(1, math.random(250,600))
                car:SetPrimaryPartCFrame(StartPosition + Vector3.new(0,3,0))
            end)
            task.wait(0.5)
        end
    end)
end

local function PushCarForward(speed, duration)
    local car = Get_Vehicle_Model()
    if not car or not car.PrimaryPart then return end
    local Weight = car:FindFirstChild("Weight")
    if not Weight then return end
    Weight.Anchored = false
    Weight.AssemblyLinearVelocity = car.PrimaryPart.CFrame.LookVector * speed
    task.wait(duration or 0.5)
    Weight.AssemblyLinearVelocity = Vector3.new(0,5,0)
end

local function StopAutoFarm()
    getgenv().AutoFarm_Running = false
    local car = Get_Vehicle_Model()
    if car and car:IsA("Model") then
        local Weight = car and car:FindFirstChild("Weight")
        if Weight and Weight:IsA("BasePart") then
            Weight.AssemblyLinearVelocity = Vector3.new(0,0,0)
        end
    end
end
wait(0.2)
getgenv().AutoFarm_VehicleMethod = Tab1:CreateToggle({
Name = "Auto Farm (Method 1, BYPASSES NEW LIMIT/DELAY!)",
CurrentValue = getgenv().Auto_Farm_Enabled or false,
Flag = "EzAutoFarmMethod1",
Callback = function(auto_farm_1)
    local car = Get_Vehicle_Model()
    if not Get_Vehicle() then
        StopAutoFarm()
        getgenv().Auto_Farm_Enabled = false
        getgenv().AutoFarm_VehicleMethod:Set(false)
        return R_Notify("Error", "Spawn a Vehicle before using this!", 5)
    end

    if not car then
        StopAutoFarm()
        getgenv().Auto_Farm_Enabled = false
        getgenv().AutoFarm_VehicleMethod:Set(false)
        return R_Notify("Error", "Spawn a Vehicle before using this!", 5)
    end

    R_Notify("Info", "This even works in Private Servers!", 5)
    R_Notify("Warning", "If it seems like you're not earning anymore, just wait!", 5)

    if auto_farm_1 then
        getgenv().Auto_Farm_Enabled = true
        StartAutoFarm()
    else
        getgenv().Auto_Farm_Enabled = false
        StopAutoFarm()
    end
end,})

getgenv().Apply_Best_Vehicle_Settings = Tab3:CreateToggle({
Name = "Better Speed System (FE)",
CurrentValue = getgenv().vehicle_speed_boost_active or false,
Flag = "Apply_Best_Vehicle_Settings_Toggle",
Callback = function(toggled)
    if toggled then
        getgenv().vehicle_speed_boost_toggle(true)
    else
        getgenv().vehicle_speed_boost_toggle(false)
    end
end,})

getgenv().Set_System_Forward_Speed = Tab3:CreateSlider({
Name = "Set 'Better System' Forward Speed (FE)",
Range = {50, 550},
Increment = 10,
CurrentValue = getgenv().vehicle_speed_boost_max_forward or 300,
Flag = "Slider_Value_Forward_Speed",
Callback = function(new_forward_speed)
    getgenv().vehicle_speed_boost_max_forward = new_forward_speed
end,})

getgenv().Set_System_Backward_Speed = Tab3:CreateSlider({
Name = "Set 'Better System' Backward Speed (FE)",
Range = {50, 200},
Increment = 10,
CurrentValue = getgenv().vehicle_speed_boost_max_backward or 125,
Flag = "Slider_Value_Backward_Speed",
Callback = function(new_backward_speed)
    getgenv().vehicle_speed_boost_max_backward = new_backward_speed
end,})

getgenv().Set_System_Acceleration = Tab3:CreateSlider({
Name = "Set 'Better System' Acceleration (FE)",
Range = {10, 100},
Increment = 10,
CurrentValue = getgenv().vehicle_speed_boost_acceleration or 10,
Flag = "Slider_Value_Acceleration",
Callback = function(new_boost_acceleration)
    getgenv().vehicle_speed_boost_acceleration = new_boost_acceleration
end,})

function enable_anti_afk()
    if getgenv().Loaded_AntiAFK_Already then return getgenv().notify("Warning", "You already loaded Anti-AFK!", 5) end
    local GC = getconnections or get_signal_cons
    if GC and typeof(GC) == "function" then
        for i,v in pairs(GC(LocalPlayer.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
        task.wait(0.25)
        getgenv().Loaded_AntiAFK_Already = true
        getgenv().Anti_AFK_1 = true
    else
        local VirtualUser = g.VirtualUser or cloneref and cloneref(game:GetService("VirtualUser")) or game:GetService("VirtualUser")
        getgenv().Anti_AFK_2 = true
        getgenv().Loaded_AntiAFK_Already = true
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end

-- I have something else planned with this, not yet though. --
function enable_anti_afk_alt2()
    if getgenv().Anti_AFK_Toggled then return end
    getgenv().Anti_AFK_Toggled = true
    while getgenv().Anti_AFK_Toggled == true do
        task.wait(30)
        if Character and Character:FindFirstChild("Humanoid") and Character:FindFirstChild("HumanoidRootPart") then
            Humanoid:Move(Vector3.new(0,0,0), false)
        end
    end
end

getgenv().Drag_Race_Farm_Enabled = getgenv().Drag_Race_Farm_Enabled or false
local function get_dragsession()
    local races = workspace:WaitForChild("Game"):WaitForChild("Races")
    local sess = races:FindFirstChild("LocalSession")
    if not sess then return nil end
    local drag = sess:FindFirstChild("Drag")
    return drag
end

local function wait_for_drag_reset()
    while workspace.Game.Races:FindFirstChild("LocalSession") do
        if not getgenv().Drag_Race_Farm_Enabled then return end
        task.wait(0.2)
    end

    while not workspace.Game.Races:FindFirstChild("LocalSession") do
        if not getgenv().Drag_Race_Farm_Enabled then return end
        task.wait(0.2)
    end

    task.wait(1)
end

local function get_dragparts_block()
    local sess = nil
    repeat
        sess = get_dragsession()
        task.wait()
    until sess or not getgenv().Drag_Race_Farm_Enabled
    if not sess then return end

    local spawns = sess:WaitForChild("Spawns")
    local cps = sess:WaitForChild("Checkpoints")
    local start = spawns:WaitForChild("1")
    local cp1 = cps:WaitForChild("1")
    local fin = sess:WaitForChild("Finish")
    return start, cp1, fin
end

local function TP(cframe)
    local car = Get_Vehicle_Model()
    if car and car.PrimaryPart then
        car:SetPrimaryPartCFrame(cframe)
    end
end

local function DriveForward(duration, speed)
    local car = Get_Vehicle_Model()
    if not car then return end
    local w = car:FindFirstChild("Weight")
    if not w then return end
    w.Anchored = false
    w.AssemblyLinearVelocity = car.PrimaryPart.CFrame.LookVector * speed
    task.wait(duration)
    w.AssemblyLinearVelocity = Vector3.new(0,0,0)
end

local function start_dragremotes()
    local tp = game.ReplicatedStorage.Remotes.Teleport
    local st = game.ReplicatedStorage.Remotes.RaceStartTimeTrial
    Fire_E(tp, {"drag", [5]=false, [6]="Drag Race Teleport Button"})
    task.wait(0.2)
    task.wait(13)
    Fire_E(st, {"Drag","RaceGoal"})
end

local function do_dragrace_cycle()
    local start, cp1, fin = get_dragparts_block()
    if not start then return end

    task.wait(0.4)

    TP(start.CFrame + Vector3.new(0,3,0))
    task.wait(0.4)
    DriveForward(1, math.random(250,600))

    local cp_dir = (start.Position - cp1.Position).Unit
    local cp_back = cp_dir * 10
    TP(cp1.CFrame + cp_back + Vector3.new(0,3,0))

    task.wait(0.25)
    DriveForward(0.6, math.random(60,120))
    local dir = (cp1.Position - fin.Position).Unit
    local backwards = dir * 15
    TP(fin.CFrame + backwards + Vector3.new(0,2,0))
    task.wait(.1)
    DriveForward(0.3, math.random(30,100))
end

getgenv().rundragrace_stable = function() do_dragrace_cycle() end
getgenv().Drag_Race_Farm = Tab2:CreateToggle({
Name = "Drag Race Farm (WORKING DECEMBER 2025!)",
CurrentValue = getgenv().Drag_Race_Farm_Enabled or false,
Flag = "DragRaceFarmStable",
Callback = function(v)
    getgenv().Drag_Race_Farm_Enabled = v
    if not v then
        R_Notify("Success", "Stopped Drag Race Farm", 5)
        return
    end

    if not Get_Vehicle() then
        getgenv().Drag_Race_Farm_Enabled = false
        getgenv().Drag_Race_Farm:Set(false)
        return R_Notify("Error", "Spawn a vehicle first!", 5)
    end

    task.spawn(function()
        while getgenv().Drag_Race_Farm_Enabled == true do
            if not Get_Vehicle() then
                R_Notify("Error", "Vehicle despawned!", 5)
                getgenv().Drag_Race_Farm_Enabled = false
                getgenv().Drag_Race_Farm:Set(false)
                return
            end

            Fire_E(game.ReplicatedStorage.Remotes.Teleport, {
                "drag",
                [5] = false,
                [6] = "Drag Race Teleport Button"
            })

            task.wait(1)

            Fire_E(game.ReplicatedStorage.Remotes.RaceStartTimeTrial, {
                "Drag",
                "RaceGoal"
            })

            task.wait(20)

            rundragrace_stable()
            task.wait(0.3)
            wait_for_drag_reset()
        end
    end)

    R_Notify("Success", "Drag Race Farm Enabled (Safe Version)", 5)
end,})

getgenv().Anti_AFK_1 = Tab2:CreateButton({
Name = "Anti AFK",
Callback = function()
    enable_anti_afk()
end,})

getgenv().Highway_Race_Farm = Tab2:CreateToggle({
Name = "Auto Farm Highway Race (Broken!)",
CurrentValue = getgenv().Highway_Farm_Enabled or false,
Flag = "Highway_Racing_AutoFarm_Ez",
Callback = function(highway_farming)
    if highway_farming then
        getgenv().Highway_Farm_Enabled = true

        if not Get_Vehicle() then
            getgenv().Highway_Farm_Enabled = false
            getgenv().Highway_Race_Farm:Set(false)
            return R_Notify("Failure:", "Spawn a Vehicle before using this!", 5)
        end

        local car = Get_Vehicle_Model()
        if not car then
            getgenv().Highway_Farm_Enabled = false
            getgenv().Highway_Race_Farm:Set(false)
            return R_Notify("Failure:", "Spawn a Vehicle before using this!", 5)
        end

        local Weight = car:FindFirstChild("Weight") or car:WaitForChild("Weight", 3)
        if not Weight then
            getgenv().Highway_Farm_Enabled = false
            getgenv().Highway_Race_Farm:Set(false)
            return R_Notify("Error:", "Weight not found inside of Vehicle!", 5)
        end

        while getgenv().Highway_Farm_Enabled == true do
            local Drag_Race = LocalSession:FindFirstChild("Drag")

            if not Get_Vehicle() then
                getgenv().Highway_Farm_Enabled = false
                getgenv().Highway_Race_Farm:Set(false)
                return 
            end

            if not Drag_Race then
                local args = {
                    "highway",
                    [5] = false,
                    [6] = "Highway Race Teleport Button"
                }
                Fire_E(Teleport_RE, args)
                task.wait(3)
                local args2 = {
                    "Highway",
                    "NoOne"
                }
                Fire_E(RaceStart_RE, args2)
                wait(0.1)
                local HighwayRace = LocalSession:FindFirstChild("Highway")
                if HighwayRace then
                    local Checkpoints = HighwayRace:FindFirstChild("Checkpoints")
                    if Checkpoints then
                        local Checkpoint_1 = Checkpoints:FindFirstChild("1")
                        local Checkpoint_2 = Checkpoints:FindFirstChild("2")
                        local Checkpoint_3 = Checkpoints:FindFirstChild("3")
                        local Checkpoint_4 = Checkpoints:FindFirstChild("4")
                        local Checkpoint_5 = Checkpoints:FindFirstChild("5")
                        local Checkpoint_6 = Checkpoints:FindFirstChild("6")
                        local Checkpoint_7 = Checkpoints:FindFirstChild("7")
                        local Checkpoint_8 = Checkpoints:FindFirstChild("8")
                        local Finish_Part = HighwayRace:FindFirstChild("Finish")
                        if Checkpoint_1 and Finish_Part and Get_Vehicle_Model() then
                            wait(17.5)
                            MoveCarThrough(Checkpoint_1, 600)
                            task.wait(1.5)
                            MoveCarThrough(Checkpoint_2, 600)
                            task.wait(5)
                            MoveCarThrough(Checkpoint_3, 600)
                            task.wait(1.5)
                            MoveCarThrough(Checkpoint_4, 600)
                            task.wait(1.5)
                            MoveCarThrough(Checkpoint_5, 600)
                            task.wait(1.5)
                            MoveCarThrough(Checkpoint_6, 600)
                            task.wait(1.5)
                            MoveCarThrough(Checkpoint_7, 600)
                            task.wait(1.5)
                            MoveCarThrough(Checkpoint_8, 600)
                            task.wait(1.5)
                            MoveCarThrough(Finish_Part, 600)
                        end
                    end
                end
            else
                wait(3)
            end
        end
    end
end,})