#import "vinhtran.hpp"
#import "loading.hxx"
#include <fstream>
#define FMT_HEADER_ONLY
#include "fmt/core.h"
#include <chrono>
#include "hook/hook.h"
extern ImVec4 espv; 
extern ImVec4 espi; 
extern ImVec4 nameColor;
extern ImVec4 distanceColor;
extern bool istelekill;
extern bool isfly;
extern bool NoRecoilEnabled;
static void Transform_INTERNAL_SetPosition(void *transform, Vvector3 in) {
    void (*_SetPos)(void *, Vvector3) = (void (*)(void *, Vvector3))getRealOffset(oxo("0x929B86C"));
    _SetPos(transform, in);
}
typedef void* DamageInfo2_o;
inline float get_distance(Vector3 a, Vector3 b) {
float dx = a.x - b.x;
 float dy = a.y - b.y;
float dz = a.z - b.z;
 return sqrtf(dx * dx + dy * dy + dz * dz);
}
static ImVec4 colorESPVisible   = ImVec4(0.0f, 1.0f, 0.0f, 1.0f); 
static ImVec4 colorESPInvisible = ImVec4(1.0f, 0.0f, 0.0f, 1.0f); 
bool AimKill = false;
bool SowDamage = true;
bool autochangeweapon = false;
bool POFFNNMOOBM = false;
int GDKLMFLNNGM = 0;
struct Vars_t
{
    int Target = {};
    bool SilentAim = false;
    bool AimKill = false;
    bool AutoWeaponSwitch = false;
    bool tele10 = false;
    bool UpPlayerOne = false;
    bool Enable = {};
    bool AimbotEnable = {};
    bool Aimbot = {};
    float AimFov = {};
    int AimCheck = {};
    int AimType = {};
    int AimWhen = {};
    bool isAimFov = {};
    int AimHitbox = 0; 
    const char* aimHitboxes[3] = {" Cabeça", " Pescoço", " Corpo"};
    const char* dir[4] = { " Automático", " Disparo", " Escopo", " Disparo + Escopo" };
    bool lines = {};
    bool Box = {};
    bool Outline = {};
    bool Name = {};
    bool Health = {};
    bool Distance = {};
    bool fovaimglow = {};
    bool circlepos = {};
    bool skeleton = {};
    bool OOF = {};
    bool counts = {};
    ImVec4 boxColor = ImVec4(1.0f, 0.0f, 0.0f, 0.8f);
    float AimSpeed = 9999.0f; 
    bool VisibleCheck = false; 
    bool IgnoreKnocked = false; 
    int BoxStyle = 0; 
    int HealthPosition = 0; 
    int HealthBarStyle = 0; 
    int LineStyle = 0; 
    int NameStyle = 0; 
    bool forceHighFPS = false;
    bool aimbotVisible = false;
    bool line = false;
    bool fps120 = false;
    bool EnableGhost = false;
    bool ShowGhostButton = false;
} Vars;
extern ImVec4 menuColor;
extern bool ShowFOV; 
class game_sdk_t
{
public:
    void init();
    int (*GetHp)(void *player);
    void *(*Curent_Match)();
    void *(*GetLocalPlayer)(void *Game);
    void *(*GetHeadPositions)(void *player);
    Vector3 (*get_position)(void *player);
    void *(*Component_GetTransform)(void *player);
    void *(*get_camera)();
    Vector3 (*WorldToViewpoint)(void*, Vector3, int);
    bool (*get_isVisible)(void *player);
    bool (*get_isLocalTeam)(void *player);
    bool (*get_IsDieing)(void *player);
    int (*get_MaxHP)(void *player);
    Vector3 (*GetForward)(void *player);
    void (*set_aim)(void *player, Quaternion look);
    bool (*get_IsSighting)(void *player);
    bool (*get_IsFiring)(void *player);
    monoString *(*name)(void *player);
    void *(*_GetHeadPositions)(void *);
    void *(*_newHipMods)(void *);
    void *(*_GetLeftAnkleTF)(void *);
    void *(*_GetRightAnkleTF)(void *);
    void *(*_GetLeftToeTF)(void *);
    void *(*_GetRightToeTF)(void *);
    void *(*_getLeftHandTF)(void *);
    void *(*_getRightHandTF)(void *);
    void *(*_getLeftForeArmTF)(void *);
    void *(*_getRightForeArmTF)(void *);
};
game_sdk_t *game_sdk = new game_sdk_t();
void game_sdk_t::init()
{ 
    this->GetHp = (int (*)(void *))getRealOffset(oxo("0x56AA7C8"));
    this->Curent_Match = (void *(*)())getRealOffset(oxo("0x591B898"));
    this->GetLocalPlayer = (void *(*)(void *))getRealOffset(oxo("0x320FF7C"));
    this->GetHeadPositions = (void *(*)(void *))getRealOffset(oxo("0x56CA948"));
    this->get_position = (Vector3(*)(void *))getRealOffset(oxo("0x8D6C1EC"));
    this->Component_GetTransform = (void *(*)(void *))getRealOffset(oxo("0x8D59C2C"));
    this->get_camera = (void *(*)())getRealOffset(oxo("0x8CFF0B4"));
    this->WorldToViewpoint = (Vector3(*)(void*, Vector3, int))getRealOffset(oxo("0x8CFEA34"));
    
    this->get_isVisible = (bool (*)(void *))getRealOffset(oxo("0x563B10C"));
    this->get_isLocalTeam = (bool (*)(void *))getRealOffset(oxo("0x5655F1C"));
    this->get_IsDieing = (bool (*)(void *))getRealOffset(oxo("0x561C768"));
    this->get_MaxHP = (int (*)(void *))getRealOffset(oxo("0x5613110"));
    this->GetForward = (Vector3(*)(void *))getRealOffset(oxo("0x8D6CBE4"));
    this->set_aim = (void (*)(void *, Quaternion))getRealOffset(oxo("0x5636F80"));
    this->get_IsSighting = (bool (*)(void *))getRealOffset(oxo("0x5629C84"));
    this->get_IsFiring = (bool (*)(void *))getRealOffset(oxo("0x56200F0"));
    this->name = (monoString * (*)(void *player)) getRealOffset(oxo("0x5630F10"));

    this->_GetHeadPositions = (void *(*)(void *))getRealOffset(oxo("0x56CA948"));
    this->_newHipMods = (void *(*)(void *))getRealOffset(oxo("0x56CAAF8"));
    this->_GetLeftAnkleTF = (void *(*)(void *))getRealOffset(oxo("0x56CAF48"));
    this->_GetRightAnkleTF = (void *(*)(void *))getRealOffset(oxo("0x56CB054"));
    this->_GetLeftToeTF = (void *(*)(void *))getRealOffset(oxo("0x56CB160"));
    this->_GetRightToeTF = (void *(*)(void *))getRealOffset(oxo("0x56CB280"));
    this->_getLeftHandTF = (void *(*)(void *))getRealOffset(oxo("0x5635F18"));
    this->_getRightHandTF = (void *(*)(void *))getRealOffset(oxo("0x563601C"));
    this->_getLeftForeArmTF = (void *(*)(void *))getRealOffset(oxo("0x5636120"));
    this->_getRightForeArmTF = (void *(*)(void *))getRealOffset(oxo("0x5636120"));
}
namespace Camera$$WorldToScreen {
    ImVec2 Regular(Vector3 pos) {
        auto cam = game_sdk->get_camera();
        if (!cam) return {0,0};

        Vector3 worldPoint = game_sdk->WorldToViewpoint(cam,pos, 2);
        Vector3 location;

        int ScreenWidth = ImGui::GetIO().DisplaySize.x;
        int ScreenHeight = ImGui::GetIO().DisplaySize.y;

        location.x = ScreenWidth * worldPoint.x;
        location.y = ScreenHeight - worldPoint.y * ScreenHeight;
        location.z  = worldPoint.z;

        return {location.x, location.y};
    }

