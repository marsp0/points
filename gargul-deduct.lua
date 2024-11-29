function gargul_deduct_points()
    local auctions = _G.Gargul.GDKP.MultiAuction.Client.AuctionDetails.Auctions

    if not am_i_lootmaster()    then return end 
    if not auctions             then return end

    local deductions = {}
    local deductions_reasons = {}
    local deduction_report = "Deducted: "
    local main_alt_map = {}

    -- populate temp cache of alt main map - all lower
    for k, v in pairs(PTS_alt_main_map) do main_alt_map[string.lower(k)] = string.lower(v) end

    for id, auction in pairs(auctions) do
        local current = auction.CurrentBid
        if current then
            local player_name = main_alt_map[current.player] or current.player
            if not deductions[player_name] then deductions[player_name] = 0 end
            if not deductions_reasons[player_name] then deductions_reasons[player_name] = "" end
            deductions[player_name] = deductions[player_name] + current.amount
            deductions_reasons[player_name] = deductions_reasons[player_name] .. " / " .. auction.name
        end
    end

    for i=1, GetNumGuildMembers() do
        local char_name, _, _, _, _, _, _, officernote = GetGuildRosterInfo(i);
        local name_lower = string.lower(char_name)
        
        if deductions[name_lower] then
            local names = {}
            gather_player_chars(char_name, names)
            apply_points_to_group(names, -deductions[name_lower], false, deductions_reasons[name_lower])
            deduction_report = deduction_report .. string.sub(char_name, 1, 5) .. " - " .. deductions[name_lower] .. ", "
        end
    end

    broadcast(deduction_report)
end