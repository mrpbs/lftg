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
local Raw_Version = "V1.2.5"
getgenv().Script_Version = tostring(Raw_Version).."-SpeedRun4"
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
local get_conns = getconnections or get_connections or get_signal_cons or blank_function
local FlamesLibrary = getgenv().FlamesLibrary
local low_level_exec = getgenv().low_level_executor
if low_level_exec == true then return g.notify("Error", "This executor cannot run this script! You'll need a better executor to run this.", 15) end
local function find_levels_folder()
    local Cache = g.levels_folder_cache
    if Cache and Cache.Parent then return Cache end
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Folder") and v.Name:lower():find("level") then
            g.levels_folder_cache = v
            return v
        end
    end
    return nil
end
wait(0.1)
if not g.levels_folder_cache then pcall(function() find_levels_folder() end) end

local function fuzzy_local_find_child(Parent, Name_Fragment)
    Name_Fragment = Name_Fragment:lower()
    for _, v in ipairs(Parent:GetChildren()) do
        if v.Name:lower():find(Name_Fragment) then
            return v
        end
    end
    return nil
end

g.wait_for_root = function()
    local Root = g.HumanoidRootPart or (g.Character and g.Character:FindFirstChild("HumanoidRootPart")) or g.get_root(LocalPlayer, 5)
    if Root and Root.Parent then return Root end
    if not g.Flames_Hub_Automatically_Teleporting_Toggled then return nil end
    while g.Flames_Hub_Automatically_Teleporting_Toggled do
        task.wait(g.Players.RespawnTime + 0.5)
        Root = g.HumanoidRootPart or (g.Character and g.Character:FindFirstChild("HumanoidRootPart")) or g.get_root(LocalPlayer, 5)
        if Root and Root.Parent then return Root end
    end
    return nil
end

local function find_ClientData_Module()
    local cache = g.ClientData_Module
    if cache and cache.Parent and cache:IsA("ModuleScript") then return cache end
    local modules_folder
    for _, v in ipairs(ReplicatedStorage:GetChildren()) do
        if v:IsA("Folder") and v.Name:lower():find("^modules$") then
            modules_folder = v
            break
        end
    end
    if not modules_folder then return nil end
    for _, v in ipairs(modules_folder:GetChildren()) do
        if v:IsA("ModuleScript") and v.Name:lower():find("clientdata") then
            g.ClientData_Module = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.ClientData_Module then pcall(function() find_ClientData_Module() end) end

local function find_User_Idling_Event()
    local cache = g.user_idling_Remote_Event_found
    if cache and cache.Parent and cache:IsA("RemoteEvent") then return cache end
    
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("user") and v.Name:lower():find("idl") and v.Parent.Name:lower():find("bloxbiz") then
            g.user_idling_Remote_Event_found = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.user_idling_Remote_Event_found then pcall(function() find_User_Idling_Event() end) end
-- [[ pure checking right here ladies and gentlemen. ]] --
g.bypass_bloxbiz_idling_system = function()
    if g.anti_bloxbiz_afk_detection_bypassed then return g.notify("Warning", "You've already bypassed Bloxbiz's AFK system!", 3) end
    local idling_remote = g.user_idling_Remote_Event_found or find_User_Idling_Event()
    if not idling_remote then return g.notify("Error", "RemoteEvent: UserIdlingEvent not found or does not exist (missing BloxbizRemotes?).", 3) end
    local fn = getconnections or get_connections or get_signal_cons
    if fn and typeof(fn) == "function" then
        g.anti_bloxbiz_afk_detection_bypassed = true
        g.notify("Success", "Flames Hub | Anti Idle bypassed (getconnections).", 3)
        for _, conn in ipairs(fn(g.LocalPlayer.Idled)) do pcall(function() conn:Disable() end) end
    elseif getrawmetatable and setreadonly and newcclosure and typeof(getrawmetatable) == "function" and typeof(setreadonly) == "function" and typeof(newcclosure) == "function" then
        g.anti_bloxbiz_afk_detection_bypassed = true
        g.notify("Success", "Flames Hub | Anti Idle bypassed (getrawmetatable / newcclosure).", 3)
        local mt = getrawmetatable(game)
        local old_namecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            if getnamecallmethod() == "FireServer" and self == idling_remote then return end
            return old_namecall(self, ...)
        end)
        setreadonly(mt, true)
    else
        return g.notify("Error", "Your executor cannot run this script! (missing dependencies).", 5)
    end
end

g.safe_teleport = function(Part_To_Teleport)
    for Attempt = 1, 5 do
        local Root = g.wait_for_root()
        if not Root then return false end
        local Success = pcall(function()
            Root.CFrame = Part_To_Teleport:GetPivot() + Vector3.new(0, 5, 0)
        end)
        if Success then return true end
        task.wait(g.Players.RespawnTime + 0.5)
    end
    return false
end

g.touch_part = function(Part)
    if not (firetouchinterest and typeof(firetouchinterest) == "function") then return false, "firetouchinterest not available on this executor" end
    local Touch_Interest = Part:FindFirstChildWhichIsA("TouchTransmitter")
    if not Touch_Interest then return false, "no TouchTransmitter on "..Part:GetFullName() end
    local Root = g.wait_for_root()
    if not Root then return false, "could not get root" end
    firetouchinterest(Root, Part, 0)
    task.wait()
    firetouchinterest(Root, Part, 1)
    return true, nil
end

