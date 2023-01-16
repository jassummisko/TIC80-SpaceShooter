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
		@col1 = colors.DarkBlue
		@col2 = colors.LightBlue
		@speed = 1
		@dir = 1

	update: =>
		super!

		@attackTime -= 1
		@blink = max(0, @blink-1)

		@move!

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
			add(particles, Scrap(@x+4, @y+4, dir, 0, colors.DarkBlue, life))

		add objs, BlueAmmo plr, @x, @y for i=1, rnd(3, 9)

	attack: =>
		sfx(sounds.laser)
		add(objs, Laser(@x-2, @y+4, false, true))