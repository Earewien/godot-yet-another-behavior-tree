# 🚀 Performance showcase

This example demonstrates behavior tree performance.

The main scene instantiates a large number of *entities*, which are driven by a behavior tree. The aim is to check for performance. To do that, use Godot Profiler. 

## Technical elements

- `main.tscn` : scene to run. This scene instantiate a large number of *entities*,
- `entity.tscn` : an entity with a simple bahavior tree.