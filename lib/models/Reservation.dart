// ignore_for_file: file_names

class Reservation {
  String client;
  String reservationPlateNumber;
  String branch;
  String branchName;
  int price;
  int startingTime;
  double duration;

  Reservation(this.client, this.reservationPlateNumber, this.branch,
      this.branchName, this.price, this.startingTime, this.duration);
}
