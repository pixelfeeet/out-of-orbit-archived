# Todo
## General
- Clean up/refactor entire project, especially Player.as
- Sort out naming conventions in level (build, draw, generate) and Player
- Get rid of the all the instances where player and world have to get passed into a function/entity
- Sort out game design/flow -- develop a comprehensive list of interaction/inventory items, enemies, npcs and other game elements
- Re-evaluate inventory system, both as far as UI and code structure (i.e, MVC).
- Construction system might be better off without having a currency system (scraps) and more of an item requirement sort of sytem.
- Fix the camera

## Weapons:
### Melee weapons
Logic:
	Reloading ranged weapons
Assets:
	Improved/cleaner melee attacking logic
	Swinging animation
	Stabbing animation
	Swinging sound
	Stabbing sound

#### Axe (Swing)
Assets:
	Graphic
	Impact sound

#### Wrench (Swing)
Assets:
	Graphic
	Impact sound

#### Lead Pipe (Swing)
Assets:
	Graphic (done)
	Impact sound

#### (Tree) Branch (Swing)
Assets:
	Graphic
	Impact sound

#### Knife (Stab)
Assets:
	Graphic
	Impact sound

### Ranged weapons

#### Rock(s)
#### Pistol
#### Bow/arrows
#### Shotgun
	Logic: short-ranged, many bullets, wide range.  The further away the enemy is
	the less damage they take.  Bullets disappear after they've traveled a certain
	distance.

#### Power blaster/rifle
#### Grenade/Bomb

## Enemies
### Water amoeba
Behavior: not much; just alternates between swimming about and waiting

## Player movement

	Acceleration/decceleration when running
	SMB style jumping--the longer the player holds the jump button down the higher the jump
	Ladders/vines?

