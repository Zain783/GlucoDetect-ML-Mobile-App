import 'dart:io';
import 'package:flutter/material.dart';
import 'package:glucoma_app_fyp/utils/app_size.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../repository/admin_services.dart';

class AddDoctorScreen extends StatefulWidget {
  const AddDoctorScreen({Key? key}) : super(key: key);

  @override
  _AddDoctorScreenState createState() => _AddDoctorScreenState();
}
class _AddDoctorScreenState extends State<AddDoctorScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_sharp,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Add Doctor",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    _showImageSourceDialog();
                  },
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _image != null
                        ? Image.file(
                            _image!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.blue,
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Doctor Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.blue,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the doctor name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: InputDecoration(
                    labelText: 'Contact',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    prefixIcon: const Icon(
                      Icons.phone,
                      color: Colors.blue,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    prefixIcon: const Icon(
                      Icons.note_add_outlined,
                      color: Colors.blue,
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the doctor description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the doctor email';
                    }
                    return null;
                  },
                ),
                12.h,
                Container(
                  height: 56,
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final Position position = await _determinePosition();
                      Selectedlatitude = position.longitude;
                      Selectedlongitude = position.latitude;
                      // await updateSelectedLocationText();
                      // ignore: use_build_context_synchronously
                      showMapDialog(
                          context, position.latitude, position.longitude);
                    },
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add_location,
                            color: Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            selectedLocationText,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {});
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      try {
                        await AdminServices().addDoctor(
                          name: _nameController.text,
                          contact: _contactController.text,
                          description: _descriptionController.text,
                          email: _emailController.text,
                          context: context,
                          image: _image!,
                          latitude: Selectedlatitude,
                          longitude: Selectedlongitude,
                        );
                      } catch (e) {
                        print(e.toString());
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Add Doctor'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String selectedLocationText = "Select Location";
  Future<void> updateSelectedLocationText() async {
    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        Selectedlatitude,
        Selectedlongitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark placemark = placemarks.first;
        setState(() {
          selectedLocationText = placemark.name ?? 'Location Selected';
        });
      } else {
        setState(() {
          selectedLocationText = 'Location Selected';
        });
      }
    } catch (e) {
      print('Error fetching location: $e');
      setState(() {
        selectedLocationText = 'Location Selected';
      });
    }
  }

  Future<void> _showImageSourceDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Gallery'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Camera'),
                  onTap: () {
                    _pickImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showMapDialog(BuildContext context, double latitude, double longitude) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MapDialog(latitude, longitude);
      },
    );
  }
}

double Selectedlatitude = 32.4672515;
double Selectedlongitude = 74.533288;

class MapDialog extends StatefulWidget {
  final double latitude;
  final double longitude;

  MapDialog(this.latitude, this.longitude, {Key? key}) : super(key: key);

  @override
  _MapDialogState createState() => _MapDialogState();
}

class _MapDialogState extends State<MapDialog> {
  GoogleMapController? mapController;
  LatLng? selectedLocation;

  final searchBar = const SearchBar(
    hintText: 'Search Location',
  );

  static PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Search Location'),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onMapTap(LatLng tappedPoint) {
    setState(() {
      selectedLocation = tappedPoint;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        children: [
          searchBar,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 85.0),
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                onTap: _onMapTap,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.latitude, widget.longitude),
                  zoom: 11.0,
                ),
                markers: selectedLocation != null
                    ? {
                        Marker(
                          markerId: const MarkerId('selected'),
                          position: selectedLocation!,
                        )
                      }
                    : {},
              ),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Selectedlatitude = selectedLocation!.latitude;
            Selectedlongitude = selectedLocation!.longitude;
            Navigator.pop(context);
          },
          child: const Text('Select Location'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context)
                .pop(); // Close the dialog without selecting a location
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
void showMapDialog(
    BuildContext context, double longitude, double currentLatidude) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return MapDialog(longitude, currentLatidude);
    },
  ).then((selectedLocation) {
    if (selectedLocation != null) {
      // Handle the selected location here
      print('Selected Location: $selectedLocation');
    }
  });
}