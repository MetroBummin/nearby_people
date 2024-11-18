import 'package:flutter/material.dart';

class NearbyPeoplePage extends StatefulWidget {
  const NearbyPeoplePage({super.key});

  @override
  State<NearbyPeoplePage> createState() => _NearbyPeoplePageState();
}

class _NearbyPeoplePageState extends State<NearbyPeoplePage> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> mockUsers = [
    {
      'name': 'John Doe',
      'status': 'Available',
      'distance': '5m away'
    },
    {
      'name': 'Jane Smith',
      'status': 'Busy',
      'distance': '10m away'
    },
    // 더 많은 테스트 데이터 추가 가능
  ];

  String? highlightedUser; // 메시지를 보낸 사용자 표시용
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showUserDetails(BuildContext context, Map<String, String> user) {
    final TextEditingController messageController = TextEditingController();
    
    // 메시지 전송 로직을 함수로 분리
    void sendMessage() {
      if (messageController.text.isNotEmpty) {
        setState(() {
          highlightedUser = user['name'];
        });
        
        _animationController
          ..reset()
          ..forward().whenComplete(() {
            if (mounted) {
              setState(() {
                highlightedUser = null;
              });
            }
          });
        
        Navigator.pop(context);
        messageController.clear();
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  user['name']![0],
                  style: const TextStyle(fontSize: 32, color: Colors.black87),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user['name']!,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(user['distance']!, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 24),
              TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Type your message...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                maxLines: 3,
                onSubmitted: (_) => sendMessage(), // Enter 키로 전송
                textInputAction: TextInputAction.send, // 키보드의 완료 버튼을 전송 버튼으로 변경
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: sendMessage,  // 동일한 전송 함수 사용
                  child: const Text('Send Message', 
                    style: TextStyle(fontSize: 16)
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Nearby People', style: TextStyle(color: Colors.black)),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Scanning for nearby people...')),
          );
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: mockUsers.length,
          itemBuilder: (context, index) {
            final user = mockUsers[index];
            bool isHighlighted = user['name'] == highlightedUser;
            
            return GestureDetector(
              onTap: () => showUserDetails(context, user),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          user['name']![0],
                          style: const TextStyle(fontSize: 24, color: Colors.black87),
                        ),
                      ),
                      if (isHighlighted)
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return SizedBox(
                              width: 85,  // CircleAvatar 지름 + 약간의 여유
                              height: 85,
                              child: CircularProgressIndicator(
                                value: _animationController.value,
                                strokeWidth: 2,
                                color: Colors.blue,
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user['name']!,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    user['distance']!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
