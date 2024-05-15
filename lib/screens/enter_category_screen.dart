import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memex/widget/custom_text_field.dart';
import 'package:memex/screens/meme_screen.dart';

class EnterCategoryScreen extends StatefulWidget {
  const EnterCategoryScreen({super.key});

  @override
  State<EnterCategoryScreen> createState() => _EnterCategoryScreenState();
}

class _EnterCategoryScreenState extends State<EnterCategoryScreen> {
  double _currentSliderValue = 4;
  List<XFile?>? images = [];
  List<String> text = [];
  List<TextEditingController> textEditingControllers = [];
  var textFields = <TextField>[];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    textEditingControllers = List.generate(
      10,
      (index) => TextEditingController(),
    );
    super.initState();
  }

  @override
  void dispose() {
    for (var element in textEditingControllers) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17181A),
      appBar: AppBar(
        title: const Text("Tier Screen", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF17181A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
                "Using Slider , Select Number of Tier You Want to Create",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                )),
            Slider(
              value: _currentSliderValue,
              max: 10,
              min: 1,
              divisions: 10,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
            Expanded(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < _currentSliderValue; i++)
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: CustomTextField.customTextField(
                            textEditingController: textEditingControllers[i],
                            hintText: "Enter Category ${i + 1}",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter category ${i + 1}";
                              }
                              return null;
                            },
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: images?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.file(
                        File(
                          images?[index]?.path ?? "",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    ImagePicker picker = ImagePicker();
                    images = await picker.pickMultiImage();
                    setState(() {});
                  },
                  child: const Text("Select Images"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        (images?.length ?? 0) > 1) {
                      text = [];
                      for (int i = 0; i < _currentSliderValue; i++) {
                        text.add(textEditingControllers[i].text);
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MemeScreen(
                            images: images,
                            totalCategories: _currentSliderValue.toInt() + 1,
                            text: text,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Please enter all categories and select at least 2 images"),
                        ),
                      );
                    }
                  },
                  child: const Text("Create MeMe"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
