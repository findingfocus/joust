X_Figure hunter ai dx
X_Figure shadowLord dx
X_Figure hunter flapping
X_Figure shadowlord flapping
X_Destanstantiate Taxi if egg collected
X_Add collide sound restriction if vulture just collided
X__Add jumping to taxi class
X_Add top collision with platforms to Taxi
X_Add jumping to taxi class only if taxi.y > jockey.y
X_Add blue jockey if bounder is killed
X_Check original game for what jockey is spawned when shadowlord is killed and egg is popped
X_Need to ensure taxi picks up jockey on middle platform in tricky spot
X_Research how scores are calculated in original
X_Sometimes two taxis get animation locked in with one another??
X_Reset midairBonus if vulture tier upgraded
X_Add scoreamount to global table upon egg collection based on eggsCaught
X_Check for appropriate scores upon vulture unseating
X_Ensure midairBonus remains false upon egg hatch
X_Ensure midair bonus increments score, not just renders the bonus
X_raise lava level after wave 1
X_raise bubble pops with lava level
X_Add spawnDelay into Vulture class as parameter
X_Configure vulture class so that SpawnDelay doesnt screw up the vulture spawn render
X_Ensure vulture inherits x and y parameter once out of graveyard
X_Factor Vulture spawns into a function that scales with enemyObjects
X_Add wave 2 spawns
X_Add wave 2 text
X_Fix wonky Vulture to Vulture collision
X_Add corrected side collision for player and retracted groundPlatform
X_Side collision of eggs to retracted platfrom
X_Side collision for vultures and groundPlatform
X_Check ptero timer for correct functioning through waves
X_Retract ground platorm for wave 3+
X_Ensure Correct Placement of platforms and ground with original game
X_Add platform retract only on wave 3
X_Potentially take out ability to kill vultures from behind
X_Ensure player and eggs die at correct lavaheight if they touch lava
X_Add low height vulture jump so they dont die in lava
X_Add successful wave clear to score
X_Add flames burning away groundPlatform
X_Only render plaftorm fire if platform is retracting
X_Populate timesEggHatched with 0s based on enemyObjects in global populates
X_Lava to be just above the burned away platform
X_Get proper wave text delay and vulture spawn time.
X_Add left and right arrow key functionality as well as the h l controls for  development purposes
X_Match Lava Heights from famicom version
X_Egg wave, egg on plaform1L, two on platform 2, 1 in tricky corner,1 on 5, two on ground
X_Ensure Eggs in wave 5 don't hatch into Vulture
X_Add wave 6 spawns
X_Move game over to be in low-center position
X_Wave 6 disappears main center platform 2 ?
X_Ensure platform 2 disappears from collidablePlatforms table once it is retracted
X_Add lavatroll animation
X_REMOVE SPAWNZONEPOINT 2 ONCE PLATFORM2 is RETRACTED!!!!!
X_Change trollGrab.x to track player for frames 1-3
__Put Ptero inits into update function not in wave function
__Come up with better way to check if all enemyObjects.hatched == true
__Ensure Vultures have midair bonus in wave 2
__Dummy initialization function implement
__Add portal sound on vulture spawn (player spawn?)
__How do we wipe away spawn zone point upon platform Retraction considering the render order?
--I am deciding not to add trollGrab for vultures, because I want to move on to another project


Unseating Bounder   500 Unseating Hunter    750 Unseating Shadowlord    1500
Killing Pterodactyl 1000
First Egg   250
Second Egg  500
Third Egg   750
Fourth+ Egg 1000
Egg bonus in air    500
SUCCESSFUL WAVE 3000

**Losing mount resets Egg to base Value
