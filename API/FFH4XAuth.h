#pragma once

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Security/Security.h>

// API de licenças documentada em "API de licenças e keys.pdf".
#define FFH4X_RECHECK_INTERVAL 300.0
#define FFH4X_LICENSE_URL @"https://api-production-182c.up.railway.app/api/license/validate"
#define FFH4X_PACKAGE_ID @"com.dts.freefiremax"
#define FFH4X_APP_VERSION_DEFAULT @"1.0.0"

static BOOL _ffh4x_validated = NO;
static BOOL _ffh4x_started = NO;
static NSTimer *_ffh4x_timer = nil;

static NSString *_ffh4x_keychain_service(void) { return @"com.ffh4x.rage.license"; }
static NSString *_ffh4x_keychain_account(void) { return @"license_key"; }
static NSString *_ffh4x_device_account(void) { return @"device_id"; }

static UIViewController *_ffh4x_root_vc(void) {
    UIWindow *keyWindow = nil;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            for (UIWindow *window in ((UIWindowScene *)scene).windows) {
                if (window.isKeyWindow) { keyWindow = window; break; }
            }
        }
        if (keyWindow) break;
    }
    if (!keyWindow) keyWindow = UIApplication.sharedApplication.windows.firstObject;
    UIViewController *root = keyWindow.rootViewController;
    while (root.presentedViewController) root = root.presentedViewController;
    return root;
}

static NSString *_ffh4x_keychain_get(NSString *account) {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: _ffh4x_keychain_service(),
        (__bridge id)kSecAttrAccount: account,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne,
        (__bridge id)kSecReturnData: @YES
    };
    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status != errSecSuccess || !result) return nil;
    NSData *data = (__bridge_transfer NSData *)result;
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

static void _ffh4x_keychain_set(NSString *value, NSString *account) {
    if (!value.length) return;
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: _ffh4x_keychain_service(),
        (__bridge id)kSecAttrAccount: account
    };
    SecItemDelete((__bridge CFDictionaryRef)query);
    NSMutableDictionary *item = [query mutableCopy];
    item[(__bridge id)kSecValueData] = [value dataUsingEncoding:NSUTF8StringEncoding];
    item[(__bridge id)kSecAttrAccessible] = (__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly;
    SecItemAdd((__bridge CFDictionaryRef)item, NULL);
}

static void _ffh4x_keychain_delete(NSString *account) {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: _ffh4x_keychain_service(),
        (__bridge id)kSecAttrAccount: account
    };
    SecItemDelete((__bridge CFDictionaryRef)query);
}

static NSString *_ffh4x_device_id(void) {
    NSString *saved = _ffh4x_keychain_get(_ffh4x_device_account());
    if (saved.length) return saved;

    NSString *deviceID = [NSUUID UUID].UUIDString.lowercaseString;
    _ffh4x_keychain_set(deviceID, _ffh4x_device_account());
    return deviceID;
}

static NSString *_ffh4x_app_version(void) {
    NSDictionary *info = NSBundle.mainBundle.infoDictionary;
    NSString *version = info[@"CFBundleShortVersionString"] ?: info[@"CFBundleVersion"];
    return version.length ? version : FFH4X_APP_VERSION_DEFAULT;
}

static BOOL FFH4X_IsValidated(void) { return _ffh4x_validated; }

static void FFH4X_Block(NSString *reason) {
    if (_ffh4x_timer) { [_ffh4x_timer invalidate]; _ffh4x_timer = nil; }
    _ffh4x_validated = NO;
    _ffh4x_keychain_delete(_ffh4x_keychain_account());

    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Licença"
            message: reason.length ? reason : @"Licença inválida."
            preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Fechar"
            style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) { exit(0); }]];
        UIViewController *root = _ffh4x_root_vc();
        if (root) [root presentViewController:alert animated:YES completion:nil];
    });
}

