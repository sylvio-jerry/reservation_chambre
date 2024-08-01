import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:reservation/src/models/reservation.dart';
import 'package:reservation/src/models/client.dart';
import 'package:reservation/src/navigation/navigation_service.dart';
import 'package:reservation/src/pages/reservation/formulaire_reservation_page.dart';
import 'package:reservation/src/themes/colors.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final Client client;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.client,
  });

  @override
  Widget build(BuildContext context) {
    final formattedNumero =
        reservation.numero.substring(reservation.numero.length - 3);

    return InkWell(
      onTap: () {
        NavigationService.navigateToPage(context,
            targetPage: FormulaireReservationPage(reservation: reservation),
            refreshSourcePage: () {});
      },
      child: Row(children: [
        Container(
          width: 70,
          height: 50,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: AppColors.greyDark.withOpacity(.1),
              borderRadius: BorderRadius.circular(12.0)),
          child: Center(
            child: Text(
              "RES-$formattedNumero",
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: AppColors.grey_3,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(client.nom),
              const SizedBox(height: 5.0),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                        text: DateFormat('dd/MM/yyyy')
                            .format(reservation.dateEntree),
                        style: Theme.of(context).textTheme.bodySmall,
                        children: [
                          const TextSpan(
                            text: ' - ',
                          ),
                          TextSpan(
                            text: DateFormat('dd/MM/yyyy')
                                .format(reservation.dateSortie),
                          ),
                        ]),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 10.0),
        Icon(
          Icons.chevron_right,
          color: AppColors.grey_3.withOpacity(.5),
        ),
      ]),
    );
  }
}
