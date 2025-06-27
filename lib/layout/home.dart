import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memories_entry/layout/add_memories.dart';
import 'package:memories_entry/model/memories_model.dart';
import '../provider/memories_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> sliderImages = [
    'https://i.imgur.com/VjJQyVb.jpg',
    'https://i.imgur.com/XeD4dHk.jpg',
    'https://i.imgur.com/OQ8as3s.jpg',
  ];

  final MemoriesProvider _memoriesProvider = MemoriesProvider();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % sliderImages.length;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cardTheme = Theme.of(context).cardTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("ذكرياتي"),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: sliderImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      sliderImages[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ذكرياتك المحفوظة",
                style: textTheme.titleLarge,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<MemoriesModel>>(
              stream: _memoriesProvider.getUserMemories(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("حدث خطأ أثناء تحميل الذكريات"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("لا توجد ذكريات بعد 😢"));
                }
                final memories = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: memories.length,
                  itemBuilder: (context, index) {
                    return _memoryCard(memories[index], cardTheme as CardTheme, textTheme);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AddMemoriesPage.routeName),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _memoryCard(MemoriesModel memory, CardTheme cardTheme, TextTheme textTheme) {
    return Card(
      shape: cardTheme.shape,
      margin: cardTheme.margin,
      elevation: cardTheme.elevation,
      color: cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(memory.titelMemories, style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(memory.decMemories, style: textTheme.bodyMedium),
            if (memory.imageMemories != null && memory.imageMemories!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(memory.imageMemories!, height: 150, fit: BoxFit.cover),
                ),
              ),
            if (memory.audioMemories != null && memory.audioMemories!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: const [
                    Icon(Icons.audiotrack, color: Colors.pink),
                    SizedBox(width: 6),
                    Text("تسجيل صوتي مرفق"),
                  ],
                ),
              ),
            const SizedBox(height: 6),
            Text(
              "📅 ${memory.dateTimeMemories.toLocal().toString().split(' ')[0]}",
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
