import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../shared/firebase/firebase_manager.dart';

class AddMemoriesPage extends StatefulWidget {
  const AddMemoriesPage({super.key});
  static const String routeName = 'addmemories';

  @override
  State<AddMemoriesPage> createState() => _AddMemoriesPageState();
}

class _AddMemoriesPageState extends State<AddMemoriesPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  File? selectedImage;
  File? selectedAudio;

  bool enableImage = false;
  bool enableAudio = false;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  Future<void> pickAudio() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result != null) {
      setState(() => selectedAudio = File(result.files.single.path!));
    }
  }

  Future<void> saveMemory() async {
    if ((enableImage && selectedImage == null) ||
        (enableAudio && selectedAudio == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("من فضلك اختر الملفات المطلوبة")),
      );
      return;
    }

    try {
      await FirebaseManager().uploadMemory(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        imageFile: selectedImage,
        audioFile: selectedAudio,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم حفظ الذكرى بنجاح")),
      );

      titleController.clear();
      descriptionController.clear();
      setState(() {
        selectedImage = null;
        selectedAudio = null;
        enableImage = false;
        enableAudio = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة ذكرى جديدة'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("عنوان الذكرى", theme),
            const SizedBox(height: 8),
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'مثال: أول مرة قرأت هذا الكتاب',
              ),
            ),

            const SizedBox(height: 20),
            _sectionTitle("رفع صورة", theme),
            SwitchListTile(
              title: const Text("هل تريد إضافة صورة؟"),
              value: enableImage,
              onChanged: (val) {
                setState(() {
                  enableImage = val;
                  if (!val) selectedImage = null;
                });
              },
            ),
            if (enableImage) ...[
              ElevatedButton.icon(
                onPressed: pickImage,
                icon: const Icon(Icons.image_outlined),
                label: const Text('اختر صورة'),
              ),
              const SizedBox(height: 10),
              if (selectedImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(selectedImage!, height: 180, fit: BoxFit.cover),
                ),
            ],

            const SizedBox(height: 20),
            _sectionTitle("رفع صوت", theme),
            SwitchListTile(
              title: const Text("هل تريد إضافة تسجيل صوتي؟"),
              value: enableAudio,
              onChanged: (val) {
                setState(() {
                  enableAudio = val;
                  if (!val) selectedAudio = null;
                });
              },
            ),
            if (enableAudio) ...[
              ElevatedButton.icon(
                onPressed: pickAudio,
                icon: const Icon(Icons.audiotrack),
                label: const Text('اختر ملف صوتي'),
              ),
              if (selectedAudio != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'الصوت المحدد: ${selectedAudio!.path.split('/').last}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
            ],

            const SizedBox(height: 20),
            _sectionTitle("تفاصيل الذكرى", theme),
            const SizedBox(height: 8),
            TextFormField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'اكتب وصفًا للذكرى هنا...',
              ),
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: saveMemory,
                icon: const Icon(Icons.save),
                label: const Text('حفظ الذكرى'),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleLarge,
    );
  }
}
