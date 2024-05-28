import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:geolocator/geolocator.dart'; // For getting the current location
import 'package:google_maps_webservice/places.dart'; // For Google Places API
import 'package:flutter_google_places/flutter_google_places.dart'; // For Google Places auto-complete
import 'database_helper.dart'; // Adjust the import according to your project structure

class CreateNewAdvertScreen extends StatefulWidget {
  const CreateNewAdvertScreen({super.key});

  @override
  _CreateNewAdvertScreenState createState() => _CreateNewAdvertScreenState();
}

class _CreateNewAdvertScreenState extends State<CreateNewAdvertScreen> {
  String _postType = 'Lost';
  String? _name;
  String? _phone;
  String? _description;
  String? _location;
  DateTime _selectedDate = DateTime.now();
  final _places = GoogleMapsPlaces(apiKey: "AIzaSyA2_xPx8g8NDjjzvt70oQuKHZKcn9azj_s");

  final _formKey = GlobalKey<FormState>();

  final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Colors.black),
    ),
    fixedSize: const Size(250, 50),
    backgroundColor: const Color(0xFFE0E0E0),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );

  final ButtonStyle saveButtonStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Colors.black),
    ),
    fixedSize: const Size(250, 50),
    backgroundColor: const Color(0xFFE0E0E0),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectPlace() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: "YOUR_API_KEY_HERE",
      mode: Mode.overlay,
      language: "en",
      components: [Component(Component.country, "us")],
    );

    if (p != null) {
      PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      setState(() {
        _location = "${p.description}, ($lat, $lng)";
      });
    }
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final advert = {
        'name': _name,
        'phone': _phone,
        'description': _description,
        'location': _location,
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'postType': _postType
      };
      DatabaseHelper.instance.addAdvert(advert).then((id) {
        if (kDebugMode) {
          print('Advert added with id: $id');
        }
        Navigator.pop(context);
      }).catchError((error) {
        if (kDebugMode) {
          print('Failed to add advert: $error');
        }
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1.0),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      labelStyle: const TextStyle(color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Advert'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ListTile(
                  title: const Text('Post Type'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Radio<String>(
                        value: 'Lost',
                        groupValue: _postType,
                        onChanged: (value) {
                          setState(() {
                            _postType = value!;
                          });
                        },
                      ),
                      const Text('Lost'),
                      Radio<String>(
                        value: 'Found',
                        groupValue: _postType,
                        onChanged: (value) {
                          setState(() {
                            _postType = value!;
                          });
                        },
                      ),
                      const Text('Found'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  decoration: _inputDecoration('Name'),
                  onSaved: (value) => _name = value,
                  validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  decoration: _inputDecoration('Phone'),
                  keyboardType: TextInputType.phone,
                  onSaved: (value) => _phone = value,
                  validator: (value) => value!.isEmpty ? 'Please enter a phone number' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  decoration: _inputDecoration('Description'),
                  maxLines: 5,
                  onSaved: (value) => _description = value,
                  validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: TextFormField(
                  decoration: _inputDecoration('Location'),
                  onSaved: (value) => _location = value,
                  validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ListTile(
                  title: Text('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () => _selectDate(context),
                ),
              ),
              Center(
                child: ElevatedButton(
                  style: saveButtonStyle,
                  onPressed: _selectPlace,
                  child: const Text('Select Location on Map'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: saveButtonStyle,
                  onPressed: _saveForm,
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
