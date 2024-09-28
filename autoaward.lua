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

function auto_award(encounter_id, success)
    if not am_i_lootmaster() then return end 

    local encounter = PTS_rewards[encounter_id]
    if encounter == nil then PTS_print("encounter does not award points"); return end
    if success == 0 then PTS_print("not awarding points for wipe"); return end

    local names = {}
    local reason = "Killed " .. encounter[2]
    gather_raid_chars(names)
    apply_points_to_group(names, encounter[1], false, reason)
    broadcast(encounter[1] .. " points awarded to raid for killing " .. encounter[2])
end
