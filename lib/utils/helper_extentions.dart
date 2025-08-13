extension ImageChannel on int {
  double toDoubleChannel(int c) {
    final r = (this >> 16) & 0xFF;
    final g = (this >> 8) & 0xFF;
    final b = this & 0xFF;
    switch (c) {
      case 0: return r.toDouble();
      case 1: return g.toDouble();
      case 2: return b.toDouble();
      default: return 0.0;
    }
  }
}