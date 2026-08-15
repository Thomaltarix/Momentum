package com.thomasboue.momentum

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity, not FlutterActivity: the health package's Android 14
// permission flow needs registerForActivityResult, which requires casting to
// ComponentActivity — see health package README "Android 14" setup section.
class MainActivity : FlutterFragmentActivity()
