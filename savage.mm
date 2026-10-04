#import "Esp/ImGuiDrawView.h"
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#import <Foundation/Foundation.h>
#define ICON_FA_COG u8"\uf013"
#define ICON_FA_EXTRA u8"\uf067"
#define ICON_FA_EXCLAMATION_TRIANGLE "\xef\x81\xb1"
#define ICON_FA_INFO_CIRCLE "\xef\x81\x9a"
#define ICON_FA_BARS "\xef\x83\x89"
#define ICON_FA_COMMENT "\xef\x81\xb5"
#include <iostream>
#include <UIKit/UIKit.h>
#include <vector>
#include "iconcpp.h"
#import "pthread.h"
#include <array>
#include <cmath>
#include <deque>
#include <fstream>
#include <algorithm>
#include <string>
#include <sstream>
#include <cstring>
#include <cstdlib>
#include <cstdio>
#include <cstdint>
#include <cerrno>
#include <cctype>
#import "JRMemory.framework/Headers/MemScan.h"
#import "Esp/CaptainHook.h"
#import "Esp/ImGuiDrawView.h"
#import "IMGUI/imgui.h"
#import "IMGUI/imgui_internal.h"
#import "IMGUI/imgui_impl_metal.h"
#import "IMGUI/zzz.h"
#include "oxorany/oxorany_include.h"
#include "AppLanguage.hpp"
#import "Helper/Mem.h"
#include "font.h"
#import "Esp/Includes.h"
#import "Helper/Vector3.h"
#import "Helper/Vector2.h"
#import "Helper/Quaternion.h"
#import "Helper/Monostring.h"
#import <Foundation/Foundation.h>
#include "Helper/font.h"
#include "Helper/data.h"
#include "ban.cpp"
#include "Config.h"

ImFont* verdana_smol;
ImFont* pixel_big = {};
ImFont* pixel_smol = {};
#include "Helper/Obfuscate.h"
#import "Helper/Hooks.h"
#import "IMGUI/zzz.h"
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <unistd.h>
#include <string.h>
#include "hook/hook.h"
ImVec4 userColor = ImVec4(1.0f, 0.0f, 0.0f, 1.0f);
ImVec4 espv = ImVec4(0.0f, 1.0f, 0.0f, 1.0f);
ImVec4 espi = ImVec4(1.0f, 0.0f, 0.0f, 1.0f);
ImVec4 fovColor = ImVec4(1.0f, 0.0f, 0.0f, 1.0f);
ImVec4 nameColor = ImVec4(1.0f, 1.0f, 1.0f, 1.0f);
ImVec4 distanceColor = ImVec4(1.0f, 1.0f, 1.0f, 1.0f);
#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^
#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale
#define UIColorFromHex(hexColor) [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1.0]
UIWindow *mainWindow;
UIButton *menuView;
// Ghost Mode Variables


@interface ImGuiDrawView () <MTKViewDelegate>
@property (nonatomic, strong) id <MTLDevice> device;
@property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
@property (nonatomic, strong) UIButton *ghostButtonView;
@property (nonatomic, strong) UISwitch *ghostSwitch;
@end

extern bool SpeeeX2Enabled;
extern bool NoRecoilEnabled;
extern bool FastReloadEnabled;
extern bool BypassEnabled;
extern bool fakeLagEnabled;

@interface MoniteActionButton : UIButton
@property(nonatomic,copy) void (^moniteAction)(void);
@end
@implementation MoniteActionButton
- (void)touchUpInside:(id)sender { if (self.moniteAction) self.moniteAction(); }
- (instancetype)initWithFrame:(CGRect)frame { if ((self=[super initWithFrame:frame])) [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside]; return self; }
@end

