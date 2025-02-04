> [!CAUTION]
> DEPRECATED. This mod is made for compatibility with an old format for DeckSkins that is no longer used. As such, it is no longer being updated and I will not be giving any more support for it in the Balatro discord. **It will still work**, but I do not reccomend using it. If you can, PLEASE avoid using this, and use the DeckSkin API built into SMODS instead. It may be a bit more complicated, but it provides a much better system with many new features and optimizations. [Check out the SMODS Wiki Page for it here](https://github.com/Steamodded/smods/wiki/SMODS.DeckSkin).

# DeckSkinsLite

A mod for Balatro that simplifies the creation of custom skins for your deck. Custom Deck skins are automatically loaded from the mod's skins folder into the game. DeckSkinsLite is backwards compatible with all skin add-ons created for DeckSkins+, and allows new modders who are inexperienced with LUA to easily make their own skins that can be loaded with DeckSkinsLite.

![Deck Customization Menu](https://i.imgur.com/qoIk2fK.gif)

## Installation

This mod requires [Lovely](https://github.com/ethangreen-dev/lovely-injector) and the latest version **(Version 1.0.0~ALPHA-1030f or later)** of [Steammodded](https://github.com/Steamopollys/Steamodded). Without these dependencies, this mod will not function.

To install DeckSkinsLite, download the contents of this repo as a zip file and extract it into your Balatro mods folder.

## Creating New Deck Skins

All you need is a small .lua file that contains a table of variables in the /skins/ folder, and a 2 textures in the /assets/ folder (a 1x and 2x version).
Check the /.example/ folder for more details on how DeckSkinsLite add-ons are formatted, [or check the Documentation for more details!](https://github.com/Kekulism/DeckSkinsPlus/wiki/Skin-Documentation)

## Credits

Huge thanks to [OneSuchKeeper]([https://github.com/onesuchkeeper]) for converting the previous version of this mod, DeckSkins+, into an API inside Steammodded! Now DeckSkins can be added by anyone even if they don't use this mod :)