static void _ffh4x_do_validate(NSString *key, BOOL silent, void (^onSuccess)(void)) {
    if (!key.length) {
        if (!silent) FFH4X_Block(@"Informe uma key de licença.");
        return;
    }

    NSURL *url = [NSURL URLWithString:FFH4X_LICENSE_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15.0];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    NSDictionary *payload = @{
        @"key": key,
        @"device_id": _ffh4x_device_id(),
        @"package": FFH4X_PACKAGE_ID,
        @"app_version": _ffh4x_app_version()
    };
    NSError *serializationError = nil;
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:payload options:0 error:&serializationError];
    if (serializationError) {
        if (!silent) FFH4X_Block(@"Não foi possível preparar a validação.");
        return;
    }

    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:
      ^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error || !data) {
            if (!silent) FFH4X_Block(@"Sem conexão. Verifique sua internet.");
            return;
        }

        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        BOOL valid = [json[@"valid"] boolValue];
        if (statusCode != 200 || !valid) {
            NSString *message = json[@"message"];
            if (!message.length) message = (statusCode == 503)
                ? @"Serviço de licença temporariamente indisponível."
                : @"Licença inválida ou expirada.";
            FFH4X_Block(message);
            return;
        }

        _ffh4x_validated = YES;
        _ffh4x_keychain_set(key, _ffh4x_keychain_account());
        if (onSuccess) dispatch_async(dispatch_get_main_queue(), onSuccess);
    }] resume];
}

static void FFH4X_StartTimer(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_ffh4x_timer) [_ffh4x_timer invalidate];
        _ffh4x_timer = [NSTimer scheduledTimerWithTimeInterval:FFH4X_RECHECK_INTERVAL
            repeats:YES block:^(NSTimer *timer) {
                NSString *saved = _ffh4x_keychain_get(_ffh4x_keychain_account());
                if (!saved.length) { FFH4X_Block(@"Sessão encerrada. Informe a key novamente."); return; }
                _ffh4x_do_validate(saved, YES, nil);
            }];
    });
}

static void FFH4X_Validate(NSString *key, void (^onSuccess)(void)) {
    if (key.length < 8) { FFH4X_Block(@"A key informada é muito curta."); return; }
    _ffh4x_do_validate(key, NO, ^{
        FFH4X_StartTimer();
        if (onSuccess) onSuccess();
    });
}

static void FFH4X_AskKey(void (^onSuccess)(void)) {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Licença"
            message:@"Digite sua chave de acesso:" preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *field) {
            field.placeholder = @"SUA-KEY-DE-LICENÇA";
            field.autocorrectionType = UITextAutocorrectionTypeNo;
            field.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
            field.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
        [alert addAction:[UIAlertAction actionWithTitle:@"Validar" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction *action) {
                NSString *key = [alert.textFields.firstObject.text stringByTrimmingCharactersInSet:
                    NSCharacterSet.whitespaceAndNewlineCharacterSet];
                if (key.length < 8) { FFH4X_AskKey(onSuccess); return; }
                FFH4X_Validate(key, onSuccess);
            }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Fechar" style:UIAlertActionStyleDestructive
            handler:^(UIAlertAction *action) { exit(0); }]];
        UIViewController *root = _ffh4x_root_vc();
        if (root) [root presentViewController:alert animated:YES completion:nil];
    });
}

static void FFH4X_Start(void (^onSuccess)(void)) {
    if (_ffh4x_started) {
        if (_ffh4x_validated && onSuccess) dispatch_async(dispatch_get_main_queue(), onSuccess);
        return;
    }
    _ffh4x_started = YES;
    NSString *saved = _ffh4x_keychain_get(_ffh4x_keychain_account());
    if (saved.length) _ffh4x_do_validate(saved, NO, ^{
        FFH4X_StartTimer();
        if (onSuccess) onSuccess();
    });
    else FFH4X_AskKey(onSuccess);
}
