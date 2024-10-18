local run_check = true
local last_update_time = GetTime()
local last_broadcast_time = {}
local overbid_msg = "%s overbid on items. Bids: %s, Current: %s, Items: %s"
local update_interval_s = 2
local broadcast_interval_s = 5

function run_point_check()
    local auctions = _G.Gargul.GDKP.MultiAuction.Client.AuctionDetails.Auctions
    local current_time = GetTime()
    local run_update = current_time - last_update_time > update_interval_s

    if not run_check            then return end
    if not run_update           then return end
    if not auctions             then return end

    -- run check only if there are active auctions
    local len = 0
    for id, auction in pairs(auctions) do if auction.endsAt ~= 0 then len = len + 1 end end
    if len == 0 then return end


    local current_points = {}
    local total_points = {}
    local items = {}

    last_update_time = current_time

    -- populate temporary cache of player points
    for i=1, GetNumGuildMembers() do
        local char_name, _, _, _, _, _, _, officernote = GetGuildRosterInfo(i);
        if char_name then
            local name_lower = string.lower(char_name)
            current_points[name_lower] = read_points(officernote)
            total_points[name_lower] = 0
            items[name_lower] = ""
        end
    end

    -- check for multibids
    for id, auction in pairs(auctions) do
        local current = auction.CurrentBid
        if auction.endsAt ~= 0 and current then
            total_points[current.player] = total_points[current.player] + current.amount
            items[current.player] = auction.name .. " " .. items[current.player] 
        end
    end

    -- announce overbids
    for player, bid in pairs(total_points) do
        if not last_broadcast_time[player] then last_broadcast_time[player] = 0 end
        local overbid = current_points[player] < bid
        local can_broadcast = current_time - last_broadcast_time[player] > broadcast_interval_s
        if overbid and can_broadcast then
            broadcast(string.format(overbid_msg, player, bid, current_points[player], items[player]))
            last_broadcast_time[player] = current_time
        end
    end

    -- check for single overbids
    for id, auction in pairs(auctions) do
        if auction.endsAt ~= 0 and auction.BidsPerPlayer then
            for player, bid in pairs(auction.BidsPerPlayer) do
                if not last_broadcast_time[player] then last_broadcast_time[player] = 0 end
                local overbid = current_points[player] < bid
                local can_broadcast = current_time - last_broadcast_time[player] > broadcast_interval_s
                if overbid and can_broadcast then
                    broadcast(string.format(overbid_msg, player, bid, current_points[player], auction.name))
                    last_broadcast_time[player] = current_time
                end
            end
        end
    end
end

function run_point_init()
    last_broadcast_time = {}
    -- enable only in guild raids
    if in_guild_raid() and am_i_lootmaster() then 
        run_check = true; 
        PTS_print("[Enabled] Tracking overbids")
    else    
        run_check = false
        PTS_print("[Disabled] Tracking overbids")
    end
end

local f = CreateFrame("Frame")
f:SetScript("OnUpdate", run_point_check)
f:SetScript("OnEvent", run_point_init)
f:RegisterEvent("PLAYER_ENTERING_WORLD")