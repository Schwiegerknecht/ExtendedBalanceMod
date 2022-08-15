-- Increase wrath timers from 7 to 10 and 10 to 15
Buffs.HEPA01BestialWrath01.Duration = 10
Buffs.HEPA01BestialWrath02.Duration = 10
Buffs.HEPA01BestialWrath03.Duration = 10
Buffs.HEPA01BestialWrath04.Duration = 10
Buffs.HEPA01BestialWrath05.Duration = 15

--Increase diseased claw snare
Buffs.HEPA01DiseasedClaws02.Affects.MoveMult.Mult = -0.10
Buffs.HEPA01DiseasedClaws03.Affects.MoveMult.Mult = -0.15

--Increase Grasp Drain
Ability.HEPA01FoulGrasp02.Amount = 166
Ability.HEPA01FoulGrasp03.Amount = 249

--Decrease the damage mitigation by Acclimation to 30% (down from 40%) --Schwiegerknecht
Buffs.HEPA01Acclimation.Affects.DamageTakenMult = {Add = -0.30}

-- Increase Ooze self damage, scaling off hero level:
-- 20 + herolevel*0/1/2/3 dmg (from 20/30/40/50)
-- This means 20/30/40/50 dmg at lvl 10, and 20/40/60/80 dmg at lvl 20
-- Maxing Ooze at lvl 1/4/7/10 would for the first 10 levels do dmg as follows:
-- 20//20/20/24/25/26/34/36/38/50, after that incrementing in steps of 3.

# Since for-loop does not work for some reason:
Ability.HEPA01Ooze02.OnAuraPulse = function(self, unit, params)
    local aiBrain = unit:GetAIBrain()
    local hero = aiBrain:GetHero()
    local herolvl = hero:GetLevel()
    local loseHealth = -(20 + herolvl*1)

    Buffs['HEPA01OozeSelf02'].Affects.Health.Add = loseHealth
    
    if unit.AbilityData.OozeOn then
        Buff.ApplyBuff(unit, 'HEPA01OozeSelf02', unit)
        if unit:GetHealth() < 100 then
            local params = { AbilityName = 'HEPA01OozeOff'}
            Abil.HandleAbility(unit, params)
        end
    end
end
Ability.HEPA01Ooze03.OnAuraPulse = function(self, unit, params)
    local aiBrain = unit:GetAIBrain()
    local hero = aiBrain:GetHero()
    local herolvl = hero:GetLevel()
    local loseHealth = -(20 + herolvl*2)

    Buffs['HEPA01OozeSelf03'].Affects.Health.Add = loseHealth
    
    if unit.AbilityData.OozeOn then
        Buff.ApplyBuff(unit, 'HEPA01OozeSelf03', unit)
        if unit:GetHealth() < 100 then
            local params = { AbilityName = 'HEPA01OozeOff'}
            Abil.HandleAbility(unit, params)
        end
    end
end
Ability.HEPA01Ooze04.OnAuraPulse = function(self, unit, params)
    local aiBrain = unit:GetAIBrain()
    local hero = aiBrain:GetHero()
    local herolvl = hero:GetLevel()
    local loseHealth = -(20 + herolvl*3)

    Buffs['HEPA01OozeSelf04'].Affects.Health.Add = loseHealth
    
    if unit.AbilityData.OozeOn then
        Buff.ApplyBuff(unit, 'HEPA01OozeSelf04', unit)
        if unit:GetHealth() < 100 then
            local params = { AbilityName = 'HEPA01OozeOff'}
            Abil.HandleAbility(unit, params)
        end
    end
end

#The for-loop, in case somebody gets it to work:
--[[
for i = 2,4 do
    Ability['HEPA01Ooze0'..i].OnAuraPulse = function(self, unit, params)
        local aiBrain = unit:GetAIBrain()
        local hero = aiBrain:GetHero()
        local herolvl = hero:GetLevel()
        local loseHealth = -(20 + herolvl * (i - 1))

        Buffs['HEPA01OozeSelf0'..i].Affects.Health.Add = loseHealth
        
        if unit.AbilityData.OozeOn then
            Buff.ApplyBuff(unit, 'HEPA01OozeSelf0'..i, unit)
            if unit:GetHealth() < 100 then
                local params = { AbilityName = 'HEPA01OozeOff'}
                Abil.HandleAbility(unit, params)
            end
        end
    end
end
]]

