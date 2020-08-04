static class Resources {

  static void message (String title, String body) {
    JOptionPane.showMessageDialog(null, body, "S " + title, JOptionPane.WARNING_MESSAGE);
  }
}
