import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:reservation/src/models/chambre.dart';
import 'package:reservation/src/models/client.dart';
import 'package:reservation/src/navigation/navigation_service.dart';
import 'package:reservation/src/pages/chambre/formulaire_chambre_page.dart';
import 'package:reservation/src/pages/client/formulaire_client_page.dart';
import 'package:reservation/src/services/database_helper.dart';
import 'package:reservation/src/themes/colors.dart';
import 'package:reservation/src/utils/constants/common_constants.dart';
import 'package:reservation/src/utils/toasts/toast_util.dart';
import 'package:reservation/src/widgets/app_bar/simple_header.dart';
import 'package:reservation/src/widgets/modal/modal_confirmation.dart';

class ChambrePage extends StatefulWidget {
  const ChambrePage({super.key});

  @override
  State<ChambrePage> createState() => _ChambrePageState();
}

class _ChambrePageState extends State<ChambrePage> {
  final searchcontroller = TextEditingController();
  late Future<List<Chambre>> _chambre;

  @override
  void initState() {
    super.initState();
    _fetchChambre();
  }

  void _fetchChambre({String query = ''}) {
    _chambre = DatabaseHelper.instance.getFilteredChambres(query);
  }

  Future<void> _deleteChambre(int id) async {
    try {
      await DatabaseHelper.instance.deleteChambre(id);
      ToastUtil.showToast(
        status: 'success',
        message: 'Chambre supprimé avec succès!',
      );
      _fetchChambre(); // Refresh the list
    } catch (e) {
      ToastUtil.showToast(
        status: 'error',
        message: 'Erreur lors de la suppression du Chambre: ${e.toString()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const SimpleHeader(
        title: "Chambre",
        isAddPop: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(CommonConst.defaultPadding),
        child: Column(
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    NavigationService.navigateToPage(context,
                        targetPage: const FormulaireChambrePage(),
                        refreshSourcePage: () {
                      setState(() {
                        _fetchChambre();
                      });
                    });
                  },
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: AppColors.color1.withOpacity(.7),
                    ),
                    child: const HeroIcon(
                      HeroIcons.plus,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: searchcontroller,
                    onChanged: (query) {
                      setState(() {
                        _fetchChambre(query: query);
                      });
                    },
                    style: Theme.of(context).textTheme.titleMedium,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primary,
                        size: 20.0,
                      ),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Theme.of(context).hintColor, fontSize: 14),
                      hintText: 'Rechercher une chambre',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: FutureBuilder<List<Chambre>>(
                future: _chambre,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Erreur lors du chargement des chambres.'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Aucun chambre trouvé.'));
                  }

                  final chambres = snapshot.data!;

                  return ListView.builder(
                    itemCount: chambres.length,
                    itemBuilder: (context, index) {
                      final chambre = chambres[index];

                      return Dismissible(
                        key: Key(chambre.id.toString()),
                        direction: DismissDirection.horizontal,
                        onDismissed: (direction) {
                          showModalConfirmation(context, onTapCancel: () {
                            Navigator.pop(context);
                            setState(() {
                              _fetchChambre();
                            });
                          }, onTapOk: () {
                            _deleteChambre(chambre.id!);
                            Navigator.pop(context);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: AppColors.grey.withOpacity(.1),
                          ),
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: ListTile(
                            title: Text(chambre.type),
                            trailing: Text(chambre.prix.toString()),
                            onTap: () {
                              NavigationService.navigateToPage(
                                context,
                                targetPage:
                                    FormulaireChambrePage(chambre: chambre),
                                refreshSourcePage: () {
                                  setState(() {
                                    _fetchChambre();
                                  });
                                },
                              );
                            },
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
  }
}
