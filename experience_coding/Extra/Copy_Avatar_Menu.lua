-- Ultimate Roblox Workspace Metadata Engine & Layered Clothing Scanner (Standalone Server Edition)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")

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

-- Refresh Button (Left Side)
local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0.5, -15, 0, 25)
RefreshBtn.Position = UDim2.new(0, 10, 0, 45)
RefreshBtn.Text = "Refresh Players"
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 14
RefreshBtn.BorderSizePixel = 0
RefreshBtn.Parent = MainFrame

-- Saved Outfits Tab (Right Side)
local SavedTabBtn = Instance.new("TextButton")
SavedTabBtn.Size = UDim2.new(0.5, -15, 0, 25)
SavedTabBtn.Position = UDim2.new(0.5, 5, 0, 45)
SavedTabBtn.Text = "Saved Outfits"
SavedTabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
SavedTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SavedTabBtn.Font = Enum.Font.SourceSansBold
SavedTabBtn.TextSize = 14
SavedTabBtn.BorderSizePixel = 0
SavedTabBtn.Parent = MainFrame


-- Containers for Views
local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -80)
ContentContainer.Position = UDim2.new(0, 0, 0, 80)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Player List Scroll Context
local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, -20, 1, -10)
PlayerScroll.Position = UDim2.new(0, 10, 0, 0)
PlayerScroll.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
PlayerScroll.ScrollBarThickness = 6
PlayerScroll.Parent = ContentContainer

local PlayerListLayout = Instance.new("UIListLayout")
PlayerListLayout.Parent = PlayerScroll
PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
PlayerListLayout.Padding = UDim.new(0, 6)
PlayerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, PlayerListLayout.AbsoluteContentSize.Y + 10)
end)

-- Asset Scan Scroll Context
local AssetScroll = Instance.new("ScrollingFrame")
AssetScroll.Size = UDim2.new(1, -20, 1, -10)
AssetScroll.Position = UDim2.new(0, 10, 0, 0)
AssetScroll.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
AssetScroll.ScrollBarThickness = 6
AssetScroll.Visible = false
AssetScroll.Parent = ContentContainer

local AssetListLayout = Instance.new("UIListLayout")
AssetListLayout.Parent = AssetScroll
AssetListLayout.SortOrder = Enum.SortOrder.LayoutOrder
AssetListLayout.Padding = UDim.new(0, 6)
AssetListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    AssetScroll.CanvasSize = UDim2.new(0, 0, 0, AssetListLayout.AbsoluteContentSize.Y + 10)
end)
-- Saved Outfits Scroll Context
local SavedScroll = Instance.new("ScrollingFrame")
SavedScroll.Size = UDim2.new(1, -20, 1, -10)
SavedScroll.Position = UDim2.new(0, 10, 0, 0)
SavedScroll.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
SavedScroll.ScrollBarThickness = 6
SavedScroll.Visible = false
SavedScroll.Parent = ContentContainer

local SavedListLayout = Instance.new("UIListLayout")
SavedListLayout.Parent = SavedScroll
SavedListLayout.SortOrder = Enum.SortOrder.LayoutOrder
SavedListLayout.Padding = UDim.new(0, 6)
SavedListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    SavedScroll.CanvasSize = UDim2.new(0, 0, 0, SavedListLayout.AbsoluteContentSize.Y + 10)
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
    PlayerScroll.Visible = true
    BackBtn.Visible = false
    RefreshBtn.Visible = true
    SavedTabBtn.Visible = true
    Title.Text = "🧬 Deep Live Outfit Scanner"
end)

SavedTabBtn.MouseButton1Click:Connect(function()
    AssetScroll.Visible = false
    PlayerScroll.Visible = false
    SavedScroll.Visible = true
    BackBtn.Visible = true
    RefreshBtn.Visible = false
    SavedTabBtn.Visible = false
    Title.Text = "📁 Saved Outfits"
    if populateSavedOutfits then populateSavedOutfits() end
end)


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
            DepthScale = 1,
            HeadScale = 1,
            BodyTypeScale = 0,
            ProportionScale = 0,
            HeadColor = ";<,#",
            TorsoColor = ";<,#",
            LeftArmColor = ";<,#",
            RightArmColor = ";<,#",
            LeftLegColor = ";<,#",
            RightLegColor = ";<,#",
        }
    }
end

