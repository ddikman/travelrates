
bool containsIgnoreCase(String text, String matchText) {
  return text.toLowerCase().contains(matchText.toLowerCase());
}

bool isEqualIgnoreCase(String first, String second) {
  return compareIgnoreCase(first, second) == 0;
}

int compareIgnoreCase(String first, String second) {
  return first.toLowerCase().compareTo(second.toLowerCase());
}