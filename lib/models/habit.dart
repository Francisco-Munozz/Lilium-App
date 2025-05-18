class Habit {
  // Título del hábito, emoji y si esta completado
  final String name;
  final String emoji;
  bool isDone;

  Habit({required this.name, required this.emoji, this.isDone = false});
}
