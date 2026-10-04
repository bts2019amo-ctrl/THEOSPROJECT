#ifndef GAMESDK_H
#define GAMESDK_H

#include <mach-o/dyld.h>
#include <cmath>
#include <cstring>
#include "offsets.h"
#include "Helper/Vector3.h"
#include "Helper/Vector2.h"
#include "Helper/Quaternion.h"
#include "Helper/Mem.h"
#include <vector>

// Forward declaration
struct Vars_t {
    bool Aimbot;
    bool IgnoreKnocked;
    bool VisibleCheck;
    bool isAimFov;
    float AimFov;
    int AimWhen;
    int AimHitbox;
    bool tele10;
    bool UpPlayerOne;
};

extern Vars_t Vars;

// ═════════════════════════════════════════════════════════════
//  Estruturas do Jogo
// ═════════════════════════════════════════════════════════════

struct Player {
    void* instance;
    void* transform;
    Vector3 position;
    Vector3 headPosition;
    float distance;
    float health;
    float maxHealth;
    bool isLocalTeam;
    bool isVisible;
    bool isDieing;
    bool isFiring;
    char name[64];
    
    Player() : instance(nullptr), transform(nullptr), 
               distance(0), health(0), maxHealth(0),
               isLocalTeam(false), isVisible(false), 
               isDieing(false), isFiring(false) {
        name[0] = '\0';
    }
};

struct Camera {
    void* instance;
    void* transform;
};

// ═════════════════════════════════════════════════════════════
//  Classe SDK - Interface com o jogo
// ═════════════════════════════════════════════════════════════

class GameSDK {
public:
    // Inicialização
    void init() {
        baseAddress = _dyld_get_image_vmaddr_slide(0);
    }
    
    // ─────────────────────────────────────────────────────────
    //  Funções de Offset
    // ─────────────────────────────────────────────────────────
    
    uintptr_t GetOffset(uintptr_t offset) {
        return baseAddress + offset;
    }
    
    // ─────────────────────────────────────────────────────────
    //  Match & Player
    // ─────────────────────────────────────────────────────────
    
    void* Curent_Match() {
        uintptr_t addr = GetOffset(CurentMatch);
        return *(void**)addr;
    }
    
    void* GetLocalPlayer(void* match) {
        if (!match) return nullptr;
        
        typedef void* (*GetLocalPlayer_t)(void*);
        GetLocalPlayer_t func = (GetLocalPlayer_t)GetOffset(GetLocalPlayer);
        return func(match);
    }
    
    std::vector<void*> GetAllPlayers(void* match) {
        std::vector<void*> players;
        if (!match) return players;
        
        uintptr_t playersList = *(uintptr_t*)((uintptr_t)match + Match_Players);
        if (!playersList) return players;
        
        // Lista de jogadores (Array da Unity)
        int count = *(int*)(playersList + 0x18);
        uintptr_t items = *(uintptr_t*)(playersList + 0x10);
        
        for (int i = 0; i < count && i < 100; i++) {
            void* player = *(void**)(items + (i * 0x8));
            if (player) {
                players.push_back(player);
            }
        }
        
        return players;
    }
    
    // ─────────────────────────────────────────────────────────
    //  Transform
    // ─────────────────────────────────────────────────────────
    
    void* Component_GetTransform(void* component) {
        if (!component) return nullptr;
        
        typedef void* (*GetTransform_t)(void*);
        GetTransform_t func = (GetTransform_t)GetOffset(Component_GetTransform);
        return func(component);
    }
    
    Vector3 Transform_GetPosition(void* transform) {
        Vector3 result = {0, 0, 0};
        if (!transform) return result;
        
        typedef Vector3 (*GetPosition_t)(void*);
        GetPosition_t func = (GetPosition_t)GetOffset(get_position_sdk);
        return func(transform);
    }
    
    void Transform_SetPosition(void* transform, Vector3 position) {
        if (!transform) return;
        
        typedef void (*SetPosition_t)(void*, Vector3);
        SetPosition_t func = (SetPosition_t)GetOffset(Transform_SetPosition);
        func(transform, position);
    }
    
    // ─────────────────────────────────────────────────────────
    //  Player Info
    // ─────────────────────────────────────────────────────────
    
    float GetPlayerHealth(void* player) {
        if (!player) return 0.0f;
        
        typedef float (*GetHp_t)(void*);
        GetHp_t func = (GetHp_t)GetOffset(GetHp);
        return func(player);
    }
    
