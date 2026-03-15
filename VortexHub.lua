-- VORTEX HUB V1 | Blox Fruits | by Nagi Killer
-- Anime Theme | Clean Code

local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local TS=game:GetService("TweenService")
local RS=game:GetService("ReplicatedStorage")
local TeleServ=game:GetService("TeleportService")
local Http=game:GetService("HttpService")
local SGui=game:GetService("StarterGui")
local Lighting=game:GetService("Lighting")
local WS=game:GetService("Workspace")
local plr=Players.LocalPlayer
local WH="YOUR_WEBHOOK_URL_HERE"

-- Cleanup
local GP=gethui and gethui() or game:GetService("CoreGui")
if GP:FindFirstChild("VH") then GP.VH:Destroy() end

-- STATE (defined first!)
local T={
    farm=false,quest=false,fly=false,boss=false,
    chest=false,inv=false,spd=false,jump=false,
    clip=false,water=false,esp=false,fesp=false,
    bright=false,scan=false,prog=false,
    mel=false,def=false,swd=false,gun=false,frt=false,
}
local Sel={spd="Normal",boss="Any"}

-- Utils
local function Char() return plr.Character end
local function Root() local c=Char() return c and c:FindFirstChild("HumanoidRootPart") end
local function Hum() local c=Char() return c and c:FindFirstChild("Humanoid") end
local function Try(f) pcall(f) end
local function Tw(o,p,t) Try(function() TS:Create(o,TweenInfo.new(t or .2),p):Play() end) end
local function Ntf(a,b) task.spawn(function() task.wait(0.1) Try(function() SGui:SetCore("SendNotification",{Title=a,Text=b,Duration=3}) end) end) end
local function GetLv()
    local ls=plr:FindFirstChild("leaderstats")
    if ls then local v=ls:FindFirstChild("Level") or ls:FindFirstChild("Lv") if v then return v.Value end end
    return 1
end
local function GetSea() local lv=GetLv() if lv>=1500 then return 3 elseif lv>=700 then return 2 else return 1 end end
local function GetBest()
    local ISLD={
        [1]={{n="Starter Island",p=Vector3.new(-1285,17,1707),lv=1},{n="Jungle",p=Vector3.new(-2000,0,1500),lv=15},{n="Pirate Village",p=Vector3.new(-2029,0,185),lv=30},{n="Desert",p=Vector3.new(-800,0,-500),lv=60},{n="Frozen Village",p=Vector3.new(-4905,0,-4500),lv=90},{n="Marineford",p=Vector3.new(4680,0,-3875),lv=120},{n="Skylands",p=Vector3.new(-95,2200,1345),lv=150},{n="Prison",p=Vector3.new(4880,0,-1700),lv=190},{n="Colosseum",p=Vector3.new(1050,0,-4700),lv=225},{n="Magma Village",p=Vector3.new(-3700,0,-3200),lv=300},{n="Underwater City",p=Vector3.new(-1700,-1300,-500),lv=375},{n="Fountain City",p=Vector3.new(-3,0,-3005),lv=625}},
        [2]={{n="Kingdom of Rose",p=Vector3.new(-274,0,-1015),lv=700},{n="Green Zone",p=Vector3.new(2107,0,2500),lv=875},{n="Graveyard Island",p=Vector3.new(-2015,0,3505),lv=950},{n="Snow Mountain",p=Vector3.new(3905,0,4200),lv=1000},{n="Hot and Cold",p=Vector3.new(-3700,0,-3200),lv=1100},{n="Cursed Ship",p=Vector3.new(300,0,-2800),lv=1200},{n="Ice Castle",p=Vector3.new(3905,0,4200),lv=1350},{n="Forgotten Island",p=Vector3.new(-95,2700,2000),lv=1425}},
        [3]={{n="Port Town",p=Vector3.new(-350,0,600),lv=1500},{n="Hydra Island",p=Vector3.new(-11370,0,-1070),lv=1575},{n="Great Tree",p=Vector3.new(-12960,400,1000),lv=1700},{n="Floating Turtle",p=Vector3.new(-13530,0,2305),lv=1775},{n="Haunted Castle",p=Vector3.new(-12345,0,4120),lv=1975},{n="Sea of Treats",p=Vector3.new(-5600,0,-12000),lv=2075},{n="Tiki Outpost",p=Vector3.new(-13300,0,-3000),lv=2300}},
    }
    local lv=GetLv() local sea=GetSea() local b=ISLD[sea][1]
    for _,i in ipairs(ISLD[sea]) do if lv>=i.lv then b=i end end
    return b
end

-- Islands table (for teleport tab)
local ISLANDS={
    [1]={{n="Starter Island",p=Vector3.new(-1285,17,1707),lv=1},{n="Jungle",p=Vector3.new(-2000,0,1500),lv=15},{n="Pirate Village",p=Vector3.new(-2029,0,185),lv=30},{n="Desert",p=Vector3.new(-800,0,-500),lv=60},{n="Frozen Village",p=Vector3.new(-4905,0,-4500),lv=90},{n="Marineford",p=Vector3.new(4680,0,-3875),lv=120},{n="Skylands",p=Vector3.new(-95,2200,1345),lv=150},{n="Prison",p=Vector3.new(4880,0,-1700),lv=190},{n="Colosseum",p=Vector3.new(1050,0,-4700),lv=225},{n="Magma Village",p=Vector3.new(-3700,0,-3200),lv=300},{n="Underwater City",p=Vector3.new(-1700,-1300,-500),lv=375},{n="Fountain City",p=Vector3.new(-3,0,-3005),lv=625}},
    [2]={{n="Kingdom of Rose",p=Vector3.new(-274,0,-1015),lv=700},{n="Green Zone",p=Vector3.new(2107,0,2500),lv=875},{n="Graveyard Island",p=Vector3.new(-2015,0,3505),lv=950},{n="Snow Mountain",p=Vector3.new(3905,0,4200),lv=1000},{n="Hot and Cold",p=Vector3.new(-3700,0,-3200),lv=1100},{n="Cursed Ship",p=Vector3.new(300,0,-2800),lv=1200},{n="Ice Castle",p=Vector3.new(3905,0,4200),lv=1350},{n="Forgotten Island",p=Vector3.new(-95,2700,2000),lv=1425}},
    [3]={{n="Port Town",p=Vector3.new(-350,0,600),lv=1500},{n="Hydra Island",p=Vector3.new(-11370,0,-1070),lv=1575},{n="Great Tree",p=Vector3.new(-12960,400,1000),lv=1700},{n="Floating Turtle",p=Vector3.new(-13530,0,2305),lv=1775},{n="Haunted Castle",p=Vector3.new(-12345,0,4120),lv=1975},{n="Sea of Treats",p=Vector3.new(-5600,0,-12000),lv=2075},{n="Tiki Outpost",p=Vector3.new(-13300,0,-3000),lv=2300}},
}
local BOSSES={"Gorilla King","Bobby","Yeti","Vice Admiral","Cyborg","Diamond","Beautiful Pirate","Darkbeard","Don Swan","Tide Keeper","cursed captain","leviathan"}
local SPECIAL={{name="Mirage Island",emoji="🌊",hex=0x00D2FF,keys={"MirageIsland","Mirage"}},{name="Kitsune Shrine",emoji="🦊",hex=0xFF8C00,keys={"KitsuneShrine","Kitsune"}}}
local SKIP={"quest","dealer","master","teacher","citizen","blacksmith","shop","upgrade","travel","mihawk","shanks","rayleigh","trainer","garp","doctor","cook","barkeep","vendor"}

