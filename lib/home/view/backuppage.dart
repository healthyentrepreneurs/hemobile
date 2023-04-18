import 'package:flutter/material.dart';
import 'package:he/home/home.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({Key? key}) : super(key: key);
  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => const BackupPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeAppBar(
        course: 'Sync Data',
        appbarwidget: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        transparentBackground: false,
      ),
      backgroundColor: const Color(0xfff6f6f6),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                title: "",
                children: [
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.backup_sharp,
                              size: 75,
                              color: Theme.of(context).primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Last backup: Today at 12:34",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                  SizedBox(height: 5.0),
                                  Text(
                                    "Total Size: 1.29 GB X",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Text(
                          "You can upload the local data sets when you get online by tapping the below button.",
                          style: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              _SingleSection(
                title: "",
                children: [
                  ListTile(
                    onTap: () {
                      // Perform backup action
                    },
                    title: Material(
                      color: Theme.of(context).primaryColor,
                      child: InkWell(
                        onTap: () {
                          // Perform backup action
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          alignment: Alignment.center,
                          child: const Text(
                            "Upload Data",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _SingleSection(
                title: "Data Statistics",
                children: [
                  ListTile(
                    title: const Text("Surveys"),
                    leading: const Icon(
                      Icons.library_books,
                    ),
                    subtitle: const Text('10 GB to be uploaded'),
                    trailing: const Icon(Icons.sync),
                    onTap: () {},
                  ),
                  ListTile(
                      title: const Text("Books"),
                      leading: const Icon(
                        Icons.menu_book,
                      ),
                      subtitle: const Text('12 GB to be uploaded'),
                      trailing: const Icon(Icons.sync),
                      onTap: () {
                        // Show dialog to choose backup frequency
                      })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.toUpperCase(),
            style:
                Theme.of(context).textTheme.headline3?.copyWith(fontSize: 16),
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
