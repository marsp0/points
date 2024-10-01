local registry = {
    [17549] = "Arcane",
    [17546] = "Nature",
    [17543] = "Fire",
    [17544] = "Frost",
    [17548] = "Shadow",
    [24382] = "Zanza",
    [17626] = "Titans",
    [17627] = "Distilled Wisdom",
    [17628] = "Supreme Power",
    [17540] = "Greater Stoneshield",
    [17538] = "Mongoose",
    [17539] = "Arcane Elixir",
    [17038] = "Firewater",
    [24363] = "Mageblood",
    [24799] = "Dumplings",
    [18194] = "Nightfin",
    [10157] = "Int"
}

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")

f:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        if in_guild_raid() then
            f:RegisterEvent("UNIT_AURA")
            PTS_print("[Enabled] Tracking consums")
        else
            f:UnregisterEvent("UNIT_AURA")
            PTS_print("[Disabled] Tracking consums")
        end
    elseif event == "UNIT_AURA" then
        unit_id = ...
        if not startswith(unit_id, "raid") or startswith(unit_id, "raidpet") then return end
        
        local current_time = GetTime()
        local player, realm = UnitName(unit_id)

        -- check buffs
        for j=1, 32 do
            local name, _, _, _, duration, expiration, _, _, _, spell_id = UnitAura(unit_id, j, "HELPFUL")
            if not name then break end

            if duration > 0 and expiration > 0 and registry[spell_id] then
                local start_time = expiration - duration
                local consum_name = registry[spell_id]

                if not PTS_consums_times[player] then PTS_consums_times[player] = {} end
                if not PTS_consums_times[player][consum_name] then PTS_consums_times[player][consum_name] = 0 end
                
                if PTS_consums_times[player][consum_name] < start_time then
                    if not PTS_consums[player] then PTS_consums[player] = {} end
                    if not PTS_consums[player][consum_name] then PTS_consums[player][consum_name] = 0 end

                    PTS_consums[player][consum_name] = PTS_consums[player][consum_name] + 1
                    PTS_consums_times[player][consum_name] = start_time
                end
            end
        end
    end
end)

function clear_consums()
    PTS_consums = {}
    PTS_consums_times = {}
    export_consums()
end