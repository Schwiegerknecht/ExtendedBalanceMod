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

-- Schwiegerknecht start
--Decrease the damage mitigation by Acclimation to 25% (down from 40%)
Buffs.HEPA01Acclimation.Affects.DamageTakenMult = {Add = -0.25}

-- Decrease Ooze Attack Speed Debuff to 0/10/20/30 (from 10/20/30/40)
for i = 1,4 do
    Buffs['HEPA01Ooze0'..i].Affects.RateOfFire.Mult = -0.1*i + 0.1
end
Ability['HEPA01Ooze01'].Description = 'Unclean Beast oozes virulent bodily fluids. While active, nearby enemies take [GetDebuffDamage] damage per second.\n\nUnclean Beast loses [GetDebuffSelfDamage] Health per second.'

# Increase Ooze self damage, scaling off hero level:
#################################################################################################################
-- 20 + herolevel*0/1/2/3 dmg (from 20/30/40/50)
-- This means 20/30/40/50 dmg at lvl 10, and 20/40/60/80 dmg at lvl 20
-- Maxing Ooze at lvl 1/4/7/10 would for the first 10 levels do dmg as follows:
-- 20//20/20/24/25/26/34/36/38/50, after that incrementing in steps of 3.

# The for-loop, in case somebody gets it to work:
-- Apparently local variables do the trick, else function declarations within
-- the outer loop seem to increment i themselves. So it's like nested loops and
-- OnAuraPulse only returns the value calculated with the highest value of i.
for i = 2,4 do
    local ooze = 'HEPA01Ooze0'..i
    local oozeSelfDmg = 'HEPA01OozeSelf0'..i
    Ability[ooze].SelfDmgMultiplier = i - 1
    Ability[ooze].OnAuraPulse = function(self, unit, params)
        local aiBrain = unit:GetAIBrain()
        local hero = aiBrain:GetHero()
        local herolvl = hero:GetLevel()
        local loseHealth = -(20 + herolvl * (self.SelfDmgMultiplier))

        Buffs[oozeSelfDmg].Affects.Health.Add = loseHealth
        
        if unit.AbilityData.OozeOn then
            Buff.ApplyBuff(unit, oozeSelfDmg, unit)
            if unit:GetHealth() < 100 then
                local params = { AbilityName = 'HEPA01OozeOff'}
                Abil.HandleAbility(unit, params)
            end
        end
    end
end

-- Change Descriptions
Ability.HEPA01Ooze02.Description = 'Unclean Beast oozes virulent bodily fluids. While active, nearby enemies take [GetDebuffDamage] damage per second and their Attack Speed is slowed by [GetDebuffSlow]%.\n\nUnclean Beast loses Health per second equivalent to 20 + UB\'s level.'
Ability.HEPA01Ooze03.Description = 'Unclean Beast oozes virulent bodily fluids. While active, nearby enemies take [GetDebuffDamage] damage per second and their Attack Speed is slowed by [GetDebuffSlow]%.\n\nUnclean Beast loses Health per second equivalent to 20 + (UB\'s level * 2).'
Ability.HEPA01Ooze04.Description = 'Unclean Beast oozes virulent bodily fluids. While active, nearby enemies take [GetDebuffDamage] damage per second and their Attack Speed is slowed by [GetDebuffSlow]%.\n\nUnclean Beast loses Health per second equivalent to 20 + (UB\'s level * 3).'




#################################################################################################################
# Make Foul Grasp I not ignore stun immunities anymore
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
-- HEPA01FoulGraspStun01 to HEPA01FoulGraspStun02
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

# Foul Grasp changes end
#################################################################################################################


#################################################################################################################
# Plague Fix
#################################################################################################################
-- Remove Plague animations
for i = 1,2 do
    Buffs['HEPA01Plague0'..i].Effects = nil
    Buffs['HEPA01Plague0'..i].EffectsBone = nil
end

