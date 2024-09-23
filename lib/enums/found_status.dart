enum FoundStatus {
  Pending('Pending'),
  Approved('Approved'),
  Rejected('Rejected');

  final String value;

  const FoundStatus(this.value);
}