-- CHange Descriptions
Ability.HEPA01Ooze02.Description = 'Unclean Beast oozes virulent bodily fluids. While active, nearby enemies take [GetDebuffDamage] damage per second and their Attack Speed is slowed by [GetDebuffSlow]%.\n\nUnclean Beast loses Health per second equivalent to 20 + UB\'s level.'
Ability.HEPA01Ooze03.Description = 'Unclean Beast oozes virulent bodily fluids. While active, nearby enemies take [GetDebuffDamage] damage per second and their Attack Speed is slowed by [GetDebuffSlow]%.\n\nUnclean Beast loses Health per second equivalent to 20 + (UB\'s level * 2).'
Ability.HEPA01Ooze04.Description = 'Unclean Beast oozes virulent bodily fluids. While active, nearby enemies take [GetDebuffDamage] damage per second and their Attack Speed is slowed by [GetDebuffSlow]%.\n\nUnclean Beast loses Health per second equivalent to 20 + (UB\'s level * 3).'


# Make Foul Grasp I not ignore stun immunities anymore --Schwiegerknecht
#################################################################################################################
BuffBlueprint {
    Name = 'HEPA01FoulGraspStun02',
    DisplayName = '<LOC ABILITY_HEPA01_0043>Foul Grasp',
    Description = '<LOC ABILITY_HEPA01_0044>Stunned.',
    BuffType = 'HEPA01FOULGRASPSTUN',
    Debuff = true,
    Stacks = 'ALWAYS',
    Duration = 2,
    TriggersStunImmune = true,
    Affects = {
        Stun = {Add = 0},
    },
    Icon = '/DGUncleanBeast/NewUncleanFoulGrasp01',
}