g.find_current_level_folder = function()
    local Level_Folder = g.levels_folder_cache or find_levels_folder()
    if not Level_Folder then return nil, "Levels folder not found" end
    local Root = g.wait_for_root()
    if not Root then return nil, "Could not get root." end
    local Position = Root.Position
    for _, Level in ipairs(Level_Folder:GetChildren()) do
        if Level:IsA("Model") then
            local Success, Center, Size = pcall(function() return Level:GetBoundingBox() end)
            if Success and Center then
                local Min = Center.Position - Size / 2
                local Max = Center.Position + Size / 2
                if Position.X >= Min.X and Position.X <= Max.X
                and Position.Y >= Min.Y and Position.Y <= Max.Y
                and Position.Z >= Min.Z and Position.Z <= Max.Z then
                    return Level, nil
                end
            end
        end
    end
    return nil, "Could not determine current level from position"
end

g.find_star = function()
    local Level, Err = g.find_current_level_folder()
    if not Level then return nil, Err end
    local Collectibles = Level:FindFirstChild("Collectibles")
    local Star_Folder = Collectibles and Collectibles:FindFirstChild("Star")
    if Star_Folder then
        local Hit = Star_Folder:FindFirstChildWhichIsA("BasePart") or Star_Folder:FindFirstChildWhichIsA("Model")
        if Hit then return Hit, nil end
    end
    for _, v in ipairs(Level:GetDescendants()) do
        if v.Name:lower():find("star") and (v:IsA("Model") or v:IsA("BasePart")) then
            return v, nil
        end
    end
    return nil, "Star not found in level "..Level.Name
end

g.teleport_to_star = function()
    local Star, Err = g.find_star()
    if not Star then return g.notify("Error", tostring(Err), 3) end
    if not g.safe_teleport(Star) then return g.notify("Error", "Could not get root.", 3) end
    local Touched, Touch_Err = g.touch_part(Star)
    if not Touched then
        g.safe_teleport(Star)
        g.notify("Warning", tostring(Touch_Err)..", teleported instead.", 3)
    end
    g.notify("Success", "Teleported to star", 3)
end

g.find_checkpoints = function()
    local Level, Err = g.find_current_level_folder()
    if not Level then return nil, Err end
    for _, v in ipairs(Level:GetDescendants()) do
        if v.Name:lower():find("checkpoint") and v:IsA("Folder") then
            return v, nil
        end
    end
    return nil, "Checkpoints folder not found in level "..Level.Name
end

g.find_checkpoint = function(Checkpoint_Number)
    local Checkpoints_Folder, Err = g.find_checkpoints()
    if not Checkpoints_Folder then return nil, Err end
    local Direct = Checkpoints_Folder:FindFirstChild(tostring(Checkpoint_Number))
    if Direct and Direct:IsA("BasePart") then return Direct, nil end
    for _, v in ipairs(Checkpoints_Folder:GetChildren()) do
        if v:IsA("BasePart") and v.Name:lower():find(tostring(Checkpoint_Number):lower()) then
            return v, nil
        end
    end
    return nil, "Checkpoint "..tostring(Checkpoint_Number).." not found in current level"
end

g.get_checkpoint_numbers = function()
    local Checkpoints_Folder, Err = g.find_checkpoints()
    if not Checkpoints_Folder then return nil, Err end
    local Numbers = {}
    for _, v in ipairs(Checkpoints_Folder:GetChildren()) do
        if v:IsA("BasePart") and tonumber(v.Name) then
            table.insert(Numbers, tonumber(v.Name))
        end
    end
    table.sort(Numbers)
    if #Numbers == 0 then return nil, "No checkpoint Parts found in current level" end
    return Numbers, nil
end

g.teleport_to_checkpoint = function(Checkpoint_Number)
    local Checkpoint, Err = g.find_checkpoint(Checkpoint_Number)
    if not Checkpoint then return g.notify("Error", tostring(Err), 3) end
    local Touched, Touch_Err = g.touch_part(Checkpoint)
    if not Touched then g.notify("Warning", tostring(Touch_Err), 3) end
    g.notify("Success", "Teleported to Checkpoint "..tostring(Checkpoint_Number), 3)
end

g.get_client_modules = function()
    local Modules = fuzzy_local_find_child(ReplicatedStorage, "modules")
    if not Modules then return nil, "Modules folder not found" end
    if not g.ClientData then
        local ClientData_Module = fuzzy_local_find_child(Modules, "clientdata")
        if ClientData_Module then g.ClientData = require(ClientData_Module) end
    end
    if not g.CharacterVisibility then
        local CharacterVisibility_Module = fuzzy_local_find_child(Modules, "charactervisibility")
        if CharacterVisibility_Module then g.CharacterVisibility = require(CharacterVisibility_Module) end
    end
    local UserInterface = fuzzy_local_find_child(Modules, "userinterface")
    if not UserInterface then return nil, "UserInterface folder not found" end
    if not g.TopbarUI then
        local TopbarUI_Module = fuzzy_local_find_child(UserInterface, "topbarui")
        if TopbarUI_Module then g.TopbarUI = require(TopbarUI_Module) end
    end
    if not g.PlayerListUI then
        local PlayerListUI_Module = fuzzy_local_find_child(UserInterface, "playerlistui")
        if PlayerListUI_Module then g.PlayerListUI = require(PlayerListUI_Module) end
    end
    return true, nil
end
wait(0.1)
g.get_client_modules()

g.get_auto_progress_levels = function(Enabled)
    g.get_client_modules()
    wait(0.25)
    if not g.ClientData then return g.notify("Error", "ModuleScript: ClientData was not found or does not exist.", 3) end
    return g.ClientData.Flags.AutoProgressLevels
