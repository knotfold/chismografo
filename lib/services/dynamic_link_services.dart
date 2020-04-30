

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class xDynamicLinkServices{
  Future handleDynamicLinks() async{
    //STARTUP from dynamic link Logic

    //get init dynamic link if th app is started using the link
    final PendingDynamicLinkData data = await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);

  //into foreground from dynamic link logic
  FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLinkData) async{
    _handleDeepLink(dynamicLinkData);
  },onError: (OnLinkErrorException e) async{
    print('Dynamic link Field : ${e.message}');
  });
      }
    
      void _handleDeepLink(PendingDynamicLinkData data) {
        final Uri deeplink = data?.link;
        if(deeplink != null){
          print('1 deeeplink: $deeplink');
        }
      }
}