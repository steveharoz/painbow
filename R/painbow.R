# XKCD's supposedly "bad" colormap https://xkcd.com/2537/
# By Steve Haroz
# License: CC-BY

require("ggplot2")

# define the XKCD "painbow" colormap (extracted from the image)
xkcd_colors = c( '#FFFFFF', '#FEFEFF', '#FAFAFC', '#F4F4F7', '#EBECF1', '#E4E4EC', '#DBDAE6', '#D1D1DE', '#C7C7D5', '#BBBDCB', '#AFB3C3', '#A4A7BA', '#999CB0', '#8F91A6', '#87899D', '#7E8193', '#747788', '#6A6D7C', '#626170', '#575765', '#4C4C57', '#41424B', '#37373E', '#2D2C32', '#242328', '#1B1A1E', '#131313', '#0C0C0A', '#060606', '#010102', '#000000', '#000003', '#00000C', '#000219', '#03092A', '#091239', '#111B49', '#162150', '#1C2756', '#222D5C', '#2A3463', '#333B6A', '#3A4370', '#424B77', '#4A527D', '#515A82', '#576085', '#5D6689', '#606C8B', '#60718C', '#5F758A', '#577985', '#4A7E80', '#407D7B', '#367C72', '#287C69', '#1C7C60', '#147C58', '#0C7D50', '#037D47', '#1E7941', '#247139', '#356632', '#54562B', '#714524', '#8D361D', '#AD2516', '#C91610', '#DF0F0C', '#F20605', '#FD0004', '#FE0302', '#FD0400', '#FD0200', '#FC0401', '#FC0202', '#FA0401', '#F80601', '#F80400', '#F50800', '#F30B01', '#F10A01', '#ED0F00', '#E91101', '#E71302', '#E31401', '#E01400', '#DC1900', '#D91D00', '#D41E00', '#D12001', '#CD2200', '#C52A00', '#C32A00', '#C02B01', '#B83201', '#B53301', '#AF3601', '#AA3A01', '#A63D02', '#A04002', '#9A4502', '#964702', '#914A01', '#8B4F01', '#865202', '#825503', '#7D5904', '#775C03', '#716003', '#6D6304', '#666704', '#606B06', '#5D6F07', '#587207', '#527607', '#4E7908', '#4B7C08', '#467F08', '#418309', '#3E860A', '#38890C', '#348D0C', '#2F900C', '#2E930E', '#2A960E', '#269A0E', '#239D0E', '#1FA00F', '#1CA211', '#1EA411', '#1EA712', '#1CA912', '#1BAC14', '#18AE15', '#13B015', '#0DB216', '#0EB417', '#09B715', '#14BA18', '#13BD1B', '#09C11C', '#0FC41E', '#14C721', '#13CA22', '#1CCC25', '#21CF27', '#27D129', '#2CD32A', '#31D62C', '#37D72F', '#41D932', '#47DB35', '#50DD37', '#57DF3A', '#5CE13D', '#65E23F', '#6BE341', '#76E343', '#80E547', '#85E749', '#8BE84D', '#91E950', '#98EB53', '#A1EB56', '#A7ED58', '#ABEE5B', '#B2EE5E', '#BAEE61', '#BEF064', '#C0F167', '#C5F26A', '#CAF26D', '#CFF173', '#D4F17A', '#D6F181', '#D9F186', '#DBF38B', '#DDF293', '#DEF399', '#E0F29F', '#E2F2A8', '#E3F1AF', '#E3F0B5', '#E4EFBC', '#E4EEC1', '#E5EDC8', '#E5ECCD', '#E6EBD2', '#E6EAD8', '#E7E9DD', '#E7E9E1' )


scale_fill_painbow = function(...) {
  scale_fill_gradientn(
    colors = xkcd_colors,
    values = seq(0, 1, length.out = length(xkcd_colors)),
    ...
  )}

scale_color_painbow = function(...) {
  scale_color_gradientn(
    colors = xkcd_colors,
    values = seq(0, 1, length.out = length(xkcd_colors)),
    ...
  )}

scale_colour_painbow = scale_color_painbow
