GameTooltip:HookScript("OnTooltipSetUnit", function(self) 
    local _, unit = self:GetUnit()
    if not unit                         then return end
    if not UnitIsPlayer(unit)           then return end
    if GetGuildInfo(unit) ~= "Unity"    then return end

    local name, server = UnitName(unit)
    if not server then server = "Golemagg" end
    unit_name = name .. "-" .. server

    if PTS_alt_main_map[unit_name] then unit_name = PTS_alt_main_map[unit_name] end

    GameTooltip:AddLine(PTS_diff_map[unit_name] or 0)
end)