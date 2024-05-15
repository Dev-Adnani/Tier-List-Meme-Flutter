import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memex/utiils/share_helper.dart';
import 'package:memex/utiils/widget_to_image.dart';

class MemeScreen extends StatefulWidget {
  final List<XFile?>? images;
  final List<String> text;

  const MemeScreen({
    super.key,
    required this.images,
    required this.text,
  });

  @override
  _MemeScreenState createState() => _MemeScreenState();
}

class _MemeScreenState extends State<MemeScreen> {
  final List<List<XFile?>> _imageLists = [
    [], // First - 0
    [], // Second - 1
    [], // Third - 2
    [], // Fourth - 3
  ];

  final List<Color> _colors = [
    Colors.red.shade400,
    Colors.green.shade400,
    Colors.blue.shade400,
    Colors.yellow.shade400,

  ];

  int _draggedIndex = -1;
  int _targetIndex = -1;

  GlobalKey globalKey = GlobalKey();

  @override
  void initState() {
    _imageLists[3] = widget.images ?? [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17181A),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("MEMIFIED", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF17181A),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          RepaintBoundary(
            key: globalKey,
            child: draggableView(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MaterialButton(
                onPressed: () async {
                  File file = await WidgetToImage.getImageFromWidget(globalKey);
                  await ShareHelper.shareImageFromPath(
                    fileName: "memified",
                    imageData: file.readAsBytesSync(),
                  );
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text("Share Image"),
              ),
              MaterialButton(
                onPressed: () async {
                  final XFile? image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() {
                      _imageLists[3].add(image);
                    });
                  }
                },
                color: Colors.blue,
                textColor: Colors.white,
                child: const Text("Add Image"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to build each ListView
  Widget _buildListView(int index) {
    return Expanded(
      child: Container(
        height: 120,
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DragTarget<int>(
          onWillAcceptWithDetails: (data) {
            setState(() {
              _targetIndex = index;
            });
            return true;
          },
          onAcceptWithDetails: (data) {
            setState(() {
              _imageLists[_targetIndex]
                  .add(_imageLists[_draggedIndex][data.data]);
              _imageLists[_draggedIndex].removeAt(data.data);
            });
          },
          builder: (context, candidateData, rejectedData) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  _imageLists[index].length,
                  (idx) {
                    return Draggable<int>(
                      data: idx,
                      feedback: Image.file(
                        File(_imageLists[index][idx]?.path ?? ""),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      child: Image.file(
                        File(_imageLists[index][idx]?.path ?? ""),
                        fit: BoxFit.cover,
                      ),
                      onDragStarted: () {
                        setState(() {
                          _draggedIndex = index;
                        });
                      },
                      onDragEnd: (details) {
                        setState(() {
                          _draggedIndex = -1;
                          _targetIndex = -1;
                        });
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget draggableView() {
    return Column(
      children: _imageLists.map((imageList) {
        return Container(
          padding: const EdgeInsets.all(8),
          color: _colors[_imageLists.indexOf(imageList)],
          child: Row(
            children: [
              Text(
                widget.text[_imageLists.indexOf(imageList)],
                style: const TextStyle(color: Colors.black, fontSize: 20),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              _buildListView(_imageLists.indexOf(imageList)),
            ],
          ),
        );
      }).toList(),
    );
  }
}
