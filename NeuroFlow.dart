import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(NeuroFlow());
}

class NeuroFlow extends StatelessWidget {
  const NeuroFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

// Home Screen with Bottom Navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    DashboardPage(),
    ProfilePage(),
    EmergencyPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "NeuroFlow",
          style: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,

            color: Colors.white,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 133, 206),
      ),
      body: _pages[_selectedIndex],
      backgroundColor: const Color.fromRGBO(230, 230, 250, 1),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.deepPurpleAccent,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.warning), label: "emerency"),
        ],
      ),
    );
  }
}

// Home Page with Navigation Buttons
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DailyPlannerPage()),
              );
            },
            icon: Icon(
              Icons.task,
              color: const Color.fromARGB(255, 101, 30, 233),
              size: 30,
            ),
            label: Text("Daily planner"),
            style: ElevatedButton.styleFrom(minimumSize: Size(500, 60)),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlarmPage()),
              );
            },
            icon: Icon(
              Icons.alarm,
              color: const Color.fromARGB(255, 255, 140, 211),
              size: 30,
            ),
            label: Text("Alarms"),
            style: ElevatedButton.styleFrom(minimumSize: Size(500, 60)),
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizPage()),
              );
            },
            icon: Icon(
              Icons.quiz,
              color: const Color.fromARGB(255, 68, 211, 255),
              size: 30,
            ),
            style: ElevatedButton.styleFrom(minimumSize: Size(500, 60)),
            label: Text("Take Quiz"),
          ),
        ],
      ),
    );
  }
}

