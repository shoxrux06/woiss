class SupplierModel {
  final String supplierName;
  final String supplierPhoneNumber;
  final String supplierEmail;

  SupplierModel({
   this.supplierName ='MUSTAFA TULGAR',
   this.supplierPhoneNumber = '93 844 00 06',
   this.supplierEmail = 'woiss.uz@gmail.com',
  });

  @override
  String toString() {
    return 'SupplierModel{supplierName: $supplierName, supplierPhoneNumber: $supplierPhoneNumber, supplierEmail: $supplierEmail}';
  }
}
