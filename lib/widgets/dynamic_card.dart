import 'package:flutter/material.dart';

class InfoCard {
  final String title;
  final String subtitle;
  // final IconData icon;
  final List<InfoLabel> labels;

  InfoCard({
    required this.title,
    required this.subtitle,
    // required this.icon,
    required this.labels,
  });
}

class InfoLabel {
  final IconData icon;
  final String label;
  final String value;

  InfoLabel({required this.icon, required this.label, required this.value});
}

class DynamicCardListPage extends StatelessWidget {
  final List<InfoCard> cardData = [
    InfoCard(
      title: 'Loan Details',
      subtitle: 'User Information',
      // icon: Icons.person,
      labels: [
        InfoLabel(icon: Icons.person, label: 'Description', value: 'KYC Form'),
        InfoLabel(icon: Icons.money, label: 'prdFrom', value: '98754584'),
        InfoLabel(
          icon: Icons.add_to_home_screen,
          label: 'prdTo',
          value: '1234567',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: cardData.length,
        itemBuilder: (context, index) {
          return InfoCardWidget(card: cardData[index]);
        },
      ),
    );
  }
}

class InfoCardWidget extends StatelessWidget {
  final InfoCard card;

  const InfoCardWidget({required this.card});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        card.subtitle,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children:
                  card.labels.map((label) {
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          iconWithLabel(label.icon, label.label),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              label.value,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),

                          const SizedBox(height: 4),
                        ],
                      ),
                    );
                  }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget iconWithLabel(IconData iconData, String label) {
    return Row(
      children: [
        Icon(iconData, size: 14),
        const SizedBox(width: 6),
        Flexible(child: Text(label, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}
