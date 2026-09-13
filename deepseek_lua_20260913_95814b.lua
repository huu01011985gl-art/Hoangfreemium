-- ============================================================
-- MARU HUB STYLE UI - Full (logo vẽ bằng code, không cần asset)
-- Tương thích 100% cú pháp BananaCatHubV2
-- ============================================================

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer

-- ===== THEME =====
local Theme = {
    Background  = Color3.fromRGB(22, 22, 28),
    Background2 = Color3.fromRGB(30, 30, 36),
    Card        = Color3.fromRGB(40, 40, 48),
    CardHover   = Color3.fromRGB(48, 48, 58),
    Text        = Color3.fromRGB(240, 240, 245),
    SubText     = Color3.fromRGB(160, 160, 175),
    Accent      = Color3.fromRGB(80, 140, 255),
    ToggleOff   = Color3.fromRGB(60, 60, 72),
    ToggleOn    = Color3.fromRGB(80, 140, 255),
    Stroke      = Color3.fromRGB(60, 60, 75),
}

-- ============================================================
-- HÀM VẼ LOGO MARU BẰNG CODE
-- ============================================================
local function CreateMaruLogo(size)
    size = size or UDim2.new(0, 60, 0, 60)
    local w, h = size.X.Offset, size.Y.Offset

    local container = Instance.new("Frame")
    container.Size = size
    container.BackgroundTransparency = 1
    container.ClipsDescendants = false

    -- Gradient xanh
    local grad = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 190, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(80, 140, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 85, 180)),
    }

    local function Bar(posX, posY, bw, bh, rot)
        local b = Instance.new("Frame")
        b.Size = UDim2.new(0, bw, 0, bh)
        b.Position = UDim2.new(0, posX, 0, posY)
        b.AnchorPoint = Vector2.new(0.5, 0.5)
        b.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
        b.BorderSizePixel = 0
        b.Rotation = rot
        b.Parent = container
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, math.max(2, bw * 0.15)); c.Parent = b
        local g = Instance.new("UIGradient"); g.Color = grad; g.Rotation = 90; g.Parent = b
        local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(220, 235, 255); s.Thickness = math.max(1, w * 0.012); s.Transparency = 0.15; s.Parent = b
        return b
    end

    -- Kích thước tương đối
    local barW = w * 0.18
    local barH = h * 0.80

    -- 2 thanh dọc
    Bar(w * 0.26, h * 0.5, barW, barH, 0)
    Bar(w * 0.74, h * 0.5, barW, barH, 0)
    -- 2 thanh chéo tạo thành chữ M
    Bar(w * 0.38, h * 0.55, barW * 0.85, barH * 0.72, 22)
    Bar(w * 0.62, h * 0.55, barW * 0.85, barH * 0.72, -22)

    -- Khung hình thoi ngoài
    local diamond = Instance.new("Frame")
    diamond.Size = UDim2.new(0, w * 0.96, 0, h * 0.96)
    diamond.Position = UDim2.new(0.5, -w * 0.48, 0.5, -h * 0.48)
    diamond.BackgroundTransparency = 1
    diamond.Rotation = 45
    diamond.Parent = container
    local dC = Instance.new("UICorner"); dC.CornerRadius = UDim.new(0, math.max(2, w * 0.05)); dC.Parent = diamond
    local dS = Instance.new("UIStroke"); dS.Color = Color3.fromRGB(200, 220, 255); dS.Thickness = math.max(1, w * 0.018); dS.Transparency = 0.35; dS.Parent = diamond

    return container
end

-- ============================================================
-- SCREEN GUI
-- ============================================================
if getgenv().MaruUI then pcall(function() getgenv().MaruUI:Destroy() end) end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MaruHubUI_" .. tostring(math.random(1, 999999))
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
getgenv().MaruUI = ScreenGui

local NotiGui = Instance.new("ScreenGui")
NotiGui.Name = "MaruHubNoti_" .. tostring(math.random(1, 999999))
NotiGui.ResetOnSpawn = false
pcall(function() NotiGui.Parent = CoreGui end)
if not NotiGui.Parent then NotiGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
local NotiList = Instance.new("UIListLayout")
NotiList.Padding = UDim.new(0, 8)
NotiList.SortOrder = Enum.SortOrder.LayoutOrder
NotiList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotiList.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotiList.Parent = NotiGui

