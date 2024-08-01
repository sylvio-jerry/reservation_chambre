class Reservation {
  final String numero;
  final int clientId;
  final int chambreId;
  final DateTime dateEntree;
  final DateTime dateSortie;

  Reservation({
    required this.numero,
    required this.clientId,
    required this.chambreId,
    required this.dateEntree,
    required this.dateSortie,
  });

  Map<String, dynamic> toMap() {
    return {
      'numero': numero,
      'clientId': clientId,
      'chambreId': chambreId,
      'dateEntree': dateEntree.toIso8601String(),
      'dateSortie': dateSortie.toIso8601String(),
    };
  }

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      numero: map['numero'],
      clientId: map['clientId'],
      chambreId: map['chambreId'],
      dateEntree: DateTime.parse(map['dateEntree']),
      dateSortie: DateTime.parse(map['dateSortie']),
    );
  }
}