for i = 1,2 do
-- Set Pulses to 10 over 10 seconds (from 30 pulses over 30 seconds)
    Buffs['HEPA01Plague0'..i].Duration = 10
    Buffs['HEPA01Plague0'..i].DurationPulse = 10 -- This is the number of pulses
-- Increase damage per tick to 15/25 (from 10/15)
    Buffs['HEPA01Plague0'..i].Affects.Health.Add = -(15*i)
-- Set MaxPlaguedUnits for both Plagues to 10
    Ability['HEPA01Plague0'..i].MaxPlaguedUnits = 10
end
-- Set Chance to spread Plague to 60/90 (normally 100/100)
Ability.HEPA01Plague01.SpreadAffectChance = 60
Ability.HEPA01Plague02.SpreadAffectChance = 90

-- Adjust description
Ability['HEPA01Plague01'].GetSpreadChance = function(self) return Ability['HEPA01Plague01'].SpreadAffectChance end
Ability['HEPA01Plague02'].GetSpreadChance = function(self) return Ability['HEPA01Plague02'].SpreadAffectChance end
Ability['HEPA01Plague01'].Description = 'When Unclean Beast deals damage, it has a chance to start a plague, dealing [GetDamageAmt] damage over [GetDuration] seconds and having a [GetSpreadChance]% chance to spread to nearby units.\n\nAnything that survives the plague becomes immune to it for [GetImmuneDuration] seconds.'
Ability['HEPA01Plague02'].Description = 'When Unclean Beast deals damage, it has a chance to start a plague, dealing [GetDamageAmt] damage over [GetDuration] seconds and having a [GetSpreadChance]% chance to spread to nearby units.\n\nAnything that survives the plague becomes immune to it for [GetImmuneDuration] seconds.'


# Implement working counter to limit number of infected units
#############################################################

--[[
    The Plague code contained callbacks that were commented because they didn't work.
    They should have decremented a NumPlaguedUnits whenever a Plague buff ran out or
    an infected unit died. The counter was set up in UB's unit.Plague and to access
    that the infected units needed to access their own unit.PlagueInstance.Instigator.
    My guess is that this wasn't possible because the infected unit was already dead.
    
    The nasty workaround below just sets up the counter in the global Buffs table. 
    Hopefully the counter is also decremented when UB is dead.
]]

-- Set up our counter of infected units in the BuffBlueprint. Used for Plague02 also!
Buffs.HEPA01Plague01.NumPlaguedUnits = 0

-- Add a comparison of current and maximum infected units in Plague(Spread) functions 01 and 02
Ability.HEPA01Plague01.Plague = function(self, unit, target, data)
    -- Only spread Plague if we are below the maximum number of infected
    if (Random(1, 100) < self.TriggerChance) and
       (Buffs.HEPA01Plague01.NumPlaguedUnits < Ability.HEPA01Plague01.MaxPlaguedUnits) then
        #LOG("*DEBUG: Applying Initial Plague to: "..target:GetUnitId())

        if unit:IsDead() or IsAlly(target:GetArmy(), unit:GetArmy()) or
           data.DamageAction == 'HEPA01Plague01' or data.DamageAction == 'HEPA01Plague02' or (data.DamageAction and Ability[data.DamageAction].FromItem) then
            return
        end

        if target:IsDead() or EntityCategoryContains(categories.STRUCTURE, target) then
            local targets = unit:GetAIBrain():GetUnitsAroundPoint((categories.MOBILE - categories.UNTARGETABLE), unit:GetPosition(), self.SpreadAffectRadius, 'Enemy')
            PlagueSpread01( unit, targets, self.SpreadAffectChance )
        else
            # Early out on application of plague here, rather than allow the buff system Manage it, to
            # properly track number of affected targets
            if Buff.HasBuff(target, 'HEPA01Plague01') or Buff.HasBuff(target, 'HEPA01PlagueImmune') or Buff.HasBuff(target, 'HEPA01Plague02') then
                return
            end
            # Create initial triggered plague effects
            self:PlagueEffect( unit, target:GetPosition(), target:GetEffectBuffClassification() )

            # Add affected unit specific plague data
            target.PlagueInstance = {
                Instigator = unit,
                InstigatorBrain = unit:GetAIBrain(),
                IgnoreAffectPulses = true,
                NumIgnoredPulses = 0,
            }

            FloatTextAt(target:GetFloatTextPosition(), "<LOC floattext_0010>PLAGUE!", 'Plague')
            if(Validate.HasAbility(unit, 'HEPA01Plague02')) then
                Buff.ApplyBuff(target, 'HEPA01Plague02', unit, unit:GetArmy())
            else
                Buff.ApplyBuff(target, 'HEPA01Plague01', unit, unit:GetArmy())
            end
            -- Add counter here
            Buffs.HEPA01Plague01.NumPlaguedUnits = Buffs.HEPA01Plague01.NumPlaguedUnits + 1
            LOG("*DEBUG: Plague01 NumPlaguedUnits: "..Buffs.HEPA01Plague01.NumPlaguedUnits)
            if Buffs.HEPA01Plague01.NumPlaguedUnits > Ability.HEPA01Plague01.MaxPlaguedUnits then
                LOG("*WARNING: NumPlaguedUnits > MaxPlaguedUnits ("..Ability.HEPA01Plague01.MaxPlaguedUnits..")")
            end
        end
    end
