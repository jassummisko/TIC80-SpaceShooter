--
-- Bundle file
-- Code changes will be overwritten
--

-- title:   Zhmup
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  moon

-- [TQ-Bundler: code.globals]

debug = false
t = 0
scr = {
	width: 240
	height: 136
}

objs = {}
particles = {}

do --enums
	export colors = {
		TransBlack: 0
		DarkPurple: 1
		LightPurple: 7
		DarkRed: 2
		LightRed: 3
		DarkYellow: 4
		LightYellow: 14
		DarkGreen: 6
		LightGreen: 5
		DarkBlue: 8
		LightBlue: 9
		DarkCyan: 10
		LightCyan: 11
		White: 12
		Gray: 13
	}

	export sounds = {
		genericAttack: 0
		boom: 1
		hit: 2
		laser: 3
		pickUp: 4
	}

	export types = {
		Player: 1
		Enemy: 2
		Projectile: 3
		EnemyProjectile: 4
		Item: 5
	}
	types.None = 0

	export weapons = {
		Bullet: 0
		Bolt: 1
	}

-- [/TQ-Bundler: code.globals]

-- [TQ-Bundler: code.utils]

do --table functions
	export add = table.insert
	export pop = table.remove
	export delObj = (tab, element) ->
		for i=#tab, 1, -1
			if tab[i] == element
				pop(tab, i)
	export removeObjs = (tab) ->
		for i=#tab, 1, -1
			if tab[i].alive == false
				pop(tab, i)
	export containsType = (tab, typ) ->
		for i=#tab, 1, -1
			if tab[i].type == typ
				return true
		return false

do --math functions
	export max = math.max
	export min = math.min
	export sin = math.sin
	export rad = math.rad
	export cos = math.cos
	export rad = math.rad
	export rnd = math.random
	export abs = math.abs
	export flr = math.floor
	
do --utilities
	export unpack = table.unpack
	export printShadow = (...) ->
		args = {...}
		text = args[1]
		x = args[2]
		y = args[3]
		colShadow = args[4]
		colText = args[5]

		print text, x+1, y+1, colShadow
		print text, x, y, colText
	export collide = (o1, o2) ->
		hit = false

		tileSize = 8
		w1 = o1.w*tileSize
		w2 = o2.w*tileSize
		h1 = o1.h*tileSize
		h2 = o2.h*tileSize
		x1, x2 = o1.x, o2.x
		y1, y2 = o1.y, o2.y

		xs = w1/2 + w2/2
		ys = h1/2 + h2/2
		xd = abs (x1 + w1/2) - (x2 + w2/2) 
		yd = abs (y1 + h1/2) - (y2 + h2/2) 

		if xd<xs and yd<ys then
			hit = true

		return hit

	export pal = (...) ->
		args = {...}
		if #args == 2
			c1 = args[1]
			c2 = args[2]
			PALETTE_MAP = 0x3FF0
			poke4(PALETTE_MAP * 2 + c1, c2)
		elseif #args == 1
			c1 = args[1]
			pal(c1, c1)

	export updateAll = (tab) -> (unless element == nil then element\update!) for element in *tab
	export drawAll = (tab) -> (unless element == nil then element\draw!) for element in *tab

-- [/TQ-Bundler: code.utils]

-- [TQ-Bundler: code.particles]

--Particles
class Particle
	new: (x, y, dir, speed, col, life) =>
		@x = x
		@y = y
		@dir = dir
		@speed = speed
		@col = @col or col or 12
		@life = @life or life or 60
		@alive = true
	update: =>
		@x += (cos rad @dir) * @speed
		@y += (sin rad @dir) * @speed
		@life -= 1
		if @life < 0
			@alive = false

	draw: =>
		rect(@x, @y, 1, 1, @col)

class Star extends Particle
	col: 12
	life: 80

