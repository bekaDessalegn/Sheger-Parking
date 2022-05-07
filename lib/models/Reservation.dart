// ignore_for_file: file_names

class Reservation{
  String client;
  String reservationPlateNumber;
  String branch;
  int slot;
  String price;
  int startingTime;
  int duration;

  Reservation(this.client, this.reservationPlateNumber, this.branch, this.slot,
      this.price, this.startingTime, this.duration);
}