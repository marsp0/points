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
    local f = _G["PointsFrameEditorTabScrollText"]

    for _, v in pairs(PTS_transactions) do
        f:Insert(v[1] .. ", " .. v[2] .. ", " .. v[3] .. ", " .. v[4] .. ", " .. v[5] .. ", " .. v[6] .. ",\n" )
    end
end