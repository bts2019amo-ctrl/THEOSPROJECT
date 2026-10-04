#import "IMGUI/imgui.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#include "Includes.h"
#import "menuIcon.h"
#import "Esp/Obfuscate.h"
#include "oxorany/oxorany_include.h"

// Extern hack_thread de savage.mm
extern void *hack_thread(void *);
//#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^

@interface MenuLoad ()
@property (nonatomic, strong) ImGuiDrawView *vna;
- (ImGuiDrawView *)GetImGuiView;

// Volume toggle
@property (nonatomic, assign) float  lastVolume;
@end

static MenuLoad *extraInfo;

UIButton* InvisibleMenuButton;
UIButton* VisibleMenuButton;
MenuInteraction* menuTouchView;
UITextField* hideRecordTextfield;
UIView* hideRecordView;
UIView* monitePanelView;
UIView* moniteFOVView;
ImVec4 menuColor = ImVec4(1.0f, 0.18f, 0.22f, 1.0f);
ImVec2 menuPos = ImVec2(0.0f, 0.0f);
ImVec2 menuSize = ImVec2(0.0f, 0.0f);

@interface MenuInteraction()
@end

@implementation MenuInteraction

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    // Enquanto o painel está aberto, esta camada recebe os toques e os
    // encaminha ao ImGui. Isso evita depender de coordenadas entre views
    // aninhadas (que faziam o painel aparecer sem aceitar cliques).
    return [ImGuiDrawView isMenuShowing];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([ImGuiDrawView isMenuShowing]) { [[extraInfo GetImGuiView] updateIOWithTouchEvent:event]; }
    [super touchesBegan:touches withEvent:event]; // repassa para o jogo
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([ImGuiDrawView isMenuShowing]) { [[extraInfo GetImGuiView] updateIOWithTouchEvent:event]; }
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([ImGuiDrawView isMenuShowing]) { [[extraInfo GetImGuiView] updateIOWithTouchEvent:event]; }
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([ImGuiDrawView isMenuShowing]) { [[extraInfo GetImGuiView] updateIOWithTouchEvent:event]; }
    [super touchesEnded:touches withEvent:event];
}

@end

@implementation MenuLoad

- (ImGuiDrawView*) GetImGuiView
{
    return _vna;
}

static void didFinishLaunching(CFNotificationCenterRef center,
                               void *observer,
                               CFStringRef name,
                               const void *object,
                               CFDictionaryRef info)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        extraInfo = [MenuLoad new];
        [extraInfo initTapGes];
        pthread_t hacks;
        pthread_create(&hacks, NULL, hack_thread, NULL);
    });
}

__attribute__((constructor)) static void initialize()
{
    CFNotificationCenterAddObserver(CFNotificationCenterGetLocalCenter(), NULL, &didFinishLaunching, (CFStringRef)UIApplicationDidFinishLaunchingNotification, NULL, CFNotificationSuspensionBehaviorDrop);
}

-(void)initTapGes
{
    // Obtém keyWindow compatível com iOS 13+
    UIWindow *keyWindow = nil;
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]]) {
            UIWindowScene *ws = (UIWindowScene *)scene;
            for (UIWindow *w in ws.windows) {
                if (w.isKeyWindow) { keyWindow = w; break; }
            }
        }
        if (keyWindow) break;
    }
    if (!keyWindow) keyWindow = UIApplication.sharedApplication.windows.firstObject;
    UIView* mainView = keyWindow.rootViewController.view;
    if (!mainView) mainView = keyWindow;
    hideRecordTextfield = [[UITextField alloc] init];
    hideRecordView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    hideRecordView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [hideRecordView setBackgroundColor:[UIColor clearColor]];
    [hideRecordView setUserInteractionEnabled:YES];
    hideRecordTextfield.secureTextEntry = true;
    [hideRecordView addSubview:hideRecordTextfield];
    CALayer *layer = hideRecordTextfield.layer;
    if ([layer.sublayers.firstObject.delegate isKindOfClass:[UIView class]]) {
        hideRecordView = (UIView *)layer.sublayers.firstObject.delegate;
    } else {
        hideRecordView = nil;
    }

    if (!hideRecordView) hideRecordView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    hideRecordView.frame = keyWindow.bounds;
    hideRecordView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [keyWindow addSubview:hideRecordView];
    
    if (!_vna) {
         ImGuiDrawView *vc = [[ImGuiDrawView alloc] init];
         _vna = vc;
         _vna.view.multipleTouchEnabled = YES; // Garantir multitouch no ImGui
    }
     
    [ImGuiDrawView showChange:false];
