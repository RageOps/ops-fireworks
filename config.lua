Config = {}

Config.UseAnimations = false

Config.CooldownTime = 5 -- 5 minutes cooldown time for fireworks

Config.BurstHeight = 32 -- 28 meters is the height that the independent fireworks blow at

Config.FireworkTypes = {
    ['proj_indep_firework'] = {
        'scr_indep_firework_grd_burst',
        'scr_indep_firework_air_burst',
    },
    ['proj_indep_firework_v2'] = {
        'scr_firework_indep_burst_rwb',
        'scr_firework_indep_spiral_burst_rwb',
        'scr_firework_indep_ring_burst_rwb',
        'scr_xmas_firework_burst_fizzle', -- (Pretty)
        'scr_firework_indep_repeat_burst_rwb', -- (Pretty)
    },
    ['proj_xmas_firework'] = {
        'scr_firework_xmas_ring_burst_rgw',
        'scr_firework_xmas_burst_rgw',
        'scr_firework_xmas_repeat_burst_rgw',
        'scr_firework_xmas_spiral_burst_rgw',
    },
    ['scr_indep_fireworks'] = {
        'scr_indep_firework_starburst', -- (sound)
        'scr_indep_firework_shotburst', -- (sound, pretty)
        'scr_indep_firework_trailburst',
        'scr_indep_firework_trailburst_spawn',
        'scr_indep_firework_burst_spawn',
        'scr_indep_firework_fountain', -- (fountain)
    },
    ['scr_rcpaparazzo1'] = {
        'scr_mich4_firework_burst_spawn',
        'scr_mich4_firework_trailburst',
        'scr_mich4_firework_starburst',
        'scr_mich4_firework_trailburst_spawn',
    },
    ['pat_heist'] = {
        'scr_heist_ornate_thermal_burn_patch',
    }
}
