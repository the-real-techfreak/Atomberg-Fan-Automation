# Atomberg Fan Integration

The intent of this project is to create a DIY IOT Module that can control the Atomberg Cieling Fan using ESP32 and IR Transmitter.
Though this project is built for Atomberg Fan, the same can be implemented for any fan that can be controlled using IR Remote

This DIY Module is achieved either using Tasmota or ESPHOME, Both methods are explained below

# Hardware Information

Components Used (I used these as I already have these components for a different project):
- D1 Mini ESP32 (https://robu.in/product/mini-kit-esp32-wifi-and-bluetooth-module/)
- IR Transmitter (https://robu.in/product/38khz-infrared-transmit-sensor-module/)
- Charging Brick for 5V supply

# Controlling using ESPHOME Firmware

ESPHOME firmware can be generated either using ESPHOME addon in Home Assistant or by using an ESPHOME docker container.
Installation steps for using ESPHOME are as below. 
- Go to ESPHOME dashboard
- Click Add Device at the bottom right corner of the dashboard
- Follow general steps to on-board the ESP32 module to ESPHOME
- Copy the yaml code from atomberg-fan.yaml in this repository and flash the ".bin" file to your module

Once the device restarts the device gets auto-detected in Home Assistant and the fan can be controlled from HA or the device web url.

# Controlling using Tasmota Firmware

As we are using an ESP32 module for controlling the device, we can make use of Berry scripting for creating a virtual MQTT Fan component which can then be injected into Smart Home hubs like Home Assistant, Homey or Homebridge.

Installation steps are as below
- Flash tasmota32-ir.bin to the ESP32 module and connect to the home wifi
- Once connected to wifi, go to Tools > Manage File System > Create and edit new file
- Create a file named atomberg_fan.be and add the content from the "atomberg_fan.be" from this repository
- If "autoexec.be" is not already created, then create a file named "autoexec.be" by clicking "Create and edit new file" again and add the content from "autoexec.be" from this repository
- If "autoexec.be" already exists, add the content from "autoexec.be" from this repository to the end of the file.
- Click Tools > Console and enter the following commands
```bash
SensorRetain 1
```
```bash
PowerRetain 1
```
```bash
Restart 1
```

On-boarding the Tasmota module into Home Assistant
- Add the following code in the configuration.yaml file in Home Assistant
```bash
mqtt:
  fan:
    - name: "Fan1"
      unique_id: "ir_kit_fan_v5"
      command_topic: "cmnd/ir-dev-1/FanSpeed"
      percentage_command_topic: "cmnd/ir-dev-1/FanSpeed"
      speed_range_min: 1
      speed_range_max: 5
      payload_on: "on"
      payload_off: "off"
      state_topic: "stat/ir-dev-1/RESULT"
      state_value_template: "on"
      optimistic: true
```
Please note that the mqtt topic (ir-dev-1) in command_topic, percentage_command_topic, state_topic needs to be updated with your device's mqtt topic

# Conclusion

My personal preference for flashing to this DIY Module is TASMOTA, as I personally feel it's UI is more intiutive and the device can be used standalone without any Smart Home hub like Home Assistant

