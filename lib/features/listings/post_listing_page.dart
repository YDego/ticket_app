import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:ticket_app/services/listings_service.dart';

class PostListingPage extends StatefulWidget {
  const PostListingPage({super.key});
  @override
  State<PostListingPage> createState() => _PostListingPageState();
}

class _PostListingPageState extends State<PostListingPage> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();
  final _images = <File>[];
  bool _loading = false;

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage(imageQuality: 85);
    setState(() => _images.addAll(files.map((x) => File(x.path))));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final id = await ListingsService().createListing(ListingInput(
        title: _title.text.trim(),
        description: _desc.text.trim().isEmpty ? null : _desc.text.trim(),
        pricePerUnit: _price.text.trim().isEmpty ? null : double.tryParse(_price.text.trim()),
        images: _images,
      ));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('פורסם (#$id)')));
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('שגיאה: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('פרסום מודעה')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'כותרת *'),
              validator: (v) => (v == null || v.trim().length < 2) ? 'כותרת קצרה מדי' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(controller: _desc, maxLines: 4, decoration: const InputDecoration(labelText: 'תיאור')),
            const SizedBox(height: 12),
            TextFormField(controller: _price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'מחיר')),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: [
                for (final f in _images)
                  Stack(children: [
                    Image.file(f, width: 100, height: 100, fit: BoxFit.cover),
                    Positioned(right: 0, top: 0, child: IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() => _images.remove(f)))),
                  ]),
                InkWell(
                  onTap: _pickImages,
                  child: Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(child: Icon(Icons.add_a_photo_outlined)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _loading ? null : _submit,
              icon: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send),
              label: const Text('פרסם'),
            ),
          ],
        ),
      ),
    );
  }
}
