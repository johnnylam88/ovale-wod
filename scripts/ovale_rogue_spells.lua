local _, Ovale = ...
local OvaleScripts = Ovale.OvaleScripts

do
	local name = "ovale_rogue_spells"
	local desc = "[5.4.7] Ovale: Rogue spells"
	local code = [[
# Rogue spells and functions.

Define(adrenaline_rush 13750)
	SpellInfo(adrenaline_rush cd=180)
	SpellInfo(adrenaline_rush buff_cdr=cooldown_reduction_agility_buff)
	SpellAddBuff(adrenaline_rush adrenaline_rush_buff=1)
Define(adrenaline_rush_buff 13750)
	SpellInfo(adrenaline_rush_buff duration=15)
Define(ambush 8676)
	SpellInfo(ambush combo=2 energy=60)
	SpellInfo(ambush critcombo=1 if_spell=seal_fate)
	SpellInfo(ambush buff_combo=shadow_blades_buff if_spell=shadow_blades)
	SpellInfo(ambush buff_energy=silent_blades_buff buff_energy_amount=-6 itemset=T16_melee itemcount=2 specialization=assassination)
	SpellInfo(ambush buff_energy=silent_blades_buff buff_energy_amount=-15 itemset=T16_melee itemcount=2 specialization=combat)
	SpellInfo(ambush buff_energy=silent_blades_buff buff_energy_amount=-2 itemset=T16_melee itemcount=2 specialization=subtlety)
	SpellInfo(ambush buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(ambush buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellInfo(ambush buff_energy=shadow_dance_buff buff_energy_amount=-20 if_spell=shadow_dance)
	SpellAddBuff(ambush silent_blades_buff=0 itemset=T16_melee itemcount=2)
	SpellAddBuff(ambush sleight_of_hand_buff=0 itemset=T16_melee itemcount=4)
	SpellAddTargetDebuff(ambush find_weakness_debuff=1 if_spell=find_weakness)
Define(anticipation 114015)
Define(anticipation_buff 115189)
	SpellInfo(anticipation_buff duration=15)
Define(anticipation_talent 18)
Define(backstab 53)
	SpellInfo(backstab combo=1 energy=35)
	SpellInfo(backstab buff_combo=shadow_blades_buff if_spell=shadow_blades)
	SpellInfo(backstab buff_energy=silent_blades_buff buff_energy_amount=-6 itemset=T16_melee itemcount=2 specialization=assassination)
	SpellInfo(backstab buff_energy=silent_blades_buff buff_energy_amount=-15 itemset=T16_melee itemcount=2 specialization=combat)
	SpellInfo(backstab buff_energy=silent_blades_buff buff_energy_amount=-2 itemset=T16_melee itemcount=2 specialization=subtlety)
	SpellInfo(backstab buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(backstab buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellAddBuff(backstab silent_blades_buff=0 itemset=T16_melee itemcount=2)
Define(bandits_guile 84654)
Define(bandits_guile_buff 84654)	# OvaleBanditsGuile
	SpellInfo(bandits_guile_buff duration=15 maxstacks=12)
Define(blade_flurry 13877)
	SpellInfo(blade_flurry cd=10)
Define(blade_flurry_buff 13877)
Define(blindside 121152)
Define(blindside_buff 121153)
	SpellInfo(blindside_buff duration=10)
Define(cheap_shot 1833)
	SpellInfo(cheap_shot combo=2 energy=40)
	SpellInfo(cheap_shot critcombo=1 if_spell=seal_fate)
	SpellInfo(cheap_shot buff_energy=silent_blades_buff buff_energy_amount=-6 itemset=T16_melee itemcount=2 specialization=assassination)
	SpellInfo(cheap_shot buff_energy=silent_blades_buff buff_energy_amount=-15 itemset=T16_melee itemcount=2 specialization=combat)
	SpellInfo(cheap_shot buff_energy=silent_blades_buff buff_energy_amount=-2 itemset=T16_melee itemcount=2 specialization=subtlety)
	SpellInfo(cheap_shot buff_combo=shadow_blades_buff if_spell=shadow_blades)
	SpellInfo(cheap_shot buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(cheap_shot buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellAddBuff(cheap_shot silent_blades_buff=0 itemset=T16_melee itemcount=2)
	SpellAddTargetDebuff(cheap_shot find_weakness_debuff=1 if_spell=find_weakness)
Define(cloak_of_shadows 31224)
	SpellInfo(cloak_of_shadows cd=60)
	SpellInfo(cloak_of_shadows buff_cdr=cooldown_reduction_agility_buff)
Define(crimson_tempest 121411)
	SpellInfo(crimson_tempest combo=finisher energy=35)
	SpellInfo(crimson_tempest buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(crimson_tempest buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellAddBuff(crimson_tempest anticipation_buff=0 if_spell=anticipation)
	SpellAddTargetDebuff(crimson_tempest crimson_tempest_dot_debuff=1)
Define(crimson_tempest_dot_debuff 122233)
	SpellInfo(crimson_tempest_dot_debuff duration=12 tick=2)
Define(crippling_poison 3408)
	SpellAddBuff(crippling_poison crippling_poison_buff=1)
Define(crippling_poison_buff 3408)
	SpellInfo(crippling_poison_buff duration=3600)
Define(cut_to_the_chase 51667)
Define(deadly_poison 2823)
	SpellAddBuff(deadly_poison deadly_poison_buff=1)
Define(deadly_poison_buff 2823)
	SpellInfo(deadly_poison_buff duration=3600)
Define(deep_insight_buff 84747)
	SpellInfo(deep_insight_buff duration=15)
Define(dispatch 111240)
	SpellInfo(dispatch combo=1 energy=30)
	SpellInfo(dispatch critcombo=1 if_spell=seal_fate)
	SpellInfo(dispatch buff_combo=shadow_blades_buff if_spell=shadow_blades)
	SpellInfo(dispatch buff_energy=silent_blades_buff buff_energy_amount=-6 itemset=T16_melee itemcount=2 specialization=assassination)
	SpellInfo(dispatch buff_energy=silent_blades_buff buff_energy_amount=-15 itemset=T16_melee itemcount=2 specialization=combat)
	SpellInfo(dispatch buff_energy=silent_blades_buff buff_energy_amount=-2 itemset=T16_melee itemcount=2 specialization=subtlety)
	SpellInfo(dispatch buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(dispatch buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellInfo(dispatch buff_energy_none=blindside_buff if_spell=blindside)
	SpellAddBuff(dispatch blindside_buff=0 if_spell=blindside)
	SpellAddBuff(dispatch silent_blades_buff=0 itemset=T16_melee itemcount=2)
Define(envenom 32645)
	SpellInfo(envenom combo=finisher energy=35)
	SpellInfo(envenom buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(envenom buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellAddBuff(envenom anticipation_buff=0 if_spell=anticipation)
	SpellAddBuff(envenom slice_and_dice=refresh if_spell=cut_to_the_chase)
Define(eviscerate 2098)
	SpellInfo(eviscerate combo=finisher energy=35)
	SpellInfo(eviscerate buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(eviscerate buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellAddBuff(eviscerate anticipation_buff=0 if_spell=anticipation)
Define(fan_of_knives 51723)
	SpellInfo(fan_of_knives combo=1 energy=35)
	SpellInfo(fan_of_knives buff_energy=silent_blades_buff buff_energy_amount=-6 itemset=T16_melee itemcount=2 specialization=assassination)
	SpellInfo(fan_of_knives buff_energy=silent_blades_buff buff_energy_amount=-15 itemset=T16_melee itemcount=2 specialization=combat)
	SpellInfo(fan_of_knives buff_energy=silent_blades_buff buff_energy_amount=-2 itemset=T16_melee itemcount=2 specialization=subtlety)
	SpellInfo(fan_of_knives buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(fan_of_knives buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellInfo(fan_of_knives buff_combo=shadow_blades_buff if_spell=shadow_blades)
	SpellAddBuff(fan_of_knives silent_blades_buff=0 itemset=T16_melee itemcount=2)
Define(feint 1966)
	SpellInfo(feint energy=20)
	SpellInfo(feint buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(feint buff_energy_less75=stealth_buff if_spell=shadow_focus)
Define(find_weakness 91023)
Define(find_weakness_debuff 91021)
	SpellInfo(find_weakness_debuff duration=10)
Define(glyph_of_kick 56805)
Define(glyph_of_redirect 146629)
Define(glyph_of_stealth 63253)
Define(glyph_of_tricks_of_the_trade 63256)
Define(glyph_of_vanish 89758)
Define(hemorrhage 16511)
	SpellInfo(hemorrhage combo=1 energy=30)
	SpellInfo(hemorrhage buff_combo=shadow_blades_buff if_spell=shadow_blades)
	SpellInfo(hemorrhage buff_energy=silent_blades_buff buff_energy_amount=-6 itemset=T16_melee itemcount=2 specialization=assassination)
	SpellInfo(hemorrhage buff_energy=silent_blades_buff buff_energy_amount=-15 itemset=T16_melee itemcount=2 specialization=combat)
	SpellInfo(hemorrhage buff_energy=silent_blades_buff buff_energy_amount=-2 itemset=T16_melee itemcount=2 specialization=subtlety)
	SpellInfo(hemorrhage buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(hemorrhage buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellAddBuff(hemorrhage silent_blades_buff=0 itemset=T16_melee itemcount=2)
	SpellAddTargetDebuff(hemorrhage hemorrhage_debuff=1)
Define(hemorrhage_debuff 89775)
	SpellInfo(hemorrhage_debuff duration=24 tick=3)
Define(kick 1766)
	SpellInfo(kick cd=15)
	SpellInfo(kick addcd=4 glyph=glyph_of_kick)
Define(kidney_shot 408)
	SpellInfo(kidney_shot cd=20 combo=finisher energy=25)
	SpellInfo(kidney_shot buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(kidney_shot buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellAddBuff(kidney_shot anticipation_buff=0 if_spell=anticipation)
Define(killing_spree 51690)
	SpellInfo(killing_spree cd=120)
	SpellInfo(killing_spree buff_cdr=cooldown_reduction_agility_buff)
Define(leeching_poison 108211)
	SpellAddBuff(leeching_poison leeching_poison_buff=1)
Define(leeching_poison_buff 108211)
	SpellInfo(leeching_poison_buff duration=3600)
Define(leeching_poison_talent 8)
SpellList(lethal_poison_buff deadly_poison_buff wound_poison_buff)
Define(marked_for_death 137619)
	SpellInfo(marked_for_death cd=60 combo=5)
Define(marked_for_death_talent 17)
Define(master_of_subtlety_buff 31665)
Define(mind_numbing_poison 5761)
	SpellAddBuff(mind_numbing_poison mind_numbing_poison_buff=1)
Define(mind_numbing_poison_buff 5761)
	SpellInfo(mind_numbing_poison_buff duration=3600)
Define(mutilate 1329)
	SpellInfo(mutilate combo=2 energy=55)
	SpellInfo(mutilate critcombo=1 if_spell=seal_fate)
	SpellInfo(mutilate buff_energy=silent_blades_buff buff_energy_amount=-6 itemset=T16_melee itemcount=2 specialization=assassination)
	SpellInfo(mutilate buff_energy=silent_blades_buff buff_energy_amount=-15 itemset=T16_melee itemcount=2 specialization=combat)
	SpellInfo(mutilate buff_energy=silent_blades_buff buff_energy_amount=-2 itemset=T16_melee itemcount=2 specialization=subtlety)
	SpellInfo(mutilate buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(mutilate buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellInfo(mutilate buff_combo=shadow_blades_buff if_spell=shadow_blades)
	SpellAddBuff(mutilate silent_blades_buff=0 itemset=T16_melee itemcount=2)
SpellList(non_lethal_poison_buff crippling_poison_buff leeching_poison_buff mind_numbing_poison_buff paralytic_poison_buff)
Define(paralytic_poison 108215)
	SpellAddBuff(paralytic_poison paralytic_poison_buff=1)
Define(paralytic_poison_buff 108215)
	SpellInfo(paralytic_poison_buff duration=3600)
Define(paralytic_poison_talent 14)
Define(premeditation 14183)
	SpellInfo(premeditation cd=20 combo=2)
Define(preparation 14185)
	SpellInfo(preparation cd=300)
Define(redirect 73981)
	SpellInfo(redirect cd=60)
	SpellInfo(redirect addcd=-50 glyph=glyph_of_redirect)
Define(revealing_strike 84617)
	SpellInfo(revealing_strike combo=1 energy=40)
	SpellInfo(revealing_strike buff_combo=shadow_blades_buff if_spell=shadow_blades)
	SpellInfo(revealing_strike buff_energy=silent_blades_buff buff_energy_amount=-6 itemset=T16_melee itemcount=2 specialization=assassination)
	SpellInfo(revealing_strike buff_energy=silent_blades_buff buff_energy_amount=-15 itemset=T16_melee itemcount=2 specialization=combat)
	SpellInfo(revealing_strike buff_energy=silent_blades_buff buff_energy_amount=-2 itemset=T16_melee itemcount=2 specialization=subtlety)
	SpellInfo(revealing_strike buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(revealing_strike buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellAddBuff(revealing_strike bandits_guile_buff=1 if_spell=bandits_guile)
	SpellAddBuff(revealing_strike silent_blades_buff=0 itemset=T16_melee itemcount=2)
	SpellAddTargetDebuff(revealing_strike revealing_strike_debuff=1)
Define(revealing_strike_debuff 84617)
	SpellInfo(revealing_strike_debuff duration=24 tick=3)
Define(rupture 1943)
	SpellInfo(rupture combo=finisher energy=25)
	SpellInfo(rupture buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(rupture buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellAddBuff(rupture anticipation_buff=0 if_spell=anticipation)
	SpellAddTargetDebuff(rupture rupture_debuff=1)
Define(rupture_debuff 1943)
	SpellInfo(rupture_debuff adddurationcp=4 duration=4 tick=2)
Define(seal_fate 14190)
Define(shadow_blades 121471)
	SpellInfo(shadow_blades cd=180)
	SpellInfo(shadow_blades buff_cdr=cooldown_reduction_agility_buff)
	SpellAddBuff(shadow_blades shadow_blades_buff=1)
Define(shadow_blades_buff 121471)
	SpellInfo(shadow_blades_buff duration=12)
	SpellInfo(shadow_blades_buff addduration=12 itemset=T14 itemcount=4)
Define(shadow_dance 51713)
	SpellInfo(shadow_dance cd=60 to_stance=rogue_shadow_dance)
	SpellInfo(shadow_dance buff_cdr=cooldown_reduction_agility_buff)
	SpellAddBuff(shadow_dance shadow_dance_buff=1)
Define(shadow_dance_buff 51713)
	SpellInfo(shadow_dance_buff duration=8)
Define(shadow_focus 108209)
Define(shadow_focus_talent 3)
Define(shuriken_toss 114014)
	SpellInfo(shuriken_toss combo=1 energy=40)
	SpellInfo(shuriken_toss critcombo=1 if_spell=seal_fate)
	SpellInfo(shuriken_toss buff_combo=shadow_blades_buff if_spell=shadow_blades)
	SpellInfo(shuriken_toss buff_energy=silent_blades_buff buff_energy_amount=-6 itemset=T16_melee itemcount=2 specialization=assassination)
	SpellInfo(shuriken_toss buff_energy=silent_blades_buff buff_energy_amount=-15 itemset=T16_melee itemcount=2 specialization=combat)
	SpellInfo(shuriken_toss buff_energy=silent_blades_buff buff_energy_amount=-2 itemset=T16_melee itemcount=2 specialization=subtlety)
	SpellInfo(shuriken_toss buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(shuriken_toss buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellAddBuff(shuriken_toss silent_blades_buff=0 itemset=T16_melee itemcount=2)
Define(shuriken_toss_talent 16)
Define(silent_blades_buff 145193)
	SpellInfo(silent_blades_buff duration=30 stacking_effect=1)
Define(sinister_strike 1752)
	SpellInfo(sinister_strike combo=1 energy=50)
	SpellInfo(sinister_strike buff_combo=shadow_blades_buff if_spell=shadow_blades)
	SpellInfo(sinister_strike buff_energy=silent_blades_buff buff_energy_amount=-6 itemset=T16_melee itemcount=2 specialization=assassination)
	SpellInfo(sinister_strike buff_energy=silent_blades_buff buff_energy_amount=-15 itemset=T16_melee itemcount=2 specialization=combat)
	SpellInfo(sinister_strike buff_energy=silent_blades_buff buff_energy_amount=-2 itemset=T16_melee itemcount=2 specialization=subtlety)
	SpellInfo(sinister_strike buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(sinister_strike buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellAddBuff(sinister_strike bandits_guile_buff=1 if_spell=bandits_guile)
	SpellAddBuff(sinister_strike silent_blades_buff=0 itemset=T16_melee itemcount=2)
Define(sleight_of_hand_buff 145211)
	SpellInfo(sleight_of_hand_buff duration=10)
Define(slice_and_dice 5171)
	SpellInfo(slice_and_dice combo=finisher energy=25)
	SpellInfo(slice_and_dice buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(slice_and_dice buff_energy_less75=stealth_buff if_spell=shadow_focus)
	SpellAddBuff(slice_and_dice slice_and_dice_buff=1)
	SpellAddBuff(slice_and_dice anticipation_buff=0 if_spell=anticipation)
Define(slice_and_dice_buff 5171)
	SpellInfo(slice_and_dice adddurationcp=6 duration=6 tick=3)
Define(stealth 1784)
	SpellInfo(stealth cd=6 to_stance=rogue_stealth)
	SpellInfo(stealth addcd=-4 glyph=glyph_of_stealth)
SpellList(steath_buff 1784 11327)
Define(subterfuge_talent 2)
Define(tricks_of_the_trade 57934)
	SpellInfo(tricks_of_the_trade cd=30 energy=15)
	SpellInfo(tricks_of_the_trade energy=0 glyph=glyph_of_tricks_of_the_trade)
	SpellInfo(tricks_of_the_trade buff_energy_less15=shadow_blades_buff if_spell=shadow_blades itemset=T15_melee itemcount=4)
	SpellInfo(tricks_of_the_trade buff_energy_less75=stealth_buff if_spell=shadow_focus)
Define(vanish 1856)
	SpellInfo(vanish cd=120)
	SpellInfo(vanish buff_cdr=cooldown_reduction_agility_buff specialization=assassination)
	SpellInfo(vanish buff_cdr=cooldown_reduction_agility_buff specialization=subtlety)
	SpellAddBuff(vanish vanish_buff=1)
Define(vanish_buff 11327)
	SpellInfo(vanish_buff duration=3)
	SpellInfo(vanish_buff addduration=2 glyph=glyph_of_vanish)
Define(vendetta 79140)
	SpellInfo(vendetta cd=120)
	SpellInfo(vendetta buff_cdr=cooldown_reduction_agility_buff)
Define(wound_poison 8679)
	SpellAddBuff(wound_poison wound_poison_buff=1)
Define(wound_poison_buff 8679)
	SpellInfo(wound_poison_buff duration=3600)
]]

	OvaleScripts:RegisterScript("ROGUE", name, desc, code, "include")
end
