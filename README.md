ThermalPrinterKit
=================

This library provides function for you to convert image into Epson TM88 series readable data format.

UIImage *logo = [UIImage imageNamed:@"ticket_logo"];

Image data to TM88 readable binary form
NSMutableData *print_data = [IGThermalSupport imageToThermalData:logo];
[sock writeData:print_data withTimeout:-1 tag:0];

line cut 
print_data = [IGThermalSupport cutLine];
[sock writeData:print_data withTimeout:-1 tag:0];
