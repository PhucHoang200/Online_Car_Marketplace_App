import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SfCartesianChart(
        title: ChartTitle(text: "Số lượng bài đăng theo tháng"),
        primaryXAxis: CategoryAxis(),
        series: <CartesianSeries>[
          ColumnSeries<ChartData, String>(
            dataSource: [
              ChartData('1', 30),
              ChartData('2', 40),
              ChartData('3', 25),
            ],
            xValueMapper: (ChartData data, _) => data.month,
            yValueMapper: (ChartData data, _) => data.count,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String month;
  final int count;
  ChartData(this.month, this.count);
}
