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

style.Colors[ImGuiCol_Text]         = ImVec4(0.92f, 0.92f, 0.95f, 1.00f);
style.Colors[ImGuiCol_TextDisabled] = ImVec4(0.42f, 0.43f, 0.47f, 1.00f);
ImVec4 red       = ImVec4(0.92f, 0.02f, 0.18f, 1.00f);
ImVec4 redHover  = ImVec4(1.00f, 0.06f, 0.24f, 1.00f);
ImVec4 redActive = ImVec4(0.68f, 0.01f, 0.10f, 1.00f);
ImVec4 panelBg   = ImVec4(0.035f, 0.038f, 0.050f, 0.98f);
ImVec4 sideBg    = ImVec4(0.025f, 0.027f, 0.036f, 0.98f);
ImVec4 frameBg   = ImVec4(0.075f, 0.078f, 0.095f, 1.00f);
style.Colors[ImGuiCol_WindowBg]             = panelBg;
style.Colors[ImGuiCol_ChildBg]              = sideBg;
style.Colors[ImGuiCol_PopupBg]              = ImVec4(0.04f, 0.04f, 0.055f, 1.00f);
style.Colors[ImGuiCol_Border]               = ImVec4(0.14f, 0.15f, 0.18f, 1.00f);
style.Colors[ImGuiCol_Button]               = ImVec4(0.07f, 0.075f, 0.09f, 1.00f);
style.Colors[ImGuiCol_ButtonHovered]        = ImVec4(0.14f, 0.045f, 0.075f, 1.00f);
style.Colors[ImGuiCol_ButtonActive]         = redActive;
style.Colors[ImGuiCol_FrameBg]              = frameBg;
style.Colors[ImGuiCol_FrameBgHovered]       = ImVec4(0.12f, 0.125f, 0.15f, 1.00f);
style.Colors[ImGuiCol_FrameBgActive]        = ImVec4(0.16f, 0.04f, 0.08f, 1.00f);
style.Colors[ImGuiCol_TitleBg]              = panelBg;
style.Colors[ImGuiCol_TitleBgActive]        = panelBg;
style.Colors[ImGuiCol_TitleBgCollapsed]     = panelBg;
style.Colors[ImGuiCol_Header]               = ImVec4(0.10f, 0.025f, 0.055f, 1.00f);
style.Colors[ImGuiCol_HeaderHovered]        = ImVec4(0.18f, 0.03f, 0.075f, 1.00f);
style.Colors[ImGuiCol_HeaderActive]         = redActive;
style.Colors[ImGuiCol_ScrollbarBg]          = sideBg;
style.Colors[ImGuiCol_ScrollbarGrab]        = red;
style.Colors[ImGuiCol_ScrollbarGrabHovered] = redHover;
style.Colors[ImGuiCol_ScrollbarGrabActive]  = redActive;
style.Colors[ImGuiCol_CheckMark]            = red;
style.Colors[ImGuiCol_SliderGrab]           = red;
style.Colors[ImGuiCol_SliderGrabActive]     = redHover;
style.Colors[ImGuiCol_Separator]            = ImVec4(0.18f, 0.19f, 0.23f, 1.00f);
style.WindowRounding = 12.0f;
style.ChildRounding = 8.0f;
style.FrameRounding = 5.0f;
style.GrabRounding = 5.0f;
style.PopupRounding = 7.0f;
style.ScrollbarRounding = 6.0f;
style.WindowBorderSize = 1.0f;
style.FrameBorderSize = 0.0f;
style.PopupBorderSize = 1.0f;
style.WindowPadding = ImVec2(14.0f, 12.0f);
style.FramePadding = ImVec2(10.0f, 5.0f);
style.ItemSpacing = ImVec2(10.0f, 7.0f);
style.ItemInnerSpacing = ImVec2(8.0f, 5.0f);
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
    ImVec2 size = ImVec2(34.0f, 18.0f);
    ImGui::PushID(label);
    if (ImGui::InvisibleButton("##switch", size)) *v = !*v;
    ImU32 track = ImGui::ColorConvertFloat4ToU32(*v ? *userColor : ImVec4(0.16f, 0.17f, 0.20f, 1.0f));
    draw->AddRectFilled(p, ImVec2(p.x + size.x, p.y + size.y), track, 9.0f);
    ImU32 outline = IM_COL32(70, 72, 80, 180);
    draw->AddRect(p, ImVec2(p.x + size.x, p.y + size.y), outline, 9.0f, 0, 1.0f);
    float knobX = *v ? (p.x + size.x - 9.0f) : (p.x + 9.0f);
    draw->AddCircleFilled(ImVec2(knobX, p.y + size.y * 0.5f), 6.0f, IM_COL32(245, 245, 248, 255));
    ImGui::SameLine();
    ImGui::SetCursorPosY(ImGui::GetCursorPosY() - 1.0f);
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

        // Calcula tudo no mesmo espaço usado pelo ImGui, com margem segura.
        // Assim a janela nunca sai da MTKView nem aparece cortada pela metade.
        CGFloat screenW = io.DisplaySize.x;
        CGFloat screenH = io.DisplaySize.y;
        if (screenW <= 1.0f || screenH <= 1.0f) {
            screenW = view.bounds.size.width;
            screenH = view.bounds.size.height;
        }
        // Layout responsivo: em retrato o painel fica alto o bastante para o conteúdo;
        // em landscape mantém o formato largo da referência.
        const CGFloat safeMargin = 8.0f;
        CGFloat maxW = MAX(80.0f, screenW - safeMargin * 2.0f);
        CGFloat maxH = MAX(80.0f, screenH - safeMargin * 2.0f);
        CGFloat panelW;
        CGFloat panelH;
        if (screenH > screenW) {
            panelW = maxW * 0.92f;
            panelH = maxH * 0.66f;
        } else {
            const CGFloat referenceRatio = 1.86f;
            panelW = MIN(maxW * 0.90f, maxH * 0.90f * referenceRatio);
            panelH = panelW / referenceRatio;
            if (panelH > maxH * 0.90f) {
                panelH = maxH * 0.90f;
                panelW = panelH * referenceRatio;
            }
        }
        CGFloat x = (screenW - panelW) * 0.5f;
        CGFloat y = (screenH - panelH) * 0.5f;
        static float panelAnim = 0.0f;
        if (MenDeal) panelAnim = ImMin(1.0f, panelAnim + io.DeltaTime * 8.0f);
        else panelAnim = 0.0f;
        CGFloat visualY = y - (1.0f - panelAnim) * 8.0f;
        // Mantém a camada UIKit alinhada à janela real do ImGui.
        menuPos = ImVec2(x, y);
        menuSize = ImVec2(panelW, panelH);

        ImGui::SetNextWindowPos(ImVec2(x, y), ImGuiCond_Always);
        ImGui::SetNextWindowSize(ImVec2(panelW, panelH), ImGuiCond_Always);


        if (MenDeal == true)
        {
            ImGui::SetNextWindowSize(ImVec2(panelW, panelH), ImGuiCond_Always);
            ImGui::PushStyleVar(ImGuiStyleVar_Alpha, 0.55f + 0.45f * panelAnim);
            ImGui::Begin("##SAPP_HIRE_PANEL", &MenDeal, ImGuiWindowFlags_NoTitleBar | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_AlwaysVerticalScrollbar);
            // Usa o tamanho efetivo aceito pelo ImGui para nunca desenhar fora da janela.
            ImVec2 actualPanelSize = ImGui::GetWindowSize();
            panelW = actualPanelSize.x;
            panelH = actualPanelSize.y;
            ImDrawList* panelDraw = ImGui::GetWindowDrawList();
            ImVec2 panelOrigin = ImGui::GetWindowPos();
            ImVec2 panelEnd = ImVec2(panelOrigin.x + panelW, panelOrigin.y + panelH);
            panelDraw->AddRectFilled(panelOrigin, panelEnd, IM_COL32(10, 11, 16, 248), 12.0f);
            panelDraw->AddRect(panelOrigin, panelEnd, IM_COL32(42, 43, 53, 255), 12.0f, 0, 1.2f);
            panelDraw->AddRectFilled(panelOrigin, ImVec2(panelEnd.x, panelOrigin.y + 88.0f), IM_COL32(13, 14, 20, 250), 12.0f);
            panelDraw->AddLine(ImVec2(panelOrigin.x, panelOrigin.y + 88.0f), ImVec2(panelEnd.x, panelOrigin.y + 88.0f), IM_COL32(29, 30, 39, 255), 1.0f);
            panelDraw->AddRectFilled(ImVec2(panelEnd.x - 22.0f, panelOrigin.y + 112.0f), ImVec2(panelEnd.x - 7.0f, panelEnd.y - 96.0f), IM_COL32(235, 0, 42, 235), 8.0f);
            ImGui::SetCursorPos(ImVec2(26.0f, 24.0f));
            ImGui::TextColored(ImVec4(0.95f, 0.95f, 0.98f, 1.0f), ICON_FA_COG);
            ImGui::SameLine(58.0f);
            ImGui::TextColored(ImVec4(0.92f, 0.92f, 0.95f, 1.0f), "SAPP");
            ImGui::SameLine(111.0f);
            ImGui::TextColored(ImVec4(0.95f, 0.02f, 0.18f, 1.0f), "HIRE");
            ImGui::SetCursorPos(ImVec2(panelW - 82.0f, 30.0f));
            ImGui::TextColored(ImVec4(0.22f, 0.23f, 0.28f, 1.0f), "OXIDE");
            ImGui::SetCursorPos(ImVec2(0.0f, 89.0f));
            ImGui::Columns(2, "MainColumns", false);
            ImGui::SetColumnWidth(0, panelW * 0.22f);
            ImGui::SetCursorPosY(ImGui::GetCursorPosY() + 8);

            static int selected_tab = 0; // 0 for AIM, 1 for ESP, 2 for MISC

            // Navegação lateral no estilo do vídeo.
            ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(0, 8));
            ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(10, 7));
            float buttonWidth = panelW * 0.19f;
            ImGui::TextDisabled("COMBAT");
            if (selected_tab == 0) ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.25f, 0.015f, 0.06f, 1.0f));
            if (ImGui::Button(ICON_FA_CROSSHAIRS "   Aimbot", ImVec2(buttonWidth, 40))) selected_tab = 0;
            if (selected_tab == 0) ImGui::PopStyleColor();
            ImGui::Dummy(ImVec2(1, 5));
            ImGui::TextDisabled("VISUAL");
            if (selected_tab == 1) ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.25f, 0.015f, 0.06f, 1.0f));
            if (ImGui::Button(ICON_FA_EYE "   Visuals", ImVec2(buttonWidth, 40))) selected_tab = 1;
            if (selected_tab == 1) ImGui::PopStyleColor();
            ImGui::Dummy(ImVec2(1, 5));
            ImGui::TextDisabled("SYSTEM");
            if (selected_tab == 2) ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.25f, 0.015f, 0.06f, 1.0f));
            if (ImGui::Button(ICON_FA_ADDRESS_CARD "   Config", ImVec2(buttonWidth, 40))) selected_tab = 2;
            if (selected_tab == 2) ImGui::PopStyleColor();
            if (selected_tab == 3) ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.25f, 0.015f, 0.06f, 1.0f));
            if (ImGui::Button(ICON_FA_COG "   Settings", ImVec2(buttonWidth, 40))) selected_tab = 3;
            if (selected_tab == 3) ImGui::PopStyleColor();
            ImGui::PopStyleVar(2);

            ImGui::NextColumn(); // Mover para a segunda coluna

            SeparatorCustom(panelW * 0.70f, 1.0f, userColor);
            ImGui::Spacing();


            // Coluna da direita (conteúdo da aba selecionada)
            bool compactLayout = screenH > screenW;
            ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(0, 5));
            ImGui::PushStyleVar(ImGuiStyleVar_FramePadding, ImVec2(0, 5));

            if (selected_tab == 0) {

                // Conteúdo da aba AIM

                CustomCheckbox(ENCRYPT(" Ativar Aimbot                 "), &Vars.Aimbot, &userColor);

                float textWidth = ImGui::CalcTextSize("Exibir FOV").x;
float firstCustomCheckboxWidth = ImGui::GetItemRectSize().x;  // Largura do primeiro checkbox
float spacing = ImGui::GetStyle().ItemSpacing.x;

// Posição X = posição atual + largura do primeiro checkbox + espaçamento
if (!compactLayout) ImGui::SameLine(firstCustomCheckboxWidth + 30.0f); // 20 pixels de espaçamento
CustomCheckbox(ENCRYPT(" Exibir FOV"), &Vars.isAimFov, &userColor);
                CustomCheckbox(ENCRYPT(" Ignorar Derrubados         "), &Vars.IgnoreKnocked, &userColor);

float firstCustomCheckboxWidth2 = ImGui::GetItemRectSize().x;
    if (!compactLayout) ImGui::SameLine(firstCustomCheckboxWidth2 + 20.0f);
    CustomCheckbox(ENCRYPT(" Apenas Visiveis"), &Vars.VisibleCheck, &userColor);

                ImGui::PushItemWidth(compactLayout ? -1.0f : 210.0f);
                ImGui::SliderFloat(ENCRYPT("Regular FOV"), &Vars.AimFov, 0.00f, 360.00f, ENCRYPT(" %.1f "), ImGuiSliderFlags_None);
                ImGui::Combo(ENCRYPT("Puxada"), &Vars.AimHitbox, Vars.aimHitboxes, 3);
                ImGui::Text(ENCRYPT("Tipo de Aimbot:"));

                ImGui::RadioButton(ENCRYPT("Ao Atirar  "), &Vars.AimWhen, 1);
                if (!compactLayout) ImGui::SameLine();
                ImGui::RadioButton(ENCRYPT("Ao Olhar"), &Vars.AimWhen, 0);
                ImGui::PopItemWidth();
            } else if (selected_tab == 1) {
                // Conteúdo da aba ESP

                if (!compactLayout) ImGui::Columns(2, "ESPColumns", false);
                CustomCheckbox(ENCRYPT(" Ativar ESP        "), &Vars.Enable, &userColor);
CustomCheckbox(ENCRYPT(" ESP Linha    "), &Vars.lines, &userColor);
if (!compactLayout) ImGui::SameLine();
CustomCheckbox(ENCRYPT(" ESP Distância    "), &Vars.Distance, &userColor);

CustomCheckbox(ENCRYPT(" ESP Caixa    "), &Vars.Box, &userColor);
if (!compactLayout) ImGui::SameLine();
CustomCheckbox(ENCRYPT(" ESP Inimigos"), &Vars.counts, &userColor);

CustomCheckbox(ENCRYPT(" ESP Nome"), &Vars.Name, &userColor);
CustomCheckbox(ENCRYPT(" ESP Vida"), &Vars.Health, &userColor);
CustomCheckbox(ENCRYPT(" ESP Esqueleto"), &Vars.skeleton, &userColor);






} else if (selected_tab == 2) {
    // Aba MISC

    // ===== Funções Rage - topo =====
    ImGui::TextColored(ImVec4(1.0f, 1.0f, 0.0f, 1.0f), ICON_FA_EXCLAMATION_TRIANGLE); // Ícone de aviso amarelo
    if (!compactLayout) ImGui::SameLine();
    ImGui::Text(ENCRYPT(" Funções Rage"));

// Segunda linha: Speed e No Recoil
CustomCheckbox(ENCRYPT(" AimKill   "), &SpeeeX2Enabled, &userColor);
if (!compactLayout) ImGui::SameLine();
CustomCheckbox(ENCRYPT(" No Recoil"), &NoRecoilEnabled, &userColor);

if (!compactLayout) ImGui::SameLine();
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
    if (!compactLayout) ImGui::SameLine();
    ImGui::Text(ENCRYPT(" Personalização"));
ImGui::PushItemWidth(40.0f);
ImGui::ColorEdit4(ENCRYPT("Cor do Painel            "), (float*)&userColor, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoTooltip | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_PickerHueBar);
if (!compactLayout) ImGui::SameLine();
ImGui::ColorEdit4(ENCRYPT("Cor do FOV"), (float*)&fovColor, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoTooltip | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_PickerHueBar);
ImGui::ColorEdit4(ENCRYPT("Cor da ESP Visível   "), (float*)&espv, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoTooltip | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_PickerHueBar);
if (!compactLayout) ImGui::SameLine();
ImGui::ColorEdit4(ENCRYPT("Cor da ESP Invisível"), (float*)&espi, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoTooltip | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_PickerHueBar);
ImGui::ColorEdit4(ENCRYPT("Cor do Nome             "), (float*)&nameColor, ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_NoTooltip | ImGuiColorEditFlags_NoSidePreview | ImGuiColorEditFlags_PickerHueBar);
if (!compactLayout) ImGui::SameLine();
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

SeparatorCustom(panelW * 0.70f, 1.0f, userColor);
ImGui::Text(ENCRYPT("Desenvolvedor: @PH SENSI"));
if (ImGui::Button(ENCRYPT(" Discord "))) {
    NSURL *url = [NSURL URLWithString:[NSString stringWithUTF8String:ENCRYPT("https://discord.gg/GFvbePNKSH")]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

            ImGui::PopStyleVar(2);
            ImGui::Columns(1); // Resetar colunas
            ImGui::End();
            ImGui::PopStyleVar();
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
