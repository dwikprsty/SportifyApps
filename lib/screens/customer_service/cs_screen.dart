import 'package:flutter/material.dart';
import 'package:sportify_app/dto/cs.dart';
import 'package:sportify_app/endpoints/endpoints.dart';
import 'package:sportify_app/screens/customer_service/cs_form.dart';
import 'package:sportify_app/services/data_service.dart';
import 'package:sportify_app/utils/constants.dart';
import 'package:sportify_app/utils/helper.dart';
import 'package:sportify_app/widgets/profile.dart';
import 'package:intl/intl.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  Future<List<CustomerService>>? newcs;
  // Future<List<DivisionDepartment>>? newdiv;
  // Future<List<PriorityIssues>>? newprority;

  @override
  void initState() {
    super.initState();
    newcs = DataService.fetchCustomerService();
    // newdiv = DataService.fetchDivisionDepartment();
    // newprority = DataService.fetchPriorityIssues();
  }

  Future<void> _confirmAndDelete(CustomerService datas) async {
    // Tampilkan dialog konfirmasi
    final bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Constants.scaffoldBackgroundColor,
        title: const Text('Delete Data'),
        content: const Text('Are you sure you want to delete this data?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    // Jika pengguna mengonfirmasi penghapusan, lanjutkan penghapusan
    if (confirmed) {
      try {
        // Memanggil metode deleteDatas untuk menghapus data dengan ID tertentu
        await DataService.deleteCustomerService(datas.idCustomerService);
        // Refresh data setelah berhasil menghapus
        setState(() {
          newcs = DataService.fetchCustomerService();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customer Service",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Constants.primaryColor),
        ),
        backgroundColor: Constants.activeMenu,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.primaryColor,
        tooltip: 'Add New Customer Service',
        onPressed: () {
          nextScreen(context, '/cs-form-screen');
        },
        child: const Icon(Icons.add,
            color: Constants.scaffoldBackgroundColor, size: 28),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/home_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              FutureBuilder<List<CustomerService>>(
                future: newcs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Constants.primaryColor,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    final data = snapshot.data!;
                    return Column(
                      children: data.map((item) {
                        return Container(
                          width: 350,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(13),
                              boxShadow: const [
                                BoxShadow(
                                    color: Constants.primaryColor,
                                    blurRadius: 10,
                                    offset: Offset(0, 5))
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const ProfileInfoWidget(
                                  image: 'assets/images/basketball.jpg',
                                  name: 'Dwi Prasetyanti',
                                  username: 'dwikprsty'),
                              const Divider(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  PopupMenuButton(
                                    color: Constants.activeMenu,
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              color: Constants.secondaryColor,
                                            ),
                                            SizedBox(width: 5),
                                            Text('Edit'),
                                          ],
                                        ),
                                        value: 'edit',
                                      ),
                                      const PopupMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Constants.secondaryColor,
                                            ),
                                            SizedBox(width: 5),
                                            Text('Delete'),
                                          ],
                                        ),
                                        value: 'delete',
                                      ),
                                    ],
                                    onSelected: (value) {
                                      if (value == 'edit') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CSFormScreen(
                                              item: item,
                                            ),
                                          ),
                                        );
                                      } else if (value == 'delete') {
                                        _confirmAndDelete(item);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              if (item.imageUrl != null)
                                Container(
                                  width: 220,
                                  margin: const EdgeInsets.only(right: 10),
                                  child: Image.network(
                                    '${Endpoints.baseURLLive}/public/${item.imageUrl!}',
                                    width: 150,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error),
                                  ),
                                ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text(
                                    'Rating : ',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) => Icon(
                                        index < item.rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: index < item.rating
                                            ? Colors.amber
                                            : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Text(' ${item.rating}/5'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Deskripsi :  ${item.description}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 36, 31, 31),
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Create at: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(item.createdAt)}',
                                ),
                              ),
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Update at: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(item.updatedAt)}',
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
