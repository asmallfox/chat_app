dynamic listFind(List list, bool Function(dynamic) fn) {
  if (list.isEmpty) return null;

  return list.firstWhere(
    fn,
    orElse: () => null,
  );
}
