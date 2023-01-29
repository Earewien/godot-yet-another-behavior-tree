# 🗣️ Sharing blackboard : the talking game !

This example demonstrates how to share a single blackboard in multiple behavior trees.

Sharing a blackboard can be necessary if you want to easily share data between trees, for example, to synchronize multiple NPCs. 

The blackboard can be instantiate in a Scene Tree via the editor, or in a script (as in this example).

## Technical elements

- `main.tscn` : scene to run. The main scene instantiates a unique blackboard and give it to all player trees,
- `player.tscn` : a player in the talking game. They all share the same blackboard to known who is the next to talk.