    ImVec2 Checker(Vector3 pos, bool &checker) {
        auto cam = game_sdk->get_camera();
        if (!cam) return {0, 0};
       
        Vector3 worldPoint = game_sdk->WorldToViewpoint(cam,pos, 4);
        Vector3 location;
     
        int ScreenWidth = ImGui::GetIO().DisplaySize.x;
        int ScreenHeight = ImGui::GetIO().DisplaySize.y;
     
        location.x = ScreenWidth * worldPoint.x;
        location.y = ScreenHeight - worldPoint.y * ScreenHeight;
        location.z = worldPoint.z;
     
        checker = location.z > 1;
     
        return {location.x, location.y};
    }
}
Vector3 GetBonePosition(void *player, void *(*transformGetter)(void *)) {
    if (!player || !transformGetter)
        return Vector3();
    void *transform = transformGetter(player);
    return transform ? game_sdk->get_position(game_sdk->Component_GetTransform(transform)) : Vector3();
}
Vector3 GetHitboxPosition(void* player, int hitbox) {
    if (!player) return Vector3::zero();
    switch (hitbox) {
        case 0: return GetBonePosition(player, game_sdk->_GetHeadPositions); 
        case 1: {
            Vector3 headPos = GetBonePosition(player, game_sdk->_GetHeadPositions);
            return headPos == Vector3::zero() ? headPos : Vector3(headPos.x, headPos.y - 0.05f, headPos.z); 
        }
        case 2: {
            Vector3 headPos = GetBonePosition(player, game_sdk->_GetHeadPositions);
            return headPos == Vector3::zero() ? headPos : Vector3(headPos.x, headPos.y - 0.2f, headPos.z); 
        }
        default: return GetBonePosition(player, game_sdk->_GetHeadPositions);
    }
}
Vector3 getPosition(void *player) {
    return game_sdk->get_position(game_sdk->Component_GetTransform(player));
}
static Vector3 GetHeadPosition(void *player) {
    return game_sdk->get_position(game_sdk->GetHeadPositions(player));
}
static Vector3 CameraMain(void *player) {
    return game_sdk->get_position(*(void **)((uint64_t)player + 0x3E8));//public Transform MainCameraTransform; ATUALIZADO
}
Quaternion GetRotationToTheLocation(Vector3 Target, float Height, Vector3 MyEnemy) {
    Vector3 direction = (Target + Vector3(0, Height, 0)) - MyEnemy;
    return Quaternion::LookRotation(direction, Vector3(0, 1, 0));
}
Quaternion GetCurrentRotation(void* player) {
    void* transform = game_sdk->Component_GetTransform(player);
    if (!transform) return Quaternion();
    return Quaternion::LookRotation(game_sdk->GetForward(transform), Vector3(0, 1, 0));
}
#include "Helper/Ext.h"
class tanghinh {
public:
    static Vector3 Transform_GetPosition(void *player) {
       Vector3 out = Vector3::zero();
        void (*_Transform_GetPosition)(void *transform, Vector3 *out) = (void (*)(void *, Vector3 *))getRealOffset(oxo("0x8D6C1EC"));//private void get_position_Injected(out Vector3 ret) { } ATUALIZADO
        _Transform_GetPosition(player, &out);
        return out;
    }

