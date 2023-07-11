-- Schwieger: Modified so the OnArmorProc call accepts the attack event data
-- coming from DoTakeDamage in ForgeUnit.lua
-- Requires overwriting the function so that OnArmorProc is not called twice.
function ArmorProc(unit, abilityName, data) -- changed
    local def = Ability[abilityName]

    # Find out if the proc goes off for this weapon proc; do this first as it is pretty cheap
    local rand = Random(1, 100)
    if rand > def.ArmorProcChance then
            return
    end

    # Make sure the unit can actually use this ability
    if not ValidateAbility(unit, { AbilityName = abilityName } ) then
        return false
    end

    # LOG( '*DEBUG: Weapon proc = ' .. abilityName .. ' - Weapon = ' .. damageData.DamageAction .. '; Tick = ' .. GetGameTick() )

    # If the ability is granted by an item, use a charge if necessary
    local item = nil
    if def.FromItem then

        # Find the item; can be in any of the Inventories of the unit
        local found = false
        for invName,inv in unit.Inventory do
            item = inv:FindItem(def.FromItem)
            if item then
                found = true
                break
            end
        end
        if not found then
            error('Unit does not have item (' .. def.FromItem .. ') that granted ability ' .. abilityName)
        end

        if item.Blueprint.Charges then
            if item:HasCharge() then
                item:UseCharge()
            else
                WARN('HandleAbility called on an item granted ability with no charges left.')
                WARN('Ability = ', abilityName)
                WARN('ItemName = ', item.Sync.BlueprintId)
                return false
            end
        end
    end

    -- Pass on instigator here
    def:OnArmorProc(unit, data)

    # If we have a cost to use this proc; then use the cost
    if def.EnergyCost then
        unit:UseEnergy(def.EnergyCost)
    end

    if def.Cooldown > 0 then
        if not def.SharedCooldown then
            unit.Sync.Abilities[abilityName].Cooldown = GetGameTimeSeconds()
        else
            unit.Sync.SharedCooldowns[def.SharedCooldown] = GetGameTimeSeconds()
        end
        SyncAbilities(unit)
    end

    # If this ability was granted by an item and the item is consumable, do consume.
    if item and item.Blueprint.Consumable then
        item:Consume()
    end

    return true
end