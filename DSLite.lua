local current_mod = SMODS.current_mod
local mod_path = SMODS.current_mod.path
local usable_path = mod_path:match("Mods/[^/]+")
local path_pattern_replace = usable_path:gsub("(%W)","%%%1")

local dsl = "DeckSkinsLite"
local ace_two = { "Ace", "King", "Queen", "Jack", "10", "9", "8", "7", "6", "5", "4", "3", "2"}
local two_ace = { "2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"}
local vanilla_suits = {'Hearts', 'Clubs', 'Diamonds', 'Spades'}

local isAllSuits = function(suit)
	if suit == "*" or suit:lower() == "a" or suit:lower() == "all" then return true else return false end
end

local SUITS = {}
for k, v in pairs(SMODS.Suits) do
	SUITS[v.card_key] = v.original_key
end

local suitConv = function(suit)
	for k, v in pairs(SUITS) do
		if k:lower() == suit:lower() or v:lower() == suit:lower() then return v end
	end
	return nil
end

local RANKS = {}
for k, v in pairs(SMODS.Ranks) do
	RANKS[v.shorthand] = v.original_key
end

local rankConv = function(rank)
	for k, v in pairs(RANKS) do
		if k:lower() == rank:lower() or v:lower() == rank:lower() then return v end
	end
	return nil
end

local LANGS = {}
for lang, tbl in pairs(G.LANGUAGES) do
	if not tbl.omit then
		table.insert(LANGS, lang)
	end
end

local function langInTable(lang, names)
	for skin_lang, lang_name in pairs(names) do
		if skin_lang == lang then
			return lang_name
		end
	end
	return nil
end

local function makeLocTXT(skin)
	local loc_txt = {}
	local names = skin.name
	if type(names) == 'string' then
		for _, lang in ipairs(LANGS) do
			loc_txt[lang] = names
		end
	elseif type(names) == 'table' then
		for _, lang in ipairs(LANGS) do
			local lang_name = langInTable(lang, names)
			if lang_name then
				loc_txt[lang] = lang_name
			end
		end
	end
	return loc_txt
end

local function reverse_table(table)
	local reversed = {}
	for i, v in ipairs(table) do
		reversed[i] = rankConv(v)
	end
	return reversed
end

local function findExistingKey(inputString, tbl)
	for key, value in pairs(tbl) do
		if key == inputString then
			return true
		end
	end
	return false
end

local function loadAtlas(atlas)
	if not findExistingKey(atlas.key, SMODS.Atlases) then
		SMODS.Atlas(atlas)
	end
end

local function loadOutdatedDeckSkin(atlases, deckskins)
	for i, v in ipairs(atlases) do
		loadAtlas(v)
	end
	for i, v in ipairs(deckskins) do
		SMODS.DeckSkin(v)
	end
end

