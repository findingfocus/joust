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
__Add wave 2 text
__Put Ptero inits into update function not in wave function
__Factor Vulture spawns into a function that scales with enemyObjects
__Add wave 2 spawns
__Come up with better way to check if all enemyObjects.hatched == true


SCORE UPDATE
Unseating Bounder   500
Unseating Hunter    750
Unseating Shadowlord    1500
Killing Pterodactyl 1000
First Egg   250
Second Egg  500
Third Egg   750
Fourth+ Egg 1000
Egg bonus in air    500
SUCCESSFUL WAVE 3000

**Losing mount resets Egg to base Value

