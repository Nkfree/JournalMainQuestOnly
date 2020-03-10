local Methods = {}

Methods.IsReceivingMainQuestJournal = function(pid)

    local mainQuestPrefixes = { "a1", "a2", "b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "c0", "c2", "c3" }

    for i = 0, tes3mp.GetJournalChangesSize(pid) - 1 do

        local quest = tes3mp.GetJournalItemQuest(pid, i)
        local questPrefix = string.sub(quest, 1, 2)

        if tableHelper.containsValue(mainQuestPrefixes, questPrefix) then
            return true
        end
    end

    return false
end


Methods.OnPlayerJournal = function(pid)
    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
		local playerName = Players[pid].name
        if Methods.IsReceivingMainQuestJournal(pid) then
            WorldInstance:SaveJournal(pid)
            tes3mp.SendJournalChanges(pid, true)
			tes3mp.LogMessage(1, "[Journal Main Quest Only] Change saved to world.json");
        else
            Players[pid]:SaveJournal()
			tes3mp.LogMessage(1, "[Journal Main Quest Only] Change saved to " .. playerName .. ".json");
        end
    end
end



customEventHooks.registerValidator("OnPlayerJournal", function(evenStatus, pid)

 Methods.OnPlayerJournal(pid)
 return customEventHooks.makeEventStatus(false,false)
 
end)

return Methods
