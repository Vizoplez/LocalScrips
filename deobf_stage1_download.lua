-- Script Path: game:GetService("Players").Vizoplezz.PlayerScripts.AACExactExploitDetector
-- Took 0.01s to decompile.
-- Executor: Potassium (v2.5.2)

-- Decompiled with Potassium's decompiler.

local Players = game:GetService("Players");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local StarterGui = game:GetService("StarterGui");
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui");
local ExactSignals = ReplicatedStorage:WaitForChild("AntiCheatRemotes", 20):WaitForChild("ExactSignals", 20);

if not ExactSignals then
    return;
end;

local CrazyHubSignature = ExactSignals:WaitForChild("CrazyHubSignature", 20);
local VpHubSignature = ExactSignals:WaitForChild("VpHubSignature", 20);
local Jnkie00144Signature = ExactSignals:WaitForChild("Jnkie00144Signature", 20);

if not (CrazyHubSignature and (VpHubSignature and Jnkie00144Signature)) then
    return;
end;

local u1 = setmetatable({}, {
    __mode = "k"
});
local u2 = {};
local u3 = false;
local u4 = false;
local u5 = false;

for _, child in ipairs(StarterGui:GetChildren()) do
    u2[string.lower(child.Name)] = true;
end;

for _, child in ipairs(PlayerGui:GetChildren()) do
    u1[child] = true;
end;

local u6 = { "auto farm", "auto quest", "auto collect money", "quest cooldown", "npc farm" };
local u7 = { "auto farm", "autofarm", "auto quest", "auto collect", "kill aura", "killaura", "bring mob", "mob farm", "noclip", "no clip", "infinite jump", "speed hack", "aimbot", "teleport", "tp to", "player esp", "esp player", "fly hack" };

local function normalize(p8) -- Line: 60
    return string.lower((tostring(p8 or ""))):gsub("%s+", " ");
end;

local function collectEvidence(p9, p10) -- Line: 64
    local v11 = 0;
    local v12 = {};

    for _, descendant in ipairs(p9:GetDescendants()) do
        if descendant:IsA("GuiButton") then
            v11 = v11 + 1;
        end;

        if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
            local success, result = pcall(function() -- Line: 72
                -- upvalues: descendant (copy)
                return descendant.Text;
            end);
            local v13 = success and string.lower((tostring(result or ""))):gsub("%s+", " ") or "";

            for _, v in ipairs(p10) do
                if not v12[v] and string.find(v13, v, 1, true) then
                    v12[v] = true;
                end;
            end;
        end;
    end;

    local v14 = 0;

    for _ in pairs(v12) do
        v14 = v14 + 1;
    end;

    return v14, v11;
end;

local function inspectCrazyHub(p15) -- Line: 86
    -- upvalues: u3 (ref), collectEvidence (copy), u6 (copy), CrazyHubSignature (copy)
    if u3 or not (p15 and (p15:IsA("ScreenGui") and p15.Name == "CrazyHub")) then
        return;
    end;

    if not p15.Parent then
        return;
    end;

    local v16 = collectEvidence(p15, u6);

    if v16 >= 3 then
        u3 = true;
        CrazyHubSignature:FireServer({
            Gui = "CrazyHub",
            Source = "ZaNYkBaD",
            EvidenceCount = v16
        });
    end;
end;

local function ignoredGui(p17) -- Line: 102
    -- upvalues: u2 (copy), u1 (copy)
    local v18;

    if p17 then
        v18 = p17.Name;
    else
        v18 = p17;
    end;

    local v19 = string.lower((tostring(v18 or ""))):gsub("%s+", " ");

    return (u2[v19] or u1[p17]) and true or ((string.find(v19, "hdadmin", 1, true) or (string.find(v19, "hd admin", 1, true) or string.find(v19, "robloxgui", 1, true))) and true or false);
end;

local function inspectVpHub(p20) -- Line: 116
    -- upvalues: u4 (ref), ignoredGui (copy), collectEvidence (copy), u7 (copy), VpHubSignature (copy)
    if u4 or not (p20 and (p20:IsA("ScreenGui") and (not ignoredGui(p20) and p20.Parent))) then
        return;
    end;

    local v21, v22 = collectEvidence(p20, u7);
    local v23 = string.lower((tostring(p20.Name or ""))):gsub("%s+", " ");

    if string.find(v23, "hub", 1, true) or (v23 == "vp" or string.find(v23, "executor", 1, true)) then
        v21 = v21 + 1;
    end;

    if v21 >= 3 and v22 >= 3 then
        u4 = true;
        VpHubSignature:FireServer({
            Source = "spawngore/Vp",
            Gui = p20.Name,
            EvidenceCount = v21,
            ButtonCount = v22
        });
    end;