end
PlagueSpread01 = function( instigator, targets, chance )
    -- Only spread Plague if we are below the maximum number of infected
    if Buffs.HEPA01Plague01.NumPlaguedUnits < Ability.HEPA01Plague01.MaxPlaguedUnits then
        local instBrain = instigator:GetAIBrain()

        for k, vUnit in targets do
            if instigator:IsDead() or not instigator.Plague then
                return
            end

            if Random(1, 100) < chance then
                if Buff.HasBuff(vUnit, 'HEPA01PlagueImmune') or Buff.HasBuff(vUnit, 'HEPA01Plague02') or Buff.HasBuff(vUnit, 'HEPA01Plague01') then
                    continue
                end

                CreateTemplatedEffectAtPos( 'UncleanBeast', 'PlagueInfectedTrigger02', vUnit:GetEffectBuffClassification(), vUnit:GetArmy(), vUnit:GetPosition()  )
                if instBrain then
                    local heroes = instBrain:GetListOfUnits(categories.HERO, false)
                    if table.getn(heroes) > 0 then

                        #LOG("*DEBUG: Applying Plague from "..instBrain.Name.." and hero ".. heroes[1]:GetUnitId().. " to unit ".. vUnit:GetUnitId())
                        vUnit.PlagueInstance = {
                            Instigator = instigator,
                            InstigatorBrain = instBrain,
                            IgnoreAffectPulses = true,
                            NumIgnoredPulses = 0,
                        }

                        -- Not needed anymore:
                        -- instigator.Plague.NumPlaguedUnits = instigator.Plague.NumPlaguedUnits + 1
                        -- Our new counter:
                        Buffs.HEPA01Plague01.NumPlaguedUnits = Buffs.HEPA01Plague01.NumPlaguedUnits + 1
                        LOG("*DEBUG: PlagueSpread01 NumPlaguedUnits: "..Buffs.HEPA01Plague01.NumPlaguedUnits)
                        if Buffs.HEPA01Plague01.NumPlaguedUnits > Ability.HEPA01Plague01.MaxPlaguedUnits then
                            LOG("*WARNING: NumPlaguedUnits ("..Buffs.HEPA01Plague01.NumPlaguedUnits..") > MaxPlaguedUnits ("..Ability.HEPA01Plague01.MaxPlaguedUnits..")")
                        end
                        if(Validate.HasAbility(instigator, 'HEPA01Plague02')) then
                            Buff.ApplyBuff(vUnit, 'HEPA01Plague02', heroes[1], heroes[1]:GetArmy())
                        else
                            Buff.ApplyBuff(vUnit, 'HEPA01Plague01', heroes[1], heroes[1]:GetArmy())
                        end
                        FloatTextAt(vUnit:GetFloatTextPosition(), "<LOC floattext_0011>PLAGUED!", 'Plague')
                        break
                    end
                end
            end
        end
    else
        LOG("*DEBUG: Not doing PlagueSpread01 because MaxPlaguedUnits has been reached.")
    end
