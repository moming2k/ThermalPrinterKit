ThermalPrinterKit
=================

This library provides function for you to convert image into Epson TM88 series readable data format.

```
UIImage *logo = [UIImage imageNamed:@"ticket_logo"];
```

**Image data to TM88 readable binary form**

```
NSMutableData *print_data = [IGThermalSupport imageToThermalData:logo];
```

**line cut**

```
NSMutableData *print_data = [IGThermalSupport cutLine];
```