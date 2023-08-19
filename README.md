# lcp2pdf
A Typst-based tool to convert lancer lcp content into an pdf in style of the core rulebook

.lcp is a file format used by the CompCon app to display data for equipment for the Lancer tabletop game. A .lcp is just a zipped folder with several .json files in it, which specify the data according to the api laid out in https://github.com/massif-press/lancer-data.

This repository provides a way to read the data files included in the .lcp file and format them into a pdf in the style of the lancer core rulebook. This way, you can use one source to generate both lcp and the manual.

## Usage
If you already have the lcp file, change the file extension to ".zip", and extract the files into the content folder. The application itself uses the [Typst](https://github.com/typst/typst) typesetting system. There are 2 ways to set it up

### Locally through the terminal
- Install Typst as specified in https://github.com/typst/typst#installation
- Compile once with `typst compile --font-path ./fonts lcp2pdf.typ manual.pdf`
- OR setup automatic compilation with `typst watch --font-path ./fonts lcp2pdf.typ manual.pdf`

Alternatively there is a vscode extension for a Typst IDE

### typst.app
There is an in-browser editor for Typst, https://typst.app.
You can duplicate the following project https://typst.app/project/ro8a0upMwPhLAbfdp3vfoj and modify the files in content accordingly. Once you are ready, download the project and compile the relevant files into an lcp as usual.

**NOTE** Due to a limitation with the app, typst.app will not be able to load the compcon font, containing all the lancer icons.

## Additional fields
lcp2pdf accepts some json fields which are ignored by COMP/CON
- **effect_print**
Since the core rulebook explain mechanics in a more descriptive way and does not explicitely format actions that are not reactions, an effect_print field is provided for systems, weapons and weapon mods, which will be displayed only in the manual.

- **img_path (frame)**
Local path to the frames artwork from the compiled file (by default lcp2pdf.typ)

- **logo_path (manufacturer)**
Local path to the manufacturers logo (Unused)

- **artwork_path (manufacturer)**
Local path to the artwork that should be displayed with the manufacturer text

Image paths accept .png, .jpg, .gif, .svg

## Integration into larger document
If you choose to include lcp2pdf in a larger Typst document, you can include it like so
```
// Your entry point to the larger document
#import "lcp2pdf.typ": print_all, style

// To show implement the style guide
#show: style

= Other stuff
#lorem(150)

#display_whole()
```