local function assembleOutdatedDeckSkin(skin)
	local atlases = {}
	local deckskins = {}

	if not skin.texture then
		sendWarnMessage("Missing texture value for DeckSkin "..skin.id..". This DeckSkin will not be loaded.", dsl)
		return
	end

	local loc
	if skin.name then loc = makeLocTXT(skin) else loc = nil end
	local allSuits = false
	local suit = suitConv(skin.suit)
	if suit == nil then
		if isAllSuits(skin.suit) then
			allSuits = true
		else
			sendWarnMessage("Invalid suit value for DeckSkin "..skin.id..". This DeckSkin will not be loaded.", dsl)
			return
		end
	end
	local cards = skin.cards or two_ace
	for i, v in ipairs(cards) do
		cards[i] = rankConv(v)
	end

	atlases[#atlases+1] = {
		key = skin.id.."_1",
		path = skin.texture,
		px = 71,
		py = 95,
		atlas_table = 'ASSET_ATLAS',
	}
	if skin.highContrastTexture then
		atlases[#atlases+1] = {
			key = skin.id.."_2",
			path = skin.highContrastTexture,
			px = 71,
			py = 95,
			atlas_table = 'ASSET_ATLAS',
		}
	end

	if allSuits then
		for i, suit in ipairs(vanilla_suits) do
			deckskins[i] = {}
			deckskins[i].key = skin.id.."_"..suit
			deckskins[i].suit = suit
			deckskins[i].ranks = cards
			deckskins[i].display_ranks = cards
			deckskins[i].lc_atlas = skin.id.."_1"
			deckskins[i].hc_atlas = skin.highContrastTexture ~= nil and skin.id.."_2" or skin.id.."_1"
			deckskins[i].loc_txt = loc
			deckskins[i].pos_style = "deck"
		end
	else
		deckskins[#deckskins+1] = {}
		deckskins[#deckskins].key = skin.id
		deckskins[#deckskins].suit = suit
		deckskins[#deckskins].ranks = cards
		deckskins[#deckskins].display_ranks = cards
		deckskins[#deckskins].lc_atlas = skin.id.."_1"
		deckskins[#deckskins].hc_atlas = skin.highContrastTexture ~= nil and skin.id.."_2" or skin.id.."_1"
		deckskins[#deckskins].loc_txt = loc
		if skin.cards == two_ace then
			deckskins[#deckskins].pos_style = 'suit'
		else
			deckskins[#deckskins].pos_style = 'ranks'
		end
	end

	loadOutdatedDeckSkin(atlases, deckskins)
end

function recursiveEnumerate(folder)
	local fileTree = ""
	for _, file in ipairs(love.filesystem.getDirectoryItems(folder)) do
		local path = folder .. "/" .. file
		local info = love.filesystem.getInfo(path)
		fileTree = fileTree .. "\n" .. path .. (info.type == "directory" and " (DIR)" or "")
		if info.type == "directory" then
			fileTree = fileTree .. recursiveEnumerate(path)
		end
	end
	return fileTree
end

local files = {}
for s in recursiveEnumerate(usable_path .. "/skins"):gmatch("[^\r\n]+") do
	files[#files + 1] = s:gsub(path_pattern_replace .. "/skins/", "")
end

local SKINS = {}
for _, file in ipairs(files) do
	if file:match("%.lua$") then
		local skin = SMODS.load_file("skins/" .. file)()
		if not skin.id then
			skin.id = file:sub(1, -5)
		end
		table.insert(SKINS, skin)
	end
end

for index, skin in ipairs(SKINS) do
	if skin.priority then
		if type(skin.priority) == 'string' then
			skin.priority = tonumber(skin.priority)
			if not skin.priority then
				sendWarnMessage("Invalid string at priority value for "..skin.id..", could not convert! Defaulting priority to 1000", dsl)
				skin.priority = 1000
			end
		elseif type(skin.priority) ~= 'number' then
			sendWarnMessage("Invalid/Unknown value at priority value for "..skin.id.."! Defaulting priority to 1000.", dsl)
			skin.priority = 1000
		end
	else
		skin.priority = 1000
	end
	skin.priority = skin.priority or 1000
	skin.original_index = index
end

table.sort(SKINS, function(a, b)
	if a.priority ~= b.priority then
		return a.priority < b.priority
	end
	return a.original_index < b.original_index
end)

for _, skin in ipairs(SKINS) do
	assembleOutdatedDeckSkin(skin)
end



-------------------
--- Credits Tab ---
-------------------
SMODS.current_mod.credits_tab = function()

	local text_scale = 0.9
	chosen = true
	return {
		n = G.UIT.ROOT,
		config = { align = "cm", padding = 0.2, colour = G.C.BLACK, r = 0.1, emboss = 0.05, minh = 6, minw = 10 },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.1, outline_colour = G.C.JOKER_GREY, r = 0.1, outline = 1 },
				nodes = {
					{
				n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'Programming by', scale = text_scale * 0.6, colour = G.C.GOLD, shadow = true } },
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'Keku', scale = text_scale * 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = '#Guigui', scale = text_scale * 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0 },
						nodes = {
							{ n = G.UIT.T, config = { text = 'Sbax', scale = text_scale * 0.5, colour = G.C.UI.TEXT_LIGHT, shadow = true } },
						}
					},
				}
			}
		}
	}
end