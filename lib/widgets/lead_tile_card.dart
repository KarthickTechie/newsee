/*
 @created on : May 7,2025
 @author : Akshayaa 
 Description : Custom widget for displaying individual lead details in card format
*/

import 'package:flutter/material.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Utils/utils.dart';

class LeadTileCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String type;
  final String product;
  final String phone;
  final String createdon;
  final String location;
  final String loanamount;
  final VoidCallback? onTap;
  final bool showarrow;
  final Widget? button;
  final bool ennablePhoneTap;

  const LeadTileCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.color = Colors.teal,
    required this.type,
    required this.product,
    required this.phone,
    required this.createdon,
    required this.location,
    required this.loanamount,
    this.onTap,
    this.showarrow = true,
    this.button,
    this.ennablePhoneTap = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withOpacity(0.1),
                    child: Icon(icon, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(subtitle, style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                  if (showarrow)
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black,
                    ),
                  if (button != null) button!,
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: iconWithLabel(Icons.person_2_outlined, type)),
                  Expanded(child: iconWithLabel(Icons.badge_outlined, product)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (!ennablePhoneTap) return;

                        FocusScope.of(context).unfocus();
                        final phoneNumber = "919940362579";
                        final Uri uri = Uri.parse('tel:$phoneNumber');
                        if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                        } else {
                         throw 'Could not launch $uri';
                        }
                      },
                      child: iconWithLabel(
                        Icons.chrome_reader_mode_outlined,
                        phone,
                      ),
                    ),
                  ),
                  Expanded(
                    child: iconWithLabel(
                      Icons.calendar_month_outlined,
                      createdon,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: iconWithLabel(Icons.location_pin, location)),
                  Expanded(
                    child: iconWithLabel(
                      Icons.currency_rupee_outlined,
                      formatAmount(loanamount),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconWithLabel(IconData iconData, String label) {
    return Row(
      children: [
        Icon(iconData, size: 16, color: color),
        const SizedBox(width: 6),
        Flexible(child: Text(label, style: const TextStyle(fontSize: 12))),
      ],
    );
  }
}
