class Address {
  String? firstName;
  String? lastName;
  String? email;
  String? street;
  String? apartment;
  String? block;
  String? city;
  String? state;
  String? country;
  String? countryId;
  String? phoneNumber;
  String? zipCode;
  String? mapUrl;
  String? latitude;
  String? longitude;

  Address({this.firstName, this.lastName, this.email, this.street, this.apartment, this.block, this.city, this.state, this.country, this.phoneNumber, this.zipCode, this.mapUrl, this.latitude, this.longitude});

  Address.fromJson(Map<String, dynamic> parsedJson) {
    firstName = parsedJson['first_name'] ?? '';
    lastName = parsedJson['last_name'] ?? '';
    apartment = parsedJson['company'] ?? '';
    street = parsedJson['address_1'] ?? '';
    block = parsedJson['address_2'] ?? '';
    city = parsedJson['city'] ?? '';
    state = parsedJson['state'] ?? '';
    country = parsedJson['country'] ?? '';
    email = parsedJson['email'] ?? '';
    // final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
    // if (alphanumeric.hasMatch(firstName!)) {
    //   phoneNumber = firstName;
    // }
    phoneNumber = parsedJson['phone'] ?? '';
    zipCode = parsedJson['postcode'];
  }

  Map<String, dynamic> toJson() {
    var address = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'address_1': street ?? '',
      'address_2': block ?? '',
      'company': apartment ?? '',
      'city': city,
      'state': state,
      'country': country,
      'phone': phoneNumber,
      'postcode': zipCode,
      'mapUrl': mapUrl,
    };
    if (email != null && email!.isNotEmpty) {
      address['email'] = email;
    }
    return address;
  }

  Address.fromLocalJson(Map<String, dynamic> json) {
    try {
      firstName = json['first_name'];
      lastName = json['last_name'];
      street = json['address_1'];
      block = json['address_2'];
      apartment = json['company'];
      city = json['city'];
      state = json['state'];
      country = json['country'];
      email = json['email'];
      phoneNumber = json['phone'];
      zipCode = json['postcode'];
      mapUrl = json['mapUrl'];
    } catch (e) {
      //printLog(e.toString());
    }
  }

  bool isValid() {
    return firstName!.isNotEmpty && lastName!.isNotEmpty && email!.isNotEmpty && street!.isNotEmpty && city!.isNotEmpty && state!.isNotEmpty && country!.isNotEmpty && phoneNumber!.isNotEmpty;
  }

  Map<String, String?> toJsonEncodable() {
    return {'first_name': firstName, 'last_name': lastName, 'address_1': street ?? '', 'address_2': block ?? '', 'company': apartment ?? '', 'city': city, 'state': state, 'country': country, 'email': email, 'phone': phoneNumber, 'postcode': zipCode};
  }

  Address.fromShopifyJson(Map<String, dynamic> json) {
    try {
      firstName = json['firstName'];
      lastName = json['lastName'];
      street = json['address1'];
      block = json['address2'];
      apartment = json['company'];
      city = json['city'];
      state = json['pronvice'];
      country = json['country'];
      email = json['email'];
      phoneNumber = json['phone'];
      zipCode = json['zip'];
      mapUrl = json['mapUrl'];
    } catch (e) {
      //printLog(e.toString());
    }
  }

  Map<String, dynamic> toShopifyJson() {
    return {
      'address': {
        'province': state,
        'country': country,
        'address1': street,
        'address2': block,
        'company': apartment,
        'zip': zipCode,
        'city': city,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phoneNumber,
      }
    };
  }

  @override
  String toString() {
    var output = '';
    if (street != null) {
      output += ' $street';
    }
    if (country != null) {
      output += ' $country';
    }
    if (city != null) {
      output += ' $city';
    }

    return output.trim();
  }

  String get fullName => [firstName ?? '', lastName ?? ''].join(' ').trim();

  String get fullAddress => [
        block ?? '',
        apartment ?? '',
        street ?? '',
        city ?? '',
        state ?? '',
        zipCode ?? '',
        country ?? '',
      ].join(' ').trim();
}

class ListAddress {
  List<Address> list = [];

  List<Map<String, String?>> toJsonEncodable() {
    return list.map((item) {
      return item.toJsonEncodable();
    }).toList();
  }
}