-- Create copies of the Foul Grasp functions, changing all instances of
-- HEPA01FoulGraspStun01
DrawLifeTriggersImmune = function(def, unit, target)
    unit:GetWeapon(1):SetStayOnTarget(true)

    # Add callbacks so we can interrupt Grasp
    unit.Callbacks.OnWeaponFire:Add(EndGraspTriggersImmune, def)
    unit.Callbacks.OnKilled:Add(EndGraspTriggersImmune, def)
    unit.Callbacks.OnStunned:Add(EndGraspTriggersImmune, def)
    unit.Callbacks.OnFrozen:Add(EndGraspTriggersImmune, def)
    target.Callbacks.OnKilled:Add(EndGraspTriggersImmune, def)
    unit.Callbacks.OnAbilityBeginCast:Add(EndGraspCancelTriggersImmune)

    Buff.ApplyBuff(unit, 'StayOnTarget', unit)
    Buff.ApplyBuff(unit, 'WeaponDisable', unit)
    
    -- Try applying the stun first so we trigger "Immune" in case of immunity.
    Buff.ApplyBuff(target, 'HEPA01FoulGraspStun02', unit, unit:GetArmy())
    -- Only apply debuffs to target if the target is not StunImmune.
    if not target.StunImmune then
        target:GetNavigator():AbortMove()
        if target.Character then
            target.Character:AbortCast()
        end
        Buff.ApplyBuff(target, 'WeaponDisable', unit, unit:GetArmy())
        Buff.ApplyBuff(target, 'Immobile', unit, unit:GetArmy())
        -- And only in this case add target to unit.AbilityData
        unit.AbilityData.FoulGraspTarget = target
    end
    unit:GetNavigator():AbortMove()
    Buff.ApplyBuff(unit, 'Immobile', unit)

    
    WaitSeconds(0.1)
    unit.Character:PlayAction('CastFoulGraspStart')
    if not unit:IsDead() then
        unit.Callbacks.OnMotionHorzEventChange:Add(Moved, def)
    end
    WaitSeconds(0.3)

    # create Foul Grasp effects at target with a vector towards the Unclean Beast.
    local unitpos = table.copy(unit:GetPosition())
    unitpos[2] = unitpos[2]+3
    local dir = VDiff(unitpos,target:GetPosition())
    local dist = VLength( dir )
    local dirNorm = VNormal(dir)
    dirNorm[2] = dirNorm[2]/2
    local unitbp = target:GetBlueprint()
    local unitheight = unitbp.SizeY * 0.9
    local unitwidth = (unitbp.SizeX + unitbp.SizeZ) / 2.5
    local unitVol = (unitbp.SizeX + unitbp.SizeZ + unitheight) / 3
    local army = unit:GetArmy()

    local fx1 = EffectTemplates.UncleanBeast.FoulGrasp01
    local fx2 = EffectTemplates.UncleanBeast.FoulGrasp02
    local fx3 = EffectTemplates.UncleanBeast.FoulGrasp05
    unit.AbilityData.FoulGraspEffects = {}
    # Brown multiply wisps
    for k, v in fx1 do
        emit = CreateAttachedEmitter( target, -2, army, v )
        emit:SetEmitterCurveParam('EMITRATE_CURVE', unitVol*1.7, 0.0)
        emit:SetEmitterCurveParam('LIFETIME_CURVE', dist, dist*0.45)
        emit:SetEmitterCurveParam('XDIR_CURVE', dirNorm[1], 0.3)
        emit:SetEmitterCurveParam('YDIR_CURVE', dirNorm[2], 0.0)
        emit:SetEmitterCurveParam('ZDIR_CURVE', dirNorm[3], 0.3)
        emit:SetEmitterCurveParam('X_POSITION_CURVE', 0.0, unitwidth)
        emit:SetEmitterCurveParam('Y_POSITION_CURVE', unitheight*0.4, unitheight)
        emit:SetEmitterCurveParam('Z_POSITION_CURVE', 0.0, unitwidth)
        table.insert( unit.AbilityData.FoulGraspEffects, emit )
    end
    # Dark red blood
    for k, v in fx2 do
        emit = CreateAttachedEmitter( target, -2, army, v )
        emit:SetEmitterCurveParam('EMITRATE_CURVE', unitVol*3.0, 0.0)
        emit:SetEmitterCurveParam('LIFETIME_CURVE', dist*0.6, dist*0.2)
        emit:SetEmitterCurveParam('XDIR_CURVE', dirNorm[1], 0.3)
        emit:SetEmitterCurveParam('ZDIR_CURVE', dirNorm[3], 0.3)
        emit:SetEmitterCurveParam('X_POSITION_CURVE', 0.0, unitwidth)
        emit:SetEmitterCurveParam('Y_POSITION_CURVE', unitheight*0.4, unitheight)
        emit:SetEmitterCurveParam('Z_POSITION_CURVE', 0.0, unitwidth)
        table.insert( unit.AbilityData.FoulGraspEffects, emit )
    end
    # Healing wisps on Unclean Beast
    AttachEffectsAtBone( unit, EffectTemplates.UncleanBeast.FoulGrasp03, -2, nil, nil, nil, unit.AbilityData.FoulGraspEffects )
    # Blood along the ground
    AttachEffectsAtBone( unit, EffectTemplates.UncleanBeast.FoulGrasp04, -2, nil, nil, nil, unit.AbilityData.FoulGraspEffects )
    # Inward rings at target
    for k, v in fx3 do
        emit = CreateAttachedEmitter( target, -2, army, v )
        emit:SetEmitterCurveParam('BEGINSIZE_CURVE', unitwidth*2.0, unitwidth)
        table.insert( unit.AbilityData.FoulGraspEffects, emit )
    end

    local data = {
        Instigator = unit,
        InstigatorBp = unit:GetBlueprint(),
        InstigatorArmy = unit:GetArmy(),
        Type = 'Spell',
        DamageAction = def.Name,
        Radius = 0,
        DamageSelf = true,
        DamageFriendly = true,
        ArmorImmune = true,
        CanBackfire = false,
        CanBeEvaded = false,
        CanCrit = false,
        CanDamageReturn = false,
        CanMagicResist = false,
        CanOverKill = true,
        IgnoreDamageRangePercent = true,
        Group = "UNITS",
    }

    for i = 1, def.Pulses do
        if not target:IsDead() and not unit:IsDead() and not unit.Silenced then
            Leech( unit, target, data, def.Amount )
            WaitSeconds(0.5)
        else
            EndGraspTriggersImmune(def, unit, target)
        end
    end
    EndGraspTriggersImmune(def, unit, target)
end

