--Increase Rally duration to 10 seconds up from 5
Buffs.HOakRally.Duration = 10
Buffs.HOakRallyHeal.Duration = 10

-- ExtendedBalanceMod start

-- Shield 
-- Decrease Shield durations to 2/3/4/4.5 (from 3/4/5/6; 3/4/6/6 in vanilla).
Buffs.HOAKShield01.Duration = 2
Buffs.HOAKShield02.Duration = 3
Buffs.HOAKShield03.Duration = 4
Buffs.HOAKShield04.Duration = 4.5
-- Also create a progression from damage immunity to cleanse to damage and debuff immunity
-- Remove the cleanse from Shield I, so now it does what the description says.
Buffs.HOAKShield01.OnBuffAffect = function(self, unit, instigator)
    unit:SetInvulnerableMesh(true)

    # Shield activation effects
    FxShieldActivate( unit )
end
-- Adapt description for Shield II to include the debuff cleanse
Ability.HOAKShield02.Description = 'Oak grants a shield to a target, cleansing them from debuffs and making them immune to damage for [GetBuffDuration] seconds.'
-- Adapt description for Shield III to include debuff immunity
Ability.HOAKShield03.Description = 'Oak grants a shield to a target, making them immune to damage and debuffs for [GetBuffDuration] seconds.'
-- Adapt description for Shield IV to include debuff immunity
Ability.HOAKShield04.Description = 'Oak grants a shield to a target, making them immune to damage and debuffs for [GetBuffDuration] seconds. Also, this powerful version of Shield heals for [GetHealAmount].'

-- Increase Penitence Cooldown to 8/8/8/8 (from 7/7/7/7)
for i = 1,4 do
    Ability['HOAKPenitence0'..i].Cooldown = 8
end