-- ===== KÉO THẢ =====
local function makeDraggable(frame, dragArea)
    local dragging, dragInput, dragStart, startPos
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- ============================================================
-- NÚT TOGGLE (góc trái) — CÓ NỀN ĐEN + LOGO
-- ============================================================
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 62, 0, 62)
ToggleBtn.Position = UDim2.new(0, 20, 0, 120)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleBtn.BackgroundTransparency = 0.15
ToggleBtn.Text = ""
ToggleBtn.AutoButtonColor = false
ToggleBtn.Parent = ScreenGui

local TCorner = Instance.new("UICorner"); TCorner.CornerRadius = UDim.new(0, 12); TCorner.Parent = ToggleBtn
local TStroke = Instance.new("UIStroke"); TStroke.Color = Color3.fromRGB(70, 70, 90); TStroke.Thickness = 1.2; TStroke.Parent = ToggleBtn

-- Logo trong nút toggle (có nền đen ở ngoài)
local ToggleLogo = CreateMaruLogo(UDim2.new(0, 42, 0, 42))
ToggleLogo.Position = UDim2.new(0.5, -21, 0.5, -21)
ToggleLogo.Parent = ToggleBtn

ToggleBtn.MouseEnter:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
    TweenService:Create(TStroke, TweenInfo.new(0.15), { Color = Theme.Accent }):Play()
end)
ToggleBtn.MouseLeave:Connect(function()
    TweenService:Create(ToggleBtn, TweenInfo.new(0.15), { BackgroundTransparency = 0.15 }):Play()
    TweenService:Create(TStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(70, 70, 90) }):Play()
end)

makeDraggable(ToggleBtn, ToggleBtn)

-- ============================================================
-- LIBRARY API
-- ============================================================
local Library = {}

function Library:Notify(opts)
    opts = opts or {}
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 300, 0, 60)
    n.BackgroundColor3 = Theme.Background2
    n.BorderSizePixel = 0
    n.Position = UDim2.new(1, 320, 1, -80)
    n.Parent = NotiGui
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = n
    local s = Instance.new("UIStroke"); s.Color = Theme.Accent; s.Thickness = 1; s.Parent = n

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -20, 0, 22); t.Position = UDim2.new(0, 10, 0, 6)
    t.BackgroundTransparency = 1
    t.Text = opts.Title or "Thông báo"; t.TextColor3 = Theme.Accent; t.TextSize = 14
    t.Font = Enum.Font.GothamBold; t.TextXAlignment = Enum.TextXAlignment.Left; t.Parent = n

    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, -20, 1, -30); d.Position = UDim2.new(0, 10, 0, 28)
    d.BackgroundTransparency = 1
    d.Text = opts.Description or opts.Desc or ""; d.TextColor3 = Theme.SubText; d.TextSize = 12
    d.Font = Enum.Font.Gotham; d.TextXAlignment = Enum.TextXAlignment.Left; d.TextWrapped = true; d.Parent = n

    TweenService:Create(n, TweenInfo.new(0.3), { Position = UDim2.new(1, -320, 1, -80) }):Play()
    task.delay(opts.Duration or 3, function()
        TweenService:Create(n, TweenInfo.new(0.3), { Position = UDim2.new(1, 320, 1, -80) }):Play()
        task.wait(0.35); n:Destroy()
    end)
end

