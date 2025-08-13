class LocationModel {
   double latitude=0;
   double longitude=0;
   String address = '';
   double radius=0; //this is radius in meters

   LocationModel.empty();

  LocationModel(this.latitude, this.longitude, this.address, {this.radius=100});
  LocationModel.fromCoordinates(String coordinates, {this.radius=100}){
    List<String> latLang = coordinates.split(',');
    if(latLang.length==2){
      latitude = double.tryParse(latLang.first.trim()) ?? 0.0;
      longitude = double.tryParse(latLang.last.trim()) ?? 0.0;
    }
  }

  bool get isNotEmpty{
    return longitude!=0.0 && latitude!=0.0&& address.isNotEmpty;
  }

  @override
  String toString() => '$longitude,$latitude, $address';

}
