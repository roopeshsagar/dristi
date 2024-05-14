import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:digit_components/digit_components.dart';
import 'package:digit_components/widgets/atoms/digit_toaster.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/model/place_details.dart';
import 'package:http/io_client.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:pucardpg/app/data/models/pin-address-model/pin_address_model.dart';
import 'package:pucardpg/app/domain/entities/litigant_model.dart';
import 'package:pucardpg/app/presentation/widgets/back_button.dart';
import 'package:pucardpg/app/presentation/widgets/help_button.dart';
import 'package:pucardpg/config/mixin/app_mixin.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddressScreen extends StatefulWidget with AppMixin {
  UserModel userModel = UserModel();

  AddressScreen({super.key, required this.userModel});

  @override
  AddressScreenState createState() => AddressScreenState();
}

const kGoogleApiKey = 'AIzaSyAASfCFja6YxwDzEAzhHFc8B-17TNTCV0g';
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class AddressScreenState extends State<AddressScreen> {
  String pinLocationKey = 'pinLocation';
  String pinCodeKey = 'pinCode';
  String stateKey = 'state';
  String districtKey = 'district';
  String cityKey = 'city';
  String localityKey = 'locality';
  String doorNoKey = 'doorNo';
  bool isSubmitting = false;
  // List<String> state = [];
  // List<String> district = ['District'];
  // List<String> city = ['City'];

  // String stateName = '';
  // String districtName = '';
  // String cityName = '';
  // String pinCode = '';

  late Position _currentPosition;

  CameraPosition? _cameraPosition;
  late LatLng _defaultLatLng;
  late LatLng _draggedLatLng;

  // List<StatesData> statesData = [];
  // String? selectedDistrict;
  // String selectedCountryISOCode = 'IN';
  // String selectedStateISOCode = '';

  // Future<void> fetchStates(String countryISOCode) async {
  //   final response = await getStatesOfCountry(countryISOCode);
  //   setState(() {
  //     statesData =
  //         response.map((state) => StatesData.fromState(state)).toList();
  //     state = response.map((state) => state.name).toList();
  //     city = city;
  //     selectedDistrict = selectedDistrict;
  //   });
  // }
  //
  // Future<void> fetchCities(String countryISOCode, String stateISOCode) async {
  //   final cities = await getStateCities(countryISOCode, stateISOCode);
  //   setState(() {
  //     city = cities.map((city) => city.name).toList();
  //   });
  // }

  late Set<Marker> markersList;

  late GoogleMapController googleMapController;
  Completer<GoogleMapController> _googleMapController = Completer();

  // final Mode _mode = Mode.overlay;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // fetchStates(selectedCountryISOCode);
    super.initState();
    _defaultLatLng = const LatLng(17.4400802, 78.3489168);
    markersList = {(Marker(markerId: MarkerId(""), position: _defaultLatLng))};
    _cameraPosition = CameraPosition(target: _defaultLatLng, zoom: 14.0);
    // _draggedLatLng = _defaultLatLng;
    // _getCurrentLocation();
  }

  _getCurrentLocation(FormGroup form) async {
    if (widget.userModel.addressModel.longitude == null ||
        widget.userModel.addressModel.longitude == 0) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
        _draggedLatLng = LatLng(_currentPosition.latitude, _currentPosition.longitude);
      });
      await _goToSpecificPosition(form, _draggedLatLng, "", "");

      // _goToSpecificPosition(LatLng(_currentPosition.latitude, _currentPosition.longitude), "", "");
      // _getAddressFromLatLng(form, LatLng(_currentPosition.latitude, _currentPosition.longitude));
    }
  }

  Future _getAddressFromLatLng(FormGroup form, LatLng position) async {
    final response = await Dio().get(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${kGoogleApiKey}");
    PlaceDetailsList detailsList = PlaceDetailsList.fromJson(response.data);
    inspect(detailsList.results[0].addressComponents);
    extractAddressComponents(detailsList.results[0].addressComponents, form);

    setState(() {
      widget.userModel.addressModel.latitude = position.latitude;
      widget.userModel.addressModel.longitude = position.longitude;
    });

    // _goToSpecificPosition(position, "", "");
  }

  Future _goToSpecificPosition(FormGroup form, LatLng position, String description, String id) async {

    GoogleMapController mapController = await _googleMapController.future;
    markersList.clear();

    markersList.add(Marker(
        markerId: MarkerId(id),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(title: description)));

    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: position,
            zoom: 14.0)
    ));
    await _getAddressFromLatLng(form, position);
    // googleMapController.animateCamera(CameraUpdate.newLatLngZoom(
    //     LatLng(position.latitude, position.longitude), 15.0));
  }

  Future _getAddress(bool dragged, FormGroup form, LatLng position, String description, String id) async {
    if (widget.userModel.addressModel.longitude != null ||
        widget.userModel.addressModel.longitude != 0) {
      GoogleMapController mapController = await _googleMapController.future;
      markersList.clear();

      markersList.add(Marker(
          markerId: MarkerId(id),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: description)));

      if (!dragged) {
        mapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(
                target: position,
                zoom: 14.0)
        ));
      }
      if (dragged) {
        await _getAddressFromLatLng(form, position);
      }
    }
  }

  // Future<void> _fetchDistrict(String pincode) async {
  //   final url = 'https://api.postalpincode.in/pincode/$pincode';
  //   final http = IOClient(HttpClient());
  //   final response = await http.get(Uri.parse(url));
  //
  //   if (response.statusCode == 200) {
  //     final body = json.decode(response.body);
  //     final postOffice = body[0]['PostOffice'] as List<dynamic>;
  //     if (postOffice.isNotEmpty) {
  //       final firstPostOffice = postOffice[0];
  //       setState(() {
  //         selectedDistrict = firstPostOffice['District'];
  //       });
  //     }
  //   } else {
  //     // Handle error
  //     print('Failed to fetch district');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: ReactiveFormBuilder(
        form: () => buildForm(),
        builder: (context, form, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DigitBackButton(),
                        DigitHelpButton()],
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Enter Your address",
                                  style: widget.theme.text24W700()?.apply(),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                GooglePlaceAutoCompleteTextField(
                                  textEditingController: controller,
                                  googleAPIKey: kGoogleApiKey,
                                  inputDecoration: const InputDecoration(
                                    hintText: "Search for a building, street, or area",
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                  ),
                                  debounceTime: 400,
                                  countries: ["in"],
                                  isLatLngRequired: true,
                                  getPlaceDetailWithLatLng:
                                      (Prediction prediction) {
                                    displayPrediction(prediction, form);
                                    inspect(prediction);
                                    print("placeDetails" +
                                        prediction.toString() +
                                        prediction.matchedSubstrings
                                            .toString() +
                                        prediction.types.toString() +
                                        prediction.terms!
                                            .map((e) => e.value)
                                            .toString());
                                  },
                                  itemClick: (Prediction prediction) {
                                    controller.text = prediction.description!;
                                    controller.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: prediction
                                                .description!.length));
                                    FocusScope.of(context).unfocus();
                                  },
                                  boxDecoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                        0), // Border radius
                                  ),
                                  itemBuilder:
                                      (context, index, Prediction prediction) {
                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.location_on),
                                          const SizedBox(
                                            width: 7,
                                          ),
                                          Expanded(
                                              child: Text(
                                                  "${prediction.description ?? ""}"))
                                        ],
                                      ),
                                    );
                                  },
                                  seperatedBuilder: Divider(),
                                  isCrossBtnShown: true,
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  height: 220,
                                  child: GoogleMap(
                                    initialCameraPosition:
                                    _cameraPosition!,
                                    markers: markersList,
                                    mapType: MapType.normal,
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      if (!_googleMapController.isCompleted) {
                                        _googleMapController.complete(controller);
                                        _getCurrentLocation(form);
                                      }
                                      // googleMapController = controller;
                                    },
                                    onCameraIdle: () {
                                      _getAddress(true, form, _draggedLatLng, "", "");
                                    },
                                    onCameraMove: (position) {
                                      _draggedLatLng = position.target;
                                      // _getAddressFromLatLng(form, position.target);
                                    },
                                    gestureRecognizers: <Factory<
                                        OneSequenceGestureRecognizer>>{
                                      Factory<OneSequenceGestureRecognizer>(
                                            () => EagerGestureRecognizer(),
                                      ),
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFC7E0F1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.info,
                                        color: Color(0xFF3498DB),size: 12.0),
                                      const SizedBox(width: 4,),
                                      Text(
                                        'Move the pin to the desired location',
                                        style: widget.theme.text12W400()?.apply(color: widget.theme.lightGrey),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(color: Color(0xFFEAECF0), height: 1, thickness: 1,),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DigitTextFormField(
                                    padding: const EdgeInsets.only(top: 0),
                                    formControlName: pinCodeKey,
                                    label: 'Pincode',
                                    keyboardType: TextInputType.number,
                                    isRequired: true,
                                    maxLength: 6,
                                    onChanged: (value) {
                                      widget.userModel.addressModel.pincode =
                                          value.value.toString();
                                      // if (value.value.length == 6) {
                                      //   _fetchDistrict(value.value);
                                      // }
                                    },
                                    validationMessages: {
                                      'required': (_) => 'Pincode is required',
                                      'maxLength': (_) => 'Max length should be 6'
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9]")),
                                    ],
                                  ),
                                  DigitTextFormField(
                                    padding: const EdgeInsets.only(top: 0),
                                    formControlName: stateKey,
                                    label: 'State',
                                    keyboardType: TextInputType.text,
                                    isRequired: true,
                                    onChanged: (value) {
                                      widget.userModel.addressModel.state =
                                          value.value.toString();
                                      // if (value.value.length == 6) {
                                      //   _fetchDistrict(value.value);
                                      // }
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z]')),
                                    ],
                                    validationMessages: {
                                      'required': (_) => 'State is required',
                                    },
                                  ),
                                  DigitTextFormField(
                                    formControlName: districtKey,
                                    label: 'District',
                                    keyboardType: TextInputType.text,
                                    isRequired: true,
                                    onChanged: (value) {
                                      widget.userModel.addressModel.district =
                                          value.value.toString();
                                      // if (value.value.length == 6) {
                                      //   _fetchDistrict(value.value);
                                      // }
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z]')),
                                    ],
                                    validationMessages: {
                                      'required': (_) => 'District is required',
                                    },
                                  ),
                                  DigitTextFormField(
                                    formControlName: cityKey,
                                    label: 'City',
                                    keyboardType: TextInputType.text,
                                    isRequired: true,
                                    onChanged: (value) {
                                      widget.userModel.addressModel.city =
                                          value.value.toString();
                                      // if (value.value.length == 6) {
                                      //   _fetchDistrict(value.value);
                                      // }
                                    },
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[a-zA-Z]')),
                                    ],
                                    validationMessages: {
                                      'required': (_) => 'City is required',
                                    },
                                  ),
                                  // DigitReactiveDropdown<String>(
                                  //   label: 'State',
                                  //   menuItems: state,
                                  //   initialValue: stateName,
                                  //   padding: const EdgeInsets.all(0),
                                  //   isRequired: true,
                                  //   formControlName: stateKey,
                                  //   valueMapper: (value) => value.toUpperCase(),
                                  //   onChanged: (value) {
                                  //     selectedStateISOCode = statesData
                                  //         .firstWhere(
                                  //             (state) => state.name == value)
                                  //         .isoCode;
                                  //     // Call fetchCities with selected state and country ISO codes
                                  //     fetchCities(selectedCountryISOCode,
                                  //         selectedStateISOCode);
                                  //   },
                                  //   validationMessages: {
                                  //     'required': (_) => 'State is required',
                                  //   },
                                  // ),
                                  // const SizedBox(
                                  //   height: 12,
                                  // ),
                                  // DigitReactiveDropdown<String>(
                                  //   label: 'District',
                                  //   menuItems: selectedDistrict != null
                                  //       ? [selectedDistrict!]
                                  //       : ['District'],
                                  //   initialValue: districtName,
                                  //   isRequired: true,
                                  //   formControlName: districtKey,
                                  //   valueMapper: (value) => value.toUpperCase(),
                                  //   onChanged: (value) {},
                                  //   validationMessages: {
                                  //     'required': (_) => 'District is required',
                                  //   },
                                  // ),
                                  // const SizedBox(
                                  //   height: 12,
                                  // ),
                                  // DigitReactiveDropdown<String>(
                                  //   label: 'City / Town',
                                  //   menuItems: city,
                                  //   initialValue: cityName,
                                  //   isRequired: true,
                                  //   formControlName: cityKey,
                                  //   valueMapper: (value) => value.toUpperCase(),
                                  //   onChanged: (value) {},
                                  //   validationMessages: {
                                  //     'required': (_) => 'City / Town is required',
                                  //   },
                                  // ),
                                  DigitTextFormField(
                                      formControlName: localityKey,
                                      label: 'Locality / Street name / Area',
                                      isRequired: true,
                                      onChanged: (value) {
                                        widget.userModel.addressModel.street =
                                            value.value.toString();
                                      },
                                      minLength: 2,
                                      maxLength: 128,
                                      validationMessages: {
                                        'required': (_) =>
                                            'Locality / Street name / Area is required',
                                        'minLength': (_) =>
                                            'Min length should be 2',
                                        'maxLength': (_) =>
                                            'Max length should be 128'
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-Z0-9 .,\\/\\-_@#\\']"))
                                      ]),
                                  DigitTextFormField(
                                      formControlName: doorNoKey,
                                      padding: const EdgeInsets.all(0),
                                      label: 'Door number',
                                      isRequired: true,
                                      onChanged: (value) {
                                        widget.userModel.addressModel.doorNo =
                                            value.value.toString();
                                      },
                                      keyboardType: TextInputType.text,
                                      minLength: 2,
                                      maxLength: 128,
                                      validationMessages: {
                                        'required': (_) =>
                                            'Door number is required',
                                        'minLength': (_) =>
                                            'Min length should be 2',
                                        'maxLength': (_) =>
                                            'Max length should be 128'
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[a-zA-Z0-9 .,\\/\\-_@#\\']"))
                                      ]),
                                ]),
                          ),
                        ],
                      ),
                  ],
                ),
              )),
              DigitElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () {
                          FocusScope.of(context).unfocus();
                          form.markAllAsTouched();
                          if (!form.valid) return;

                          if (form.value[pinCodeKey].toString().isNotEmpty &&
                              int.parse(form.value[pinCodeKey].toString()) <
                                  100000) {
                            DigitToast.show(
                              context,
                              options: DigitToastOptions(
                                "Enter valid Pincode",
                                true,
                                widget.theme.theme(),
                              ),
                            );
                            return;
                          }
                          Navigator.pushNamed(context, '/IdentitySelectionScreen',
                              arguments: widget.userModel);
                          isSubmitting = false;
                        },
                  child: Text(
                    'Next',
                    style: widget.theme.text20W700()?.apply(
                          color: Colors.white,
                        ),
                  )),
            ],
          );
        },
      ),
    );
  }

  FormGroup buildForm() => fb.group(<String, Object>{
        pinLocationKey: FormControl<String>(value: ''),
        pinCodeKey: FormControl<String>(
            value: widget.userModel.addressModel.pincode,
            validators: [
              Validators.required,
              Validators.maxLength(6),
              Validators.number
            ]),
        stateKey: FormControl<String>(
            value: widget.userModel.addressModel.state,
            validators: [Validators.required]),
        districtKey: FormControl<String>(
            value: widget.userModel.addressModel.district,
            validators: [Validators.required]),
        cityKey: FormControl<String>(
            value: widget.userModel.addressModel.city,
            validators: [Validators.required]),
        localityKey: FormControl<String>(
            value: widget.userModel.addressModel.street,
            validators: [
              Validators.required,
              Validators.minLength(2),
              Validators.maxLength(128)
            ]),
        doorNoKey: FormControl<String>(
            value: widget.userModel.addressModel.doorNo,
            validators: [
              Validators.required,
              Validators.minLength(2),
              Validators.maxLength(128)
            ]),
      });

  Future<void> displayPrediction(Prediction p, FormGroup form) async {
    final response = await Dio().get(
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=${p.placeId}&key=${kGoogleApiKey}");
    PlaceDetails details = PlaceDetails.fromJson(response.data);
    inspect(details.result!.addressComponents);
    extractAddressComponents(details.result!.addressComponents, form);

    setState(() {
      widget.userModel.addressModel.latitude = double.parse(p.lat!);
      widget.userModel.addressModel.longitude = double.parse(p.lng!);
    });

    _getAddress(false, form, LatLng(double.parse(p.lat!), double.parse(p.lng!)), p.description!, p.placeId!);
  }

  void extractAddressComponents(List<AddressComponents>? addressComponents, FormGroup form) {
    String newStateName = '';
    String newDistrictName = '';
    String newCityName = '';
    String newPinCode = '';
    String newLocality = '';
    for (var component in addressComponents!) {
      List<String>? types = component.types;
      String? longName = component.longName;

      if (types!.contains('administrative_area_level_1')) {
        newStateName = longName!;
      } else if (types.contains('administrative_area_level_3')) {
        newDistrictName = longName!;
      } else if (types.contains('locality')) {
        newCityName = longName!;
      } else if (types.contains('postal_code')) {
        newPinCode = longName!;
      } else if (types.contains('route')) {
        newLocality = longName!;
      } else if (types.contains('neighborhood')) {
        if (newLocality.isEmpty) {
          newLocality = longName!;
        }
      } else if (types.contains('sublocality_level_3')) {
        if (newLocality.isEmpty) {
          newLocality = longName!;
        }
      } else if (types.contains('sublocality_level_2')) {
        if (newLocality.isEmpty) {
          newLocality = longName!;
        }
      } else if (types.contains('sublocality_level_1')) {
        if (newLocality.isEmpty) {
          newLocality = longName!;
        }
      } else if (types.contains('sublocality')) {
        if (newLocality.isEmpty) {
          newLocality = longName!;
        }
      }
    }
    setState(() {
      widget.userModel.addressModel.state = newStateName;
      widget.userModel.addressModel.district = newDistrictName;
      widget.userModel.addressModel.city = newCityName;
      widget.userModel.addressModel.pincode = newPinCode;
      widget.userModel.addressModel.street = newLocality;
      form.control(pinCodeKey).value = widget.userModel.addressModel.pincode;
      form.control(stateKey).value = widget.userModel.addressModel.state;
      form.control(districtKey).value = widget.userModel.addressModel.district;
      form.control(cityKey).value = widget.userModel.addressModel.city;
      form.control(localityKey).value = widget.userModel.addressModel.street;
    });
  }
}
