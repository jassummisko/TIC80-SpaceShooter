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
	type: types.Projectile
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
		--PASS