@interface MonitePanelView : UIView
@end
@implementation MonitePanelView {
    UIView *_sidebar, *_content, *_header;
    NSInteger _tab;
    UIColor *_accent;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if ((self=[super initWithFrame:frame])) { _accent=[UIColor colorWithRed:.8 green:.5 blue:1 alpha:1]; [self buildShell]; }
    return self;
}
- (void)applyCut:(UIView *)v size:(CGFloat)c {
    v.clipsToBounds=YES;
    UIBezierPath *p=[UIBezierPath bezierPath]; CGFloat w=v.bounds.size.width,h=v.bounds.size.height;
    [p moveToPoint:CGPointMake(c,0)]; [p addLineToPoint:CGPointMake(w,0)]; [p addLineToPoint:CGPointMake(w,h-c)]; [p addLineToPoint:CGPointMake(w-c,h)]; [p addLineToPoint:CGPointMake(0,h)]; [p addLineToPoint:CGPointMake(0,c)]; [p closePath];
    CAShapeLayer *m=[CAShapeLayer layer]; m.path=p.CGPath; v.layer.mask=m;
}
- (UILabel *)label:(NSString *)text frame:(CGRect)f size:(CGFloat)size color:(UIColor *)color {
    UILabel *l=[[UILabel alloc] initWithFrame:f]; l.text=text; l.font=[UIFont systemFontOfSize:size weight:UIFontWeightRegular]; l.textColor=color; l.numberOfLines=1; return l;
}
- (void)buildShell {
    self.backgroundColor=[UIColor colorWithRed:11.0/255 green:14.0/255 blue:21.0/255 alpha:1];
    self.layer.borderColor=[UIColor colorWithRed:26.0/255 green:29.0/255 blue:36.0/255 alpha:1].CGColor; self.layer.borderWidth=1;
    [self applyCut:self size:16];
    _sidebar=[[UIView alloc] initWithFrame:CGRectMake(0,0,113,self.bounds.size.height)]; _sidebar.backgroundColor=self.backgroundColor; [self addSubview:_sidebar];
    _content=[[UIView alloc] initWithFrame:CGRectMake(113,0,self.bounds.size.width-113,self.bounds.size.height)]; _content.backgroundColor=self.backgroundColor; [self addSubview:_content];
    UIView *line=[[UIView alloc] initWithFrame:CGRectMake(112,0,1,self.bounds.size.height)]; line.backgroundColor=[UIColor colorWithRed:26.0/255 green:29.0/255 blue:36.0/255 alpha:1]; [self addSubview:line];
    NSArray *names=@[@"AIMBOT",@"VISUALS",@"WEAPON",@"MISC",@"SETTINGS",@"ACCOUNT",@"VERSION"];
    for (NSInteger i=0;i<names.count;i++) {
        MoniteActionButton *b=[[MoniteActionButton alloc] initWithFrame:CGRectMake(6,6+i*44,101,40)]; b.tag=7000+i; b.titleLabel.numberOfLines=2; b.titleLabel.textAlignment=NSTextAlignmentCenter; [b setTitle:names[i] forState:UIControlStateNormal]; b.titleLabel.font=[UIFont systemFontOfSize:9 weight:UIFontWeightSemibold]; b.moniteAction=^{ self->_tab=i; [self rebuild]; }; [_sidebar addSubview:b];
    }
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(drag:)]; [_header addGestureRecognizer:pan];
    [self rebuild];
}
- (void)drag:(UIPanGestureRecognizer *)g { CGPoint d=[g translationInView:self.superview]; self.center=CGPointMake(self.center.x+d.x,self.center.y+d.y); [g setTranslation:CGPointZero inView:self.superview]; }
- (void)clearContent { for (UIView *v in _content.subviews) [v removeFromSuperview]; }
- (void)rebuild {
    [self clearContent];
    NSArray *titles=@[@"AIMBOT",@"VISUALS",@"WEAPON",@"MISC",@"SETTINGS",@"ACCOUNT",@"VERSION"];
    NSString *title=titles[MIN(_tab,titles.count-1)];
    UIView *head=[[UIView alloc] initWithFrame:CGRectMake(14,12,_content.bounds.size.width-28,40)]; head.backgroundColor=[UIColor colorWithRed:6.0/255 green:9.0/255 blue:14.0/255 alpha:1]; [_content addSubview:head]; [self applyCut:head size:8];
    UILabel *t=[self label:title frame:CGRectMake(14,0,head.bounds.size.width-28,40) size:13 color:_accent]; [head addSubview:t];
    UIView *body=[[UIView alloc] initWithFrame:CGRectMake(0,64,_content.bounds.size.width,_content.bounds.size.height-64)]; [_content addSubview:body];
    if (_tab==0) [self buildAim:body]; else if (_tab==1) [self buildVisual:body]; else if (_tab==2) [self buildWeapon:body]; else if (_tab==3) [self buildMisc:body]; else if (_tab==4) [self buildSettings:body]; else if (_tab==5) [self buildAccount:body]; else [self buildVersion:body];
    for (NSInteger i=0;i<7;i++) { UIButton *b=(UIButton *)[_sidebar viewWithTag:7000+i]; b.backgroundColor=(i==_tab)?[UIColor colorWithRed:25.0/255 green:32.0/255 blue:40.0/255 alpha:1]:UIColor.clearColor; b.layer.borderWidth=(i==_tab)?2:0; b.layer.borderColor=_accent.CGColor; }
}
- (void)addCheck:(UIView *)parent y:(CGFloat *)y title:(NSString *)title ref:(bool *)ref {
    UIView *row=[[UIView alloc] initWithFrame:CGRectMake(14,*y,parent.bounds.size.width-28,30)]; [parent addSubview:row];
    MoniteActionButton *box=[[MoniteActionButton alloc] initWithFrame:CGRectMake(0,3,22,22)]; box.layer.borderWidth=1; box.layer.borderColor=[UIColor colorWithRed:60.0/255 green:65.0/255 blue:75.0/255 alpha:1].CGColor; box.moniteAction=^{ *ref=!*ref; [self refreshCheck:box ref:ref]; }; [row addSubview:box];
    [row addSubview:[self label:title frame:CGRectMake(34,0,row.bounds.size.width-34,30) size:13 color:[UIColor colorWithWhite:.78 alpha:1]]]; [self refreshCheck:box ref:ref]; *y+=34;
}
- (void)refreshCheck:(UIView *)box ref:(bool *)ref { box.backgroundColor=*ref?_accent:[UIColor colorWithRed:25.0/255 green:32.0/255 blue:40.0/255 alpha:1]; [box.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; if (*ref) { UILabel *c=[self label:@"✓" frame:box.bounds size:16 color:UIColor.whiteColor]; c.textAlignment=NSTextAlignmentCenter; [box addSubview:c]; } }
- (void)addSlider:(UIView *)parent y:(CGFloat *)y title:(NSString *)title ref:(float *)ref min:(float)min max:(float)max {
    UILabel *l=[self label:[NSString stringWithFormat:@"%@ %.1f",title,*ref] frame:CGRectMake(14,*y,parent.bounds.size.width-28,20) size:12 color:[UIColor colorWithWhite:.72 alpha:1]]; [parent addSubview:l]; *y+=20;
    UISlider *sl=[[UISlider alloc] initWithFrame:CGRectMake(14,*y,parent.bounds.size.width-28,24)]; sl.minimumValue=min; sl.maximumValue=max; sl.value=*ref; sl.minimumTrackTintColor=_accent; sl.maximumTrackTintColor=[UIColor colorWithRed:25.0/255 green:32.0/255 blue:40.0/255 alpha:1]; sl.tag=(NSInteger)ref; [sl addTarget:self action:@selector(slider:) forControlEvents:UIControlEventValueChanged]; [parent addSubview:sl]; *y+=38;
}
- (void)slider:(UISlider *)s { float *p=(float *)s.tag; if (p) *p=s.value; }
- (void)addLine:(UIView *)v y:(CGFloat)y { UIView *l=[[UIView alloc] initWithFrame:CGRectMake(14,y,v.bounds.size.width-28,1)]; l.backgroundColor=[UIColor colorWithRed:26.0/255 green:29.0/255 blue:36.0/255 alpha:1]; [v addSubview:l]; }
- (void)buildAim:(UIView *)v { CGFloat y=4; [self addCheck:v y:&y title:@"Aimbot" ref:&Vars.Aimbot]; [self addCheck:v y:&y title:@"Show FOV" ref:&Vars.isAimFov]; [self addCheck:v y:&y title:@"Ignore Knocked" ref:&Vars.IgnoreKnocked]; [self addCheck:v y:&y title:@"Only Visible" ref:&Vars.VisibleCheck]; [self addLine:v y:y+2]; y+=12; [self addSlider:v y:&y title:@"FOV" ref:&Vars.AimFov min:0 max:360]; }
- (void)buildVisual:(UIView *)v { CGFloat y=4; [self addCheck:v y:&y title:@"ESP Enable" ref:&Vars.Enable]; [self addLine:v y:y+2]; y+=12; [self addCheck:v y:&y title:@"ESP Lines" ref:&Vars.lines]; [self addCheck:v y:&y title:@"ESP Distance" ref:&Vars.Distance]; [self addCheck:v y:&y title:@"ESP Boxes" ref:&Vars.Box]; [self addCheck:v y:&y title:@"ESP Enemies" ref:&Vars.counts]; [self addCheck:v y:&y title:@"ESP Name" ref:&Vars.Name]; [self addCheck:v y:&y title:@"ESP Health" ref:&Vars.Health]; [self addCheck:v y:&y title:@"ESP Skeleton" ref:&Vars.skeleton]; }
- (void)buildMisc:(UIView *)v { CGFloat y=4; [self addCheck:v y:&y title:@"AimKill" ref:&SpeeeX2Enabled]; [self addCheck:v y:&y title:@"No Recoil" ref:&NoRecoilEnabled]; [self addCheck:v y:&y title:@"Fly Player" ref:&Vars.UpPlayerOne]; [self addCheck:v y:&y title:@"Ghost Hack" ref:&Vars.ShowGhostButton]; }
- (void)buildWeapon:(UIView *)v { CGFloat y=4; [self addCheck:v y:&y title:@"No Recoil" ref:&NoRecoilEnabled]; [self addCheck:v y:&y title:@"Fast Reload" ref:&FastReloadEnabled]; [self addCheck:v y:&y title:@"AimKill" ref:&SpeeeX2Enabled]; }
- (void)buildSettings:(UIView *)v { CGFloat y=4; [self addCheck:v y:&y title:@"Bypass" ref:&BypassEnabled]; [self addLine:v y:y+8]; y+=20; [v addSubview:[self label:@"Interface preferences" frame:CGRectMake(14,y,v.bounds.size.width-28,24) size:12 color:[UIColor colorWithWhite:.6 alpha:1]]]; }
- (void)buildAccount:(UIView *)v { [v addSubview:[self label:@"ACCOUNT" frame:CGRectMake(14,4,v.bounds.size.width-28,26) size:14 color:_accent]]; [v addSubview:[self label:@"License: EXTERNAL" frame:CGRectMake(14,38,v.bounds.size.width-28,24) size:13 color:[UIColor colorWithWhite:.78 alpha:1]]]; [v addSubview:[self label:@"Client authorized" frame:CGRectMake(14,70,v.bounds.size.width-28,24) size:13 color:[UIColor colorWithRed:.3 green:1 blue:.55 alpha:1]]]; }
- (void)buildVersion:(UIView *)v { [v addSubview:[self label:@"MONITE PANEL" frame:CGRectMake(14,4,v.bounds.size.width-28,26) size:14 color:_accent]]; [v addSubview:[self label:@"Visual layout extracted from the reference menu" frame:CGRectMake(14,38,v.bounds.size.width-28,45) size:12 color:[UIColor colorWithWhite:.7 alpha:1]]]; [v addSubview:[self label:@"Build 1.0.0" frame:CGRectMake(14,92,v.bounds.size.width-28,24) size:12 color:[UIColor colorWithWhite:.55 alpha:1]]]; }
@end

@implementation ImGuiDrawView
ImFont *_espFont;
ImFont* verdanab;
ImFont* icons;
ImFont* interb;
ImFont* Urbanist;

static bool MenDeal = true;
extern ImVec2 menuPos;
extern ImVec2 menuSize;
BOOL hasGhostBeenDrawn = NO;
bool fakeLagEnabled = false;
bool FastReloadEnabled = true;
bool SpeeeX2Enabled = false;
bool NoRecoilEnabled = false;
bool WallGlowEnabled = false;
bool WallFlyEnabled = false;
bool WallHackEnabled = false;
bool ScopeEnabled = false;
bool BypassEnabled = true;
bool istelekill = false;
bool isfly = false;
bool antiban(void *instance) {
    return false;
}
bool func_ghost = false;

int FUNC_GHOST(void *instance) {
    return 31278;
}
- (void)ghostModeUI {
    if (self.ghostButtonView) return;

    self.ghostButtonView = [[UIButton alloc] initWithFrame:CGRectMake(305, 330, 58, 54)];
    self.ghostButtonView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.ghostButtonView.layer.cornerRadius = 13;
    self.ghostButtonView.clipsToBounds = YES;
    self.ghostButtonView.layer.shadowOpacity = 0;
    self.ghostButtonView.layer.shadowColor = [UIColor clearColor].CGColor;
    self.ghostButtonView.layer.shadowRadius = 0;
    self.ghostButtonView.alpha = 1.0f;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 58, 20)];
    label.text = @"Ghost";
    label.font = [UIFont fontWithName:@"CourierNewPS-BoldMT" size:11];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [self.ghostButtonView addSubview:label];

    self.ghostSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(3.5, 20, 51, 31)];
    self.ghostSwitch.onTintColor = [UIColor purpleColor];
    self.ghostSwitch.thumbTintColor = [UIColor whiteColor];
    self.ghostSwitch.backgroundColor = [UIColor clearColor];
    [self.ghostSwitch addTarget:self action:@selector(ghostSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    [self.ghostButtonView addSubview:self.ghostSwitch];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGhostDrag:)];
    [self.ghostButtonView addGestureRecognizer:panGesture];

    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    [mainWindow addSubview:self.ghostButtonView];
}

