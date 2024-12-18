class DailyReport {
  double totalSales;
  int productSold;
  int receiptOpen;

  DailyReport({this.totalSales = 0, this.productSold = 0, this.receiptOpen = 0});

  void addReport({required double total, required int product, required int receipt}) {
    totalSales += total;
    productSold += product;
    receipt += receipt;
  }
}
