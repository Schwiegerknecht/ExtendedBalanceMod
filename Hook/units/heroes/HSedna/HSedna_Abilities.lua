--Increase yeti damage, normally 8 per level
Buffs.HSednaYetiBuff02.Affects.DamageRating.Add = 30
Buffs.HSednaYetiBuff03.Affects.DamageRating.Add = 60
Buffs.HSednaYetiBuff04.Affects.DamageRating.Add = 90

--Increase Life's child trigger to 50% up from 30%
Ability.HSednaLifesChild.HealthPercentTrigger = .50

-- Increase minion evasion from inspiring roar to 20 up from 15 and duration to 10 up from 5
Buffs.HSednaInspiringRoar.Affects.Evasion.Add = 20
Buffs.HSednaInspiringRoar.Duration = 10

-- Increase Wild Swing Radius to 3
Buffs.HSednaWildSwings.Affects.DamageRadius.Add = 3


-- Schwiegerknecht start

-- Add knockup to Wild Swings
Buffs.HSednaWildSwings.Affects.MetaAmount = {Add = 8}
Buffs.HSednaWildSwings.Affects.MetaRadius = {Add = 3}
-- Wild Swings gives Yeti 40 auto attack damage (normally 0)
Buffs.HSednaWildSwings.Affects.DamageRating = {Add = 40}
-- Adjust description and make it clearer
Ability.HSednaWildSwings.GetDamageRating = function(self) return math.floor(Buffs.HSednaWildSwings.Affects.DamageRating.Add) end
Ability.HSednaWildSwings.Description = 'Sedna\'s Yetis strike with wide swings, dealing [GetDamageMult]% cleave damage to nearby enemies while knocking up smaller units. They also gain [GetDamageRating] weapon damage.'


-- Increase Yeti armor by 0/50/150/200 (normally 0/0/0/0)
Buffs.HSednaYetiBuff02.Affects.Armor  = {Add = 50}
Buffs.HSednaYetiBuff03.Affects.Armor  = {Add = 100}
Buffs.HSednaYetiBuff04.Affects.Armor  = {Add = 150}

-- Reduce mana cost of Horn of the Yeti to 525/650/775/900 (normally 550/750/950/1150)
Ability.HSednaYeti01.EnergyCost = 525
Ability.HSednaYeti02.EnergyCost = 650
Ability.HSednaYeti03.EnergyCost = 775
Ability.HSednaYeti04.EnergyCost = 900

-- Adjust descriptions to make changes clearer
Ability.HSednaYeti02.GetYetiHP = function(self) return math.floor ( Buffs.HSednaYetiBuff02.Affects.MaxHealth.Add) end
Ability.HSednaYeti02.GetYetiArmor = function(self) return math.floor ( Buffs.HSednaYetiBuff02.Affects.Armor.Add) end
Ability.HSednaYeti03.GetYetiHP = function(self) return math.floor ( Buffs.HSednaYetiBuff03.Affects.MaxHealth.Add) end
Ability.HSednaYeti03.GetYetiArmor = function(self) return math.floor ( Buffs.HSednaYetiBuff03.Affects.Armor.Add) end
Ability.HSednaYeti04.GetYetiHP = function(self) return math.floor ( Buffs.HSednaYetiBuff04.Affects.MaxHealth.Add) end
Ability.HSednaYeti04.GetYetiArmor = function(self) return math.floor ( Buffs.HSednaYetiBuff04.Affects.Armor.Add) end

Ability.HSednaYeti02.Description = 'Sedna summons [GetNumYetis] mighty Yeti to defend her. Yeti gain [GetYetiHP] HP and [GetYetiArmor] armor. She may have [GetMaxYeti] Yeti active.'
Ability.HSednaYeti03.Description = 'Sedna summons [GetNumYetis] mighty Yeti to defend her. Yeti gain [GetYetiHP] HP and [GetYetiArmor] armor. She may have [GetMaxYeti] Yeti active.'
Ability.HSednaYeti04.Description = 'Sedna summons [GetNumYetis] mighty Yeti to defend her. Yeti gain [GetYetiHP] HP and [GetYetiArmor] armor. She may have [GetMaxYeti] Yeti active.'


__moduleinfo.auto_reload = true