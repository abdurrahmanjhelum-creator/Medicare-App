import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'search_widget.dart';

class DoctorListHeader extends StatelessWidget {
  final String title;
  final String hintText;
  final String shortText;
  final Widget? leading;
  final Widget? trailing;
  final bool showSearch;
  final Color? firstColor;
  final Color? secondColor;
  final ValueChanged<String>? onSearchChanged;
  final bool autofocus;
  final FocusNode? focusNode;

  const DoctorListHeader({
    super.key,
    required this.title,
    this.hintText = "Search",
    required this.shortText,
    this.leading,
    this.trailing,
    this.showSearch = true,
    this.firstColor,
    this.secondColor,
    this.onSearchChanged,
    this.autofocus = false,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            firstColor ?? AppColors.primaryGreen,
            secondColor ?? AppColors.secondaryGreen,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[leading!, const SizedBox(height: 20)],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      shortText,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                Flexible(child: trailing!),
              ],
            ],
          ),
          if (showSearch) ...[
            const SizedBox(height: 15),
            SearchWidget(
              hintText: hintText,
              onChanged: onSearchChanged,
              autofocus: autofocus,
              focusNode: focusNode,
            ),
          ],
        ],
      ),
    );
  }
}
