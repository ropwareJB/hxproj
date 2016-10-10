### hxproj - Haxe Build tool
**hxproj** is a Project-level build tool for Haxe projects, it delegates actual building to the classic Haxe compiler.  

The build tool operates at a Project-Target level. You create a new 'project' with it, specify what targets you intend to export to, what haxelib libraries it uses (optional version numbers). Then you can run `hb make` and it'll generate the hxml for your project and passit off to the Haxe compiler.

#### Usage
```
hb create <Projectname> <js|lua|swf|as3|neko|php|cpp|cppia|cs|java|python>]
hb init <Projectname> <js|lua|swf|as3|neko|php|cpp|cppia|cs|java|python>]
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
+ Vaxe Integration

#### Inspiration
*Snowkit Flow* - The original great build tool that I used, but had some gripes with. I have a personal disdain for nodejs so I decided to make one to fit my own needs. For Haxe, in Haxe. There are several editor plugins available for it, most notably [For Atom](https://github.com/snowkit/atom-flow), and [Vaxe for Vim](https://github.com/jdonaldson/vaxe).   
[Snowkit Flow Homepage](https://snowkit.github.io/flow/) | [Github](https://github.com/snowkit/flow)  

#### Future Development
+ {JS,JAVA,CS} Targets
+ Project Skeletons
+ Multiple targets

#### Vaxe Integration
To get integration with Vaxe (so `:make` will run `hb make` and other goodies), use [this fork](https://github.com/Montycarlo/vaxe) of Vaxe. Additions are minimal. Add `let g:vaxe_hxproj=1` to your `.vimrc` or `init.vim` file.

#### Supported Targets
This project is still in it's infant stages, so support is minimal.

| Target | Supported | Target | Supported |
| ------ | --------- | ------ | --------- |
| JS | false | PYTHON | true |
| LUA | false | JAVA | false |
| SWF | false | CS | false |
| AS3 | false | CPPIA | false |
| NEKO | true | CPP | true |
| PHP | true | | |

