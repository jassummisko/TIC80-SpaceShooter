export _DRAWGUI=->
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

