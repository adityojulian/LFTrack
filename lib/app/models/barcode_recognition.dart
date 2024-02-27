class BarcodeRecognition {
  final String _barcodeValue;
  final bool _isDuplicate;

  BarcodeRecognition(this._barcodeValue, this._isDuplicate);

  String get barcodeValue => _barcodeValue;
  bool get isDuplicate => _isDuplicate;

  @override
  String toString() {
    return 'Barcode(value: $barcodeValue, isDuplicate: $isDuplicate)';
  }
}
