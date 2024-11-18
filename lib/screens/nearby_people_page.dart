import 'package:flutter/material.dart';

class NearbyPeoplePage extends StatefulWidget {
  const NearbyPeoplePage({super.key});

  @override
  State<NearbyPeoplePage> createState() => _NearbyPeoplePageState();
}

class _NearbyPeoplePageState extends State<NearbyPeoplePage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby People'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // 설정 페이지
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mockUsers.length,
        itemBuilder: (context, index) {
          final user = mockUsers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(user['name']![0]),
              ),
              title: Text(user['name']!),
              subtitle: Text(user['status']!),
              trailing: Text(user['distance']!),
              onTap: () {
                // 사용자 상세 정보
                showUserDetails(context, user);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 나중에 실제 스캔 기능 구현
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Scanning for nearby people...')),
          );
        },
        child: const Icon(Icons.search),
      ),
    );
  }

  void showUserDetails(BuildContext context, Map<String, String> user) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              child: Text(user['name']![0]),
            ),
            const SizedBox(height: 16),
            Text(user['name']!, style: Theme.of(context).textTheme.headlineSmall),
            Text(user['status']!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 메시지 보내기 기능
                Navigator.pop(context);
              },
              child: const Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}
