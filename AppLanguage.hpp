#pragma once
#include <string>

enum AppLanguage {
    AppLanguagePortuguese,
    AppLanguageEnglish,
    AppLanguageVietnamese,
    AppLanguageSpanish
};

extern AppLanguage currentLanguage;

std::string LocalizedString(const std::string& key);
