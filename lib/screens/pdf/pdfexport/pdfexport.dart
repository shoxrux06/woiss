import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:furniture_app/data/model/invoice.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import '../../../data/cart.dart';
import '../../../data/model/response/order_get_model.dart';

Future<Uint8List> makePdf(Invoice invoice, String languageCode) async {
  int discount = invoice.client?.discount ?? 0;
  var sum1;
  var sum2;
  var differenceSum = 0;
  if (invoice.order != null) {
    sum1 = int.tryParse(
            '${invoice.order?.orderItems.map((e) => e.quantity * e.productId.price.intBranchPrice).reduce((value, element) => value + element) ?? 0}') ??
        0;
    sum2 = (int.tryParse(
                '${invoice.order?.orderItems.map((e) => e.quantity * e.productId.price.intBranchPrice).reduce((value, element) => value + element) ?? 0}')! *
            (discount * 0.01))
        .toInt();
    differenceSum = sum1 - sum2;
  } else {
    invoice.orderItems.fold(0, (previousValue, element) {
      sum1 = (element.quantity * element.productId.price.intBranchPrice);
      print('previousValue>>>$previousValue');
      print('sum1>>>$sum1');
    });
    invoice.orderItems.fold(0, (previousValue, element) {
      sum2 = (element.quantity *
              element.productId.price.intBranchPrice *
              (discount * 0.01))
          .toInt();
      print('sum2>>>$sum2');
    });
    if (sum1 != null && sum2 != null) {
      differenceSum = sum1 - sum2;
    }
  }

  String? moneyFormat(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ' ');
      return value;
    }
  }

  print('discount >>>>****$discount');
  print('sum1 >>>>****$sum1');
  print('sum2 >>>>****$sum2');
  print('totalSum >>>>****$differenceSum');
  final loadFonts1 =
      await rootBundle.load("assets/fonts/NotoSerif/NotoSerif-Regular.ttf");
  final loadFonts2 =
      await rootBundle.load("assets/fonts/NotoSerif/NotoSerif-Bold.ttf");
  final fontBase = Font.ttf(loadFonts1);
  final fontBold = Font.ttf(loadFonts2);

  final pdf = Document(
      theme: ThemeData.withFont(
    base: fontBase,
    bold: fontBold,
  ));
  final imageLogo = MemoryImage(
      (await rootBundle.load('assets/icons/logo.png')).buffer.asUint8List());
  final instagramLogo = MemoryImage(
      (await rootBundle.load('assets/icons/instagram.png'))
          .buffer
          .asUint8List());
  final emailLogo = MemoryImage(
      (await rootBundle.load('assets/icons/aroba.png')).buffer.asUint8List());
  print('Invoice Data>>>>>>>>>>>>>>>>>$invoice');
  print('Discount>>>>>>>>>>>>>>>>>${invoice.client?.discount}');

  List<OrderItem> newOrderItems = invoice.orderItems;
  List<OrderItem> singleProductList = [];
  List<OrderItem> multipleProductList = [];

  double valyutaValue = 1;

  if (newOrderItems.length < 10) {
    for (int i = 0; i < newOrderItems.length; i++) {
      singleProductList.add(newOrderItems[i]);
    }
  } else {
    for (int i = 0; i < 10; i++) {
      singleProductList.add(newOrderItems[i]);
    }
    print('singleProductList.length>>>${singleProductList.length}');
    print('singleProductList>>>${singleProductList}');
    for (int i = 10; i < newOrderItems.length; i++) {
      multipleProductList.add(newOrderItems[i]);
    }
  }

  String valyutaName = invoice.orderItems[0].productId.price.branchPrice
      .substring(invoice.orderItems[0].productId.price.branchPrice.lastIndexOf(
          ' ', invoice.orderItems[0].productId.price.branchPrice.length));

  print('valyutaName--->$valyutaName');



  if (invoice.orderItems.isNotEmpty) {
    print('here');
    if (valyutaName.trim() == 'manat') {
      valyutaValue = 1.7;
      print('valyutaValue$valyutaValue');
    } else if (valyutaName.trim() == 'сум') {
      valyutaValue = 11000;
      print('valyutaValue$valyutaValue');
    }else if (valyutaName.trim() == 'rub') {
      valyutaValue = 0.59;
      print('valyutaValue$valyutaValue');
    }else if (valyutaName.trim() == 'tl') {
      valyutaValue = 	7.1;
      print('valyutaValue$valyutaValue');
    }
  }

  String invoiceForm = '';
  String contractForm = '';
  String clientName = '';
  String clientNumber = '';
  String clientEmail = '';
  String clientAddress = '';
  String woissCustomerRepresentative = '';
  String woissCustomerRepresentativePhone = '';
  String woissCustomerRepresentativeEmail = '';
  String propasalDate = '';
  String estimatedProductionTime = '';
  String offerNo = '';
  String hallVassariLivingArea = '';
  String picture = '';
  String model = '';
  String product = '';
  String detail = '';
  String price = '';
  String quantity = '';
  String totalPrice = '';
  String subTotalPrice = '';
  String offerPriceDetail = '';
  String totalWithoutDiscount = '';
  String subtotalDiscount = '';
  String dividerText = '';
  String discountNumber = '';
  String sum = '';
  if (languageCode == 'en') {
    contractForm = 'CONTRACT FORM:';
    invoiceForm = 'INVOICE FORM:';
    clientName = 'CLIENT NAME:';
    clientNumber = 'CLIENT NUMBER:';
    clientEmail = 'CLIENT EMAIL:';
    clientAddress = 'CLIENT ADDRESS:';
    woissCustomerRepresentative = 'WOISS CUSTOMER REPRESENTATIVE:';
    woissCustomerRepresentativePhone = 'WOISS CUSTOMER REPRESENTATIVE PHONE:';
    woissCustomerRepresentativeEmail = 'WOISS CUSTOMER REPRESENTATIVE E-MAIL:';
    propasalDate = 'PROPOSAL DATE:';
    estimatedProductionTime = 'ESTIMATED PRODUCTION TIME (WEEK):';
    offerNo = 'OFFER NO:';
    hallVassariLivingArea = 'PRODUCTS';
    picture = 'PICTURE';
    model = 'MODEL';
    product = 'PRODUCT';
    detail = 'DETAIL';
    price = 'PRICE';
    quantity = 'QUANTITY';
    totalPrice = 'TOTAL PRICE';
    subTotalPrice = 'SUB TOTAL PRICE';
    discountNumber = 'DISCOUNT:';
    sum = 'sum';
    offerPriceDetail = 'OFFER PRICE DETAIL';
    totalWithoutDiscount = 'TOTAL WITHOUT DISCOUNT (VAT EXCLUDED)';
    subtotalDiscount = 'TOTAL WITH DISCOUNT (VAT EXCLUDED)';
    dividerText =
        'In order to ensure total quality and customer satisfaction, all products are carefully inspected by WOISS before they are packaged.If the buyer does not receive the products subject to the contract on the delivery date specified above, the new delivery date is determined unilaterally by WOISS according to its own production and shipment schedule.';
  } else if (languageCode == 'ru') {
    contractForm = 'ФОРМА ДОГОВОРА:';
    invoiceForm = 'ФОРМА КОММЕРЧЕСКОГО ПРЕДЛОЖЕНИЯ:';
    clientName = 'ИМЯ КЛИЕНТА:';
    clientNumber = 'НОМЕР КЛИЕНТА:';
    clientEmail = 'ЭЛЕКТРОННАЯ ПОЧТА КЛИЕНТА:';
    clientAddress = 'АДРЕС КЛИЕНТА:';
    woissCustomerRepresentative = 'ПРЕДСТАВИТЕЛЬ ПО РАБОТЕ С КЛИЕНТАМИ WOISS:';
    woissCustomerRepresentativePhone =
        'ТЕЛЕФОН ПРЕДСТАВИТЕЛЯ ПО РАБОТЕ С КЛИЕНТАМИ WOISS:';
    woissCustomerRepresentativeEmail =
        'ЭЛЕКТРОННАЯ ПОЧТА ПРЕДСТАВИТЕЛЯ ПО РАБОТЕ С КЛИЕНТАМИ WOISS:';
    propasalDate = 'ДАТА ПРЕДЛОЖЕНИЯ:';
    estimatedProductionTime = ' ВРЕМЯ ПОСТАВКИ(НЕДЕЛЯ):';
    offerNo = 'ID ЗАКАЗА:';
    hallVassariLivingArea = 'ТОВАРЫ';
    picture = 'ФОТО';
    model = 'МОДЕЛЬ';
    product = 'ТОВАР';
    detail = 'ДЕТАЛИ';
    price = 'ЦЕНА';
    quantity = 'КОЛИЧЕСТВО';
    totalPrice = 'ИТОГОВАЯ ЦЕНА';
    subTotalPrice = 'ПРОМЕЖУТОЧНАЯ ЦЕНА';
    offerPriceDetail = 'ИНФОРМАЦИЯ О ЦЕНЕ ЗАКАЗА';
    discountNumber = 'СКИДКА:';
    totalWithoutDiscount = 'ИТОГО БЕЗ СКИДКИ (БЕЗ НДС)';
    subtotalDiscount = 'ИТОГО СО СКИДКОЙ (БЕЗ НДС)';
    sum = 'сум';
    dividerText = 'Чтобы гарантировать качество и удовлетворенность клиентов,'
        ' WOISS тщательно проверяет все продукты перед их упаковкой.'
        'Если покупатель не получает товары, являющиеся предметом договора,'
        ' в дату поставки, указанную выше, новая дата поставки определяется '
        'WOISS в одностороннем порядке в соответствии с собственным графиком производства и отгрузки.';
  } else if (languageCode == 'tr') {
    contractForm = 'SÖZLEŞME FORMU:';
    invoiceForm = 'TEKLİF FORMU';
    clientName = 'MÜŞTERİ İSMİ:';
    clientNumber = 'MÜŞTERİ TELEFON NUMARASI:';
    clientEmail = 'MÜŞTERİ e-mail:';
    clientAddress = 'MÜŞTERİ ADRESİ:';
    woissCustomerRepresentative = 'WOİSS MÜŞTERİ TEMSİLCİSİ:';
    woissCustomerRepresentativePhone = 'WOİSS MÜŞTERİ TEMSİLCİSİ TELEFON:';
    woissCustomerRepresentativeEmail = 'WOİSS MÜŞTERİ TEMSİLCİSİ e-mail:';
    propasalDate = 'TEKLİF HAZIRLANMA TARİHİ:';
    estimatedProductionTime = 'TAHMİNİ ÜRETİM SÜRESİ (HAFTA):';
    offerNo = 'TEKLİF NO:';
    hallVassariLivingArea = 'ÜRÜNLER';
    picture = 'RESİM';
    model = 'MODEL';
    product = 'ÜRÜN';
    detail = 'DETAY';
    price = 'LİSTE FİYATI';
    quantity = 'ADET';
    sum = 'so\'m';
    totalPrice = 'TOPLAM LİSTE';
    discountNumber = 'İNDİRİM:';
    subTotalPrice = 'İNDİRİMLİ TOPLAM FİYAT';
    offerPriceDetail = 'TEKLİF BEDELİ DETAYI';
    totalWithoutDiscount = 'İNDİRİMSİZ TOPLAM (KDV HARİÇ)';
    subtotalDiscount = 'TOPLAM İNDİRİMLİ (KDV HARİÇ)';
    dividerText =
        'Toplam kalite ve müşteri memnuniyetinin tesisi için tüm ürünler paketlenmeden önce WOİSS tarafından dikkatlice denetlenir.Alıcının, sözleşme konusu ürünleri yukarıda belirtilen teslim tarihinde teslim almaması halinde, yeni teslim tarihiWOİSS tarafından kendi üretim ve sevkiyat programına göre tek taraflı olarak belirlenir.';
  } else if (languageCode == 'uz') {
    contractForm = 'KONTRAKT FORMA:';
    invoiceForm = 'INVOICE FORMA:';
    clientName = 'MIJOZ ISMI:';
    clientNumber = 'MIJOZ NOMERI:';
    clientEmail = 'MIJOZ EMAILI:';
    clientAddress = 'MIJOZ ADDRESSI:';
    woissCustomerRepresentative = 'WOISS MIJOZLAR VAKILI:';
    woissCustomerRepresentativePhone = 'WOISS MIJOZLAR VAKILI NOMERI:';
    woissCustomerRepresentativeEmail = 'WOISS MIJOZLAR VAKILI e-maili:';
    propasalDate = 'TAKLIF SANA:';
    estimatedProductionTime = 'ISHLAB CHIQARISHNING TAHMINIY VAQTI (hafta):';
    offerNo = 'TAKLIF NO:';
    hallVassariLivingArea = 'MAHSULOTLAR';
    picture = 'RASM';
    model = 'MODEL';
    product = 'TOVAR';
    detail = 'DETAILS';
    price = 'NARXI';
    quantity = 'SONI';
    totalPrice = 'UMUMIY NARX';
    subTotalPrice = 'CHEGIRMALI NARX';
    offerPriceDetail = 'TAKLIF NARXI BATAFSIL';
    discountNumber = 'CHEGIRMA:';
    sum = 'so\'m';
    totalWithoutDiscount = 'JAMI CHEGIRMASIZ (QQS CHIZQANDA)';
    subtotalDiscount = 'UMUMIY CHEGIRMA (QQS CHIZQANDA)';
    dividerText =
        "Umumiy sifat va mijozlar ehtiyojini qondirish uchun barcha mahsulotlar qadoqlashdan oldin WOISS tomonidan diqqat bilan tekshiriladi.Agar xaridor shartnomada ko'rsatilgan mahsulotlarni yuqorida ko'rsatilgan etkazib berish sanasida olmasa, yangi etkazib berish sanasiU WOISS tomonidan o'zining ishlab chiqarish va jo'natish jadvaliga muvofiq bir tomonlama belgilanadi.";
  }
  var myImg;
  List<ImageProvider> images = [];
  for (int i = 0; i < invoice.orderItems.length; i++) {
    myImg = await networkImage(invoice.orderItems[i].productId.img);
    images.add(myImg);
  }
  pdf.addPage(
    Page(
      margin: const EdgeInsets.only(right: 48, left: 48, top: 24),
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          border: Border.all(color: PdfColor(0, 0, 0))),
                      child: Column(children: [
                        SizedBox(
                          height: 59,
                          width: 80,
                          child: Image(imageLogo),
                        ),
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Text(
                                  "VOİS MOBİLYA İTHALAT İHRACAT SANAYİ TİCARET LTD.ŞTİ.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 4)),
                            ),
                            SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              child: Text(
                                  'İSTANBUL FACTORY : Mecidiye Mh. Sürme Sk. No:27 Sultanbeyli – İstanbul / +90 212 561 40 04',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 4)),
                            ),
                            SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              child: Text(
                                  'BAKU STORE : EDEL Mall Center, Ahmad Racabli St. 227, Narimanov Rayonu, Baku, Azerbaijan +99412 555 96 47',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 4)),
                            ),
                            SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              child: Text(
                                  'GROZNY STORE : Krasnoflotskaya ulitsa, No:3А Grozni, Chechenskaya Respublika, Rusya',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 4)),
                            ),
                            SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              child: Text(
                                  'TASHKENT STORE : Shota Rustavelli ulitsa, No:12 Tashkent, Uzbekistan',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 4)),
                            ),
                            SizedBox(height: 4),
                            Container(
                                width: double.infinity,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 6,
                                        width: 6,
                                        child: Image(emailLogo),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                          'woiss.uz@gmail.com - www.woissmobili.com.tr - @woiss.uz',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 4)),
                                      SizedBox(width: 8),
                                      SizedBox(
                                        height: 6,
                                        width: 6,
                                        child: Image(instagramLogo),
                                      ),
                                    ])),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ]),
                    ),
                  ),
                  // SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Column(children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: PdfColor.fromInt(0xffeceff1),
                            border: Border.all(color: PdfColor(0, 0, 0))),
                        child: Text(
                          invoice.order?.status == 1
                              ? '$invoiceForm'
                              : invoice.order?.status == 2
                                  ? '$contractForm'
                                  : '',
                          style: TextStyle(
                              fontSize: 6, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Table(
                        border: TableBorder.all(color: PdfColors.black),
                        children: [
                          // TableRow(
                          //   children: [
                          //     PaddedTextForm('$invoiceForm'),
                          //   ],
                          // ),
                          TableRow(
                            children: [
                              CustomText('$clientName',
                                  style: TextStyle(fontSize: 3)),
                              CustomTextTwo('${invoice.client?.fullname}',
                                  style: TextStyle(fontSize: 3))
                            ],
                          ),
                          TableRow(
                            children: [
                              CustomText('$clientNumber',
                                  style: TextStyle(fontSize: 3)),
                              CustomTextTwo('${invoice.client?.phone}',
                                  style: TextStyle(fontSize: 3))
                            ],
                          ),
                          TableRow(
                            children: [
                              CustomTextDiscount(
                                discountNumber,
                              ),
                              CustomTextDiscountTwo('$discount %',
                                  style: TextStyle(
                                      fontSize: 3,
                                      color: PdfColor.fromInt(0xfff44336)))
                            ],
                          ),
                          TableRow(
                            children: [
                              CustomText('$clientEmail',
                                  style: TextStyle(fontSize: 3)),
                              CustomTextTwo('', style: TextStyle(fontSize: 3))
                            ],
                          ),
                          TableRow(
                            children: [
                              CustomText('$clientAddress',
                                  style: TextStyle(fontSize: 3)),
                              CustomTextTwo(
                                '${invoice.client?.address}',
                                style: TextStyle(fontSize: 3),
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              CustomText('$woissCustomerRepresentative',
                                  style: TextStyle(fontSize: 3)),
                              CustomTextTwo(invoice.supplier.supplierName,
                                  style: TextStyle(fontSize: 3))
                            ],
                          ),
                          TableRow(
                            children: [
                              CustomText('$woissCustomerRepresentativePhone',
                                  style: TextStyle(fontSize: 3)),
                              CustomTextTwo(
                                  invoice.supplier.supplierPhoneNumber,
                                  style: TextStyle(fontSize: 3))
                            ],
                          ),
                          TableRow(
                            children: [
                              CustomText('$woissCustomerRepresentativeEmail',
                                  style: TextStyle(fontSize: 3)),
                              CustomTextTwo(invoice.supplier.supplierEmail,
                                  style: TextStyle(fontSize: 3))
                            ],
                          ),
                          TableRow(
                            children: [
                              CustomText('$propasalDate',
                                  style: TextStyle(fontSize: 3)),
                              CustomTextTwo(
                                  '${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                                  style: TextStyle(fontSize: 3))
                            ],
                          ),
                          TableRow(
                            children: [
                              CustomText('$estimatedProductionTime',
                                  style: TextStyle(fontSize: 6)),
                              CustomTextTwo('10', style: TextStyle(fontSize: 6))
                            ],
                          ),
                          TableRow(
                            children: [
                              CustomText('$offerNo',
                                  style: TextStyle(fontSize: 6)),
                              CustomTextTwo(
                                  invoice.order?.status == 1
                                      ? 'INV-${invoice.order?.branch.substring(0, 1)}-${invoice.order?.orderNumber}'
                                      : invoice.order?.status == 2
                                          ? 'WOISS-${invoice.order?.branch.substring(0, 1)}-${invoice.order?.orderNumber}'
                                          : '',
                                  style: TextStyle(fontSize: 6))
                            ],
                          )
                        ],
                      ),
                    ]),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 24),
              decoration:
                  BoxDecoration(border: Border.all(color: PdfColor(0, 0, 0))),
              child: Text(
                '$dividerText',
                style: TextStyle(fontSize: 6),
                textAlign: TextAlign.center,
              ),
            ),
            Column(children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: PdfColor.fromInt(0xfffbe9e7),
                    border: Border.all(color: PdfColor(0, 0, 0))),
                child: Text(
                  '$hallVassariLivingArea',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Table(
                border: TableBorder.all(color: PdfColors.black),
                children: [
                  TableRow(
                    children: [
                      Padding(
                        child: Text(
                          'ID',
                          style: TextStyle(
                              fontSize: 5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                      Padding(
                        child: Text(
                          '$picture',
                          style: TextStyle(
                              fontSize: 5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                      Padding(
                        child: Text(
                          '$model',
                          style: TextStyle(
                              fontSize: 5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                      Padding(
                        child: Text(
                          '$product',
                          style: TextStyle(
                              fontSize: 5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                      Padding(
                        child: Text(
                          '$detail',
                          style: TextStyle(
                              fontSize: 5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                      Padding(
                        child: Text(
                          '$price',
                          style: TextStyle(
                              fontSize: 5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                      Padding(
                        child: Text(
                          '$quantity',
                          style: TextStyle(
                              fontSize: 5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                      Padding(
                        child: Text(
                          '$totalPrice',
                          style: TextStyle(
                              fontSize: 5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                      Padding(
                        child: Text(
                          '$subTotalPrice',
                          style: TextStyle(
                              fontSize: 5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                      Padding(
                        child: Text(
                          'USD',
                          style: TextStyle(
                              fontSize: 5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        padding: EdgeInsets.all(4),
                      ),
                    ],
                  ),
                  ...singleProductList.map((orderItem) {
                    int index = singleProductList.indexOf(orderItem);
                    String productName = '';
                    String productColor = '';
                    if (languageCode == 'en') {
                      productName = orderItem.productId.nameEn;
                      productColor = orderItem.productId.colorEn;
                    } else if (languageCode == 'ru') {
                      productName = orderItem.productId.nameRu;
                      productColor = orderItem.productId.colorRu;
                    } else if (languageCode == 'tr') {
                      productName = orderItem.productId.nameTr;
                      productColor = orderItem.productId.colorTr;
                    } else if (languageCode == 'uz') {
                      productName = orderItem.productId.nameUz;
                      productColor = orderItem.productId.colorUz;
                    }
                    return TableRow(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        Expanded(
                          child: PaddedText("${index + 1}"),
                          flex: 1,
                        ),
                        Expanded(
                          child: Image(images[index]),
                          flex: 2,
                        ),
                        Expanded(
                          child: CustomCategoryNameText(
                              "${orderItem.productId.categoryId.name}"),
                          flex: 2,
                        ),
                        Expanded(
                          child: PaddedText("$productName"),
                          flex: 2,
                        ),
                        Expanded(
                          child: Column(children: [
                            PaddedText("${orderItem.color}"),
                            PaddedText("${orderItem.size}"),
                          ]),
                          flex: 2,
                        ),
                        Expanded(
                          child: PaddedText(
                              "${moneyFormat(orderItem.productId.price.intBranchPrice.toString())} ${invoice.orderItems.isNotEmpty ? invoice.orderItems[0].productId.price.branchPrice.substring(invoice.orderItems[0].productId.price.branchPrice.lastIndexOf(' ', invoice.orderItems[0].productId.price.branchPrice.length)) : ''}"),
                          flex: 2,
                        ),
                        Expanded(
                          child: PaddedText("${orderItem.quantity}"),
                          flex: 2,
                        ),
                        Expanded(
                          child: PaddedText(
                              "${moneyFormat((orderItem.quantity * orderItem.productId.price.intBranchPrice).toString())} ${invoice.orderItems.isNotEmpty ? invoice.orderItems[0].productId.price.branchPrice.substring(invoice.orderItems[0].productId.price.branchPrice.lastIndexOf(' ', invoice.orderItems[0].productId.price.branchPrice.length)) : ''}"),
                          flex: 2,
                        ),
                        Expanded(
                          child: PaddedText(
                              "${'${moneyFormat((orderItem.quantity * orderItem.productId.price.intBranchPrice - (orderItem.quantity * orderItem.productId.price.intBranchPrice * (invoice.client!.discount! * 0.01)).toInt()).toString())}'} ${invoice.orderItems.isNotEmpty ? invoice.orderItems[0].productId.price.branchPrice.substring(invoice.orderItems[0].productId.price.branchPrice.lastIndexOf(' ', invoice.orderItems[0].productId.price.branchPrice.length)) : ''}"),
                          flex: 2,
                        ),
                        Expanded(
                          child: CustomCategoryNameText(
                              "${moneyFormat('${ ((orderItem.quantity * orderItem.productId.price.intBranchPrice -
                                  (orderItem.quantity * orderItem.productId.price.intBranchPrice * (invoice.client!.discount! * 0.01))).toInt() / valyutaValue).toStringAsFixed(0)}')}\$"),
                          flex: 2,
                        )
                      ],
                    );
                  }),
                ],
              ),
            ]),
            newOrderItems.length > 10
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Padding(
                          child: Text(
                            "$offerPriceDetail",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: PdfColor.fromInt(0xfff44336)),
                          ),
                          padding: EdgeInsets.only(bottom: 10, top: 20),
                        ),
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$totalWithoutDiscount",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    "$subtotalDiscount ",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                            SizedBox(width: 24),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${moneyFormat(sum1.toInt().toString()) ?? 0}  ${invoice.orderItems.isNotEmpty ? invoice.orderItems[0].productId.price.branchPrice.substring(invoice.orderItems[0].productId.price.branchPrice.lastIndexOf(' ', invoice.orderItems[0].productId.price.branchPrice.length)) : ''}",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    "${moneyFormat(differenceSum.toString()) ?? 0} ${invoice.orderItems.isNotEmpty ? invoice.orderItems[0].productId.price.branchPrice.substring(invoice.orderItems[0].productId.price.branchPrice.lastIndexOf(' ', invoice.orderItems[0].productId.price.branchPrice.length)) : ''}",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                            SizedBox(width: 24),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  border: Border.all(color: PdfColor(0, 0, 0))),
                              child: Text(
                                '${moneyFormat((differenceSum.toInt() / valyutaValue).toStringAsFixed(0))}\$',
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            )
                          ]),
                    ],
                  ),
            Container(height: 50),
          ],
        );
      },
    ),
  );
  if (newOrderItems.length > 10) {
    pdf.addPage(Page(build: (context) {
      return Container(
          child: Column(children: [
        Table(
          border: TableBorder.all(color: PdfColors.black),
          children: [
            TableRow(
              children: [
                Padding(
                  child: Text(
                    'ID',
                    style: TextStyle(fontSize: 5),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(4),
                ),
                Padding(
                  child: Text(
                    '$picture',
                    style: TextStyle(fontSize: 5),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(4),
                ),
                Padding(
                  child: Text(
                    '$model',
                    style: TextStyle(fontSize: 5),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(4),
                ),
                Padding(
                  child: Text(
                    '$product',
                    style: TextStyle(fontSize: 5),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(4),
                ),
                Padding(
                  child: Text(
                    '$detail',
                    style: TextStyle(fontSize: 5),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(4),
                ),
                Padding(
                  child: Text(
                    '$price',
                    style: TextStyle(fontSize: 5),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(4),
                ),
                Padding(
                  child: Text(
                    '$quantity',
                    style: TextStyle(fontSize: 5),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(4),
                ),
                Padding(
                  child: Text(
                    '$totalPrice',
                    style: TextStyle(fontSize: 5),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(4),
                ),
                Padding(
                  child: Text(
                    '$subTotalPrice',
                    style: TextStyle(fontSize: 5),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(4),
                ),
                Padding(
                  child: Text(
                    'USD',
                    style: TextStyle(fontSize: 5),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.all(4),
                ),
              ],
            ),
            ...multipleProductList.map((orderItem) {
              int index = multipleProductList.indexOf(orderItem);
              String productName = '';
              String productColor = '';
              if (languageCode == 'en') {
                productName = orderItem.productId.nameEn;
                productColor = orderItem.productId.colorEn;
              } else if (languageCode == 'ru') {
                productName = orderItem.productId.nameRu;
                productColor = orderItem.productId.colorRu;
              } else if (languageCode == 'tr') {
                productName = orderItem.productId.nameTr;
                productColor = orderItem.productId.colorTr;
              } else if (languageCode == 'uz') {
                productName = orderItem.productId.nameUz;
                productColor = orderItem.productId.colorUz;
              }
              return TableRow(
                verticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  Expanded(
                    child: PaddedText("${index + 11}"),
                    flex: 1,
                  ),
                  Expanded(
                    child: Image(images[index + 10]),
                    flex: 2,
                  ),
                  Expanded(
                    child: PaddedText("${orderItem.productId.categoryId.name}"),
                    flex: 2,
                  ),
                  Expanded(
                    child: PaddedText("$productName"),
                    flex: 2,
                  ),
                  Expanded(
                    child: Column(children: [
                      PaddedText("${orderItem.color}"),
                      PaddedText("${orderItem.size}"),
                    ]),
                    flex: 2,
                  ),
                  Expanded(
                    child: PaddedText(
                        "${moneyFormat(orderItem.productId.price.intBranchPrice.toString())} ${invoice.orderItems.isNotEmpty ? invoice.orderItems[0].productId.price.branchPrice.substring(invoice.orderItems[0].productId.price.branchPrice.lastIndexOf(' ', invoice.orderItems[0].productId.price.branchPrice.length)) : ''}"),
                    flex: 2,
                  ),
                  Expanded(
                    child: PaddedText("${orderItem.quantity}"),
                    flex: 2,
                  ),
                  Expanded(
                    child: PaddedText(
                        "${moneyFormat((orderItem.quantity * orderItem.productId.price.intBranchPrice).toString())} ${invoice.orderItems.isNotEmpty ? invoice.orderItems[0].productId.price.branchPrice.substring(invoice.orderItems[0].productId.price.branchPrice.lastIndexOf(' ', invoice.orderItems[0].productId.price.branchPrice.length)) : ''}"),
                    flex: 2,
                  ),
                  Expanded(
                    child: PaddedText(
                        "${'${moneyFormat((orderItem.quantity * orderItem.productId.price.intBranchPrice - (orderItem.quantity * orderItem.productId.price.intBranchPrice * (invoice.client!.discount! * 0.01)).toInt()).toString())}'} ${invoice.orderItems.isNotEmpty ? invoice.orderItems[0].productId.price.branchPrice.substring(invoice.orderItems[0].productId.price.branchPrice.lastIndexOf(' ', invoice.orderItems[0].productId.price.branchPrice.length)) : ''}"),
                    flex: 2,
                  ),
                  Expanded(
                    child: CustomCategoryNameText(
                        "${moneyFormat(((orderItem.quantity * orderItem.productId.price.intBranchPrice - (orderItem.quantity * orderItem.productId.price.intBranchPrice * (invoice.client!.discount! * 0.01))).toInt() / valyutaValue).toStringAsFixed(0))}\$"),
                    flex: 2,
                  )
                ],
              );
            }),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Padding(
                child: Text(
                  "$offerPriceDetail",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: PdfColor.fromInt(0xfff44336)),
                ),
                padding: EdgeInsets.only(bottom: 10, top: 20),
              ),
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$totalWithoutDiscount",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "$subtotalDiscount ",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ]),
                  SizedBox(width: 24),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${moneyFormat(sum1.toInt().toString())}  ${invoice.orderItems.isNotEmpty ? invoice.orderItems[0].productId.price.branchPrice.substring(invoice.orderItems[0].productId.price.branchPrice.lastIndexOf(' ', invoice.orderItems[0].productId.price.branchPrice.length)) : ''}",
                          style: TextStyle(fontSize: 10),
                        ),
                        Text(
                          "${moneyFormat(differenceSum.toInt().toString())} ${invoice.orderItems.isNotEmpty ? invoice.orderItems[0].productId.price.branchPrice.substring(invoice.orderItems[0].productId.price.branchPrice.lastIndexOf(' ', invoice.orderItems[0].productId.price.branchPrice.length)) : ''}",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ]),
                  SizedBox(width: 24),
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        border: Border.all(color: PdfColor(0, 0, 0))),
                    child: Text(
                      "${moneyFormat((differenceSum.toInt() / valyutaValue).toStringAsFixed(0))}\$",
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  )
                ]),
          ],
        ),
      ]));
    }));
  }
  return pdf.save();
}

// Widget PaddedTextForm(
//   final String text, {
//   final TextAlign align = TextAlign.left,
// }) =>
//     Padding(
//       padding: EdgeInsets.all(4),
//       child: Text(text, textAlign: align, style: TextStyle(fontSize: 8)),
//     );

Widget CustomText(
  final String text, {
  final TextAlign align = TextAlign.right,
  final TextStyle? style,
}) =>
    Padding(
      padding: EdgeInsets.all(2),
      child: Text(text, textAlign: align, style: TextStyle(fontSize: 4)),
    );

Widget CustomTextDiscount(
  final String text, {
  final TextAlign align = TextAlign.right,
  final TextStyle? style,
}) =>
    Padding(
      padding: EdgeInsets.all(2),
      child: Text(text,
          textAlign: align,
          style: TextStyle(fontSize: 4, color: PdfColor.fromInt(0xfff44336))),
    );

Widget CustomTextDiscountTwo(
  final String text, {
  final TextAlign align = TextAlign.center,
  final TextStyle? style,
}) =>
    Padding(
      padding: EdgeInsets.all(2),
      child: Text(text,
          textAlign: align,
          style: TextStyle(fontSize: 4, color: PdfColor.fromInt(0xfff44336))),
    );

Widget CustomTextTwo(
  final String text, {
  final TextAlign align = TextAlign.center,
  final TextStyle? style,
}) =>
    Padding(
      padding: EdgeInsets.all(2),
      child: Text(text,
          textAlign: align,
          style: TextStyle(
            fontSize: 4,
          )),
    );

Widget CustomCategoryNameText(
  final String text, {
  final TextAlign align = TextAlign.center,
  final TextStyle? style,
}) =>
    Padding(
      padding: EdgeInsets.all(4),
      child: Text(text,
          textAlign: align,
          style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
    );

Widget PaddedText(
  final String text, {
  final TextAlign align = TextAlign.center,
  final TextStyle? style,
}) =>
    Padding(
      padding: EdgeInsets.all(4),
      child: Text(text, textAlign: align, style: TextStyle(fontSize: 8)),
    );
