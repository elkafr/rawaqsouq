class Product {
    String adsMtgerId;
    String adsMtgerName;
    String adsMtgerPrice;
    dynamic adsMtgerCat;
    String adsMtgerPhoto;
    String addCart;

    Product({
        this.adsMtgerId,
        this.adsMtgerName,
        this.adsMtgerPrice,
        this.adsMtgerCat,
        this.adsMtgerPhoto,
        this.addCart,
    });

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        adsMtgerId: json["ads_mtger_id"],
        adsMtgerName: json["ads_mtger_name"],
        adsMtgerPrice: json["ads_mtger_price"],
        adsMtgerCat: json["ads_mtger_cat"] ?? '',
        adsMtgerPhoto: json["ads_mtger_photo"],
        addCart: json["add_cart"],
    );

    Map<String, dynamic> toJson() => {
        "ads_mtger_id": adsMtgerId,
        "ads_mtger_name": adsMtgerName,
        "ads_mtger_price": adsMtgerPrice,
        "ads_mtger_cat": adsMtgerCat,
        "ads_mtger_photo": adsMtgerPhoto,
        "add_cart": addCart,
    };
}