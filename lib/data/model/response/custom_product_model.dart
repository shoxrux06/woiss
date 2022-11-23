class CustomProductModel{
  int id;
  String nameRu;
  String nameEn;
  String nameUz;
  String nameTr;
  int price;
  String branchPrice;
  int intBranchPrice;
  String img;
  String color;
  String size;
  String categoryName;

  CustomProductModel({
    required this.id,
    required this.nameRu,
    required this.nameEn,
    required this.nameUz,
    required this.nameTr,
    required this.price,
    required this.branchPrice,
    required this.intBranchPrice,
    required this.img,
    required this.color,
    required this.size,
    required this.categoryName,
  });

  @override
  String toString() {
    return 'CustomProductModel{id: $id, nameRu: $nameRu, nameEn: $nameEn, nameUz: $nameUz, nameTr: $nameTr, price: $price, branchPrice: $branchPrice, intBranchPrice: $intBranchPrice, img: $img, color: $color, size: $size, categoryName: $categoryName}';
  }
}