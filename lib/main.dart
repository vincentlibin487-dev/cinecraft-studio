import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Camera error: $e');
  }
  runApp(const CinecraftStudioApp());
}

class CinecraftStudioApp extends StatelessWidget {
  const CinecraftStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cinecraft Studio Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
      ),
      home: const StudioHomeScreen(),
    );
  }
}

class StudioHomeScreen extends StatefulWidget {
  const StudioHomeScreen({super.key});

  @override
  State<StudioHomeScreen> createState() => _StudioHomeScreenState();
}

class _StudioHomeScreenState extends State<StudioHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CameraStudioTab(),
    const EditorStudioTab(),
    const AiSmartStudioTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: const Color(0xFF1F1F1F),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.videocam),
            label: 'Pro Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Master Editor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology),
            label: 'AI Studio',
          ),
        ],
      ),
    );
  }
}

// 1. പ്രൊഫഷണൽ ക്യാമറ ടാബ്
class CameraStudioTab extends StatefulWidget {
  const CameraStudioTab({super.key});

  @override
  State<CameraStudioTab> createState() => _CameraStudioTabState();
}

class _CameraStudioTabState extends State<CameraStudioTab> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    if (cameras.isNotEmpty) {
      controller = CameraController(cameras[0], ResolutionPreset.high);
      controller!.initialize().then((_) {
        if (!mounted) return;
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cinecraft Pro Camera', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.auto_awesome, color: Colors.blueAccent), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          Center(child: CameraPreview(controller!)),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(icon: const Icon(Icons.photo_library, size: 32), onPressed: () {}),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: IconButton(
                    iconSize: 50,
                    icon: const Icon(Icons.fiber_manual_record, color: Colors.red),
                    onPressed: () {},
                  ),
                ),
                IconButton(icon: const Icon(Icons.cameraswitch, size: 32), onPressed: () {}),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// 2. മാസ്റ്റർ വീഡിയോ എഡിറ്റർ ടാബ്
class EditorStudioTab extends StatelessWidget {
  const EditorStudioTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cinecraft Master Timeline Editor')),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black,
              child: const Center(
                child: Text('Video Preview Window', style: TextStyle(color: Colors.grey)),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: const Color(0xFF1F1F1F),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildToolItem(Icons.cut, 'Split'),
                _buildToolItem(Icons.speed, 'Speed'),
                _buildToolItem(Icons.text_format, 'Text'),
                _buildToolItem(Icons.auto_fix_high, 'AI Filter'),
                _buildToolItem(Icons.mic, 'AI Audio'),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: const Color(0xFF181818),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildTimelineClip('Clip 1.mp4', Colors.blueGrey),
                  _buildTimelineClip('Clip 2.mp4', Colors.teal),
                  _buildTimelineClip('AI Transition', Colors.deepOrange),
                  _buildTimelineClip('Clip 3.mp4', Colors.indigo),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.blueAccent),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }

  Widget _buildTimelineClip(String title, Color color) {
    return Container(
      width: 120,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}

// 3. ഫുൾ AI പവേർഡ് സ്മാർട്ട് സ്റ്റുഡിയോ ടാബ്
class AiSmartStudioTab extends StatelessWidget {
  const AiSmartStudioTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Smart Studio & Automation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildAiHeaderCard(),
          const SizedBox(height: 16),
          _buildAiCard(Icons.auto_fix_high, 'AI Magic Color & Lighting', 'Automatically corrects lighting and colors to give a cinematic movie look.'),
          _buildAiCard(Icons.mic_none, 'AI Voice Denoiser & Studio Mic', 'Removes background noise completely from your voice and makes it sound like a pro studio mic.'),
          _buildAiCard(Icons.closed_caption, 'AI Auto Captions / Subtitles', 'Generates subtitles for your videos automatically in multiple languages.'),
          _buildAiCard(Icons.movie_creation, 'AI Script to Video Generator', 'Convert your scripts and ideas directly into storyboards and automated edits.'),
        ],
      ),
    );
  }

  Widget _buildAiHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blueAccent, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cinecraft AI Engine Active', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 8),
          Text('All professional AI features are unlocked, completely free, and require no login or subscription.', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildAiCard(IconData icon, String title, String subtitle) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent, size: 36),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}