-- Remotes
local Rems=nil
task.spawn(function() Try(function() Rems=RS:WaitForChild("Remotes",15) end) end)
local function Fire(n,...) Try(function() local f=Rems or RS:FindFirstChild("Remotes") if not f then return end local r=f:FindFirstChild(n) if r then if r:IsA("RemoteEvent") then r:FireServer(...) else r:InvokeServer(...) end end end) end

-- Game functions
local function DetIsland() for _,i in ipairs(SPECIAL) do for _,k in ipairs(i.keys) do if WS:FindFirstChild(k) then return i end for _,v in ipairs(WS:GetDescendants()) do if v.Name:lower():find(k:lower()) then return i end end end end end
local function IsEnemy(v)
    if not v:IsA("Model") then return false end
    for _,p in ipairs(Players:GetPlayers()) do if p.Character==v then return false end end
    local n=v.Name:lower() for _,s in ipairs(SKIP) do if n:find(s) then return false end end
    local h=v:FindFirstChildOfClass("Humanoid") if not h or h.Health<=0 then return false end
    return v:FindFirstChild("HumanoidRootPart")~=nil
end
local function FindEnemy()
    local r=Root() if not r then return nil,0 end
    local bn,bd=nil,math.huge
    for _,v in ipairs(WS:GetDescendants()) do
        if IsEnemy(v) then local m=v:FindFirstChild("HumanoidRootPart") if m then local d=(r.Position-m.Position).Magnitude if d<bd then bn=v bd=d end end end
    end
    return bn,bd
end
local function TP(pos,nm)
    task.spawn(function() Try(function()
        local r=Root() if not r then return end
        local h=Hum() if h then h.WalkSpeed=0 end
        if nm then Fire("TeleportIsland",nm,pos) end
        for i=1,8 do r.CFrame=CFrame.new(pos+Vector3.new(0,5,0)) task.wait(0.05) end
        if h then h.WalkSpeed=24 end
    end) end)
end
local function Attack(t)
    if not t then return end
    Fire("AttackMob",t) Fire("DamageMob",t)
    local m=t:FindFirstChild("HumanoidRootPart")
    if m then local p=m.Position Fire("UseFruit",p) Fire("UseSword",p) Fire("GunShoot",p) for i=1,3 do Fire("UseAbility"..i,p) end end
    Try(function() local c=Char() if not c then return end local tl=c:FindFirstChildOfClass("Tool") if tl then if m then local re=tl:FindFirstChildOfClass("RemoteEvent") if re then re:FireServer(m.Position) end end tl:Activate() end end)
end

-- Fly
local FBV,FBG,FC,FO=nil,nil,nil,false
local function FlyOn(h) FO=true Fire("Fly",true) Try(function() local r=Root() if not r then return end if FBV and FBV.Parent then FBV:Destroy() end if FBG and FBG.Parent then FBG:Destroy() end FBV=Instance.new("BodyVelocity",r) FBV.Velocity=Vector3.new(0,0,0) FBV.MaxForce=Vector3.new(0,math.huge,0) FBV.P=1e5 FBG=Instance.new("BodyGyro",r) FBG.MaxTorque=Vector3.new(math.huge,math.huge,math.huge) FBG.P=9e3 FBG.D=100 FBG.CFrame=r.CFrame r.CFrame=CFrame.new(r.Position+Vector3.new(0,h or 150,0)) end) if FC then FC:Disconnect() end FC=RunService.Heartbeat:Connect(function() if FO and FBV and FBV.Parent then FBV.Velocity=Vector3.new(0,0,0) end end) end
local function FlyOff() FO=false Fire("Fly",false) Fire("StopFly") if FC then FC:Disconnect() FC=nil end Try(function() if FBV and FBV.Parent then FBV:Destroy() end end) Try(function() if FBG and FBG.Parent then FBG:Destroy() end end) end
local WP=nil
local function WOn() Try(function() if WP and WP.Parent then WP:Destroy() end local r=Root() if not r then return end WP=Instance.new("Part",WS) WP.Size=Vector3.new(10,.5,10) WP.Anchored=false WP.CanCollide=true WP.Transparency=.95 WP.CFrame=r.CFrame*CFrame.new(0,-2.8,0) local w=Instance.new("WeldConstraint",WP) w.Part0=WP w.Part1=r end) end
local function WOff() Try(function() if WP and WP.Parent then WP:Destroy() WP=nil end end) end

-- ═══════════════════════════
-- ANIME COLORS
-- ═══════════════════════════
local BG   =Color3.fromRGB(10,8,20)
local BG2  =Color3.fromRGB(16,12,30)
local BG3  =Color3.fromRGB(24,18,42)
local CARD =Color3.fromRGB(18,14,32)
local SIDE =Color3.fromRGB(12,10,22)
local PUR  =Color3.fromRGB(168,48,255)
local PINK =Color3.fromRGB(255,48,168)
local BLUE =Color3.fromRGB(48,168,255)
local GOLD =Color3.fromRGB(255,192,48)
local GRN  =Color3.fromRGB(48,255,128)
local RED  =Color3.fromRGB(255,48,72)
local WHT  =Color3.fromRGB(232,228,255)
local GRY  =Color3.fromRGB(128,118,152)
local DRK  =Color3.fromRGB(52,42,72)
local TOFF =Color3.fromRGB(26,20,44)

-- ═══════════════════════════
-- SCREEN GUI
-- ═══════════════════════════
local SG=Instance.new("ScreenGui",GP)
SG.Name="VH" SG.ResetOnSpawn=false SG.DisplayOrder=999 SG.IgnoreGuiInset=true SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling

-- ═══════════════════════════
-- ANIME V BUTTON
-- ═══════════════════════════
local VF=Instance.new("Frame",SG)
VF.Size=UDim2.new(0,56,0,56) VF.Position=UDim2.new(0,10,0.5,-28)
VF.BackgroundColor3=BG VF.BorderSizePixel=0 VF.ZIndex=30
Instance.new("UICorner",VF).CornerRadius=UDim.new(0,14)

-- Animated gradient border
local VStr=Instance.new("UIStroke",VF) VStr.Color=PUR VStr.Thickness=2.5