function EndGraspTriggersImmune(def, unit)
    #LOG("*DEBUG: Ending foul grasp")
    unit.Callbacks.OnWeaponFire:Remove(EndGraspTriggersImmune)
    unit.Callbacks.OnKilled:Remove(EndGraspTriggersImmune)
    unit.Callbacks.OnStunned:Remove(EndGraspTriggersImmune)
    unit.Callbacks.OnFrozen:Remove(EndGraspTriggersImmune)
    unit.Callbacks.OnMotionHorzEventChange:Remove(Moved)
    unit.Callbacks.OnAbilityBeginCast:Remove(EndGraspCancelTriggersImmune)

    local target = unit.AbilityData.FoulGraspTarget
    if target and not target:IsDead() then
        Buff.RemoveBuff(target, 'Immobile')
        Buff.RemoveBuff(target, 'HEPA01FoulGraspStun02') --
        if Buff.HasBuff(target, 'WeaponDisable') then
            Buff.RemoveBuff(target, 'WeaponDisable')
        end
        target.Callbacks.OnKilled:Remove(EndGraspTriggersImmune)
    end

    if unit.AbilityData.FoulGraspEffects then
        for kEffect, vEffect in unit.AbilityData.FoulGraspEffects do
            vEffect:Destroy()
        end
        unit.AbilityData.FoulGraspEffects = nil
    end

    if unit.AbilityData.FoulGraspThread then
        unit.AbilityData.FoulGraspThread:Destroy()
        unit.AbilityData.FoulGraspThread = nil
    end
    if Buff.HasBuff(unit, 'WeaponDisable') then
        Buff.RemoveBuff(unit, 'WeaponDisable')
    end
    if Buff.HasBuff(unit, 'StayOnTarget') then
        Buff.RemoveBuff(unit, 'StayOnTarget', unit)
        #Lets make sure that the last instance of the buff is removed
        if not Buff.HasBuff(unit, 'StayOnTarget') then
            unit:GetWeapon(1):SetStayOnTarget(false)
        end
    end

    Buff.RemoveBuff(unit, 'Immobile')
    unit.Character:PlayAction('CastFoulGraspEnd')
end

function EndGraspCancelTriggersImmune(def, unit)
    #LOG("*DEBUG: Ending foul grasp")
    unit.Callbacks.OnWeaponFire:Remove(EndGraspTriggersImmune)
    unit.Callbacks.OnKilled:Remove(EndGraspTriggersImmune)
    unit.Callbacks.OnStunned:Remove(EndGraspTriggersImmune)
    unit.Callbacks.OnFrozen:Remove(EndGraspTriggersImmune)
    unit.Callbacks.OnMotionHorzEventChange:Remove(Moved)
    unit.Callbacks.OnAbilityBeginCast:Remove(EndGraspCancelTriggersImmune)

    local target = unit.AbilityData.FoulGraspTarget
    if target and not target:IsDead() then
        Buff.RemoveBuff(target, 'Immobile')
        Buff.RemoveBuff(target, 'HEPA01FoulGraspStun02') --
        if Buff.HasBuff(target, 'WeaponDisable') then
            Buff.RemoveBuff(target, 'WeaponDisable')
        end
        target.Callbacks.OnKilled:Remove(EndGraspTriggersImmune)
    end

    if unit.AbilityData.FoulGraspEffects then
        for kEffect, vEffect in unit.AbilityData.FoulGraspEffects do
            vEffect:Destroy()
        end
        unit.AbilityData.FoulGraspEffects = nil
    end

    if unit.AbilityData.FoulGraspThread then
        unit.AbilityData.FoulGraspThread:Destroy()
        unit.AbilityData.FoulGraspThread = nil
    end
    if Buff.HasBuff(unit, 'WeaponDisable') then
        Buff.RemoveBuff(unit, 'WeaponDisable')
    end
    if Buff.HasBuff(unit, 'StayOnTarget') then
        Buff.RemoveBuff(unit, 'StayOnTarget', unit)
        #Lets make sure that the last instance of the buff is removed
        if not Buff.HasBuff(unit, 'StayOnTarget') then
            unit:GetWeapon(1):SetStayOnTarget(false)
        end
    end

    Buff.RemoveBuff(unit, 'Immobile')
    unit.Character:PlayAction('CastFoulGraspEnd')
end
-- Use those functions In Foul Grasp I
Ability.HEPA01FoulGrasp01.OnStartAbility = function(self,unit,params)
    local target = params.Targets[1]
    local thd = ForkThread(DrawLifeTriggersImmune, self, unit, target)
    unit.Trash:Add(thd)
    target.Trash:Add(thd)
    unit.AbilityData.FoulGraspThread = thd
end
-- Change descriptions to reflect which levels ignore Stun immunities.
Ability.HEPA01FoulGrasp01.Description = 'Unclean Beast clutches a target in its claws, stunning them and draining [GetDamageAmt] life over [GetDuration] seconds. This does not ignore stun immunities.'
Ability.HEPA01FoulGrasp02.Description = 'Unclean Beast clutches a target in its claws, stunning them and draining [GetDamageAmt] life over [GetDuration] seconds. This ignores stun immunities.'
Ability.HEPA01FoulGrasp03.Description = 'Unclean Beast clutches a target in its claws, stunning them and draining [GetDamageAmt] life over [GetDuration] seconds. This ignores stun immunities.'