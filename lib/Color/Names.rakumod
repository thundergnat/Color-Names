unit class Color::Names:ver<2.0.0>:api<2>:auth<zef:thundergnat>;

#use JSON::Fast;

sub find-color ( $colors, Str $needle, :ex(:$exact) ) is export {
  if $exact
  {
    my $name = $colors.keys.first: { $colors{$_}<name>.lc eq $needle.lc };
    $name ?? ( $name => $colors{ $name } ) !! {}
  }
  else
  {
    my @found = $colors.keys.grep: { $colors{$_}<name>.lc.contains: $needle.lc };
    +@found ?? ( @found.map: { $_ => $colors{ $_ } } ) !! {}
  }
}

sub nearest (%c, Int $r, Int $g, Int $b) is export {
  # Uses "sensitivity" scaling values from wikipedia:Color_difference to search
  # for "nearby" colors.

    my @c;
    my $threshold = 1;

    repeat { # Find at least one close color
      @c = %c.grep: {
        3 * abs($r - .value<rgb>[0]) < $threshold and
        4 * abs($g - .value<rgb>[1]) < $threshold and
        2 * abs($b - .value<rgb>[2]) < $threshold
      }
      ++$threshold;
  } until @c.elems;
  @c
}


method color-data( *@sources )
{
  my @valid = <X11 XKCD CSS3 X11-Grey NCS NBS Crayola Resene RAL-CL RAL-DSP FS595B FS595C>;
  my %h;

  for @sources.grep({ $_ ∉ @valid })
  {
    note "Sorry, don't know about $_, only {@valid}"
  }

  for @sources.grep({ $_ ∈ @valid }) -> $source
  {
    my $provider = "Color::Names::$source";
    require ::($provider);
    %h = %h, ::($provider).color-data;
  }

  return %h;
}

=begin pod

=head1 NAME

Color::Names - A fairly comprehensive collection of lists of named colors.

This is an extension of the original L<Color::Names|https://github.com/holli-holzer/perl6-Color-Names> module by
Markus Holzer ( holli.holzer@gmail.com )

It is excellent, but insufficient for my purposes. This module has the same basic functionality
but an extended API (:api<2>) and expanded color lists.

=head1 SYNOPSIS

=begin code :lang<raku>

use Color::Names:api<2>;

# a hash of normalized color names associated
# with rgb values and a pretty name

say Color.Names.color-data("X11");


# you can mix sets, names are associated with the group
# they came from

say Color.Names.color-data("X11", "XKCD");


# There is a find-color routine exported you can use to search for partial
# or exact names.

use Color::Data::CSS3;
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

=end code

Color name ID fields are the full name (or code) with all non alphanumeric
characters removed, with a hyphen and uppercase list name appended.

So C<Light Green> from the X11 list would be C<lightgreen-X11>. This allows multiple
lists to be loaded simultaneously without name conflicts.

=head1 DESCRIPTION

There are several color sets that can be loaded, separately, or in combination.

B<CSS3> - (141 colors) L<W3 CSS 3 standard web colors|https://www.w3schools.com/cssref/css_colors.asp>, supported by nearly all browsers and web related software.


B<X11> - (422 colors, excluding grey0-grey100) L<The X11 color set|https://www.w3schools.com/colors/colors_x11.asp>. Not as standardized; there are several variations with minor differences. CSS3 colors are very nearly a proper subset.


B<X11-Grey> - (101 colors, only-grey) L<The X11 grey scale colors|https://www.w3schools.com/colors/colors_x11.asp>.  (grey0 through grey100). Separated to make it easier to exclude if desired.


B<XCKD> - (954 colors) L<The XKCD color collection|https://www.w3schools.com/colors/colors_xkcd.asp>, collated by Randall Munroe as a result of an extensive L<color survey|https://xkcd.com/color/rgb/> of web citizens.


B<NBS> - (267 colors)  National Bureau of Standards L<standardized color names|https://www.w3schools.com/colors/colors_nbs.asp>. Published by the L<The National Bureau of Standards - ISCC color group|https://en.wikipedia.org/wiki/ISCC%E2%80%93NBS_system>.


B<NCS> - (1950 colors) L<The Natural Color System|https://www.w3schools.com/colors/colors_ncs.asp> is the color standard (for interior design, decorating, and painting) in Sweden, Spain, Norway and South Africa. Uses color composition codes to label individual colors rather than names.


B<Resene> - (1378 colors) L<Resene™ color names and non-official approximate RGB values|https://www.w3schools.com/colors/colors_resene.asp> to simulate them on the web. L<Resene™|https://www.resene.co.nz/> is a prominent paint/decorating retailer in New Zealand. The L<Resene Paints Limited color palettes chart is publicly available on the web|http://www.resene.co.nz/swatches/>.


B<Crayola> - (315 colors) L<Crayola™ color names and approximate RGB values|https://www.w3schools.com/colors/colors_crayola.asp> to simulate them on the web. Crayola™ is a famous color pencil and crayon producer. Their color names are often creative and funny (with no evidence of correlating to web based names). These are not official Crayola™ colors, only RGB approximations.


B<RAL-CL> - (213 colors) L<RAL Classic colors|https://en.wikipedia.org/wiki/List_of_RAL_colors#RAL_Classic>. ('Reichs-Ausschuß für Lieferbedingungen und Gütesicherung' - 'Reich Committee for Delivery and Quality Assurance') Standardized colors used in European countries. Approximations of actual colors. Not to be used for color verification.


B<RAL-DSP> - (1822 colors) L<RAL Design System Plus colors|https://en.wikipedia.org/wiki/List_of_RAL_colors#RAL_Design_System+>. ('Reichs-Ausschuß für Lieferbedingungen und Gütesicherung' - 'Reich Committee for Delivery and Quality Assurance') Expanded, mathematically determined color group following the CIELab system. Approximations of actual colors. Not to be used for color verification.


B<FS595B> - (209 colors) L<Federal Standard 595B colors|http://www.fed-std-595.com/FS-595-Paint-Spec.htm> Mostly obsolete but still referred to occasionally. Old version of Federal Standard 595 colors previously used in U.S. government procurement. Approximations of actual colors. Not to be used for color verification.


B<FS595C> - (589 colors) L<Federal Standard 595C colors|https://www.federalstandardcolor.com/>. Standard colors used in U.S. government procurement. These are approximate colors. The appearance may vary depending on your monitor settings.  Largely superceded by SAE AMS-STD-595, though most, if not all of the colors are exactly the same. Approximations of actual colors. Not to be used for color verification.


If you know about other lists of name/color pairs in use, please let me know.

=head1 AUTHOR

Original Color::Names code and module: Markus «Holli» Holzer

Extended API and expanded color lists: Stephen Schulze (thundergnat)

=head1 LICENSE

Copyright © 2019 Markus Holzer ( holli.holzer@gmail.com ); 2022 Stephen Schulze

Licensed under the BSD-2-Clause License. See LICENSE.

This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

=end pod
