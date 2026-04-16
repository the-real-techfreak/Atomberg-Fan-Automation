# Master Loader
print("BRY: Loading sub-scripts...")

load("atomberg_fan.be")
if global.contains("Atomberg_Fan")
    var fan_inst = global.Atomberg_Fan()
    tasmota.add_driver(fan_inst)
    print("BRY: Atomberg Driver Started")
end

print("BRY: All scripts processed")