- (void)ghostSwitchChanged:(UISwitch *)sender {
    Vars.EnableGhost = sender.on;
    static bool ghostState = false;
    void* ghostMain = (void*)getRealOffset(ENCRYPTOFFSET("0x105C0DC8C"));    // main ghost effect

    if (sender.on && !ghostState) {
        hook((void*[]){ ghostMain },
             (void*[]){ (void*)FUNC_GHOST },
             1);
        func_ghost = true;
        ghostState = true;
    } else if (!sender.on && ghostState) {
         Unhook(ghostMain);
           func_ghost = false;
        ghostState = false;
    }
}

- (void)handleGhostDrag:(UIPanGestureRecognizer *)gesture {
    UIView *draggedView = gesture.view;
    CGPoint translation = [gesture translationInView:draggedView.superview];
    CGPoint newCenter = CGPointMake(draggedView.center.x + translation.x, draggedView.center.y + translation.y);
    draggedView.center = newCenter;
    [gesture setTranslation:CGPointZero inView:draggedView.superview];
}

- (void)toggleSpeedX2:(BOOL)enable {
    static dispatch_once_t onceToken;
    static vector<void*> results;
    
    JRMemoryEngine *engine = new JRMemoryEngine(mach_task_self());
    AddrRange range = {0x100000000, 0x200000000};
    
    if (enable) {
        dispatch_once(&onceToken, ^{
            uint64_t search = 4397530849764387586;
            engine->JRScanMemory(range, &search, JR_Search_Type_ULong);
            results = engine->getAllResults();
        });
        
        uint64_t modify = 4366458311853765201;
        for(int i = 0; i < results.size(); i++) {
            engine->JRWriteMemory((unsigned long long)(results[i]), &modify, JR_Search_Type_ULong);
        }
    } else {
        uint64_t modify = 4397530849764387586; // Original value
        for(int i = 0; i < results.size(); i++) {
            engine->JRWriteMemory((unsigned long long)(results[i]), &modify, JR_Search_Type_ULong);
        }
        onceToken = 0;
        results.clear();
    }
    delete engine;
}