end

g.set_auto_progress_levels = function(Enabled)
    g.get_client_modules()
    wait(0.25)
    if not g.ClientData then return g.notify("Error", "ModuleScript: ClientData was not found or does not exist.", 3) end
    g.ClientData.Flags.AutoProgressLevels = Enabled
end
wait(0.1)
g.set_auto_progress_levels(true)

g.teleport_checkpoint_sequence = function(Delay_Seconds)
    Delay_Seconds = Delay_Seconds or 1
    FlamesLibrary.spawn("checkpoint_sequence", "spawn", function()
        local Checkpoint_Numbers, Err = g.get_checkpoint_numbers()
        if not Checkpoint_Numbers then return g.notify("Error", tostring(Err), 3) end
        for _, Checkpoint_Number in ipairs(Checkpoint_Numbers) do
            g.teleport_to_checkpoint(Checkpoint_Number)
            wait(Delay_Seconds)
        end
    end)
end

g.Flames_Hub_Automatically_Teleporting_Toggled = g.Flames_Hub_Automatically_Teleporting_Toggled or false
g.flames_hub_auto_teleport_loop = function()
    while g.Flames_Hub_Automatically_Teleporting_Toggled do
        local Level_Folder, Err = g.find_current_level_folder()
        if not Level_Folder then
            wait(0.5)
            continue
        end
        g.teleport_to_star()
        wait(1)
        g.teleport_checkpoint_sequence(1)
        wait(1)
        local Wait_Start = os.clock()
        while g.Flames_Hub_Automatically_Teleporting_Toggled and os.clock() - Wait_Start < 30 do
            local New_Level_Folder = g.find_current_level_folder()
            if New_Level_Folder and New_Level_Folder ~= Level_Folder then break end
            wait(0.5)
        end
    end
end

g.set_auto_teleport = function(Enabled)
    g.Flames_Hub_Automatically_Teleporting_Toggled = Enabled
    if Enabled then
        FlamesLibrary.spawn("auto_teleport_loop", "spawn", g.flames_hub_auto_teleport_loop)
        g.notify("Success", "Flames Hub | Auto Farm is now enabled.", 3)
    else
        g.notify("Success", "Flames Hub | Auto Farm is now disabled.", 3)
    end
end

g.current_dances_for_Speed_Run_Four = {
    { Id = "MBoss",   Name = "Meme Boss"          },
    { Id = "OrgJust", Name = "Orange Justice"      },
    { Id = "Worm",    Name = "Worm"                },
    { Id = "Floss",   Name = "Floss"               },
    { Id = "Mates",   Name = "Best Mates"          },
    { Id = "Jub",     Name = "Jubilation"          },
    { Id = "BLess",   Name = "Boneless"            },
    { Id = "Dab",     Name = "Dab"                 },
    { Id = "BDown",   Name = "Breakdown"           },
    { Id = "Robot",   Name = "Robot"               },
    { Id = "EleShuf", Name = "Electro Shuffle"     },
    { Id = "Bunny",   Name = "Bunny"               },
    { Id = "Eagle",   Name = "Eagle"               },
    { Id = "Esquiva", Name = "Esquiva"             },
    { Id = "Excited", Name = "Excited"             },
    { Id = "Flapper", Name = "Flapper"             },
    { Id = "Fresh",   Name = "Fresh"               },
    { Id = "Hype",    Name = "Hype"                },
    { Id = "JJacks",  Name = "Jumping Jacks"       },
    { Id = "MartDC",  Name = "Martelo Do Chau"     },
    { Id = "PLock",   Name = "Pop Lock"            },
    { Id = "RPony",   Name = "Ride The Pony"       },
    { Id = "Salute",  Name = "Salute"              },
    { Id = "Samba",   Name = "Samba"               },
    { Id = "Silly",   Name = "Silly"               },
    { Id = "TakeL",   Name = "TakeTheL"            },
    { Id = "HeliT",   Name = "Helicopter T-Pose"   },
    { Id = "URock",   Name = "Up Rock"             },
    { Id = "Wiggle",  Name = "Wiggle"              },
    { Id = "YUgly",   Name = "Yall Ugly"           },
    { Id = "YAwe",    Name = "You're Awesome"      },
    { Id = "FlipI",   Name = "Flippin Incredible"  },
    { Id = "Pumpn",   Name = "Pumpernickel"        },
    { Id = "Yeet",    Name = "Yeet"                },
    { Id = "Whip",    Name = "Whip"                },
    { Id = "Frees",   Name = "Freestyle"           },
    { Id = "InfDab",  Name = "Infinite Dab"        },
    { Id = "S2S",     Name = "Side To Side"        },
}

local function find_Network_Module_Utility()
    local cache = g.main_Network_Utility_Module
    if cache and cache.Parent and cache:IsA("ModuleScript") then return cache end

    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("ModuleScript") and v.Name:lower():find("network") then
            g.main_Network_Utility_Module = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.main_Network_Utility_Module then pcall(function() find_Network_Module_Utility() end) end

local function find_CommonData_Utility_Module()
    local cache = g.CommonData_Utility_Module
    if cache and cache.Parent and cache:IsA("ModuleScript") then return cache end

    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("ModuleScript") and v.Name:lower():find("commonda") then
            g.CommonData_Utility_Module = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.CommonData_Utility_Module then pcall(function() find_CommonData_Utility_Module() end) end

