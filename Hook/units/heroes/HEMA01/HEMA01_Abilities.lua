-- Increase deepfreeze consume damage
Ability.HEMA01FreezeStructure02.DamagePerBuff = 200 --normally 175
Ability.HEMA01FreezeStructure03.DamagePerBuff = 300 --normally 250
Ability.HEMA01FreezeStructure04.DamagePerBuff = 400 --normally 325

--Have HEMA01_Script.lua access these variables for stance switching time,
--making for easier tweaks if wanted - Schwiegerknecht 
Ability.HEMA01SwitchIce.SwitchDuration = 0.8
Ability.HEMA01SwitchFire.SwitchDuration = 0.8