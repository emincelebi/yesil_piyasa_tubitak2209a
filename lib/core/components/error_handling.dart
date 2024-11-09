class ErrorHandling {
  static String translateErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-credential':
        return 'Kullanıcı bulunamadı. Lütfen bilgilerinizi kontrol edin.';
      case 'email-already-in-use':
        return 'Bu e-posta zaten kullanımda. Farklı bir e-posta deneyin.';
      case 'network-request-failed':
        return 'İnternet bağlantısı hatası. Lütfen bağlantınızı kontrol edin.';
      default:
        return 'Bir hata oluştu. Lütfen tekrar deneyin.';
    }
  }
}
