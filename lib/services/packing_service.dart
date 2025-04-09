class PackingService {
  static List<String> generatePackingList(double temperature) {
    List<String> packingList = ["Passport", "Phone", "Charger", "Clothing"];

    if (temperature >= 25) {
      // Very warm weather
      packingList.addAll(["Sunscreen", "Swimwear", "Sunglasses", "Hat"]);
    } else if (temperature >= 15) {
      // Moderately warm weather
      packingList.addAll(["Light jacket", "T-shirt", "Shorts"]);
    } else {
      // Cold weather
      packingList.addAll(["Winter coat", "Gloves", "Hat"]);
    }

    return packingList;
  }
}