- (void)toggleNoRecoil:(BOOL)enable {
    static dispatch_once_t onceToken;
    static std::vector<void*> results; 

    JRMemoryEngine* engine = new JRMemoryEngine(mach_task_self());
    AddrRange range = { 0x100000000, 0x200000000 }; 

    if (enable) {
        dispatch_once(&onceToken, ^{
            uint64_t search = 1016018816; 
            engine->result->resultBuffer.clear();
            engine->result->count = 0;
            engine->JRScanMemory(range, &search, JR_Search_Type_ULong);
            results = engine->getAllResults();
        });

        uint64_t modify = 0; 
        for (size_t i = 0; i < results.size(); i++) {
            engine->JRWriteMemory((unsigned long long)(results[i]), &modify, JR_Search_Type_ULong);
        }
    } else {
        uint64_t modify = 1016018816; 
        for (size_t i = 0; i < results.size(); i++) {
            engine->JRWriteMemory((unsigned long long)(results[i]), &modify, JR_Search_Type_ULong);
        }
        onceToken = 0; 
        results.clear();
    }

    delete engine;
}

- (void)toggleWallGlow:(BOOL)enable {
    static dispatch_once_t onceToken;
    static vector<void*> results;
    
    JRMemoryEngine *engine = new JRMemoryEngine(mach_task_self());
    AddrRange range = {0x100000000, 0x160000000};
    
    if (enable) {
        dispatch_once(&onceToken, ^{
            float search = 1.22f;
            engine->JRScanMemory(range, &search, JR_Search_Type_Float);
            results = engine->getAllResults();
        });

        
        float modify = 965.0f;
        for(int i = 0; i < results.size(); i++) {
            engine->JRWriteMemory((unsigned long long)(results[i]), &modify, JR_Search_Type_Float);
        }
    } else {
        float modify = 1.22f;
        for(int i = 0; i < results.size(); i++) {
            engine->JRWriteMemory((unsigned long long)(results[i]), &modify, JR_Search_Type_Float);
        }
        onceToken = 0;
        results.clear();
    }
    delete engine;
}



- (void)toggleWallFly:(BOOL)enable {
    static dispatch_once_t onceToken;
    static vector<void*> results;
    
    JRMemoryEngine *engine = new JRMemoryEngine(mach_task_self());
    AddrRange range = {0x100000000, 0x160000000};
    
    if (enable) {
        dispatch_once(&onceToken, ^{
            float search = 1.5f;
            engine->JRScanMemory(range, &search, JR_Search_Type_Float);
            results = engine->getAllResults();
        });
        
        float modify = 900.0f;
        for(int i = 0; i < results.size(); i++) {
            engine->JRWriteMemory((unsigned long long)(results[i]), &modify, JR_Search_Type_Float);
        }
    } else {
        float modify = 1.5f;
        for(int i = 0; i < results.size(); i++) {
            engine->JRWriteMemory((unsigned long long)(results[i]), &modify, JR_Search_Type_Float);
        }
        onceToken = 0;
        results.clear();
    }
    delete engine;
}

- (void)toggleWallHack:(BOOL)enable {
    static dispatch_once_t onceToken;
    static vector<void*> results;
    
    JRMemoryEngine *engine = new JRMemoryEngine(mach_task_self());
    AddrRange range = {0x100000000, 0x160000000};
    
    if (enable) {
        dispatch_once(&onceToken, ^{
            float search = 2;
            engine->JRScanMemory(range, &search, JR_Search_Type_Float);
            float search1 = 0.10000000149;
            engine->JRNearBySearch(0x20, &search1, JR_Search_Type_Float);
            float search2 = 3;
            engine->JRScanMemory(range, &search2, JR_Search_Type_Float);
            float search3 = 4.2038954e-45;
            engine->JRScanMemory(range, &search3, JR_Search_Type_Float);
            float search4 = 4.2038954e-45;
            engine->JRNearBySearch(0x20, &search4, JR_Search_Type_Float);
            results = engine->getAllResults();
        });
        
        float modify = -99;
        float modify1 = -1;
        float modify2 = -999;
        float modify3 = 1.3998972e-42;
        float modify4 = 1.3998972e-42;
        for(int i = 0; i < results.size(); i++) {
            engine->JRWriteMemory((unsigned long long)(results[i]), &modify, JR_Search_Type_Float);
        }
    } else {
        // Note: Original values not provided in the original code
        // You would need to restore the original values here
        onceToken = 0;
        results.clear();
    }
    delete engine;
}

