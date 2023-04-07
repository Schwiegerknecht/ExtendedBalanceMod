-- Decrease Cooldown Reduction maximum (aka CDR cap) to 50% (from 60%)
function Cooldown( unit, buffName )
    local val = BuffCalculate(unit, buffName, 'Cooldown', 1)

    if val < 0.5 then
        val = 0.5
    end

    unit.Sync.CooldownMod = val
end

-- TEST because Armory uses wrong MaxHP values:
-- What happens if we pass current MaxHP instead of unitbphealth to BuffCalculate?
-- Answer: Utter chaos. Creeps OP and you can gain MaxHP by selling HP items at shop.

# idea: an alternative might be to add another step of calculation in BuffCalculate(). something in the same category as Adds and Mults that is calculated after them in the very end, e.g. FinalMult. ideally you could then replace Mult with FinalMult in all relevant buffs and it would also be usable for buffaffects other than MaxHealth

-- Make new BuffAffect which modifies all values produced by normal MaxHealth.
-- This is used to base Armory/FS calculation on the MaxHP after Low/High Grunt
-- Strength settings are taken into account.
-- As opposed to the normal BuffCalculate() (which first calculates Adds, then
-- Mults) this version calculates Mults first, then Adds (to prevent multiplying
-- e.g. Bloody Haze)

--[[
local prevMaxHealth = MaxHealth

BuffBlueprint {
    Name = 'ArmyMaxHealthDummyBuff',
    DisplayName = 'Dummy MaxHealth',
    Description = 'Gives no extra MaxHealth, is only used for value calculation',
    BuffType = 'MAXHEALTHDUMMYBUFF',
    Stacks = 'REPLACE',
    Debuff = false,
    --Icon = '/DGVampLord/NewVamplordBloodyHaze01',
    Duration = 1,
    DoNotPulseIcon = true,
    Affects = {
        MaxHealth = {Add = 0, AdjustHealth = true},
    },
}

function ArmyMaxHealth(unit, buffName)

    -- To get normal MaxHealth we calculate it with a dummy buff
    local oldMaxHealth = BuffCalculate(unit, 'ArmyMaxHealthDummyBuff', 'MaxHealth', unitbphealth)

    local newMaxHealth = BuffCalculateMultAdd(unit, buffName, 'ArmyMaxHealth', oldMaxHealth)
    unit:SetMaxHealth(newMaxHealth)
    unit.Sync.MaxHealth = newMaxHealth

    # Adjusts current health by the amount of the MaxHealth buff
    local maxHealthAdjustment = newMaxHealth - oldMaxHealth
    local currentHealth = unit:GetHealth()
    
    # If we are decreasing max health, then apply the descrease
        if maxHealthAdjustment < 0 then
            if(currentHealth + maxHealthAdjustment <= 0) then
                unit:AdjustHealth(-currentHealth + 1)
            else
                unit:AdjustHealth(maxHealthAdjustment)
            end
        # Otherwise we are increasing max health. The bp tells us whether or not to adjust the current health
        else
            if(Buffs[buffName].Affects.ArmyMaxHealth.AdjustHealth == true) then
                if(currentHealth + maxHealthAdjustment <= 0) then
                    unit:AdjustHealth(-currentHealth + 1)
                else
                    unit:AdjustHealth(maxHealthAdjustment)
                end
            end
        end
    
end
]]

--[[
Things as far as I understand (or guess them) to be:
BuffCalculate() keeps track of all sorts of BuffAffects on every Sync beat. It calculates all instances of each
type of BuffAffect, first the Adds, then the Mults.
This works because each BuffAffect function calls BuffCalculate
]]