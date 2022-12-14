local BOM = BuffomatAddon ---@type BomAddon

---@class BomLanguagesModule
local languagesModule = BuffomatModule.New("Languages") ---@type BomLanguagesModule

local buffomatModule = BuffomatModule.Import("Buffomat") ---@type BomBuffomatModule
local englishModule = BuffomatModule.Import("LanguageEnglish") ---@type BomLanguageEnglishModule
local germanModule = BuffomatModule.Import("LanguageGerman") ---@type BomLanguageGermanModule
local frenchModule = BuffomatModule.Import("LanguageFrench") ---@type BomLanguageFrenchModule
local russianModule = BuffomatModule.Import("LanguageRussian") ---@type BomLanguageRussianModule
local chineseModule = BuffomatModule.Import("LanguageChinese") ---@type BomLanguageChineseModule

local L = setmetatable({}, { __index = function(t, k)
  if BOM.L and BOM.L[k] then
    return BOM.L[k]
  else
    return "[" .. k .. "]"
  end
end })

setmetatable(languagesModule, {
  __call = function(_, k)
    if BOM.L and BOM.L[k] then
      return BOM.L[k] or ("¶" .. k)
    else
      return "¶" .. k
    end
  end
})

function languagesModule:SetupTranslations()
  -- Always add english and add one language that is supported and is current
  BOM.locales = {
    enEN = englishModule:Translations(),
  }

  local currentLang = GetLocale()

  if currentLang == "deDE" then
    BOM.locales.deDE = germanModule:Translations()
  end
  if currentLang == "frFR" then
    BOM.locales.frFR = frenchModule:Translations()
  end

  if currentLang == "ruRU" then
    BOM.locales.ruRU = russianModule:Translations()
  end

  if currentLang == "zhCN" then
    BOM.locales.zhCN = chineseModule:Translations()
  end

  BOM.L = BOM.locales[GetLocale()] or {}
  setmetatable(BOM.L, {
    __index = BOM.locales["enEN"]
  })
  BOM.L.AboutCredits = "nanjuekaien1 & wellcat for the Chinese translation|n" ..
          "OlivBEL for the french translation|n" ..
          "Arrogant_Dreamer & kvakvs for the russian translation|n"
end

function languagesModule:LocalizationInit()
  if buffomatModule.shared and buffomatModule.shared.CustomLocales then
    for key, value in pairs(buffomatModule.shared.CustomLocales) do
      if value ~= nil and value ~= "" then
        BOM.L[key .. "_org"] = BOM.L[key]
        BOM.L[key] = value
      end
    end
  end
end