-- Rainbow corners
local CL={}
local function MkCL(xs,ys,xo,yo,w,h)
    local f=Instance.new("Frame",VF)
    f.Size=UDim2.new(0,w,0,h) f.Position=UDim2.new(xs,xo,ys,yo)
    f.BackgroundColor3=PUR f.BorderSizePixel=0 f.ZIndex=33
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,2)
    table.insert(CL,f)
end
MkCL(0,0,2,2,14,2) MkCL(0,0,2,2,2,14)
MkCL(1,0,-16,2,14,2) MkCL(1,0,-4,2,2,14)
MkCL(0,1,2,-4,14,2) MkCL(0,1,2,-16,2,14)
MkCL(1,1,-16,-4,14,2) MkCL(1,1,-4,-16,2,14)

-- Inner glow
local VGl=Instance.new("Frame",VF)
VGl.Size=UDim2.new(1,0,1,0) VGl.BackgroundColor3=PUR
VGl.BackgroundTransparency=0.82 VGl.BorderSizePixel=0 VGl.ZIndex=31
Instance.new("UICorner",VGl).CornerRadius=UDim.new(0,14)

-- Shadow V
local VS=Instance.new("TextLabel",VF)
VS.Size=UDim2.new(1,3,1,3) VS.Position=UDim2.new(0,2,0,2)
VS.BackgroundTransparency=1 VS.Text="V"
VS.TextColor3=Color3.fromRGB(60,0,100) VS.TextSize=32
VS.Font=Enum.Font.GothamBlack VS.ZIndex=32

-- Main V
local VM=Instance.new("TextLabel",VF)
VM.Size=UDim2.new(1,0,1,0) VM.BackgroundTransparency=1
VM.Text="V" VM.TextColor3=WHT VM.TextSize=32
VM.Font=Enum.Font.GothamBlack VM.ZIndex=33

-- Anime pulse ring
local VRing=Instance.new("Frame",VF)
VRing.Size=UDim2.new(1,8,1,8) VRing.Position=UDim2.new(0,-4,0,-4)
VRing.BackgroundTransparency=1 VRing.BorderSizePixel=0 VRing.ZIndex=29
Instance.new("UICorner",VRing).CornerRadius=UDim.new(0,18)
local VRingSt=Instance.new("UIStroke",VRing) VRingSt.Color=PUR VRingSt.Thickness=1 VRingSt.Transparency=0.6

-- Rainbow + pulse animation
task.spawn(function()
    local t=0
    while SG.Parent do
        t=t+0.04
        local r=math.floor(math.sin(t)*127+128)
        local g=math.floor(math.sin(t+2.1)*127+128)
        local b=math.floor(math.sin(t+4.2)*127+128)
        local col=Color3.fromRGB(r,g,b)
        VStr.Color=col VM.TextColor3=col VGl.BackgroundColor3=col VRingSt.Color=col
        VRingSt.Transparency=0.4+math.sin(t*2)*0.3
        for i,f in ipairs(CL) do
            local o=i*(math.pi/4)
            f.BackgroundColor3=Color3.fromRGB(math.floor(math.sin(t+o)*127+128),math.floor(math.sin(t+o+2.1)*127+128),math.floor(math.sin(t+o+4.2)*127+128))
        end
        task.wait(0.05)
    end
end)

-- V click + drag
local VBtn=Instance.new("TextButton",VF)
VBtn.Size=UDim2.new(1,0,1,0) VBtn.BackgroundTransparency=1 VBtn.Text="" VBtn.BorderSizePixel=0 VBtn.ZIndex=34
local vd,vi,vs,vp=false,nil,nil,nil
VBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then vd=true vs=i.Position vp=VF.Position i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then vd=false end end) end end)
VBtn.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then vi=i end end)
UIS.InputChanged:Connect(function(i) if i==vi and vd then local d=i.Position-vs VF.Position=UDim2.new(vp.X.Scale,vp.X.Offset+d.X,vp.Y.Scale,vp.Y.Offset+d.Y) end end)

-- ═══════════════════════════
-- MAIN PANEL (Anime style)
-- ═══════════════════════════
local isOpen=false
local Panel=Instance.new("Frame",SG)
Panel.Name="VHPanel" Panel.Size=UDim2.new(0,500,0,370)
Panel.Position=UDim2.new(0.5,-250,0.5,-185)
Panel.BackgroundColor3=BG Panel.BorderSizePixel=0
Panel.ClipsDescendants=true Panel.ZIndex=15 Panel.Visible=false
Instance.new("UICorner",Panel).CornerRadius=UDim.new(0,18)

-- Animated panel stroke
local PSt=Instance.new("UIStroke",Panel) PSt.Color=PUR PSt.Thickness=1.5
task.spawn(function() local t=0 while SG.Parent do t=t+0.03 PSt.Color=Color3.fromRGB(math.floor(math.sin(t)*127+128),math.floor(math.sin(t+2.1)*127+128),math.floor(math.sin(t+4.2)*127+128)) task.wait(0.05) end end)

-- Anime diagonal pattern bg
local BgPat=Instance.new("Frame",Panel)
BgPat.Size=UDim2.new(1,0,1,0) BgPat.BackgroundColor3=BG BgPat.BorderSizePixel=0 BgPat.ZIndex=14
Instance.new("UICorner",BgPat).CornerRadius=UDim.new(0,18)

-- Title bar with anime gradient
local TB=Instance.new("Frame",Panel)
TB.Size=UDim2.new(1,0,0,40) TB.BackgroundColor3=BG2 TB.BorderSizePixel=0 TB.ZIndex=16
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,18)
-- Fix corners
local TFx=Instance.new("Frame",TB) TFx.Size=UDim2.new(1,0,0,18) TFx.Position=UDim2.new(0,0,1,-18) TFx.BackgroundColor3=BG2 TFx.BorderSizePixel=0 TFx.ZIndex=16

-- Animated rainbow line
local RL=Instance.new("Frame",TB) RL.Size=UDim2.new(1,0,0,2) RL.Position=UDim2.new(0,0,1,-2) RL.BackgroundColor3=PUR RL.BorderSizePixel=0 RL.ZIndex=17
local RG=Instance.new("UIGradient",RL)
RG.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(0,0,0)),ColorSequenceKeypoint.new(0.2,BLUE),ColorSequenceKeypoint.new(0.5,PUR),ColorSequenceKeypoint.new(0.8,PINK),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))})
task.spawn(function() local r=0 while SG.Parent do r=(r+2)%360 RG.Rotation=r task.wait(0.03) end end)

-- Title icon + text
local TIco=Instance.new("TextLabel",TB) TIco.Size=UDim2.new(0,30,1,0) TIco.Position=UDim2.new(0,8,0,0) TIco.BackgroundTransparency=1 TIco.Text="⚡" TIco.TextScaled=true TIco.ZIndex=17
local TLbl=Instance.new("TextLabel",TB) TLbl.Size=UDim2.new(1,-130,1,0) TLbl.Position=UDim2.new(0,40,0,0) TLbl.BackgroundTransparency=1 TLbl.Text="VORTEX HUB" TLbl.TextColor3=WHT TLbl.TextSize=16 TLbl.Font=Enum.Font.GothamBlack TLbl.TextXAlignment=Enum.TextXAlignment.Left TLbl.ZIndex=17
-- Animate title color
task.spawn(function() local t=0 while SG.Parent do t=t+0.03 TLbl.TextColor3=Color3.fromRGB(math.floor(math.sin(t)*60+195),math.floor(math.sin(t+1)*20+210),255) task.wait(0.05) end end)

