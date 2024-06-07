import 'package:flutter/material.dart';
import 'package:t2t1/firsttime/stepper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Target Income Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: INCOMEsimlator(),
    );
  }
}

class INCOMEsimlator extends StatefulWidget {
  @override
  _INCOMEsimlatorState createState() => _INCOMEsimlatorState();
}

class _INCOMEsimlatorState extends State<INCOMEsimlator> {
  double targetIncome = 20000;

  final List<String> PATList = [
    'Director',
    'Senior Director',
    'Executive Director',
    'Senior Executive Director',
    'Platinum Director',
    'Platinum Director',
    'Diamond Director'
  ];

  final List<int> incomeRange = [26000, 58000, 86000, 110000, 200000];
  final List<int> earningPerLPBLeg = [0, 20000, 27000, 28000, 28000, 28000, 28000];

  int qualifiedLegsRequired = 1;
  String PAT = 'Senior Director';
  int LPBLegsRequired = 0;
  int directorLegsRequired = 0;
  List<Leg> legs = [];

  @override
  void initState() {
    super.initState();
    _setTargetData(targetIncome);
  }

  void _setTargetData(double target) {
    setState(() {
      targetIncome = target;
      if (target <= incomeRange[0]) {
        qualifiedLegsRequired = 1;
        PAT = PATList[qualifiedLegsRequired];
      } else if (target > incomeRange[0] && target <= incomeRange[1]) {
        qualifiedLegsRequired = 2;
        PAT = PATList[qualifiedLegsRequired];
      } else if (target > incomeRange[1] && target <= incomeRange[2]) {
        qualifiedLegsRequired = 3;
        PAT = PATList[qualifiedLegsRequired];
      } else if (target > incomeRange[2] && target <= incomeRange[3]) {
        qualifiedLegsRequired = 4;
        PAT = PATList[qualifiedLegsRequired];
      } else if (target > incomeRange[3] && target <= incomeRange[4]) {
        qualifiedLegsRequired = 6;
        PAT = PATList[qualifiedLegsRequired];
      }

      LPBLegsRequired = (target / earningPerLPBLeg[qualifiedLegsRequired]).round();
      _generateLegs();
    });
  }

  void _generateLegs() {
    legs.clear();
    int averagePurchase = 6000;
    int LPBLegVolume = 216000;
    int directorLegVolume = 66000;

    for (int i = 0; i < LPBLegsRequired; i++) {
      legs.add(Leg(
          number: legs.length + 1,
          sales: LPBLegVolume,
          users: (LPBLegVolume / averagePurchase).round()));
    }

    directorLegsRequired = qualifiedLegsRequired - LPBLegsRequired;
    for (int i = 0; i < directorLegsRequired; i++) {
      legs.add(Leg(
          number: legs.length + 1,
          sales: directorLegVolume,
          users: (directorLegVolume / averagePurchase).round()));
    }

    int PGPVLegs = 6 - qualifiedLegsRequired;
    int consultantsPerPGPVLeg = (targetIncome / 6000).round();
    for (int i = 0; i < PGPVLegs; i++) {
      legs.add(Leg(
          number: legs.length + 1,
          sales: consultantsPerPGPVLeg * averagePurchase,
          users: consultantsPerPGPVLeg));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Target Income: ${targetIncome.toInt()}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: targetIncome,
              min: 0,
              max: 50000,
              divisions: 100,
              label: targetIncome.toInt().toString(),
              onChanged: (value) {
                _setTargetData(value);
              },
            ),
            SizedBox(height: 20),
            Text(
              PAT,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: legs.length,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Leg ${legs[index].number}',
                        style: TextStyle(fontSize: 18),
                      ),
                      Slider(
                        value: legs[index].sales.toDouble(),
                        min: 0,
                        max: 300000,
                        divisions: 100,
                        label: legs[index].sales.toString(),
                        onChanged: null, // Slider is disabled
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sales: ${legs[index].sales}'),
                          Text('Users: ${legs[index].users}'),
                          Icon(Icons.info_outline, color: Colors.blue),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  // Trigger the increment of step in CustomStepperPage widget
                  CustomStepperPage.of(context)?.incrementStep(); // Go to step 3
                },
                child: SizedBox(
                  width: 150.0, // Adjust the width as needed
                  height: 50.0, // Adjust the height as needed
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1FA2FF), Color(0xFF12D8FA), Color(0xFF1FA2FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Leg {
  final int number;
  final int sales;
  final int users;

  Leg({required this.number, required this.sales, required this.users});
}
