# Yet Another Behavior Tree

A Behavior Tree implementation for [Godot Engine](https://godotengine.org/)

![image](documentation/assets/bt_illustration.png)

## 📄 Features

➡️ This plugin is an implementation of well-known Behavior Trees, allowing game developers to create AI-Like behaviors for their NPCs. In addition to provide all behavior tree base nodes, this plugin also brings additional helper nodes that avoid to create custom ones.

➡️ As all behavior trees, this implementation provides a tree root called `BTRoot`. This node will contains all your AI logic. Root node only accept a unique behavior tree node as child, which is a composite node. Composite nodes defines the root of a tree branch : each branch can be seen as a *rule* for your AI. They accept any kind of behavior tree nodes as children. It can either be a composite, decorator or leaf nodes. Decorator nodes allow to customize result of its only child node. Leaf nodes, as their name implies, do not have any child. They represents basic unit of work of your AI, which can be separated into two notions: conditions and actions.

➡️ In some cases, you will need to share information between your AI nodes. To avoid to create side scripts and/or stateful entities, this behavior tree also provides the notion of Blackboard. In a blackboard, you can store key-value datas. They can be retrieve and updated from any node in your tree. Blackboard is not erased between tree execution, meaning you can store persistent datas in it.

*(See below for full node documentation)*

➡️ Having nice features is cool, but beeing able to use them in an easy way is cooler 😎. **Yet Another Behavior Tree** provides a nice Godot Editor integration throught
- A set on uniform and beautiful (😂) node icons, that make it easier to identify what each node is and what it is doing in the *Scene* view,
- Configuration warning in *Scene* view if your behavior tree is not well configured,
- Easy node configuration through exported variables

## 📄 Nodes Documentation

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btblackboard.png) BTBlackboard

Blackboard allows to share data across nodes and behavior trees. You can create/retreieve/erase pairs of key-value. Keys and values are variants and can be anything.

Some well-known properties are already fed by the root tree during execution :
- `delta` : the float value of delta from *process* or *physics process* (depending on root tree process mode).


![image](documentation/assets/nodes/btblackboard.png)

🔑 Properties list:
- `data` : a dictionnary allowing to specifies default entries before tree first execution.

###  ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btroot.png) BTRoot

Its the entry point of your behavior tree. It can only have a unique child of type `BTComposite`.

![image](documentation/assets/nodes/btroot.png)

🔑 Properties list:
- `enabled` : indicates if tree should run or non. Default is *on*,
- `root_process_mode` : indicates whether tree should execute during *process* or *physics process*. Default is *physics process*,
- `actor_path` : path to the node that the tree is drescribing actions for. This is the node that will be passed to all tree nodes, allowing you to manipulate the actor at every tree step. Default is *empty*.
- `blackboard` : path to the blackboard node. This allows to share a same blackboard between several trees, for example to code a group of enemies acting together, or to spécify some default entries using the editor. If empty, a default empty blackboard will be used during tree execution. Default is *empty*.

###  ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btselector.png) BTSelector

The selector node is a *composite node* that executes its children from the first one to the last one, in order, until one of them returns *SUCCESS*. If a selector child succeeds, the selector succeed too. If all selector children failed, the selector fails too.

![image](documentation/assets/nodes/btselector.png)

🔑 Properties list:
- `save_progression` : indicates whether the selector should resume to the last running child on next tree execution (*on*), or restart from its first child (*off*). Its usefull to describe a non-interruptible action, or to optimize process time. Default is *off*.

###  ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btrandomselector.png) BTRandomSelector

The random selector node is a *composite node* behaves like the `BTSelector` node, except that it executes its children in random order.

![image](documentation/assets/nodes/btrandomselector.png)

🔑 Properties list:
- `save_progression` : indicates whether the random selector should resume to the last running child on next tree execution (*on*), or restart from its first child (*off*). Its usefull to describe a non-interruptible action, or to optimize process time. Default is *off*.

###  ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btsequence.png) BTSequence

The sequence node is a *composite node* that executes its children from the first one to the last one, until all children succeed or one of its children fails. Il all children succedd, the sequence succeeds too ; if one child fails, the sequence fails too.

![image](documentation/assets/nodes/btsequence.png)

🔑 Properties list:
- `save_progression` : indicates whether the sequence should resume to the last running child on next tree execution (*on*), or restart from its first child (*off*). Its usefull to describe a non-interruptible action, or to optimize process time. Default is *off*.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btsuccess.png) BTSuccess

The success node is a *decorator* node that always returns *success* on child execution.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btfailure.png) BTFailure

The failure node is a *decorator* node that always returns *failed* on child execution.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btinverter.png) BTInverter

The inverter node is a *decorator* node returns *success* when its child fails its execution, and *failure* when its child succeeds its execution. When its child is *running*, it returns *running* too.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btlimiter.png) BTLimiter

The limiter node is a *decorator* node that limits the total number of execution of its child node. When the limit is not reachs, the limiter nodes reports its child execution status. Once the limit is reachs, it never executs its child and always report a *failed* execution.