local function find_Remotes_Folder()
    local cache = g.Remotes_Folder
    if cache and cache.Parent then return cache end
    for _, v in ipairs(ReplicatedStorage:GetChildren()) do
        if v:IsA("Folder") and v.Name:lower():find("remotes") and not v.Name:lower():find("bloxbiz") then
            g.Remotes_Folder = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.Remotes_Folder then pcall(function() find_Remotes_Folder() end) end

local function find_State_Remote()
    local cache = g.State_Remote
    if cache and cache.Parent and cache:IsA("RemoteEvent") then return cache end
    local folder = g.Remotes_Folder or find_Remotes_Folder()
    if not folder then return nil end

    for _, v in ipairs(folder:GetChildren()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("^state$") then
            g.State_Remote = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.State_Remote then pcall(function() find_State_Remote() end) end

local function find_BloxbizRemotes_Folder()
    local cache = g.BloxbizRemotes_Folder
    if cache and cache.Parent then return cache end
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("Folder") and v.Name:lower():find("bloxbizremotes") then
            g.BloxbizRemotes_Folder = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.BloxbizRemotes_Folder then pcall(function() find_BloxbizRemotes_Folder() end) end

local function find_OnSendGuiImpressions_Remote()
    local cache = g.OnSendGuiImpressions_Remote
    if cache and cache.Parent and cache:IsA("RemoteEvent") then return cache end
    local folder = g.BloxbizRemotes_Folder or find_BloxbizRemotes_Folder()
    if not folder then return nil end

    for _, v in ipairs(folder:GetChildren()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("onsendguiimpressions") then
            g.OnSendGuiImpressions_Remote = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.OnSendGuiImpressions_Remote then pcall(function() find_OnSendGuiImpressions_Remote() end) end

local function find_GetSubsetClientPlayerStats_Remote()
    local cache = g.GetSubsetClientPlayerStats_Remote
    if cache and cache.Parent and cache:IsA("RemoteFunction") then return cache end
    local folder = g.BloxbizRemotes_Folder or find_BloxbizRemotes_Folder()
    if not folder then return nil end

    for _, v in ipairs(folder:GetChildren()) do
        if v:IsA("RemoteFunction") and v.Name:lower():find("getsubsetclientplayerstats") then
            g.GetSubsetClientPlayerStats_Remote = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.GetSubsetClientPlayerStats_Remote then pcall(function() find_GetSubsetClientPlayerStats_Remote() end) end

local function find_GetClientLogs_Remote()
    local cache = g.GetClientLogs_Remote
    if cache and cache.Parent and cache:IsA("RemoteFunction") then return cache end
    local folder = g.BloxbizRemotes_Folder or find_BloxbizRemotes_Folder()
    if not folder then return nil end
    for _, v in ipairs(folder:GetChildren()) do
        if v:IsA("RemoteFunction") and v.Name:lower():find("getclientlogs") then
            g.GetClientLogs_Remote = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.GetClientLogs_Remote then pcall(function() find_GetClientLogs_Remote() end) end

local function find_Tool_Remote()
    local cache = g.Tool_Remote
    if cache and cache.Parent and cache:IsA("RemoteEvent") then return cache end
    local folder = g.Remotes_Folder or find_Remotes_Folder()
    if not folder then return nil end
    for _, v in ipairs(folder:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("tool") then
            g.Tool_Remote = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.Tool_Remote then pcall(function() find_Tool_Remote() end) end

g.block_bloxbiz_telemetry = function()
    if g.currently_blocking_bloxbiz_telemetry then return g.notify("Warning", "Flames Hub | Bloxbiz telemetry blocker already active.", 3) end
    local telemetry_names = {
        onsendguiimpressions       = true,
        impressionevent            = true,
        useridlingevent            = true,
        newplayerevent             = true,
        adinteractionevent         = true,
        getsubsetclientplayerstats = true,
        getclientlogs              = true,
    }
    local folder = g.BloxbizRemotes_Folder or find_BloxbizRemotes_Folder()
    if not folder then return g.notify("Error", "Flames Hub | BloxbizRemotes folder not found.", 3) end
    local blocked_set = {}
    local children_ok, children = pcall(function() return folder:GetChildren() end)
    if children_ok and children then
        for _, v in ipairs(children) do
            local name_ok, name = pcall(function() return v.Name:lower() end)
            if name_ok and name and telemetry_names[name] then
                blocked_set[v] = true
            end
        end
    end

    if not hookmetamethod or typeof(hookmetamethod) ~= "function" then return g.notify("Error", "Flames Hub | 'hookmetamethod' not available in this executor.", 3) end
    if not newcclosure or typeof(newcclosure) ~= "function" then return g.notify("Error", "Flames Hub | 'newcclosure' not available in this executor.", 3) end
    g.currently_blocking_bloxbiz_telemetry = true
    local original_namecall
    original_namecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method
        if getnamecallmethod and typeof(getnamecallmethod) == "function" then method = getnamecallmethod() end
        if (method == "FireServer" or method == "InvokeServer") and blocked_set[self] then return nil end
        if original_namecall and typeof(original_namecall) == "function" then return original_namecall(self, ...) end
    end))
    g.notify("Success", "Flames Hub | Bloxbiz telemetry suppressed.", 3)
end

g.Network_Buy_Dance_Request = function(Dance_Id)
    if not Dance_Id then return g.notify("Error", "Please input a DanceID to buy a Dance!", 3) end
    if not require or typeof(require) ~= "function" then return g.notify("Error", "require is not available in this executor.", 3) end
    local Network_Module = g.main_Network_Utility_Module or find_Network_Module_Utility()
    if not Network_Module or not Network_Module:IsA("ModuleScript") then return g.notify("Error", "ModuleScript: NetworkRequestUtility not found or is not a ModuleScript.", 3) end
    local CommonData_Module = g.CommonData_Utility_Module or find_CommonData_Utility_Module()
    if not CommonData_Module or not CommonData_Module:IsA("ModuleScript") then return g.notify("Error", "ModuleScript: CommonData not found or is not a ModuleScript.", 3) end
    local Network_Ok, Network = pcall(require, Network_Module)
    if not Network_Ok or not Network then return g.notify("Error", "Failed to require NetworkRequestUtility.", 3) end
    local CommonData_Ok, CommonData = pcall(require, CommonData_Module)
    if not CommonData_Ok or not CommonData then return g.notify("Error", "Failed to require CommonData.", 3) end
    if not Network.MakeRequest or typeof(Network.MakeRequest) ~= "function" then return g.notify("Error", "NetworkRequestUtility.MakeRequest is not available.", 3) end
    if not CommonData.StateRequestType or not CommonData.ItemAction or not CommonData.ItemType then return g.notify("Error", "CommonData is missing required fields.", 3) end
    Network.MakeRequest({
        Request = CommonData.StateRequestType.ItemAction,
        Args = { CommonData.ItemAction.Buy, CommonData.ItemType.Dance, Dance_Id },
        Callback = coroutine.running()
    })
end

g.Buy_Dance = function(Dance_Id) task.spawn(g.Network_Buy_Dance_Request, Dance_Id) end
g.get_local_dance_tool_states = function()
    local client_data_mod = g.ClientData_Module or find_ClientData_Module()
    if not client_data_mod then return nil, "ClientData module not found." end
    local cd_ok, ClientData = pcall(require, client_data_mod)
    if not cd_ok or not ClientData then return nil, "Failed to require ClientData." end
    local local_state = ClientData.LocalPlayerState
    if not local_state then return nil, "LocalPlayerState not available." end
    local tool_states = local_state.ToolStates
    if not tool_states or not tool_states.ById then return nil, "ToolStates.ById not available." end
    local common_data_mod = g.CommonData_Utility_Module or find_CommonData_Utility_Module()
    if not common_data_mod then return nil, "CommonData module not found." end
    local cm_ok, CommonData = pcall(require, common_data_mod)
    if not cm_ok or not CommonData then return nil, "Failed to require CommonData." end
    local dance_type = CommonData.ToolType and CommonData.ToolType.Dance
    local results = {}
    for id, state in pairs(tool_states.ById) do
        local is_dance = dance_type ~= nil and state.Type == dance_type
        local has_tool = state.Tool and typeof(state.Tool) == "Instance"
        if is_dance and has_tool then
            table.insert(results, {
                Id    = id,
                Name  = state.Tool.Name,
                State = state,
            })
        end
    end

    return results, nil
end

g.cached_dance_name_to_id = {}
g.refresh_dance_cache = function()
    local dance_states, err = g.get_local_dance_tool_states()
    if not dance_states then return g.notify("Error", err or "Failed to get dance states.", 3) end
    if #dance_states == 0 then return g.notify("Warning", "No owned emotes found in ToolStates yet — try again in a moment.", 3) end
    g.cached_dance_name_to_id = {}
    for _, entry in ipairs(dance_states) do g.cached_dance_name_to_id[entry.Name] = entry.Id end
    local count = 0
    for _ in pairs(g.cached_dance_name_to_id) do count = count + 1 end
    g.notify("Success", "Loaded " .. tostring(count) .. " emote(s) into cache.", 3)
end

g.equip_dance_by_name = function(dance_name)
    if not dance_name then return g.notify("Error", "No dance name provided.", 3) end
    local Tool_Remote = g.Tool_Remote or find_Tool_Remote()
    if not Tool_Remote then return g.notify("Error", "Tool remote not found.", 3) end
    local common_data_mod = g.CommonData_Utility_Module or find_CommonData_Utility_Module()
    if not common_data_mod then return g.notify("Error", "CommonData module not found.", 3) end
    local cm_ok, CommonData = pcall(require, common_data_mod)
    if not cm_ok or not CommonData then return g.notify("Error", "Failed to require CommonData.", 3) end
    local use_type = CommonData.ToolRequestType and CommonData.ToolRequestType.Use
    if not use_type then use_type = "u" end
    if not g.cached_dance_name_to_id or not next(g.cached_dance_name_to_id) then return g.notify("Error", "Emote cache is empty — press Refresh Emotes first.", 3) end
    local target_id = nil
    for name, id in pairs(g.cached_dance_name_to_id) do
        if name:lower() == dance_name:lower() then
            target_id = id
            break
        end
    end

    if not target_id then return g.notify("Error", "Dance '" .. tostring(dance_name) .. "' not in cache — press Refresh Emotes.", 3) end
    local fire_ok, fire_err = pcall(function() Tool_Remote:FireServer(use_type, target_id) end)
    if not fire_ok then return g.notify("Error", "FireServer failed: " .. tostring(fire_err), 3) end
    g.notify("Success", "Equipped: "..tostring(dance_name), 2.5)
end

g.build_dance_dropdown_options = function()
    local dance_states, err = g.get_local_dance_tool_states()
    if not dance_states or #dance_states == 0 then return { "None" }, {} end
    local options = {}
    local name_to_state = {}
    for _, entry in ipairs(dance_states) do
        table.insert(options, entry.Name)
        name_to_state[entry.Name] = entry
    end
    return options, name_to_state
end

g.Network_Energy_Exchange_Request = function()
    if not require or typeof(require) ~= "function" then return g.notify("Error", "require is not available in this executor.", 3) end
    local Network_Module = g.main_Network_Utility_Module or find_Network_Module_Utility()
    if not Network_Module or not Network_Module:IsA("ModuleScript") then return g.notify("Error", "ModuleScript: NetworkRequestUtility not found.", 3) end
    local CommonData_Module = g.CommonData_Utility_Module or find_CommonData_Utility_Module()
    if not CommonData_Module or not CommonData_Module:IsA("ModuleScript") then return g.notify("Error", "ModuleScript: CommonData not found.", 3) end
    local Network_Ok, Network = pcall(require, Network_Module)
    if not Network_Ok or not Network then return g.notify("Error", "Failed to require NetworkRequestUtility.", 3) end
    local CommonData_Ok, CommonData = pcall(require, CommonData_Module)
    if not CommonData_Ok or not CommonData then return g.notify("Error", "Failed to require CommonData.", 3) end
    if not Network.MakeRequest or typeof(Network.MakeRequest) ~= "function" then return g.notify("Error", "NetworkRequestUtility.MakeRequest is not available.", 3) end
    local request_type = (CommonData.StateRequestType and CommonData.StateRequestType.EnergyExchange) or "ee"
    local ok, err = pcall(function()
        Network.MakeRequest({
            Request  = request_type,
            Args     = {},
            Callback = coroutine.running()
        })
    end)
    if not ok then g.notify("Error", "Energy exchange request failed: " .. tostring(err), 3) end
end

g.auto_sell_energy = function(state)
    if not state then
        g.auto_sell_energy_active = false
        if g.auto_sell_energy_thread then
            pcall(function() task.cancel(g.auto_sell_energy_thread) end)
            g.auto_sell_energy_thread = nil
        end
        return
    end

    if g.auto_sell_energy_active then return end
    g.auto_sell_energy_active = true

    g.auto_sell_energy_thread = task.spawn(function()
        while g.auto_sell_energy_active do
            task.spawn(g.Network_Energy_Exchange_Request)
            task.wait(1)
        end
    end)
end

g.Find_SkinTone_RealHumanoid_Remote_Event_BloxBiz = function()
    local cache = g.skintone_changer_BloxBiz_RE
    if cache and cache.Parent and cache:IsA("RemoteEvent") then return cache end
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:lower():find("catalog") and v.Name:lower():find("apply") and v.Name:lower():find("humanoid") then
            g.skintone_changer_BloxBiz_RE = v
            return v
        end
    end

    return nil
end
wait(0.1)
if not g.skintone_changer_BloxBiz_RE then pcall(function() g.Find_SkinTone_RealHumanoid_Remote_Event_BloxBiz() end) end

g.rainbow_skintone_currently_enabled = g.rainbow_skintone_currently_enabled or false
g.rainbow_skintone_busy = g.rainbow_skintone_busy or false
local function fire_skintone(color)
    local remote = g.Find_SkinTone_RealHumanoid_Remote_Event_BloxBiz()
    if not remote then return false end
    local ok = pcall(function()
        remote:FireServer({ BodyColor = color })
    end)
    return ok
end

local function cache_current_skintone()
    local char = g.Character or g.LocalPlayer.Character or g.get_char(LocalPlayer, 5)
    if not char then return nil end
    local body_colors = char:FindFirstChildWhichIsA("BodyColors") or char:FindFirstChildOfClass("BodyColors")
    if not body_colors then return nil end
    local r, g_val, b = 0, 0, 0
    local parts = {
        body_colors.HeadColor3,
        body_colors.TorsoColor3,
        body_colors.LeftArmColor3,
        body_colors.RightArmColor3,
        body_colors.LeftLegColor3,
        body_colors.RightLegColor3,
    }
    for _, c in ipairs(parts) do
        r = r + c.R
        g_val = g_val + c.G
        b = b + c.B
    end
    return Color3.new(r / 6, g_val / 6, b / 6)
end

g.rainbow_skintone_currently_enabled = g.rainbow_skintone_currently_enabled or false
g.rainbow_skintone_busy = g.rainbow_skintone_busy or false
g.rainbow_skintone_toggle = function(state)
    if g.rainbow_skintone_busy then
        if g.Toggle_RGB_Skintone_UI then g.Toggle_RGB_Skintone_UI:Set(false, false) end
        return
    end
    if state == nil then state = not g.rainbow_skintone_currently_enabled end
    if not state then
        if not g.rainbow_skintone_currently_enabled then
            if g.Toggle_RGB_Skintone_UI then g.Toggle_RGB_Skintone_UI:Set(false, false) end
            return
        end

        g.rainbow_skintone_busy = true
        g.rainbow_skintone_currently_enabled = false
        FlamesLibrary.disconnect("rainbow_skintone_loop")
        local restore_color = g.rainbow_skintone_cached_color
        FlamesLibrary.spawn("rainbow_skintone_restore", "delay", 0.1, function()
            if restore_color then fire_skintone(restore_color) end
            g.rainbow_skintone_cached_color = nil
            task.wait(0.25)
            g.rainbow_skintone_busy = false
        end)
        return
    end

    if g.rainbow_skintone_currently_enabled then return end

    local cached = cache_current_skintone()
    if not cached then
        if g.Toggle_RGB_Skintone_UI then g.Toggle_RGB_Skintone_UI:Set(false, false) end
        return
    end

    g.rainbow_skintone_cached_color = cached
    g.rainbow_skintone_currently_enabled = true
    FlamesLibrary.spawn("rainbow_skintone_loop", "spawn", function()
        local hue = 0
        while g.rainbow_skintone_currently_enabled do
            hue = (hue + 0.005) % 1
            local color = Color3.fromHSV(hue, 1, 1)
            fire_skintone(color)
            task.wait(0.05)
        end
    end)
end

g.toggle_current_level_god_mode = function(state)
    if state == nil then state = not g.god_mode_currently_enabled end
    if not state then
        g.god_mode_currently_enabled = false
        FlamesLibrary.disconnect("god_mode_level_watch")
        FlamesLibrary.disconnect("god_mode_new_level_watch")
        if g.god_mode_cached_transmitters then
            for _, entry in ipairs(g.god_mode_cached_transmitters) do
                local part = entry.part
                if part and part.Parent and part:IsDescendantOf(game) then FlamesLibrary.disconnect("god_mode_hazard_watch_" .. part:GetFullName()) end
            end
        end
        g.god_mode_cached_transmitters = nil
        g.notify("Success", "Flames Hub | GodMode has been disabled.", 3)
        return
    end

    if g.god_mode_currently_enabled then return end
    local function get_hazard_parts()
        local Levels_Folder = g.levels_folder_cache or workspace:FindFirstChild("Levels")
        if not Levels_Folder then return nil, "Levels folder not found" end
        for _, Level in ipairs(Levels_Folder:GetChildren()) do
            if Level:IsA("Model") then
                local Map = Level:FindFirstChild("Map", true)
                if Map then
                    local Hazards = Map:FindFirstChild("Hazards", true)
                    if Hazards then return Hazards, nil end
                end
            end
        end
        return nil, "Hazards not found in any level"
    end

    local function nuke_hazards(Hazards)
        g.god_mode_cached_transmitters = {}
        for _, v in ipairs(Hazards:GetDescendants()) do
            if v:IsA("TouchTransmitter") then
                local part = v.Parent
                if part and part:IsA("BasePart") then
                    table.insert(g.god_mode_cached_transmitters, { part = part })
                    pcall(function() v:Destroy() end)
                end
            end
        end
    end

    local function start_level_watch(Hazards)
        FlamesLibrary.disconnect("god_mode_level_watch")
        FlamesLibrary.connect("god_mode_level_watch", Hazards.DescendantAdded:Connect(function(v)
            if not g.god_mode_currently_enabled then return end
            if v:IsA("TouchTransmitter") then
                local part = v.Parent
                if not part or not part:IsA("BasePart") then return end
                local already_cached = false
                for _, entry in ipairs(g.god_mode_cached_transmitters) do if entry.part == part then already_cached = true break end end
                if not already_cached then table.insert(g.god_mode_cached_transmitters, { part = part }) end
                pcall(function() v:Destroy() end)
            end
        end))
    end

    local function apply_to_current_level()
        if g.god_mode_cached_transmitters then for _, entry in ipairs(g.god_mode_cached_transmitters) do if entry.part and entry.part.Parent then FlamesLibrary.disconnect("god_mode_hazard_watch_" .. entry.part:GetFullName()) end end end
        g.god_mode_cached_transmitters = nil
        FlamesLibrary.disconnect("god_mode_level_watch")
        local Level, Err = g.find_current_level_folder()
        if Level then
            local Map = Level:FindFirstChild("Map", true)
            if Map then local Hazards = Map:FindFirstChild("Hazards", true) end
        end
        local Hazards, HErr = get_hazard_parts()
        if not Hazards then return g.notify("Error", "There is no Hazard parts in this Level (broken?).", 3) end
        nuke_hazards(Hazards)
        start_level_watch(Hazards)
    end

    local Levels_Folder = workspace:FindFirstChild("Levels")
    if not Levels_Folder then return g.notify("Error", "Levels folder not found.", 3) end
    g.god_mode_currently_enabled = true
    g.notify("Success", "Flames Hub | GodMode has been enabled.", 3)
    apply_to_current_level()
    FlamesLibrary.connect("god_mode_new_level_watch", Levels_Folder.ChildAdded:Connect(function(child)
        if not g.god_mode_currently_enabled then return end
        if not child:IsA("Model") then return end
        task.wait(1)
        apply_to_current_level()
    end))
end

g.teleport_to_current_level_spawn = function()
    local Levels_Folder = g.levels_folder_cache or workspace:FindFirstChild("Levels")
    if not Levels_Folder then return g.notify("Error", "Levels folder not found.", 3) end
    local Hazards_Ref = nil
    local Current_Level = nil
    for _, Level in ipairs(Levels_Folder:GetChildren()) do
        if Level:IsA("Model") then
            local Map = Level:FindFirstChild("Map", true)
            if Map then
                local Hazards = Map:FindFirstChild("Hazards", true)
                if Hazards then
                    Current_Level = Level
                    break
                end
            end
        end
    end

    if not Current_Level then return g.notify("Error", "Could not determine current level.", 3) end
    local Map = Current_Level:FindFirstChild("Map", true)
    if not Map then return g.notify("Error", "Map not found in level "..tostring(Current_Level), 3) end
    local Sub_Levels = Map:FindFirstChild("Levels", true)
    if not Sub_Levels then return g.notify("Error", "Sub-levels not found in level "..tostring(Current_Level), 3) end
    local Spawn = Sub_Levels:FindFirstChildWhichIsA("SpawnLocation") or Sub_Levels:FindFirstChild("SpawnLocation", true)
    if not Spawn then return g.notify("Error", "SpawnLocation not found.", 3) end
    local char = g.Character or g.LocalPlayer.Character or g.get_char(LocalPlayer, 5)
    if not char or not char:FindFirstChild("HumanoidRootPart") then return g.notify("Error", "Could not get character.", 3) end
    char:PivotTo(Spawn:GetPivot() + Vector3.new(0, 6, 0))
    g.notify("Success", "Teleported to Level "..tostring(Current_Level).."'s spawn.", 0.75)
end

local flames_ui = loadstring(game:HttpGet("https://pastebin.com/raw/9Vs0Pq8k", true))()
local Window = flames_ui.new({
	Name = "Flames Hub | Speed Run 4 | "..tostring(getgenv().Script_Version),
	ConfigFolder = "Flames_Hub_Speed_Run_4",
	Color = Color3.fromRGB(21, 103, 251),
	Bind = "RightShift",
})
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

local Home_Page = Window:CreatePage("Main")
local Home_Section = Home_Page:CreateSection("Home")
local LocalPlayer_Section = Home_Page:CreateSection("Player")
local Extras_Section = Home_Page:CreateSection("Extra")

Home_Section:CreateButton({
Name = "Get Star (FE)",
Callback = function()
    g.teleport_to_star()
end,})

Home_Section:CreateButton({
Name = "Skip Level (Free, FE)",
Callback = function()
    g.teleport_checkpoint_sequence(1)
end,})

Home_Section:CreateButton({
Name = "Teleport To Current Level Spawn (FE)",
Callback = function()
    g.teleport_to_current_level_spawn()
end,})

g.Flames_Hub_Auto_Farm_Toggle_UI = Home_Section:CreateToggle({
Name = "Auto Farm (FE)",
Default = g.Flames_Hub_Automatically_Teleporting_Toggled or false,
Flag = "Speed_Run_4_Auto_Farm_Flag",
Callback = function(state)
    g.set_auto_teleport(state)
end}, "Speed_Run_4_Auto_Farm_Flag")

local dance_option_names = {}
local dance_name_to_id = {}
local seen_names = {}
for _, entry in ipairs(g.current_dances_for_Speed_Run_Four) do
    local name = tostring(entry.Name)
    local id   = tostring(entry.Id)
    if not seen_names[name] then
        seen_names[name] = true
        table.insert(dance_option_names, name)
        dance_name_to_id[name] = id
    end
end

g.create_ui_element("Dropdown", LocalPlayer_Section, {
Name = "Buy Any Dance (FE)",
Options = dance_option_names,
DefaultItemSelected = "None",
ItemSelecting = false,
Callback = function(selected)
    if not selected or selected == "None" then return g.notify("Error", "Select a dance first.", 2.5) end
    local dance_id = dance_name_to_id[selected]
    if not dance_id then return g.notify("Error", "Dance ID not found for: "..tostring(selected), 3) end
    g.notify("Info", "Buying: "..tostring(selected), 2)
    g.Buy_Dance(dance_id)
end}, "Buy_Dance_Dropdown_UI")

LocalPlayer_Section:CreateButton({
Name = "Anti AFK (bypasses Bloxbiz!)",
Callback = function()
    g.bypass_bloxbiz_idling_system()
end,})

Extras_Section:CreateButton({
Name = "Disable Logging (FE)",
Callback = function()
    g.block_bloxbiz_telemetry()
end,})

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "GodMode (FE)",
Default = g.god_mode_currently_enabled or false,
Flag = "Dont_Damage_When_Touching_Hazards",
Callback = function(state)
    g.toggle_current_level_god_mode(state)
end}, "Dont_Damage_When_Touching_Hazards")

