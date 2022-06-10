int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(3);
}