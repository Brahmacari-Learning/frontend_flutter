import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedanta_frontend/src/providers/doa_provider.dart';
import 'package:vedanta_frontend/src/services/auth_wraper.dart';
import 'package:vedanta_frontend/src/widgets/input_rounded_with_icon_widget.dart';
import 'package:vedanta_frontend/src/widgets/no_internet.dart';

class AlarmSelectDoaScreen extends StatefulWidget {
  const AlarmSelectDoaScreen({super.key});

  @override
  State<AlarmSelectDoaScreen> createState() => _AlarmSelectDoaScreenState();
}

class _AlarmSelectDoaScreenState extends State<AlarmSelectDoaScreen> {
  final TextEditingController _controllerSearch = TextEditingController();
  final List<dynamic> _doaList = [];
  Timer? _debounce;
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

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _futureDoa = _getDoaList(_controllerSearch.text);
      });
    });
  }

  @override
  void dispose() {
    _controllerSearch.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _futureDoa = _getDoaList('');
  }

  @override
  Widget build(BuildContext context) {
    return AuthWrapper(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
          shadowColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.purple,
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
            onChanged: (value) {
              _onSearchChanged();
            },
            label: 'Cari doa...',
            onEnter: (value) {
              _onSearchChanged();
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
                return const NoInternet();
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
      ),
    );
  }
}
