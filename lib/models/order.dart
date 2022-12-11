class Order {
    String carttMtger;
    String carttNumber;
    String carttFatora;
    String carttSeller;
    String carttDate;
    String carttState;
    int carttTotlal;
    String carttTawsilDate;
    String carttTawsilTime;
    List<CarttDetail> carttDetails;

    Order({
        this.carttMtger,
        this.carttNumber,
        this.carttFatora,
        this.carttSeller,
        this.carttDate,
        this.carttState,
        this.carttTotlal,
        this.carttTawsilDate,
        this.carttTawsilTime,
        this.carttDetails,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        carttMtger: json["cartt_mtger"],
        carttNumber: json["cartt_number"],
        carttFatora: json["cartt_fatora"],
        carttSeller: json["cartt_seller"],
        carttDate: json["cartt_date"],
        carttState: json["cartt_state"],
        carttTotlal: json["cartt_totlal"],
        carttTawsilDate: json["cartt_tawsil_date"],
        carttTawsilTime: json["cartt_tawsil_time"],
        carttDetails: List<CarttDetail>.from(json["cartt_details"].map((x) => CarttDetail.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "cartt_mtger": carttMtger,
        "cartt_number": carttNumber,
        "cartt_fatora": carttFatora,
        "cartt_seller": carttSeller,
        "cartt_date": carttDate,
        "cartt_state": carttState,
        "cartt_totlal": carttTotlal,
        "cartt_tawsil_date": carttTawsilDate,
        "cartt_tawsil_time": carttTawsilTime,
        "cartt_details": List<dynamic>.from(carttDetails.map((x) => x.toJson())),
    };
}

class CarttDetail {
    String carttName;
    int carttAmount;
    int carttPrice;
    int carttAds;
    String carttPhoto;

    CarttDetail({
        this.carttName,
        this.carttAmount,
        this.carttPrice,
        this.carttPhoto,
        this.carttAds
    });

    factory CarttDetail.fromJson(Map<String, dynamic> json) => CarttDetail(
        carttName: json["cartt_name"],
        carttAmount: json["cartt_amount"],
        carttPrice: json["cartt_price"],
        carttPhoto: json["cartt_photo"],
        carttAds:json["cartt_ads"]
    );

    Map<String, dynamic> toJson() => {
        "cartt_name": carttName,
        "cartt_amount": carttAmount,
        "cartt_price": carttPrice,
        "cartt_photo" :carttPhoto,
        "cartt_ads":carttAds
    };
}