end
Ability.HEPA01Plague02.Plague = function(self, unit, target, data)
    -- Only spread Plague if we are below the maximum number of infected
    if (Random(1, 100) < self.TriggerChance) and
       (Buffs.HEPA01Plague01.NumPlaguedUnits < Ability.HEPA01Plague02.MaxPlaguedUnits) then
        #LOG("*DEBUG: Applying Initial Plague to: "..target:GetUnitId())

        if unit:IsDead() or IsAlly(target:GetArmy(), unit:GetArmy()) or data.DamageAction == 'HEPA01Plague02' or (data.DamageAction and Ability[data.DamageAction].FromItem) then
            return
        end

        if target:IsDead() or EntityCategoryContains(categories.STRUCTURE, target) then
            local targets = unit:GetAIBrain():GetUnitsAroundPoint((categories.MOBILE - categories.UNTARGETABLE), unit:GetPosition(), self.SpreadAffectRadius, 'Enemy')
            PlagueSpread02( unit, targets, self.SpreadAffectChance )
        else
            # Early out on application of plague here, rather than allow the buff system Manage it, to
            # properly track number of affected targets
            if Buff.HasBuff(target, 'HEPA01Plague02') or Buff.HasBuff(target, 'HEPA01PlagueImmune') then
                return
            end

            # Create initial triggered plague effects
            self:PlagueEffect( unit, target:GetPosition(), target:GetEffectBuffClassification() )

            # Add affected unit specific plague data
            target.PlagueInstance = {
                Instigator = unit,
                InstigatorBrain = unit:GetAIBrain(),
                IgnoreAffectPulses = true,
                NumIgnoredPulses = 0,
            }

            FloatTextAt(target:GetFloatTextPosition(), "<LOC floattext_0012>PLAGUE!", 'Plague')
            if(Validate.HasAbility(unit, 'HEPA01Plague02')) then
                Buff.ApplyBuff(target, 'HEPA01Plague02', unit, unit:GetArmy())
            else
                Buff.ApplyBuff(target, 'HEPA01Plague01', unit, unit:GetArmy())
            end
            -- Add counter here
            Buffs.HEPA01Plague01.NumPlaguedUnits = Buffs.HEPA01Plague01.NumPlaguedUnits + 1
            LOG("*DEBUG: Plague02 NumPlaguedUnits: "..Buffs.HEPA01Plague01.NumPlaguedUnits)
            if Buffs.HEPA01Plague01.NumPlaguedUnits > Ability.HEPA01Plague02.MaxPlaguedUnits then
                LOG("*WARNING: NumPlaguedUnits > MaxPlaguedUnits ("..Ability.HEPA01Plague02.MaxPlaguedUnits..")")
            end
        end
    end
