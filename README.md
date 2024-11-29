# DeckSkinsLite

A mod for Balatro that simplifies the creation of custom skins for your deck. Custom Deck skins are automatically loaded from the mod's skins folder into the game. DeckSkinsLite is backwards compatible with all skin add-ons created for DeckSkins+, and allows new modders who are inexperienced with LUA to easily make their own skins that can be loaded with DeckSkinsLite.

![Deck Customization Menu](https://i.imgur.com/qoIk2fK.gif)

## Installation

This mod requires [Lovely](https://github.com/ethangreen-dev/lovely-injector) and the latest version **(Version 1.0.0~ALPHA-1030f or later)** of [Steammodded](https://github.com/Steamopollys/Steamodded). Without these dependencies, this mod will not function.

To install DeckSkinsLite, download the contents of this repo as a zip file and extract it into your Balatro mods folder. 
Inside the Balatro mods folder, make sure the folder you place the contents of the repo does not end with `-main`! Name the folder something like "DeckSkinsLite".

## Creating New Deck Skins

Making an add-on for DeckSkinsLite is super easy!
All you need is a small .lua file that contains a table of variables in the /skins/ folder, and a 2 textures in the /assets/ folder (a 1x and 2x version).
Check the /.example/ folder for more details on how DeckSkinsLite add-ons are formatted, [or check the Documentation for more details!](https://github.com/Kekulism/DeckSkinsPlus/wiki/Skin-Documentation)

## Credits

Huge thanks to [OneSuchKeeper]([https://github.com/onesuchkeeper]) for converting the previous version of this mod, DeckSkins+, into an API inside Steammodded! Now DeckSkins can be added by anyone even if they don't use this mod :)