    static void *Player_GetHeadCollider(void *player)
    {
        void *(*_Player_GetHeadCollider)(void *players) = (void *(*)(void *))getRealOffset(oxo("0x5634F3C"));//public virtual Collider get_HeadCollider() { } ATUALIZADO
        return _Player_GetHeadCollider(player);
    }

    static bool Physics_Raycast(Vector3 camLocation, Vector3 headLocation, unsigned int LayerID, void *collider)
    {
        bool (*_Physics_Raycast)(Vector3 camLocation, Vector3 headLocation, unsigned int LayerID, void *collider) = (bool (*)(Vector3, Vector3, unsigned int, void *))getRealOffset(oxo("0x6396DE4"));//public static bool SingleLineCheck(Vector3 startTrace, Vector3 endTrace, uint traceFlag, ref HitObjectInfo hitObjectInfo) { } ATUALIZADO
        return _Physics_Raycast(camLocation, headLocation, LayerID, collider);
    }

    static bool isVisible(void *enemy) {
        if (!enemy) return false;
        
        try {
            // Pega posições
            void* cam = game_sdk->get_camera();
            if (!cam) return false;
            
            void* camTF = game_sdk->Component_GetTransform(cam);
            if (!camTF) return false;
            
            Vector3 cameraPos = game_sdk->get_position(camTF);
            
            void* enemyTF = game_sdk->Component_GetTransform(enemy);
            if (!enemyTF) return false;
            
            Vector3 enemyPos = game_sdk->get_position(enemyTF);
            
            if (cameraPos == Vector3::zero() || enemyPos == Vector3::zero()) return false;
            
            // Testa múltiplos layers para detectar paredes
            // Layer 1 = Terrain, 8 = Default, 11 = Wall, 12 = Obstacle
            void *hitObj = NULL;
            
            // Se QUALQUER layer detectar colisão, o inimigo NÃO está visível
            if (Physics_Raycast(cameraPos, enemyPos, 1, &hitObj)) return false;   // Terrain
            if (Physics_Raycast(cameraPos, enemyPos, 8, &hitObj)) return false;   // Default
            if (Physics_Raycast(cameraPos, enemyPos, 11, &hitObj)) return false;  // Wall
            if (Physics_Raycast(cameraPos, enemyPos, 12, &hitObj)) return false;  // Obstacle
            
            // Se passou por todos os raycasts sem colisão, está visível
            return true;
            
        } catch (...) {
            return false;
        }
    }
};
void DrawLine(ImDrawList* drawList, ImVec2 start, ImVec2 end, float thickness, bool isDead = false, bool isVisible = false) {
    if (!drawList) return;
    ImColor color = isDead ? ImColor(255, 0, 0)
                  : isVisible ? ImColor(colorESPVisible)
                  : ImColor(colorESPInvisible);
    drawList->AddLine(start, end, color, thickness);
}

// ============================================================
// ESP — reescrito do zero para máxima performance
// ============================================================

// Converte posição 3D para 2D — retorna false se atrás da câmera
static bool W2S(Vector3 pos, ImVec2& out) {
    auto cam = game_sdk->get_camera();
    if (!cam) return false;
    Vector3 vp = game_sdk->WorldToViewpoint(cam, pos, 4);
    if (vp.z <= 0.01f) return false; // atrás da câmera
    float W = ImGui::GetIO().DisplaySize.x;
    float H = ImGui::GetIO().DisplaySize.y;
    out.x = W * vp.x;
    out.y = H - vp.y * H;
    return true;
}

// Lê posição de um osso diretamente — 1 chamada Unity
static Vector3 GetBonePosOpt(void* player, void*(*getter)(void*)) {
    if (!player || !getter) return Vector3::zero();
    void* tf = getter(player);
    if (!tf) return Vector3::zero();
    Vector3 out = Vector3::zero();
    void (*injected)(void*, Vector3*) = (void(*)(void*, Vector3*))getRealOffset(oxo("0x8D6C1EC")); // ATUALIZADO
    injected(tf, &out);
    return out;
}