function Library:CreateWindow(opts)
    opts = opts or {}
    local titleText = opts.Title or "Maru Hub"
    local subtitleText = opts.Subtitle or ""

    -- ===== MAIN =====
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 620, 0, 400)
    Main.Position = UDim2.new(0.5, -310, 0.5, -200)
    Main.BackgroundColor3 = Theme.Background
    Main.BorderSizePixel = 0
    Main.Visible = false
    Main.Parent = ScreenGui
    local MC = Instance.new("UICorner"); MC.CornerRadius = UDim.new(0, 10); MC.Parent = Main
    local MS = Instance.new("UIStroke"); MS.Color = Theme.Stroke; MS.Thickness = 1; MS.Parent = Main

    -- ===== TITLE BAR =====
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Theme.Background2
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Main
    local TBC = Instance.new("UICorner"); TBC.CornerRadius = UDim.new(0, 10); TBC.Parent = TopBar
    makeDraggable(Main, TopBar)

    -- Logo nhỏ title bar (không nền)
    local topLogo = CreateMaruLogo(UDim2.new(0, 22, 0, 22))
    topLogo.Position = UDim2.new(0, 8, 0.5, -11)
    topLogo.Parent = TopBar

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -160, 1, 0)
    title.Position = UDim2.new(0, 36, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = titleText .. "  " .. subtitleText
    title.TextColor3 = Theme.Text; title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = TopBar

    local function MakeTitleBtn(text, posX, cb)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 32, 1, 0)
        btn.Position = UDim2.new(1, posX, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = text; btn.TextColor3 = Theme.Text; btn.TextSize = 15
        btn.Font = Enum.Font.GothamBold; btn.AutoButtonColor = false
        btn.Parent = TopBar
        btn.MouseEnter:Connect(function() btn.TextColor3 = Theme.Accent end)
        btn.MouseLeave:Connect(function() btn.TextColor3 = Theme.Text end)
        btn.MouseButton1Click:Connect(cb)
        return btn
    end

    MakeTitleBtn("—", -96, function() Main.Visible = false end)

    local isMax = false
    local nSize, nPos = UDim2.new(0, 620, 0, 400), UDim2.new(0.5, -310, 0.5, -200)
    MakeTitleBtn("□", -64, function()
        isMax = not isMax
        TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
            Size = isMax and UDim2.new(1, -40, 1, -40) or nSize,
            Position = isMax and UDim2.new(0, 20, 0, 20) or nPos
        }):Play()
    end)

    MakeTitleBtn("✕", -32, function() Main.Visible = false end)

    -- ===== SIDEBAR =====
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -35)
    Sidebar.Position = UDim2.new(0, 0, 0, 35)
    Sidebar.BackgroundColor3 = Theme.Background2
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = Main
    local SC = Instance.new("UICorner"); SC.CornerRadius = UDim.new(0, 10); SC.Parent = Sidebar

    -- Logo lớn sidebar — KHÔNG nền đen, chỉ logo trần
    local BigLogo = CreateMaruLogo(UDim2.new(0, 90, 0, 90))
    BigLogo.Position = UDim2.new(0.5, -45, 0, 10)
    BigLogo.Parent = Sidebar

    -- Search
    local SearchFrame = Instance.new("Frame")
    SearchFrame.Size = UDim2.new(1, -16, 0, 28)
    SearchFrame.Position = UDim2.new(0, 8, 0, 108)
    SearchFrame.BackgroundColor3 = Theme.Card
    SearchFrame.BorderSizePixel = 0
    SearchFrame.Parent = Sidebar
    local SFC = Instance.new("UICorner"); SFC.CornerRadius = UDim.new(0, 6); SFC.Parent = SearchFrame

    local SearchBox = Instance.new("TextBox")
    SearchBox.Size = UDim2.new(1, -16, 1, 0)
    SearchBox.Position = UDim2.new(0, 8, 0, 0)
    SearchBox.BackgroundTransparency = 1
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "🔍 Tìm kiếm..."
    SearchBox.PlaceholderColor3 = Theme.SubText
    SearchBox.TextColor3 = Theme.Text
    SearchBox.TextSize = 12
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    SearchBox.ClearTextOnFocus = false
    SearchBox.Parent = SearchFrame

    -- Tab list
    local TabList = Instance.new("ScrollingFrame")
    TabList.Size = UDim2.new(1, -16, 1, -150)
    TabList.Position = UDim2.new(0, 8, 0, 142)
    TabList.BackgroundTransparency = 1
    TabList.BorderSizePixel = 0
    TabList.ScrollBarThickness = 3
    TabList.ScrollBarImageColor3 = Theme.Accent
    TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabList.Parent = Sidebar

    local TLL = Instance.new("UIListLayout")
    TLL.Padding = UDim.new(0, 4)
    TLL.SortOrder = Enum.SortOrder.LayoutOrder
    TLL.Parent = TabList
    TLL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabList.CanvasSize = UDim2.new(0, 0, 0, TLL.AbsoluteContentSize.Y + 4)
    end)

    -- Content
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -160, 1, -35)
    Content.Position = UDim2.new(0, 160, 0, 35)
    Content.BackgroundTransparency = 1
    Content.Parent = Main

    local Pages = Instance.new("Frame")
    Pages.Size = UDim2.new(1, 0, 1, 0)
    Pages.BackgroundTransparency = 1
    Pages.Parent = Content

    -- ===== WINDOW API =====
    local Window = {}
    local Tabs = {}
    local AllElements = {}

    local function SwitchTab(t)
        for _, x in pairs(Tabs) do
            x.Page.Visible = false
            x.Button.BackgroundColor3 = Theme.Background2
            x.ButtonStroke.Color = Theme.Stroke
            x.ButtonTitle.TextColor3 = Theme.SubText
        end
        t.Page.Visible = true
        t.Button.BackgroundColor3 = Theme.Card
        t.ButtonStroke.Color = Theme.Accent
        t.ButtonTitle.TextColor3 = Theme.Accent
    end

    function Window:AddTab(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 32)
        btn.BackgroundColor3 = Theme.Background2
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = TabList
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = btn
        local bs = Instance.new("UIStroke"); bs.Color = Theme.Stroke; bs.Thickness = 1; bs.Parent = btn

        local bt = Instance.new("TextLabel")
        bt.Size = UDim2.new(1, -20, 1, 0)
        bt.Position = UDim2.new(0, 12, 0, 0)
        bt.BackgroundTransparency = 1
        bt.Text = name; bt.TextColor3 = Theme.SubText; bt.TextSize = 13
        bt.Font = Enum.Font.GothamMedium
        bt.TextXAlignment = Enum.TextXAlignment.Left
        bt.Parent = btn

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, -20, 1, -20)
        page.Position = UDim2.new(0, 10, 0, 10)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = Theme.Accent
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.Parent = Pages

        local pl = Instance.new("UIListLayout")
        pl.Padding = UDim.new(0, 8)
        pl.SortOrder = Enum.SortOrder.LayoutOrder
        pl.Parent = page
        pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pl.AbsoluteContentSize.Y + 8)
        end)

        local td = { Button = btn, ButtonTitle = bt, ButtonStroke = bs, Page = page, Name = name }
        table.insert(Tabs, td)
        btn.MouseButton1Click:Connect(function() SwitchTab(td) end)
        if #Tabs == 1 then SwitchTab(td) end

        -- ===== TAB API =====
        local Tab = {}

        function Tab:AddLeftGroupbox(n) return self:AddSection(n) end

        function Tab:AddSection(name)
            local sec = Instance.new("Frame")
            sec.Size = UDim2.new(1, 0, 0, 30)
            sec.BackgroundTransparency = 1
            sec.Parent = page

            local st = Instance.new("TextLabel")
            st.Size = UDim2.new(1, 0, 0, 24)
            st.BackgroundTransparency = 1
            st.Text = name; st.TextColor3 = Theme.Accent; st.TextSize = 13
            st.Font = Enum.Font.GothamBold
            st.TextXAlignment = Enum.TextXAlignment.Left
            st.Parent = sec

            local sl = Instance.new("Frame")
            sl.Size = UDim2.new(1, 0, 0, 1)
            sl.Position = UDim2.new(0, 0, 0, 24)
            sl.BackgroundColor3 = Theme.Accent
            sl.BackgroundTransparency = 0.6
            sl.BorderSizePixel = 0
            sl.Parent = sec

            local slist = Instance.new("Frame")
            slist.Size = UDim2.new(1, 0, 0, 0)
            slist.Position = UDim2.new(0, 0, 0, 30)
            slist.BackgroundTransparency = 1
            slist.Parent = sec

            local sll = Instance.new("UIListLayout")
            sll.Padding = UDim.new(0, 6)
            sll.SortOrder = Enum.SortOrder.LayoutOrder
            sll.Parent = slist
            sll:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                slist.Size = UDim2.new(1, 0, 0, sll.AbsoluteContentSize.Y)
                sec.Size = UDim2.new(1, 0, 0, 30 + sll.AbsoluteContentSize.Y + 10)
            end)

            local Group = {}

            -- TOGGLE
            function Group:AddToggle(flag, opts)
                opts = opts or {}
                local title = opts.Title or flag
                local desc = opts.Desc or opts.Description
                local state = opts.Default or false

                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, desc and 55 or 42)
                card.BackgroundColor3 = Theme.Card
                card.BorderSizePixel = 0
                card.Parent = slist
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = card

                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(1, -70, 0, 20)
                tl.Position = UDim2.new(0, 14, 0, desc and 8 or 11)
                tl.BackgroundTransparency = 1
                tl.Text = title; tl.TextColor3 = Theme.Text; tl.TextSize = 13
                tl.Font = Enum.Font.GothamMedium
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = card

                if desc then
                    local dl = Instance.new("TextLabel")
                    dl.Size = UDim2.new(1, -70, 0, 16)
                    dl.Position = UDim2.new(0, 14, 0, 30)
                    dl.BackgroundTransparency = 1
                    dl.Text = desc; dl.TextColor3 = Theme.SubText; dl.TextSize = 11
                    dl.Font = Enum.Font.Gotham
                    dl.TextXAlignment = Enum.TextXAlignment.Left
                    dl.Parent = card
                end

                local bg = Instance.new("Frame")
                bg.Size = UDim2.new(0, 44, 0, 22)
                bg.Position = UDim2.new(1, -56, 0.5, -11)
                bg.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
                bg.BorderSizePixel = 0
                bg.Parent = card
                local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(1, 0); bc.Parent = bg

                local circ = Instance.new("Frame")
                circ.Size = UDim2.new(0, 18, 0, 18)
                circ.Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                circ.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                circ.BorderSizePixel = 0
                circ.Parent = bg
                local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(1, 0); cc.Parent = circ

                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1, 0, 1, 0)
                b.BackgroundTransparency = 1
                b.Text = ""
                b.Parent = card

                b.MouseButton1Click:Connect(function()
                    state = not state
                    TweenService:Create(bg, TweenInfo.new(0.15), { BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff }):Play()
                    TweenService:Create(circ, TweenInfo.new(0.15), { Position = state and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9) }):Play()
                    if opts.Callback then pcall(opts.Callback, state) end
                end)

                table.insert(AllElements, { Card = card, Name = title, Section = name })
                return { SetStage = function(_, v) state = v end }
            end

            -- BUTTON
            function Group:AddButton(opts)
                opts = opts or {}
                local title = opts.Title or "Button"
                local desc = opts.Desc or opts.Description

                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, desc and 50 or 38)
                card.BackgroundColor3 = Theme.Card
                card.BorderSizePixel = 0
                card.Parent = slist
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = card

                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(1, -20, 0, 20)
                tl.Position = UDim2.new(0, 14, 0, desc and 6 or 9)
                tl.BackgroundTransparency = 1
                tl.Text = title; tl.TextColor3 = Theme.Text; tl.TextSize = 13
                tl.Font = Enum.Font.GothamMedium
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = card

                if desc then
                    local dl = Instance.new("TextLabel")
                    dl.Size = UDim2.new(1, -20, 0, 16)
                    dl.Position = UDim2.new(0, 14, 0, 26)
                    dl.BackgroundTransparency = 1
                    dl.Text = desc; dl.TextColor3 = Theme.SubText; dl.TextSize = 11
                    dl.Font = Enum.Font.Gotham
                    dl.TextXAlignment = Enum.TextXAlignment.Left
                    dl.Parent = card
                end

                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1, 0, 1, 0)
                b.BackgroundTransparency = 1
                b.Text = ""
                b.Parent = card

                b.MouseEnter:Connect(function()
                    TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = Theme.CardHover }):Play()
                end)
                b.MouseLeave:Connect(function()
                    TweenService:Create(card, TweenInfo.new(0.15), { BackgroundColor3 = Theme.Card }):Play()
                end)
                b.MouseButton1Click:Connect(function()
                    if opts.Callback then pcall(opts.Callback) end
                end)

                table.insert(AllElements, { Card = card, Name = title, Section = name })
                return { SetTitle = function(_, v) tl.Text = v end }
            end

            -- DROPDOWN
            function Group:AddDropdown(flag, opts)
                opts = opts or {}
                local title = opts.Title or flag
                local values = opts.Values or {}
                local selected = opts.Default

                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 38)
                card.BackgroundColor3 = Theme.Card
                card.BorderSizePixel = 0
                card.Parent = slist
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = card

                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(0.5, 0, 1, 0)
                tl.Position = UDim2.new(0, 14, 0, 0)
                tl.BackgroundTransparency = 1
                tl.Text = title; tl.TextColor3 = Theme.Text; tl.TextSize = 13
                tl.Font = Enum.Font.GothamMedium
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = card

                local vb = Instance.new("Frame")
                vb.Size = UDim2.new(0.45, 0, 1, -10)
                vb.Position = UDim2.new(0.53, 0, 0, 5)
                vb.BackgroundColor3 = Theme.Background2
                vb.BorderSizePixel = 0
                vb.Parent = card
                local vbc = Instance.new("UICorner"); vbc.CornerRadius = UDim.new(0, 6); vbc.Parent = vb

                local vl = Instance.new("TextLabel")
                vl.Size = UDim2.new(1, -30, 1, 0)
                vl.Position = UDim2.new(0, 8, 0, 0)
                vl.BackgroundTransparency = 1
                vl.Text = selected and tostring(selected) or "Chọn..."
                vl.TextColor3 = Theme.SubText; vl.TextSize = 12
                vl.Font = Enum.Font.Gotham
                vl.TextXAlignment = Enum.TextXAlignment.Left
                vl.Parent = vb

                local arr = Instance.new("TextLabel")
                arr.Size = UDim2.new(0, 25, 1, 0)
                arr.Position = UDim2.new(1, -25, 0, 0)
                arr.BackgroundTransparency = 1
                arr.Text = "‹"; arr.TextColor3 = Theme.SubText; arr.TextSize = 14
                arr.Parent = vb

                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1, 0, 1, 0)
                b.BackgroundTransparency = 1
                b.Text = ""
                b.Parent = card

                b.MouseButton1Click:Connect(function()
                    if #values == 0 then return end
                    selected = values[math.random(1, #values)]
                    vl.Text = tostring(selected)
                    if opts.Callback then pcall(opts.Callback, selected) end
                end)

                table.insert(AllElements, { Card = card, Name = title, Section = name })
                return { Set = function(_, v) selected = v; vl.Text = tostring(v) end }
            end

            -- SLIDER
            function Group:AddSlider(opts)
                opts = opts or {}
                local title = opts.Title or "Slider"
                local min = opts.Min or 0
                local max = opts.Max or 100
                local default = opts.Default or min

                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 50)
                card.BackgroundColor3 = Theme.Card
                card.BorderSizePixel = 0
                card.Parent = slist
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = card

                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(1, -60, 0, 20)
                tl.Position = UDim2.new(0, 14, 0, 6)
                tl.BackgroundTransparency = 1
                tl.Text = title; tl.TextColor3 = Theme.Text; tl.TextSize = 13
                tl.Font = Enum.Font.GothamMedium
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = card

                local vl = Instance.new("TextLabel")
                vl.Size = UDim2.new(0, 50, 0, 20)
                vl.Position = UDim2.new(1, -60, 0, 6)
                vl.BackgroundTransparency = 1
                vl.Text = tostring(default); vl.TextColor3 = Theme.Accent; vl.TextSize = 12
                vl.Font = Enum.Font.GothamBold
                vl.Parent = card

                local barBg = Instance.new("Frame")
                barBg.Size = UDim2.new(1, -28, 0, 6)
                barBg.Position = UDim2.new(0, 14, 0, 34)
                barBg.BackgroundColor3 = Theme.ToggleOff
                barBg.BorderSizePixel = 0
                barBg.Parent = card
                local bbc = Instance.new("UICorner"); bbc.CornerRadius = UDim.new(1, 0); bbc.Parent = barBg

                local barFill = Instance.new("Frame")
                barFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                barFill.BackgroundColor3 = Theme.Accent
                barFill.BorderSizePixel = 0
                barFill.Parent = barBg
                local bfc = Instance.new("UICorner"); bfc.CornerRadius = UDim.new(1, 0); bfc.Parent = barFill

                local sb = Instance.new("TextButton")
                sb.Size = UDim2.new(1, 0, 1, 20)
                sb.Position = UDim2.new(0, 0, -0.5, 0)
                sb.BackgroundTransparency = 1
                sb.Text = ""
                sb.Parent = barBg

                local dragging = false
                sb.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local rx = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                        local v = math.floor(min + (max - min) * rx)
                        barFill.Size = UDim2.new(rx, 0, 1, 0)
                        vl.Text = tostring(v)
                        if opts.Callback then pcall(opts.Callback, v) end
                    end
                end)

                table.insert(AllElements, { Card = card, Name = title, Section = name })
                return {}
            end

            -- INPUT
            function Group:AddInput(flag, opts)
                opts = opts or {}
                local title = opts.Title or flag
                local ph = opts.Placeholder or "Nhập..."

                local card = Instance.new("Frame")
                card.Size = UDim2.new(1, 0, 0, 38)
                card.BackgroundColor3 = Theme.Card
                card.BorderSizePixel = 0
                card.Parent = slist
                local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = card

                local tl = Instance.new("TextLabel")
                tl.Size = UDim2.new(0.5, 0, 1, 0)
                tl.Position = UDim2.new(0, 14, 0, 0)
                tl.BackgroundTransparency = 1
                tl.Text = title; tl.TextColor3 = Theme.Text; tl.TextSize = 12
                tl.Font = Enum.Font.Gotham
                tl.TextXAlignment = Enum.TextXAlignment.Left
                tl.Parent = card

                local box = Instance.new("TextBox")
                box.Size = UDim2.new(0.45, 0, 1, -10)
                box.Position = UDim2.new(0.53, 0, 0, 5)
                box.BackgroundColor3 = Theme.Background2
                box.BorderSizePixel = 0
                box.Text = ""
                box.PlaceholderText = ph
                box.PlaceholderColor3 = Theme.SubText
                box.TextColor3 = Theme.Text
                box.TextSize = 12
                box.Font = Enum.Font.Gotham
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.ClearTextOnFocus = false
                box.Parent = card
                local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = box

                box.FocusLost:Connect(function()
                    if opts.Callback then pcall(opts.Callback, box.Text) end
                end)

                table.insert(AllElements, { Card = card, Name = title, Section = name })
                return { Set = function(_, v) box.Text = v end }
            end

            -- LABEL
            function Group:AddLabel(text)
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 0, 24)
                lbl.BackgroundTransparency = 1
                lbl.Text = text; lbl.TextColor3 = Theme.SubText; lbl.TextSize = 12
                lbl.Font = Enum.Font.Gotham
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.TextWrapped = true
                lbl.Parent = slist

                table.insert(AllElements, { Card = lbl, Name = text, Section = name })
                return { SetText = function(_, v) lbl.Text = v end }
            end

            return Group
        end

        return Tab
    end

    -- ===== SEARCH HOẠT ĐỘNG =====
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(SearchBox.Text)
        for _, el in ipairs(AllElements) do
            if q == "" then
                el.Card.Visible = true
            else
                local m = string.find(string.lower(el.Name), q, 1, true) ~= nil
                    or string.find(string.lower(el.Section), q, 1, true) ~= nil
                el.Card.Visible = m
            end
        end
    end)

    -- Toggle
    ToggleBtn.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
    end)

    return Window
end

-- ============================================================
-- HẾT UI
-- ============================================================