class Scrap extends Particle
	update: =>
		@speed = @life/10
		@x += math.cos(math.rad(@dir)) * @speed
		@y += math.sin(math.rad(@dir)) * @speed
		@life -= 1
		if @life < 0
			delObj(particles, self)

-- [/TQ-Bundler: code.particles]

-- [TQ-Bundler: code.entity]

--Entities
class Entity
	type: types.None
	new: (x, y, flip) =>
		@type = @type or types.None
		@x = x or 60
		@y = y or scr.height/2
		@flip = flip or false
		@alpha = @alpha or 0
		@rot = 0
		@w = @w or 1
		@h = @h or 1
		@spr = @spr or 256
		@alive = true
		@frame = 0

	update: =>
		@frame += 1

	draw: =>
		spr(@spr, @x, @y, @alpha, 1, @flip, @rot, @w, @h)

	kill: =>
		@alive = false


-- [/TQ-Bundler: code.entity]

-- [TQ-Bundler: code.items]

class Item extends Entity
	type: types.Item
	new: (target, ...) =>
		super ...
		@target = target
		@restTime = 40

	update: =>
		super!
        @collision!

    collision: =>
        

class AmmoDrop extends Item
    ammoType: "Yellow"
    color: 0
	new: (...) =>
		super ...
        @restTime = 60
        @spawnTargetOffsetX = @x + rnd -20, 20
        @spawnTargetOffsetY = @y + rnd -20, 20
	
	update: =>
		super!
        @spawnMove! if @frame <= @restTime
		@moveTowardsPlayer! if @frame > @restTime

    spawnMove: =>
		@x += (@spawnTargetOffsetX - @x) * 0.05 
		@y += (@spawnTargetOffsetY - @y) * 0.05 
        

    collision: =>
		for obj in *objs
			if obj.type == types.Player
				if collide(obj, self)
					@kill!
                    sfx sounds.pickUp
                    obj.ammo[@ammoType] = min obj.ammo[@ammoType]+5, 600

	moveTowardsPlayer: =>
        targetX = @target.x + (@target.w*8)/2 -- get center of target
        targetY = @target.y + (@target.h*8)/2 -- get center of target
		@x += (targetX - @x) * 0.08 
		@y += (targetY - @y) * 0.08 

	draw: =>
		rectb @x, @y, 3, 3, @color


class YellowAmmo extends AmmoDrop
    ammoType: "Yellow"
    color: colors.LightYellow

class BlueAmmo extends AmmoDrop
    ammoType: "Blue"
    color: colors.LightBlue

class GreenAmmo extends AmmoDrop
    ammoType: "Green"
    color: colors.LightGreen

class RedAmmo extends AmmoDrop
	ammoType: "Red"
	color: colors.LightRed

-- [/TQ-Bundler: code.items]

-- [TQ-Bundler: code.projectiles]

--Bullets
class Projectile extends Entity
	type: types.Projectile
	damage: 0
	cooldown: 0
	speed: 0
	spr: 0
	sfx: 0

	new: (...) =>
		super ...

	update: =>
		super!
		if (@x > scr.width+8) or (@x < -8)
			self.alive = false
		@collision!

	collision: =>
		for obj in *objs
			if obj.type == types.Enemy
				if collide(obj, self)
					self.alive = false

class Bullet extends Projectile
	speed: 5
	spr: 272
	frame: 0
	cooldown: 8
	damage: 1
	sfx: sounds.genericAttack
	update: =>
		super!
		@animate!
		
	animate: =>
		if @frame >= 4
			@frame = 0
			if @spr > 272
				@spr = 272
			else
				@spr += 1
		@x += @speed

class Laser extends Projectile
	speed: 4
	spr: 274
	damage: 2
	new: (...) =>
		args = {...}
		enemy = pop(args)
		super table.unpack(args)

		if enemy then
			@type = types.EnemyProjectile

	update: =>
		super!
		@x -= @speed

	kill: =>
		super!
		for i=1, 15
			add(particles, Scrap(@x, @y+4, rnd(-30, 30), 0, colors.LightRed, rnd(60)))

	collision: =>
		---PASS

