-- Schwieger:
-- Decrease Cooldown Reduction maximum (aka CDR cap) to 50% (from 60%)
-- Make it compatible with UberFix, which introduces global variables for these
-- things, in this case CooldownCap.

-- Check if UberFix 1.06 is active
local uberfix_active = false
for k, mod in pairs(__active_mods) do
    if mod.uid == "003B56DC-6BF9-11DF-8A4C-A7DEDFD71052" then -- check for UberFix 1.06
        uberfix_active = true
    end
end
if uberfix_active == true then
    CooldownCap = 0.5
else
    -- If no UberFix, introduce that here
    CooldownCap = 0.5
    
    function Cooldown( unit, buffName )
        local val = BuffCalculate(unit, buffName, 'Cooldown', 1)

        if val < CooldownCap then
            val = CooldownCap
        end

        unit.Sync.CooldownMod = val
    end

    -- If no UberFix then we throw in the updated Absorption function from there as well
    --Mithy: Full tabled re-write of Absorption to fix all overlap and refresh issues.
    function Absorption( unit, buffName, buffDef, buffAffects, instigator, instigatorArmy, bAfterRemove )
        local abData = unit.AbsorptionData
        local abAffects = buffAffects.Absorption

        --Mult is a damage-taken multiplier for absorption.  Min 0.1 (10%), no max.
        if abAffects.Mult then
            --Bypass BuffCalculate to get mults without adds factored in
            local mult = 1
            for k, v in abAffects do
                if v.Mult then
                    mult = mult + (v.Mult * v.Count)
                end
            end
            abData.Mult = math.max(mult, 0.1)
        end

        --Add/remove absorption amounts
        if abAffects.Add then
            if not bAfterRemove then
                local abBuff = {
                    Absorption = abAffects.Add,
                    BuffName = buffName,
                }
                table.insert(abData.Buffs, abBuff)
            else
                --Remove oldest (lowest key) instance of this buff name
                for i=1, (table.getn(abData.Buffs) or 1) do
                    if abData.Buffs[i].BuffName == buffName then
                        table.remove(abData.Buffs, i)
                        break
                    end
                end
            end
        end

        --Add up total absorption amounts and set sync var
        local total = 0
        for k, v in abData.Buffs do
            total = total + v.Absorption
        end
        unit.Sync.Absorption = total
        unit.Sync.AbsorptionMult = abData.Mult
    end
end

-- Add Mithy's Mana Leech.
-- New BuffAffects functions:
--   EnergyAdd
--   EnergyLeech
-- New Variables:
--   EnergyAddCap
--   EnergyLeechCap
--   LifestealCap
--   CooldownCap

if uberfix_active == false then
    EnergyAddCap = false

    --EnergyAdd - acts like life steal, adding mana based on damage done
    function EnergyAdd(unit, buffName, buffDef, buffAffects, instigator, instigatorArmy, afterRemove)
        local val = BuffCalculate(unit, buffName, 'EnergyAdd', 0)
        if EnergyAddCap then
            val = math.min(val, EnergyAddCap)
        end
        unit.EnergyAdd = val
        unit.Sync.EnergyAdd = val
    end
    
    EnergyLeechCap = false
    --EnergyLeech - as above, but actually takes mana from the target based on damage done and adds that amount
    function EnergyLeech(unit, buffName, buffDef, buffAffects, instigator, instigatorArmy, afterRemove)
        local val = BuffCalculate(unit, buffName, 'EnergyLeech', 0)
        if EnergyLeechCap then
            val = math.min(val, EnergyLeechCap)
        end
        unit.EnergyLeech = val
        unit.Sync.EnergyLeech = val
    end
   
    --EnergyDrain - one-time transfer like Energy, except it steals from the target like EnergyLeech and adds that amount to the instigator
    --Add must be >0 (although this amount is actually subtracted from the target)
    function EnergyDrain(unit, buffName, buffDef, buffAffects, instigator, instigatorArmy, afterRemove)
        --Make sure instigator is alive, skip on remove since we're instant
        if afterRemove or not instigator or instigator:IsDead() then return end

        local amount = buffAffects.EnergyDrain.Add
        local text = not buffAffects.EnergyDrain.NoFloatText
        if amount > 0 then
            --Let ForgeUnit.DoEnergyLeech handle the checks and energy transaction
            instigator:DoEnergyLeech(unit, amount, 1, text)
        end

        --Nil out this buff affect table on the recipient unit, since it's a one-off like energy and health (not worth hard-overriding Buff.ApplyBuff for)
        unit.Buffs.Affects.EnergyDrain = nil
    end
    
    LifeStealCap = false
    function LifeSteal( unit, buffName )
        local val = BuffCalculate(unit, buffName, 'LifeSteal', 0)
        --New global cap
        if LifeStealCap then
            val = math.min(val, LifeStealCap)
        end
        unit.LifeSteal = val
    
        --Added sync var for UI display
        unit.Sync.LifeSteal = val
    end
end