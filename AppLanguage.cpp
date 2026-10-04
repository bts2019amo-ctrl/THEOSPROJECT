#include "AppLanguage.hpp"
#include "oxorany/oxorany_include.h"

AppLanguage currentLanguage = AppLanguagePortuguese;

static const char* GetCurrentLang(const std::string& key) {
    if (currentLanguage == AppLanguageEnglish) {
        if (key == oxorany("Fix Login")) return oxorany("Fix Login");
        if (key == oxorany("Idioma")) return oxorany("Language");
        if (key == oxorany("Português")) return oxorany("Portuguese");
        if (key == oxorany("Inglês")) return oxorany("English");
        if (key == oxorany("Vietnamita")) return oxorany("Vietnamese");
        if (key == oxorany("Espanhol")) return oxorany("Spanish");

        if (key == oxorany("AIMBOT")) return oxorany("AIMBOT");
        if (key == oxorany("VISUAIS")) return oxorany("VISUALS");
        if (key == oxorany("ARMA")) return oxorany("WEAPON");
        if (key == oxorany("MISC")) return oxorany("MISC");
        if (key == oxorany("AJUSTES")) return oxorany("SETTINGS");
        if (key == oxorany("CONTA")) return oxorany("ACCOUNT");
        if (key == oxorany("Estilo:")) return oxorany("Style:");
        if (key == oxorany("Posição:")) return oxorany("Position:");
        if (key == oxorany("Tipo de Aimbot:")) return oxorany("Aimbot Type:");
        if (key == oxorany("Esconder Painel")) return oxorany("Hide Panel");
        if (key == oxorany("PAINEL FFH4X @granjeiroff")) return oxorany("FFH4X PANEL @granjeiroff");

        if (key == oxorany("                          PAINEL FFH4X @granjeiroff")) return oxorany("                          FFH4X PANEL @granjeiroff");
        if (key == oxorany("Ativar Aimbot")) return oxorany("Enable Aimbot");
        if (key == oxorany("Puxar em Paredes")) return oxorany("Pull Through Walls");
        if (key == oxorany("Exibir FOV")) return oxorany("Show FOV");
        if (key == oxorany("Exibir Linha")) return oxorany("Show Line");
        if (key == oxorany("Regular Fov")) return oxorany("Adjust FOV");
        if (key == oxorany("Puxada")) return oxorany("Pull");
        if (key == oxorany(" Cabeça")) return oxorany(" Head");
        if (key == oxorany(" Pescoço")) return oxorany(" Neck");
        if (key == oxorany(" Corpo")) return oxorany(" Body");
        if (key == oxorany("Ao Atirar")) return oxorany("When Shooting");
        if (key == oxorany("Ao Olhar")) return oxorany("When Looking");

        if (key == oxorany("Ativar ESP")) return oxorany("Enable ESP");
        if (key == oxorany("ESP Linha")) return oxorany("ESP Line");
        if (key == oxorany(" Cima")) return oxorany(" Top");
        if (key == oxorany(" Baixo")) return oxorany(" Bottom");
        if (key == oxorany("ESP Caixa")) return oxorany("ESP Box");
        if (key == oxorany(" Redondo")) return oxorany(" Round");
        if (key == oxorany(" Cornered")) return oxorany(" Cornered");
        if (key == oxorany("ESP Nome")) return oxorany("ESP Name");
        if (key == oxorany(" Com Sombra")) return oxorany(" With Shadow");
        if (key == oxorany(" Sem Sombra")) return oxorany(" Without Shadow");
        if (key == oxorany("ESP Vida")) return oxorany("ESP Health");
        if (key == oxorany(" Esquerda")) return oxorany(" Left");
        if (key == oxorany(" Direita")) return oxorany(" Right");
        if (key == oxorany("ESP Esqueleto")) return oxorany("ESP Skeleton");

        if (key == oxorany("Funções Rage")) return oxorany("Rage Features");
        if (key == oxorany("Teleport 8m")) return oxorany("Teleport 8m");
        if (key == oxorany("Voar Player")) return oxorany("Fly Player");
        if (key == oxorany("Guest")) return oxorany("Guest");
        if (key == oxorany("Speed")) return oxorany("Speed");
        if (key == oxorany("No Recoil")) return oxorany("No Recoil");
        if (key == oxorany("AimSilent")) return oxorany("AimSilent");
        if (key == oxorany("  Personalização")) return oxorany("  Customization");
        if (key == oxorany("Cor do Menu")) return oxorany("Menu Color");
        if (key == oxorany("Cor da ESP Visível")) return oxorany("Visible ESP Color");
        if (key == oxorany("Cor da ESP Invisível")) return oxorany("Invisible ESP Color");

        if (key == oxorany("Use com cautela")) return oxorany("Use with caution");
        if (key == oxorany("Kiểu:")) return oxorany("Style:");
        if (key == oxorany("Vị trí:")) return oxorany("Position:");
        if (key == oxorany("Loại Aimbot:")) return oxorany("Aimbot Type:");
        if (key == oxorany("Ẩn bảng điều khiển")) return oxorany("Hide Panel");
        if (key == oxorany("BẢNG ĐIỀU KHIỂN FFH4X @granjeiroff")) return oxorany("FFH4X PANEL @granjeiroff");
    } else if (currentLanguage == AppLanguageVietnamese) {
        if (key == oxorany("Fix Login")) return oxorany("Sửa đăng nhập");
        if (key == oxorany("Idioma")) return oxorany("Ngôn ngữ");
        if (key == oxorany("Português")) return oxorany("Tiếng Bồ Đào Nha");
        if (key == oxorany("Inglês")) return oxorany("Tiếng Anh");
        if (key == oxorany("Vietnamita")) return oxorany("Tiếng Việt");
        if (key == oxorany("Espanhol")) return oxorany("Tiếng Tây Ban Nha");

        if (key == oxorany("AIMBOT")) return oxorany("AIMBOT");
        if (key == oxorany("VISUAIS")) return oxorany("HÌNH ẢNH");
        if (key == oxorany("ARMA")) return oxorany("VŨ KHÍ");
        if (key == oxorany("MISC")) return oxorany("KHÁC");
        if (key == oxorany("AJUSTES")) return oxorany("CÀI ĐẶT");
        if (key == oxorany("CONTA")) return oxorany("TÀI KHOẢN");

        if (key == oxorany("                          PAINEL FFH4X @granjeiroff")) return oxorany("                          BẢNG ĐIỀU KHIỂN FFH4X @granjeiroff");
        if (key == oxorany("Ativar Aimbot")) return oxorany("Bật Aimbot");
        if (key == oxorany("Puxar em Paredes")) return oxorany("Kéo qua tường");
        if (key == oxorany("Exibir FOV")) return oxorany("Hiển thị FOV");
        if (key == oxorany("Exibir Linha")) return oxorany("Hiển thị đường kẻ");
        if (key == oxorany("Regular Fov")) return oxorany("Điều chỉnh FOV");
        if (key == oxorany("Puxada")) return oxorany("Kéo");
        if (key == oxorany(" Cabeça")) return oxorany(" Đầu");
        if (key == oxorany(" Pescoço")) return oxorany(" Cổ");
        if (key == oxorany(" Corpo")) return oxorany(" Thân");
        if (key == oxorany("Ao Atirar")) return oxorany("Khi bắn");
        if (key == oxorany("Ao Olhar")) return oxorany("Khi nhìn");

        if (key == oxorany("Ativar ESP")) return oxorany("Bật ESP");
        if (key == oxorany("ESP Linha")) return oxorany("Đường ESP");
        if (key == oxorany(" Cima")) return oxorany(" Trên");
        if (key == oxorany(" Baixo")) return oxorany(" Dưới");
        if (key == oxorany("ESP Caixa")) return oxorany("Hộp ESP");
        if (key == oxorany(" Redondo")) return oxorany(" Tròn");
        if (key == oxorany("ESP Nome")) return oxorany("Tên ESP");
        if (key == oxorany(" Com Sombra")) return oxorany(" Có bóng");
        if (key == oxorany(" Sem Sombra")) return oxorany(" Không bóng");
        if (key == oxorany("ESP Vida")) return oxorany("Máu ESP");
        if (key == oxorany(" Esquerda")) return oxorany(" Trái");
        if (key == oxorany(" Direita")) return oxorany(" Phải");
        if (key == oxorany("ESP Esqueleto")) return oxorany("Khung xương ESP");

        if (key == oxorany("Funções Rage")) return oxorany("Chức năng Rage");
        if (key == oxorany("Teleport 8m")) return oxorany("Dịch chuyển 8m");
        if (key == oxorany("Voar Player")) return oxorany("Bay người chơi");
        if (key == oxorany("Guest")) return oxorany("Khách");
        if (key == oxorany("Speed")) return oxorany("Tốc độ");
        if (key == oxorany("No Recoil")) return oxorany("Không giật");
        if (key == oxorany("AimSilent")) return oxorany("AimSilent");
        if (key == oxorany("  Personalização")) return oxorany("  Tùy chỉnh");
        if (key == oxorany("Cor do Menu")) return oxorany("Màu menu");
        if (key == oxorany("Cor da ESP Visível")) return oxorany("Màu ESP thấy được");
        if (key == oxorany("Cor da ESP Invisível")) return oxorany("Màu ESP ẩn");

        if (key == oxorany("Use com cautela")) return oxorany("Sử dụng cẩn thận");
        if (key == oxorany("Kiểu:")) return oxorany("Kiểu:");
        if (key == oxorany("Vị trí:")) return oxorany("Vị trí:");
        if (key == oxorany("Loại Aimbot:")) return oxorany("Loại Aimbot:");
        if (key == oxorany("Ẩn bảng điều khiển")) return oxorany("Ẩn bảng điều khiển");
        if (key == oxorany("BẢNG ĐIỀU KHIỂN FFH4X @granjeiroff")) return oxorany("BẢNG ĐIỀU KHIỂN FFH4X @granjeiroff");
    } else if (currentLanguage == AppLanguageSpanish) {
        if (key == oxorany("Fix Login")) return oxorany("Arreglar inicio de sesión");
        if (key == oxorany("Idioma")) return oxorany("Idioma");
        if (key == oxorany("Português")) return oxorany("Portugués");
        if (key == oxorany("Inglês")) return oxorany("Inglés");
        if (key == oxorany("Vietnamita")) return oxorany("Vietnamita");
        if (key == oxorany("Espanhol")) return oxorany("Español");

        if (key == oxorany("AIMBOT")) return oxorany("AIMBOT");
        if (key == oxorany("VISUAIS")) return oxorany("VISUALES");
        if (key == oxorany("ARMA")) return oxorany("ARMA");
        if (key == oxorany("MISC")) return oxorany("VARIOS");
        if (key == oxorany("AJUSTES")) return oxorany("AJUSTES");
        if (key == oxorany("CONTA")) return oxorany("CUENTA");

        if (key == oxorany("                          PAINEL FFH4X @granjeiroff")) return oxorany("                          PANEL FFH4X @granjeiroff");
        if (key == oxorany("Ativar Aimbot")) return oxorany("Activar Aimbot");
        if (key == oxorany("Puxar em Paredes")) return oxorany("Jalar por paredes");
        if (key == oxorany("Exibir FOV")) return oxorany("Mostrar FOV");
        if (key == oxorany("Exibir Linha")) return oxorany("Mostrar línea");
        if (key == oxorany("Regular Fov")) return oxorany("Ajustar FOV");
        if (key == oxorany("Puxada")) return oxorany("Jalón");
        if (key == oxorany(" Cabeça")) return oxorany(" Cabeza");
        if (key == oxorany(" Pescoço")) return oxorany(" Cuello");
        if (key == oxorany(" Corpo")) return oxorany(" Cuerpo");
        if (key == oxorany("Ao Atirar")) return oxorany("Al disparar");
        if (key == oxorany("Ao Olhar")) return oxorany("Al apuntar");

        if (key == oxorany("Ativar ESP")) return oxorany("Activar ESP");
        if (key == oxorany("ESP Linha")) return oxorany("Línea ESP");
        if (key == oxorany(" Cima")) return oxorany(" Arriba");
        if (key == oxorany(" Baixo")) return oxorany(" Abajo");
        if (key == oxorany("ESP Caixa")) return oxorany("Caja ESP");
        if (key == oxorany(" Redondo")) return oxorany(" Redondo");
        if (key == oxorany("ESP Nome")) return oxorany("Nombre ESP");
        if (key == oxorany(" Com Sombra")) return oxorany(" Con sombra");
        if (key == oxorany(" Sem Sombra")) return oxorany(" Sin sombra");
        if (key == oxorany("ESP Vida")) return oxorany("Salud ESP");
        if (key == oxorany(" Esquerda")) return oxorany(" Izquierda");
        if (key == oxorany(" Direita")) return oxorany(" Derecha");
        if (key == oxorany("ESP Esqueleto")) return oxorany("Esqueleto ESP");

        if (key == oxorany("Funções Rage")) return oxorany("Funciones Rage");
        if (key == oxorany("Teleport 8m")) return oxorany("Teletransporte 8m");
        if (key == oxorany("Voar Player")) return oxorany("Volar jugador");
        if (key == oxorany("Guest")) return oxorany("Invitado");
        if (key == oxorany("Speed")) return oxorany("Velocidad");
        if (key == oxorany("No Recoil")) return oxorany("Sin retroceso");
        if (key == oxorany("AimSilent")) return oxorany("AimSilent");
        if (key == oxorany("  Personalização")) return oxorany("  Personalización");
        if (key == oxorany("Cor do Menu")) return oxorany("Color del menú");
        if (key == oxorany("Cor da ESP Visível")) return oxorany("Color ESP visible");
        if (key == oxorany("Cor da ESP Invisível")) return oxorany("Color ESP invisible");

        if (key == oxorany("Use com cautela")) return oxorany("Usar con precaución");
        if (key == oxorany("Kiểu:")) return oxorany("Estilo:");
        if (key == oxorany("Vị trí:")) return oxorany("Posición:");
        if (key == oxorany("Loại Aimbot:")) return oxorany("Tipo de Aimbot:");
        if (key == oxorany("Ẩn bảng điều khiển")) return oxorany("Ocultar panel");
        if (key == oxorany("BẢNG ĐIỀU KHIỂN FFH4X @granjeiroff")) return oxorany("PANEL FFH4X @granjeiroff");
    }

    return key.c_str();
}

std::string LocalizedString(const std::string& key) {
    const char* result = GetCurrentLang(key);
    return std::string(result);
}
