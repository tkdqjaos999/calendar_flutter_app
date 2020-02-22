import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

Logger logger = Logger();

class FirebaseProvider with ChangeNotifier {
  final FirebaseAuth fAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  FirebaseUser _user;

  String _lastFirebaseResponse = "";

  FirebaseProvider() {
    logger.d('init FirebaseProvider');
    _prepareUser();
  }

  FirebaseUser getUser() {
    return _user;
  }

  void setUser(FirebaseUser user){
    _user = user;
    notifyListeners();
  }

  _prepareUser() {
    fAuth.currentUser().then((FirebaseUser currentUser){
      setUser(currentUser);
    });
  }

  // 이메일 / 비밀번호로 Firebase에 회원가입
  Future<bool> signUpWithEmail(String email, String password) async {
    try {
      AuthResult result = await fAuth.createUserWithEmailAndPassword(email: email, password: password);
      if(result.user != null) {
        // 인증 메일 발송
        result.user.sendEmailVerification();
        // 새로운 계정 생성이 성공하였으므로 기존 계정 로그아웃
        signOut();
        return true;
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      List<String> result = e.toString().split(',');
      setLastFBMessage(result[1]);
      return false;
    }
  }

  // 이메일 / 비밀번호로 Firebase에 로그인
  Future<bool> singInWithEmail(String email, String password) async {
    try {
      var result = await fAuth.signInWithEmailAndPassword(email: email, password: password);
      if(result != null) {
        setUser(result.user);
        logger.d(getUser);
        return true;
      }
    } on Exception catch (e) {
      logger.e(e.toString());
      List<String> result = e.toString().split(',');
      setLastFBMessage(result[1]);
      return false;
    }
  }

  Future<bool> singWithGoogleAccount() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(idToken: googleAuth.idToken, accessToken: googleAuth.idToken);
      final FirebaseUser user = (await fAuth.signInWithCredential(credential)).user;
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await fAuth.currentUser();
      assert(user.uid == currentUser.uid);
      setUser(user);
      return true;
    } on Exception catch (e) {
      logger.e(e.toString());
      List<String> result = e.toString().split(',');
      setLastFBMessage(result[1]);
      return false;
    }
  }

  // Firebase로부터 로그아웃
  signOut() async {
    await fAuth.signOut();
    setUser(null);
  }

  // 사용자에게 비밀번호 재설정 메일을 영어로 전송 시도
  sendPasswordResetEmailByEnglish() async {
    await fAuth.setLanguageCode('en');
    sendPasswordResetEmail();
  }
  
  // 사용자에게 비밀번호 재설정 메일을 한국어로 전송 시도
  sendPasswordResetEmailByKorean() async {
    await fAuth.setLanguageCode('ko');
    sendPasswordResetEmail();
  }

  // 사용자에게 비밀번호 재설정 메일을 전송
  sendPasswordResetEmail() async {
    fAuth.sendPasswordResetEmail(email: getUser().email);
  }
  
  // Firebase로부터 회원 탈퇴
  withdrawalAccount() async {
    await getUser().delete();
    setUser(null);
  }

  // Firebase로부터 수신한 메시지 설정
  setLastFBMessage(String msg) {
    _lastFirebaseResponse = msg;
  }

  // Firebase로부터 수신한 메시지를 반환하고 삭제
  getLstFBMessage() {
    String returnValue = _lastFirebaseResponse;
    _lastFirebaseResponse = null;
    return returnValue;
  }
}