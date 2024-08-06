PTS_links_start_index = 1

function links_sorter(a, b) return a.main < b.main end

function name_in_guild(name)
    for i=1, GetNumGuildMembers() do
        char_name = GetGuildRosterInfo(i);
        if name == char_name then return true end
    end

    return false
end

function clear_rows()
    for i=1, 17 do
        _G["PointsFrameLinksTabRow" .. i .. "Name"]:SetText("")
    end
end

function update_alt_main_map()
    PTS_alt_main_map = {}
    for _, main_map in pairs(PTS_main_alts_map) do
        PTS_alt_main_map[main_map.main] = main_map.main
        for _, alt in pairs(main_map.alts) do
            PTS_alt_main_map[alt] = main_map.main
        end 
    end
end

function add_link()
    main = _G["PointsFrameLinksTabMain"]:GetText()
    alt =  _G["PointsFrameLinksTabAlt"]:GetText()

    if not name_in_guild(main) then
        PTS_print(main .. " not in guild")
        return
    end

    if not name_in_guild(alt) then
        PTS_print(alt .. " not in guild")
        return
    end

    -- check if main is in table
    main_exists = false
    for k, v in pairs(PTS_main_alts_map) do
        if v.main == main then
            alt_exists = false
            for _, existing_alt in pairs(v.alts) do
                if existing_alt == alt then alt_exists=true end
            end
            if not alt_exists then
                table.insert(v.alts, alt)
            end
            main_exists = true
        end
    end

    -- add if not in table
    if not main_exists then
        table.insert(PTS_main_alts_map, {main=main, alts={alt}})
    end

    table.sort(PTS_main_alts_map, links_sorter)
    update_alt_main_map()
    populate_links()
end

function remove_link()
    main = _G["PointsFrameLinksTabMain"]:GetText()
    alt =  _G["PointsFrameLinksTabAlt"]:GetText()

    -- check if main is in table
    for k, v in pairs(PTS_main_alts_map) do
        if v.main == main then
            for i, existing_alt in pairs(v.alts) do
                if existing_alt == alt then table.remove(v.alts, i); break; end
            end

            if #v.alts == 0 then
                table.remove(PTS_main_alts_map, k)
            end
        end
    end

    table.sort(PTS_main_alts_map, links_sorter)
    update_alt_main_map()
    populate_links()
end

function populate_links()
    clear_rows()
    PTS_links_start_index = math.min(math.max(1, PTS_links_start_index), #PTS_main_alts_map - 16)
    local row_i = 1
    for i=PTS_links_start_index, PTS_links_start_index + 16 do
        if PTS_main_alts_map[i] == nil then return end
        local v = PTS_main_alts_map[i]
        local str = v.main
        for _, alt in pairs(v.alts) do
            str = str .. ", " .. alt
            
        end

        _G["PointsFrameLinksTabRow" .. row_i .. "Name"]:SetText(str)
        row_i = row_i + 1
    end
end

function links_button_on_click()
    PTS_links_start_index = 1
    update_alt_main_map()
    populate_links()
    set_active_tab("PointsFrameLinksTab")
end

function change_links_page(delta)
    if delta > 0 then 
        PTS_links_start_index = PTS_links_start_index - 16
    else
        PTS_links_start_index = PTS_links_start_index + 16
    end 

    populate_links()
end