import 'package:flutter/material.dart';
import 'package:flutter_login_signup/numberfinal.dart';

class Challenger4Image extends StatelessWidget {
  final int score; // Accept score from the previous screen

  const Challenger4Image({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Move Forward"),
        backgroundColor: const Color.fromARGB(255, 207, 238, 252),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 207, 238, 252),
              Color.fromARGB(255, 242, 222, 246),
              Colors.white
            ],
          ),
        ),
        child: Center(
          child: ThirdGame(score: score),
        ),
      ),
    );
  }
}

class ThirdGame extends StatefulWidget {
  final int score; // Accept score from the previous screen

  const ThirdGame({super.key, required this.score});

  @override
  _ThirdGameState createState() => _ThirdGameState();
}

class _ThirdGameState extends State<ThirdGame> {
  String? solution; // Store the solution
  List<String> availableNumbers = ["2", "1", "9", "7"]; // Available numbers
  bool? isCorrectSolution;
  int attempts = 0;
  int maxAttempts = 3;
  late int score; // Initialize score
  bool buttonClicked = false; // Track if the button has been clicked

  // Map for Cloudinary URLs for each number and animations
  final Map<String, String> cloudinaryImages = {
    "2": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716505/2_zdfgum.png",
    "1": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716505/1_tlz5st.png",
    "9": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716507/9_gdnhiv.png",
    "7": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727716506/7_p3h2p5.png",
    "correct": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358648/correct_edynxy.gif",
    "wrong": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727358655/wrong_k3n0qk.gif",
    "main": "https://res.cloudinary.com/dfph32nsq/image/upload/v1727726887/two_k1esxb.png"
  };

  @override
  void initState() {
    super.initState();
    // Set the score to the initial score received from the previous screen
    score = widget.score;
  }

  void checkSolution() {
    if (solution == "2") {
      // Correct solution
      setState(() {
        isCorrectSolution = true;
        buttonClicked = true; // Set buttonClicked to true when solution is correct
        score += 100; // Increase score on correct solution
      });
    } else {
      // Incorrect solution
      setState(() {
        attempts++;
        if (attempts >= maxAttempts) {
          // If the maximum attempts are reached, reset score
          score = 0;
          solution = "2"; // Set solution to correct answer after max attempts
        }
        isCorrectSolution = false;
      });
    }
  }

  void moveForward() {
    // Navigate to next screen or perform any action you want when solution is correct
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => numberfinal(score: score),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isCorrectSolution != null && isCorrectSolution!)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Image.network(
                cloudinaryImages["correct"]!, // URL for correct gif
                width: 100,
                height: 100,
              ),
            ),
          if (isCorrectSolution != null && !isCorrectSolution!)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Image.network(
                cloudinaryImages["wrong"]!, // URL for wrong gif
                width: 100,
                height: 100,
              ),
            ),
          Image.network(
            cloudinaryImages["main"]!, // Main image URL
            width: 300,
            height: 200,
          ),
          const SizedBox(height: 20),
          // Display the box for solution
          GestureDetector(
            onTap: () {
              setState(() {
                if (solution != null) {
                  availableNumbers.add(solution!); // Add number back to options list
                  solution = null; // Clear solution
                }
              });
            },
            child: Container(
              width: 100,
              height: 100,
              color: Colors.grey,
              alignment: Alignment.center,
              child: solution != null
                  ? SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  cloudinaryImages[solution]!, // Render dropped image from Cloudinary
                  fit: BoxFit.contain,
                ),
              )
                  : const SizedBox(), // Render nothing if no image is dropped
            ),
          ),
          const SizedBox(height: 20),
          // Display draggable number cards
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: availableNumbers.map((number) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (solution == null) {
                      solution = number; // Update solution
                      availableNumbers.remove(number); // Remove selected number
                    }
                  });
                },
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Material(
                    elevation: 5, // Increase elevation
                    borderRadius: BorderRadius.circular(12), // Round corners
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12), // Round corners
                      child: Image.network(
                        cloudinaryImages[number]!, // Use Cloudinary URL for each number
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          // Display "Check Solution" or "Move Forward" button based on solution
          if (!buttonClicked)
            ElevatedButton(
              onPressed: checkSolution,
              child: const Text("Check Solution"),
            ),
          if (isCorrectSolution != null && isCorrectSolution! && buttonClicked)
            ElevatedButton(
              onPressed: moveForward,
              child: const Text("Move Forward"),
            ),
          const SizedBox(height: 20),
          // Display score and remaining attempts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Score: $score",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "${maxAttempts - attempts} Chance",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Challenger4Image(score: 0), // Provide the initial score here
  ));
}
