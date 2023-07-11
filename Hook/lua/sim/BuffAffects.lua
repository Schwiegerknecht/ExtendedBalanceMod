-- Schwieger:
-- Decrease Cooldown Reduction maximum (aka CDR cap) to 50% (from 60%)
-- Make it compatible with UberFix, which introduces global variables for these
-- things, in this case CooldownCap.

-- Check if UberFix 1.06 is in table of active mods
local uberfix_version = nil
for k, mod in pairs(__active_mods) do
    local uberfix_index = string.find(mod.name, 'UberFix')
    if uberfix_index != nil then
        -- Filter out the substring with the needed mod name
        uberfix_version = string.sub(mod.name, uberfix_index)
    end
end
if uberfix_version == "UberFix 1.06" then -- UberFix is being used
    LOG('Found ', repr(uberfix_version), ' in active mods')
    CooldownCap = 0.5
else
    LOG('Did not find any version of UberFix in active mods')

    -- If no UberFix, overwrite the function
    function Cooldown( unit, buffName )
        local val = BuffCalculate(unit, buffName, 'Cooldown', 1)

        if val < 0.5 then
            val = 0.5
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