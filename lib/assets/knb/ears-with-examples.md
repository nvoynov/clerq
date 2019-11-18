% Easy approach to requirements syntax (EARS)

# General template

`optional preconditions` `optional trigger` the `system name` shall `system response`.

# Normal behaviour

The `system name` shall `system response`.

## Car

__[car.1]__ The car shall have a maximum retail sale price of XXX.

__[car.2]__ The car shall be compliant with the safety requirements defined in XXX.

## Laptop

__[lap.1]__ The laptop shall have a mass of no more than XXX grams.

__[lap.2]__ The laptop shall have a minimum battery life of XXX hours.

# Unwanted behavior

If `optional preconditions` `trigger`, then the `system name` shall `system response`.

## Car

__[car.1]__ If the car detects attempted intrusion, then the car shall operate the car alarm.

__[car.2]__ If the car detects low oil pressure, then the car shall display a "low oil pressure" warning.

## Laptop

__[lap.1]__ If the incorrect password is entered, then the laptop shall display XXX warning message.

__[lap.2]__ If the laptop is connected to a non-compatible device, then the laptop shall prevent transfer of data, prevent transfer of charge, display XXX warning message and not be damaged.

# Event-driven, When

When `trigger` the `system name` shall `system response`.

## Car

__[car.1]__ When the clutch pedal is depressed, the car shall disengage the driving force.

__[car.2]__ When the "turn indicator" command is received, the car shall operate the indicator lights on the front, side and rear of the vehicle, and provide audible and visual confirmation to the driver.

## Laptop

__[lap.1]__ When the laptop is off and the power button is pressed, the laptop shall boot up.

__[lap.2]__ When the laptop is running and the laptop is closed, the laptop shall enter "powersave" mode.

# State-driven, While

While `in a specific state` the `system name` shall `system response`.

## Car

__[car.1]__ While the ignition is on, the car shall display the fuel level and the oil level to the driver.

__[car.2]__ While the key is in the ignition, the car alarm shall be inhibited.

__[car.3]__ While the handbrake is applied, the wheels shall be locked.

## Laptop

__[lap.1]__ While the laptop is running on the battery and the battery is below XXX % charge, the laptop shall display "low battery".

__[lap.2]__ While an external audio output device is connected, the laptop shall mute the built-in speaker and send the audio output signal to the external audio output device.

# Option, Where

Where `feature is included` the `system name` shall `system response`

## Car

__[car.1]__ Where the car has electric windows, the electric window controls shall be on the driver's door panel.

__[car.2]__ Where the car includes automatic windscreen wipers, the car shall sense moisture on the windscreen and operate the windscreen wipers without driver commands.

## Laptop

__[lap.1]__ Where a "long life" battery is fitted, the laptop shall have a minimum battery life of XXX hours.

__[lap.2]__ Where the laptop is a "lightweight" model, the laptop shall have a mass of no more than XXX grams.

# Complex requirements

## Car

__[car.1]__ Where the car includes an "owner alert"  system, if the car detects attempted intrusion, then the car shall send a message to the owner and activate the car alarm.

__[car.2]__ While the car is being driven forwards above a speed of XXX, if the driver attempts to engage reverse gear, then the car shall prevent engagement of reverse gear.

## Laptop

__[lap.1]__ Where the laptop includes "voice input" option, while the voice input option is selected, the laptop shall accept voice input commands.

__[lap.2]__ While the laptop is running on mains electrical power, if the power cable is disconnected, then the laptop shall display a warning message.
