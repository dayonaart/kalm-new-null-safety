class AddressPayload {
  int? country;
  int? state;
  int? city;

  AddressPayload({this.country, this.state, this.city});

  factory AddressPayload.fromJson(Map<String, int?> json) {
    return AddressPayload(
      country: json['country'],
      state: json['state'],
      city: json['city'],
    );
  }

  Map<String, int?> toJson() => {
        'country': country,
        'state': state,
        'city': city,
      };
}
