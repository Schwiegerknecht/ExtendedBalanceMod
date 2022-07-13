# Fix Sacrifice so it actually works. Requires removing 'and not unit == v'.
# Also uses the local allies variable from DivineJusticeBuffFunction because
# the original would also heal towers which does not seem to be the intention.

for i=1,3 do
    Ability.['HOculusSacrifice0'..i].AreaHeal = function(self, unit, data)
        if data.Amount > self.MinHit then
            
            local HealAmt = data.Amount * self.PercentHeal
            local pos = unit:GetPosition()
            local radius = self.HealRadius
    
                       
            local data = {
                Instigator = unit,
                InstigatorBp = unit:GetBlueprint(),
                InstigatorArmy = unit:GetArmy(),
                Amount = HealAmt * -1,
                IgnoreDamageRangePercent = true,
                Type = 'Spell',
                DamageAction = self.Name,
                DamageSelf = false,
                DamageFriendly = true,
                Origin = pos,
                CanDamageReturn = false,
                CanCrit = false,
                CanBackfire = false,
                CanBeEvaded = false,
                CanMagicResist = true,
                ArmorImmune = true,
                Group = "UNITS",
            }
            
            # spell at center of Oculus
            AttachEffectsAtBone( unit, EffectTemplates.Oculus.Sacrifice01, -2 )
            
            -- local entities = GetEntitiesInSphere(data.Group, pos, self.HealRadius ) -- Changed
            -- entities = EntityCategoryFilterDown( categories.ALLUNITS - categories.UNTARGETABLE, entities ) -- Changed
            -- Alternative from DivineJusticeBuffFunction so as not to heal towers:
            local aiBrain = unit:GetAIBrain()
            local allies = aiBrain:GetUnitsAroundPoint( categories.MOBILE, unit.Position, self.HealRadius, 'Ally' )
    
    
            for k,v in allies do
                if IsAlly(unit:GetArmy(), v:GetArmy()) then -- 'and not unit == v' was the problem for some reason
                -- Alternative from DivineJusticeBuffFunction:
                -- if (v and not v:IsDead() and not EntityCategoryContains(categories.NOBUFFS, v) and not EntityCategoryContains(categories.UNTARGETABLE, v)) then
                    DealDamage(data, v)
                    
                    ## check to not play effects on oculus
                    if v != unit then
                        # Heal effects at targeted unit
                        AttachBuffEffectAtBone( v, 'Heal05', -2 );
                    end
                end
            end             
        end
    end
end

__moduleinfo.auto_reload = true
