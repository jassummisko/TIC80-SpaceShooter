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
include "code.entity"
include "code.items"
include "code.projectiles"
include "code.weapons"
include "code.player"

include "code.enemies.base"
include "code.enemies.gnawer"
include "code.enemies.trackerPew"
include "code.enemies.patrolPew"

include "code.waves"

include "code.collisions"

include "code.gui"

export doStarfield = ->
	if t%3 == 0 
		px = scr.width
		py = rnd(scr.height)
		dir = 180
		spd = rnd 3, 8
		add particles, Star(px, py, dir, spd)

export BOOT=->
	export plr = Plr!
	add objs, plr

export UPDATE=->
	updateAll particles
	updateAll objs
	removeObjs particles
	removeObjs objs
	doCollisions objs
	doStarfield!
	spawnWaves!	
	
export DRAW=->
	cls 0
	drawAll(particles)
	drawAll(objs)
	_DRAWGUI!
	drawDebug! if debug	

export TIC=->
	poke(0x3FFB,0)	-- remove cursor
	t+=1

	UPDATE!
	DRAW!

