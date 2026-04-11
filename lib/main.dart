import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userInput = '';
  String answer = '0';

  final List<String> buttons = [
    'C', '+/-', '%', 'DEL',
    '7', '8', '9', '/',
    '4', '5', '6', 'x',
    '1', '2', '3', '-',
    '0', '.', '=', '+',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          // Display Area
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20,20,20,10),
              color: Colors.grey[900],
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    userInput,
                    style: const TextStyle(fontSize: 24, color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    answer,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Buttons
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.all(2),
              color: Colors.grey[900],
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final text = buttons[index];

                  // Clear Button
                  if (text == 'C') {
                    return MyButton(
                      buttonText: text,
                      color: Colors.red[400],
                      textColor: Colors.white,
                      onTap: () {
                        setState(() {
                          userInput = '';
                          answer = '0';
                        });
                      },
                    );
                  }

                  // +/- Button
                  if (text == '+/-') {
                    return MyButton(
                      buttonText: text,
                      color: Colors.blue[50],
                      textColor: Colors.black,
                      onTap: () {
                        setState(() {
                          if (userInput.isNotEmpty && userInput != '0') {
                            if (userInput.startsWith('-')) {
                              userInput = userInput.substring(1);
                            } else {
                              userInput = '-$userInput';
                            }
                          }
                        });
                      },
                    );
                  }

                  // % Button
                  if (text == '%') {
                    return MyButton(
                      buttonText: text,
                      color: Colors.blue[50],
                      textColor: Colors.black,
                      onTap: () {
                        setState(() {
                          if (userInput.isNotEmpty) {
                            userInput += '%';
                          }
                        });
                      },
                    );
                  }

                  // Delete Button
                  if (text == 'DEL') {
                    return MyButton(
                      buttonText: text,
                      color: Colors.blue[50],
                      textColor: Colors.black,
                      onTap: () {
                        setState(() {
                          if (userInput.isNotEmpty) {
                            userInput = userInput.substring(0, userInput.length - 1);
                          }
                        });
                      },
                    );
                  }

                  // Equal Button
                  if (text == '=') {
                    return MyButton(
                      buttonText: text,
                      color: Colors.orange[700],
                      textColor: Colors.white,
                      onTap: () => equalPressed(),
                    );
                  }

                  // Other buttons
                  return MyButton(
                    buttonText: text,
                    color: isOperator(text) ? Colors.blueAccent : Colors.white,
                    textColor: isOperator(text) ? Colors.white : Colors.black,
                    onTap: () {
                      setState(() {
                        userInput += text;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(String x) {
    return ['/', 'x', '-', '+', '='].contains(x);
  }

  void equalPressed() {
    try {
      String finalInput = userInput.replaceAll('x', '*');

      // Handle percentage
      finalInput = finalInput.replaceAll('%', '/100');

      Parser p = Parser();
      Expression exp = p.parse(finalInput);
      ContextModel cm = ContextModel();

      double eval = exp.evaluate(EvaluationType.REAL, cm);

      setState(() {
        answer = eval.toStringAsFixed(6).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
        // Keep the expression in userInput so user can see what they calculated
      });
    } catch (e) {
      setState(() {
        answer = 'Error';
      });
    }
  }
}

// Button Widget
class MyButton extends StatelessWidget {
  final String buttonText;
  final Color? color;
  final Color? textColor;
  final VoidCallback? onTap;

  const MyButton({
    super.key,
    required this.buttonText,
    this.color,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: color ?? Colors.white,
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor ?? Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}