# 🪵 Simple AI logic : the lumberjack !

This example is about a lumberjack that needs to cut logs. He can carry a certain quantity of logs before going back to the nearest warehouse to drop logs. When logs are dropped, he moves back to the tree he was cutting (or, the nearest tree if the tree is cut), and cut logs again.

The aim of this example is to show how to implement a simple AI logic, composed of differents phases, using a behavior tree. This is just a proposal, there are several ways to create our lumberjack !

In lumberjack behavior tree, you can notice there is no custom tree node (action or condition) : only based ones are used. To execute functional actions, like dropping logs, the `BTActionCallable` is used. It allows to call a method in a node. For simple behavior trees, it allows to contain all logic into the same script.

## Technical elements

- `main.tscn` : scene to run,
- `lumberjack.tscn` : the lumberjack. The behavior tree is in this scene.