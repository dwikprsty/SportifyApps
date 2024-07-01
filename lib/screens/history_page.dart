import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sportify_app/dto/reservation.dart';
import 'package:sportify_app/dto/fields.dart';
import 'package:sportify_app/dto/session.dart';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:sportify_app/services/data_service.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/widgets/search_form.dart';
import 'package:sportify_app/cubit/auth/auth_cubit.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late Future<List<Reservation>> _bookingHistory;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.dataUser;
    _bookingHistory = DataService.fetchBookingHistory(user!.idPengguna);
  }

  void _updateSearchQuery(String? query) {
    setState(() {
      _searchQuery = query ?? '';
    });
    if (kDebugMode) {
      print('Search query updated: $_searchQuery');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  Color.fromARGB(255, 90, 137, 158),
                  Constants.scaffoldBackgroundColor,
                ],
                focal: Alignment.center,
                radius: 1.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SearchWidget(
                        hintText: "Find your booking history",
                        height: 35,
                        controller: _searchController,
                        onChanged: _updateSearchQuery,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<Reservation>>(
                    future: _bookingHistory,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No booking history found'));
                      } else {
                        final bookings = snapshot.data!;
                        return ListView.builder(
                          itemCount: bookings.length,
                          itemBuilder: (context, index) {
                            final booking = bookings[index];
                            final harga = booking.harga;
                            final idLapangan = booking.idLapangan;
                            final idSesi = booking.idSesi;
                            final tglSewa = booking.tglSewa;
                            // final pembayaran = booking.pembayaran;

                            return FutureBuilder<FieldDetail?>(
                              future:
                                  DataService.fetchDetailLapangan(idLapangan!),
                              builder: (context, detailSnapshot) {
                                if (detailSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (detailSnapshot.hasError) {
                                  return Center(
                                      child: Text(
                                          'Error: ${detailSnapshot.error}'));
                                } else if (!detailSnapshot.hasData ||
                                    detailSnapshot.data == null) {
                                  return const Center(
                                      child: Text('No field detail found'));
                                } else {
                                  final fieldDetail = detailSnapshot.data!;
                                  return FutureBuilder<Session?>(
                                    future:
                                        DataService.fetchDetailSession(idSesi!),
                                    builder: (context, sessionSnapshot) {
                                      if (sessionSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (sessionSnapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${sessionSnapshot.error}'));
                                      } else if (!sessionSnapshot.hasData ||
                                          sessionSnapshot.data == null) {
                                        return const Center(
                                            child: Text(
                                                'No session detail found'));
                                      } else {
                                        final sessionDetail =
                                            sessionSnapshot.data!;
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 6,
                                                offset: Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/images/loading_image.png',
                                                image:
                                                    '${Endpoints.showImage}/${fieldDetail.gambarLapangan}',
                                                fit: BoxFit.cover,
                                                height: 100,
                                                width: 150,
                                                placeholderErrorBuilder:
                                                    (context, error,
                                                        stackTrace) {
                                                  debugPrint(
                                                      'Error loading image: $error');
                                                  return Image.asset(
                                                    'assets/images/failed_placeholder.png',
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: 150,
                                                  );
                                                },
                                                imageErrorBuilder: (context,
                                                    error, stackTrace) {
                                                  debugPrint('Error: $error');
                                                  return Image.asset(
                                                    'assets/images/failed_image.png',
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: 150,
                                                  );
                                                },
                                                fadeOutDuration:
                                                    const Duration(seconds: 30),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(fieldDetail.courtName,
                                                        style: const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                    Text(
                                                        'Booking Date: ${DateFormat('EEE, dd MMM yyyy HH:mm').format(tglSewa)}',
                                                        style: const TextStyle(
                                                            fontSize: 14)),
                                                    Text(
                                                        'Session: ${sessionDetail.waktu}',
                                                        style: const TextStyle(
                                                            fontSize: 14)),
                                                    Text(
                                                        'Price: ${harga.toString()}',
                                                        style: const TextStyle(
                                                            fontSize: 14)),
                                                    Text(
                                                      'Payment Status: ${booking.pembayaran ? 'Paid' : 'Unpaid'}',
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                  );
                                }
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
