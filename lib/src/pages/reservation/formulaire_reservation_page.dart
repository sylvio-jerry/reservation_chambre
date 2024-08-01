// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:reservation/src/models/chambre.dart';
import 'package:reservation/src/models/client.dart';
import 'package:reservation/src/models/reservation.dart';
import 'package:reservation/src/provider/home/home_provider.dart';
import 'package:reservation/src/services/database_helper.dart';
import 'package:reservation/src/themes/colors.dart';
import 'package:reservation/src/utils/constants/common_constants.dart';
import 'package:reservation/src/utils/toasts/toast_util.dart';
import 'package:reservation/src/widgets/app_bar/simple_header.dart';
import 'package:reservation/src/widgets/button/custom_outline_button.dart';
import 'package:reservation/src/widgets/dropdown/dropdown_select.dart';
import 'package:reservation/src/widgets/inputs/custom_date_form_field.dart';

class FormulaireReservationPage extends ConsumerStatefulWidget {
  const FormulaireReservationPage({super.key, this.reservation});

  final Reservation? reservation;

  @override
  ConsumerState<FormulaireReservationPage> createState() =>
      _FormulaireReservationPageState();
}

class _FormulaireReservationPageState
    extends ConsumerState<FormulaireReservationPage> {
  String numeroReservation = "RES - ${DateTime.now().millisecondsSinceEpoch}";
  final dateEntreecontroller = TextEditingController();
  final dateSortiecontroller = TextEditingController();
  List<Client> clients = [];
  List<Chambre> chambres = [];
  Client? selectedClient;
  Chambre? selectedChambre;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.reservation != null) {
      numeroReservation = widget.reservation!.numero;
      dateEntreecontroller.text =
          DateFormat('dd/MM/yyyy').format(widget.reservation!.dateEntree);
      dateSortiecontroller.text =
          DateFormat('dd/MM/yyyy').format(widget.reservation!.dateSortie);
      // Initialiser les clients et les chambres sélectionnés
      _loadData().then((_) {
        selectedClient = clients
            .firstWhere((client) => client.id == widget.reservation!.clientId);
        selectedChambre = chambres.firstWhere(
            (chambre) => chambre.id == widget.reservation!.chambreId);
        setState(() {});
      });
    } else {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    clients = await DatabaseHelper.instance.getClients();
    chambres = await DatabaseHelper.instance.getChambres();
    setState(() {});
  }

  @override
  void dispose() {
    dateEntreecontroller.dispose();
    dateSortiecontroller.dispose();
    super.dispose();
  }

  Future<void> _saveReservation() async {
    if (_formKey.currentState!.validate() &&
        selectedClient != null &&
        selectedChambre != null) {
      final reservation = Reservation(
        numero: numeroReservation,
        clientId: selectedClient?.id ?? 0,
        chambreId: selectedChambre?.id ?? 0,
        dateEntree: DateFormat('dd/MM/yyyy').parse(dateEntreecontroller.text),
        dateSortie: DateFormat('dd/MM/yyyy').parse(dateSortiecontroller.text),
      );

      try {
        await DatabaseHelper.instance.insertReservation(reservation);
        resetFields();
        ToastUtil.showToast(
          status: 'success',
          message: 'Réservation sauvegardée avec succès!',
        );
      } catch (e) {
        ToastUtil.showToast(
          status: 'error',
          message: 'Erreur lors de la réservation: ${e.toString()}',
        );
      }
    } else {
      ToastUtil.showToast(
        status: 'error',
        message: 'Veuillez remplir tous les champs obligatoires',
      );
    }
  }

  Future<void> _updateReservation() async {
    if (_formKey.currentState!.validate() &&
        selectedClient != null &&
        selectedChambre != null) {
      final reservation = Reservation(
        numero: widget.reservation!.numero,
        clientId: selectedClient?.id ?? 0,
        chambreId: selectedChambre?.id ?? 0,
        dateEntree: DateFormat('dd/MM/yyyy').parse(dateEntreecontroller.text),
        dateSortie: DateFormat('dd/MM/yyyy').parse(dateSortiecontroller.text),
      );

      try {
        await DatabaseHelper.instance.updateReservation(reservation);
        ToastUtil.showToast(
          status: 'success',
          message: 'Réservation mise à jour avec succès!',
        );
        goBack();
      } catch (e) {
        ToastUtil.showToast(
          status: 'error',
          message: 'Erreur lors de la mise à jour: ${e.toString()}',
        );
      }
    } else {
      ToastUtil.showToast(
        status: 'error',
        message: 'Veuillez remplir tous les champs obligatoires',
      );
    }
  }

  void resetFields() {
    dateEntreecontroller.clear();
    dateSortiecontroller.clear();
    selectedClient = null;
    selectedChambre = null;
    setState(() {});
  }

  void goBack() {
    ref.read(pageIndexProvider.notifier).setPageIndex(1);
    ref.read(pageIndexProvider.notifier).setPageIndex(0);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: SimpleHeader(
          title: widget.reservation == null
              ? "Nouvelle Reservation"
              : "Modifier du Reservation",
          isAddPop: true,
          onTap: () {
            goBack();
          }),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(CommonConst.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Numero",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          width: 25,
                          child: Divider(
                            thickness: 1.5,
                            color: AppColors.greyDark,
                          ),
                        ),
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(left: 25),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: Colors.white),
                        child: Text(numeroReservation,
                            style: Theme.of(context).textTheme.titleLarge)),
                  ],
                ),
                const SizedBox(height: 30),
                CustomDateFormField(
                  label: "Date entrée",
                  hintText: "date entrée",
                  validator: (date) =>
                      date!.isEmpty ? "Veuillez renseigner ce champ" : null,
                  controller: dateEntreecontroller,
                  iconData: Icons.date_range,
                ),
                const SizedBox(height: 25),
                CustomDateFormField(
                  label: "Date Sortie",
                  hintText: "date Sortie",
                  validator: (date) =>
                      date!.isEmpty ? "Veuillez renseigner ce champ" : null,
                  controller: dateSortiecontroller,
                  iconData: Icons.date_range,
                ),
                const SizedBox(height: 25),
                DropdownSelect<Client>(
                  label: "Client",
                  value: selectedClient,
                  items: clients,
                  onChanged: (Client? value) {
                    setState(() {
                      selectedClient = value;
                    });
                  },
                  itemLabel: (Client client) => client.nom,
                ),
                const SizedBox(height: 25),
                DropdownSelect<Chambre>(
                  label: "Chambre",
                  value: selectedChambre,
                  items: chambres,
                  onChanged: (Chambre? value) {
                    setState(() {
                      selectedChambre = value;
                    });
                  },
                  itemLabel: (Chambre chambre) =>
                      '${chambre.type} - ${chambre.prix}€',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(CommonConst.defaultPadding),
        height: 110,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            CustomOutlineButton(
                label: widget.reservation == null
                    ? "Enregistrer"
                    : "Mettre à jour",
                borderColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.secondary,
                icon: Icons.save,
                onPressed: widget.reservation != null
                    ? _updateReservation
                    : _saveReservation)
          ],
        ),
      ),
    );
  }
}
