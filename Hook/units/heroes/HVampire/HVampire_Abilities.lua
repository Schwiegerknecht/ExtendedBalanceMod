--Reduce Batswarm II to Range 25 to make range increases per level consistent at 20,25,30
Ability.HVampireBatSwarm02.RangeMax = 25

-- Schwiegerknecht
-- Testing if you can call the new class EliteCrawler

function RaiseVampire(abilDef, deadUnit)
    local inst = deadUnit.AbilityData.VampLord.VampireConversionInst
    if not inst or inst:IsDead() or deadUnit == inst then
        return
    end
    local rand = Random(1, 100)
    if rand > abilDef.VampireChance then
        return
    end

    local numVampires = ArmyBrains[inst:GetArmy()]:GetCurrentUnits(categories.elitecrawler)
    #LOG('*DEBUG: num vampires = ' .. numVampires)
    if(numVampires < inst.AbilityData.Vampire.VampireMax) then
        local pos = deadUnit:GetPosition()
        local orient = deadUnit:GetOrientation()
        local brainNum = inst:GetArmy()
        local vampireling = CreateUnitHPR('EliteCrawler', brainNum, pos[1], pos[2], pos[3], orient[1], orient[2],orient[3])
        if not vampireling then
            return
        end
		vampireling:AdjustHealth( vampireling:GetMaxHealth() )
        IssueGuard({vampireling}, inst)

        # Apply Coven buff to new vampire
        for i = 1, 3 do
            if(Validate.HasAbility(inst, 'HVampireCoven0' .. i)) then
                Buff.ApplyBuff(vampireling, 'HVampireCovenTarget0' .. i, inst)
            end
            if(Validate.HasAbility(inst, 'HVampireConversion0' .. i)) then
                Buff.ApplyBuff(vampireling, 'HVampireConversionTarget0' .. i, inst)
                vampireling:AdjustHealth(vampireling:GetMaxHealth())
            end
        end
    end
end

function Coven(buffDef, vampLord, buffName)
    if(vampLord and not vampLord:IsDead()) then
        if(not vampLord.AbilityData.Vampire) then
            vampLord.AbilityData.Vampire = {}
        end
        if buffDef.VampireMax then
            vampLord.AbilityData.Vampire.VampireMax = buffDef.VampireMax
        end

        # Apply Coven buff to existing vampires
        # Vampirelings Health is increased by the difference between their old max Health and their new max Health
        if(buffName) then
            local vampirelings = ArmyBrains[vampLord:GetArmy()]:GetListOfUnits(categories.elitecrawler, false)
            for k, v in vampirelings do
                if(v and not v:IsDead()) then
                    local oldHealth = v:GetHealth()
                    local oldMaxHealth = v:GetMaxHealth()
                    Buff.ApplyBuff(v, buffName, vampLord)
                    local newMaxHealth = v:GetMaxHealth()
                    local adjustedHealth = newMaxHealth - (oldMaxHealth - oldHealth)
                    v:AdjustHealth(adjustedHealth)
                end
            end
        end
    end
end