    float GetPlayerMaxHealth(void* player) {
        if (!player) return 0.0f;
        
        typedef float (*GetMaxHP_t)(void*);
        GetMaxHP_t func = (GetMaxHP_t)GetOffset(get_MaxHP);
        return func(player);
    }
    
    bool IsPlayerDieing(void* player) {
        if (!player) return false;
        
        typedef bool (*IsDieing_t)(void*);
        IsDieing_t func = (IsDieing_t)GetOffset(get_IsDieing);
        return func(player);
    }
    
    bool IsPlayerVisible(void* player) {
        if (!player) return false;
        
        typedef bool (*IsVisible_t)(void*);
        IsVisible_t func = (IsVisible_t)GetOffset(get_isVisible);
        return func(player);
    }
    
    bool IsPlayerLocalTeam(void* player) {
        if (!player) return false;
        
        typedef bool (*IsLocalTeam_t)(void*);
        IsLocalTeam_t func = (IsLocalTeam_t)GetOffset(get_isLocalTeam);
        return func(player);
    }
    
    const char* GetPlayerName(void* player) {
        if (!player) return "";
        
        typedef void* (*GetName_t)(void*);
        GetName_t func = (GetName_t)GetOffset(name_Player);
        void* nameObj = func(player);
        
        if (!nameObj) return "";
        
        // MonoString - pega o conteúdo
        return (const char*)((uintptr_t)nameObj + 0x14);
    }
    
    // ─────────────────────────────────────────────────────────
    //  Body Parts
    // ─────────────────────────────────────────────────────────
    
    void* GetHeadTransform(void* player) {
        if (!player) return nullptr;
        
        typedef void* (*GetHeadTF_t)(void*);
        GetHeadTF_t func = (GetHeadTF_t)GetOffset(GetHeadTF);
        return func(player);
    }
    
    Vector3 GetHeadPosition(void* player) {
        void* headTF = GetHeadTransform(player);
        if (!headTF) return {0, 0, 0};
        
        return Transform_GetPosition(headTF);
    }
    
    // ─────────────────────────────────────────────────────────
    //  Camera
    // ─────────────────────────────────────────────────────────
    
    void* GetMainCamera() {
        typedef void* (*GetCamera_t)();
        GetCamera_t func = (GetCamera_t)GetOffset(get_camera);
        return func();
    }
    
    void* GetCameraTransform(void* camera) {
        if (!camera) return nullptr;
        return *(void**)((uintptr_t)camera + MainCameraTransform);
    }
    
    Vector2 WorldToScreen(Vector3 worldPos) {
        Vector2 result = {-1, -1};
        
        void* camera = GetMainCamera();
        if (!camera) return result;
        
        typedef Vector3 (*WorldToScreen_t)(void*, Vector3, int);
        WorldToScreen_t func = (WorldToScreen_t)GetOffset(WorldToScreenPoint);
        
        Vector3 screenPos = func(camera, worldPos, 2);
        
        // Verifica se está na frente da câmera
        if (screenPos.z > 0.0f) {
            result.x = screenPos.x;
            result.y = screenPos.y;
        }
        
        return result;
    }
    
    // ─────────────────────────────────────────────────────────
    //  Aimbot
    // ─────────────────────────────────────────────────────────
    
    void SetAim(void* player, Vector3 targetPos) {
        if (!player) return;
        
        typedef void (*SetAim_t)(void*, Vector3);
        SetAim_t func = (SetAim_t)GetOffset(set_aim);
        func(player, targetPos);
    }
    
    // ─────────────────────────────────────────────────────────
    //  Raycast
    // ─────────────────────────────────────────────────────────
    
    bool Raycast(Vector3 origin, Vector3 direction, float maxDistance) {
        typedef bool (*Raycast_t)(Vector3, Vector3, float);
        Raycast_t func = (Raycast_t)GetOffset(Physics_Raycast);
        return func(origin, direction, maxDistance);
    }
    
private:
    uintptr_t baseAddress = 0;
};

// Instância global do SDK
static GameSDK* game_sdk = nullptr;

// ─────────────────────────────────────────────────────────────
//  Funções Globais de ESP e Aimbot
// ─────────────────────────────────────────────────────────────

std::vector<Player> g_players;
Player g_localPlayer;

