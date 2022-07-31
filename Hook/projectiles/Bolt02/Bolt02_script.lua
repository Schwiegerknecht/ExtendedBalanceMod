local Projectile = import('/lua/sim/Projectile.lua').Projectile
local Buff = import('/lua/sim/buff.lua')

-- Change the buff application to accept a table
-- Schwiegerkneccht
Bolt02 = Class(Projectile) {
    OnImpact = function(self, targetType, targetEntity)
        if(targetType == 'Unit' and targetEntity) then
            local launcher = self:GetLauncher()
            if(launcher and launcher:IsDead()) then
                launcher = targetEntity
            end
            
            # Determine Snipes damage boost, depending on distance traveled
            # Currently: Damage +10 for every 3 traveled
            local damageperrange = 10
            local rangeblock = 3
            local targpos = table.copy(targetEntity:GetPosition())
            local launcherpos = self.DamageData.LauncherPosition
            local targetdist = VDist2(launcherpos[1], launcherpos[3], targpos[1], targpos[3])
            local damageBuff = math.floor(targetdist/rangeblock)            
            self.DamageData.Amount = self.DamageData.Amount + (damageBuff * damageperrange)
            
            #if self.DamageData.Buff then -- Changed
            #    Buff.ApplyBuff(targetEntity, self.DamageData.Buff, self.DamageData.Instigator)
            #end
            if self.DamageData.Buff then
                local snipeBuffs = self.DamageData.Buff
                for _, buffs in ipairs(snipeBuffs) do
                    Buff.ApplyBuff(targetEntity, buffs, self.DamageData.Instigator)
                end
            end
        end
        Projectile.OnImpact(self, targetType, targetEntity)
    end,
}
TypeClass = Bolt02