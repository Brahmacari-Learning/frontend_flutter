import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/doa_provider.dart';
import 'package:vedanta_frontend/src/widgets/input_rounded_with_icon_widget.dart';

class AlarmSelectDoaScreen extends StatefulWidget {
  const AlarmSelectDoaScreen({super.key});

  @override
  State<AlarmSelectDoaScreen> createState() => _AlarmSelectDoaScreenState();
}

class _AlarmSelectDoaScreenState extends State<AlarmSelectDoaScreen> {
  final TextEditingController _controllerSearch = TextEditingController();
  final List<dynamic> _doaList = [];

  late Future<void> _futureDoa = Future.value();

  Future<void> _getDoaList(String query) async {
    final doaProvider = Provider.of<DoaProvider>(context, listen: false);
    final response = await doaProvider.searchDoa(query);
    setState(() {
      _doaList.clear();
      for (var i = 0; i < response['doas'].length; i++) {
        _doaList.add(response['doas'][i]);
      }
    });
  }

  @override
  void dispose() {
    _controllerSearch.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _futureDoa = _getDoaList('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        shadowColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.purple, // Warna pink untuk back button
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.pop(context);
          },
        ),
        title: InputRoundedWithIcon(
          controller: _controllerSearch,
          icon: Icons.search,
          onChanged: (value) async {
            setState(() {
              _futureDoa = _getDoaList(_controllerSearch.text);
            });
          },
          label: 'Cari doa...',
          onEnter: (value) async {
            setState(() {
              _futureDoa = _getDoaList(_controllerSearch.text);
            });
          },
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<void>(
          future: _futureDoa,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              return _doaList.isEmpty
                  ? const Center(child: Text('Tidak ada doa'))
                  : ListView.builder(
                      itemCount: _doaList.length,
                      itemBuilder: (context, index) {
                        final doa = _doaList[index];
                        return ListTile(
                          title: Text(
                            doa['title'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context, doa);
                          },
                        );
                      },
                    );
            }
          },
        ),
      ),
    );
  }
}
