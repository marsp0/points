PTS_rewards = {
    -- mol
    [663] = { 3, "Lucifron" },
    [664] = { 3, "Magmadar" },
    [665] = { 3, "Gehennas" },
    [666] = { 3, "Garr" },
    [667] = { 3, "Shazzrah" },
    [668] = { 3, "Baron Geddon" },
    [669] = { 3, "Sulfuron Harbinger" },
    [670] = { 3, "Golemagg the Incinerator"},
    [671] = { 8, "Majordomo Executus" },
    [672] = { 8, "Ragnaros" },
    -- bwl
    [610] = { 7, "Razorgore the Untamed" },
    [611] = { 7, "Vaelastrasz the Corrupt" },
    [612] = { 7, "Broodlord Lashlayer" },
    [613] = { 7, "Firemaw" },
    [614] = { 7, "Ebonroc" },
    [615] = { 7, "Flamegor" },
    [616] = { 7, "Chromaggus" },
    [617] = { 10, "Nefarian" },
    -- aq40
    [709] = { 10, "The Prophet Skeram" },
    [710] = { 10, "The Silithid Royalty" },
    [711] = { 10, "Battleguard Sartura" },
    [712] = { 10, "Fankriss the Unyielding" },
    [713] = { 10, "Viscidus" },
    [714] = { 10, "Princess Huhuran" },
    [715] = { 10, "The Twin Emperors" },
    [716] = { 10, "Ouro" },
    [717] = { 12, "C'Thun" },
    -- naxx
    [1107] = { 13, "Anub'Rekhan" },
    [1110] = { 13, "Grand Widow Faerlina" },
    [1116] = { 13, "Maexxna" },
    [1117] = { 13, "Noth the Plaguebringer" },
    [1112] = { 13, "Heigan the Unclean" },
    [1115] = { 13, "Loatheb" },
    [1113] = { 13, "Instructor Razuvious" },
    [1109] = { 13, "Gothik the Harvester" },
    [1121] = { 13, "The Four Horsemen" },
    [1118] = { 13, "Patchwerk" },
    [1111] = { 13, "Grobbulus" },
    [1108] = { 13, "Gluth" },
    [1120] = { 13, "Thaddius" },
    [1119] = { 15, "Sapphiron" },
    [1114] = { 16, "Kel'Thuzad" }
}

local auto_award_name = ""
local auto_award_amount = 0
local auto_award_reason = ""
local dialog_template = "Deduct %s points from %s for %s ?"

function get_name_with_server(name)
    members = GetNumGroupMembers();
    for i=1, members do
        unit_name, realm = UnitName("raid"..i)
        if unit_name == name then
            if realm == nil or realm == "" then realm = GetRealmName() end
            return name .. "-" .. realm
        end
    end
end

function am_i_lootmaster()
    local lootmethod, masterlooterPartyID, masterlooterRaidID = GetLootMethod()
    if lootmethod ~= "master" then return false end
    local master_looter_name = GetRaidRosterInfo(masterlooterRaidID);
    local name, _ = UnitName("player")

    return name == master_looter_name
end

function auto_award(encounter_id, success)
    local encounter = PTS_rewards[encounter_id]
    if encounter == nil then PTS_print("encounter does not award points"); return end
    if success == 0 then PTS_print("not awarding points for wipe"); return end

    if not am_i_lootmaster() then PTS_print("cannot award points if you are not ML"); return end 

    local names = {}
    local reason = "Killed " .. encounter[2]
    gather_raid_chars(names)
    apply_points_to_group(names, encounter[1], false, reason)
    broadcast_message(encounter[1] .. " points awarded to raid for killing " .. encounter[2])
end

function auto_award_gargul()

    if auto_award_name == "" then return end

    local names = {}
    local full_receiver_name = get_name_with_server(auto_award_name)
    gather_player_chars(full_receiver_name, names)
    apply_points_to_group(names, auto_award_amount, false, auto_award_reason)
    broadcast_message(math.abs(auto_award_amount) .. " points taken from " .. full_receiver_name .. " - " .. auto_award_reason)

    auto_award_name = ""
    auto_award_amount = 0
    auto_award_reason = ""
end

function detect_winner(...)
    local _, _, msg, author = ...
    local full_name = UnitName("player") .. "-" .. GetRealmName()

    if not am_i_lootmaster() then PTS_print("cannot award points if you are not ML"); return end 
    if full_name ~= author or string.find(msg, " was awarded to ") == nil then return end

    local char_name_start = string.find(msg, "%w+ for ")
    local char_name_end = string.find(msg, " for %d+g.") - 1
    local amount_start = string.find(msg, "%d+g. Congrats")
    local amount_end = string.find(msg, "g. Congrats") - 1
    local item_start = string.find(msg, "|h%[") + 3
    local item_end = string.find(msg, "]|h|") - 1
    
    auto_award_name = string.sub(msg, char_name_start, char_name_end)
    auto_award_amount = tonumber(string.sub(msg, amount_start, amount_end)) * -1
    auto_award_reason = string.sub(msg, item_start, item_end)

    StaticPopupDialogs["POINTS_AUTO_AWARD_CONFIRM"].text = string.format(dialog_template, math.abs(auto_award_amount), auto_award_name, auto_award_reason)
    StaticPopup_Show("POINTS_AUTO_AWARD_CONFIRM");
end

local auto_award_frame = _G["PointsAutoAward"]
auto_award_frame:RegisterEvent("CHAT_MSG_RAID")
auto_award_frame:RegisterEvent("CHAT_MSG_RAID_LEADER")
auto_award_frame:RegisterEvent("CHAT_MSG_RAID_WARNING")
auto_award_frame:SetScript("OnEvent", detect_winner)

StaticPopupDialogs["POINTS_AUTO_AWARD_CONFIRM"] = { 
    text = "", 
    button1 = ACCEPT, 
    button2 = CANCEL, 
    OnAccept = auto_award_gargul
};
