
/// Returns a copy of the list alphabetically sorted by the property
/// of each element as given by [property] parameter.
List<T> alphabeticallySorted<T>(List<T> list, String Function(T) property) {
  assertNotNull(list, 'list');
  assertNotNull(property, 'property');

  final validProperty = (item) {
    if (item == null) {
      throw ArgumentError.value(null, 'list', 'Invalid list element');
    }
    
    final propertyValue = property(item);
    if (propertyValue == null) {
      throw ArgumentError.value(null, 'list', 'Invalid list element property');
    }

    return propertyValue;
  };

  final listCopy = List<T>.from(list);
  listCopy.sort((first, second) {
    final firstProperty = validProperty(first).toLowerCase();
    final secondProperty = validProperty(second).toLowerCase();
    return firstProperty.compareTo(secondProperty);
  });
  return listCopy;
}

/// Shorthand to check a value for null and return if successful.
/// [name] should be the name of the parameter or variable checked.
T nonNull<T>(T value, String name) {
  assertNotNull(value, name);
  return value;
}

/// Throw an argument error if the given value is null.
/// [name] should be the name of the parameter or variable checked.
void assertNotNull<T>(T value, String name) {
  if (value == null) {
    throw ArgumentError.notNull(name);
  }
}