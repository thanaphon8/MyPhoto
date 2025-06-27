import 'package:flutter/material.dart';

void main() {
  runApp(const PhotoGridApp());
}

class PhotoGridApp extends StatelessWidget {
  const PhotoGridApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Viewer',
      home: const PhotoGridPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PhotoGridPage extends StatefulWidget {
  const PhotoGridPage({super.key});

  @override
  State<PhotoGridPage> createState() => _PhotoGridPageState();
}

class _PhotoGridPageState extends State<PhotoGridPage> {
  bool isGridView = true;

  final List<String> imageUrls = const [
    'https://picsum.photos/id/1011/400/300',
    'https://picsum.photos/id/1012/400/300',
    'https://picsum.photos/id/1013/400/300',
    'https://picsum.photos/id/1015/400/300',
    'https://picsum.photos/id/1016/400/300',
    'https://picsum.photos/id/1018/400/300',
    'https://picsum.photos/id/1020/400/300',
    'https://picsum.photos/id/1024/400/300',
    'https://picsum.photos/id/1027/400/300',
    'https://picsum.photos/id/1035/400/300',
  ];

  void openFullScreen(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            FullScreenGallery(imageUrls: imageUrls, initialIndex: initialIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow, // เปลี่ยนเป็นสีเหลือง
        title: const Text('MY Photo'),
        actions: [
          IconButton(
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
          ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: isGridView
            ? GridView.builder(
                key: const ValueKey('grid'),
                padding: const EdgeInsets.all(8.0),
                itemCount: imageUrls.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => openFullScreen(index),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(imageUrls[index], fit: BoxFit.cover),
                    ),
                  );
                },
              )
            : ListView.builder(
                key: const ValueKey('list'),
                padding: const EdgeInsets.all(8.0),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => openFullScreen(index),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class FullScreenGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenGallery({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<FullScreenGallery> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow, // เปลี่ยนเป็นสีเหลือง
        iconTheme: const IconThemeData(color: Colors.black), // ไอคอนสีดำ
        elevation: 0,
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(child: Image.network(widget.imageUrls[index])),
          );
        },
      ),
    );
  }
}
