#=
my_colours:
- Julia version: 1.4.1
- Author: khudabukhsh.2
- Date: 2020-05-06
=#

using Colors
using ColorSchemes

RawRGB2RGB(a, b, c) = Colors.RGB{Float64}(a/255, b/255, c/255)

grays = ColorScheme([Colors.RGB{Float64}(i, i, i) for i in 0:0.1:1.0])


blues = ColorScheme([
    RawRGB2RGB(113,199,236),
    RawRGB2RGB(30,187,215),
    RawRGB2RGB(24,154,211),
    RawRGB2RGB(16,125,172),
    RawRGB2RGB(0,80,115)])

reds = ColorScheme([
    RawRGB2RGB(236,30,30),
    RawRGB2RGB(204,29,29),
    RawRGB2RGB(159,37,37),
    RawRGB2RGB(120,31,31),
    RawRGB2RGB(94,22,22)])

greys = ColorScheme([
    RawRGB2RGB(162,162,162),
    RawRGB2RGB(81,81,81),
    RawRGB2RGB(59,59,59),
    RawRGB2RGB(37,37,37),
    RawRGB2RGB(16,16,16)])

forrest = ColorScheme([
    RawRGB2RGB(186,221,215),
    RawRGB2RGB(44,53,73),
    RawRGB2RGB(48,74,90),
    RawRGB2RGB(94,131,110),
    RawRGB2RGB(135,171,112)])

bluegreys = ColorScheme([
    RawRGB2RGB(194,205,216),
    RawRGB2RGB(161,169,180),
    RawRGB2RGB(56,129,184),
    RawRGB2RGB(35,81,116),
    RawRGB2RGB(29,43,73)])

coffee = ColorScheme([
    RawRGB2RGB(236,224,209),
    RawRGB2RGB(219,193,172),
    RawRGB2RGB(216,197,166),
    RawRGB2RGB(112,64,65),
    RawRGB2RGB(56,34,15)])

pinks = ColorScheme([
    RawRGB2RGB(250,236,230),
    RawRGB2RGB(238,207,200),
    RawRGB2RGB(217,178,169),
    RawRGB2RGB(163,126,113)])

browns = ColorScheme([
    RawRGB2RGB(219,201,184),
    RawRGB2RGB(161,126,97),
    RawRGB2RGB(133,88,50),
    RawRGB2RGB(116,72,42),
    RawRGB2RGB(54,41,37)])

browngreen = ColorScheme([
    RawRGB2RGB(221,213,199),
    RawRGB2RGB(184,171,139),
    RawRGB2RGB(139,138,104),
    RawRGB2RGB(105,103,61),
    RawRGB2RGB(60,56,34)])

purplybrown = ColorScheme([
    RawRGB2RGB(182,138,130),
    RawRGB2RGB(161,125,132),
    RawRGB2RGB(139,114,134),
    RawRGB2RGB(116,99,124),
    RawRGB2RGB(92,89,114)])

junglegreen = ColorScheme([
    RawRGB2RGB(133,170,155),
    RawRGB2RGB(88,139,118),
    RawRGB2RGB(41,95,72),
    RawRGB2RGB(32,76,57),
    RawRGB2RGB(24,57,43)])

greens = ColorScheme([
    RawRGB2RGB(148,206,152),
    RawRGB2RGB(97,175,102),
    RawRGB2RGB(56,142,62),
    RawRGB2RGB(27,112,33),
    RawRGB2RGB(6,78,10)])

maroons = ColorScheme([
    RawRGB2RGB(193,113,113),
    RawRGB2RGB(169,76,76),
    RawRGB2RGB(146,68,68),
    RawRGB2RGB(109,54,54),
    RawRGB2RGB(86,36,36)])

cyans = ColorScheme([
    RawRGB2RGB(138,187,187),
    RawRGB2RGB(101,155,150),
    RawRGB2RGB(60,131,132),
    RawRGB2RGB(29,91,95),
    RawRGB2RGB(0,78,82)])