end
PlagueSpread02 = function( instigator, targets, chance )
    -- Only spread Plague if we are below the maximum number of infected
    if Buffs.HEPA01Plague01.NumPlaguedUnits < Ability.HEPA01Plague02.MaxPlaguedUnits then
        local instBrain = instigator:GetAIBrain()

        for k, vUnit in targets do
            if instigator:IsDead() or not instigator.Plague then
                return
            end

            if Random(1, 100) < chance then
                if Buff.HasBuff(vUnit, 'HEPA01Plague02') or Buff.HasBuff(vUnit, 'HEPA01PlagueImmune') then
                    continue
                end

                CreateTemplatedEffectAtPos( 'UncleanBeast', 'PlagueInfectedTrigger02', vUnit:GetEffectBuffClassification(), vUnit:GetArmy(), vUnit:GetPosition()  )
                if instBrain then
                    local heroes = instBrain:GetListOfUnits(categories.HERO, false)
                    if table.getn(heroes) > 0 then

                        #LOG("*DEBUG: Applying Plague from "..instBrain.Name.." and hero ".. heroes[1]:GetUnitId().. " to unit ".. vUnit:GetUnitId())
                        vUnit.PlagueInstance = {
                            Instigator = instigator,
                            InstigatorBrain = instBrain,
                            IgnoreAffectPulses = true,
                            NumIgnoredPulses = 0,
                        }

                        -- Not needed anymore:
                        -- instigator.Plague.NumPlaguedUnits = instigator.Plague.NumPlaguedUnits + 1
                        -- Our new counter:
                        Buffs.HEPA01Plague01.NumPlaguedUnits = Buffs.HEPA01Plague01.NumPlaguedUnits + 1
                        LOG("*DEBUG: PlagueSpread02 NumPlaguedUnits: "..Buffs.HEPA01Plague01.NumPlaguedUnits)
                        if Buffs.HEPA01Plague01.NumPlaguedUnits > Ability.HEPA01Plague02.MaxPlaguedUnits then
                            LOG("*WARNING: NumPlaguedUnits ("..Buffs.HEPA01Plague01.NumPlaguedUnits..") > MaxPlaguedUnits ("..Ability.HEPA01Plague02.MaxPlaguedUnits..")")
                        end
                        if(Validate.HasAbility(instigator, 'HEPA01Plague02')) then
                            Buff.ApplyBuff(vUnit, 'HEPA01Plague02', heroes[1], heroes[1]:GetArmy())
                        else
                            Buff.ApplyBuff(vUnit, 'HEPA01Plague01', heroes[1], heroes[1]:GetArmy())
                        end
                        FloatTextAt(vUnit:GetFloatTextPosition(), "<LOC floattext_0013>PLAGUED!", 'Plague')
                        break
                    end
                end
            end
        end
    else
        LOG("*DEBUG: Not doing PlagueSpread02 because MaxPlaguedUnits has been reached.")
    end
end

-- Activate the Callbacks in both Plague Buffs that decrement
-- the counter if the unit is killed or the buff removed
for i = 1,2 do
    Buffs['HEPA01Plague0'..i].OnApplyBuff = function( self, unit, instigator )
        unit.Callbacks.OnKilled:Add(self.UnitOnKilledCallback, self)
    end
end
for i = 1,2 do
    Buffs['HEPA01Plague0'..i].OnBuffRemove = function(self, unit)
        LOG("*DEBUG: Removing Buff")
        self:DecrementPlagueCounter(unit)
        Buff.ApplyBuff(unit, 'HEPA01PlagueImmune', unit)
        -- Remove the OnKilled Callback to prevent decrementing twice in case it dies before getting reinfected.
        unit.Callbacks.OnKilled:Remove(self.UnitOnKilledCallback)
    end
end
for i = 1,2 do
    Buffs['HEPA01Plague0'..i].UnitOnKilledCallback = function( self, unit )
        unit.Callbacks.OnKilled:Remove(self.UnitOnKilledCallback)
        LOG("*DEBUG: Unit killed")
        self:DecrementPlagueCounter(unit)
    end
end

for i = 1,2 do
    Buffs['HEPA01Plague0'..i].DecrementPlagueCounter = function(self, unit)
        Buffs.HEPA01Plague01.NumPlaguedUnits = Buffs.HEPA01Plague01.NumPlaguedUnits - 1
        if Buffs.HEPA01Plague01.NumPlaguedUnits < 0 then
            Buffs.HEPA01Plague01.NumPlaguedUnits = 0
        end
        if unit.PlagueInstance then
            unit.PlagueInstance = nil
        end
        LOG("*DEBUG: Decremented NumPlaguedUnits to "..Buffs.HEPA01Plague01.NumPlaguedUnits)
    end
end