void get_players() {
    g_players.clear();
    
    if (!game_sdk) return;
    
    void* match = game_sdk->Curent_Match();
    if (!match) return;
    
    void* localPlayer = game_sdk->GetLocalPlayer(match);
    if (!localPlayer) return;
    
    // Pega informação do jogador local
    g_localPlayer.instance = localPlayer;
    g_localPlayer.transform = game_sdk->Component_GetTransform(localPlayer);
    g_localPlayer.position = game_sdk->Transform_GetPosition(g_localPlayer.transform);
    
    // Pega todos os jogadores
    std::vector<void*> allPlayers = game_sdk->GetAllPlayers(match);
    
    for (void* playerPtr : allPlayers) {
        if (!playerPtr || playerPtr == localPlayer) continue;
        
        Player player;
        player.instance = playerPtr;
        player.transform = game_sdk->Component_GetTransform(playerPtr);
        
        if (!player.transform) continue;
        
        // Informações básicas
        player.position = game_sdk->Transform_GetPosition(player.transform);
        player.headPosition = game_sdk->GetHeadPosition(playerPtr);
        player.health = game_sdk->GetPlayerHealth(playerPtr);
        player.maxHealth = game_sdk->GetPlayerMaxHealth(playerPtr);
        player.isDieing = game_sdk->IsPlayerDieing(playerPtr);
        player.isVisible = game_sdk->IsPlayerVisible(playerPtr);
        player.isLocalTeam = game_sdk->IsPlayerLocalTeam(playerPtr);
        
        // Nome
        const char* name = game_sdk->GetPlayerName(playerPtr);
        if (name) {
            strncpy(player.name, name, sizeof(player.name) - 1);
            player.name[sizeof(player.name) - 1] = '\0';
        }
        
        // Distância
        Vector3 delta = {
            player.position.x - g_localPlayer.position.x,
            player.position.y - g_localPlayer.position.y,
            player.position.z - g_localPlayer.position.z
        };
        player.distance = sqrtf(delta.x * delta.x + delta.y * delta.y + delta.z * delta.z);
        
        g_players.push_back(player);
    }
}

void aimbot() {
    if (!Vars.Aimbot || !game_sdk) return;
    if (g_players.empty()) return;
    
    // Verifica condição de ativar aimbot
    bool shouldAim = false;
    if (Vars.AimWhen == 3) {
        // Ao atirar
        if (g_localPlayer.instance) {
            typedef bool (*IsFiring_t)(void*);
            IsFiring_t isFiring = (IsFiring_t)game_sdk->GetOffset(get_IsFiring);
            shouldAim = isFiring(g_localPlayer.instance);
        }
    } else if (Vars.AimWhen == 0) {
        // Sempre (ao olhar)
        shouldAim = true;
    }
    
    if (!shouldAim) return;
    
    // Encontra o melhor alvo
    Player* bestTarget = nullptr;
    float bestFov = Vars.isAimFov ? Vars.AimFov : 999999.0f;
    
    ImVec2 screenCenter(ImGui::GetIO().DisplaySize.x / 2, ImGui::GetIO().DisplaySize.y / 2);
    
    for (auto& player : g_players) {
        // Filtros
        if (Vars.IgnoreKnocked && player.isDieing) continue;
        if (player.isLocalTeam) continue;
        if (Vars.VisibleCheck && !player.isVisible) continue;
        
        // Posição do alvo baseado no hitbox escolhido
        Vector3 targetPos;
        if (Vars.AimHitbox == 0) {
            // Cabeça
            targetPos = player.headPosition;
        } else if (Vars.AimHitbox == 1) {
            // Peito
            targetPos = player.position;
            targetPos.y += 1.5f;
        } else {
            // Corpo
            targetPos = player.position;
        }
        
        // Converte para tela
        Vector2 screenPos = game_sdk->WorldToScreen(targetPos);
        if (screenPos.x < 0 || screenPos.y < 0) continue;
        
        // Calcula distância do crosshair
        float dx = screenPos.x - screenCenter.x;
        float dy = screenPos.y - screenCenter.y;
        float fov = sqrtf(dx * dx + dy * dy);
        
        if (fov < bestFov) {
            bestFov = fov;
            bestTarget = &player;
        }
    }
    
    // Aplica o aim no melhor alvo
    if (bestTarget && g_localPlayer.instance) {
        Vector3 targetPos;
        if (Vars.AimHitbox == 0) {
            targetPos = bestTarget->headPosition;
        } else if (Vars.AimHitbox == 1) {
            targetPos = bestTarget->position;
            targetPos.y += 1.5f;
        } else {
            targetPos = bestTarget->position;
        }
        
        game_sdk->SetAim(g_localPlayer.instance, targetPos);
    }
}

#endif /* GAMESDK_H */