_vna.view.userInteractionEnabled = NO;
    _vna.view.frame = hideRecordView.bounds;
    _vna.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [hideRecordView addSubview:_vna.view];

    menuTouchView = [[MenuInteraction alloc] initWithFrame:mainView.bounds];
    menuTouchView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    menuTouchView.multipleTouchEnabled = YES;
    [[UIApplication sharedApplication].windows[0].rootViewController.view addSubview:menuTouchView];
    Class moniteClass = NSClassFromString(@"MonitePanelView");
    if (moniteClass) {
        CGFloat panelWidth = MIN(425.0, keyWindow.bounds.size.width - 20.0);
        monitePanelView = [[moniteClass alloc] initWithFrame:CGRectMake((keyWindow.bounds.size.width - panelWidth) * 0.5, (keyWindow.bounds.size.height - 340.0) * 0.5, panelWidth, 340.0)];
        monitePanelView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        monitePanelView.hidden = YES;
        [keyWindow addSubview:monitePanelView];
    }

    Class fovClass = NSClassFromString(@"MoniteFOVView");
    if (fovClass) {
        moniteFOVView = [[fovClass alloc] initWithFrame:keyWindow.bounds];
        moniteFOVView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        moniteFOVView.hidden = NO;
        if (monitePanelView) [keyWindow insertSubview:moniteFOVView belowSubview:monitePanelView];
        else [keyWindow addSubview:moniteFOVView];
        CADisplayLink *fovLink = [CADisplayLink displayLinkWithTarget:moniteFOVView selector:@selector(tick:)];
        [fovLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    // ── Volume button toggle ───────────────────────────────
    // Pressionar Volume Up depois Volume Down (ou vice-versa)
    // em menos de 0.6 segundos abre/fecha o menu.
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];
    [audioSession setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:nil];
    self.lastVolume      = audioSession.outputVolume;
    [audioSession addObserver:self
                   forKeyPath:@"outputVolume"
                      options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                      context:nil];

    NSData* data = [[NSData alloc] initWithBase64EncodedString:menuIcon options:0];
    (void)[UIImage imageWithData:data];

    InvisibleMenuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    InvisibleMenuButton.frame = CGRectMake(10, 10, 50, 50);
    InvisibleMenuButton.backgroundColor = [UIColor clearColor];
    InvisibleMenuButton.multipleTouchEnabled = YES;
[InvisibleMenuButton addTarget:self action:@selector(buttonDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    [InvisibleMenuButton addGestureRecognizer:tapGestureRecognizer];
    [[UIApplication sharedApplication].windows[0].rootViewController.view addSubview:InvisibleMenuButton];
    
    VisibleMenuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    VisibleMenuButton.frame = CGRectMake(10, 10, 50, 50);
    VisibleMenuButton.backgroundColor = [UIColor clearColor];
    VisibleMenuButton.layer.cornerRadius = VisibleMenuButton.frame.size.width * 0.5f;
    VisibleMenuButton.multipleTouchEnabled = YES;
    [hideRecordView addSubview:VisibleMenuButton];

    // Triple tap (3 dedos) para abrir menu
    UITapGestureRecognizer *tripleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    tripleTapGesture.numberOfTapsRequired = 3;
    tripleTapGesture.numberOfTouchesRequired = 1;
    [mainView addGestureRecognizer:tripleTapGesture];
    
    // Adicionar também na window para garantir
    UITapGestureRecognizer *tripleTapGestureWindow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    tripleTapGestureWindow.numberOfTapsRequired = 3;
    tripleTapGestureWindow.numberOfTouchesRequired = 1;
    [keyWindow addGestureRecognizer:tripleTapGestureWindow];
}


- (void)showMenu:(UITapGestureRecognizer *)tapGestureRecognizer {
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        BOOL open = ![ImGuiDrawView isMenuShowing];
        [ImGuiDrawView showChange:NO];
        _vna.view.hidden = YES;
        monitePanelView.hidden = !open;
        monitePanelView.userInteractionEnabled = open;
        menuTouchView.userInteractionEnabled = NO;
    }
}

- (void)buttonDragged:(UIButton *)button withEvent:(UIEvent *)event
{
    UITouch *touch = [[event touchesForView:button] anyObject];

    CGPoint previousLocation = [touch previousLocationInView:button];
    CGPoint location = [touch locationInView:button];
    CGFloat delta_x = location.x - previousLocation.x;
    CGFloat delta_y = location.y - previousLocation.y;

    button.center = CGPointMake(button.center.x + delta_x, button.center.y + delta_y);

    VisibleMenuButton.center = button.center;
    VisibleMenuButton.frame = button.frame;
}

// ── Volume KVO — qualquer clique em Vol+ ou Vol- abre/fecha o menu ──
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (![keyPath isEqualToString:@"outputVolume"]) return;

    float newVol = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    float oldVol = self.lastVolume;
    self.lastVolume = newVol;

    // Ignora variações mínimas (ruído do sistema)
    if (fabs(newVol - oldVol) < 0.01f) return;

    // Qualquer pressão de volume (up ou down) = toggle imediato
    dispatch_async(dispatch_get_main_queue(), ^{
        BOOL open = ![ImGuiDrawView isMenuShowing];
        [ImGuiDrawView showChange:NO];
        self->_vna.view.hidden = YES;
        monitePanelView.hidden = !open;
        monitePanelView.userInteractionEnabled = open;
        menuTouchView.userInteractionEnabled = NO;
    });
}

- (void)dealloc {
    @try {
        [[AVAudioSession sharedInstance] removeObserver:self forKeyPath:@"outputVolume"];
    } @catch (NSException *e) {}
}

@end
