function gargul_deduct_points()
    local auctions = _G.Gargul.GDKP.MultiAuction.Client.AuctionDetails.Auctions

    if not am_i_lootmaster()    then return end 
    if not auctions             then return end

    local deductions = {}
    local deductions_reasons = {}
    local deduction_report = "Deducted: "

    for id, auction in pairs(auctions) do
        local current = auction.CurrentBid
        if current then
            if not deductions[current.player] then deductions[current.player] = 0 end
            if not deductions_reasons[current.player] then deductions_reasons[current.player] = "" end
            deductions[current.player] = deductions[current.player] + current.amount
            deductions_reasons[current.player] = deductions_reasons[current.player] .. ", " .. auction.name
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