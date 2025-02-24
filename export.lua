function export_button_on_click()
    set_active_tab("PointsFrameEditorTab")
    _G["PointsFrameEditorTabClearButton"]:Hide()
    
    if am_admn() then _G["PointsFrameEditorTabDiffButton"]:Show() end
end

function export_points()
    set_active_tab("PointsFrameEditorTab")
    _G["PointsFrameEditorTabClearButton"]:Hide()
    local f = _G["PointsFrameEditorTabScrollText"]

    for i=1, GetNumGuildMembers() do
        char_name, _, _, _, cls, _, _, officernote = GetGuildRosterInfo(i);
        ep = read_points(officernote)
        f:Insert(char_name .. "," .. ep .. ",\n")
    end
end

function export_transactions()
    set_active_tab("PointsFrameEditorTab")
    local b = _G["PointsFrameEditorTabClearButton"]
    b:SetScript("OnClick", clear_transactions)
    b:Show()

    local f = _G["PointsFrameEditorTabScrollText"]

    for _, v in pairs(PTS_transactions) do
        f:Insert(v[1] .. ", " .. v[2] .. ", " .. v[3] .. ", " .. v[4] .. ", " .. v[5] .. ", " .. v[6] .. ",\n" )
    end
end

function export_diff()
    set_active_tab("PointsFrameEditorTab")
    local b = _G["PointsFrameEditorTabClearButton"]
    b:SetScript("OnClick", update_diff)
    b:Show()

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
    export_diff()
end

function export_consums()
    set_active_tab("PointsFrameEditorTab")
    local b = _G["PointsFrameEditorTabClearButton"]
    b:SetScript("OnClick", clear_consums)
    b:Show()

    local f = _G["PointsFrameEditorTabScrollText"]

    for player, consums in pairs(PTS_consums) do
        local str_row = player .. ", "
        for name, quantity in pairs(consums) do
            str_row = str_row .. quantity .. "x " .. name .. ", "
        end

        f:Insert(str_row .. "\n")
    end
end