import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:reservation/src/themes/colors.dart';

typedef CallbackSimpleHeader = void Function();

class SimpleHeader extends StatefulWidget implements PreferredSizeWidget {
  const SimpleHeader(
      {super.key,
      this.title = "",
      this.onTap,
      this.actions,
      this.isAddPop = true});

  final String title;
  final CallbackSimpleHeader? onTap;
  final bool isAddPop;
  final Widget? actions;

  @override
  State<SimpleHeader> createState() => _SimpleHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _SimpleHeaderState extends State<SimpleHeader> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      elevation: 0,
      toolbarHeight: 70,
      titleSpacing: widget.isAddPop ? 0 : null,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      leading: widget.isAddPop
          ? IconButton(
              onPressed: () => {
                    widget.onTap != null
                        ? widget.onTap!()
                        : Navigator.pop(context, true)
                  },
              iconSize: 30,
              icon: SvgPicture.asset(
                "assets/images/arrow-left.svg",
                color: isDarkMode ? AppColors.white : AppColors.grey_4,
              ))
          : null,
      // leadingWidth: isAddPop? 0:,
      leadingWidth: !widget.isAddPop ? 0 : null,
      actions: widget.actions != null ? [widget.actions!] : null,
      title: !widget.isAddPop
          ? Text(widget.title,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: isDarkMode ? AppColors.white : AppColors.black))
          : InkWell(
              onTap: () => {
                widget.onTap != null ? widget.onTap!() : Navigator.pop(context)
              },
              child: Text(widget.title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: isDarkMode ? AppColors.white : AppColors.black,
                      )),
            ),
    );
  }
}
