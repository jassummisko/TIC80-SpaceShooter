class Projectile extends Entity
	damageVal: 0
	cooldown: 0
	speed: 0
	spr: 0

	new: (...) =>
		super ...

	update: =>
		super!
		@alive = false if (@x > SCR.width+8) or (@x < -8)

class Bullet extends Projectile
	speed: 5
	spr: 272
	frame: 0
	cooldown: 8
	damageVal: 1

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
	damageVal: 2
	new: (...) =>
		args = {...}
		@enemy = pop args
		super unpack args

	update: =>
		super!
		@x -= @speed

	kill: =>
		super!
		for i=1, 15
			add Particles, Scrap @x, @y+4, rnd(-30, 30), 0, COLORS.LightRed, rnd(60)

class Bolt extends Projectile
	speed: 7
	spr: 260
	damageVal: 0.5
	cooldown: 4

	update: =>
		super!
		@x += @speed

class Bomb extends Projectile
	speed: 5
	spr: 276
	damageVal: 20
	cooldown: 150

	new: (...) =>
		super ...
		@targetX = 100+@x
		@exploded = false
		@explodedDuration = 2
		@lint = 90

	update: =>
		super!
		@alive = @explodedDuration > 0
		@x += (@targetX - @x) * 0.05 unless @exploded
		@explodedDuration -= 1 if @exploded
		if @lint >= 60
			@lint -= 1
		else
			@explode! unless @exploded
			@exploded = true			

	explode: =>
		for i=1, 200
			add Particles, 
				Particle @x+4, @y+4, (rnd 360), (rnd 5, 10), 
					COLORS.LightRed, (rnd 10, 30) unless @exploded

		@exploded = true
		@x, @y = 0, 0
		@w, @h = 16*2, 16*2
		@draw = -> 