local VTag=Instance.new("TextLabel",TB) VTag.Size=UDim2.new(0,26,0,15) VTag.Position=UDim2.new(0,182,0.5,-7) VTag.BackgroundColor3=PUR VTag.Text="V1" VTag.TextColor3=WHT VTag.TextSize=9 VTag.Font=Enum.Font.GothamBlack VTag.BorderSizePixel=0 VTag.ZIndex=17 Instance.new("UICorner",VTag).CornerRadius=UDim.new(0,4)

local function MkTBtn(t,xo,c)
    local b=Instance.new("TextButton",TB) b.Size=UDim2.new(0,26,0,26) b.Position=UDim2.new(1,xo,0.5,-13) b.BackgroundColor3=BG3 b.Text=t b.TextColor3=c b.TextSize=12 b.Font=Enum.Font.GothamBold b.BorderSizePixel=0 b.ZIndex=18
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7) Instance.new("UIStroke",b).Color=c return b
end
local MinB=MkTBtn("—",-58,GRY)
local XB=MkTBtn("✕",-28,RED)

-- Drag panel
local DB=Instance.new("TextButton",TB) DB.Size=UDim2.new(1,-60,1,0) DB.BackgroundTransparency=1 DB.Text="" DB.ZIndex=19
local pd,pi,ps,pp=false,nil,nil,nil
DB.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then pd=true ps=i.Position pp=Panel.Position i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then pd=false end end) end end)
DB.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then pi=i end end)
UIS.InputChanged:Connect(function(i) if i==pi and pd then local d=i.Position-ps Panel.Position=UDim2.new(pp.X.Scale,pp.X.Offset+d.X,pp.Y.Scale,pp.Y.Offset+d.Y) end end)

-- Sidebar
local SB=Instance.new("Frame",Panel) SB.Size=UDim2.new(0,100,1,-42) SB.Position=UDim2.new(0,0,0,42) SB.BackgroundColor3=SIDE SB.BorderSizePixel=0 SB.ZIndex=16
Instance.new("UIListLayout",SB).Padding=UDim.new(0,2)
local SBPad=Instance.new("UIPadding",SB) SBPad.PaddingTop=UDim.new(0,6) SBPad.PaddingLeft=UDim.new(0,3) SBPad.PaddingRight=UDim.new(0,3)
local SDv=Instance.new("Frame",Panel) SDv.Size=UDim2.new(0,1,1,-42) SDv.Position=UDim2.new(0,100,0,42) SDv.BackgroundColor3=BG3 SDv.BorderSizePixel=0 SDv.ZIndex=16

-- Scroll
local SC=Instance.new("ScrollingFrame",Panel)
SC.Size=UDim2.new(1,-106,1,-46) SC.Position=UDim2.new(0,103,0,44)
SC.BackgroundTransparency=1 SC.BorderSizePixel=0 SC.ScrollBarThickness=2
SC.ScrollBarImageColor3=PUR SC.CanvasSize=UDim2.new(0,0,0,0)
SC.ZIndex=16 SC.ScrollingEnabled=true
local SCL=Instance.new("UIListLayout",SC) SCL.Padding=UDim.new(0,3) SCL.HorizontalAlignment=Enum.HorizontalAlignment.Center SCL.SortOrder=Enum.SortOrder.LayoutOrder
local SCPAD=Instance.new("UIPadding",SC) SCPAD.PaddingTop=UDim.new(0,4) SCPAD.PaddingBottom=UDim.new(0,10) SCPAD.PaddingLeft=UDim.new(0,4) SCPAD.PaddingRight=UDim.new(0,6)
SCL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() SC.CanvasSize=UDim2.new(0,0,0,SCL.AbsoluteContentSize.Y+16) end)

-- ═══════════════════════════
-- TABS
-- ═══════════════════════════
local TABS={{ic="⚔️",nm="Farm",nc=PINK},{ic="💀",nm="Boss",nc=RED},{ic="🌊",nm="Islands",nc=BLUE},{ic="📊",nm="Stats",nc=GRN},{ic="🗺️",nm="Teleport",nc=GOLD},{ic="🔧",nm="Player",nc=PUR},{ic="👁️",nm="Visual",nc=Color3.fromRGB(200,140,255)},{ic="📋",nm="Info",nc=GRY}}
local TBTN={} local CT=1 local ITS={}
local function MkTab(d,i)
    local f=Instance.new("Frame",SB) f.Size=UDim2.new(1,0,0,42) f.BackgroundColor3=SIDE f.BorderSizePixel=0 f.ZIndex=16
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
    -- Anime tab with icon + name
    local ico=Instance.new("TextLabel",f) ico.Size=UDim2.new(1,0,0,20) ico.Position=UDim2.new(0,0,0,3) ico.BackgroundTransparency=1 ico.Text=d.ic ico.TextScaled=true ico.ZIndex=18
    local nm=Instance.new("TextLabel",f) nm.Size=UDim2.new(1,0,0,14) nm.Position=UDim2.new(0,0,0,25) nm.BackgroundTransparency=1 nm.Text=d.nm nm.TextColor3=DRK nm.TextSize=8 nm.Font=Enum.Font.GothamBold nm.ZIndex=18
    -- Active bar
    local ac=Instance.new("Frame",f) ac.Size=UDim2.new(0,3,0.6,0) ac.Position=UDim2.new(0,0,0.2,0) ac.BackgroundColor3=d.nc ac.BorderSizePixel=0 ac.ZIndex=19 ac.Visible=false Instance.new("UICorner",ac).CornerRadius=UDim.new(0,2)
    local b=Instance.new("TextButton",f) b.Size=UDim2.new(1,0,1,0) b.BackgroundTransparency=1 b.Text="" b.ZIndex=20
    TBTN[i]={f=f,nm=nm,ac=ac,b=b,d=d}
end
for i,d in ipairs(TABS) do MkTab(d,i) end

-- ═══════════════════════════
-- CONTENT BUILDERS
-- ═══════════════════════════
local OC={} local function NO(t) OC[t]=(OC[t] or t*100)+1 return OC[t] end
local function TR(f,t) table.insert(ITS,{f=f,t=t}) return f end