- (void)toggleScope:(BOOL)enable {
    static dispatch_once_t onceToken;
    static vector<void*> results;
    
    JRMemoryEngine *engine = new JRMemoryEngine(mach_task_self());
    AddrRange range = {0x100000000, 0x160000000};
    
    if (enable) {
        dispatch_once(&onceToken, ^{
            float search = 0.03f;
            engine->JRScanMemory(range, &search, JR_Search_Type_Float);
            results = engine->getAllResults();
        });
        
        float modify = 10.0f;
        for(int i = 0; i < results.size(); i++) {
            engine->JRWriteMemory((unsigned long long)(results[i]), &modify, JR_Search_Type_Float);
        }
    } else {
        float modify = 0.03f; // Original value
        for(int i = 0; i < results.size(); i++) {
            engine->JRWriteMemory((unsigned long long)(results[i]), &modify, JR_Search_Type_Float);
        }
        onceToken = 0;
        results.clear();
    }
    delete engine;
}

- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];

    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];

    if (!self.device) abort();

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;
   ImGuiStyle& style = ImGui::GetStyle();

style.Colors[ImGuiCol_Text] = ImVec4(1,1,1,1);
style.Colors[ImGuiCol_TextDisabled] = ImVec4(0.60f,0.60f,0.60f,1);
ImVec4 moniteBg=ImVec4(11.0f/255,14.0f/255,21.0f/255,1), moniteFrame=ImVec4(25.0f/255,32.0f/255,40.0f/255,1), moniteAccent=ImVec4(0.8f,0.5f,1,1);
style.Colors[ImGuiCol_WindowBg]=moniteBg; style.Colors[ImGuiCol_ChildBg]=moniteBg; style.Colors[ImGuiCol_PopupBg]=moniteFrame;
style.Colors[ImGuiCol_Border]=ImVec4(26.0f/255,29.0f/255,36.0f/255,1); style.Colors[ImGuiCol_Button]=ImVec4(0,0,0,0); style.Colors[ImGuiCol_ButtonHovered]=moniteFrame; style.Colors[ImGuiCol_ButtonActive]=moniteFrame;
style.Colors[ImGuiCol_FrameBg]=moniteFrame; style.Colors[ImGuiCol_FrameBgHovered]=ImVec4(35.0f/255,42.0f/255,52.0f/255,1); style.Colors[ImGuiCol_FrameBgActive]=moniteFrame;
style.Colors[ImGuiCol_TitleBg]=moniteBg; style.Colors[ImGuiCol_TitleBgActive]=moniteBg; style.Colors[ImGuiCol_TitleBgCollapsed]=moniteBg; style.Colors[ImGuiCol_Header]=moniteFrame; style.Colors[ImGuiCol_HeaderHovered]=moniteFrame; style.Colors[ImGuiCol_HeaderActive]=moniteAccent;
style.Colors[ImGuiCol_ScrollbarBg]=moniteBg; style.Colors[ImGuiCol_ScrollbarGrab]=moniteFrame; style.Colors[ImGuiCol_ScrollbarGrabHovered]=moniteAccent; style.Colors[ImGuiCol_ScrollbarGrabActive]=moniteAccent; style.Colors[ImGuiCol_CheckMark]=moniteAccent; style.Colors[ImGuiCol_SliderGrab]=moniteAccent; style.Colors[ImGuiCol_SliderGrabActive]=moniteAccent; style.Colors[ImGuiCol_Separator]=ImVec4(26.0f/255,29.0f/255,36.0f/255,1);
style.WindowRounding=0; style.ChildRounding=0; style.FrameRounding=4; style.GrabRounding=4; style.PopupRounding=4; style.ScrollbarRounding=3; style.WindowBorderSize=1; style.FrameBorderSize=0; style.PopupBorderSize=1; style.WindowPadding=ImVec2(0,8); style.FramePadding=ImVec2(10,5); style.ItemSpacing=ImVec2(8,5); style.ItemInnerSpacing=ImVec2(8,4);
    static const ImWchar icons_ranges[] = { 0xf000, 0xf3ff, 0 };
    ImFontConfig icons_config;
    ImFontConfig CustomFont;
    CustomFont.FontDataOwnedByAtlas = false;
    icons_config.MergeMode = true;
    icons_config.PixelSnapH = true;
    io.Fonts->AddFontFromMemoryTTF(const_cast<std::uint8_t*>(Custom), sizeof(Custom), 21.f, &CustomFont);
    io.Fonts->AddFontFromMemoryCompressedTTF(font_awesome_data, font_awesome_size, 19.0f, &icons_config, icons_ranges);
    io.Fonts->AddFontDefault();
    ImFont* font = io.Fonts->AddFontFromMemoryTTF(sansbold, sizeof(sansbold), 21.0f, NULL, io.Fonts->GetGlyphRangesCyrillic());
    verdana_smol = io.Fonts->AddFontFromMemoryTTF(verdana, sizeof verdana, 40, NULL, io.Fonts->GetGlyphRangesCyrillic());
    pixel_big = io.Fonts->AddFontFromMemoryTTF((void*)smallestpixel, sizeof smallestpixel, 400, NULL, io.Fonts->GetGlyphRangesCyrillic());
    pixel_smol = io.Fonts->AddFontFromMemoryTTF((void*)smallestpixel, sizeof smallestpixel, 10*2, NULL, io.Fonts->GetGlyphRangesCyrillic());
    ImGui_ImplMetal_Init(_device);

    return self;
}

+ (void)showChange:(BOOL)open {
    MenDeal = open;
}

+ (BOOL)isMenuShowing {
    return MenDeal;
}

- (MTKView *)mtkView {
    return (MTKView *)self.view;
}

void CustomCheckbox(const char* label, bool* v, ImVec4* userColor)
{
    ImDrawList* draw = ImGui::GetWindowDrawList();
    ImVec2 p = ImGui::GetCursorScreenPos();
    
    ImVec2 size = ImVec2(26.0f, 26.0f); // tamanho do quadrado
    float rounding = 5.0f;

    ImGui::PushID(label);
    if (ImGui::InvisibleButton("##cbold", size))
        *v = !*v;

    ImVec4 bgColor = ImVec4(0.12f, 0.12f, 0.12f, 0.54f);
    ImU32 fillColor = ImGui::ColorConvertFloat4ToU32(*v ? *userColor : bgColor);

    draw->AddRectFilled(p, ImVec2(p.x + size.x, p.y + size.y), fillColor, rounding);
    ImU32 borderColor = IM_COL32(60, 60, 60, 255);
    draw->AddRect(p, ImVec2(p.x + size.x, p.y + size.y), borderColor, rounding, 0, 1.0f);
    if (*v) {
        ImU32 checkColor = IM_COL32(255, 255, 255, 255);
        draw->AddLine(ImVec2(p.x + 6, p.y + 13), ImVec2(p.x + 11, p.y + 18), checkColor, 2.0f);
        draw->AddLine(ImVec2(p.x + 11, p.y + 18), ImVec2(p.x + 20, p.y + 8), checkColor, 2.0f);
    }

    // alinhar texto verticalmente no centro da checkbox
    ImGui::SameLine();
    float textHeight = ImGui::GetTextLineHeight();
    ImGui::SetCursorPosY(ImGui::GetCursorPosY() + (size.y - textHeight) * 0.5f);
    ImGui::TextUnformatted(label);

    ImGui::PopID();
}


