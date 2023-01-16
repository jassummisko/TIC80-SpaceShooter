spawn = (obj) -> add(objs, obj)
waveDelay = 0
waves = {
	->
		spawn Gnawer(scr.width-68, scr.height/2, false, 30)
		spawn Gnawer(scr.width-48, scr.height/2, false, 60)
	->
		spawn Gnawer(scr.width-68, scr.height/2, false, 30)
		spawn Gnawer(scr.width-28, scr.height/2, false, 30)
		spawn Gnawer(scr.width-48, scr.height/2, false, 60)
		spawn Gnawer(scr.width-88, scr.height/2, false, 60)
	->
		spawn Gnawer(scr.width-88, scr.height/2, false, 0)
		spawn Gnawer(scr.width-68, scr.height/2, false, 30)
		spawn Gnawer(scr.width-48, scr.height/2, false, 60)
		spawn TrackerPew(scr.width-28, scr.height/2, false)
	->
		spawn Gnawer(scr.width-88, scr.height/2, false, 0)
		spawn TrackerPew(scr.width-68, scr.height/2, false)
		spawn TrackerPew(scr.width-48, scr.height/2, false)
		spawn TrackerPew(scr.width-28, scr.height/2, false)
	->
		spawn Gnawer(scr.width-88, scr.height/2, false, 0)
		spawn TrackerPew(scr.width-68, scr.height/2, false)
		spawn TrackerPew(scr.width-48, scr.height/2, false)
		spawn PatrolPew(scr.width-28, scr.height/2, false)
}	

export spawnWaves = ->
	unless containsType objs, Enemy
		waveDelay -= 1
		if waveDelay <= 0
			waves[rnd(#waves)]!
			waveDelay = 60