local emote_dropdown_ref = nil
emote_dropdown_ref = g.create_ui_element("Dropdown", LocalPlayer_Section, {
Name = "Equip Any Emote (FE)",
Options = { "Press Refresh Emotes first" },
DefaultItemSelected = "None",
ItemSelecting = false,
Callback = function(selected)
    if not selected or selected == "None" or selected == "Press Refresh Emotes first" then return g.notify("Error", "Select an emote first.", 2.5) end
    g.equip_dance_by_name(selected)
end}, "Equip_Dance_Dropdown_UI")

g.create_ui_element("Button", LocalPlayer_Section, {
Name = "Refresh Emotes Dropdown",
Callback = function()
    local dance_states, err = g.get_local_dance_tool_states()
    if not dance_states or #dance_states == 0 then return g.notify("Warning", err or "No owned emotes found — try again in a moment.", 3) end
    g.cached_dance_name_to_id = {}
    local options = {}
    for _, entry in ipairs(dance_states) do
        g.cached_dance_name_to_id[entry.Name] = entry.Id
        table.insert(options, entry.Name)
    end
    if emote_dropdown_ref and emote_dropdown_ref.Update then emote_dropdown_ref:Update(options) end
    local count = #options
    g.notify("Success", "Loaded " .. tostring(count) .. " emote(s).", 3)
end}, "Refresh_Emotes_Button_UI")

g.create_ui_element("Toggle", Extras_Section, {
Name = "Auto Sell Energy (FE)",
Default = g.auto_sell_energy_active or false,
Flag = "Auto_Sell_Energy_Toggle_UI",
Callback = function(state)
    g.auto_sell_energy(state)
end}, "Auto_Sell_Energy_Toggle_UI")

g.create_ui_element("Toggle", LocalPlayer_Section, {
Name = "Rainbow Skin (FE)",
Default = g.rainbow_skintone_currently_enabled or false,
Flag = "Toggle_RGB_Skintone_UI",
Callback = function(state)
    g.rainbow_skintone_toggle(state)
end}, "Toggle_RGB_Skintone_UI")