local function Sec(tx,t,col)
    local f=Instance.new("Frame",SC) f.Size=UDim2.new(1,-2,0,24) f.BackgroundTransparency=1 f.LayoutOrder=NO(t) f.ZIndex=17 f.Visible=false
    -- Anime section header with colored dot
    local dot=Instance.new("Frame",f) dot.Size=UDim2.new(0,4,0,14) dot.Position=UDim2.new(0,2,0.5,-7) dot.BackgroundColor3=col or PUR dot.BorderSizePixel=0 dot.ZIndex=18 Instance.new("UICorner",dot).CornerRadius=UDim.new(0,2)
    local l=Instance.new("TextLabel",f) l.Size=UDim2.new(1,-12,0,16) l.Position=UDim2.new(0,10,0.5,-8) l.BackgroundTransparency=1 l.Text=tx:upper() l.TextColor3=col or PUR l.TextSize=10 l.Font=Enum.Font.GothamBlack l.TextXAlignment=Enum.TextXAlignment.Left l.ZIndex=18
    local ln=Instance.new("Frame",f) ln.Size=UDim2.new(1,-12,0,1) ln.Position=UDim2.new(0,10,1,-1) ln.BackgroundColor3=col or PUR ln.BackgroundTransparency=0.6 ln.BorderSizePixel=0 ln.ZIndex=18
    -- Gradient line
    local lg=Instance.new("UIGradient",ln) lg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))})
    return TR(f,t)
end

local function Tog(lb,sb,t,key,col)
    local f=Instance.new("Frame",SC) f.Size=UDim2.new(1,-2,0,sb and 44 or 36) f.BackgroundColor3=CARD f.BorderSizePixel=0 f.LayoutOrder=NO(t) f.ZIndex=17 f.Visible=false
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,10)
    -- Anime card border
    local fst=Instance.new("UIStroke",f) fst.Color=DRK fst.Thickness=1 fst.Transparency=0.5
    -- Left colored bar
    local bar=Instance.new("Frame",f) bar.Size=UDim2.new(0,3,0.6,0) bar.Position=UDim2.new(0,0,0.2,0) bar.BackgroundColor3=DRK bar.BorderSizePixel=0 bar.ZIndex=18 Instance.new("UICorner",bar).CornerRadius=UDim.new(0,2)
    local ll=Instance.new("TextLabel",f) ll.Size=UDim2.new(1,-56,0,18) ll.Position=UDim2.new(0,12,0,sb and 5 or 9) ll.BackgroundTransparency=1 ll.Text=lb ll.TextColor3=WHT ll.TextSize=12 ll.Font=Enum.Font.GothamBold ll.TextXAlignment=Enum.TextXAlignment.Left ll.ZIndex=18
    if sb then local sl=Instance.new("TextLabel",f) sl.Size=UDim2.new(1,-56,0,12) sl.Position=UDim2.new(0,12,0,24) sl.BackgroundTransparency=1 sl.Text=sb sl.TextColor3=GRY sl.TextSize=9 sl.Font=Enum.Font.Gotham sl.TextXAlignment=Enum.TextXAlignment.Left sl.ZIndex=18 end
    -- Anime pill toggle
    local pill=Instance.new("Frame",f) pill.Size=UDim2.new(0,42,0,22) pill.Position=UDim2.new(1,-48,0.5,-11) pill.BackgroundColor3=TOFF pill.BorderSizePixel=0 pill.ZIndex=19 Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
    local pst=Instance.new("UIStroke",pill) pst.Color=DRK pst.Thickness=1
    local knob=Instance.new("Frame",pill) knob.Size=UDim2.new(0,16,0,16) knob.Position=UDim2.new(0,3,0.5,-8) knob.BackgroundColor3=DRK knob.BorderSizePixel=0 knob.ZIndex=20 Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    local nc=col or PUR
    local function Ref()
        local on=T[key]
        Tw(pill,{BackgroundColor3=on and nc or TOFF})
        Tw(knob,{Position=on and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8),BackgroundColor3=on and WHT or DRK})
        Tw(pst,{Color=on and nc or DRK})
        Tw(bar,{BackgroundColor3=on and nc or DRK})
        Tw(fst,{Color=on and nc or DRK,Transparency=on and 0.3 or 0.5})
    end
    local hit=Instance.new("TextButton",f) hit.Size=UDim2.new(1,0,1,0) hit.BackgroundTransparency=1 hit.Text="" hit.ZIndex=21
    hit.MouseButton1Click:Connect(function()
        T[key]=not T[key] Ref()
        if key=="fly" then if T.fly then FlyOn(150) else FlyOff() end end
        if key=="water" then if T.water then WOn() else WOff() end end
    end)
    return TR(f,t)
end

local function Btn(lb,t,col,cb)
    local f=Instance.new("Frame",SC) f.Size=UDim2.new(1,-2,0,34) f.BackgroundTransparency=1 f.LayoutOrder=NO(t) f.ZIndex=17 f.Visible=false
    local b=Instance.new("TextButton",f) b.Size=UDim2.new(1,0,0,30) b.Position=UDim2.new(0,0,0,2) b.BackgroundColor3=CARD b.Text=lb b.TextColor3=col or PUR b.TextSize=11 b.Font=Enum.Font.GothamBold b.BorderSizePixel=0 b.ZIndex=18
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    local bst=Instance.new("UIStroke",b) bst.Color=col or PUR bst.Thickness=1
    -- Anime gradient on button
    local bg=Instance.new("UIGradient",b) bg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(30,20,50)),ColorSequenceKeypoint.new(1,Color3.fromRGB(15,10,25))}) bg.Rotation=90
    b.MouseEnter:Connect(function() Tw(b,{BackgroundTransparency=0.3}) end)
    b.MouseLeave:Connect(function() Tw(b,{BackgroundTransparency=0}) end)
    if cb then b.MouseButton1Click:Connect(cb) end
    TR(f,t) return b
end

local function Inf(lb,t,col)
    local f=Instance.new("Frame",SC) f.Size=UDim2.new(1,-2,0,30) f.BackgroundColor3=CARD f.BorderSizePixel=0 f.LayoutOrder=NO(t) f.ZIndex=17 f.Visible=false Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
    Instance.new("UIStroke",f).Color=DRK
    local ll=Instance.new("TextLabel",f) ll.Size=UDim2.new(0.52,0,1,0) ll.Position=UDim2.new(0,10,0,0) ll.BackgroundTransparency=1 ll.Text=lb ll.TextColor3=GRY ll.TextSize=11 ll.Font=Enum.Font.GothamBold ll.TextXAlignment=Enum.TextXAlignment.Left ll.ZIndex=18
    local vl=Instance.new("TextLabel",f) vl.Size=UDim2.new(0.46,-4,1,0) vl.Position=UDim2.new(0.52,0,0,0) vl.BackgroundTransparency=1 vl.Text="—" vl.TextColor3=col or PUR vl.TextSize=11 vl.Font=Enum.Font.GothamBold vl.TextXAlignment=Enum.TextXAlignment.Right vl.ZIndex=18
    TR(f,t) return vl
end