local function createDetailedAssetCard(categoryName, assetId, rawPropertySource)
    local numericId = tonumber(assetId)
    if not numericId then return end

    local CardFrame = Instance.new("Frame")
    CardFrame.Size = UDim2.new(1, -5, 0, 105)
    CardFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    CardFrame.BorderSizePixel = 0
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

-- Scan Logic (Now accepts Player object directly)
local function deepScanPlayerOutfit(targetPlayer)
    for _, child in pairs(AssetScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    
    Title.Text = "🧬 Scanning: " .. targetPlayer.DisplayName
    PlayerScroll.Visible = false
    AssetScroll.Visible = true
    RefreshBtn.Visible = false
    BackBtn.Visible = true

    local liveChar = targetPlayer.Character or Workspace:FindFirstChild(targetPlayer.Name)
    if not liveChar then return end

    local humanoid = liveChar:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local avatarFrame = Instance.new("Frame")
    avatarFrame.Size = UDim2.new(1, -5, 0, 250)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    avatarFrame.BorderSizePixel = 1
    avatarFrame.BorderColor3 = Color3.fromRGB(0, 255, 150)
    avatarFrame.Parent = AssetScroll

    local bigViewport = Instance.new("ViewportFrame")
    bigViewport.Size = UDim2.new(1, 0, 1, 0)
    bigViewport.BackgroundTransparency = 1
    bigViewport.Parent = avatarFrame

    task.spawn(function()
        local prevArchivable = liveChar.Archivable
        liveChar.Archivable = true
        local charClone = liveChar:Clone()
        liveChar.Archivable = prevArchivable

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

        local ok, jsonText = pcall(function()
            return HttpService:JSONEncode(safeOutfit)
        end)

        -- Action Panel & Raw JSON Output Box
        local rawFrame = Instance.new("Frame")
        rawFrame.Size = UDim2.new(1, -5, 0, 195) 
        rawFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
        rawFrame.BorderSizePixel = 0
        rawFrame.Parent = AssetScroll

        local rawTitle = Instance.new("TextLabel")
        rawTitle.Size = UDim2.new(1, -10, 0, 18)
        rawTitle.Position = UDim2.new(0, 5, 0, 6)
        rawTitle.Text = "Outfit Output & Actions"
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

        -- Button Layout Container
        local actionLayout = Instance.new("Frame")
        actionLayout.Size = UDim2.new(1, -10, 0, 28)
        actionLayout.Position = UDim2.new(0, 5, 0, 160)
        actionLayout.BackgroundTransparency = 1
        actionLayout.Parent = rawFrame

        local uigrid = Instance.new("UIGridLayout")
        uigrid.CellSize = UDim2.new(0.32, 0, 1, 0)
        uigrid.CellPadding = UDim2.new(0.02, 0, 0, 0)
        uigrid.SortOrder = Enum.SortOrder.LayoutOrder
        uigrid.Parent = actionLayout

        -- 1. Copy Button
        local copyBtn = Instance.new("TextButton")
        copyBtn.Text = "Copy JSON"
        copyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
        copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        copyBtn.Font = Enum.Font.SourceSansBold
        copyBtn.TextSize = 12
        copyBtn.BorderSizePixel = 0
        copyBtn.LayoutOrder = 1
        copyBtn.Parent = actionLayout

        -- 2. Save Outfit Button
        local saveBtn = Instance.new("TextButton")
        saveBtn.Text = "Save Outfit"
        saveBtn.BackgroundColor3 = Color3.fromRGB(40, 170, 90)
        saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        saveBtn.Font = Enum.Font.SourceSansBold
        saveBtn.TextSize = 12
        saveBtn.BorderSizePixel = 0
        saveBtn.LayoutOrder = 2
        saveBtn.Parent = actionLayout

        -- 3. Wear Outfit Button (Server-Sided via Network Hook)
        local wearBtn = Instance.new("TextButton")
        wearBtn.Text = "Try On (Server)"
        wearBtn.BackgroundColor3 = Color3.fromRGB(249, 180, 0)
        wearBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        wearBtn.Font = Enum.Font.SourceSansBold
        wearBtn.TextSize = 12
        wearBtn.BorderSizePixel = 0
        wearBtn.LayoutOrder = 3
        wearBtn.Parent = actionLayout

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
                pcall(function()
                    loadstring(game:HttpGet("https://pastebin.com/raw/GiEmv8Qf"))()
                end)
                task.wait(1)
                Send = getgenv().Send or (getgenv().g and getgenv().g.Send)
                Get = getgenv().Get or (getgenv().g and getgenv().g.Get)
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
                    
                                     if outfitData.Age and Get then
                        pcall(function()
                            Get("age", tostring(outfitData.Age)) 
                            task.wait(0.3)
                            Get("age", tostring(outfitData.Age))
                        end)
                        task.wait(0.3)
                    end

                    
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
                    table.insert(outfitsList, {
                        name = name,
                        data = data,
                        file = file,
                        isScanned = isScanned
                    })
                end
            end
        end
    end

    -- 2. Sort the table: Scanned outfits first, then alphabetical
    table.sort(outfitsList, function(a, b)
        if a.isScanned and not b.isScanned then
            return true
        elseif not a.isScanned and b.isScanned then
            return false
        else
            return string.lower(a.name) < string.lower(b.name)
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
            local myChar = LocalPlayer.Character
            if not myChar then return end

            -- Safely clone the character
            local oldArch = myChar.Archivable
            myChar.Archivable = true
            local dummy = myChar:Clone()
            myChar.Archivable = oldArch

            if dummy then
                -- Clean up scripts
                for _, v in pairs(dummy:GetDescendants()) do
                    if v:IsA("Script") or v:IsA("LocalScript") then v:Destroy() end
                end

                local hum = dummy:FindFirstChildOfClass("Humanoid")
                if hum then
                    -- Build a Roblox Description out of the saved JSON
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
                            local typeName = acc.AccessoryType .. "Accessory"
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

                    -- Apply the outfit to the dummy (Pcall because it has to download assets from Roblox)
                    pcall(function() hum:ApplyDescription(desc) end)
                end

                dummy.Parent = SmallViewport
                local camera = Instance.new("Camera")
                camera.Parent = SmallViewport
                
                local head = dummy:FindFirstChild("Head")
                if head then
                    camera.CFrame = head.CFrame * CFrame.new(0, 0, -2.5) * CFrame.Angles(0, math.pi, 0)
                    camera.Focus = head.CFrame
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
        WearBtn.Size = UDim2.new(0.18, 0, 0, 26)
        WearBtn.Position = UDim2.new(0.40, 0, 0.5, -13)
        WearBtn.Text = "Wear"
        WearBtn.BackgroundColor3 = Color3.fromRGB(249, 180, 0)
        WearBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
        WearBtn.Font = Enum.Font.SourceSansBold
        WearBtn.TextSize = 12
        WearBtn.BorderSizePixel = 0
        WearBtn.Parent = Entry

        local RenameBtn = Instance.new("TextButton")
        RenameBtn.Size = UDim2.new(0.20, 0, 0, 26)
        RenameBtn.Position = UDim2.new(0.60, 0, 0.5, -13)
        RenameBtn.Text = "Rename"
        RenameBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 150)
        RenameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        RenameBtn.Font = Enum.Font.SourceSansBold
        RenameBtn.TextSize = 12
        RenameBtn.BorderSizePixel = 0
        RenameBtn.Parent = Entry

        local DeleteBtn = Instance.new("TextButton")
        DeleteBtn.Size = UDim2.new(0.14, 0, 0, 26)
        DeleteBtn.Position = UDim2.new(0.82, 0, 0.5, -13)
        DeleteBtn.Text = "Del"
        DeleteBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        DeleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        DeleteBtn.Font = Enum.Font.SourceSansBold
        DeleteBtn.TextSize = 12
        DeleteBtn.BorderSizePixel = 0
        DeleteBtn.Parent = Entry

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
                    if data.Age and Get then pcall(function() Get("age", tostring(data.Age)) task.wait(0.3) Get("age", tostring(data.Age)) end) end
                    if data.HeightScale then for i=1,3 do Send("body_scale", "HeightScale", data.HeightScale * 100) task.wait(0.1) end end
                    if data.WidthScale then for i=1,3 do Send("body_scale", "WidthScale", data.WidthScale * 100) task.wait(0.1) end end
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

        PlayerBtn.MouseButton1Click:Connect(function()
            deepScanPlayerOutfit(player)
        end)
    end
end

-- Initialize
RefreshBtn.MouseButton1Click:Connect(populatePlayerList)
populatePlayerList()
