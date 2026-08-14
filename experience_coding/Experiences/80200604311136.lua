if not game:IsLoaded() then game.Loaded:Wait() end
if getgenv().Car_Zone_Script_Hub_Menu_Loaded then return end
getgenv().Car_Zone_Script_Hub_Menu_Loaded = true
local g = getgenv and getgenv()
local set_fps_function = setfps or setfpscap or set_fps or set_fps_cap
if set_fps_function then set_fps_function(360) end
if not g.GlobalEnvironmentFramework_Initialized then
   loadstring(game:HttpGet("https://pastebin.com/raw/T25mDhBZ"))()
   wait(0.1)
   g.GlobalEnvironmentFramework_Initialized = true
end
wait(0.2)
g.type_checker_function = function(what, what_type) return typeof(what) == "Instance" and what:IsA(what_type) or false end
g.service_wrap = g.service_wrap or function(serviceName)
    local name = tostring(serviceName)

    if setmetatable then
        if not g._service_cache then
            g._service_cache = setmetatable({}, {
            __index = function(self, index)
                local svc = game:GetService(index)
                if cloneref and svc then svc = cloneref(svc) end
                self[index] = svc
                return svc
            end})
        end

        return g._service_cache[name]
    end

    local svc = game:GetService(name)
    if cloneref and svc then svc = cloneref(svc) end
    return svc
end