local function Drp(lb,t,opts,sk,col)
    local f=Instance.new("Frame",SC) f.Size=UDim2.new(1,-2,0,36) f.BackgroundColor3=CARD f.BorderSizePixel=0 f.LayoutOrder=NO(t) f.ZIndex=17 f.Visible=false Instance.new("UICorner",f).CornerRadius=UDim.new(0,10) Instance.new("UIStroke",f).Color=DRK
    local ll=Instance.new("TextLabel",f) ll.Size=UDim2.new(0.5,0,1,0) ll.Position=UDim2.new(0,10,0,0) ll.BackgroundTransparency=1 ll.Text=lb ll.TextColor3=WHT ll.TextSize=11 ll.Font=Enum.Font.GothamBold ll.TextXAlignment=Enum.TextXAlignment.Left ll.ZIndex=18
    local idx=1
    local vb=Instance.new("TextButton",f) vb.Size=UDim2.new(0.44,0,0,24) vb.Position=UDim2.new(0.54,0,0.5,-12) vb.BackgroundColor3=BG3 vb.Text=opts[idx].." ▾" vb.TextColor3=col or PUR vb.TextSize=10 vb.Font=Enum.Font.GothamBold vb.BorderSizePixel=0 vb.ZIndex=19 Instance.new("UICorner",vb).CornerRadius=UDim.new(0,6) Instance.new("UIStroke",vb).Color=col or PUR
    vb.MouseButton1Click:Connect(function() idx=idx%#opts+1 vb.Text=opts[idx].." ▾" Sel[sk]=opts[idx] end)
    TR(f,t)
end

local function Sp(t,h) local f=Instance.new("Frame",SC) f.Size=UDim2.new(1,-2,0,h or 4) f.BackgroundTransparency=1 f.LayoutOrder=NO(t) f.ZIndex=17 f.Visible=false TR(f,t) end

-- ═══════════════════════════
-- BUILD ALL TABS
-- ═══════════════════════════

-- TAB 1: FARM
Sec("Auto Farm",1,PINK)
Tog("Auto Farm","Moves to enemies + AttackMob",1,"farm",PINK)
Tog("Auto Quest","TP to NPC + AcceptQuest",1,"quest",GRN)
Tog("Fly While Farming","Float above mobs",1,"fly",BLUE)
Tog("Auto Chest","Collect chests",1,"chest",GOLD)
Tog("Auto Progression","TP to best island for level",1,"prog",PUR)
Sp(1) Sec("Combat",1,PINK)
Drp("Attack Speed",1,{"Normal","Fast","Very Fast"},"spd",PINK)
Sp(1) Sec("Status",1)
local sF=Inf("Status",1,PINK)   sF.Text="Inactive"
local sT=Inf("Target",1,WHT)    sT.Text="None"
local sQ=Inf("Quest",1,GRN)     sQ.Text="None"
local sI=Inf("Island",1,GOLD)   sI.Text="—"

-- TAB 2: BOSS
Sec("Boss Finder",2,RED)
local bI=Inf("In Server",2,RED) bI.Text="Tap Scan"
Sp(2)
Tog("Auto Kill Boss","Farm selected boss",2,"boss",RED)
Drp("Target",2,{"Any","Gorilla King","Bobby","Yeti","Vice Admiral","Cyborg","Diamond","Beautiful Pirate","Darkbeard","Don Swan","Tide Keeper","leviathan"},"boss",RED)
Sp(2)
Btn("🔍 Scan Bosses",2,RED,function()
    local found={}
    for _,bn in ipairs(BOSSES) do for _,v in ipairs(WS:GetDescendants()) do if v:IsA("Model") and v.Name:lower():find(bn:lower()) then local h=v:FindFirstChildOfClass("Humanoid") if h and h.Health>0 then table.insert(found,v.Name.." ("..math.floor(h.Health).."hp)") end end end end
    bI.Text=#found>0 and table.concat(found," | ") or "None found"
    Ntf(#found>0 and "👹 Boss!" or "Scan",#found>0 and table.concat(found,"\n") or "No bosses in server")
end)
Btn("⚡ TP to Boss",2,RED,function()
    local tg=Sel.boss or "Any"
    for _,v in ipairs(WS:GetDescendants()) do
        if v:IsA("Model") then local match=tg=="Any" or v.Name:lower():find(tg:lower()) if match then local h=v:FindFirstChildOfClass("Humanoid") local m=v:FindFirstChild("HumanoidRootPart") if h and h.Health>0 and m then TP(m.Position) Ntf("TP","→ "..v.Name) return end end end
    end
    Ntf("Boss","No boss found! Scan first.")
end)

-- TAB 3: ISLANDS
Sec("Scanner",3,BLUE)
Tog("Auto Scan","Hop servers for Mirage/Kitsune",3,"scan",BLUE)
Btn("🔍 Check Server",3,BLUE,function() local i=DetIsland() if i then Ntf("✅ Found!",i.emoji.." "..i.name) else Ntf("Vortex","No island here") end end)
Btn("🚀 Server Hop",3,PUR,function() Try(function() TeleServ:Teleport(game.PlaceId,plr) end) end)
Btn("🔗 Copy Link",3,PINK,function() local l="roblox://experiences/start?placeId="..game.PlaceId.."&gameInstanceId="..game.JobId Try(function() setclipboard(l) end) Ntf("✅ Copied!","Paste in Chrome!") end)
Sp(3) Sec("Status",3)
local iSt=Inf("Status",3,BLUE)     iSt.Text="Idle"
local iFo=Inf("Last Found",3,BLUE) iFo.Text="None"
local iSc=Inf("Scanned",3)         iSc.Text="0"

-- TAB 4: STATS
Sec("Select Stat",4,GRN)
Tog("Melee",nil,4,"mel",GRN) Tog("Defense",nil,4,"def",GRN)
Tog("Sword",nil,4,"swd",GRN) Tog("Gun",nil,4,"gun",GRN)
Tog("Devil Fruit",nil,4,"frt",GRN)
Sp(4) Sec("Add Points",4,GRN)
local function GSS() if T.mel then return "Melee" elseif T.def then return "Defense" elseif T.swd then return "Sword" elseif T.gun then return "Gun" elseif T.frt then return "Fruit" end end
local function AddSt(a) local s=GSS() if not s then Ntf("Stats","Toggle a stat!") return end task.spawn(function() for i=1,a do Fire("UpgradeStat",s) Fire("Stats",s) task.wait(0.05) end Ntf("Stats","+"..a.." "..s) end) end
Btn("➕ +1",4,GRN,function() AddSt(1) end)
Btn("➕ +10",4,BLUE,function() AddSt(10) end)
Btn("➕ +50",4,PUR,function() AddSt(50) end)
Btn("➕ +100",4,PINK,function() AddSt(100) end)

-- TAB 5: TELEPORT
Sec("Islands by Sea",5,GOLD)
local seaLbl=Inf("Sea / Level",5,GOLD)
local IBtns={}
for sea=1,3 do
    for _,isl in ipairs(ISLANDS[sea]) do
        local pos=isl.p local nm=isl.n local lv=isl.lv local s=sea
        local b=Btn("📍 "..nm.." [Lv"..lv.."]",5,GOLD,function() TP(pos,nm) Ntf("TP","→ "..nm) end)
        table.insert(IBtns,{f=b.Parent,sea=s})
    end
end
local function RefISL() local sea=GetSea() local lv=GetLv() seaLbl.Text="Sea "..sea.." | Lv "..lv for _,d in ipairs(IBtns) do d.f.Visible=(CT==5) and (d.sea==sea) end end

-- TAB 6: PLAYER
Sec("Mods",6,PUR)
Tog("Invincibility","Always full HP",6,"inv",GRN)
Tog("Speed x2","Double walk speed",6,"spd",BLUE)
Tog("Infinite Jump","Jump mid-air",6,"jump",GOLD)
Tog("No Clip","Walk through walls",6,"clip",PINK)
Tog("Walk on Water","Don't sink in ocean",6,"water",BLUE)
Sp(6) Sec("Fly",6,BLUE)
Btn("🕊️ Fly Up (150)",6,BLUE,function() FlyOn(150) Ntf("Vortex","Flying!") end)
Btn("🛬 Land / Stop",6,GRY,function() FlyOff() T.fly=false Ntf("Vortex","Landed!") end)
Sp(6) Sec("Server",6,PUR)
Btn("🔗 Copy Link",6,PUR,function() local l="roblox://experiences/start?placeId="..game.PlaceId.."&gameInstanceId="..game.JobId Try(function() setclipboard(l) end) Ntf("✅","Paste in Chrome!") end)
Btn("🔄 Rejoin",6,GRY,function() Try(function() TeleServ:Teleport(game.PlaceId,plr) end) end)

-- TAB 7: VISUAL
Sec("Visual",7,Color3.fromRGB(200,140,255))
Tog("Player ESP","Show names above heads",7,"esp",PINK)
Tog("Fruit ESP","Show dropped fruits + TP",7,"fesp",GOLD)
Tog("Full Bright","Remove all darkness",7,"bright",GOLD)

-- TAB 8: INFO
Sec("Player",8)
local iN=Inf("Username",8)          iN.Text=plr.Name
local iL=Inf("Level",8,GOLD)
local iS=Inf("Sea",8,PUR)
local iH=Inf("HP",8,GRN)
local iB=Inf("Beli",8,GOLD)
local iBst=Inf("Best Island",8,PINK)
Sp(8) Sec("Server",8)
local iPC=Inf("Players",8)
local iPl=Inf("Place ID",8)          iPl.Text=tostring(game.PlaceId)

-- ═══════════════════════════
-- TAB SWITCHING
-- ═══════════════════════════
local function SwTab(i)
    CT=i
    for j,d in ipairs(TBTN) do
        local on=j==i
        Tw(d.f,{BackgroundColor3=on and BG3 or SIDE})
        d.nm.TextColor3=on and d.d.nc or DRK
        d.ac.Visible=on
    end
    for _,it in ipairs(ITS) do it.f.Visible=it.t==i end
    if i==5 then RefISL() end
    SC.CanvasPosition=Vector2.new(0,0)
end
for i,d in ipairs(TBTN) do d.b.MouseButton1Click:Connect(function() SwTab(i) end) end
SwTab(1)

-- ═══════════════════════════
-- OPEN / CLOSE
-- ═══════════════════════════
local function Open()
    isOpen=true Panel.Visible=true Panel.BackgroundTransparency=1
    Panel.Size=UDim2.new(0,0,0,0) Panel.Position=UDim2.new(0.5,0,0.5,0)
    Tw(Panel,{Size=UDim2.new(0,500,0,370),Position=UDim2.new(0.5,-250,0.5,-185),BackgroundTransparency=0},0.3)
end
local function Close()
    isOpen=false
    Tw(Panel,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0),BackgroundTransparency=1},0.2)
    task.spawn(function() task.wait(0.25) Panel.Visible=false end)
