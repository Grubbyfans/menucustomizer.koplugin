-- v1.1: renamed the English plugin name from "Menu settings" to "Menu customizer".
-- v1.0: localized plugin metadata (en/uk via tr/trn).

-- ── Localization (zh/en/uk) ─────────────────────────────────────────
-- Language is read from G_reader_settings:readSetting("language").
-- KOReader leaves "language" unset when the UI is in its default English;
-- in that case this plugin defaults to Chinese so Chinese users see Chinese
-- without having to switch KOReader's whole UI language first.
--   "zh*" / unset -> Chinese (simplified)
--   "uk*"         -> Ukrainian
--   explicit "en*"/"C" -> English
local function get_ui_language()
    local lang = G_reader_settings and G_reader_settings:readSetting("language")
    if type(lang) == "string" and lang ~= "" then
        return lang
    end
    return "zh"
end

local function is_uk_language()
    return get_ui_language():sub(1, 2) == "uk"
end

local function is_zh_language()
    return get_ui_language():sub(1, 2) == "zh"
end

--- Pick the Chinese / Ukrainian / English variant of a string.
local function tr(en, uk, zh)
    if is_uk_language() then
        return uk or en
    elseif is_zh_language() then
        return zh or en
    end
    return en
end

--- Ukrainian-aware plural selection (kept for plural strings).
local function trn(n, en1, enN, uk1, ukFew, ukMany)
    if is_uk_language() then
        local n10 = n % 10
        local n100 = n % 100
        if n10 == 1 and n100 ~= 11 then
            return uk1
        elseif n10 >= 2 and n10 <= 4 and (n100 < 12 or n100 > 14) then
            return ukFew
        else
            return ukMany
        end
    end
    return (n == 1) and en1 or enN
end

return {
    fullname = tr("Menu customizer", "Налаштування меню", "菜单自定义"),
    description = tr(
        "Shows the full menu hierarchy for reader and file browser modes. Allows disabling individual tabs, submenus and menu items. Generates custom menu order files in the settings directory.",
        "Відображає повну ієрархію меню для режимів читання та оглядача файлів. Дозволяє вимикати окремі вкладки, підменю та пункти меню. Створює файли кастомного порядку меню в теці налаштувань.",
        "显示阅读器和文件浏览器模式的完整菜单层级，可禁用单个标签页、子菜单和菜单项，并在设置目录中生成自定义菜单顺序文件。"),
}
