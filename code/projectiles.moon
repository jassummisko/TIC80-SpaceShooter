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
			@alive = false
		@collision!

	collision: => 
		for obj in *objs
			if collide(obj, self) and obj.type == types.Enemy 
				@alive = false
				return

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
			add particles, Scrap @x, @y+4, rnd(-30, 30), 0, colors.LightRed, rnd(60)

	collision: =>
		---PASS

class Bolt extends Projectile
	speed: 7
	spr: 260
	damage: 1
	cooldown: 4

	update: =>
		super!
		@x += @speed

	collision: =>
		---PASS

class Bomb extends Projectile
	speed: 5
	spr: 276
	damage: 20
	cooldown: 150

	new: (...) =>
		super ...
		@targetX = 100+@x
		@exploded = false
		@explodedDuration = 2

	update: =>
		super!
		@alive = @explodedDuration > 0
		@x += (@targetX - @x) * 0.05 unless @exploded
		@explodedDuration -= 1 if @exploded

	explode: =>
		@x -= 64
		@y -= 64
		@w  = 16*2
		@h  = 16*2
		@draw = -> 

	collision: =>
		if @exploded then return
		for obj in *objs
			if obj.type == types.Enemy and collide(obj, self)
				for i=1, 200
					add particles, 
						Particle @x+4, @y+4, (rnd 360), (rnd 5, 10), 
							colors.LightRed, (rnd 10, 30) unless @exploded

				@exploded = true
				@explode!