repeat task.wait() until typeof(g.service_wrap) == "function"
local MarketplaceService = g.service_wrap("MarketplaceService")
local game_name = MarketplaceService:GetProductInfo(game.PlaceId).Name
local Luna = loadstring(game:HttpGet("https://gitlab.com/greatest-group/experience_coding/-/raw/main/UIs/Luna.lua?ref_type=heads", true))()
local Window = Luna:CreateWindow({
    Name = "Flames Hub | Car Zone",
    Subtitle = "Flames Hub | Car Zone.",
    LogoID = "0",
    LoadingEnabled = true,
    LoadingTitle = "Flames Hub | Presents",
    LoadingSubtitle = "by Flames Hub.",
    ConfigSettings = {
        RootFolder = nil,
        ConfigFolder = "CarZone_FlamesHub"
    },
    KeySystem = false,
    KeySettings = {
        Title = "Flames Hub | Key System",
        Subtitle = "",
        Note = "Welcome to: Flames Hub | Car Zone!",
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
local Home_Tab = Window:CreateTab({Name = "🏡 Home 🏡", Icon = "view_in_ar", ImageSource = "Material", ShowTitle = true})
local Home_LocalPlayer_Section = Home_Tab:CreateSection("Section | LocalPlayer")
local Vehicle_Tab = Window:CreateTab({Name = "🏎️ Vehicle 🏎️", Icon = "view_in_ar", ImageSource = "Material", ShowTitle = true})
local Vehicle_Section = Vehicle_Tab:CreateSection("Section | Vehicles")
local Config_Tab = Window:CreateTab({Name = "✏️ Config ✏️", Icon = "view_in_ar", ImageSource = "Material", ShowTitle = true})
local Config_Section = Config_Tab:CreateSection("Section | Configuration Page")
local UI_Tab = Window:CreateTab({Name = "🖥️ UI 🖥️", Icon = "view_in_ar", ImageSource = "Material", ShowTitle = true})
local UI_Section = UI_Tab:CreateSection("Section | UI")
local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local get_conns = getconnections or get_signal_cons or blankfunction
local LogService = cloneref and cloneref(game:GetService("LogService")) or game:GetService("LogService")

function close_menu()
    if Luna then Luna:Destroy_UI() end
    getgenv().Car_Zone_Script_Hub_Menu_Loaded = false
end

g.getRoot = function(char)
    if not char then
        char = getgenv().Character or getgenv().LocalPlayer.Character or get_char(LocalPlayer or game.Players.LocalPlayer) or game.Players.LocalPlayer.Character
    end

    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if hum and hum.RootPart then
        return hum.RootPart
    end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        return hrp
    end
end

g.get_car_tune_tbl_func = function()
    g.car_tune_table = nil

    for _, v in next, getgc(true) do
        if type(v) == "table" and rawget(v, "Horsepower") and rawget(v, "Ratios") then
            g.car_tune_table = v
            break
        end
    end

    local t = g.car_tune_table
    if not t then
        if getgenv().notify then
            return getgenv().notify("Error", "We we're unable to find the tune table.", 5)
        else
            return warn("We we're unable to find the tune table.")
        end
    end
end

local current_spawned_position = CFrame.new(-859.396545, 3.83541036, -3766.95581, 0.0951488391, -5.01057045e-08, 0.995463073, -7.26954994e-08, 1, 5.72824845e-08, -0.995463073, -7.78160469e-08, 0.0951488391)
getgenv().has_spawn_point_set = true
getgenv().spawn_delay_maximum = 0.1
local lastDeath

function onDied()
	task.spawn(function()
		if pcall(function() getgenv().Character:FindFirstChildOfClass('Humanoid') end) and getgenv().Character:FindFirstChildOfClass('Humanoid') then
			getgenv().Character:FindFirstChildOfClass('Humanoid').Died:Connect(function()
				if getRoot(Players.LocalPlayer.Character) then
					lastDeath = getRoot(getgenv().Character or getgenv().LocalPlayer.Character).CFrame
				end
			end)
		else
			wait(2)
			onDied()
		end
	end)
end

if not getgenv().SpawnPoint_Char_Added_Connection then
    getgenv().SpawnPoint_Char_Added_Connection = true
    LocalPlayer.CharacterAdded:Connect(function(char)
        if not (getgenv().Character or getgenv().Character.Parent) then
            repeat wait(10) until getgenv().LocalPlayer.Character and Character
            if not Character then
                Character = char
            end
        end

        pcall(function()
            if getgenv().has_spawn_point_set and current_spawned_position ~= nil then
                wait(getgenv().spawn_delay_maximum)
                getRoot(getgenv().Character).CFrame = current_spawned_position
            end
        end)

        onDied()
    end)
end
onDied()

g.get_spawned_cars_folder = g.get_spawned_cars_folder or function()
    local cached = g.already_found_spawned_vehicles_folder
    if cached and cached:IsA("Folder") and cached.Parent then
        return cached
    end

    local ws = g.Workspace or workspace
    if not ws then return nil end

    for _, v in ipairs(ws:GetDescendants()) do
        if v:IsA("Folder") then
            local n = v.Name:lower()
            if (n:find("spawned") and (n:find("cars") or n:find("vehicles"))) then
                g.already_found_spawned_vehicles_folder = v
                return v
            end
        end
    end

    return nil
end
wait(0.1)
g.get_spawned_cars_folder()
wait(0.2)
g.get_vehicle = g.get_vehicle or function()
    if not g.LocalPlayer then return nil end
    local ws = g.Workspace or workspace
    if not ws then return nil end

    if not g.already_found_spawned_vehicles_folder then
        g.already_found_spawned_vehicles_folder =
            (g.get_spawned_cars_folder and g.get_spawned_cars_folder())
            or ws:FindFirstChild("SpawnedCars", true)
    end

    local folder = g.already_found_spawned_vehicles_folder
    if not folder then
        if g.notify then
            g.notify("Error", "Could not find SpawnedCars Folder inside of Workspace.", 7)
        end
        return nil
    end

    local direct = folder:FindFirstChild(g.LocalPlayer.Name)
    if direct and direct:IsA("Model") then
        return direct
    end

    return nil
end

g.find_instance = g.find_instance or function(location, search, class_name, deep, cache_name)
    if typeof(location) == "string" then
        local lname = location:lower()
        if lname == "workspace" then
            location = g.Workspace or workspace
        else
            local ok, svc = pcall(game.GetService, game, location)
            if not ok or not svc then return nil end
            location = svc
        end
    end

    if typeof(location) ~= "Instance" then
        return nil
    end

    local search_l = search and tostring(search):lower()
    local use_class = class_name and tostring(class_name)
    local list = deep and location:GetDescendants() or location:GetChildren()

    for _, v in ipairs(list) do
        if (not use_class or v:IsA(use_class)) and (not search_l or v.Name:lower():find(search_l)) then
            if cache_name then
                g[cache_name] = v
            end
            return v
        end
    end

    return nil
end

local function find_sounds_Remote_Event_instance()
    local cache = getgenv().sounds_event_found_ez
    if cache and cache:IsA("RemoteEvent") then
        return cache
    end

    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("sound") and v.Name:lower():find("remote") then
            getgenv().sounds_event_found_ez = v
            return v
        end
    end

    return nil
end

local function find_session_reward_Remote_Event_inst()
    local cache = getgenv().session_reward_Remote_event_instance
    if cache and cache:IsA("RemoteEvent") and cache.Parent then
        return cache
    end

    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("session") and v.Name:lower():find("reward") then
            getgenv().session_reward_Remote_event_instance = v
            return v
        end
    end

    return nil
end

if not getgenv().sounds_event_found_ez then find_sounds_Remote_Event_instance() end
if not getgenv().session_reward_Remote_event_instance then find_session_reward_Remote_Event_inst() end
function claim_all_session_rewards()
    local Remote = getgenv().session_reward_Remote_event_instance or find_session_reward_Remote_Event_inst()
    if not Remote then return end

    for _, Value in ipairs({60, 300, 600, 900, 1200, 1500, 1800}) do
        Remote:FireServer(Value)
        task.wait(0.15)
    end
end

local function find_horn_toggle_Remote_Event()
    local cache = getgenv().found_horn_Remote_Event_instance
    if cache and cache:IsA("RemoteEvent") then
        return cache
    end

    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("horn") and v.Name:lower():find("remote") then
            getgenv().found_horn_Remote_Event_instance = v
            return v
        end
    end

    return nil
end

local function find_lights_Remote_Event()
    local cache = getgenv().found_lights_RE_ez
    if cache and cache:IsA("RemoteEvent") then
        return cache
    end

    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("light") and v.Name:lower():find("remote") then
            getgenv().found_lights_RE_ez = v
            return v
        end
    end

    return nil
end

if not getgenv().found_horn_Remote_Event_instance then find_horn_toggle_Remote_Event() end
if not getgenv().found_lights_RE_ez then find_lights_Remote_Event() end
g.create_smoke_FE = g.create_smoke_FE or function(amount_of_smoke)
    local vehicle = g.get_vehicle and g.get_vehicle()
    if not vehicle then
        if getgenv().notify then
            return getgenv().notify("Error", "You do not have a Vehicle spawned, spawn one.", 6)
        else
            return warn("No Vehicle is spawned or it does not exist anymore.")
        end
    end
    local smoke_value = tonumber(amount_of_smoke) or 0
    local smoke_remote = g.Smoke_Remote or g.find_instance("ReplicatedStorage", "smoke", "RemoteEvent", true, "Smoke_Remote")
    local args = {vehicle, "UpdateSmoke", 0, smoke_value}
    pcall(function()
        smoke_remote:FireServer(unpack(args))
    end)
end

local types_of_vehicle_lights = {
    "Hazard",
    "Brake",
    "LeftSignal",
    "RightSignal",
}

getgenv().Mute_Engine_Sounds = getgenv().Mute_Engine_Sounds or false
getgenv().Toggle_Engine_Mute = function(state)
    getgenv().Mute_Engine_Sounds = state
    if state then
        local car = getgenv().get_vehicle and getgenv().get_vehicle()
        if not car then return getgenv().notify("Error", "No vehicle found.", 5) end
        local Exh = car:FindFirstChild("Exh", true)
        if not Exh then return getgenv().notify("Error", "Exh not found in vehicle.", 5) end
        local sounds = getgenv().sounds_event_found_ez or find_sounds_Remote_Event_instance()
        if not sounds then return getgenv().notify("Error", "SoundsRemote not found in Vehicle.", 5) end
        getgenv().FlamesLibrary.connect("Mute_Engine_Loop", RunService.Stepped:Connect(function()
            if not getgenv().Mute_Engine_Sounds then return end
            if not car or not car.Parent then
                getgenv().FlamesLibrary.disconnect("Mute_Engine_Loop")
                return
            end
            if not Exh or not Exh.Parent then
                getgenv().FlamesLibrary.disconnect("Mute_Engine_Loop")
                return
            end
            local Muted_Sound_Table = {}
            for _, sound in ipairs(Exh:GetChildren()) do
                if sound:IsA("Sound") then
                    table.insert(Muted_Sound_Table, {sound, 0, 0})
                end
            end
            if #Muted_Sound_Table == 0 then
                getgenv().FlamesLibrary.disconnect("Mute_Engine_Loop")
                return
            end
            sounds:FireServer("updateSounds", car, Muted_Sound_Table)
        end))
    else
        getgenv().FlamesLibrary.disconnect("Mute_Engine_Loop")
        local car = getgenv().get_vehicle and getgenv().get_vehicle()
        if not car then return end
        local Exh = car:FindFirstChild("Exh", true)
        if not Exh then return end
        local sounds = getgenv().sounds_event_found_ez or find_sounds_Remote_Event_instance()
        if not sounds then return end
        local Restore_Sound_Table = {}
        for _, sound in ipairs(Exh:GetChildren()) do
            if sound:IsA("Sound") then
                table.insert(Restore_Sound_Table, {sound, sound.Pitch, sound.Volume})
            end
        end
        if #Restore_Sound_Table == 0 then return end
        sounds:FireServer("updateSounds", car, Restore_Sound_Table)
    end
end

getgenv().toggle_horn_on_vehicle = function(state)
    local current_vehicle = g.get_vehicle()
    if not current_vehicle then return getgenv().notify("Error", "Vehicle not found or does not exist.", 5) end
    local horn_RE = getgenv().found_horn_Remote_Event_instance or find_horn_toggle_Remote_Event()
    if not horn_RE then return end

    getgenv().is_horn_currently_blairing = state
    horn_RE:FireServer(current_vehicle, "Horn", state)
end

getgenv().fire_light_state = function(property, value)
    local car = getgenv().get_vehicle and getgenv().get_vehicle()
    if not car then return getgenv().notify("Error", "No vehicle found.", 5) end
    local lights_remote = getgenv().found_lights_RE_ez or find_lights_Remote_Event()
    if not lights_remote then return end
    lights_remote:FireServer(car, property, value)
end

getgenv().Toggle_Hazard_Spam = function(state)
    getgenv().Hazard_Spam_Active = state
    if state then
        getgenv().FlamesLibrary.spawn("Hazard_Spam_Loop", "spawn", function()
            while getgenv().Hazard_Spam_Active == true do
                getgenv().fire_light_state("Brake", true)
                getgenv().fire_light_state("Lights", 2)
                task.wait(0.7)
                getgenv().fire_light_state("Brake", false)
                getgenv().fire_light_state("Lights", 0)
                task.wait(0.4)
            end
        end)
    else
        getgenv().FlamesLibrary.disconnect("Hazard_Spam_Loop")
        getgenv().fire_light_state("Brake", false)
    end
end

getgenv().toggle_vehicle_alarm_system_realistic = function(state)
    getgenv().realistic_car_alarm_system = state
    getgenv().toggle_horn_on_vehicle(state)
    getgenv().Toggle_Hazard_Spam(state)
end

getgenv().hide_smoke_automatically = getgenv().hide_smoke_automatically or function(toggle)
    if toggle == true then
        local current_vehicle_spawned = getgenv().get_vehicle()
        if not current_vehicle_spawned then
            if getgenv().notify then
                return getgenv().notify("Error", "You do not have a Vehicle spawned, spawn one.", 6)
            else
                return warn("No Vehicle is spawned or it does not exist anymore.")
            end
        end

        getgenv().automatically_hiding_smoke_performance = true
        getgenv().hiding_any_smoke_automatically_task = task.spawn(function()
            while getgenv().automatically_hiding_smoke_performance == true do
                task.wait(0.1)
                if not current_vehicle_spawned or not current_vehicle_spawned.Parent then
                    getgenv().automatically_hiding_smoke_performance = false
                    break
                end

                for _, v in ipairs(current_vehicle_spawned:GetDescendants()) do
                    if v:IsA("ParticleEmitter") and v.Name:lower():find("smoke") then
                        v.Enabled = false
                    end
                end
            end
        end)
    elseif toggle == false then
        getgenv().automatically_hiding_smoke_performance = false
        if getgenv().hiding_any_smoke_automatically_task then
            pcall(function() task.cancel(getgenv().hiding_any_smoke_automatically_task) end)
            getgenv().hiding_any_smoke_automatically_task = nil
        end
        task.wait(0.5)
        local current_vehicle_spawned = getgenv().get_vehicle()
        if not current_vehicle_spawned then
            return
        end

        for _, v in ipairs(current_vehicle_spawned:GetDescendants()) do
            if v:IsA("ParticleEmitter") and v.Name:lower():find("smoke") then
                v.Enabled = true
            end
        end
    end
end

g.find_settings_main_RE = g.find_settings_main_RE or function()
    local cache = g.main_settings_RE_obj
    if cache and cache:IsA("RemoteEvent") and cache.Parent then
        return cache
    end

    for _, v in ipairs(g.ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("settings") and not v.Name:lower():find("wczy") then
            g.main_settings_RE_obj = v
            return v
        end
    end

    return nil
end

local spawned_vehicle = g.get_vehicle and g.get_vehicle()
getgenv().Current_Vehicle_Thats_Spawned_Label = Vehicle_Section:CreateLabel({
    Text = "Current Vehicle: None",
    Style = 1
})
wait(0.2)
if spawned_vehicle then
    local stats = spawned_vehicle:FindFirstChild("Stats")
    local car_name = stats and stats:FindFirstChild("CarName")
    local value = car_name and car_name.Value
    if value then
        getgenv().Current_Vehicle_Thats_Spawned_Label:Set("Current Vehicle: "..tostring(value))
    end
end

getgenv().vehicle_speed_boost_toggle = function(toggled)
    if toggled == true then
        if getgenv().vehicle_speed_boost_active then return end
        local current_vehicle = getgenv().get_vehicle()
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
        local current_vehicle = getgenv().get_vehicle()
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

if not getgenv().car_spawner_watcher_connection_started then
    getgenv().car_spawner_watcher_connection_started = true
    local spawned_vehicles_folder = getgenv().already_found_spawned_vehicles_folder or (getgenv().get_spawned_cars_folder and getgenv().get_spawned_cars_folder())
    if spawned_vehicles_folder and spawned_vehicles_folder:IsA("Folder") then
        getgenv().spawned_cars_folder = spawned_vehicles_folder
        getgenv().Spawned_Vehicles_Folder_Child_Added_Automated_Task = task.spawn(function()
            getgenv().car_spawner_connection = spawned_vehicles_folder.ChildAdded:Connect(function(new_model)
                if not new_model or not new_model:IsA("Model") then return end
                if new_model.Name ~= getgenv().LocalPlayer.Name then return end

                local stats = new_model:FindFirstChild("Stats")
                local carName = stats and stats:FindFirstChild("CarName")
                local value = carName and carName.Value

                if value and getgenv().Current_Vehicle_Thats_Spawned_Label then
                    getgenv().Current_Vehicle_Thats_Spawned_Label:Set("Current Vehicle: "..tostring(value))
                end
            end)
        end)
    end
end

getgenv().free_codes_claimer_func = function()
    local find_code_RE = getgenv().Code_Event_RE or getgenv().find_instance("ReplicatedStorage", "code", "RemoteEvent", true, "Code_Event_RE")
    if not find_code_RE then return getgenv().notify("Error", "CodeEvent not found or does not exist.", 5) end
    for _, v in ipairs(getgenv().LocalPlayer:GetChildren()) do
        if v:IsA("Folder") and v.Name:lower():find("codes") and v.Name:lower():find("folder") then
            for _, code in ipairs(v:GetChildren()) do
                if code:IsA("BoolValue") and code.Value == false then
                    find_code_RE:FireServer(tostring(code.Name))
                    task.wait(0.15)
                end
            end
        end
    end
end

g.toggle_invehicle_plr_tag = g.toggle_invehicle_plr_tag or function(toggled)
    if toggled == true then
        local found_RE = g.main_settings_RE_obj or g.find_settings_main_RE()
        if found_RE and found_RE:IsA("RemoteEvent") and found_RE.Parent then
            pcall(function() found_RE:FireServer("Tag", 1) end)
        end
    elseif toggled == false then
        local found_RE = g.main_settings_RE_obj or g.find_settings_main_RE()
        if found_RE and found_RE:IsA("RemoteEvent") and found_RE.Parent then
            pcall(function() found_RE:FireServer("Tag", 0) end)
        end
    else
        return 
    end
end

getgenv().main_smoke_value_counter = getgenv().main_smoke_value_counter or 25
getgenv().Smoke_Power_Slider = Config_Tab:CreateSlider({
Name = "Smoke Power (FE)",
Description = "Sets the power of the smoke effect.",
Range = {1, 100},
Increment = 1,
CurrentValue = getgenv().main_smoke_value_counter or 25,
Callback = function(new_smoke_amount)
    getgenv().main_smoke_value_counter = tonumber(new_smoke_amount)
end}, "Smoke_Power_UI_Slider")

getgenv().Spawn_Smoke_Button = Vehicle_Tab:CreateButton({
Name = "Spawn Smoke (FE)",
Description = "Spawns smoke on your vehicle.",
Callback = function()
    pcall(function()
        getgenv().create_smoke_FE(getgenv().main_smoke_value_counter)
    end)
end})

getgenv().Loop_Smoke_Toggle = Vehicle_Tab:CreateToggle({
Name = "Loop Smoke (FE)",
Description = "Continuously spawns smoke on your vehicle.",
CurrentValue = getgenv().is_currently_spawning_smoke or false,
Callback = function(is_toggled)
    if is_toggled then
        getgenv().is_currently_spawning_smoke = true
        task.spawn(function()
            while getgenv().is_currently_spawning_smoke == true do
                task.wait()
                getgenv().create_smoke_FE(getgenv().main_smoke_value_counter)
            end
        end)
    else
        getgenv().is_currently_spawning_smoke = false
    end
end}, "Loop_Smoke_UI_Toggle")

getgenv().Claim_Codes_Button = Home_Tab:CreateButton({
Name = "Claim Codes (FE)",
Description = "Automatically claims all available free codes.",
Callback = function()
    pcall(function() getgenv().free_codes_claimer_func() end)
end})

getgenv().Collect_All_Playtime_Rewards_Button = Home_Tab:CreateButton({
Name = "Collect Playtime Rewards (FE).",
Description = "Instantly collects all available playtime rewards.",
Callback = function()
    claim_all_session_rewards()
end})

getgenv().Toggle_Horn_On_Vehicle_Loop = Vehicle_Tab:CreateToggle({
Name = "Horn Loop (FE)",
Description = "Allows you to toggle your Horn, letting it blair on loop.",
CurrentValue = getgenv().is_horn_currently_blairing or false,
Callback = function(state)
    getgenv().toggle_horn_on_vehicle(state)
end}, "LoopToggled_Horn_Remote_UI")

getgenv().Hazard_And_Horn_Toggle = Vehicle_Tab:CreateToggle({
Name = "Set Off Car Alarm (FE)",
Description = "Turns on your hazards, and blairs your car alarm at one time.",
CurrentValue = getgenv().realistic_car_alarm_system or false,
Callback = function(state)
    getgenv().toggle_vehicle_alarm_system_realistic(state)
end}, "RealisticBreakingIntoCarAlarm")

-- [[ This system isn't the usual FE sounds system, I'll look into it later lol. ]] --
--[[getgenv().Mute_Sounds_In_Vehicle = Vehicle_Tab:CreateToggle({
Name = "Mute Vehicle Sounds (FE)",
Description = "Mutes all your Vehicle sounds, other players can hear? (they can't).",
CurrentValue = getgenv().Mute_Engine_Sounds or false,
Callback = function(state)
    getgenv().Toggle_Engine_Mute(state)
end}, "LoopMuteSoundsInsideVehicle")--]]

getgenv().Apply_Best_Vehicle_Settings = Vehicle_Tab:CreateToggle({
Name = "Better Speed System (FE)",
Description = "Applies the best & fastest Vehicle settings.",
CurrentValue = getgenv().vehicle_speed_boost_active or false,
Callback = function(toggled)
    if toggled then
        getgenv().vehicle_speed_boost_toggle(true)
    else
        getgenv().vehicle_speed_boost_toggle(false)
    end
end}, "Apply_Best_Vehicle_Settings_Toggle")

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
Range = {50, 200},
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

getgenv().Flash_Tag_Toggle = Home_Tab:CreateToggle({
Name = "Flash Tag (FE)",
Description = "Flashes your in-vehicle player tag.",
CurrentValue = false,
Callback = function(flash_tag_toggled)
    if flash_tag_toggled then
        getgenv().tag_flasher_enabled = true
        while getgenv().tag_flasher_enabled == true do
            task.wait(1)
            getgenv().toggle_invehicle_plr_tag(true)
            task.wait(1)
            getgenv().toggle_invehicle_plr_tag(false)
        end
    else
        getgenv().tag_flasher_enabled = false
        task.wait(0.3)
        getgenv().toggle_invehicle_plr_tag(false)
    end
end}, "Flash_Tag_UI_Toggle")

getgenv().Auto_Hide_Car_Smoke_Toggle = Vehicle_Tab:CreateToggle({
Name = "Auto Hide Car Smoke",
Description = "Automatically hides your car smoke from others.",
CurrentValue = false,
Callback = function(hiding_smoke)
    if hiding_smoke then
        getgenv().hide_smoke_automatically(true)
    else
        getgenv().hide_smoke_automatically(false)
    end
end}, "Auto_Hide_Car_Smoke_UI_Toggle")

getgenv().Destroy_GUI_Button = UI_Tab:CreateButton({
Name = "Destroy GUI",
Description = "Closes and destroys the menu.",
Callback = function()
    close_menu()
end})