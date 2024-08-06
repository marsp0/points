PTS_guild_tab_start_index = 1

function roster_sorter(a,b)
    if PTS_sort_by_name then 
        return a.name < b.name
    else
        return a.points > b.points
    end
end

function populate_roster()
    PTS_guild_roster = {}
    for i=1, GetNumGuildMembers() do
        char_name, _, _, _, cls, _, _, officernote = GetGuildRosterInfo(i);
        ep = read_points(officernote)
        table.insert(PTS_guild_roster, {name=char_name, class=cls, points=tonumber(ep or 0)})
    end
    table.sort(PTS_guild_roster, roster_sorter)
end

function populate_dkp_points()
    PTS_guild_tab_start_index = math.min(math.max(1, PTS_guild_tab_start_index), #PTS_guild_roster - 19)

    row_i = 1
    for i=PTS_guild_tab_start_index, PTS_guild_tab_start_index + 19 do
        local name_frame = _G["PointsFrameGuildTabRow" .. row_i .. "Name"]
        local class_frame = _G["PointsFrameGuildTabRow" .. row_i .. "Class"]
        local points_frame = _G["PointsFrameGuildTabRow" .. row_i .. "Points"]

        name_frame:SetText(PTS_guild_roster[i].name)
        class_frame:SetText(PTS_guild_roster[i].class)
        points_frame:SetText(PTS_guild_roster[i].points)

        local color = ccm[PTS_guild_roster[i].class]
        name_frame:SetTextColor(color.r, color.g, color.b)
        class_frame:SetTextColor(color.r, color.g, color.b)
        points_frame:SetTextColor(color.r, color.g, color.b)

        row_i = row_i + 1
    end
end

function change_dkp_page(delta)
    if delta > 0 then 
        PTS_guild_tab_start_index = PTS_guild_tab_start_index - 19
    else
        PTS_guild_tab_start_index = PTS_guild_tab_start_index + 19
    end 

    populate_dkp_points()
end

function guild_button_on_click()
    populate_roster()
    PTS_guild_tab_start_index = 1
    populate_dkp_points()
    set_active_tab("PointsFrameGuildTab")
end

function swap_sort_method()
    PTS_sort_by_name = not PTS_sort_by_name
    guild_button_on_click()
end