void SeparatorCustom(float width, float thickness, ImVec4 userColor)
{
    ImGuiWindow* window = ImGui::GetCurrentWindow();
    if (window->SkipItems)
        return;

    ImVec2 pos = window->DC.CursorPos;
    float avail_width = ImGui::GetContentRegionAvail().x;

    if (width > avail_width)
        width = avail_width;

    ImGui::Dummy(ImVec2(width, thickness));

    ImU32 col = ImGui::GetColorU32(userColor);

    ImVec2 p1 = pos;
    ImVec2 p2 = ImVec2(pos.x + width, pos.y);

    window->DrawList->AddLine(p1, p2, col, thickness);
}



- (void)loadView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGRect bounds = window ? window.bounds : UIScreen.mainScreen.bounds;
    self.view = [[MTKView alloc] initWithFrame:bounds];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.multipleTouchEnabled = YES;
((MTKView *)self.view).multipleTouchEnabled = YES;
self.view.multipleTouchEnabled = YES;
    self.mtkView.multipleTouchEnabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    self.mtkView.hidden = YES;
    self.mtkView.clipsToBounds = YES;

    self.view.multipleTouchEnabled = YES;
    self.mtkView.multipleTouchEnabled = YES;
}

#pragma mark - Interaction

- (void)updateIOWithTouchEvent:(UIEvent *)event
{
    UITouch *anyTouch = event.allTouches.anyObject;
    if (!anyTouch) return;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.MousePos = ImVec2(touchLocation.x, touchLocation.y);

    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches)
    {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled)
        {
            hasActiveTouch = YES;
            break;
        }
    }
    io.MouseDown[0] = hasActiveTouch;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([ImGuiDrawView isMenuShowing]) { [self updateIOWithTouchEvent:event]; }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([ImGuiDrawView isMenuShowing]) { [self updateIOWithTouchEvent:event]; }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([ImGuiDrawView isMenuShowing]) { [self updateIOWithTouchEvent:event]; }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([ImGuiDrawView isMenuShowing]) { [self updateIOWithTouchEvent:event]; }
}




// أضف قبل drawInMTKView

#pragma mark - MTKViewDelegate

- (void)drawInMTKView:(MTKView*)view
{
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;

    CGFloat framebufferScale = view.window.screen.nativeScale ?: UIScreen.mainScreen.nativeScale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 60);



    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
        
    hideRecordTextfield.secureTextEntry = NO;

    if (MenDeal == true) 
    {
        [self.view setUserInteractionEnabled:YES];
        [self.view.superview setUserInteractionEnabled:YES];
        [menuTouchView setUserInteractionEnabled:YES];
    } 
    else if (MenDeal == false) 
    {
        [self.view setUserInteractionEnabled:NO];
        [self.view.superview setUserInteractionEnabled:NO];
        [menuTouchView setUserInteractionEnabled:NO];
    }


    MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor != nil) 
    {
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        [renderEncoder pushDebugGroup:@"ImGui Jane"];

        ImGui_ImplMetal_NewFrame(renderPassDescriptor);
        ImGui::NewFrame();
        ImGuiStyle& style = ImGui::GetStyle();
        ImFont* font = ImGui::GetFont();
        font->Scale = 16.f / font->FontSize;
        
        CGFloat x = (io.DisplaySize.x - 425.0f) * 0.5f;
        CGFloat y = (io.DisplaySize.y - 340.0f) * 0.5f;
        // Mantém a camada UIKit alinhada à janela real do ImGui.
        menuPos = ImVec2(x, y);
        menuSize = ImVec2(425, 340);

        ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_Always);
        ImGui::SetNextWindowSize(ImVec2(425, 340), ImGuiCond_Always);

        
        if (MenDeal == true)
        {
            ImGui::SetNextWindowSize(ImVec2(425, 340), ImGuiCond_Always);
            ImGui::Begin("##MONITE_PANEL", &MenDeal, ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoCollapse);
            ImDrawList* moniteDraw = ImGui::GetWindowDrawList();
            ImVec2 moniteOrigin = ImGui::GetWindowPos();
            moniteDraw->AddRectFilled(moniteOrigin, ImVec2(moniteOrigin.x+425, moniteOrigin.y+340), IM_COL32(11,14,21,255), 0);
            moniteDraw->AddLine(ImVec2(moniteOrigin.x+113, moniteOrigin.y), ImVec2(moniteOrigin.x+113, moniteOrigin.y+340), IM_COL32(26,29,36,255), 1);
            ImGui::Columns(2, "MainColumns", false); // Duas colunas
            ImGui::SetColumnWidth(0, 113.0f);
            ImGui::SetCursorPosY(ImGui::GetCursorPosY() + 5); // Espaço adicional

            static int selected_tab = 0; // 0 for AIM, 1 for ESP, 2 for MISC

            // Coluna da esquerda (navegação)
            ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(0, 8));
            ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(0, 6));
            
