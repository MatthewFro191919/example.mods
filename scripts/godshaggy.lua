local sh_r = 600
local bfControlY = 0
local endCheck = false
local trigger = 1
local shag_fly = true
local songStarted = false
----------------------------
local collected = false
local state0 = true
local vsp = -10
----------------------------
local dvsp = {-20, -20, -20}
local dhsp = {0, 0, 0}
local CdebId = 1
local Csx = {0,0,0}
local Csy = {0,0,0}
local Csc = {0,0,0}
local CtF = {0,0,0}
local CtD = {0,0,0}
local CpF = {0,0,0}
------Thanks to Bf Myt for this----------
local currentGhost = 0
local lastGhost = 0
local fps = 0

function onCreate()
	makeAnimatedLuaSprite('legs', 'characters/shaggy_godboyfriend', 0, 0)
	addAnimationByPrefix('legs', 'Instance', 'solo_legs', 24, false)
	addOffset('legs', 'Instance', 0, 0)
	setObjectOrder('legs', getObjectOrder('boyfriendGroup'))
	addLuaSprite('legs', false)
end

function onBeatHit()
	if curBeat < 32 then
		sh_r = 60
	elseif (curBeat >= 50*4 and curBeat <= 58*4) or curBeat >= 140 * 4 then
		sh_r = 60
	else
		sh_r = 600
	end
end


function onUpdate(elapsed)
		fps = fps + elapsed
		createGhost('legs','FFFFF', getProperty('legs.animation.curAnim.name'), getProperty('boyfriend.imageFile'))
		createGhost('boyfriend', 'FFFFF', getProperty('boyfriend.animation.curAnim.name'), getProperty('boyfriend.imageFile'))
		fps = 0

		rotRateShag = curStep / 9.25
		sh_toy = -2450 + -math.sin(rotRateShag * 2) * sh_r * 0.45
		sh_tox = -330 - math.cos(rotRateShag) * sh_r
		setProperty('boyfriend.x', getProperty('boyfriend.x') + ((sh_tox - getProperty('boyfriend.x')) / 12))
		setProperty('boyfriend.y', getProperty('boyfriend.y') + ((sh_toy - getProperty('boyfriend.y')) / 12))
		setProperty('boyfriend.x', getProperty('boyfriend.x') + (((sh_tox+800) - getProperty('boyfriend.x')) / 12))
		setProperty('boyfriend.y', getProperty('boyfriend.y') + ((sh_toy - getProperty('boyfriend.y')) / 12))

		if getProperty('boyfriend.animation.curAnim.name') == "idle" then
			setProperty('boyfriend.angle', math.sin(rotRateShag) * sh_r * 0.07 / 4)
			setProperty('legs.alpha', 1)
			setProperty('legs.angle', math.sin(rotRateShag) * sh_r * 0.07)
			setProperty('legs.x', (getProperty('boyfriend..x') + -25 + math.cos((getProperty('legs.angle') + 90) * (math.pi/180)) * 150))
			setProperty('legs.y', (getProperty('boyfriend..y') + 290 + math.sin((getProperty('legs.angle') + 90) * (math.pi/180)) * 150))
			setProperty('legs.x', getProperty('legs.x') - getProperty('legs.angle')*3.6)
			if getProperty('legs.angle') > 0 then
				setProperty('legs.y', getProperty('legs.y') + -getProperty('legs.angle')-getProperty('boyfriend..angle')*2)
			elseif getProperty('legs.angle') < 0 then
				setProperty('legs.y', getProperty('legs.y') + getProperty('legs.angle')-getProperty('boyfriend.angle')*2)
			end
		end
	if (shag_fly and songStarted) then
		cameraSetTarget('boyfriend')
		setProperty('mouse.alpha', 0)
	elseif (not shag_fly and allowCountdown) or mustHitSection then
		cameraSetTarget('boyfriend')
		if bfControlY > 2000 and not collected then
			setProperty('mouse.alpha', 1)
		else
			setProperty('mouse.alpha', 0)
		end
	end
end
function createGhost(character, color, anim, location)
    local spriteName = character..'Ghost'..lastGhost
    makeAnimatedLuaSprite(spriteName, location, getProperty(character..'.x'), getProperty(character..'.y'))
    scaleObject(spriteName, getProperty(character..'.scale.x'), getProperty(character..'.scale.y'))
    setProperty(spriteName..'.color',getColorFromHex(color))
    setProperty(spriteName..'.alpha', getProperty(character..'.alpha') - 0.4)
    doTweenAlpha(spriteName..'Bye',spriteName, 0, 0.5, 'linear')
    setObjectOrder(spriteName,getObjectOrder('boyfriendGroup')-2)
    addGhostAnim(character,anim)
    addLuaSprite(spriteName,false)
    setProperty(spriteName..'.flipX', getProperty(character..'.flipX'))
    setProperty(spriteName..'.angle', getProperty(character..'.angle'))
    objectPlayAnimation(character..'Ghost'..lastGhost,anim,true)
    lastGhost = lastGhost + 1
end

function addGhostAnim(character, name)
	local spriteAnim = character..'Ghost'..lastGhost
	addAnimationByPrefix(spriteAnim, name, getProperty(character..'.animation.frameName'), getProperty(character..'.animation.curAnim.frameRate'), getProperty(character..'.animation.curAnim.looped'))
	setProperty(spriteAnim..'.offset.x', getProperty(character..'.offset.x'))
	setProperty(spriteAnim..'.offset.y', getProperty(character..'.offset.y'))
end
