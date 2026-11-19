enum Category {
  food('Սնունդ', '🍔'),
  transport('Տրանսպորտ', '🚌'),
  entertainment('Զվարճանք', '🎮'),
  other('Այլ', '📦');

  final String name;
  final String emoji;

  const Category(this.name, this.emoji);
}
