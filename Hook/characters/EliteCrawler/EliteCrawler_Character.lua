CharacterBlueprint {
    Actions = {
    },
    AnimEvents = {
        vampire_minion_attack01_sound_grunt = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_grunt_attack',
        },
        vampire_minion_attack01_sound_swing = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_swing',
        },
         vampire_minion_attack01_sound_hit = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_hit',
        },
        vampire_minion_death_grunt_sound_1 = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_grunt_death',
        },
        vampire_minion_death_bodyfall_sound_1 = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_death_bodyfall',
        },
        vampire_minion_move_1 = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_move_run1',
        },
        vampire_minion_move_2 = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_move_run2',
        },
        vampire_minion_idle_1 = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_idle',
        },
        vampire_minion_fidget_1 = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_fidget1',
        },
        vampire_minion_fidget_2 = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_fidget2',
        },
        vampire_minion_stun_1 = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_stun',
        },
        vampire_minion_flail_1 = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_flail1',
        },
        vampire_minion_bounce = {
            Sound = 'Forge/CREEPS/Vampire_minion/snd_cr_vampire_minion_roll_bounce',
        },
     },
    AnimStates = {
        Idle = {
            IsRandom = false,
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_Idle_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_idle_1', time = 0.01, },
                    },
                    Loop = true,
                },
            },
            Transitions = {
                ANIM_START_MOVING = { Duration = 0.1, TargetState = 'Run', },
                ANIM_FIDGET = { TargetState ='Fidget',},
            },
        },
        Fidget = {
            IsRandom = true,
            FidgetTimeMin = 4,
            FidgetTimeMax = 12,
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_Fidget_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_fidget_1', time = 0.01, },
                    },
                    Loop = false,
                    EventOnCompletion = true,
                },
                {
                    Animation = '/characters/Vampire/animations/Vampire_Fidget02_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_fidget_2', time = 0.01, },
                    },
                    Loop = false,
                    EventOnCompletion = true,
                },
            },
            Transitions = {
                ANIM_START_MOVING = { Duration = 0.1, TargetState = 'Run', },
                ANIM_DONE = {Duration = 0.2, TargetStateStationary = 'Idle', TargetStateMoving = 'Run', },
            },
        },
        Run = {
            #ScaleOnUnitVelocity = true,
            TimeScale = 1.16,
            IsRandom = true,
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_Run01_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_move_1', time = 0.01, },  #sound waving arms crazy anim
                    },
                    Loop = true,
                },
                {
                    Animation = '/characters/Vampire/animations/Vampire_Run02_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_move_2', time = 0.01, },
                        { name = 'snd_cr_vampire_minion_roll_bounce', time = 0.30, },
                        { name = 'snd_cr_vampire_minion_roll_bounce', time = 0.60, },
                        { name = 'snd_cr_vampire_minion_roll_bounce', time = 0.90, },
                        { name = 'snd_cr_vampire_minion_roll_bounce', time = 1.20, },  #sound bounce roll anim

                    },
                    Loop = true,
                },
            },
            Transitions = {
                ANIM_STOP_MOVING = { Duration = 0.2,TargetState = 'RunStop',},
                ANIM_INTERRUPT =  { TargetStateStationary = 'Idle',},
            },
        },
        RunStop = {
            IsRandom = true,
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_RunStop01_anim.gr2',
                    Loop = false,
                    EventOnCompletion = true,
                },
                {
                    Animation = '/characters/Vampire/animations/Vampire_RunStop02_anim.gr2',
                    Loop = false,
                    EventOnCompletion = true,
                },
            },
            Transitions = {
                ANIM_DONE = { Duration = 0.1,TargetState = 'Idle',},
                ANIM_INTERRUPT =  { TargetStateStationary = 'Idle',},
                ANIM_START_MOVING = { Duration = 0.1, TargetState = 'Run', },
            },
        },
        Attack = {
            RandomStates =
            {
                { Target = 'Attack01', RandomWeight = 5, },
                { Target = 'Attack02', RandomWeight = 5,},
                { Target = 'Attack03', RandomWeight = 5,},
            },
        },
        AttackMove = {
            RandomStates =
            {
                { Target = 'AttackMove01', RandomWeight = 5, },
                { Target = 'AttackMove02', RandomWeight = 5,},
                { Target = 'AttackMove03', RandomWeight = 5,},
            },
        },
        Attack01 = {
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_Attack_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_attack01_sound_grunt', time = 0.01, },
                        { name = 'vampire_minion_attack01_sound_swing', time = 0.1, },
                        { name = 'vampire_minion_attack01_sound_hit', time = 0.4, },
                    },
                    Loop = false,
                    EventOnCompletion = true,
                },
            },
            Transitions = {
                ANIM_DONE = { Duration = 0.1,TargetState = 'Idle',},
                ANIM_INTERRUPT =  { TargetStateStationary = 'Idle',},
                ANIM_START_MOVING = { Duration = 0.1, TargetState = 'AttackMove01', CopyClocks = true, },
            },
        },
        AttackMove01 = {
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_Attackmove_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_attack01_sound_grunt', time = 0.01, },
                        { name = 'vampire_minion_attack01_sound_swing', time = 0.1, },
                        { name = 'vampire_minion_attack01_sound_hit', time = 0.4, },
                    },
                    Loop = false,
                    EventOnCompletion = true,
                },
            },
            Transitions = {
                ANIM_DONE = { Duration = 0.1, TargetStateMoving = 'Run', TargetStateStationary = 'RunStop', },
                ANIM_STOP_MOVING = { Duration = 0.1, TargetState = 'Attack01', CopyClocks = true, },
            },
        },
        Attack02 = {
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_Attack02_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_attack01_sound_grunt', time = 0.01, },
                        { name = 'vampire_minion_attack01_sound_swing', time = 0.15, },
                        { name = 'vampire_minion_attack01_sound_hit', time = 0.5, },
                    },
                    Loop = false,
                    EventOnCompletion = true,
                },
            },
            Transitions = {
                ANIM_DONE = { Duration = 0.1,TargetState = 'Idle',},
                ANIM_INTERRUPT =  { TargetStateStationary = 'Idle',},
                ANIM_START_MOVING = { Duration = 0.1, TargetState = 'AttackMove02', CopyClocks = true, },
            },
        },
        AttackMove02 = {
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_Attack02move_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_attack01_sound_grunt', time = 0.01, },
                        { name = 'vampire_minion_attack01_sound_swing', time = 0.15, },
                        { name = 'vampire_minion_attack01_sound_hit', time = 0.5, },
                    },
                    Loop = false,
                    EventOnCompletion = true,
                },
            },
            Transitions = {
                ANIM_DONE = { Duration = 0.1, TargetStateMoving = 'Run', TargetStateStationary = 'RunStop', },
                ANIM_STOP_MOVING = { Duration = 0.1, TargetState = 'Attack02', CopyClocks = true, },
            },
        },
        Attack03 = {
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_Attack03_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_attack01_sound_grunt', time = 0.01, },
                        { name = 'vampire_minion_attack01_sound_swing', time = 0.3, },
                        { name = 'vampire_minion_attack01_sound_hit', time = 0.4, },
                    },
                    Loop = false,
                    EventOnCompletion = true,
                },
            },
            Transitions = {
                ANIM_DONE = { Duration = 0.1,TargetState = 'Idle',},
                ANIM_INTERRUPT =  { TargetStateStationary = 'Idle',},
                ANIM_START_MOVING = { Duration = 0.1, TargetState = 'AttackMove03', CopyClocks = true, },
            },
        },
        AttackMove03 = {
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_Attack03move_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_attack01_sound_grunt', time = 0.01, },
                        { name = 'vampire_minion_attack01_sound_swing', time = 0.3, },
                        { name = 'vampire_minion_attack01_sound_hit', time = 0.4, },
                    },
                    Loop = false,
                    EventOnCompletion = true,
                },
            },
            Transitions = {
                ANIM_DONE = { Duration = 0.1, TargetStateMoving = 'Run', TargetStateStationary = 'RunStop', },
                ANIM_STOP_MOVING = { Duration = 0.1, TargetState = 'Attack03', CopyClocks = true, },
            },
        },
        Stun = {
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_Stun_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_stun_1', time = 0.01, },
                    },
                    Loop = true,
                },
            },
            Transitions = {
                ANIM_STOP_MOVING = { Duration = 0.2, TargetStateStationary = 'Idle', TargetStateMoving = 'Run',},
                ANIM_INTERRUPT =  { TargetStateStationary = 'Idle', TargetStateMoving = 'Run', },
           },
        },
        Flail = {
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_Flail01_anim.gr2',
                     Events = {
                        { name = 'vampire_minion_flail_1', time = 0.01, },
                    },
                    Loop = true,
                },
            },
            Transitions = {
                ANIM_DIE = {TargetState = 'Flail',},
                ANIM_GROUNDIMPACT = {TargetState = 'FlailDie',},
            },
        },
        Die = {
            IsRandom = true,
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_Death_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_death_grunt_sound_1', time = 0.01, },
                        { name = 'vampire_minion_death_bodyfall_sound_1', time = 0.3, },
                    },
                    Loop = false,
                },
                {
                    Animation = '/characters/Vampire/animations/Vampire_Death02_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_death_grunt_sound_1', time = 0.01, },
                        { name = 'vampire_minion_death_bodyfall_sound_1', time = 0.35, },
                    },
                    Loop = false,
                },
            },
        },
        FlailDie = {
            Compositions = {
                {
                    Animation = '/characters/Vampire/animations/Vampire_FlailDie01_anim.gr2',
                    Events = {
                        { name = 'vampire_minion_flaildie_1', time = 0.01, },
                    },
                    Loop = false,
                },
            },
            Transitions = {
                ANIM_DIE = {TargetState = 'FlailDie',},
                ANIM_GROUNDIMPACT = {TargetState = 'FlailDie',},
            },
        },
    },
    DefaultTransitions = {
        ANIM_DIE = {TargetState = 'Die',},
        ANIM_GROUNDIMPACT = {TargetState = 'FlailDie',},
        ANIM_FLAIL = {TargetState = 'Flail',},
    },
    DrawScales = {
        Good = 0.28,
        Evil = 0.28,
        Neutral = 0.28,
    },
    Effects = {
        Base = 'Vampire',
        BuffClassification = 'Small',
    },
    Meshes = {
        '/mods/enfos/hook/characters/nightmare01/nightmare01_MESH',
        Good = '/characters/Vampire/Vampire_MESH',
        Evil = '/characters/Vampire/Vampire_MESH',
        Neutral = '/characters/Vampire/Vampire_MESH',
    },
    Name = 'nightmare01',
    ScaleVariance = .2,

}
