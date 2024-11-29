local group_player_map = {}
local player_group_map = {}
local player = 0
local group = 1

function groups_button_on_click()
    set_active_tab("PointsFrameGroupsTab")
end

function groups_apply_button()
    local raw_string = _G["PointsFrameGroupsTabScrollText"]:GetText()
    
    group_player_map = {}
    player_group_map = {}
    player = 0
    group = 1
    parse_groups(raw_string)
    apply_groups()
end

function parse_groups(raw_string) 
    for line in string.gmatch(raw_string, "[^\r\n]+") do

        local group_end = string.find(line, ":") - 1
        local group_str = string.sub(line, 0, group_end)
        local group = tonumber(group_str)

        group_player_map[group] = {}
        local start_index = group_end + 2
        local group_line = string.sub(line, start_index)
        local index = 1

        for member in string.gmatch(group_line, "[^,]+") do
            group_player_map[group][index] = string.lower(member)
            player_group_map[member] = group
            index = index + 1
        end
    end
end

function apply_groups()
    
    player = player + 1
    if player == 6 then group = group + 1; player = 1 end

    if group == 9 then print("Finished applying groups"); return end

    C_Timer.After(0.4, apply_groups)
    -- TODO: allow missing groups
 
    if not group_player_map[group] or not group_player_map[group][player] then 
        print("Groups: unassigned spot", tostring(group), tostring(player))
    end

    local player_index_map = {}
    local player_group_map_current = {}
    local target_player = group_player_map[group][player]

    -- build maps
    for i=1, GetNumGroupMembers() do
        local _, _, subgroup    = GetRaidRosterInfo(i);
        local name              = string.lower(UnitName("raid" .. i));
        
        player_index_map[name] = i
        player_group_map_current[name] = subgroup
    end

    -- dont do anything if player is already in grp
    if player_group_map_current[target_player] == group then return end

    -- find player to swap with
    local swap_index = 0
    local target_index = player_index_map[target_player]
    local swap_player = ""
    for player, player_group in pairs(player_group_map_current) do
        if player_group == group and player_group_map[player] ~= group then
            swap_index = player_index_map[player]
            swap_player = player
        end
    end

    if not target_index then return end

    if swap_index > 0 then
        SwapRaidSubgroup(swap_index, target_index);
    else
        SetRaidSubgroup(target_index, group);
    end
end
