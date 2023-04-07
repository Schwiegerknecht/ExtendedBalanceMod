-- Create custom effect template for Fell-Darkur
if not EffectTemplates.Items.Glove.GlovesOfFellDarkurProc then
    EffectTemplates.Items.Glove.GlovesOfFellDarkurProc = {
        -- FireNovaCast01
        '/effects/emitters/heroes/torchbearer/attack/spell/nova/fire/h_tb_atk_s_n_fi_12_castfire_h_emit.bp',
        -- The ground effect (?) from FireNovaCast01
        '/effects/emitters/heroes/torchbearer/attack/spell/nova/fire/h_tb_atk_s_n_fi_12_castfire_l_emit.bp',
        -- Sparks from FireNova01
        --'/effects/emitters/heroes/torchbearer/attack/spell/nova/fire/h_tb_atk_s_n_fi_10_sparks_h_emit.bp',
        -- The ground burst from FireRing01
        '/effects/emitters/heroes/torchbearer/attack/spell/ring/fire/h_tb_atk_s_r_fi_03_groundburst_h_emit.bp',
        -- From FireBallImpact01
        '/effects/emitters/projectiles/fireball01/impact/p_fib01_i_06_risingsparks_h_emit.bp',
        '/effects/emitters/projectiles/fireball01/impact/p_fib01_i_02_sparklines_h_emit.bp',
        '/effects/emitters/projectiles/fireball01/impact/p_fib01_i_03_firecloud_h_emit.bp',
        '/effects/emitters/projectiles/fireball01/impact/p_fib01_i_04_fire_h_emit.bp', 
        '/effects/emitters/projectiles/fireball01/impact/p_fib01_i_01_flash_h_emit.bp',
        --'/effects/emitters/projectiles/fireball01/impact/p_fib01_i_03_firecloud_l_emit.bp',
        --'/effects/emitters/projectiles/fireball01/impact/p_fib01_i_04_fire_l_emit.bp',
        '/effects/emitters/projectiles/fireball01/impact/p_fib01_i_08_groundfirering_h_emit.bp',
    }
end

-- Custom effect to be used in BuffBlueprints as "Effects = 'Burn01,"
-- It's the same animations as in Torchbearer's Ignite01 Effect Template.
if not EffectTemplates.Buff.Burn01 then
    EffectTemplates.Buff.Burn01 = {
        Small = {
            # high, med, low
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_32_ignite_embers_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_29_ignite_fire_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_30_ignite_fire_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_31_ignite_smoke_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_30_ignite_fire_l_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_35_ignite_glow_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_36_ignite_groundglow_h_emit.bp',
        },
        Medium = {
            # high, med, low
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_32_ignite_embers_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_29_ignite_fire_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_30_ignite_fire_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_31_ignite_smoke_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_30_ignite_fire_l_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_35_ignite_glow_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_36_ignite_groundglow_h_emit.bp',
        },
        Large = {
            # high, med, low
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_32_ignite_embers_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_29_ignite_fire_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_30_ignite_fire_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_31_ignite_smoke_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_30_ignite_fire_l_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_35_ignite_glow_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_36_ignite_groundglow_h_emit.bp',
        },
        Huge = {
            # high, med, low
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_32_ignite_embers_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_29_ignite_fire_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_30_ignite_fire_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_31_ignite_smoke_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_30_ignite_fire_l_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_35_ignite_glow_h_emit.bp',
            '/effects/emitters/heroes/torchbearer/ambient/fire/h_tb_amb_fi_36_ignite_groundglow_h_emit.bp',
        },
    }
end

# Notes:
-- FireNovaCast01: Flames going upward like bonfire. Nice, though not like an explosion
-- FireRing01: The little flames that make up the circle of fire
-- Ignite01: A little flaming effect around the character, can indicate burning
-- Torch01: Not really doing anything?
-- AmbientBase01: Not really doing anything?
-- EpicFireDeath01: Like FireNovaCast01, but for ~4 seconds. Too long
-- EpicFireDeath02: Like fireworks and then a rain of flames. Funny :)
-- EpicFireDeath03: A little flame at ca. height 108. Looks kinda weird even on Rook
-- EpicFireDeath04: Huge spherical boom!
-- AmbientFireSphere02: Nothing visible?
-- AmbientFireSphereFaint01: Very small flame on the ground
-- CastFireBall01+03: A downward trail of fire at head height. Kinda nice for Rook maybe?
-- CastFireBall02: A small flame at head height, not at the object