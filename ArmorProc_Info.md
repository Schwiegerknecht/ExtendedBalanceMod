# Miscellaneous info on Armor Procs

The following functions are called in order from bottom to top when an Armor Proc happens:

`ArmorProc` (Ability.lua)
`DoArmorProcs` (ForgetUnit.lua)
`DoTakeDamage` (ForgetUnit.lua)
`OnDamage` (ForgetUnit.lua)
`DealDamage`
`DoDamage`


`DoTakeDamage` accesses the data from the attack event, so maybe try passing that as argument to `DoArmorProcs` and `ArmorProc` (in Ability.lua), so that OnArmorProc can access it in an ability blueprint.

## Passing the `def` argument (see code in next section):
{
  AbilityCategory="GENERIC",
  AbilityType="ArmorProc",
  ArmorProcChance=100,
  FromItem="Item_Artifact_200",
  Icon="../../../../../textures/ui/common/BuffFlags/buff_flag_valor",
  Name="Item_Artifact_200_ArmorProc",
  OnArmorProc=function: 19C527A8
}

## Passing the `params` argument:
nil

## Passing the `damageData` argument:
nil

## Passing the `instigator` argument:
nil

## Passing the `target` argument:
nil

# Attemps to access attacker's data in OnArmorProc

OnArmorProc = function(self, unit, instigator)
    # unit = Item owner, instigator = projectile that hits unit?
    LOG(repr(instigator.DamageData))
    -- if EntityCategoryContains(categories.HERO, instigator) then
    -- end
    # Check definition of OnArmorProc for arguments
    
    # Make sure the attacker is a Demigod before applying buff
    # Only apply buff if attacker is not dead
    #if instigator and not instigator:IsDead() and EntityCategoryContains(categories.HERO, unit) then
        #    Buff.ApplyBuff(instigator, 'Item_Artifact_200_ArmorProc', unit)
        #    AttachEffectsAtBone( unit, EffectTemplates.Items.Breastplate.NuadusWarplateProc, -2 )
        #end
    end
end

For OnArmorProc = function(self, unit, X) check for various arguments X:
Argument X: View function
Result
---
data: LOG(repr(data))
nil
---
params: LOG(repr(params))
nil
---

: LOG(repr(self:GetDamageTable()))
Seems to return the whole initial messages from start of game. Then Error:
    WARNING: 00:09:45: Error running OnImpact script in Entity /projectiles/boulder01/boulder01_proj.bp at 385dc600: ...migod\dgdata.zip\lua\common\items\artifact_items.lua(1518): attempt to call method `GetDamageTable' (a nil value)
         stack traceback:
         	...migod\dgdata.zip\lua\common\items\artifact_items.lua(1518): in function `OnArmorProc'
         	...amapps\common\demigod\dgdata.zip\lua\sim\ability.lua(614): in function `ArmorProc'
         	...apps\common\demigod\dgdata.zip\lua\sim\forgeunit.lua(798): in function `DoArmorProcs'
         	...apps\common\demigod\dgdata.zip\lua\sim\forgeunit.lua(1974): in function `DoTakeDamage'
         	...apps\common\demigod\dgdata.zip\lua\sim\forgeunit.lua(554): in function `OnDamage'
         	...amapps\common\demigod\dgdata.zip\lua\sim\globals.lua(67): in function `DealDamage'
         	...pps\common\demigod\dgdata.zip\lua\sim\projectile.lua(95): in function `DoDamage'
         	...pps\common\demigod\dgdata.zip\lua\sim\projectile.lua(221): in function <...pps\common\demigod\dgdata.zip\lua\sim\projectile.lua:216>
---
: LOG(repr(self:GetDamageTable()))
Same thing as one above, with warnings for the following projectiles and a nil value:
    WARNING: 00:02:41: Error running OnImpact script in Entity /projectiles/lightningball01/lightningball01_proj.bp
    WARNING: 00:02:41: Error running OnImpact script in Entity /projectiles/spellslow01/spellslow01_proj.bp
    WARNING: 00:02:43: Error running OnImpact script in Entity /projectiles/lightningball01/lightningball01_proj.bp
    WARNING: 00:02:21: Error running lua script: ...migod\dgdata.zip\lua\common\items\artifact_items.lua(1518): attempt to call method `GetDamageTable' (a nil value)
---
: LOG(repr(unit))
    WARNING: 00:01:15: Error running OnImpact script in Entity /projectiles/spellslow01/spellslow01_proj.bp at 386f4a80: out of memory
    WARNING: 00:01:16: Error running OnAnimEvent script in CScriptObject at 38cfd1f0: out of memory
    WARNING: 00:01:19: Error running lua script from destroyed thread: out of memory