class Bolt extends Projectile
	speed: 7
	spr: 260
	damage: 2
	cooldown: 4

	update: =>
		super!
		@x += @speed

	collision: =>
		---PASS

-- [/TQ-Bundler: code.projectiles]

-- [TQ-Bundler: code.player]

--Player
class Plr extends Entity
	type: types.Player
	speed: 2
	spr: 256
	alpha: 1
	w: 2
	h: 1
	cooldown: 0
	wpn: weapons.Bullet
	wpns: {
		[0]: weapons.Bullet
		[1]: weapons.Bolt 
	}
	score: 0
	health: 1
	ammo: {
		Yellow: 0
		Blue: 0
		Green: 0
		Red: 0
	}

	update: =>
		@controls!
		@cooldown -= 1 if @cooldown > 0

		fuelCols = {colors.LightRed, colors.DarkYellow, colors.Gray}
		for i=1, 2
			add particles, 
				Particle @x, @y+4, (160+rnd 40), (rnd 1, 3)/2, fuelCols[rnd #fuelCols ], (rnd 10, 30)

		@collision!
		@die! if @health <= 0

	draw: => 
		super!

	controls: =>
		if btn 0
			@y = max @y-@speed, 8
		if btn 1
			@y = min @y+@speed, scr.height-16
		if btn 2
			@x = max @x-@speed, 0
		if btn 3
			@x = min @x+@speed, scr.width-16
		if btn 4
			@shoot!
		if btnp 5
			@wpn = (@wpn + 1) % (#@wpns+1)


	shoot: =>
		switch @wpn 
			when weapons.Bullet
				bullet = Bullet @x+16, @y
				if @cooldown == 0
					@cooldown = bullet.cooldown
					sfx bullet.sfx, 24, 120, 1
					add objs, bullet
			
			when weapons.Bolt
				bullet = Bolt @x+16, @y
				if @cooldown == 0 	
					@cooldown = bullet.cooldown
					if @ammo.Yellow > 0
						sfx bullet.sfx, 24, 120, 1
						add objs, bullet
						@ammo.Yellow -= 3
					else 
						for i=1, rnd 0, 1
							add particles, 
								Particle @x+@w*8, @y+4, (20 - rnd 40), (rnd 1, 3), colors.LightYellow, (rnd 10, 30)

	die: =>
		sfx(sounds.boom, 0, 120, 0)
		for i=1, 15
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add particles, (Scrap @x+8, @y+4, dir, 0, colors.Gray, life)
		@alive = false

	damage: (amt) => @health -= amt

	collision: =>
		for obj in *objs
			if obj.type == types.Enemy or obj.type == types.EnemyProjectile
				if collide(obj, self)
					@die!
					obj\kill!

-- [/TQ-Bundler: code.player]


-- [TQ-Bundler: code.enemies.base]

class Enemy extends Entity
	type: types.Enemy
	score: 0

	collision: =>
		for obj in *objs
			if obj.type == types.Projectile
				if collide(obj, self)
					@damage(obj.damage)

	spawn: =>
		if @spawning
			@x = math.floor(@x + (@targetX - @x) * 0.1)
			@spawning = false if @x == @targetX

	die: =>
		@alive = false
		plr.score += @score	

	kill: => @health = 0

-- [/TQ-Bundler: code.enemies.base]

-- [TQ-Bundler: code.enemies.gnawer]

class Gnawer extends Enemy
	alpha: 1
	w: 1
	h: 1
	spr: 258
	score: 5
	
	new: (...) =>
		args = {...}
		offset = pop args
		super unpack args

		@targetX = @x
		@spawning = true

		@x = scr.width
		@ycen = y or scr.height/2
		@health = 6
		@frame = 0
		@bobSpeed = 3
		@attackTime = rnd(80, 200)
		@speed = 0
		@attackSpeed = 2
		@blink = 0
		@offset = offset

	update: =>
		super!
		@blink = max(0, @blink-1)

		@move!
		@collision!
		@attack! if @frame > @attackTime
		@die! if @health <= 0

	draw: =>
		if @blink > 0 pal(colors.DarkYellow, colors.White)
		spr(@spr, @x, @y, @alpha, 1, @flip, @rot, @w, @h)
		pal(colors.DarkYellow, colors.DarkYellow)

	move: =>
		@spawn!
		@y = @ycen + flr(30 * (sin(rad(@frame*@bobSpeed+@offset))))
		@x -= @speed
		@x = scr.width+16 if @x <= -16

	attack: =>
		@speed = @attackSpeed

	damage: (amt) =>
		sfx(sounds.hit, 0, 120, 0)
		for i=1, 2
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add(particles, Scrap(@x+4, @y+4, dir, 0, colors.White, life))
		@blink = 2
		@health -= amt

	die: =>
		super!
		sfx(sounds.boom, 0, 120, 0)
		for i=1, 20
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add(particles, Scrap(@x+4, @y+4, dir, 0, colors.DarkYellow, life))
		for i=1, rnd 3, 10
			add objs, YellowAmmo plr, @x, @y

-- [/TQ-Bundler: code.enemies.gnawer]

-- [TQ-Bundler: code.enemies.trackerPew]

class TrackerPew extends Enemy
	w: 1
	h: 2
	spr: 259
	score: 10

	new: (...) =>
		super ...
		@blink = 0
		@spawning = true

		@health = 12
		@moveTime = rnd(40, 120)
		@attackTime = rnd(120, 240)
		@targetY = plr.y
		@targetX = @x
		@x = scr.width

	update: =>
		super!
		@attackTime -= 1
		@moveTime -= 1
		@blink = max 0, @blink-1

		@move!
		@collision!

		if @health <= 0
			@die!

		if @attackTime <= 0
			@attack!
			@attackTime = rnd(120, 240)

	draw: =>
		if @blink > 0 
			pal(colors.DarkRed, colors.White)
		if @blink > 0 
			pal(colors.LightRed, colors.White)
		spr(@spr, @x, @y, @alpha, 1, @flip, @rot, @w, @h)
		pal(colors.DarkRed) 
		pal(colors.LightRed)

	move: =>
		@spawn!

		@targetY = max(2, min(plr.y, scr.height-16))

		if @moveTime <= 0
			@y = math.floor(@y + ((@targetY - @y) * 0.2))
			if @y == @targetY
				@moveTime = rnd(40, 120)

	damage: (amt) =>
		sfx(sounds.hit, 0, 120, 0)
		for i=1, 2
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add(particles, Scrap(@x+4, @y+4, dir, 0, colors.White, life))
		@blink = 2
		@health -= amt

	die: =>
		super!
		sfx(sounds.boom, 0, 120, 0)
		for i=1, 20
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add particles, Scrap(@x+4, @y+4, dir, 0, colors.DarkRed, life)

		for i=1, rnd(3, 9)
			add objs, RedAmmo plr, @x, @y

	attack: =>
		sfx sounds.laser
		add objs, Laser @x-2, @y+4, false, true

-- [/TQ-Bundler: code.enemies.trackerPew]

-- [TQ-Bundler: code.enemies.patrolPew]

class PatrolPew extends Enemy
	w: 1
	h: 2
	spr: 259
    score: 10

	new: (...) =>
		super ...
		@health = 12
		@blink = 0
		@attackTime = rnd(60, 120)
		@targetX = @x
		@x = scr.width
		@spawning = true
		@col1 = colors.DarkCyan
		@col2 = colors.LightCyan
		@speed = 1
		@dir = 1

	update: =>
		super!

		@attackTime -= 1
		@blink = max(0, @blink-1)

		@move!
		@collision!

		if @health <= 0
			@die!

		if @attackTime <= 0
			@attack!
			@attackTime = rnd(100, 200)

	draw: =>
		if @blink > 0 then pal(colors.DarkRed, colors.White) else pal(colors.DarkRed, @col1)
		if @blink > 0 then pal(colors.LightRed, colors.White) else pal(colors.LightRed, @col2)
		spr(@spr, @x, @y, @alpha, 1, @flip, @rot, @w, @h)
		pal(colors.DarkRed, colors.DarkRed)
		pal(colors.LightRed, colors.LightRed)

	move: =>
		@spawn!
		@y += @speed * @dir
		if @y <= 2 				then @dir =  1
		if @y >= scr.height-18	then @dir = -1

	damage: (amt) =>
		sfx(sounds.hit, 0, 120, 0)
		for i=1, 2
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add(particles, Scrap(@x+4, @y+4, dir, 0, colors.White, life))
		@blink = 2
		@health -= amt

	die: =>
        super!
		sfx(sounds.boom, 0, 120, 0)
		for i=1, 20
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add(particles, Scrap(@x+4, @y+4, dir, 0, colors.DarkRed, life))

	attack: =>
		sfx(sounds.laser)
		add(objs, Laser(@x-2, @y+4, false, true))

-- [/TQ-Bundler: code.enemies.patrolPew]


-- [TQ-Bundler: code.waves]

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
	unless containsType objs, types.Enemy
		waveDelay -= 1
		if waveDelay <= 0
			waves[rnd(#waves)]!
			waveDelay = 60

-- [/TQ-Bundler: code.waves]


_DRAWGUI=->
	--PLR AND SCR ARE GLOBAL
	rectb(0, 0, scr.width, scr.height, 12)
	printShadow("Score: "..plr.score, 4, 4, 8, 12)
	printShadow("PRESS CTRL-R TO RESTART", 60, scr.height/2-4, 8, 12) if not plr.alive

	rect  80, 4, plr.ammo.Red/10, 6, colors.LightRed
	rectb 80, 4, 60, 6, colors.DarkRed

	--- YELLOW BAR
	rect  150, 4, plr.ammo.Yellow/10, 6, colors.LightYellow
	rectb 150, 4, 60, 6, colors.DarkYellow

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

	_DRAWGUI!
		
	if debug
		print("Objects: "..#objs, 4, 16, 12)
		print("Particles: "..#particles, 4, 24, 12)
-- <SPRITES>
-- 000:1111111111ccc1111c000c111c0d00ccc000d000c0000000cccccccc11111111
-- 001:111111111111111111111111ccccc1110000dc11000000c1ccccccc111111111
-- 002:1144411114000411114400411111400411440041140004111144411111111111
-- 003:0002200000030200000302000003020000030200000302000000020002220200
-- 004:000000000000000000e000000e0e000ee000e0e000000e000000000000000000
-- 016:0000000000000000000330000334430033444300003330000000000000000000
-- 017:0000000000000000000330003344430003344300003330000000000000000000
-- 018:0000000000000000000000002222222233333333000000000000000000000000
-- 019:0222020000000200000302000003020000030200000302000003020000022000
-- 020:0000000000033000003223000324e23003244230003223000003300000000000
-- </SPRITES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- 003:e28030b0460db00630c0504b8050e050
-- </WAVES>

-- <SFX>
-- 000:20503040602080109010b000c000e000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000f000210000000000
-- 001:03080308030803f713f74357534763378327a327c307d307e307f307f307f307f300f300f300f300f300f300f300f300f300f300f300f300f300f300000000000000
-- 002:03f04370d330f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300f300000000000000
-- 003:2323333d43645303630302e002e002b00290027001500140d130e110f110f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100310000000000
-- 004:01f00100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100f100400000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:000000d800d8d80000ff0000d8d80000ff0000d800ff00ff0000d80000ff00d8d800ffffffffffd8d8d8ffff00000000
-- </PALETTE>

