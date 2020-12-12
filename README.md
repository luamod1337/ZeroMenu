# ZeroMenu
A lua extension for [2Take1Menu](https://2take1.menu) made by 1337Zero

## Installation
	
	- Copy the content from zeromenu2.rar (zeroMenu2.lua & ZeroMenuLibFolder) to %appdata%\PopstarDevs\2Take1Menu\scripts

# Vehicle

##### Slow
	Slows your vehicle down to 1.
##### Tune
	Upgrades your vehicles torque with the given amount. This counts as a modifier.
	A value of 1 seems to be the default modifier. A value of 100 means 100 times the torque. 100 Seems to be a good modifier too.
##### Drift
	Sets the vehicles max speed to 180, while giving it a fuckton of torque.
	  - Sets the max speed to (100 whatever) ~108 km/h.
	  - Sets the torque to 200.
	  
##### Remove Max Speed
	Doesn't remove the max speed actually, set the max speed to 150000.
##### Set max Speed
	Sets the max speed to the given value.
##### Set Heli Blade Speed
	- Sets the helicopter blade speed of the helicopter you are inside.
	- 0 means no force upwards.
##### Open Vehicle Parachute
	Opens the parachute of the vehicle you are inside.
##### Freeze Vehicle on exit
	- Freeze the vehicle if you leave it.
	- Unfreeze it, if you enter it again.
##### Noclip Vehicle on exit
	- Noclips the vehicle if you leave it.
	- This only works for vehicles which are nearby at the point you left it.
	- Stay nearby to avoid it from beeing hit
##### Acrobatic Right
	- Exp. Feature, rotates the car that it is one tire. Buggy.

### Modder Detection

##### Godmode Check
	- Checks all players for godmode. 
	- False Positives might be loading (in/out)
##### Visible Check
	- Checks (all) player if they are invisible. 
	- Players not rendered in your client (distance) are invisible too.
##### Position Check
	- Checks the distance moved by players.
	- False Positives can be teleport to building(invites) or loading into gtao.
##### Request Control Check
	- Checks if a player denies request control
##### IP Range Check
	- removed with latest build

### Nearby

##### Anti Depressor
	- Removes specific (configurable) vehicles nearby you.
	- Punishes the player too.
##### SlowMo
	- Every vehicle around you will get a max speed of 1.
	- Applies to planes too.
##### Hyper
	- Every vehicle around you will get a high max speed and a high torque value.
##### Check for encounters
	- Fun option, sends player nearby you a "Corona warning"
##### No Vehicle Collision
	- Every vehicle around next to you will be set to no collide.
	- Works against players too (best if host).
##### No Object Collision
	- No Collision with nearby Objects.
##### Party Mode
	- Peds around you will drive next to you and start a party.
##### BLM Demo
	- Peds around you will get weapons and shoot random peds around you.
##### Firework around you
	- No party without firework.

### Self

##### Wander Streets
	- Gives your ped the task to drive around in gta (aggressivly)

### Protection

##### FPS Crash
	- Removes vehicles around you, which count is higher than 10.
	- 10 Vehicle of one type is fine, if 11 one will be removed.

### World

##### Reset Wave Itensity
	- Resets the wave intensity to default value.
##### Set Wave Itensity
	- Sets the wave intensity.
##### Clear Objects
	- Removes objects nearby.
##### Clear Vehicles
	- Removes vehicles nearby.
##### Clear Peds
	- Removes peds nearby.
##### Clear Cops
	- Removes cops nearby.

### ChatCommands

##### Chatlog
	- Logs the chat to a file
##### Enable Chatcommands
	- Enables chatcommands
##### Enable !upgrade <torque>
	- More torque for every player (might the limited to a distance of 2000)
##### Enable !slap <player>
	- Exp. should slap players and or their cars
### Lobby

##### Log Modder
	- Logs known modder to a csv file.
##### Inform about Modders
	- Tells you if a modder was found, and marks him as a modder

### Dev

##### Shit Bird Attack
	- Exp. Function, should spawn Birds with a task to shit on you.

### Grief

##### Vehicle Speed Grief
	- Sets the max vehicle speed of the player.
##### Vehicle Speed Upgrade Grief
	- Upgrades that players vehicle.
##### Vehicle Door Grief
	- Looks the doors of that players car.
##### Push Grief
	- Pushes that player away.
##### Disable Vehicle
	- Disables the vehicle of that player
##### Net Event Log
	- Logs and Blocks script & net events.
##### Scream Grief
	- Sound grief.
##### Control Grief
	- Disable the control of that players vehicle.