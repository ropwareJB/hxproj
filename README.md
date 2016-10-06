### hb - Haxe Build tool
**hb** is a Project-level build tool for Haxe projects, it delegates actual building to the classic Haxe compiler.  

The build tool operates at a Project-Target level. You create a new 'project' with it, specify what targets you intend to export to, what haxelib libraries it uses (optional version numbers). Then you can run `hb make` and it'll generate the hxml for your project and passit off to the Haxe compiler.

#### Usage
```
hb project <Projectname> [-t <JS|LUA|SWF|AS3|NEKO|PHP|CPP|CPPIA|CS|JAVA|PYTHON>]
hb lib add <Lib[:Version]>
hb lib remove <Library>
hb lib list
hb lib install
hb lib update
hb make
```

#### Features
+ Haxelib integration
+ Output Prepend
+ Project Manipulation in any subdirectory

#### Inspiration
*Snowkit Flow* - The original great build tool that I used, but had some gripes with. I have a personal disdain for nodejs so I decided to make one to fit my own needs. For Haxe, in Haxe. There are several editor plugins available for it, most notably [For Atom](https://github.com/snowkit/atom-flow), and [Vaxe for Vim](https://github.com/jdonaldson/vaxe).   
[Snowkit Flow Homepage](https://snowkit.github.io/flow/) | [Github](https://github.com/snowkit/flow)  

#### Future Development
+ Neovim + Vim Pluins
+ {JS,CPP,JAVA,CS} Targets
+ Project Skeletons
+ Multiple targets

#### Supported Targets
This project is still in it's infant stages, so only a couple of targets are usable currently.

| Target | Supported | Target | Supported |
| ------ | --------- | ------ | --------- |
| JS | false | PYTHON | true |
| LUA | false | JAVA | false |
| SWF | false | CS | false |
| AS3 | false | CPPIA | false |
| NEKO | false | CPP | false |
| PHP | false | | |