// Esqueleto otimizado — lê todos os ossos em batch, sem raycast extra
static void ESP_DrawSkeleton(void* player, ImDrawList* dl, ImColor col) {
    // Lê os 7 ossos necessários
    Vector3 head = GetBonePosOpt(player, game_sdk->_GetHeadPositions);
    Vector3 hip  = GetBonePosOpt(player, game_sdk->_newHipMods);
    Vector3 lAnk = GetBonePosOpt(player, game_sdk->_GetLeftAnkleTF);
    Vector3 rAnk = GetBonePosOpt(player, game_sdk->_GetRightAnkleTF);
    Vector3 lHnd = GetBonePosOpt(player, game_sdk->_getLeftHandTF);
    Vector3 rHnd = GetBonePosOpt(player, game_sdk->_getRightHandTF);
    Vector3 lFA  = GetBonePosOpt(player, game_sdk->_getLeftForeArmTF);
    Vector3 rFA  = GetBonePosOpt(player, game_sdk->_getRightForeArmTF);

    // Converte para 2D em batch
    ImVec2 sHead, sHip, sLA, sRA, sLH, sRH, sLFA, sRFA;
    if (!W2S(head, sHead)) return; // se a cabeça não está na tela, skip
    bool ok = W2S(hip, sHip) && W2S(lAnk, sLA) && W2S(rAnk, sRA)
           && W2S(lHnd, sLH) && W2S(rHnd, sRH)
           && W2S(lFA,  sLFA) && W2S(rFA, sRFA);
    if (!ok) return;

    // Desenha 8 segmentos com uma cor — sem raycast
    dl->AddLine(sHead, sHip,  col, 1.0f); // espinha
    dl->AddLine(sHead, sLFA,  col, 1.0f); // ombro E
    dl->AddLine(sHead, sRFA,  col, 1.0f); // ombro D
    dl->AddLine(sLFA,  sLH,   col, 1.0f); // antebraço E
    dl->AddLine(sRFA,  sRH,   col, 1.0f); // antebraço D
    dl->AddLine(sHip,  sLA,   col, 1.0f); // perna E
    dl->AddLine(sHip,  sRA,   col, 1.0f); // perna D
}

// ============================================================
// Cache de visibilidade — 1 raycast por player a cada 6 frames
// ============================================================
#include <unordered_map>
static std::unordered_map<void*, bool> g_visibilityCache;
static int g_visibilityFrameCounter = 0;

static bool GetVisibilityCached(void* player) {
    auto it = g_visibilityCache.find(player);
    if (it != g_visibilityCache.end()) return it->second;
    bool v = tanghinh::isVisible(player);
    g_visibilityCache[player] = v;
    return v;
}

// ============================================================
// Cache de nome — string alocada 1x por player a cada 120 frames
// ============================================================
static std::unordered_map<void*, std::string> g_nameCache;
static int g_nameCacheFrameCounter = 0;

static const std::string& GetNameCached(void* player) {
    auto it = g_nameCache.find(player);
    if (it != g_nameCache.end()) return it->second;
    auto pname = game_sdk->name(player);
    std::string name = pname ? pname->toCPPString() : "?";
    std::transform(name.begin(), name.end(), name.begin(), ::tolower);
    g_nameCache[player] = std::move(name);
    return g_nameCache[player];
}
// DrawHealthBar mantido para compatibilidade
void DrawHealthBar(ImDrawList* drawList, ImVec2 start, ImVec2 end, float healthMultiplier, float thickness, bool isDead = false) {
    if (!drawList) return;
    drawList->AddRectFilled(ImVec2(start.x - thickness/2, start.y), ImVec2(start.x + thickness/2, end.y), ImColor(50, 50, 50, 200));
    if (healthMultiplier > 0) {
        float totalHeight = end.y - start.y;
        float healthHeight = totalHeight * healthMultiplier;
        ImColor color = isDead ? ImColor(255, 0, 0) : ImColor(0, 255, 0);
        drawList->AddRectFilled(ImVec2(start.x - thickness/2, end.y - healthHeight), ImVec2(start.x + thickness/2, end.y), color);
    }
}

