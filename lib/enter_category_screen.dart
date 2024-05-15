import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memex/custom_text_field.dart';
import 'package:memex/meme_screen.dart';

class EnterCategoryScreen extends StatefulWidget {
  const EnterCategoryScreen({super.key});

  @override
  State<EnterCategoryScreen> createState() => _EnterCategoryScreenState();
}

class _EnterCategoryScreenState extends State<EnterCategoryScreen> {
  late TextEditingController categoryOneController;
  late TextEditingController categoryTwoController;
  late TextEditingController categoryThreeController;
  late TextEditingController categoryFourController;

  List<XFile?>? images = [];
  List<String> text = [];
  List<TextEditingController> textEditingControllers = [];
  var textFields = <TextField>[];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    categoryOneController = TextEditingController();
    categoryTwoController = TextEditingController();
    categoryThreeController = TextEditingController();
    categoryFourController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    categoryOneController.dispose();
    categoryTwoController.dispose();
    categoryThreeController.dispose();
    categoryFourController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17181A),
      appBar: AppBar(
        title: const Text("Enter Category Screen",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF17181A),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    CustomTextField.customTextField(
                      textEditingController: categoryOneController,
                      hintText: "Enter Category One",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter category one";
                        }
                        return null;
                      },
                    ),
                    CustomTextField.customTextField(
                      textEditingController: categoryTwoController,
                      hintText: "Enter Category Two",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter category two";
                        }
                        return null;
                      },
                    ),
                    CustomTextField.customTextField(
                      textEditingController: categoryThreeController,
                      hintText: "Enter Category Three",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter category three";
                        }
                        return null;
                      },
                    ),
                    CustomTextField.customTextField(
                      textEditingController: categoryFourController,
                      hintText: "Enter Category Four",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter category four";
                        }
                        return null;
                      },
                    ),

                  ],
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
                    text.add(categoryOneController.text);
                    text.add(categoryTwoController.text);
                    text.add(categoryThreeController.text);
                    text.add(categoryFourController.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MemeScreen(
                          images: images,
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
        ),
      ),
    );
  }
}