end
VBtn.MouseButton1Click:Connect(function() if isOpen then Close() else Open() end end)
MinB.MouseButton1Click:Connect(function() Close() end)
XB.MouseButton1Click:Connect(function() Close() task.spawn(function() task.wait(0.25) SG:Destroy() end) end)

-- ═══════════════════════════
-- GAME LOOPS
-- ═══════════════════════════
task.spawn(function()
    while SG.Parent do
        Try(function()
            iL.Text=tostring(GetLv()) iS.Text="Sea "..GetSea()
            local ls=plr:FindFirstChild("leaderstats") if ls then local b=ls:FindFirstChild("Beli") or ls:FindFirstChild("Beri") if b then iB.Text=tostring(b.Value) end end
            local h=Hum() if h then iH.Text=math.floor(h.Health).."/"..math.floor(h.MaxHealth) end
            iPC.Text=#Players:GetPlayers().."/"..Players.MaxPlayers
            local best=GetBest() iBst.Text=best.n.." (Lv"..best.lv..")"
        end)
        task.wait(2)
    end
end)

task.spawn(function() while SG.Parent do if CT==5 then Try(RefISL) end task.wait(3) end end)

RunService.Heartbeat:Connect(function()
    Try(function()
        if T.inv then local h=Hum() if h then h.Health=h.MaxHealth end end
        local h=Hum() if h then h.WalkSpeed=T.spd and 50 or 24 if T.jump then h.JumpPower=120 end end
        if T.clip then local c=Char() if c then for _,pt in ipairs(c:GetDescendants()) do if pt:IsA("BasePart") then pt.CanCollide=false end end end end
        if T.bright then Lighting.Brightness=2 Lighting.ClockTime=14 end
        if FO and FBV and FBV.Parent then FBV.Velocity=Vector3.new(0,0,0) end
    end)
end)

UIS.JumpRequest:Connect(function()
    if T.jump then Try(function() local h=Hum() if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end) end
end)

local EB={} RunService.Heartbeat:Connect(function() Try(function()
    if T.esp then
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=plr and p.Character and not EB[p.Name] then
                local r=p.Character:FindFirstChild("HumanoidRootPart")
                if r then local bb=Instance.new("BillboardGui",r) bb.Size=UDim2.new(0,90,0,24) bb.AlwaysOnTop=true local tl=Instance.new("TextLabel",bb) tl.Size=UDim2.new(1,0,1,0) tl.BackgroundTransparency=1 tl.Text=p.Name tl.TextColor3=PINK tl.TextSize=12 tl.Font=Enum.Font.GothamBold EB[p.Name]=bb end
            end
        end
    else for k,bb in pairs(EB) do Try(function() bb:Destroy() end) EB[k]=nil end end
end) end)

