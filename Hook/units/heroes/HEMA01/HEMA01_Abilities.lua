-- Increase deepfreeze consume damage
Ability.HEMA01FreezeStructure02.DamagePerBuff = 200 --normally 175
Ability.HEMA01FreezeStructure03.DamagePerBuff = 300 --normally 250
Ability.HEMA01FreezeStructure04.DamagePerBuff = 400 --normally 325

-- ExtendedBalanceMod start

--Decrease duration of Deep Freeze debuff to 5/5/5/5 (from 5/6/7/7)
for i=1,4 do
    Buffs['HEMA01FreezeSlow0'..i].Duration = 5
end

--Have HEMA01_Script.lua access these variables for stance switching time,
--making for easier tweaks if wanted
Ability.HEMA01SwitchIce.SwitchDuration = 0.8
Ability.HEMA01SwitchFire.SwitchDuration = 0.8

-- Clarify Stun Immunities in Frost Nova descriptions.
Ability.HEMA01FrostNova01.GetImmuneDuration = function(self) return Buffs['HEMA01FrostNova01HeroImmune'].Duration end
Ability.HEMA01FrostNova02.GetImmuneDuration = function(self) return Buffs['HEMA01FrostNova02HeroImmune'].Duration end
Ability.HEMA01FrostNova03.GetImmuneDuration = function(self) return Buffs['HEMA01FrostNova03HeroImmune'].Duration end
Ability.HEMA01FrostNova01.Description = 'Releases a wave of frost, freezing all enemies around the Torch Bearer, stunning them for [GetStun] seconds. Demigods are stunned for [GetDemigodStun] seconds, after which they receive Stun Immunity for [GetImmuneDuration] seconds.\n\nAll units have [GetMovementSlow]% Movement Speed for [GetDuration] seconds.'
Ability.HEMA01FrostNova02.Description = 'Releases a wave of frost, freezing all enemies around the Torch Bearer, stunning them for [GetStun] seconds. Demigods are stunned for [GetDemigodStun] seconds, after which they receive Stun Immunity for [GetImmuneDuration] seconds.\n\nAll units have [GetMovementSlow]% Movement Speed for [GetDuration] seconds.'
Ability.HEMA01FrostNova03.Description = 'Releases a wave of frost, freezing all enemies around the Torch Bearer, stunning them for [GetStun] seconds. Demigods are stunned for [GetDemigodStun] seconds, after which they receive Stun Immunity for [GetImmuneDuration] seconds.\n\nAll units have [GetMovementSlow]% Movement Speed for [GetDuration] seconds.'