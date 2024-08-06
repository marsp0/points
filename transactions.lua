function add_transaction(timestamp, giver, receiver, before, after, reason)
    table.insert(PTS_transactions, {timestamp, giver, receiver, tonumber(before), tonumber(after), reason})
end

function transactions_check()
    PTS_print("Currently " .. #PTS_transactions .. " transactions in cache.")
    if #PTS_transactions > 1000 then
        PTS_print("Local transaction cache is getting big. Export transactions to reduce count")
        PTS_print("Local transaction cache is getting big. Export transactions to reduce count")
        PTS_print("Local transaction cache is getting big. Export transactions to reduce count")
        PTS_print("Local transaction cache is getting big. Export transactions to reduce count")
        PTS_print("Local transaction cache is getting big. Export transactions to reduce count")
        PTS_print("Local transaction cache is getting big. Export transactions to reduce count")
    end
end

function clear_transactions()
    PTS_transactions = {}
    export_transactions()
end