// DrawSkeleton — wrapper para compatibilidade, usa a versão otimizada
void DrawSkeleton(void* player, ImDrawList* drawList, float scale_factor) {
    if (!player || !drawList) return;
    bool isDead    = game_sdk->get_IsDieing(player);
    bool isVisible = GetVisibilityCached(player); // reutiliza cache — sem raycast extra
    ImColor col = isDead ? ImColor(255, 0, 0)
                : isVisible ? ImColor(colorESPVisible)
                : ImColor(colorESPInvisible);
    ESP_DrawSkeleton(player, drawList, col);
}
bool isFov(Vector3 vec1, Vector3 vec2, int radius) {
    float dx = vec1.x - vec2.x;
    float dy = vec1.y - vec2.y;
    return (dx * dx + dy * dy) <= (radius * radius);
}
void *GetClosestEnemy() {
    try {
        float shortestDistance = 250.0f;
        void *closestEnemy = NULL;
        void *get_MatchGame = game_sdk->Curent_Match();
        if (!get_MatchGame)
            return NULL;
        void *LocalPlayer = game_sdk->GetLocalPlayer(get_MatchGame);
        if (!LocalPlayer || !game_sdk->Component_GetTransform(LocalPlayer))
            return NULL;
        if (!Vars.Aimbot && !Vars.Enable)
            return NULL;
        Dictionary<uint8_t *, void **> *players = *(Dictionary<uint8_t *, void **> **)((long)get_MatchGame + oxo("0x148"));
        if (!players)
            return NULL;
        Vector3 LocalPlayerPos = getPosition(LocalPlayer);
        ImVec2 center = ImVec2(ImGui::GetIO().DisplaySize.x / 2, ImGui::GetIO().DisplaySize.y / 2);
        for (int u = 0; u < players->getSize(); u++) {
            void *Player = players->getValues()[u];
            if (!Player || Player == LocalPlayer || !game_sdk->get_MaxHP(Player) || game_sdk->get_isLocalTeam(Player))
                continue;
            if (Vars.IgnoreKnocked && game_sdk->get_IsDieing(Player))
                continue;
            // SEMPRE verifica visibilidade - não mira em inimigos atrás de paredes
            if (!tanghinh::isVisible(Player))
                continue;
            Vector3 PlayerPos = GetHitboxPosition(Player, Vars.AimHitbox);
            float distance = Vector3::Distance(LocalPlayerPos, PlayerPos);
            if (distance >= 300)
                continue;
            ImVec2 enemyScreenPos = Camera$$WorldToScreen::Regular(PlayerPos);
            bool isValidTarget = isFov(Vector3(enemyScreenPos.x, enemyScreenPos.y, 0), Vector3(center.x, center.y, 0), Vars.AimFov);
            if (isValidTarget && distance < shortestDistance) {
                shortestDistance = distance;
                closestEnemy = Player;
            }
        }
        return closestEnemy;
    } catch (...) {
        return NULL;
    }
}

void NoRecoil(void* instance, Vector3* recoilVec, float a1, float a2) {
    if (!NoRecoilEnabled) return;
    recoilVec->x = 0;
    recoilVec->y = 0;
    recoilVec->z = 0;
}
void bitch(void *_this, float a1, float a2) {
    if (!_this || !Vars.Enable) return;

    void* match = game_sdk->Curent_Match();
    if (!match) return;
    void* local = game_sdk->GetLocalPlayer(match);
    if (!local || !game_sdk->Component_GetTransform(local)) return;

    if (!game_sdk->get_IsFiring(local)) return;

    void* target = GetClosestEnemy();
    if (!target) return;
    
    // VERIFICAÇÃO EXTRA: Confirma que o target está realmente visível
    if (!tanghinh::isVisible(target)) return;
    
    if (game_sdk->GetHp(target) <= 0) return;
    
    Vector3 targetPos;

    switch (Vars.Target) {
        case 0:
            targetPos = GetHeadPosition(target);
            break;
        case 1:
            targetPos = GetHeadPosition(target);
            break;
        case 2:
            targetPos = GetHeadPosition(target);
            break;
    }

    Vector3 eye = GetHeadPosition(local); 

    Quaternion aimRot = GetRotationToTheLocation(targetPos, 0, eye);

    if (Vars.SilentAim) {
       
        game_sdk->set_aim(local, aimRot);
    } else if (Vars.Aimbot) {
        
    }
}

void AutoHookSilentFire() {
    static bool isHooked = false;
    // Throttle — só processa a cada 10 frames para não penalizar o render
    static int _throttle = 0;
    if (++_throttle < 10) return;
    _throttle = 0;

    void* fireOffset    = (void*)getRealOffset(ENCRYPTOFFSET("0x10523717C"));
    void* noRecoilAddr  = (void*)getRealOffset(ENCRYPTOFFSET("0x105174020"));

    if (!Vars.SilentAim) return;

    void* match = game_sdk->Curent_Match();
    if (!match) return;

    void* local = game_sdk->GetLocalPlayer(match);
   if (!local || !game_sdk->Component_GetTransform(local)) return;
    bool isFiring = game_sdk->get_IsFiring(local);

    
    if (!isFiring && isHooked) {

   Unhook(fireOffset);
Unhook(noRecoilAddr);
        isHooked = false;
        return;
    }

  
    if (isFiring) {
        void* enemy = GetClosestEnemy();
        if (!enemy || game_sdk->GetHp(enemy) <= 0) return;

        if (!isHooked) {
            void* addr[] = { fireOffset, noRecoilAddr };
            void* func[] = { (void*)bitch, (void*)NoRecoil };
            hook(addr, func, 2);
            isHooked = true;
        }
    }
}

void NoRecoilHook() {
    static bool isHooked = false;
    // Throttle — reavalia a cada 30 frames (~2x/s em 60fps)
    static int _nrThrottle = 0;
    if (++_nrThrottle < 30) return;
    _nrThrottle = 0;

    void* noRecoilAddr = (void*)getRealOffset(ENCRYPTOFFSET("0x105174020"));

    if (!NoRecoilEnabled) {
        if (isHooked) {
            Unhook(noRecoilAddr);
            isHooked = false;
        }
        return;
    }

    if (!isHooked) {
        void* addr[] = { noRecoilAddr };
        void* func[] = { (void*)NoRecoil };
        hook(addr, func, 1);
        isHooked = true;
    }
}

