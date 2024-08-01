// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:reservation/src/models/client.dart';
import 'package:reservation/src/services/database_helper.dart';
import 'package:reservation/src/utils/constants/common_constants.dart';
import 'package:reservation/src/utils/toasts/toast_util.dart';
import 'package:reservation/src/widgets/app_bar/simple_header.dart';
import 'package:reservation/src/widgets/button/custom_outline_button.dart';
import 'package:reservation/src/widgets/inputs/custom_form_field.dart';

class FormulaireClientPage extends StatefulWidget {
  const FormulaireClientPage({super.key, this.client});

  final Client? client;

  @override
  State<FormulaireClientPage> createState() => _FormulaireClientPageState();
}

class _FormulaireClientPageState extends State<FormulaireClientPage> {
  final nomClientcontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final telcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      nomClientcontroller.text = widget.client!.nom;
      emailcontroller.text = widget.client!.email;
      telcontroller.text = widget.client!.tel;
    }
  }

  @override
  void dispose() {
    nomClientcontroller.dispose();
    emailcontroller.dispose();
    telcontroller.dispose();
    super.dispose();
  }

  Future<void> _saveClient() async {
    if (_formKey.currentState!.validate()) {
      final client = Client(
        numClient: 'C${DateTime.now().millisecondsSinceEpoch}',
        nom: nomClientcontroller.text,
        email: emailcontroller.text,
        tel: telcontroller.text,
      );

      try {
        await DatabaseHelper.instance.insertClient(client);
        resetFields();
        ToastUtil.showToast(
          status: 'success',
          message: 'Client ajouté avec succès!',
        );
      } catch (e) {
        ToastUtil.showToast(
          status: 'error',
          message: 'Erreur lors de l\'ajout du client: ${e.toString()}',
        );
      }
    }
  }

  Future<void> _updateClient() async {
    if (_formKey.currentState!.validate()) {
      final client = Client(
          numClient: 'C${DateTime.now().millisecondsSinceEpoch}',
          nom: nomClientcontroller.text,
          email: emailcontroller.text,
          tel: telcontroller.text,
          id: widget.client!.id);

      try {
        await DatabaseHelper.instance.updateClient(client);
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
    nomClientcontroller.clear();
    emailcontroller.clear();
    telcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: SimpleHeader(
        title: widget.client == null ? "Nouveau Client" : "Modifier Client",
        isAddPop: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(CommonConst.defaultPadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomFormField(
                  label: "Nom",
                  hintText: "nom du client",
                  validator: (nom) =>
                      nom!.isEmpty ? "Veuillez renseigner ce champ" : null,
                  controller: nomClientcontroller,
                  iconData: Icons.person,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 15),
                CustomFormField(
                  label: "Email",
                  hintText: "email du client",
                  validator: (email) =>
                      email!.isEmpty ? "Veuillez renseigner ce champ" : null,
                  controller: emailcontroller,
                  iconData: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                CustomFormField(
                  label: "Tel",
                  hintText: "tel du client",
                  validator: (tel) =>
                      tel!.isEmpty ? "Veuillez renseigner ce champ" : null,
                  controller: telcontroller,
                  iconData: Icons.phone,
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
                label: widget.client == null ? "Enregistrer" : "Mettre à jour",
                borderColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.secondary,
                icon: Icons.save,
                onPressed: widget.client != null ? _updateClient : _saveClient)
          ],
        ),
      ),
    );
  }
}
