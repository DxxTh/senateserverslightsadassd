lts = lts or {}
lts.forms = {}
/*
lts.forms["Untrained"] = {
	icon = "I",
	holdtype = "melee2",
	crystalBooster = 0.5,
	idles = {
		up = "wos_judge_b_idle",
		left = "wos_judge_r_idle",
		right = "wos_judge_h_idle"
	},
	runs = {
		up = "wos_judge_b_run",
		left = "wos_judge_r_run",
		right = "run_melee2"
	},
	moves = {
		w = {
			[1] = {
				anim = {
					charge = "wos_judge_h_s1_charge",
					seq = "wos_judge_h_s1_t1",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_s1_t1",
					charge = "wos_judge_a_s1_charge",
					time = 1,
				},
				speed = 75,
				damage = 0.5,
			},
			
			[2] = {
				anim = {
					charge = "wos_judge_h_s1_charge",
					seq = "wos_judge_h_s1_t2",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_s1_t2",
					charge = "wos_judge_a_s1_charge",
					time = 1,
				},
				speed = 75,
				damage = 1,
			},
			
			[3] = {
				anim = {
					charge = "wos_judge_h_s1_charge",
					seq = "wos_judge_h_s1_t3",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_s1_t3",
					charge = "wos_judge_a_s1_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
		a = {
			[1] = {
				anim = {
					seq = "wos_judge_h_left_t2",
					charge = "wos_judge_h_left_charge",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_left_t1",
					charge = "wos_judge_a_left_charge",
					time = 1,
				},
				speed = 75,
				damage = 0.5,
			},
			[2] = {
				anim = {
					seq = "wos_judge_h_left_t2",
					charge = "wos_judge_h_left_charge",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_left_t2",
					charge = "wos_judge_a_left_charge",
					time = 1,
				},
				speed = 75,
				damage = 1,
			},
			[3] = {
				anim = {
					seq = "wos_judge_h_left_t3",
					charge = "wos_judge_h_left_charge",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_left_t3",
					charge = "wos_judge_a_left_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
		d = {
			[1] = {
				anim = {
					seq = "wos_judge_h_right_t2",
					charge = "wos_judge_h_right_charge",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_right_t1",
					charge = "wos_judge_a_right_charge",
					time = 1,
				},
				speed = 75,
				damage = 0.5,
			},
			[2] = {
				anim = {
					seq = "wos_judge_h_right_t2",
					charge = "wos_judge_h_right_charge",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_right_t1",
					charge = "wos_judge_a_right_charge",
					time = 1,
				},
				speed = 75,
				damage = 1,
			},
			[3] = {
				anim = {
					seq = "wos_judge_h_right_t3",
					charge = "wos_judge_h_right_charge",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_right_t1",
					charge = "wos_judge_a_right_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
	},
}
*/
lts.forms["Form I: Shii-Cho"] = {
	icon = "I",
	holdtype = "melee2",
	crystalBooster = 0.5,
	idles = {
		up = "wos_judge_b_idle",
		left = "wos_judge_r_idle",
		right = "wos_judge_h_idle"
	},
	runs = {
		up = "wos_judge_b_run",
		left = "wos_judge_r_run",
		right = "run_melee2"
	},
	moves = {
		w = {
			[1] = {
				anim = {
					charge = "wos_judge_h_s1_charge",
					seq = "wos_judge_h_s1_t1",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_s1_t1",
					charge = "wos_judge_a_s1_charge",
					time = 1,
				},
				speed = 120,
				damage = 0.5,
			},
			
			[2] = {
				anim = {
					charge = "wos_judge_h_s1_charge",
					seq = "wos_judge_h_s1_t2",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_s1_t2",
					charge = "wos_judge_a_s1_charge",
					time = 1,
				},
				speed = 120,
				damage = 1,
			},
			
			[3] = {
				anim = {
					charge = "wos_judge_h_s1_charge",
					seq = "wos_judge_h_s1_t3",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_s1_t3",
					charge = "wos_judge_a_s1_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
		a = {
			[1] = {
				anim = {
					seq = "wos_judge_h_left_t2",
					charge = "wos_judge_h_left_charge",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_left_t1",
					charge = "wos_judge_a_left_charge",
					time = 1,
				},
				speed = 120,
				damage = 0.5,
			},
			[2] = {
				anim = {
					seq = "wos_judge_h_left_t2",
					charge = "wos_judge_h_left_charge",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_left_t2",
					charge = "wos_judge_a_left_charge",
					time = 1,
				},
				speed = 120,
				damage = 1,
			},
			[3] = {
				anim = {
					seq = "wos_judge_h_left_t3",
					charge = "wos_judge_h_left_charge",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_left_t3",
					charge = "wos_judge_a_left_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
		d = {
			[1] = {
				anim = {
					seq = "wos_judge_h_right_t2",
					charge = "wos_judge_h_right_charge",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_right_t1",
					charge = "wos_judge_a_right_charge",
					time = 1,
				},
				speed = 120,
				damage = 0.5,
			},
			[2] = {
				anim = {
					seq = "wos_judge_h_right_t2",
					charge = "wos_judge_h_right_charge",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_right_t1",
					charge = "wos_judge_a_right_charge",
					time = 1,
				},
				speed = 120,
				damage = 1,
			},
			[3] = {
				anim = {
					seq = "wos_judge_h_right_t3",
					charge = "wos_judge_h_right_charge",
					time = 1,
				},
				air = {
					seq = "wos_judge_a_right_t1",
					charge = "wos_judge_a_right_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
	},
}


--lts.forms["Form II: Makashi"] = {}
--lts.forms["Form III: Soresu"] = {}
--lts.forms["Form IV: Ataru"] = {}
---lts.forms["Form V: Djem So"] = {}
--lts.forms["Form VI: Niman"] = {}
--lts.forms["Form VI: Juyo"] = {}
--lts.forms["Form SK: Sokan"] = {}
--lts.forms["Form JK: Jar'Kai"] = {}


lts.forms["Form II: Ryoku"] = {
	icon = "II",
	holdtype = "melee2",
	crystalBooster = 0.5,
	idles = {
		up = "wos_ryoku_b_idle",
		left = "wos_ryoku_r_idle",
		right = "wos_ryoku_h_idle"
	},
	runs = {
		up = "wos_ryoku_b_run",
		left = "wos_ryoku_r_run",
		right = "wos_ryoku_h_run"
	},
	moves = {
		w = {
			[1] = {
				anim = {
					charge = "wos_ryoku_h_s1_charge",
					seq = "wos_ryoku_h_s1_t1",
					time = 1,
				},
				air = {
					seq = "wos_ryoku_a_s1_t1",
					charge = "wos_ryoku_a_s1_charge",
					time = 1,
				},
				speed = 75,
				damage = 0.5,
			},
			
			[2] = {
				anim = {
					charge = "wos_ryoku_h_s1_charge",
					seq = "wos_ryoku_h_s1_t2",
					time = 1,
				},
				air = {
					seq = "wos_ryoku_a_s1_t2",
					charge = "wos_ryoku_a_s1_charge",
					time = 1,
				},
				speed = 75,
				damage = 1,
			},
			
			[3] = {
				anim = {
					charge = "wos_ryoku_h_s1_charge",
					seq = "wos_ryoku_h_s1_t3",
					time = 1,
				},
				air = {
					seq = "wos_ryoku_a_s1_t3",
					charge = "wos_ryoku_a_s1_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
		a = {
			[1] = {
				anim = {
					seq = "wos_ryoku_h_left_t2",
					charge = "wos_ryoku_h_left_charge",
					time = 1,
				},
				air = {
					seq = "wos_ryoku_a_left_t1",
					charge = "wos_ryoku_a_left_charge",
					time = 1,
				},
				speed = 75,
				damage = 0.5,
			},
			[2] = {
				anim = {
					seq = "wos_ryoku_h_left_t2",
					charge = "wos_ryoku_h_left_charge",
					time = 1,
				},
				air = {
					seq = "wos_ryoku_a_left_t2",
					charge = "wos_ryoku_a_left_charge",
					time = 1,
				},
				speed = 75,
				damage = 1,
			},
			[3] = {
				anim = {
					seq = "wos_ryoku_h_left_t3",
					charge = "wos_ryoku_h_left_charge",
					time = 1,
				},
				air = {
					seq = "wos_ryoku_a_left_t3",
					charge = "wos_ryoku_a_left_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
		d = {
			[1] = {
				anim = {
					seq = "wos_ryoku_h_right_t2",
					charge = "wos_ryoku_h_right_charge",
					time = 1,
				},
				air = {
					seq = "wos_ryoku_a_right_t1",
					charge = "wos_ryoku_a_right_charge",
					time = 1,
				},
				speed = 75,
				damage = 0.5,
			},
			[2] = {
				anim = {
					seq = "wos_ryoku_h_right_t2",
					charge = "wos_ryoku_h_right_charge",
					time = 1,
				},
				air = {
					seq = "wos_ryoku_a_right_t1",
					charge = "wos_ryoku_a_right_charge",
					time = 1,
				},
				speed = 75,
				damage = 1,
			},
			[3] = {
				anim = {
					seq = "wos_ryoku_h_right_t3",
					charge = "wos_ryoku_h_right_charge",
					time = 1,
				},
				air = {
					seq = "wos_ryoku_a_right_t1",
					charge = "wos_ryoku_a_right_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
	},
}

lts.forms["Form III: phalanx"] = {
	icon = "II",
	holdtype = "melee2",
	crystalBooster = 0.5,
	idles = {
		up = "wos_phalanx_b_idle",
		left = "wos_phalanx_r_idle",
		right = "wos_phalanx_h_idle"
	},
	runs = {
		up = "wos_phalanx_b_run",
		left = "wos_phalanx_r_run",
		right = "wos_phalanx_h_run"
	},
	moves = {
		w = {
			[1] = {
				anim = {
					charge = "wos_phalanx_h_s1_charge",
					seq = "wos_phalanx_h_s1_t1",
					time = 1,
				},
				air = {
					seq = "wos_phalanx_a_s1_t1",
					charge = "wos_phalanx_a_s1_charge",
					time = 1,
				},
				speed = 75,
				damage = 0.5,
			},
			
			[2] = {
				anim = {
					charge = "wos_phalanx_h_s1_charge",
					seq = "wos_phalanx_h_s1_t2",
					time = 1,
				},
				air = {
					seq = "wos_phalanx_a_s1_t2",
					charge = "wos_phalanx_a_s1_charge",
					time = 1,
				},
				speed = 75,
				damage = 1,
			},
			
			[3] = {
				anim = {
					charge = "wos_phalanx_h_s1_charge",
					seq = "wos_phalanx_h_s1_t3",
					time = 1,
				},
				air = {
					seq = "wos_phalanx_a_s1_t3",
					charge = "wos_phalanx_a_s1_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
		a = {
			[1] = {
				anim = {
					seq = "wos_phalanx_h_left_t2",
					charge = "wos_phalanx_h_left_charge",
					time = 1,
				},
				air = {
					seq = "wos_phalanx_a_left_t1",
					charge = "wos_phalanx_a_left_charge",
					time = 1,
				},
				speed = 75,
				damage = 0.5,
			},
			[2] = {
				anim = {
					seq = "wos_phalanx_h_left_t2",
					charge = "wos_phalanx_h_left_charge",
					time = 1,
				},
				air = {
					seq = "wos_phalanx_a_left_t2",
					charge = "wos_phalanx_a_left_charge",
					time = 1,
				},
				speed = 75,
				damage = 1,
			},
			[3] = {
				anim = {
					seq = "wos_phalanx_h_left_t3",
					charge = "wos_phalanx_h_left_charge",
					time = 1,
				},
				air = {
					seq = "wos_phalanx_a_left_t3",
					charge = "wos_phalanx_a_left_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
		d = {
			[1] = {
				anim = {
					seq = "wos_phalanx_h_right_t2",
					charge = "wos_phalanx_h_right_charge",
					time = 1,
				},
				air = {
					seq = "wos_phalanx_a_right_t1",
					charge = "wos_phalanx_a_right_charge",
					time = 1,
				},
				speed = 75,
				damage = 0.5,
			},
			[2] = {
				anim = {
					seq = "wos_phalanx_h_right_t2",
					charge = "wos_phalanx_h_right_charge",
					time = 1,
				},
				air = {
					seq = "wos_phalanx_a_right_t1",
					charge = "wos_phalanx_a_right_charge",
					time = 1,
				},
				speed = 75,
				damage = 1,
			},
			[3] = {
				anim = {
					seq = "wos_phalanx_h_right_t3",
					charge = "wos_phalanx_h_right_charge",
					time = 1,
				},
				air = {
					seq = "wos_phalanx_a_right_t1",
					charge = "wos_phalanx_a_right_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
	},
}

lts.forms["Form IV: vanguard"] = {
	icon = "II",
	holdtype = "melee2",
	crystalBooster = 0.5,
	idles = {
		up = "vanguard_b_idle",
		left = "vanguard_f_idle",
		right = "vanguard_h_idle"
	},
	runs = {
		up = "vanguard_b_run",
		left = "vanguard_f_run",
		right = "vanguard_h_run"
	},
	moves = {
		w = {
			[1] = {
				anim = {
					charge = "wos_ryoku_h_s1_charge",
					seq = "vanguard_h_s1_t1",
					time = 1,
				},
				air = {
					seq = "vanguard_a_s1_t1",
					charge = "vanguard_a_s1_charge",
					time = 1,
				},
				speed = 75,
				damage = 0.5,
			},
			
			[2] = {
				anim = {
					charge = "wos_ryoku_h_s1_charge",
					seq = "vanguard_h_s1_t2",
					time = 1,
				},
				air = {
					seq = "vanguard_a_s1_t2",
					charge = "vanguard_a_s1_charge",
					time = 1,
				},
				speed = 75,
				damage = 1,
			},
			
			[3] = {
				anim = {
					charge = "wos_ryoku_h_s1_charge",
					seq = "vanguard_h_s1_t3",
					time = 1,
				},
				air = {
					seq = "vanguard_a_s1_t3",
					charge = "vanguard_a_s1_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
		a = {
			[1] = {
				anim = {
					seq = "vanguard_h_left_t2",
					charge = "wos_ryoku_h_s1_charge",
					time = 1,
				},
				air = {
					seq = "vanguard_a_left_t1",
					charge = "wos_ryoku_h_s1_charge",
					time = 1,
				},
				speed = 75,
				damage = 0.5,
			},
			[2] = {
				anim = {
					seq = "vanguard_h_left_t2",
					charge = "wos_ryoku_h_s1_charge",
					time = 1,
				},
				air = {
					seq = "vanguard_a_left_t2",
					charge = "wos_ryoku_h_s1_charge",
					time = 1,
				},
				speed = 75,
				damage = 1,
			},
			[3] = {
				anim = {
					seq = "vanguard_h_left_t3",
					charge = "wos_ryoku_h_s1_charge",
					time = 1,
				},
				air = {
					seq = "vanguard_a_left_t3",
					charge = "wos_ryoku_h_s1_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
		d = {
			[1] = {
				anim = {
					seq = "vanguard_h_right_t2",
					charge = "wos_ryoku_h_s1_charge",
					time = 1,
				},
				air = {
					seq = "vanguard_a_right_t1",
					charge = "wos_ryoku_h_s1_charge",
					time = 1,
				},
				speed = 75,
				damage = 0.5,
			},
			[2] = {
				anim = {
					seq = "vanguard_h_right_t2",
					charge = "wos_ryoku_h_s1_charge",
					time = 1,
				},
				air = {
					seq = "vanguard_a_right_t1",
					charge = "wos_ryoku_h_s1_charge",
					time = 1,
				},
				speed = 75,
				damage = 1,
			},
			[3] = {
				anim = {
					seq = "vanguard_h_right_t3",
					charge = "wos_ryoku_h_s1_charge",
					time = 1,
				},
				air = {
					seq = "vanguard_a_right_t1",
					charge = "wos_ryoku_h_s1_charge",
					time = 1,
				},
				speed = 250,
				damage = 1.5,
			},
		},
	},
}