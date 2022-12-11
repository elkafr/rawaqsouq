class Cart {
    String title;
    String cartId;
    int cartAmount;
    int cartPrice;
    String adsMtgerPhoto;

    Cart({
        this.title,
        this.cartId,
        this.cartAmount,
        this.cartPrice,
        this.adsMtgerPhoto,
    });

    factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        title: json["title"],
        cartId: json["cart_id"],
        cartAmount: json["cart_amount"],
        cartPrice: json["cart_price"],
        adsMtgerPhoto: json["ads_mtger_photo"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "cart_id": cartId,
        "cart_amount": cartAmount,
        "cart_price": cartPrice,
        "ads_mtger_photo": adsMtgerPhoto,
    };
}
