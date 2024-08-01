import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reservation/src/models/client.dart';
import 'package:reservation/src/models/reservation.dart';
import 'package:reservation/src/pages/reservation/reservation_card.dart';
import 'package:reservation/src/provider/home/home_provider.dart';
import 'package:reservation/src/services/database_helper.dart';
import 'package:reservation/src/themes/colors.dart';
import 'package:reservation/src/utils/constants/common_constants.dart';
import 'package:reservation/src/utils/toasts/toast_util.dart';
import 'package:reservation/src/widgets/app_bar/simple_header.dart';
import 'package:reservation/src/widgets/modal/modal_confirmation.dart';

class ReservationPage extends ConsumerStatefulWidget {
  const ReservationPage({super.key});

  @override
  ConsumerState<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends ConsumerState<ReservationPage> {
  final searchController = TextEditingController();
  late Future<List<Reservation>> _reservationsFuture;
  List<Client> clients = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData({String query = ''}) async {
    _reservationsFuture =
        DatabaseHelper.instance.getFilteredReservations(query);
    clients = await DatabaseHelper.instance.getClients();
    setState(() {});
  }

  Future<void> _deleteReservation(String numero) async {
    try {
      await DatabaseHelper.instance.deleteReservation(numero);
      ToastUtil.showToast(
        status: 'success',
        message: 'La réservation a été supprimée avec succès!',
      );
      _fetchData(); // Refresh the list
    } catch (e) {
      ToastUtil.showToast(
        status: 'error',
        message:
            'Erreur lors de la suppression de la réservation: ${e.toString()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.listen<int>(pageIndexProvider, (previousIndex, currentIndex) {
          if (currentIndex == 0) {
            _fetchData();
          }
        });
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: const SimpleHeader(
            title: "Réservations",
            isAddPop: false,
          ),
          body: Container(
            padding: const EdgeInsets.all(CommonConst.defaultPadding),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  onChanged: (query) {
                    setState(() {
                      _fetchData(query: query);
                    });
                  },
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.search,
                      color: AppColors.greyDark.withOpacity(.5),
                      size: 20.0,
                    ),
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 14,
                    ),
                    hintText: 'Rechercher une réservation',
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: FutureBuilder<List<Reservation>>(
                    future: _reservationsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child: Text(
                                'Erreur lors du chargement des réservations.'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('Aucune réservation trouvée.'));
                      }

                      final reservations = snapshot.data!;

                      return ListView.builder(
                        itemCount: reservations.length,
                        itemBuilder: (context, index) {
                          final reservation = reservations[index];
                          Client? client;

                          try {
                            client = clients.firstWhere(
                              (client) => client.id == reservation.clientId,
                            );
                          } catch (e) {
                            // Client introuvable, ignorer cette réservation
                            return const SizedBox.shrink();
                          }

                          return Dismissible(
                            key: Key(reservation.numero),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              showModalConfirmation(
                                context,
                                onTapCancel: () {
                                  Navigator.pop(context);
                                  _fetchData();
                                },
                                onTapOk: () {
                                  _deleteReservation(reservation.numero);
                                  Navigator.pop(context);
                                },
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15.0),
                              child: ReservationCard(
                                reservation: reservation,
                                client: client,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