void PullEnemiesToPlayer() {
    if (!Vars.Enable || !Vars.tele10)
        return;
    // Throttle — roda a cada 10 frames (~6x/s em 60fps)
    static int _pullThrottle = 0;
    if (++_pullThrottle < 10) return;
    _pullThrottle = 0;

    void *match = game_sdk->Curent_Match();
    if (!match) return;

    void *local = game_sdk->GetLocalPlayer(match);
    if (!local || !game_sdk->Component_GetTransform(local)) return;

    Dictionary<uint8_t *, void **> *players = *(Dictionary<uint8_t *, void **> **)((long)match + 0x148);
    if (!players) return;

    void *localTF = game_sdk->Component_GetTransform(local);
    Vector3 localPos = getPosition(localTF);
    Vector3 forward = game_sdk->GetForward(localTF);

    for (int i = 0; i < players->getSize(); i++) {
        void *enemy = players->getValues()[i];
        if (!enemy || enemy == local) continue;
        if (!game_sdk->Component_GetTransform(enemy)) continue;
        if (!game_sdk->get_MaxHP(enemy)) continue;
        if (game_sdk->get_IsDieing(enemy)) continue;
        if (game_sdk->GetHp(enemy) <= 0) continue;
        if (game_sdk->get_isLocalTeam(enemy)) continue;

        void *enemyTF = game_sdk->Component_GetTransform(enemy);
        Vector3 enemyPos = getPosition(enemyTF);
        float distance = Vector3::Distance(localPos, enemyPos);

        if (distance > 8.0f)
            continue;

        
        Vector3 stableFront = localPos + forward * 1.2f;
        stableFront.y = localPos.y; // 

        Transform_INTERNAL_SetPosition(enemyTF, Vvector3(stableFront.x, stableFront.y, stableFront.z));
    }
}
void UpOneEnemy() {
    if (!Vars.Enable || !Vars.UpPlayerOne)
        return;
    // Throttle — roda a cada 6 frames
    static int _upThrottle = 0;
    if (++_upThrottle < 6) return;
    _upThrottle = 0;

    void *match = game_sdk->Curent_Match();
    if (!match) return;

    void *local = game_sdk->GetLocalPlayer(match);
    if (!local || !game_sdk->Component_GetTransform(local)) return;

    Dictionary<uint8_t *, void **> *players = *(Dictionary<uint8_t *, void **> **)((long)match + 0x148);
    if (!players) return;

    // Limpa cache de ground Y se a partida mudou
    static void* s_lastMatch = nullptr;
    static std::unordered_map<void*, float> s_groundY;
    if (match != s_lastMatch) {
        s_groundY.clear();
        s_lastMatch = match;
    }

    for (int i = 0; i < players->getSize(); i++) {
        void *enemy = players->getValues()[i];
        if (!enemy || enemy == local) continue;
        if (!game_sdk->Component_GetTransform(enemy)) continue;
        if (!game_sdk->get_MaxHP(enemy)) continue;
        if (game_sdk->get_IsDieing(enemy)) continue;
        if (game_sdk->GetHp(enemy) <= 0) continue;
        if (game_sdk->get_isLocalTeam(enemy)) continue;

        void *enemyTF = game_sdk->Component_GetTransform(enemy);
        if (!enemyTF) continue;

        Vector3 enemyPos = getPosition(enemyTF);

        // Eleva o inimigo até 5.7m acima do chão original — sem drift
        auto it = s_groundY.find(enemy);
        if (it == s_groundY.end()) {
            s_groundY[enemy] = enemyPos.y;
            it = s_groundY.find(enemy);
        }
        float groundY = it->second;
        float targetY = groundY + 5.7f;

        if (enemyPos.y < targetY - 0.05f)
            enemyPos.y = std::min(enemyPos.y + 0.90f, targetY);
        else if (enemyPos.y > targetY + 0.05f)
            enemyPos.y = targetY;

        Transform_INTERNAL_SetPosition(enemyTF, Vvector3(enemyPos.x, enemyPos.y, enemyPos.z));
    }
}

void ProcessAimbot() {
    if (!Vars.Aimbot)
        return;
    void *CurrentMatch = game_sdk->Curent_Match();
    if (!CurrentMatch)
        return;
    void *LocalPlayer = game_sdk->GetLocalPlayer(CurrentMatch);
    if (!LocalPlayer || !game_sdk->Component_GetTransform(LocalPlayer))
        return;
    void *closestEnemy = GetClosestEnemy();
    if (!closestEnemy || !game_sdk->Component_GetTransform(closestEnemy))
        return;
    Vector3 EnemyLocation = GetHitboxPosition(closestEnemy, Vars.AimHitbox);
    if (EnemyLocation == Vector3::zero())
        return;
    Vector3 PlayerLocation = CameraMain(LocalPlayer);
    if (PlayerLocation == Vector3::zero())
        return;
    bool IsScopeOn = game_sdk->get_IsSighting(LocalPlayer);
    bool IsFiring = game_sdk->get_IsFiring(LocalPlayer);
    bool shouldAim =
        (Vars.AimWhen == 0) ||                          
        (Vars.AimWhen == 1 && IsFiring) ||              
        (Vars.AimWhen == 2 && IsScopeOn) ||             
        (Vars.AimWhen == 3 && (IsFiring || IsScopeOn)); 
    if (shouldAim) {
        // SEMPRE verifica se o inimigo está visível (não está atrás de paredes)
        if (!tanghinh::isVisible(closestEnemy)) {
            return; // Se não está visível, não mira
        }
        
        Quaternion TargetLook = GetRotationToTheLocation(EnemyLocation, 0.05f, PlayerLocation);
        game_sdk->set_aim(LocalPlayer, TargetLook);
    }
   }
