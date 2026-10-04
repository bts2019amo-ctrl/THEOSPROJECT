#ifndef OFFSETS_H
#define OFFSETS_H

// ═════════════════════════════════════════════════════════════
//  OFFSETS DO JOGO — Atualizados
// ═════════════════════════════════════════════════════════════

// Camera & Rendering
#define get_camera                  0x8CFF0B4
#define WorldToScreenPoint          0x8CFEA34
#define MainCameraTransform         0x3E8

// Transform & Components
#define Component_GetTransform      0x8D59C2C
#define get_position_sdk            0x8D6C1EC
#define Transform_SetPosition       0x8D6C2B4
#define GetForward                  0x8D6CBE4
#define get_gameObject              0x8D59C7C

// Match & Player
#define CurentMatch                 0x591B898
#define GetLocalPlayer              0x320FF7C
#define Match_Players               0x148

// Player Stats
#define GetHp                       0x56AA7C8
#define get_MaxHP                   0x5613110
#define get_IsDieing                0x561C768
#define get_IsFiring                0x56200F0
#define get_IsSighting              0x5629C84
#define get_isVisible               0x563B10C
#define get_isLocalTeam             0x5655F1C
#define name_Player                 0x5630F10

// Body Parts - Head
#define GetHeadTF                   0x56CA948
#define GetHeadPositions            0x56CA948
#define get_HeadCollider            0x5634F3C

// Body Parts - Arms
#define getLeftForeArmTF            0x5636120
#define getLeftHandTF               0x5635F18
#define getRightHandTF              0x563601C

// Body Parts - Legs
#define GetLeftAnkleTF              0x56CAF48
#define GetLeftToeTF                0x56CB160
#define GetRightAnkleTF             0x56CB054
#define GetRightToeTF               0x56CB280

// Body Parts - Core
#define _newHipMods                 0x56CAAF8

// Aimbot
#define set_aim                     0x5636F80

// Physics
#define Physics_Raycast             0x6396DE4

#endif /* OFFSETS_H */
