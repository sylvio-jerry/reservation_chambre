// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reservation/src/models/chambre.dart';
import 'package:reservation/src/models/client.dart';
import 'package:reservation/src/services/database_helper.dart';
import 'package:reservation/src/utils/constants/common_constants.dart';
import 'package:reservation/src/utils/toasts/toast_util.dart';
import 'package:reservation/src/widgets/app_bar/simple_header.dart';
import 'package:reservation/src/widgets/button/custom_outline_button.dart';
import 'package:reservation/src/widgets/inputs/custom_form_field.dart';
import 'package:reservation/src/widgets/inputs/input_radio.dart';

class FormulaireChambrePage extends StatefulWidget {
  const FormulaireChambrePage({super.key, this.chambre});

  final Chambre? chambre;

  @override
  State<FormulaireChambrePage> createState() => _FormulaireChambrePageState();
}

class _FormulaireChambrePageState extends State<FormulaireChambrePage> {
  final prixController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //type de chambre
  final String forOnePerson = "Pour une personne";
  final String forTwoPerson = "Pour deux personnes";
  final String forFamily = "Pour une famille";
  String selectedType = "Pour une personne";

  @override
  void initState() {
    super.initState();
    if (widget.chambre != null) {
      prixController.text = widget.chambre!.prix.toString();
      selectedType = widget.chambre!.type;
    }
  }

  @override
  void dispose() {
    prixController.dispose();
    super.dispose();
  }

  Future<void> _saveChambre() async {
    if (_formKey.currentState!.validate()) {
      final chambre = Chambre(
        type: selectedType,
        prix: int.parse(prixController.text),
      );

      try {
        await DatabaseHelper.instance.insertChambre(chambre);
        resetFields();
        ToastUtil.showToast(
          status: 'success',
          message: 'Chambre ajouté avec succès!',
        );
      } catch (e) {
        ToastUtil.showToast(
          status: 'error',
          message: 'Erreur lors de l\'ajout du Chambre: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _updateChambre() async {
    if (_formKey.currentState!.validate()) {
      final chambre = Chambre(
          type: selectedType,
          prix: int.parse(prixController.text),
          id: widget.chambre!.id);

      try {
        await DatabaseHelper.instance.updateChambre(chambre);
        Navigator.pop(context, true);
        ToastUtil.showToast(
          status: 'success',
          message: 'Information mise à jour avec succès!',
        );
      } catch (e) {
        ToastUtil.showToast(
          status: 'error',
          message: 'Erreur lors de la mise à jour: ${e.toString()}',
        );
      }
    }
  }

  void resetFields() {
    prixController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: SimpleHeader(
        title: widget.chambre == null ? "Nouvelle Chambre" : "Modifier Chambre",
        isAddPop: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(CommonConst.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Type de chambre",
                        style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 60,
                      child: ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          InputRadio(
                            label: forOnePerson,
                            selectedValue: selectedType,
                            isButtonStyle: true,
                            onTap: (v) {
                              setState(() {
                                selectedType = v ?? "";
                              });
                            },
                            boxWidth: 180,
                          ),
                          const SizedBox(width: 10),
                          InputRadio(
                            label: forTwoPerson,
                            selectedValue: selectedType,
                            isButtonStyle: true,
                            boxWidth: 200,
                            onTap: (v) {
                              setState(() {
                                selectedType = v ?? "";
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          InputRadio(
                            label: forFamily,
                            selectedValue: selectedType,
                            isButtonStyle: true,
                            boxWidth: 160,
                            onTap: (v) {
                              setState(() {
                                selectedType = v ?? "";
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                CustomFormField(
                  label: "Prix",
                  hintText: "prix du chambre",
                  validator: (tel) =>
                      tel!.isEmpty ? "Veuillez renseigner ce champ" : null,
                  controller: prixController,
                  iconData: Icons.attach_money_sharp,
                  keyboardType: TextInputType.phone,
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
                label: widget.chambre == null ? "Enregistrer" : "Mettre à jour",
                borderColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.secondary,
                icon: Icons.save,
                onPressed:
                    widget.chambre != null ? _updateChambre : _saveChambre)
          ],
        ),
      ),
    );
  }
}
