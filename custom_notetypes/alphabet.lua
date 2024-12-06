function onCreate()
	for i = 0, getProperty('unspawnNotes.length')-1 do
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'alphabet' then
			setPropertyFromGroup('unspawnNotes', i, 'texture', 'notes/NOTE_recursed')
			setPropertyFromGroup('unspawnNotes', i, 'antialiasing', false)
			setPropertyFromGroup('unspawnNotes', i, 'scale.x', 0.60)
			setPropertyFromGroup('unspawnNotes', i, 'scale.y', 0.60)
			setPropertyFromGroup('unspawnNotes', i, 'offsetX', 4)
			end
		end
	end
end

function noteMiss(id, noteData, noteType, isSustainNote)
	if noteType == 'alphabet' then
		triggerEvent('Screen Shake', '0.005, 0.1', '')
	end
end
