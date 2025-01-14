import 'package:flutter/material.dart';
import 'package:voicepassing/services/api_service.dart';
import 'package:voicepassing/style/color_style.dart';
import 'package:voicepassing/widgets/pie_chart.dart';

class ChartBox extends StatelessWidget {
  ChartBox({super.key});

  final List<double> tempData = [1, 1, 1];
  final Future<List<double>> categoryNum = ApiService.getCategoryNum();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "범죄 유형 통계",
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ColorStyles.backgroundBlue),
            child: FutureBuilder(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return PieChartSample2(data: snapshot.data!);
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              future: categoryNum,
            )),
        const SizedBox(
          height: 36,
        ),
      ],
    );
  }
}
