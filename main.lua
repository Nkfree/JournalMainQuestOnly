local Methods = {}

function Methods.IsConfigSettingValid()

	if config.shareJournal == true then
		return false
	end
	
	return true
end

function Methods.IsMainQuest(pid)

    local mainQuestPrefixes = { "a1", "a2", "b1", "b2", "b3", "b4", "b5", "b6", "b7", "b8", "c0", "c2", "c3" }

    for i = 0, tes3mp.GetJournalChangesSize(pid) - 1 do
		
		local journalItem = {
            type = tes3mp.GetJournalItemType(pid, i),
            index = tes3mp.GetJournalItemIndex(pid, i),
            quest = tes3mp.GetJournalItemQuest(pid, i),
            timestamp = {
                daysPassed = WorldInstance.data.time.daysPassed,
                month = WorldInstance.data.time.month,
                day = WorldInstance.data.time.day
            }
        }
		
		if journalItem.type == enumerations.journal.ENTRY then
            journalItem.actorRefId = tes3mp.GetJournalItemActorRefId(pid, i)
        end
		
        local questPrefix = string.sub(journalItem.quest, 1, 2)

        if tableHelper.containsValue(mainQuestPrefixes, questPrefix) then
            return journalItem
        end
    end

    return false
end


function Methods.IsReceivingMainQuestJournal(pid)

	local journalItem = Methods.IsMainQuest(pid)
	
	if journalItem then
		
		for id, _ in pairs(Players) do
		
			if id ~= pid then
				if journalItem.type == enumerations.journal.ENTRY then

					if journalItem.actorRefId == nil then
						journalItem.actorRefId = "player"
					end

					if journalItem.timestamp ~= nil then
						tes3mp.AddJournalEntryWithTimestamp(id, journalItem.quest, journalItem.index, journalItem.actorRefId,
							journalItem.timestamp.daysPassed, journalItem.timestamp.month, journalItem.timestamp.day)
					else
						tes3mp.AddJournalEntry(id, journalItem.quest, journalItem.index, journalItem.actorRefId)
					end
				else
					tes3mp.AddJournalIndex(id, journalItem.quest, journalItem.index)
				end
				tes3mp.SendJournalChanges(id)
			end
			
		end
		
		return true
    end
	return false
end

customEventHooks.registerHandler("OnServerPostInit", function(eventStatus)
	if Methods.IsConfigSettingValid() == false then
		tes3mp.LogMessage(1, "[JournalMainQuestOnly] OnServerPostInit: config.shareJournal variable needs to be set to false should the script work properly!")
	end
end)

customEventHooks.registerValidator("OnPlayerJournal", function(evenStatus, pid)

	if Methods.IsReceivingMainQuestJournal(pid) == true then
		for id, _ in pairs(Players) do
			Players[id]:SaveJournal()
		end
		
		return customEventHooks.makeEventStatus(false,false)
	else
		return customEventHooks.makeEventStatus(true,true)
	end
end)

return Methods