![image](documentation/assets/nodes/btlimiter.png)

🔑 Properties list:
- `limit`: number of allowed child execution. Default is *1*,
- `include_limit`: whether or not the `limit` value is included into the number of times the child can run. It clarifies the usage of the limit. Default is *on*.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btrepeatuntil.png) BTRepeatUntil

The repeat until node is a *decorator* node that loop its child execution until child execution result is as excepted. It is possible to specifies the maximum number of loop execution allowed to obtain the desired result. If desired result is obtained before the loop execution limit, the repeat until node returns the obtained result. If not, its returns a *failure*.

![image](documentation/assets/nodes/btrepeatuntil.png)

🔑 Properties list:
- `stop_condition`: expected child result to stop the loop. Default is *SUCCESS*,
- `max_iteration`: maximum number of child execution to obtain the desired result. If value is *0*, there is **no limit** to the number of times the loop can run (⚠️ be careful to not create an infinite loop). If value is more than zero, its represents the maximum number of loop execution. Default is *0*.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btrandom.png) BTRandom

The random node is a *decorator* node randomly execute its child. If the child is executed, the node result is the same as its child result. Otherwise, result is *failure.

![image](documentation/assets/nodes/btrandom.png)

🔑 Properties list:
- `probability`: a float between *0* (included) and *1* (included) indicating the probability of child execution. Default is *0.5*.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btcondition.png) BTCondition

The condition node is a *leaf* node. Its purpose is to return *success* when  a condition is meet, *failure* otherwise. This node should never return *running.

**Users must subclass this node to implements their own condititions**.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btconditionblackboardkeyexists.png) BTConditionBlackboardKeyExists

The blackboard key exists condition node is a *leaf* node. It returns *success* if a certain key is present in the tree blackboard during its execution, *failure* otherwise.

![image](documentation/assets/nodes/btconditionblackboardkeyexists.png)

🔑 Properties list:
- `blackboard_key`: name of the key that must exists in the blackboard.

⚠️ Due to GDScript 2.0 restrictions, only string type keys can be set, since its not possible to export Variant variables.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btconditionblackboardvaluescomparison.png) BTConditionBlackboardValuesComparison

The blackboard values comparison condition node is a *leaf* node. It returns *success* both values represented by specified keys returns true when compared using the given operator.

![image](documentation/assets/nodes/btconditionblackboardvaluescomparison.png)

🔑 Properties list:
- `first_operand_blackboard_key`: name of the key that old the first value to compare.
- `operator` : operator used to compare values
- `second_operand_blackboard_key`: name of the key that old the second value to compare.

⚠️ Due to GDScript 2.0 restrictions, only string type keys can be set, since its not possible to export Variant variables.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btaction.png) BTAction

The action node is a *leaf* node. Its purpose is to return *success* when an action is completed, *failure* if its fails to execute, and *running* if the action is occuring but is not completed yet.

**Users must subclass this node to implements their own actions**.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btactionwait.png) BTActionWait

The wait action node is a *leaf* node. Its execution returns *running* during the specified wait time, then returns *success* when specified time is elapsed. After succeeded, the wait time is rearmed for next tree execution.

![image](documentation/assets/nodes/btactionwait.png)

🔑 Properties list:
- `wait_time_ms`: number of milliseconds to wait before returning *success*. Default is *1000*,
- `random_deviation_ms` : indicates if a random deviation should be applied to the wait time. *0* means theire is no deviation et the wait time will be strictyl respected. Random deviation may change after each node rearm. Default is *0*, meaning no deviation at all.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btactionblackboardset.png) BTActionBlackboardSet

The blackboard set action node is a *leaf* node. It allows to set a value in the blackboard. Its execution always returns *success*. 

![image](documentation/assets/nodes/btactionblackboardset.png)

🔑 Properties list:
- `blackboard_key`: name of the key that must be set,
- `expression` : an expression representing the value to associated to the given key. The expression will be evaluated by Godot Engine during child execution. It should be simple. See [Godot Expression](https://docs.godotengine.org/en/latest/classes/class_expression.html) for details. In expression, user has access to two predefined variables:
  - `actor`: the node the tree is describing action for,
  - `blackboard`: the tree blackboard
- `can_overwrite_value` : a boolean indicating if the value must be overwritten if it already exists.

⚠️ Due to GDScript 2.0 restrictions, only string type keys can be set, since its not possible to export Variant variables.

### ![icon](addons/yet_another_behavior_tree/src/Assets/Icons/btactionblackboarddelete.png) BTActionBlackboardDelete

The blackboard delete action node is a *leaf* node. It allows to erase a key from the tree blackboard.

![image](documentation/assets/nodes/btactionblackboarddelete.png)

🔑 Properties list:
- `blackboard_key`: name of the key that must be erased from blackboard.

⚠️ Due to GDScript 2.0 restrictions, only string type keys can be set, since its not possible to export Variant variables.