float buttonWidth = 101.0f;
auto MoniteTab = [&](const char* title, int index) {
    bool active = selected_tab == index;
    ImGui::PushStyleColor(ImGuiCol_Button, active ? ImVec4(25.0f/255,32.0f/255,40.0f/255,1) : ImVec4(0,0,0,0));
    if (ImGui::Button(title, ImVec2(buttonWidth,52))) selected_tab=index;
    ImVec2 tabMin=ImGui::GetItemRectMin(), tabMax=ImGui::GetItemRectMax();
    if (active) {
        float pulse=0.82f+0.18f*(0.5f+0.5f*sinf((float)ImGui::GetTime()*3.0f));
        ImGui::GetWindowDrawList()->AddRectFilled(ImVec2(tabMax.x-4,tabMin.y),ImVec2(tabMax.x,tabMax.y),ImGui::ColorConvertFloat4ToU32(ImVec4(0.8f,0.5f,1.0f,pulse)),0);
    }
    ImGui::PopStyleColor();
};
MoniteTab(ICON_FA_CROSSHAIRS "\nAimbot",0);
MoniteTab(ICON_FA_EYE "\nVisuals",1);
MoniteTab(ICON_FA_COG "\nConfig",2);
MoniteTab(ICON_FA_ADDRESS_CARD "\nSettings",3);
            ImGui::PopStyleVar(2);

            ImGui::NextColumn();
            const char* moniteSection = selected_tab == 0 ? "Aimbot" : (selected_tab == 1 ? "Visuals" : (selected_tab == 2 ? "Config" : "Settings"));
            ImGui::TextColored(ImVec4(0.80f,0.50f,1.00f,1.00f), "%s", moniteSection);
            ImGui::SameLine(ImGui::GetColumnWidth() - 40.0f);
            ImGui::TextDisabled("01");
            SeparatorCustom(285.0f, 1.0f, userColor);
            ImGui::Spacing(); // Mover para a segunda coluna

            SeparatorCustom(285.0f, 1.0f, userColor);
            ImGui::Spacing();


            // Coluna da direita (conteúdo da aba selecionada)
            ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(0, 5));
            ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(0, 5));

            if (selected_tab == 0) {

                // Conteúdo da aba AIM 

                CustomCheckbox(ENCRYPT(" Ativar Aimbot                 "), &Vars.Aimbot, &userColor);

                float textWidth = ImGui::CalcTextSize("Exibir FOV").x;
float firstCustomCheckboxWidth = ImGui::GetItemRectSize().x;  // Largura do primeiro checkbox
float spacing = ImGui::GetStyle().ItemSpacing.x;

// Posição X = posição atual + largura do primeiro checkbox + espaçamento
ImGui::SameLine(firstCustomCheckboxWidth + 30.0f); // 20 pixels de espaçamento
CustomCheckbox(ENCRYPT(" Exibir FOV"), &Vars.isAimFov, &userColor);
                CustomCheckbox(ENCRYPT(" Ignorar Derrubados         "), &Vars.IgnoreKnocked, &userColor);

float firstCustomCheckboxWidth2 = ImGui::GetItemRectSize().x;
    ImGui::SameLine(firstCustomCheckboxWidth2 + 20.0f);
    CustomCheckbox(ENCRYPT(" Apenas Visiveis"), &Vars.VisibleCheck, &userColor);

                ImGui::PushItemWidth(210);
                ImGui::SliderFloat(ENCRYPT("Regular FOV"), &Vars.AimFov, 0.00f, 360.00f, ENCRYPT(" %.1f "), ImGuiSliderFlags_None);
                ImGui::Combo(ENCRYPT("Puxada"), &Vars.AimHitbox, Vars.aimHitboxes, 3);
                ImGui::Text(ENCRYPT("Tipo de Aimbot:"));

                ImGui::RadioButton(ENCRYPT("Ao Atirar  "), &Vars.AimWhen, 1);
                ImGui::SameLine();
                ImGui::RadioButton(ENCRYPT("Ao Olhar"), &Vars.AimWhen, 0);
                ImGui::PopItemWidth();
            } else if (selected_tab == 1) {
                // Conteúdo da aba ESP

                ImGui::Columns(2, "ESPColumns", false);
                CustomCheckbox(ENCRYPT(" Ativar ESP        "), &Vars.Enable, &userColor);
CustomCheckbox(ENCRYPT(" ESP Linha    "), &Vars.lines, &userColor);
ImGui::SameLine();
CustomCheckbox(ENCRYPT(" ESP Distância    "), &Vars.Distance, &userColor);

CustomCheckbox(ENCRYPT(" ESP Caixa    "), &Vars.Box, &userColor);
ImGui::SameLine();
CustomCheckbox(ENCRYPT(" ESP Inimigos"), &Vars.counts, &userColor);

CustomCheckbox(ENCRYPT(" ESP Nome"), &Vars.Name, &userColor);
CustomCheckbox(ENCRYPT(" ESP Vida"), &Vars.Health, &userColor);
CustomCheckbox(ENCRYPT(" ESP Esqueleto"), &Vars.skeleton, &userColor);




                

} else if (selected_tab == 2) {
    // Aba MISC

    // ===== Funções Rage - topo =====
    ImGui::TextColored(ImVec4(1.0f, 1.0f, 0.0f, 1.0f), ICON_FA_EXCLAMATION_TRIANGLE); // Ícone de aviso amarelo
    ImGui::SameLine();
    ImGui::Text(ENCRYPT(" Funções Rage"));

// Segunda linha: Speed e No Recoil
CustomCheckbox(ENCRYPT(" AimKill   "), &SpeeeX2Enabled, &userColor);
ImGui::SameLine();
CustomCheckbox(ENCRYPT(" No Recoil"), &NoRecoilEnabled, &userColor);

ImGui::SameLine();
        ImGui::Checkbox("Voar Player", &Vars.UpPlayerOne);
ImGui::Checkbox(" Ghost Hack", &Vars.ShowGhostButton);
        if (Vars.ShowGhostButton) {
            if (!self.ghostButtonView) {
                [self ghostModeUI];
            }
        } else {
            if (self.ghostButtonView) {
                [self.ghostButtonView removeFromSuperview];
                self.ghostButtonView = nil;
            }
        }


    // ===== Personalização - abaixo =====
    ImGui::TextColored(ImVec4(0, 1, 0, 1), ICON_FA_BARS);
    ImGui::SameLine();
    ImGui::Text(ENCRYPT(" Personalização"));
ImGui::PushItemWidth(40.0f);
ImGui::ColorEdit4(ENCRYPT("Cor do Painel            "), (float*)&userColor, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoTooltip | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_PickerHueBar);
ImGui::SameLine(); 
ImGui::ColorEdit4(ENCRYPT("Cor do FOV"), (float*)&fovColor, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoTooltip | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_PickerHueBar);
ImGui::ColorEdit4(ENCRYPT("Cor da ESP Visível   "), (float*)&espv, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoTooltip | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_PickerHueBar);
ImGui::SameLine(); 
ImGui::ColorEdit4(ENCRYPT("Cor da ESP Invisível"), (float*)&espi, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoTooltip | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_PickerHueBar);
ImGui::ColorEdit4(ENCRYPT("Cor do Nome             "), (float*)&nameColor, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoTooltip | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_PickerHueBar);
ImGui::SameLine();
ImGui::ColorEdit4(ENCRYPT("Cor da Distância"), (float*)&distanceColor, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoTooltip | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_PickerHueBar);
ImGui::PopItemWidth();
    ImGuiStyle& style = ImGui::GetStyle();

    style.Colors[ImGuiCol_CheckMark] = userColor;
    style.Colors[ImGuiCol_SliderGrab] = userColor;
    style.Colors[ImGuiCol_SliderGrabActive] = userColor;

    style.Colors[ImGuiCol_TitleBg] = userColor;
    style.Colors[ImGuiCol_TitleBgActive] = userColor;
    style.Colors[ImGuiCol_TitleBgCollapsed] = userColor;
    style.Colors[ImGuiCol_Separator] = userColor;

    style.Colors[ImGuiCol_Button] = userColor;
    style.Colors[ImGuiCol_ButtonHovered] = userColor;
    style.Colors[ImGuiCol_ButtonActive] = userColor;

    style.Colors[ImGuiCol_Tab] = userColor;
    style.Colors[ImGuiCol_TabHovered] = userColor;
    style.Colors[ImGuiCol_TabActive] = userColor;
    style.Colors[ImGuiCol_TabUnfocusedActive] = userColor;

    style.Colors[ImGuiCol_Header] = userColor;
    style.Colors[ImGuiCol_HeaderHovered] = userColor;
    style.Colors[ImGuiCol_HeaderActive] = userColor;

    style.Colors[ImGuiCol_NavHighlight] = userColor;
    style.Colors[ImGuiCol_TextSelectedBg] = userColor;
    style.Colors[ImGuiCol_ScrollbarBg] = userColor;
    style.Colors[ImGuiCol_ScrollbarGrab] = userColor;
    style.Colors[ImGuiCol_ScrollbarGrabHovered] = userColor;
    style.Colors[ImGuiCol_ScrollbarGrabActive] = userColor;


    if (ImGui::Button(ENCRYPT(" Fix Loguin "))) {
        self.mtkView.hidden = YES;
        MenDeal = NO;
        timer(30) {
            self.mtkView.hidden = NO;
            MenDeal = YES;
        });
    }
}

  else if (selected_tab == 3) {
NSString *key         = @"Licença validada pela API";
NSString *expiryDate  = @"Gerenciada pelo servidor";
NSString *deviceModel = [[UIDevice currentDevice] model];
NSString *iosVersion  = [[UIDevice currentDevice] systemVersion];

std::string sRemainingTime("Gerenciado pelo servidor");
// Exibição no ImGui
ImGui::Text(ENCRYPT("Dispositivo: %s"), [deviceModel UTF8String]);
ImGui::Text(ENCRYPT("Versão do iOS: %s"), [iosVersion UTF8String]);
ImGui::Text(ENCRYPT("Expira em: %s"), [expiryDate UTF8String]);
ImGui::Text(ENCRYPT("Tempo Restante: %s"), sRemainingTime.c_str());
ImGui::Text(ENCRYPT("Key: %s"), [key UTF8String]);

SeparatorCustom(330.0f, 1.0f, userColor);
ImGui::Text(ENCRYPT("Desenvolvedor: @PH SENSI"));
if (ImGui::Button(ENCRYPT(" Discord "))) {
    NSURL *url = [NSURL URLWithString:[NSString stringWithUTF8String:ENCRYPT("https://discord.gg/GFvbePNKSH")]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

            ImGui::PopStyleVar(2);
            ImGui::Columns(1); // Resetar colunas
            ImGui::End();
        }
        
        ImDrawList* draw_list = ImGui::GetBackgroundDrawList();
        get_players();
        aimbot();
        game_sdk->init();
        

if (Vars.isAimFov && Vars.AimFov > 0) {
    ImVec2 center = ImVec2(ImGui::GetIO().DisplaySize.x / 2, ImGui::GetIO().DisplaySize.y / 2);

    if (Vars.fovaimglow) {
        static float rainbowHue = 0.0f;
        rainbowHue += ImGui::GetIO().DeltaTime * 0.8f;
        if (rainbowHue > 1.0f) rainbowHue = 0.0f;

        drawcircleglow(
            draw_list,
            center,
            Vars.AimFov,
            ImColor(fovColor), // usa cor configurada
            100,
            2.0f,
            12
        );
    } else {
        draw_list->AddCircle(
            center,
            Vars.AimFov,
            ImColor(fovColor),
            100,
            2.0f
        );
    }
}


        ImGui::Render();
        ImDrawData* draw_data = ImGui::GetDrawData();
        ImGui_ImplMetal_RenderDrawData(draw_data, commandBuffer, renderEncoder);
        [renderEncoder popDebugGroup];
        [renderEncoder endEncoding];
        [commandBuffer presentDrawable:view.currentDrawable];
        [commandBuffer commit];
    } 
} 

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size {}
void hooking() {
void* address[] = {
               (void*)getRealOffset(ENCRYPTOFFSET("0x1044290AC"))
    };
    void* function[] = {
                (void*)antiban                                                     
    };
            hook(address, function, 1);
}
void *hack_thread(void *) {

    sleep(5);
    hooking();
    pthread_exit(nullptr);
    return nullptr;
}

void __attribute__((constructor)) initialize() {
    pthread_t hacks;
    pthread_create(&hacks, NULL, hack_thread, NULL); 
}

- (NSString*)remaningTime:(NSDate*)startDate endDate:(NSDate*)endDate
{
    NSDateComponents *components;
    NSInteger week;
    NSInteger days;
    NSInteger hour;
    NSInteger minutes;
    NSInteger second;
    NSString *durationString;
    
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:startDate toDate:endDate options: 0];
    days = [components day];
    week = round(days / 7);
    hour = [components hour];
    minutes = [components minute];
    second = [components second];
    return [NSString stringWithFormat:@"%ld dia(s), %ld h, %ld min, %ld s",days, hour, minutes, second];
}

@end
