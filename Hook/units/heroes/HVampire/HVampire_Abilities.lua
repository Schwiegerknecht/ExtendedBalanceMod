--Reduce Batswarm II to Range 25 to make range increases per level consistent at 20,25,30
Ability.HVampireBatSwarm02.RangeMax = 25


-- Schwiegerknecht start

-- Make description for Vampiric Aura more accurate
Ability.HVampireVampiricAura01.GetLifeSteal = function(self) return math.floor( Buffs['HVampireVampiricAura01'].Affects.LifeSteal.Add * 100) end
Ability.HVampireVampiricAura01.Description = 'Lord Erebus gains a [GetLifeSteal]% Life Steal Aura.'


--Increase Army of the Night buffs: 40% Attack Speed (from 5) and + 100% Lifesteal (from 10%)
Buffs.HVampireArmyoftheNight.Affects.RateOfFire.Mult = 0.4
Buffs.HVampireArmyoftheNight.Affects.LifeSteal.Add = 1.0

-- Give Nightcrawlers a WeaponProc to reduce armor
-- Add ability via Buff in the ArmyBonusBlueprint
Buffs.HVampireArmyoftheNight.OnBuffAffect = function(self, unit, instigator)
    Abil.AddAbility(unit, 'HVampireArmyoftheNightMinionAbil', true)
end
-- Give WeaponProc to Night Walkers
AbilityBlueprint {
    Name = 'HVampireArmyoftheNightMinionAbil',
    DisplayName = 'Army of the Night Armor Shred',
    Description = 'Erebus\' Night Walkers have a [GetProcChance]% chance on each auto attack to reduce their targets armor by [GetArmorShred] for [GetDuration] seconds. This also works on structures.',
    GetProcChance = function(self) return math.floor( self.WeaponProcChance ) end,
    GetArmorShred = function(self) return math.floor( Buffs['HVampireArmyoftheNightProcDebuff'].Affects.Armor.Add * -1) end,
    GetDuration = function(self) return math.floor( Buffs['HVampireArmyoftheNightProcDebuff'].Duration) end,
    AbilityType = 'WeaponProc',
    WeaponProcChance = 50,
    OnWeaponProc = function(self, unit, target, damageData)
        if EntityCategoryContains(categories.ALLUNITS, target) and not EntityCategoryContains(categories.UNTARGETABLE, target) then
            Buff.ApplyBuff(target, 'HVampireArmyoftheNightProcDebuff', unit)
        end
    end,
    Icon = '/DGVampLord/NewVamplordArmyoftheNight01',
}
-- Debuff applied on Proc
BuffBlueprint {
    Name = 'HVampireArmyoftheNightProcDebuff',
    DisplayName = 'Army of the Night',
    Description = 'Armor reduced.',
    BuffType = 'HVAMPIREVAMPIREPROC',
    EntityCategory = 'ALLUNITS - UNTARGETABLE',
    Debuff = true,
    CanBeDispelled = true,
    Stacks = 'Always',
    Duration = 5,
    Affects = {
        Armor = {Add = -75},
    },
    Icon = '/DGVampLord/NewVamplordArmyoftheNight01',
}
-- Adjust description
Ability.HVampireArmyoftheNight.GetLifeStealBonus = function(self) return math.floor( Buffs['HVampireArmyoftheNight'].Affects.LifeSteal.Add * 100 ) end
Ability.HVampireArmyoftheNight.GetProcChance = function(self) return math.floor( Ability['HVampireArmyoftheNightMinionAbil'].WeaponProcChance ) end
Ability.HVampireArmyoftheNight.GetArmorReduction = function(self) return math.floor( Buffs['HVampireArmyoftheNightProcDebuff'].Affects.Armor.Add * -1 ) end

Ability.HVampireArmyoftheNight.Description = 'Lord Erebus leads his Night Walkers as a bloodthirsty pack. Their Attack Speed is increased by [GetAttackBonus]% and they gain [GetLifeStealBonus]% lifesteal. They also have a [GetProcChance]% chance on auto attack to reduce the target\'s armor by [GetArmorReduction].'

__moduleinfo.auto_reload = true