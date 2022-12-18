
import '../TodoAction.dart';
import '../classification/Priority.dart';

class TodoActionBuilder {
  String? name;
  String? description;

  Priority? priority;

  String? id;

  TodoActionBuilder() {
    name = "";
    description = "";
    priority = Priority.A_FAIRE;
  }

  TodoActionBuilder.import(TodoAction action) {
    name = action.name;
    description = action.description;
    priority = action.priority;

    id = action.id;
  }

  TodoAction build() {
    return TodoAction.fromAll(name!, description!, priority!, id);
  }
}
