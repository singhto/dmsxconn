class MyApi {
  double calcuclatHue(String statusTxt){
    double hueDouble ;

   switch (statusTxt) {
      case 'งดจ่ายไม่ได้':
        hueDouble = 0;
        break;
      case 'สั่งระงับการปฏิบัติงาน':
        hueDouble = 250;
        break;
      case 'สั่งระงับ (ชำระเงินระหว่างขอผ่อนผัน':
        hueDouble = 250;
        break;
      case 'รับทราบคำสั่งระงับ':
        hueDouble = 250;
        break;
      case 'ขอผ่อนผันครั้งที่ 1':
        hueDouble = 0;
        break;
      case 'ขอผ่อนผันครั้งที่ 2':
        hueDouble = 0;
        break;
      case 'ปลดสายแล้ว':
        hueDouble = 0;
        break;
      case 'ถอดมิเตอร์แล้ว':
        hueDouble = 0;
        break;
      case 'ให้ต่อสาย':
        hueDouble = 300;
        break;
      case 'ให้ต่อมิเตอร์':
        hueDouble = 3000;
        break;
      case 'ต่อสายแล้ว':
        hueDouble = 60;
        break;
      case 'ต่อมิเตอร์แล้ว':
        hueDouble = 60;
        break;

      default:
        hueDouble = 120;
        break;
    }

    return hueDouble;
  }
}