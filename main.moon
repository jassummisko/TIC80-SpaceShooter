-- title:   Zhmup
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  moon

include "code.debug"
include "code.globals"
include "code.utils"
include "code.particles"
include "code.entities.entityBase"
include "code.entities.items"
include "code.entities.projectiles"
include "code.weapons"
include "code.entities.player"

include "code.entities.enemies.enemyBase"
include "code.entities.enemies.gnawer"
include "code.entities.enemies.trackerPew"
include "code.entities.enemies.patrolPew"

include "code.waves"

include "code.collisions"

include "code.gui"

export doStarfield = ->
	if t%3 == 0 
		px = SCR.width
		py = rnd(SCR.height)
		dir = 180
		spd = rnd 3, 8
		add Particles, Star(px, py, dir, spd)

export BOOT=->
	export plr = Plr!
	add Objs, plr

export UPDATE=->
	updateAll Particles
	updateAll Objs
	removeObjs Particles
	removeObjs Objs
	doCollisions Objs
	doStarfield!
	spawnWaves!	
	
export DRAW=->
	cls 0
	drawAll(Particles)
	drawAll(Objs)
	_DRAWGUI!
	drawDebug! if debug	

export TIC=->
	poke(0x3FFB,0)	-- remove cursor
	t+=1

	UPDATE!
	DRAW!