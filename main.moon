-- title:   Zhmup
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  moon

include "code.globals"
include "code.utils"
include "code.particles"
include "code.entity"
include "code.items"
include "code.projectiles"
include "code.player"

include "code.enemies.base"
include "code.enemies.gnawer"
include "code.enemies.trackerPew"
include "code.enemies.patrolPew"

include "code.waves"

export BOOT=->
	export plr = Plr!
	add objs, plr
	
export TIC=->
	poke(0x3FFB,0)	-- remove cursor
	t+=1

	_UPDATE!
	_DRAW!

export _UPDATE=->
	updateAll particles
	updateAll objs
	removeObjs particles
	removeObjs objs

	if t%3 == 0 
		px = scr.width
		py = rnd(scr.height)
		dir = 180
		spd = rnd 3, 8
		add particles, Star(px, py, dir, spd)

	spawnWaves!	
	
export _DRAW=->
	cls 0
	
	drawAll(particles)
	drawAll(objs)

	rectb(0, 0, scr.width, scr.height, 12)
	printShadow("Score: "..plr.score, 4, 4, 8, 12)

	printShadow("PRESS CTRL-R TO RESTART", 60, scr.height/2-4, 8, 12) if not plr.alive
		
	if debug
		print("Objects: "..#objs, 4, 16, 12)
		print("Particles: "..#particles, 4, 24, 12)
