function export_button_on_click()
    set_active_tab("PointsFrameEditorTab")
    _G["PointsFrameEditorTabStandingsButton"]:Show()
    _G["PointsFrameEditorTabTransactionsButton"]:Show()
    
    if am_admn() then _G["PointsFrameEditorTabDiffButton"]:Show() end
end

function export_points()
    set_active_tab("PointsFrameEditorTab")
    local f = _G["PointsFrameEditorTabScrollText"]

    for i=1, GetNumGuildMembers() do
        char_name, _, _, _, cls, _, _, officernote = GetGuildRosterInfo(i);
        ep = read_points(officernote)
        f:Insert(char_name .. "," .. ep .. ",\n")
    end
end

function export_transactions()
    set_active_tab("PointsFrameEditorTab")
    _G["PointsFrameEditorTabClearTransactions"]:Show()
    local f = _G["PointsFrameEditorTabScrollText"]

    for _, v in pairs(PTS_transactions) do
        f:Insert(v[1] .. ", " .. v[2] .. ", " .. v[3] .. ", " .. v[4] .. ", " .. v[5] .. ", " .. v[6] .. ",\n" )
    end
end

function export_diff()
    set_active_tab("PointsFrameEditorTab")
    _G["PointsFrameEditorTabUpdateDiffButton"]:Show()
    local f = _G["PointsFrameEditorTabScrollText"]

    for i=1, GetNumGuildMembers() do
        local char_name, _, _, _, _, _, _, officernote = GetGuildRosterInfo(i);
        local actual = read_points(officernote)
        local expected = PTS_diff_map[char_name] 
        if actual ~= expected then
            if actual == nil then actual = 0 end
            if expected == nil then expected = 0 end
            f:Insert(char_name .. "," .. expected .. ", " .. actual .. ", " .. math.abs(expected - actual) .. "\n" )
        end
    end
end

function update_diff()
    PTS_diff_map = {}
    for i=1, GetNumGuildMembers() do
        local char_name, _, _, _, _, _, _, officernote = GetGuildRosterInfo(i);
        PTS_diff_map[char_name] = read_points(officernote)
    end
end

function export_consums()
    set_active_tab("PointsFrameEditorTab")
    _G["PointsFrameEditorTabClearConsumsButton"]:Show()

    local f = _G["PointsFrameEditorTabScrollText"]

    for player, consums in pairs(PTS_consums) do
        local str_row = player .. ", "
        for name, quantity in pairs(consums) do
            str_row = str_row .. name .. " (" .. quantity .. "), "
        end

        f:Insert(str_row)
    end
end