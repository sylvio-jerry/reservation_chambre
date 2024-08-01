import 'package:flutter/material.dart';
import 'package:reservation/src/themes/colors.dart';
import 'package:reservation/src/widgets/button/custom_outline_button.dart';
import 'package:reservation/src/widgets/button/custom_solide_button.dart';

void showModalConfirmation(
  BuildContext context, {
  Color backgroundColor = AppColors.grey_1,
  required Function onTapCancel,
  required Function onTapOk,
  String title = "Suppression",
  String content = "Voulez-vous vraiment effectuer la suppression ?",
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
        elevation: 2,
        insetPadding: const EdgeInsets.symmetric(horizontal: 15),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        backgroundColor: backgroundColor,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: AppColors.red),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Text(
                  content,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 120,
                    child: CustomOutlineButton(
                      label: "Non",
                      borderColor: AppColors.greyDark,
                      textColor: AppColors.greyDark,
                      onPressed: () {
                        onTapCancel();
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 120,
                    child: CustomSolideButton(
                      label: "Oui",
                      bgColor: AppColors.red,
                      textColor: AppColors.white,
                      onPressed: () {
                        onTapOk();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        )),
  );
}
