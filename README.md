[![Actions Status](https://github.com/thundergnat/Color-Names/actions/workflows/test.yml/badge.svg)](https://github.com/thundergnat/Color-Names/actions)

NAME
====

Color::Names - A fairly comprehensive collection of lists of named colors.

This is an extension of the original [Color::Names](https://github.com/holli-holzer/perl6-Color-Names) module by Markus Holzer ( holli.holzer@gmail.com )

It is excellent, but insufficient for my purposes. This module has the same basic functionality but an extended API (:api<2>) and expanded color lists.

The major difference is the data structure for the color database. The original (:api<1>) used the color name as its hash key. Worked, bit only allowed loading one set of color values at a time to prevent collisions.

This module (:api<2) uses a scheme to allow any number of color hashes to be loaded at the same time.

Each color set is stored in a hash with the color name concatonated with the set ID as its key, with the value containing information the color name, its RGB values in an array, and in some cases, a color 'code', an identifying code for that color.

SYNOPSIS
========

```raku
use Color::Names:api<2>;

# a hash of normalized color names / set ID
# with rgb values, a pretty name, and possibly color codes

.say for sort Color::Names.color-data("X11");


# you can mix sets, names are associated with the group
# they came from

.say for sort Color::Names.color-data("X11", "XKCD");


# There is a find-color routine exported you can use to search for partial
# or exact names.

use Color::Names::CSS3;
.say for sort Color::Names.color-data(<CSS3>).&find-color: <Aqua>;
# --> aqua-CSS3             => { rgb => [0 255 255], name => Aqua}
# --> aquamarine-CSS3       => { rgb => [127 255 212], name => Aquamarine}
# --> mediumaquamarine-CSS3 => { rgb => [102 205 170], name => Medium Aquamarine}


.say for sort Color::Names.color-data(<CSS3>).&find-color: <Aqua>, :exact;
# --> aqua-CSS3 => { rgb => [0 255 255], name => Aqua}

use Color::Names::X11 :colors;
say COLORS{'red-X11'};
# --> {name => Red, rgb => [255 0 0]}


# There is also an exported nearest() routine to find the nearest color to a
# given R G B triple.

my %c = Color::Names.color-data(<XKCD>);
say nearest(%c, 152, 215, 150);
# --> [hospitalgreen-XKCD => {name => Hospital Green, rgb => [155 229 170]}]
```

Color name ID fields are the full name (or code) with all non alphanumeric characters removed, with a hyphen and uppercase list name appended.

So `Light Green` from the X11 list would be `lightgreen-X11`. This allows multiple lists to be loaded simultaneously without name conflicts.

DESCRIPTION
===========

There are several color sets that can be loaded, separately, or in combination.

**CSS3** - (141 colors) [W3 CSS 3 standard web colors](https://www.w3schools.com/cssref/css_colors.asp), supported by nearly all browsers and web related software.

**X11** - (422 colors, excluding grey0-grey100) [The X11 color set](https://www.w3schools.com/colors/colors_x11.asp). Not as standardized; there are several variations with minor differences. CSS3 colors are very nearly a proper subset.

**X11-Grey** - (101 colors, only-grey) [The X11 grey scale colors](https://www.w3schools.com/colors/colors_x11.asp). (grey0 through grey100). Separated to make it easier to exclude if desired.

**XCKD** - (954 colors) [The XKCD color collection](https://www.w3schools.com/colors/colors_xkcd.asp), collated by Randall Munroe as a result of an extensive [color survey](https://xkcd.com/color/rgb/) of web citizens.

**NBS** - (267 colors) National Bureau of Standards [standardized color names](https://www.w3schools.com/colors/colors_nbs.asp). Published by the [The National Bureau of Standards - ISCC color group](https://en.wikipedia.org/wiki/ISCC%E2%80%93NBS_system).

**NCS** - (1950 colors) [The Natural Color System](https://www.w3schools.com/colors/colors_ncs.asp) is the color standard (for interior design, decorating, and painting) in Sweden, Spain, Norway and South Africa. Uses color composition codes to label individual colors rather than names.

**Resene** - (1378 colors) [Resene™ color names and non-official approximate RGB values](https://www.w3schools.com/colors/colors_resene.asp) to simulate them on the web. [Resene™](https://www.resene.co.nz/) is a prominent paint/decorating retailer in New Zealand. The [Resene Paints Limited color palettes chart is publicly available on the web](http://www.resene.co.nz/swatches/).

**Crayola** - (315 colors) [Crayola™ color names and approximate RGB values](https://www.w3schools.com/colors/colors_crayola.asp) to simulate them on the web. Crayola™ is a famous color pencil and crayon producer. Their color names are often creative and funny (with no evidence of correlating to web based names). These are not official Crayola™ colors, only RGB approximations.

**RAL-CL** - (213 colors) [RAL Classic colors](https://en.wikipedia.org/wiki/List_of_RAL_colors#RAL_Classic). ('Reichs-Ausschuß für Lieferbedingungen und Gütesicherung' - 'Reich Committee for Delivery and Quality Assurance') Standardized colors used in European countries. Approximations of actual colors. Not to be used for color verification.

**RAL-DSP** - (1822 colors) [RAL Design System Plus colors](https://en.wikipedia.org/wiki/List_of_RAL_colors#RAL_Design_System+). ('Reichs-Ausschuß für Lieferbedingungen und Gütesicherung' - 'Reich Committee for Delivery and Quality Assurance') Expanded, mathematically determined color group following the CIELab system. Approximations of actual colors. Not to be used for color verification.

**FS595B** - (209 colors) [Federal Standard 595B colors](http://www.fed-std-595.com/FS-595-Paint-Spec.htm) Mostly obsolete but still referred to occasionally. Old version of Federal Standard 595 colors previously used in U.S. government procurement. Approximations of actual colors. Not to be used for color verification.

**FS595C** - (589 colors) [Federal Standard 595C colors](https://www.federalstandardcolor.com/). Standard colors used in U.S. government procurement. These are approximate colors. The appearance may vary depending on your monitor settings. Largely superceded by SAE AMS-STD-595, though most, if not all of the colors are exactly the same. Approximations of actual colors. Not to be used for color verification.

If you know about other lists of name/color pairs in use, please let me know.

AUTHOR
======

Original Color::Names code and module: Markus «Holli» Holzer

Extended API and expanded color lists: Stephen Schulze (thundergnat)

LICENSE
=======

Copyright © 2019 Markus Holzer ( holli.holzer@gmail.com ); 2022 Stephen Schulze

Licensed under the BSD-2-Clause License. See LICENSE.

This is free software: you are free to change and redistribute it. There is NO WARRANTY, to the extent permitted by law.

