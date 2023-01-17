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

		@x = SCR.width
		@ycen = y or SCR.height/2
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
		@attack! if @frame > @attackTime
		@die! if @health <= 0

	draw: =>
		if @blink > 0 pal(COLORS.DarkYellow, COLORS.White)
		spr(@spr, @x, @y, @alpha, 1, @flip, @rot, @w, @h)
		pal(COLORS.DarkYellow, COLORS.DarkYellow)

	move: =>
		@spawn!
		@y = @ycen + flr(30 * (sin(rad(@frame*@bobSpeed+@offset))))
		@x -= @speed
		@x = SCR.width+16 if @x <= -16

	attack: =>
		@speed = @attackSpeed

	damage: (amt) =>
		sfx(SOUNDS.hit, 0, 120, 0)
		@blink = 2
		@health -= amt
		for i=1, 2
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add(Particles, Scrap(@x+4, @y+4, dir, 0, COLORS.White, life))

	die: =>
		super!
		sfx(SOUNDS.boom, 0, 120, 0)
		for i=1, 20
			dir = rnd(0, 360)
			life = rnd(10, 40)
			add(Particles, Scrap(@x+4, @y+4, dir, 0, COLORS.DarkYellow, life))
		
		add Objs, YellowAmmo plr, @x, @y for i=1, rnd 3, 10