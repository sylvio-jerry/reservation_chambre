class Client {
  int? id; // Auto-increment
  String numClient;
  String nom;
  String tel;
  String email;

  Client({
    this.id,
    required this.numClient,
    required this.nom,
    required this.tel,
    required this.email,
  });

  // Convert a Client object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'numClient': numClient,
      'nom': nom,
      'tel': tel,
      'email': email,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Extract a Client object from a Map object
  factory Client.fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      numClient: map['numClient'],
      nom: map['nom'],
      tel: map['tel'],
      email: map['email'],
    );
  }
}
