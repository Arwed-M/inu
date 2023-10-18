enum NodeType {
  string,
  map,
  empty;

  static NodeType? fromObj(Object? obj) =>
      fromString(obj.runtimeType.toString());

  static NodeType? fromString(String str) =>
      NodeType.values.firstWhere((e) => e.match == str);

  String get match => switch (this) {
        NodeType.string => "String",
        NodeType.map => "_Map<String, dynamic>",
        NodeType.empty => "Null",
      };
}
