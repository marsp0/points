ccm = {}
ccm["Warrior"] = {r=0.78, g=0.61, b=0.43}
ccm["Rogue"]   = {r=1.0, g=0.96, b=0.41}
ccm["Hunter"]  = {r=0.67, g=0.83, b=0.45}
ccm["Mage"]    = {r=0.25, g=0.78, b=0.92}
ccm["Warlock"] = {r=0.53, g=0.53, b=0.93}
ccm["Paladin"] = {r=0.96, g=0.55, b=0.73}
ccm["Priest"]  = {r=1.0, g=1.0, b=1.0}
ccm["Druid"]   = {r=1.0, g=0.49, b=0.04}

raid_zones_map = {
    [249] = true,
    [409] = true,
    [469] = true,
    [509] = true,
    [531] = true,
    [533] = true,
    [309] = true
}

function set_active_tab(tab_name)
    _G["PointsFrameGuildTab"]:Hide()
    _G["PointsFrameLinksTab"]:Hide()
    _G["PointsFrameAddRemoveTab"]:Hide()
    _G["PointsFrameEditorTab"]:Hide()
    _G["PointsFrameGroupsTab"]:Hide()

    -- clear export frame
    _G["PointsFrameEditorTabScrollText"]:SetText("")

    _G[tab_name]:Show()
end

function in_guild_raid()
    local zoneName, instanceType, _, _, _, _, _, areaID = GetInstanceInfo()
    if instanceType == "raid" and raid_zones_map[areaID] then 
        return true
    end

    return false
end

function am_admn() return UnitName("player") == "Shiah" end

function am_i_lootmaster()
    if not UnitInRaid("player") then return false end

    local lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()
    if lootmethod ~= "master" then return false end
    local master_looter_name = GetRaidRosterInfo(masterlooterRaidID);
    local name, _ = UnitName("player")

    return name == master_looter_name
end

function PTS_print(msg)
    print("Unity Points: " .. msg)
end

function broadcast(msg)
    if true then
        SendChatMessage(msg, "GUILD")
    else
        PTS_print(msg)
    end
end

function compute_points(ep, amount, is_percent)
    local new_ep = ep + amount
    if is_percent then
        amount = amount / 100
        new_ep = ep + amount * ep
    end
    if new_ep < 0 then PTS_print("new ep is less than 0, will set new ep to 0") end
    return math.max(math.ceil(new_ep), 0)
end

function add_points(i, amount)
    -- GuildRosterSetPublicNote(i, amount)
    GuildRosterSetOfficerNote(i, amount)
end

function read_points(note)
    return tonumber(note) or 0
end

function startswith(str, sub)
    return string.sub(str,1,string.len(sub))==sub
end
