Factorio: Rail-Crossing
=========================

Mod for factorio that adds the ability to cross rail networks. Most important notes: 
+ New rail segment that allows two trains to pass at the same time. Imagine this is a bridge or tunnel.
+ Trains don't kill anymore (byproduct of getting the rail segment working), and you can walk through them.
+ Train construction is slightly modified to prevent crashes.

Install instructions:
No special requirements here, just copy the "rail-crossing_..." folder into the mods folder. The mods folder is created after running Factorio once. After copying, restart Factorio and open mods in the main menu, you should see the mod already enabled there.

Known issues:
+ The in-inventory stack is removed and restored a tick later, to force the player hand empty. It might be annoying, but it seems to be a good way to avoid issues
+ Placing trains may not work sometimes because of another safeguard. Try building the train farther from other trains.

Version history:

0.1.1
+ Using a slightly different safeguard against quick-placing train carriages. 

0.1.0
+ Initial version