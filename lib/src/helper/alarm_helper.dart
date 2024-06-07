int convertUlangiDoa(List<bool> ulangiDoa) {
  int ulangi = 0;
  for (int i = 0; i < ulangiDoa.length; i++) {
    if (ulangiDoa[i]) {
      ulangi = ulangi | (1 << i);
    }
  }
  return ulangi;
}

List<bool> getUlangiDoa(int ulangi) {
  List<bool> ulangiDoa = [];
  for (int i = 0; i < 7; i++) {
    if ((ulangi & (1 << i)) != 0) {
      ulangiDoa.add(true);
    } else {
      ulangiDoa.add(false);
    }
  }
  return ulangiDoa;
}