end;

local function inspectJnkie00144(p24) -- Line: 141
    -- upvalues: u5 (ref), collectEvidence (copy), u7 (copy), Jnkie00144Signature (copy)
    if u5 or not (p24 and (p24:IsA("ScreenGui") and p24.Parent)) then
        return;
    end;

    local v25 = string.find(string.lower((tostring(p24.Name or ""))):gsub("%s+", " "), "00144d74da70bdcf4ee5e5d7f0d5504133078c575b6b873b09ffca64082efbb6", 1, true) ~= nil;
    local v26 = string.find(string.lower((tostring(p24.Name or ""))):gsub("%s+", " "), "jnkie", 1, true) ~= nil and true or string.find(string.lower((tostring(p24.Name or ""))):gsub("%s+", " "), "junkie", 1, true) ~= nil;

    for _, descendant in ipairs(p24:GetDescendants()) do
        local v27 = string.lower((tostring(descendant.Name or ""))):gsub("%s+", " ");
        v25 = v25 or string.find(v27, "00144d74da70bdcf4ee5e5d7f0d5504133078c575b6b873b09ffca64082efbb6", 1, true) ~= nil;
        v26 = v26 or (string.find(v27, "jnkie", 1, true) ~= nil and true or string.find(v27, "junkie", 1, true) ~= nil);

        if descendant:IsA("TextLabel") or (descendant:IsA("TextButton") or descendant:IsA("TextBox")) then
            local success, result = pcall(function() -- Line: 157
                -- upvalues: descendant (copy)
                return descendant.Text;
            end);
            local v28 = success and string.lower((tostring(result or ""))):gsub("%s+", " ") or "";
            v25 = v25 or string.find(v28, "00144d74da70bdcf4ee5e5d7f0d5504133078c575b6b873b09ffca64082efbb6", 1, true) ~= nil;
            v26 = v26 or (string.find(v28, "jnkie", 1, true) ~= nil and true or string.find(v28, "junkie", 1, true) ~= nil);
        end;
    end;

    local v29, v30 = collectEvidence(p24, u7);
    local v31;

    if v26 then
        if v29 >= 4 then
            v31 = v30 >= 4;
        else
            v31 = false;
        end;
    else
        v31 = v26;
    end;

    if v25 or v31 then
        u5 = true;
        Jnkie00144Signature:FireServer({
            Source = "jnkie/00144",
            Host = "api.jnkie.com",
            ScriptId = "00144d74da70bdcf4ee5e5d7f0d5504133078c575b6b873b09ffca64082efbb6",
            Gui = p24.Name,
            EvidenceCount = v29,
            ButtonCount = v30,
            ExactHash = v25,
            JnkieAnchor = v26
        });
    end;
end;

local function scheduleInspection(p32) -- Line: 183
    -- upvalues: inspectCrazyHub (copy), inspectJnkie00144 (copy), inspectVpHub (copy)
    task.delay(0.35, inspectCrazyHub, p32);
    task.delay(0.45, inspectJnkie00144, p32);
    task.delay(0.8, inspectVpHub, p32);
    task.delay(1.5, inspectJnkie00144, p32);
    task.delay(2.5, inspectVpHub, p32);
    task.delay(3.5, inspectJnkie00144, p32);
    task.delay(5, inspectVpHub, p32);
end;

PlayerGui.ChildAdded:Connect(scheduleInspection);
pcall(function() -- Line: 195
    -- upvalues: u1 (copy), scheduleInspection (copy)
    local CoreGui = game:GetService("CoreGui");

    for _, child in ipairs(CoreGui:GetChildren()) do
        u1[child] = true;
    end;

    CoreGui.ChildAdded:Connect(scheduleInspection);
end);

for _, child in ipairs(PlayerGui:GetChildren()) do
    task.defer(inspectCrazyHub, child);
    task.defer(inspectJnkie00144, child);
end;
