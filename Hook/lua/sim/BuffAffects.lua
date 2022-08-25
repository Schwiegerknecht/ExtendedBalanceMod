-- Decrease Cooldown Reduction maximum (aka CDR cap) to 50% (from 60%)
function Cooldown( unit, buffName )
    local val = BuffCalculate(unit, buffName, 'Cooldown', 1)

    if val < 0.5 then
        val = 0.5
    end

    unit.Sync.CooldownMod = val
end