dynamic listFind(List list, bool Function(dynamic) fn) {
  return list.firstWhere(
    fn,
    orElse: () => null,
  );
}
