spawn = (obj) -> add(Objs, obj)
waveDelay = 0
waves = {
	->
		spawn Gnawer(SCR.width-68, SCR.height/2, false, 30)
		spawn Gnawer(SCR.width-48, SCR.height/2, false, 60)
	->
		spawn Gnawer(SCR.width-68, SCR.height/2, false, 30)
		spawn Gnawer(SCR.width-28, SCR.height/2, false, 30)
		spawn Gnawer(SCR.width-48, SCR.height/2, false, 60)
		spawn Gnawer(SCR.width-88, SCR.height/2, false, 60)
	->
		spawn Gnawer(SCR.width-88, SCR.height/2, false, 0)
		spawn Gnawer(SCR.width-68, SCR.height/2, false, 30)
		spawn Gnawer(SCR.width-48, SCR.height/2, false, 60)
		spawn TrackerPew(SCR.width-28, SCR.height/2, false)
	->
		spawn Gnawer(SCR.width-88, SCR.height/2, false, 0)
		spawn TrackerPew(SCR.width-68, SCR.height/2, false)
		spawn TrackerPew(SCR.width-48, SCR.height/2, false)
		spawn TrackerPew(SCR.width-28, SCR.height/2, false)
	->
		spawn Gnawer(SCR.width-88, SCR.height/2, false, 0)
		spawn TrackerPew(SCR.width-68, SCR.height/2, false)
		spawn TrackerPew(SCR.width-48, SCR.height/2, false)
		spawn PatrolPew(SCR.width-28, SCR.height/2, false)
}	

export spawnWaves = ->
	unless containsType Objs, Enemy
		waveDelay -= 1
		if waveDelay <= 0
			waves[rnd(#waves)]!
			waveDelay = 60