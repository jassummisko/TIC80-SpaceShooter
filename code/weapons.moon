WEAPONS = {}

registerWeapon = (wpn) -> add WEAPONS, wpn

class Weapon
    projectile: Bullet
	sfx: sounds.genericAttack
    new: (user) =>
        @user = user
    
    shoot: =>
        bullet = (@projectile) @user.x+16, @user.y
        if @user.cooldown <= 0
            @user.cooldown = bullet.cooldown
            sfx @sfx, 24, 120, 1
            add objs, bullet

WEAPONS[0] = Weapon

class WeaponBolt extends Weapon
    projectile: Bolt
    sfx: sounds.bolt
    
    shoot: =>
        bullet = (@projectile) @user.x+16, @user.y
        if @user.cooldown == 0 	
            @user.cooldown = bullet.cooldown
            if @user.ammo.Yellow >= 3
                sfx @sfx, 32, 120, 1
                add objs, bullet
                @user.ammo.Yellow -= 3
            else 
                for i=1, rnd -1, 1
                    add particles, 
                        Particle @user.x+@user.w*8, @user.y+4, (20 - rnd 40), 
                            (rnd 1, 3), colors.LightYellow, (rnd 10, 30) for i=1, 4
                    sfx sounds.spark

class WeaponBomb extends Weapon
    projectile: Bomb

    shoot: =>
        bullet = (@projectile) @user.x+16, @user.y
        if @user.cooldown == 0
            if @user.ammo.Red >= 200
                @user.cooldown = bullet.cooldown
                add objs, bullet
                @user.ammo.Red -= 200

registerWeapon WeaponBolt
registerWeapon WeaponBomb