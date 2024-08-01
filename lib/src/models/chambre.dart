class Chambre {
  int? id; // Auto-increment
  String type;
  int prix;

  Chambre({
    this.id,
    required this.type,
    required this.prix,
  });

  // Convert a Chambre object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'type': type,
      'prix': prix,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Extract a Chambre object from a Map object
  factory Chambre.fromMap(Map<String, dynamic> map) {
    return Chambre(
      id: map['id'],
      type: map['type'],
      prix: map['prix'],
    );
  }
}
