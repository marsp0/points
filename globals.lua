PTS_guild_roster = {}
PTS_sort_by_name = true
PTS_main_alts_map = PTS_main_alts_map or {}
PTS_alt_main_map = {}
PTS_transactions = PTS_transactions or {}
PTS_diff_map = PTS_diff_map or {} 
PTS_consums = PTS_consums or {}
PTS_consums_times = PTS_consums_times or {}

SlashCmdList['POINTS_SLASHCMD'] = function(msg)
    local f = _G["PointsFrame"]
    if f:IsVisible() then
        f:Hide()
    else
        f:Show()
    end
end
SLASH_POINTS_SLASHCMD1 = '/points'