void get_players() {
    if (!Vars.Enable) return;

    ImDrawList* dl = ImGui::GetBackgroundDrawList();
    if (!dl) return;

    // Atualiza caches periodicamente
    if (++g_visibilityFrameCounter >= 6)   { g_visibilityFrameCounter = 0; g_visibilityCache.clear(); }
    if (++g_nameCacheFrameCounter  >= 120)  { g_nameCacheFrameCounter  = 0; g_nameCache.clear(); }

    PullEnemiesToPlayer();
    UpOneEnemy();
    if (Vars.Aimbot) ProcessAimbot();

    void* match = game_sdk->Curent_Match();
    if (!match) return;
    void* local = game_sdk->GetLocalPlayer(match);
    if (!local) return;

    // Lê o dictionary sem alocar vector — acessa entries diretamente
    Dictionary<uint8_t*, void**>* dict =
        *(Dictionary<uint8_t*, void**>**)((long)match + 0x148);
    if (!dict) return;

    void* cam = game_sdk->get_camera();
    if (!cam) return;

    float W = ImGui::GetIO().DisplaySize.x;
    float H = ImGui::GetIO().DisplaySize.y;
    ImVec2 screenCenter(W * 0.5f, H * 0.5f);

    Vector3 localPos = getPosition(local);
    int playerCount = 0;

    // Itera entries do dictionary diretamente sem getValues()
    auto entries = dict->entries;
    if (!entries) return;
    int entryCount = dict->count;

    for (int u = 0; u < entryCount; u++) {
        void* enemy = (void*)entries->toCPPlist()[u].value;
        if (!enemy || enemy == local) continue;
        if (!game_sdk->Component_GetTransform(enemy)) continue;
        if (!game_sdk->get_MaxHP(enemy)) continue;
        if (game_sdk->get_isLocalTeam(enemy)) continue;

        Vector3 pos = getPosition(enemy);
        float dist  = Vector3::Distance(localPos, pos);
        if (dist > 200.0f) continue;

        playerCount++;

        bool isDead    = game_sdk->get_IsDieing(enemy);
        bool isVisible = GetVisibilityCached(enemy);

        // Calcula posições 2D — apenas 2 chamadas W2S por player
        ImVec2 sFeet, sHead;
        bool inScreen = W2S(pos, sFeet) && W2S(pos + Vector3(0, 1.6f, 0), sHead);
        if (!inScreen) {
            // OOF (fora de tela)
            if (Vars.OOF) {
                ImVec2 dummy;
                bool w2sc = W2S(pos, dummy);
                if (!w2sc) {
                    Vector3 viewdir  = game_sdk->GetForward(game_sdk->Component_GetTransform(cam));
                    Vector3 targetdir = Vector3::Normalized(pos - game_sdk->get_position(game_sdk->Component_GetTransform(cam)));
                    float vA = atan2(viewdir.z,  viewdir.x)  * Rad2Deg;
                    float tA = atan2(targetdir.z, targetdir.x) * Rad2Deg;
                    if (vA < 0) vA += 360; if (tA < 0) tA += 360;
                    float angle = fmodf(360 - (tA - vA) - 90 + 720, 360);
                    float size = 3.5f;
                    OtFovV1(screenCenter.x, screenCenter.y, 90 + dist * 2,
                            angle - size, angle + size,
                            ImColor(1.f, 1.f, 1.f, 0.8f), 1);
                }
            }
            continue;
        }

        ImColor espCol = isDead    ? ImColor(255, 0, 0)
                       : isVisible ? ImColor(colorESPVisible)
                                   : ImColor(colorESPInvisible);

        float boxH = fabsf(sFeet.y - sHead.y);
        float boxW = boxH * 0.35f;
        ImVec2 boxMin(sHead.x - boxW, sHead.y);
        ImVec2 boxMax(sHead.x + boxW, sFeet.y);

        // Linha para o inimigo
        if (Vars.lines) {
            ImVec2 origin = (Vars.LineStyle == 0)
                ? ImVec2(screenCenter.x, 0)
                : ImVec2(screenCenter.x, H);
            dl->AddLine(origin, sHead, espCol, 1.0f);
        }

        // Box ESP — 1 chamada AddRect em vez de 4 AddLine
        if (Vars.Box) {
            if (Vars.BoxStyle == 0) {
                dl->AddRect(boxMin, boxMax, espCol, 0, 0, 1.0f);
                if (Vars.Outline)
                    dl->AddRect(boxMin - ImVec2(1,1), boxMax + ImVec2(1,1), IM_COL32(0,0,0,180), 0, 0, 1.0f);
            } else {
                // Corner box — 8 segmentos curtos
                float cx = boxW * 0.3f, cy = boxH * 0.3f;
                dl->AddLine(boxMin,                    {boxMin.x + cx, boxMin.y}, espCol, 1.0f);
                dl->AddLine(boxMin,                    {boxMin.x, boxMin.y + cy}, espCol, 1.0f);
                dl->AddLine({boxMax.x, boxMin.y},      {boxMax.x - cx, boxMin.y}, espCol, 1.0f);
                dl->AddLine({boxMax.x, boxMin.y},      {boxMax.x, boxMin.y + cy}, espCol, 1.0f);
                dl->AddLine({boxMin.x, boxMax.y},      {boxMin.x + cx, boxMax.y}, espCol, 1.0f);
                dl->AddLine({boxMin.x, boxMax.y},      {boxMin.x, boxMax.y - cy}, espCol, 1.0f);
                dl->AddLine(boxMax,                    {boxMax.x - cx, boxMax.y}, espCol, 1.0f);
                dl->AddLine(boxMax,                    {boxMax.x, boxMax.y - cy}, espCol, 1.0f);
            }
        }

        // Esqueleto
        if (Vars.skeleton) {
            ESP_DrawSkeleton(enemy, dl, espCol);
        }

        // Barra de saúde — sem chamadas Unity extras (usa HP já lido)
        if (Vars.Health) {
            int hp    = game_sdk->GetHp(enemy);
            int maxHp = game_sdk->get_MaxHP(enemy);
            float ratio = (maxHp > 0) ? ImClamp((float)hp / maxHp, 0.0f, 1.0f) : 0.0f;
            float barX = (Vars.HealthPosition == 0) ? boxMin.x - 5 : boxMax.x + 2;
            float filledY = boxMax.y - boxH * ratio;
            dl->AddRectFilled({barX, boxMin.y}, {barX + 3, boxMax.y}, IM_COL32(30, 30, 30, 200));
            ImU32 hpCol = ratio > 0.5f ? IM_COL32(0,220,0,255)
                        : ratio > 0.25f ? IM_COL32(220,180,0,255)
                        : IM_COL32(220,0,0,255);
            dl->AddRectFilled({barX, filledY}, {barX + 3, boxMax.y}, hpCol);
        }

        // Nome — cache de 120 frames
        if (Vars.Name) {
            const std::string& name = GetNameCached(enemy);
            ImVec2 tsz = verdana_smol->CalcTextSizeA(8.0f, FLT_MAX, 0, name.c_str());
            ImVec2 npos(sHead.x - tsz.x * 0.5f, sHead.y - tsz.y - 2);
            if (Vars.NameStyle == 0)
                dl->AddRectFilled(npos - ImVec2(1,1), npos + tsz + ImVec2(1,1), IM_COL32(0,0,0,100));
            AddText(verdana_smol, 8.0f, false, Vars.Outline, npos, espCol, name);
        }

        // Distância
        if (Vars.Distance) {
            char buf[16];
            snprintf(buf, sizeof(buf), "%dM", (int)dist);
            AddText(pixel_smol, 8.0f, false, true, {boxMax.x + 3, sHead.y}, ImColor(255, 255, 255), buf);
        }
    }

    // Contador de players
    if (Vars.counts && playerCount > 0) {
        char buf[8];
        snprintf(buf, sizeof(buf), "%d", playerCount);
        ImVec2 tsz = pixel_big->CalcTextSizeA(40.0f, FLT_MAX, 0, buf);
        ImVec2 tpos(screenCenter.x - tsz.x * 0.5f, 10);
        dl->AddText(pixel_big, 40.0f, tpos + ImVec2(1,1),  IM_COL32(0,0,0,255), buf);
        dl->AddText(pixel_big, 40.0f, tpos,                 IM_COL32(255,220,0,255), buf);
    }
}
void aimbot() {
    ImDrawList* draw_list = ImGui::GetBackgroundDrawList();
    if (!draw_list) return;

    // Linha para alvo mais próximo — usa cache de visibilidade
    if (Vars.line) {
        void* target = GetClosestEnemy();
        if (target) {
            Vector3 targetPos = GetHitboxPosition(target, Vars.AimHitbox);
            ImVec2 screenPos = Camera$$WorldToScreen::Regular(targetPos);
            ImVec2 center = ImVec2(ImGui::GetIO().DisplaySize.x / 2, ImGui::GetIO().DisplaySize.y / 2);
            draw_list->AddLine(center, screenPos, GetVisibilityCached(target) ? ImColor(0, 255, 0) : ImColor(255, 0, 0), 1.5f);
        }
    }

    // Círculo de FOV
    if (Vars.isAimFov && Vars.AimFov > 0.0f) {
        ImVec2 center = ImVec2(ImGui::GetIO().DisplaySize.x / 2, ImGui::GetIO().DisplaySize.y / 2);
        draw_list->AddCircle(center, Vars.AimFov, ImGui::ColorConvertFloat4ToU32(menuColor), 100, 2.0f);
    }

    // ProcessAimbot já foi chamado dentro de get_players() — não chama de novo aqui
}
