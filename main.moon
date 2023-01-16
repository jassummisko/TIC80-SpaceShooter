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
include "code.weapons"
include "code.player"

include "code.enemies.base"
include "code.enemies.gnawer"
include "code.enemies.trackerPew"
include "code.enemies.patrolPew"

include "code.waves"

_DRAWGUI=->
	--PLR AND SCR ARE GLOBAL
	rectb(0, 0, scr.width, scr.height, 12)
	printShadow("Score: "..plr.score, 4, 4, 8, 12)
	printShadow("PRESS CTRL-R TO RESTART", 60, scr.height/2-4, 8, 12) if not plr.alive

	barSize = 40

	--- RED BAR
	rect  80, 4, plr.ammo.Red/10, 6, colors.LightRed
	rectb 80, 4, barSize, 6, colors.DarkRed

	--- YELLOW BAR
	rect  130, 4, plr.ammo.Yellow/10, 6, colors.LightYellow
	rectb 130, 4, barSize, 6, colors.DarkYellow

	--- BLUE BAR
	rect  180, 4, plr.ammo.Blue/10, 6, colors.LightBlue
	rectb 180, 4, barSize, 6, colors.DarkBlue

export BOOT=->
	export plr = Plr!
	add objs, plr
	
export TIC=->
	poke(0x3FFB,0)	-- remove cursor
	t+=1

	_UPDATE!
	_DRAW!

export doCollisions = (objs) ->
	for i, obj1 in ipairs objs
		for obj2 in *objs[i,]
			if collide obj1, obj2

				--use "continue if" to override collision
				--otherwise, do not use "continue if"

				continue if doCollide obj1, Plr, obj2, Enemy, ->
					obj1\kill!
					obj2\kill!
				
				continue if doCollide obj1, Plr, obj2, Projectile, ->
					if obj2.enemy
						obj1\kill!
						obj2\kill! 
				
				continue if doCollide obj1, Enemy, obj2, Bolt, ->
					obj1\damage obj2.damageVal unless obj2.enemy

				doCollide obj1, Enemy, obj2, Bomb, ->
					obj2\explode! unless obj2.exploded
					
				continue if doCollide obj1, Enemy, obj2, Projectile, ->
					unless obj2.enemy
						obj1\damage obj2.damageVal
						obj2\kill!

export _UPDATE=->
	updateAll particles
	updateAll objs
	removeObjs particles
	removeObjs objs
	doCollisions objs

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

	_DRAWGUI!
		
	if debug
		print("Objects: "..#objs, 4, 16, 12)
		print("Particles: "..#particles, 4, 24, 12)