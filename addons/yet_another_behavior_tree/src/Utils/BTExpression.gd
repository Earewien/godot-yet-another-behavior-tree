extends RefCounted
class_name BTExpression

#------------------------------------------
# Signaux
#------------------------------------------

#------------------------------------------
# Exports
#------------------------------------------

#------------------------------------------
# Variables publiques
#------------------------------------------

var expression:String = "":
    set(value):
        if value != expression:
            expression = value
            _expression = _parse_expression(expression)

#------------------------------------------
# Variables privées
#------------------------------------------

var _expression:Expression

#------------------------------------------
# Fonctions Godot redéfinies
#------------------------------------------

#------------------------------------------
# Fonctions publiques
#------------------------------------------

func is_valid() -> bool:
    return _expression != null

func evaluate(actor:Node, blackboard:BTBlackboard) -> Variant:
    var arguments:Array[Variant] = [actor, blackboard, blackboard.get_delta()]
    return _execute_expression(arguments)

#------------------------------------------
# Fonctions privées
#------------------------------------------

func _parse_expression(string_expr:String) -> Expression:
    var expr:Expression = Expression.new()
    var parse_code:int = expr.parse(string_expr, ["actor", "blackboard", "delta"])
    if parse_code != OK:
        push_error("Unable to parse expression '%s' : %s" % [string_expr, expr.get_error_text()])
        return null
    return expr

func _execute_expression(arguments:Array[Variant]) -> Variant:
    var result:Variant = null
    if _expression == null:
        _expression = _parse_expression(expression)
    if _expression != null:
        result = _expression.execute(arguments, self, true)
        if _expression.has_execute_failed():
            result = null
            push_error("Unable to execute expression '%s' : %s" % [expression, _expression.get_error_text()])
    return result
