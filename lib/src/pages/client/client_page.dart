import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:reservation/src/models/client.dart';
import 'package:reservation/src/navigation/navigation_service.dart';
import 'package:reservation/src/pages/client/formulaire_client_page.dart';
import 'package:reservation/src/provider/home/home_provider.dart';
import 'package:reservation/src/services/database_helper.dart';
import 'package:reservation/src/themes/colors.dart';
import 'package:reservation/src/utils/constants/common_constants.dart';
import 'package:reservation/src/utils/toasts/toast_util.dart';
import 'package:reservation/src/widgets/app_bar/simple_header.dart';
import 'package:reservation/src/widgets/modal/modal_confirmation.dart';

class ClientPage extends ConsumerStatefulWidget {
  const ClientPage({super.key});

  @override
  ConsumerState<ClientPage> createState() => _ClientPageState();
}

class _ClientPageState extends ConsumerState<ClientPage> {
  final searchcontroller = TextEditingController();
  late Future<List<Client>> _clients;

  @override
  void initState() {
    super.initState();
    _fetchClients();
  }

  void _fetchClients({String query = ''}) {
    _clients = DatabaseHelper.instance.getFilteredClients(query);
  }

  Future<void> _deleteClient(int id) async {
    try {
      await DatabaseHelper.instance.deleteClient(id);
      ToastUtil.showToast(
        status: 'success',
        message: 'Client supprimé avec succès!',
      );
      _fetchClients(); // Refresh the list
    } catch (e) {
      ToastUtil.showToast(
        status: 'error',
        message: 'Erreur lors de la suppression du client: ${e.toString()}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.listen<int>(pageIndexProvider, (previousIndex, currentIndex) {
          if (currentIndex == 3) {
            _fetchClients();
          }
        });
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: const SimpleHeader(
            title: "Client",
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
                            targetPage: const FormulaireClientPage(),
                            refreshSourcePage: () {
                          setState(() {
                            _fetchClients();
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
                            _fetchClients(query: query);
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
                          hintText: 'Rechercher un client',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: FutureBuilder<List<Client>>(
                    future: _clients,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(
                            child:
                                Text('Erreur lors du chargement des clients.'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('Aucun client trouvé.'));
                      }

                      final clients = snapshot.data!;

                      return ListView.builder(
                        itemCount: clients.length,
                        itemBuilder: (context, index) {
                          final client = clients[index];

                          return Dismissible(
                            key: Key(client.id.toString()),
                            direction: DismissDirection.horizontal,
                            onDismissed: (direction) {
                              showModalConfirmation(context, onTapCancel: () {
                                Navigator.pop(context);
                                setState(() {
                                  _fetchClients();
                                });
                              }, onTapOk: () {
                                _deleteClient(client.id!);
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
                                title: Text(client.nom),
                                subtitle: Text(client.email),
                                trailing: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.greyDark.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    child: Center(
                                        child: Text(
                                      client.id.toString(),
                                      style: const TextStyle(
                                          color: AppColors.white),
                                    ))),
                                onTap: () {
                                  NavigationService.navigateToPage(
                                    context,
                                    targetPage:
                                        FormulaireClientPage(client: client),
                                    refreshSourcePage: () {
                                      setState(() {
                                        _fetchClients();
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
      },
    );
  }
}
