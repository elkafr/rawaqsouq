class Store {
    String mtgerId;
    String mtgerName;
    String mtgerCat;
    String mtgerAdress;
    String adsPhoto;
    int isAddToFav;

    Store({
        this.mtgerId,
        this.mtgerName,
        this.mtgerCat,
        this.mtgerAdress,
        this.adsPhoto,
        this.isAddToFav
    });

    factory Store.fromJson(Map<String, dynamic> json) => Store(
        mtgerId: json["mtger_id"],
        mtgerName: json["mtger_name"],
        mtgerCat: json["mtger_cat"],
        mtgerAdress: json["mtger_adress"],
        adsPhoto: json["ads_photo"],
        isAddToFav: json["is_add_to_fav"]
    );

    Map<String, dynamic> toJson() => {
        "mtger_id": mtgerId,
        "mtger_name": mtgerName,
        "mtger_cat": mtgerCat,
        "mtger_adress": mtgerAdress,
        "ads_photo": adsPhoto,
        "is_add_to_fav":isAddToFav
    };
}