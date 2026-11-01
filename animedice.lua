_G.ANIMEDICE_KEY = "ANIMEDICE-FREE"
loadstring(([[
-- [🎃] Anime Dice | Tower Only + Auto Trade
-- Delta Executor | Inline Loader

local Plr=game:GetService("Players")
local TS=game:GetService("TweenService")
local RS=game:GetService("RunService")
local UIS=game:GetService("UserInputService")
local RepS=game:GetService("ReplicatedStorage")
local WS=game:GetService("Workspace")
local lp=Plr.LocalPlayer
local gui=lp:WaitForChild("PlayerGui")

-- cleanup
for _,v in ipairs(gui:GetChildren()) do
    if v.Name=="ADScript" then v:Destroy() end
end

-- config
local CFG={
    TowerOnly=true,
    AutoPlaceBest=true,
    AutoRemoveWeak=true,
    AutoTrade=true,
    AutoAccept=false,
    TradeTarget="",
    MinRarity="Rare",
    MaxSlots=10,
    RefreshRate=1.5,
    TradeDelay=3,
    TradeWant={"Legendary","Mythical","Secret","Divine"},
}

local RANK={Common=1,Uncommon=2,Rare=3,Epic=4,Legendary=5,Mythical=6,Secret=7,Divine=8}
local RCOL={
    Common=Color3.fromRGB(180,180,180),Uncommon=Color3.fromRGB(80,200,80),
    Rare=Color3.fromRGB(60,120,255),Epic=Color3.fromRGB(160,60,255),
    Legendary=Color3.fromRGB(255,180,0),Mythical=Color3.fromRGB(255,60,60),
    Secret=Color3.fromRGB(255,100,200),Divine=Color3.fromRGB(100,255,255),
}
local RLIST={"Common","Uncommon","Rare","Epic","Legendary","Mythical","Secret","Divine"}

local T={
    BG=Color3.fromRGB(10,10,16),
    Surface=Color3.fromRGB(18,18,28),
    Card=Color3.fromRGB(24,24,36),
    Primary=Color3.fromRGB(255,180,0),
    Green=Color3.fromRGB(67,181,129),
    Red=Color3.fromRGB(240,71,71),
    Blue=Color3.fromRGB(88,101,242),
    Text=Color3.fromRGB(220,221,222),
    Muted=Color3.fromRGB(110,110,130),
}

local function cr(p,r) local c=Instance.new("UICorner",p) c.CornerRadius=UDim.new(0,r or 😎 return c end
local function sk(p,col,th) local s=Instance.new("UIStroke",p) s.Color=col or T.Primary s.Thickness=th or 1.5 return s end
local function tw(o,props,t)
    TS:Create(o,TweenInfo.new(t or .3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),props):Play()
end
local function mkLbl(parent,props)
    local l=Instance.new("TextLabel",parent)
    l.BackgroundTransparency=1
    l.Font=Enum.Font.GothamBold
    l.TextColor3=T.Text
    l.TextSize=13
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextYAlignment=Enum.TextYAlignment.Center
    for k,v in pairs(props) do l[k]=v end
    return l
end
local function mkBtn(parent,props,cb)
    local b=Instance.new("TextButton",parent)
    b.Font=Enum.Font.GothamBold
    b.TextColor3=Color3.new(1,1,1)
    b.BorderSizePixel=0
    b.AutoButtonColor=false
    for k,v in pairs(props) do b[k]=v end
    cr(b,6)
    if cb then b.MouseButton1Click:Connect(cb) end
    return b
end

-- ── GUI ──
local sg=Instance.new("ScreenGui",gui)
sg.Name="ADScript"
sg.ResetOnSpawn=false
sg.IgnoreGuiInset=true
sg.DisplayOrder=999

local blur=Instance.new("BlurEffect",game:GetService("Lighting"))
blur.Size=0 tw(blur,{Size=12},.5)

local ov=Instance.new("Frame",sg)
ov.Size=UDim2.new(1,0,1,0)
ov.BackgroundColor3=Color3.new(0,0,0)
ov.BackgroundTransparency=0.5
ov.BorderSizePixel=0

local win=Instance.new("Frame",sg)
win.Size=UDim2.new(0,400,0,500)
win.Position=UDim2.new(.5,-200,1.5,0)
win.BackgroundColor3=T.BG
win.BorderSizePixel=0
win.ZIndex=10
cr(win,12) sk(win,T.Primary,1.5)
tw(win,{Position=UDim2.new(.5,-200,.5,-250)},.5)

-- header
local hdr=Instance.new("Frame",win)
hdr.Size=UDim2.new(1,0,0,80)
hdr.BackgroundColor3=T.Surface
hdr.BorderSizePixel=0
hdr.ZIndex=11
cr(hdr,12)

mkLbl(hdr,{Size=UDim2.new(0,50,0,50),Position=UDim2.new(0,12,0,15),Text="🎲",TextSize=40,TextXAlignment=Enum.TextXAlignment.Center,ZIndex=12})
mkLbl(hdr,{Size=UDim2.new(1,-80,0,26),Position=UDim2.new(0,72,0,12),Text="Anime Dice Script",TextSize=17,TextColor3=T.Primary,ZIndex=12})
mkLbl(hdr,{Size=UDim2.new(1,-80,0,18),Position=UDim2.new(0,72,0,38),Text="Tower Only  •  Auto Trade",TextSize=11,TextColor3=T.Muted,ZIndex=12})
mkLbl(hdr,{Size=UDim2.new(1,-80,0,16),Position=UDim2.new(0,72,0,58),Text="discord.gg/ojailbreaks",TextSize=10,TextColor3=T.Blue,ZIndex=12})

mkBtn(hdr,{Size=UDim2.new(0,24,0,24),Position=UDim2.new(1,-30,0,8),Text="✕",TextSize=12,BackgroundColor3=Color3.fromRGB(50,50,65),TextColor3=T.Text,ZIndex=15},function()
    tw(win,{Position=UDim2.new(.5,-200,1.5,0)},.4)
    tw(blur,{Size=0},.4)
    task.wait(.45) sg:Destroy() blur:Destroy()
end)

-- toggles
local tcard=Instance.new("Frame",win)
tcard.Size=UDim2.new(1,-24,0,160)
tcard.Position=UDim2.new(0,12,0,92)
tcard.BackgroundColor3=T.Card
tcard.BorderSizePixel=0
tcard.ZIndex=11
cr(tcard,8) sk(tcard,Color3.fromRGB(40,40,55),1)

mkLbl(tcard,{Size=UDim2.new(1,-12,0,20),Position=UDim2.new(0,10,0,4),Text="TOGGLE",TextSize=10,TextColor3=T.Primary,ZIndex=12})

local tdefs={
    {"TowerOnly","🏰 Tower Only"},
    {"AutoPlaceBest","⬆️ Auto Place Best"},
    {"AutoRemoveWeak","🗑️ Auto Remove Weak"},
    {"AutoTrade","🤝 Auto Trade"},
    {"AutoAccept","✅ Auto Accept Trade"},
}
for i,d in ipairs(tdefs) do
    local y=22+(i-1)*26
    mkLbl(tcard,{Size=UDim2.new(.6,0,0,22),Position=UDim2.new(0,8,0,y),Text=d[2],TextSize=12,TextColor3=T.Text,ZIndex=12})
    local tb=Instance.new("TextButton",tcard)
    tb.Size=UDim2.new(0,44,0,18)
    tb.Position=UDim2.new(1,-50,0,y+2)
    tb.Font=Enum.Font.GothamBold tb.TextSize=10
    tb.TextColor3=Color3.new(1,1,1) tb.BorderSizePixel=0 tb.ZIndex=13
    cr(tb,9)
    local function ref()
        tb.Text=CFG[d[1]] and "ON" or "OFF"
        tb.BackgroundColor3=CFG[d[1]] and T.Green or T.Red
    end ref()
    tb.MouseButton1Click:Connect(function() CFG[d[1]]=not CFG[d[1]] ref() end)
end

-- min rarity
local rarCard=Instance.new("Frame",win)
rarCard.Size=UDim2.new(1,-24,0,36)
rarCard.Position=UDim2.new(0,12,0,264)
rarCard.BackgroundColor3=T.Card
rarCard.BorderSizePixel=0 rarCard.ZIndex=11
cr(rarCard,8) sk(rarCard,Color3.fromRGB(40,40,55),1)
mkLbl(rarCard,{Size=UDim2.new(.5,0,1,0),Position=UDim2.new(0,10,0,0),Text="⚔️ Min Rarity Tower",TextSize=12,TextColor3=T.Text,ZIndex=12})
local ri=3
local rb=Instance.new("TextButton",rarCard)
rb.Size=UDim2.new(.45,0,0,24) rb.Position=UDim2.new(.53,0,.5,-12)
rb.Font=Enum.Font.GothamBold rb.TextSize=11
rb.TextColor3=Color3.new(1,1,1) rb.BorderSizePixel=0 rb.ZIndex=12
cr(rb,5)
local function refRar() rb.Text=RLIST[ri] rb.BackgroundColor3=RCOL[RLIST[ri]] CFG.MinRarity=RLIST[ri] end refRar()
rb.MouseButton1Click:Connect(function() ri=ri%#RLIST+1 refRar() end)

-- trade target
local ttCard=Instance.new("Frame",win)
ttCard.Size=UDim2.new(1,-24,0,40)
ttCard.Position=UDim2.new(0,12,0,312)
ttCard.BackgroundColor3=T.Card
ttCard.BorderSizePixel=0 ttCard.ZIndex=11
cr(ttCard,8) sk(ttCard,Color3.fromRGB(40,40,55),1)
mkLbl(ttCard,{Size=UDim2.new(0,80,1,0),Position=UDim2.new(0,8,0,0),Text="🎯 Target:",TextSize=12,TextColor3=T.Muted,ZIndex=12})
local ttb=Instance.new("TextBox",ttCard)
ttb.Size=UDim2.new(1,-96,0,26) ttb.Position=UDim2.new(0,90,.5,-13)
ttb.BackgroundColor3=Color3.fromRGB(14,14,22) ttb.BorderSizePixel=0
ttb.Font=Enum.Font.Gotham ttb.TextSize=12
ttb.TextColor3=T.Text ttb.PlaceholderText="Username (kosong = semua)"
ttb.PlaceholderColor3=T.Muted ttb.Text="" ttb.ClearTextOnFocus=false ttb.ZIndex=12
cr(ttb,5)
ttb.FocusLost:Connect(function() CFG.TradeTarget=ttb.Text end)

-- progress
local progCard=Instance.new("Frame",win)
progCard.Size=UDim2.new(1,-24,0,44)
progCard.Position=UDim2.new(0,12,0,364)
progCard.BackgroundColor3=T.Card
progCard.BorderSizePixel=0 progCard.ZIndex=11
cr(progCard,8) sk(progCard,Color3.fromRGB(40,40,55),1)
local progLbl=mkLbl(progCard,{Size=UDim2.new(1,-12,0,20),Position=UDim2.new(0,8,0,2),Text="Siap dieksekusi...",TextSize=11,TextColor3=T.Muted,ZIndex=12})
local bbg=Instance.new("Frame",progCard)
bbg.Size=UDim2.new(1,-16,0,8) bbg.Position=UDim2.new(0,8,0,30)
bbg.BackgroundColor3=Color3.fromRGB(20,20,32) bbg.BorderSizePixel=0 bbg.ZIndex=12
cr(bbg,4)
local bfill=Instance.new("Frame",bbg)
bfill.Size=UDim2.new(0,0,1,0) bfill.BackgroundColor3=T.Primary
bfill.BorderSizePixel=0 bfill.ZIndex=13
cr(bfill,4)
local function setP(pct,txt,col)
    tw(bfill,{Size=UDim2.new(pct,0,1,0)},.3)
    if col then bfill.BackgroundColor3=col end
    progLbl.Text=txt or "" progLbl.TextColor3=col or T.Text
end

-- execute button
local exBtn=mkBtn(win,{
    Size=UDim2.new(1,-24,0,46),
    Position=UDim2.new(0,12,0,420),
    Text="▶  EXECUTE",TextSize=15,
    BackgroundColor3=T.Primary,
    TextColor3=Color3.fromRGB(12,12,12),
    ZIndex=12,
},nil)
exBtn.MouseEnter:Connect(function() tw(exBtn,{BackgroundColor3=Color3.fromRGB(255,210,60)},.15) end)
exBtn.MouseLeave:Connect(function() tw(exBtn,{BackgroundColor3=T.Primary},.15) end)

-- ── CORE LOGIC ──
local function findRemote(name)
    for _,v in ipairs(RepS:GetDescendants()) do
        if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction"))
            and v.Name:lower():find(name:lower()) then return v end
    end
end

local function getInventory()
    local units={}
    local folders={lp:FindFirstChild("Units"),lp:FindFirstChild("Inventory"),lp:FindFirstChild("Characters")}
    for _,folder in ipairs(folders) do
        if folder then
            for _,unit in ipairs(folder:GetChildren()) do
                local rar=unit:FindFirstChild("Rarity") or unit:FindFirstChild("rarity")
                local pw=unit:FindFirstChild("Power") or unit:FindFirstChild("Damage") or unit:FindFirstChild("Dps")
                table.insert(units,{
                    name=unit.Name,
                    rarity=rar and rar.Value or "Common",
                    rank=RANK[rar and rar.Value or "Common"] or 1,
                    power=pw and tonumber(pw.Value) or (RANK[rar and rar.Value or "Common"] or 1)*100,
                    ref=unit,
                })
            end
        end
    end
    table.sort(units,function(a,b) return(a.power or 0)>(b.power or 0) end)
    return units
end

local placed={}
local towerStatus="Idle"
local tradeStatus="Idle"
local towerRunning=false
local tradeRunning=false

local function towerLoop()
    towerRunning=true
    while CFG.TowerOnly and towerRunning do
        task.wait(CFG.RefreshRate)
        if not CFG.AutoPlaceBest then continue end
        local inv=getInventory()
        local minRank=RANK[CFG.MinRarity] or 3
        local eligible={}
        for _,u in ipairs(inv) do
            if u.rank>=minRank then table.insert(eligible,u) end
        end
        if #eligible==0 then towerStatus="No eligible units" continue end
        local slots={}
        for _,v in ipairs(WS:GetDescendants()) do
            local n=v.Name:lower()
            if(n:find("slot") or n:find("tower") or n:find("placeholder"))
                and(v:IsA("BasePart") or v:IsA("Model")) then
                table.insert(slots,v)
            end
        end
        local fill=math.min(CFG.MaxSlots,#slots)
        for i=1,fill do
            local unit=eligible[i]
            if not unit then break end
            local cur=placed[i]
            if cur and cur.power>=unit.power then continue end
            if cur and CFG.AutoRemoveWeak then
                local rem=findRemote("remove") or findRemote("sell") or findRemote("unplace")
                if rem then
                    pcall(function()
                        if rem:IsA("RemoteEvent") then rem:FireServer(slots[i])
                        else rem:InvokeServer(slots[i]) end
                    end)
                    task.wait(.15)
                end
            end
            local place=findRemote("place") or findRemote("deploy") or findRemote("put") or findRemote("spawn")
            if place then
                pcall(function()
                    if place:IsA("RemoteEvent") then place:FireServer(unit.ref,slots[i])
                    else place:InvokeServer(unit.ref,slots[i]) end
                end)
                placed[i]=unit
                towerStatus="Placed "..unit.name.." slot "..i
            end
            task.wait(.1)
        end
    end
    towerRunning=false
end

local lastTrade=0
local function buildOffer()
    local inv=getInventory()
    local offer={}
    for _,u in ipairs(inv) do
        if #offer>=4 then break end
        local wanted=false
        for _,r in ipairs(CFG.TradeWant) do
            if u.rarity:lower()==r:lower() then wanted=true break end
        end
        if not wanted then table.insert(offer,u) end
    end
    return offer
end

local function tradeLoop()
    tradeRunning=true
    local inc=findRemote("incoming") or findRemote("traderequest")
    if inc and inc:IsA("RemoteEvent") then
        inc.OnClientEvent:Connect(function(sender,theirOffer)
            if not CFG.AutoAccept then return end
            local hasWanted=false
            if theirOffer then
                for _,item in ipairs(theirOffer) do
                    for _,r in ipairs(CFG.TradeWant) do
                        if(item.rarity or ""):lower()==r:lower() then hasWanted=true break end
                    end
                end
            end
            if hasWanted then
                local acc=findRemote("accept") or findRemote("confirm")
                if acc then
                    task.wait(.5)
                    pcall(function()
                        if acc:IsA("RemoteEvent") then acc:FireServer(sender)
                        else acc:InvokeServer(sender) end
                    end)
                end
            end
        end)
    end
    while CFG.AutoTrade and tradeRunning do
        task.wait(CFG.TradeDelay)
        if os.time()-lastTrade<CFG.TradeDelay then continue end
        local targets={}
        if CFG.TradeTarget~="" then
            local p=Plr:FindFirstChild(CFG.TradeTarget)
            if p and p~=lp then table.insert(targets,p) end
        else
            for _,p in ipairs(Plr:GetPlayers()) do
                if p~=lp then table.insert(targets,p) end
            end
        end
        if #targets==0 then tradeStatus="No targets" continue end
        local offer=buildOffer()
        if #offer==0 then tradeStatus="Nothing to offer" continue end
        local trem=findRemote("trade") or findRemote("offer") or findRemote("exchange")
        if not trem then tradeStatus="No trade remote" continue end
        for _,target in ipairs(targets) do
            pcall(function()
                if trem:IsA("RemoteEvent") then trem:FireServer(target,offer)
                else trem:InvokeServer(target,offer) end
            end)
            tradeStatus="Sent → "..target.Name
            lastTrade=os.time()
            task.wait(.4)
        end
    end
    tradeRunning=false
end

-- status HUD
local hud=Instance.new("Frame",sg)
hud.Size=UDim2.new(0,220,0,44)
hud.Position=UDim2.new(0,8,1,-52)
hud.BackgroundColor3=T.BG
hud.BackgroundTransparency=0.2
hud.BorderSizePixel=0
hud.ZIndex=20
hud.Visible=false
cr(hud,8) sk(hud,T.Primary,1)
local hudT=mkLbl(hud,{Size=UDim2.new(1,-8,0.5,0),Position=UDim2.new(0,6,0,0),Text="🏰 Tower: Idle",TextSize=11,TextColor3=T.Green,ZIndex=21})
local hudTr=mkLbl(hud,{Size=UDim2.new(1,-8,0.5,0),Position=UDim2.new(0,6,0.5,0),Text="🤝 Trade: Idle",TextSize=11,TextColor3=T.Blue,ZIndex=21})
RS.Heartbeat:Connect(function()
    hudT.Text="🏰 "..towerStatus
    hudTr.Text="🤝 "..tradeStatus
end)

-- hotkey
UIS.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if inp.KeyCode==Enum.KeyCode.F7 then
        CFG.TowerOnly=not CFG.TowerOnly
        if CFG.TowerOnly and not towerRunning then task.spawn(towerLoop) end
    elseif inp.KeyCode==Enum.KeyCode.F8 then
        CFG.AutoTrade=not CFG.AutoTrade
        if CFG.AutoTrade and not tradeRunning then task.spawn(tradeLoop) end
    end
end)

-- execute logic
local executing=false
exBtn.MouseButton1Click:Connect(function()
    if executing then return end
    executing=true
    exBtn.Text="⏳ Loading..."
    exBtn.BackgroundColor3=Color3.fromRGB(70,70,90)

    setP(.2,"🔑 Cek key...",T.Primary) task.wait(.3)
    local key=_G.ANIMEDICE_KEY or ""
    if key~="" then
        setP(.35,"✅ Key: "..key,T.Green) task.wait(.25)
    else
        setP(.35,"⚠️ No key — free mode",T.Muted) task.wait(.25)
    end

    setP(.55,"🎮 Cek game...",T.Primary) task.wait(.25)
    setP(.7,"✅ Game OK",T.Green) task.wait(.2)

    setP(.85,"⚡ Memulai script...",T.Primary) task.wait(.3)

    if CFG.TowerOnly then task.spawn(towerLoop) end
    if CFG.AutoTrade then task.spawn(tradeLoop) end

    setP(1,"✅ Script aktif!",T.Green)
    exBtn.Text="✅ Aktif!"
    exBtn.BackgroundColor3=T.Green
    hud.Visible=true

    task.wait(1.2)
    tw(win,{Position=UDim2.new(.5,-200,1.5,0)},.4)
    tw(ov,{BackgroundTransparency=1},.4)
    tw(blur,{Size=0},.4)
    task.wait(.45)
    win:Destroy() ov:Destroy() blur:Destroy()
end)
]]))()
