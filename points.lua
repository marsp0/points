function gather_player_chars(player, chars)
    local main = PTS_alt_main_map[player]
    if main then
        table.insert(chars, main)
        for _, v in pairs(PTS_main_alts_map) do
            if v.main == main then
                for _, v in pairs(v.alts) do
                    table.insert(chars, v)
                end 
            end
        end
    else
        table.insert(chars, player)
    end
end

function gather_raid_chars(chars)
    members = GetNumGroupMembers();
    for i=1, members do
        name = GetRaidRosterInfo(i);
        _, realm = UnitName("raid"..i)
        if realm == nil or realm == "" then name = name .. "-" .. GetRealmName() end
        gather_player_chars(name, chars)
    end
end

function apply_points_to_guild(amount, is_percent, reason)
    local timestamp = time()
    local giver_name = UnitName("player")
    for i=1, GetNumGuildMembers() do
        local char_name, _, _, _, cls, _, note, officernote = GetGuildRosterInfo(i);
        local ep = read_points(officernote)
        local new_ep = compute_points(ep, amount, is_percent)
        add_points(i, new_ep)
        add_transaction(timestamp, giver_name, char_name, ep, new_ep, reason)
    end
end

function apply_points_to_group(group, amount, is_percent, reason)
    local timestamp = time()
    local giver_name = UnitName("player")
    for _, name in pairs(group) do
        for i=1, GetNumGuildMembers() do
            local char_name, _, _, _, cls, _, note, officernote = GetGuildRosterInfo(i);
            if name == char_name then
                local ep = read_points(officernote)
                local new_ep = compute_points(ep, amount, is_percent)
                add_points(i, new_ep)
                add_transaction(timestamp, giver_name, char_name, ep, new_ep, reason)
                break
            end
        end
    end
end

function apply_points_change()
    local name = _G["PointsFrameAddRemoveTabName"]:GetText()
    local amount = tonumber(_G["PointsFrameAddRemoveTabAmount"]:GetText())
    local reason = _G["PointsFrameAddRemoveTabReason"]:GetText()
    local is_percent = _G["PointsFrameAddRemoveTabIsPercent"]:GetChecked()

    if amount == nil then PTS_print("Invalid amount"); return end
    if name == "" then PTS_print("Invalid name"); return end
    if reason == "" then PTS_print("Invalid reason"); return end

    amount = math.floor(amount)
    local names = {}
    if name == "Guild" then
        apply_points_to_guild(amount, is_percent, reason)
    elseif name == "Raid" then
        if not IsInRaid() then PTS_print("Not in raid"); return end
        gather_raid_chars(names)
        apply_points_to_group(names, amount, is_percent, reason)
    else
        gather_player_chars(name, names)
        apply_points_to_group(names, amount, is_percent, reason)
    end
    
    local msg = " points added to "
    if (amount < 0) then
        msg = " points taken from "
    end
    local report_points = math.abs(amount)
    if (is_percent) then report_points = report_points .. "%" end
    broadcast_message(report_points .. msg .. name .. " - " .. reason)
end

function points_button_on_click()
    _G["PointsFrameAddRemoveTabAmount"]:SetText("")
    _G["PointsFrameAddRemoveTabReason"]:SetText("")
    _G["PointsFrameAddRemoveTabIsPercent"]:SetChecked(false)
    set_active_tab("PointsFrameAddRemoveTab")
end

function points_name_on_click(self)
    local name = _G[self:GetName() .. "Name"]:GetText()
    _G["PointsFrameAddRemoveTabName"]:SetText(name)
    points_button_on_click()
end