local FB={} RunService.Heartbeat:Connect(function() Try(function()
    if T.fesp then
        for _,v in ipairs(WS:GetDescendants()) do
            if v:IsA("Model") and not FB[v] then
                local n=v.Name:lower()
                if n:find("fruit") or n:find("mera") or n:find("hie") then
                    local pt=v:FindFirstChild("Handle") or v:FindFirstChildOfClass("BasePart")
                    if pt then
                        local bb=Instance.new("BillboardGui",pt) bb.Size=UDim2.new(0,110,0,44) bb.AlwaysOnTop=true
                        local tl=Instance.new("TextLabel",bb) tl.Size=UDim2.new(1,0,0,22) tl.BackgroundTransparency=1 tl.Text="🍎 "..v.Name tl.TextColor3=GOLD tl.TextSize=11 tl.Font=Enum.Font.GothamBold
                        local tb=Instance.new("TextButton",bb) tb.Size=UDim2.new(0.5,0,0,18) tb.Position=UDim2.new(0.25,0,0,24) tb.BackgroundColor3=BG tb.Text="TP" tb.TextColor3=PUR tb.TextSize=10 tb.Font=Enum.Font.GothamBold tb.BorderSizePixel=0 Instance.new("UICorner",tb).CornerRadius=UDim.new(0,5)
                        tb.MouseButton1Click:Connect(function() local r=Root() if r then Fire("FruitPickup",v) r.CFrame=CFrame.new(pt.Position+Vector3.new(0,4,0)) end end)
                        FB[v]=bb
                    end
                end
            end
        end
    else for k,bb in pairs(FB) do Try(function() bb:Destroy() end) FB[k]=nil end end
end) end)

-- Farm loop
local QCD=0
task.spawn(function()
    while SG.Parent do
        if T.farm then
            Try(function()
                local c=Char() local r=Root() local h=Hum()
                if not c or not r or not h then return end
                if T.fly and not FO then FlyOn(150) end
                if not T.fly and FO then FlyOff() end
                if T.quest and os.time()>QCD then
                    for _,v in ipairs(WS:GetDescendants()) do
                        if v:IsA("Model") and v.Name:lower():find("quest") then
                            local npc=v:FindFirstChild("HumanoidRootPart")
                            if npc then
                                for i=1,5 do r.CFrame=CFrame.new(npc.Position+Vector3.new(0,0,4)) task.wait(0.05) end
                                task.wait(0.4) Fire("AcceptQuest",v.Name)
                                local cd=v:FindFirstChildOfClass("ClickDetector",true) if cd then Try(function() fireClickDetector(cd) end) end
                                sQ.Text=v.Name QCD=os.time()+25 break
                            end
                        end
                    end
                end
                if T.prog then
                    local best=GetBest() local dist=(r.Position-best.p).Magnitude
                    if dist>300 then sI.Text="→"..best.n TP(best.p,best.n) else sI.Text=best.n end
                end
                local enemy,dist=FindEnemy()
                if enemy then
                    local m=enemy:FindFirstChild("HumanoidRootPart")
                    if m then
                        sF.Text="⚔️ "..enemy.Name sF.TextColor3=PINK sT.Text=math.floor(dist).." studs"
                        TS:Create(r,TweenInfo.new(0.08,Enum.EasingStyle.Linear),{CFrame=CFrame.new(m.Position+Vector3.new(0,FO and 2 or 0.5,0))}):Play()
                        task.wait(0.08) Attack(enemy)
                    end
                else sF.Text="🔍 Searching" sF.TextColor3=GRY sT.Text="None" end
            end)
            local sp=Sel.spd task.wait(sp=="Very Fast" and 0.08 or sp=="Fast" and 0.18 or 0.4)
        else
            if FO and not T.fly then FlyOff() end
            sF.Text="Inactive" sF.TextColor3=DRK sT.Text="None" sQ.Text="None"
            task.wait(0.4)
        end
    end
end)

task.spawn(function()
    while SG.Parent do
        if T.boss then
            Try(function()
                local r=Root() if not r then return end
                local tg=Sel.boss or "Any"
                for _,v in ipairs(WS:GetDescendants()) do
                    if v:IsA("Model") then
                        local match=tg=="Any" or v.Name:lower():find(tg:lower())
                        if match then local h=v:FindFirstChildOfClass("Humanoid") local m=v:FindFirstChild("HumanoidRootPart") if h and h.Health>0 and m then TS:Create(r,TweenInfo.new(0.08,Enum.EasingStyle.Linear),{CFrame=CFrame.new(m.Position+Vector3.new(0,1,0))}):Play() task.wait(0.08) Attack(v) break end end
                    end
                end
            end)
            task.wait(0.3)
        else task.wait(0.5) end
    end
end)

task.spawn(function()
    while SG.Parent do
        if T.chest then
            Try(function()
                local r=Root() if not r then return end
                local cf=WS:FindFirstChild("Chests")
                for _,v in ipairs(cf and cf:GetChildren() or WS:GetDescendants()) do
                    if v.Name:lower():find("chest") then
                        local pos=v:IsA("BasePart") and v.Position or (v:IsA("Model") and v:GetPivot().Position)
                        if pos and (r.Position-pos).Magnitude<400 then
                            for i=1,5 do r.CFrame=CFrame.new(pos+Vector3.new(0,3,0)) task.wait(0.05) end
                            task.wait(0.3) Fire("CollectChest",v) Fire("CollectRareChest",v)
                            for _,cd in ipairs(v:GetDescendants()) do
                                if cd:IsA("ClickDetector") then Try(function() fireClickDetector(cd) end) end
                                if cd:IsA("ProximityPrompt") then Try(function() fireproximityprompt(cd) end) end
                            end
                        end
                    end
                end
            end)
            task.wait(4)
        else task.wait(0.5) end
    end
end)

local SN=0 local NK={}
task.spawn(function()
    while SG.Parent do
        if T.scan then
            Try(function()
                SN=SN+1 iSc.Text=tostring(SN) iSt.Text="🔭 #"..SN iSt.TextColor3=BLUE
                local found=DetIsland()
                if found then
                    local link="roblox://experiences/start?placeId="..game.PlaceId.."&gameInstanceId="..game.JobId
                    local key=game.JobId..found.name
                    if not NK[key] then
                        NK[key]=true iFo.Text=found.emoji.." "..found.name iSt.Text="✅ "..found.name iSt.TextColor3=GRN
                        Ntf("🌊 Island!",found.name.." found!")
                        Try(function() setclipboard(link) end)
                        Try(function() request({Url=WH,Method="POST",Headers={["Content-Type"]="application/json"},Body=Http:JSONEncode({username="⚡ Vortex Hub",embeds={{title=found.emoji.." "..found.name,description="**Found:** "..found.name.."\n**Join:** "..link,color=found.hex,footer={text="Vortex Hub V1"}}}})}) end)
                    end
                    task.wait(10)
                else
                    iSt.Text="❌ Hopping" iSt.TextColor3=RED
                    task.wait(3) Try(function() TeleServ:Teleport(game.PlaceId,plr) end) task.wait(8)
                end
            end)
        else iSt.Text="Idle" iSt.TextColor3=GRY task.wait(0.5) end
    end
end)

Ntf("⚡ Vortex Hub V1","Loaded! Tap V to open 🔥")
print("✅ Vortex Hub V1 loaded!")