// Alarm Page
class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<TimeOfDay> alarms = [];

  void _addAlarm() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        alarms.add(pickedTime);
      });
    }
  }

  void _removeAlarm(int index) {
    setState(() {
      alarms.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alarms")),
      body: Column(
        children: [
          ElevatedButton(onPressed: _addAlarm, child: const Text("Add Alarm")),
          Expanded(
            child: ListView.builder(
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(alarms[index].format(context)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeAlarm(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Daily Planner Page
class DailyPlannerPage extends StatefulWidget {
  const DailyPlannerPage({super.key});

  @override
  _DailyPlannerPageState createState() => _DailyPlannerPageState();
}

class _DailyPlannerPageState extends State<DailyPlannerPage> {
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();
  List<Map<String, dynamic>> tasks = [];

  @override
  void dispose() {
    _taskTitleController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  void _handleAddTask() {
    String title = _taskTitleController.text.trim();
    String description = _taskDescriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty) {
      setState(() {
        tasks.add({'title': title, 'description': description, 'done': false});
        _taskTitleController.clear();
        _taskDescriptionController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Task title and description cannot be empty"),
        ),
      );
    }
  }

  void _toggleTaskStatus(int index) {
    setState(() {
      tasks[index]['done'] = !tasks[index]['done'];
    });
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Planner")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskTitleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _taskDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _handleAddTask,
              child: const Text("Add Task"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(child: Text("No tasks added yet."))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: tasks[index]['done'],
                              onChanged: (value) => _toggleTaskStatus(index),
                            ),
                            title: Text(
                              tasks[index]['title'],
                              style: TextStyle(
                                decoration: tasks[index]['done']
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: Text(tasks[index]['description']),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTask(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

//EmergencyPage
class EmergencyPage extends StatelessWidget {
  const EmergencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Emergency Page", style: TextStyle(fontSize: 24)),
    );
  }
}

// Dashboard Page
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _quizScore = 0;

  @override
  void initState() {
    super.initState();
    _loadScore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadScore(); // Reload score when the dashboard is visited again
  }

  Future<void> _loadScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _quizScore = prefs.getInt('quiz_score') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Your Quiz Score: $_quizScore",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _quizScore > 2
              ? Column(
                  children: [
                    Icon(Icons.emoji_events, size: 100, color: Colors.amber),
                    Text(
                      "Congratulations!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                )
              : Text(
                  "Keep trying to earn a trophy!",
                  style: TextStyle(fontSize: 18),
                ),
        ],
      ),
    );
  }
}

// Profile Page with Editable Fields
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Your Name";
  String age = "Age";
  String birthDate = "Date Of Birth";
  String condition = "Your Neurodiverse Condition";
  String email = "Your email";
  String phone = "Your Phone Number";

  void _editField(
    String fieldName,
    String currentValue,
    Function(String) onSave,
  ) {
    TextEditingController controller = TextEditingController(
      text: currentValue,
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit $fieldName"),
          content: TextField(controller: controller),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget buildEditableField(
    String label,
    String value,
    Function(String) onSave,
  ) {
    return ListTile(
      title: Text("$label: $value"),
      trailing: IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => _editField(label, value, onSave),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildEditableField(
                "Name",
                name,
                (val) => setState(() => name = val),
              ),
              buildEditableField(
                "Age",
                age,
                (val) => setState(() => age = val),
              ),
              buildEditableField(
                "Birth Date",
                birthDate,
                (val) => setState(() => birthDate = val),
              ),
              buildEditableField(
                "Neurodiverse Condition",
                condition,
                (val) => setState(() => condition = val),
              ),
              buildEditableField(
                "Email",
                email,
                (val) => setState(() => email = val),
              ),
              buildEditableField(
                "Phone",
                phone,
                (val) => setState(() => phone = val),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Quiz Page
class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question':
          'If a friend looks sad and isnt talking much, what would be a good thing to do?',
      'options': [
        'Ignore them',
        'Ask if they are okay and offer to listen',
        'Tell them to stop being sad',
        'Walk away',
      ],
      'answer': 'Ask if they are okay and offer to listen',
    },
    {
      'question':
          ' What does it usually mean when someone crosses their arms and looks away while talking to you?',
      'options': [
        ' They are feeling open and friendly',
        'They might be upset or uncomfortable',
        'They want to dance',
        'They are thinking about lunch',
      ],
      'answer': 'They might be upset or uncomfortable',
    },
    {
      'question': 'They might be upset or uncomfortable',
      'options': [
        'Do them in any order without a plan',
        'Make a to-do list and prioritize the most important task first',
        ' Wait until the last minute and rush to finish them',
        'Ignore them and hope they go away',
      ],
      'answer':
          'Make a to-do list and prioritize the most important task first',
    },
    {
      'question':
          'If you forget what you were supposed to do next, what is a helpful strategy?',
      'options': [
        'Get frustrated and stop trying',
        'Use a planner or checklist to remind yourself',
        'Wait for someone to remind you',
        ' Do something else instead',
      ],
      'answer': 'Use a planner or checklist to remind yourself',
    },
    {
      'question':
          'If you are trying to solve a puzzle and get stuck, what should you do?',
      'options': [
        'Give up immediately',
        'Keep trying different ways to solve it',
        'Get angry and throw it away',
        'Blame someone else',
      ],
      'answer': 'Keep trying different ways to solve it',
    },
  ];

  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  int _score = 0;
  Future<void> _saveScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('quiz_score', _score);
  }

  void _submitAnswer() {
    if (_selectedAnswer == _questions[_currentQuestionIndex]['answer']) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
      });
    } else {
      _saveScore(); // Save the score when quiz ends
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Quiz Over'),
            content: Text('Your score is: $_score/${_questions.length}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentQuestionIndex = 0;
                    _score = 0;
                    _selectedAnswer = null;
                  });
                },
                child: Text('Restart'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1} / ${_questions.length}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ..._questions[_currentQuestionIndex]['options']
                .map<Widget>(
                  (option) => RadioListTile<String>(
                    title: Text(option),
                    value: option,
                    groupValue: _selectedAnswer,
                    onChanged: (value) {
                      setState(() {
                        _selectedAnswer = value;
                      });
                    },
                  ),
                )
                .toList(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAnswer,
              child: Text('Submit Answer'),
            ),
          ],
        ),
      ),
    );
  }
}

class SharedPreferences {
  static Future getInstance() async {}
}
