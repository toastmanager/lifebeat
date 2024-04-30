import 'package:lifebeat/entities/checkpoint.dart';
import 'package:lifebeat/entities/goal.dart';
import 'package:lifebeat/entities/task.dart';
import 'package:lifebeat/objectbox.g.dart';

class ObjectBox {
  late final Store store;

  late final Box<Task> taskBox;
  late final Box<Goal> goalBox;
  late final Box<Checkpoint> checkpointBox;

  ObjectBox._create(this.store) {
    taskBox = Box<Task>(store);
    goalBox = Box<Goal>(store);
    checkpointBox = Box<Checkpoint>(store);

    if (taskBox.isEmpty()) {
      _putDemoData();
    }
  }

  void _putDemoData() {
    Task task1 = Task(text: 'task 1', status: false, date: DateTime(2025));
    Task task2 = Task(text: 'task 2', status: true, date: DateTime(2025));
    Task task3 = Task(text: 'task 3', status: false, date: DateTime(2024));

    Goal goal1 = Goal(description: 'description 1', text: 'text 1', begin: DateTime(2025), deadline: DateTime(2026));
    Goal goal2 = Goal(description: 'description 2', text: 'text 2', begin: DateTime(2025), deadline: DateTime(2026));

    Checkpoint checkpoint1 = Checkpoint(text: 'goal checkpoint 1', finished: false);
    Checkpoint checkpoint2 = Checkpoint(text: 'goal checkpoint 2', finished: true);
    Checkpoint checkpoint3 = Checkpoint(text: 'goal checkpoint 3', finished: false);
    Checkpoint checkpoint4 = Checkpoint(text: 'goal checkpoint 4', finished: true);

    goal1.checkpoints.addAll([checkpoint1, checkpoint2]);
    goal2.checkpoints.addAll([checkpoint3, checkpoint4]);

    checkpointBox.putMany([checkpoint1, checkpoint2, checkpoint3, checkpoint4]);
    goalBox.putMany([goal1, goal2]);
    taskBox.putMany([task1, task2, task3]);
  }

  static Future<ObjectBox> create() async {
    final store = await openStore();
    return ObjectBox._create(store);
  }

  Stream<List<Task>> getTasks() {
    final builder = taskBox.query()..order(Task_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  int addTask(
    String text,
    DateTime date,
  ) {
    Task newTask = Task(
      text: text,
      status: false,
      date: date
    );
    int newTaskId = taskBox.put(newTask);
    
    return newTaskId;
  }

  bool deleteTask(int id) {
    return taskBox.remove(id);
  }

  Stream<List<Task>> getDayTasks(DateTime date) {
    final builder = taskBox.query(
      Task_.date.betweenDate(
        DateTime(date.year, date.month, date.day, 0, 0, 0),
        DateTime(date.year, date.month, date.day, 23, 59, 59),
      )
    );
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  bool switchTask(int id) {
    try {
      Task task = taskBox.get(id)!;
      task.switchStatus();
      taskBox.put(task);
      return task.status;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Goal>> getGoals() {
    final builder = goalBox.query()..order(Goal_.id, flags: Order.descending);
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }
}