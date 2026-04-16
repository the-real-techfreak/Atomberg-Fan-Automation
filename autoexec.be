import string
import json

class IR_Controller_Driver
    var fan_codes
    def init()
        self.fan_codes = [
            ["Power", "0xCF8976"], ["1", "0xCFD12E"],
            ["2", "0xCF09F6"], ["3", "0xCF51AE"],
            ["4", "0xCFC936"], ["5", "0xCF11EE"]
        ]
        tasmota.add_cmd('FanSpeed', / cmd, idx, payload -> self.handle_fan(payload))
        tasmota.add_cmd('ACMode', / cmd, idx, payload -> self.handle_ac_mode(payload))
        tasmota.add_cmd('ACTemp', / cmd, idx, payload -> self.handle_ac_temp(payload))
    end

    def handle_fan(payload)
        var p = str(payload)
        var code = ""
        if p == "1" || p == "20" code = "0xCFD12E"
        elif p == "2" || p == "40" code = "0xCF09F6"
        elif p == "3" || p == "60" code = "0xCF51AE"
        elif p == "4" || p == "80" code = "0xCFC936"
        elif p == "5" || p == "100" code = "0xCF11EE"
        elif p == "0" || p == "off" || p == "power" code = "0xCF8976"
        end
        if code != "" tasmota.cmd("IRSend1 {\"Protocol\":\"NEC\",\"Bits\":32,\"Data\":" + code + "}") end
        tasmota.resp_cmnd_done()
    end

    def handle_ac_mode(payload)
        var p = str(payload)
        if p == "cool" tasmota.cmd("IRHVAC {\"Vendor\":\"Daikin\",\"Power\":\"On\",\"Mode\":\"Cool\",\"Temp\":22}")
        elif p == "off" tasmota.cmd("IRHVAC {\"Vendor\":\"Daikin\",\"Power\":\"Off\"}")
        end
        tasmota.resp_cmnd_done()
    end

    def handle_ac_temp(payload)
        var t = str(payload)
        tasmota.cmd("IRHVAC {\"Vendor\":\"Daikin\",\"Power\":\"On\",\"Mode\":\"Cool\",\"Temp\":" + t + "}")
        tasmota.resp_cmnd_done()
    end

    def web_add_main_button()
        import webserver
        webserver.content_send("<iframe name='h' style='display:none;'></iframe><hr>")
        
        # --- FAN SECTION ---
        webserver.content_send("<p style='color:#1fa3ec;font-weight:bold;margin-bottom:10px;'>Atomberg Fan</p>")
        webserver.content_send("<div style='text-align:center;margin-bottom:10px;'>")
        webserver.content_send("<a href='cm?cmnd=FanSpeed%200' target='h' style='background:#df4b4b;color:white;padding:8px 20px;text-decoration:none;border-radius:4px;font-size:14px;'>FAN POWER</a>")
        webserver.content_send("</div>")
        
        webserver.content_send("<div style='padding:0 15px;'>")
        webserver.content_send("<input type='range' min='1' max='5' value='1' step='1' style='width:100%;accent-color:#1fa3ec;' onchange=\"fetch('cm?cmnd=FanSpeed%20'+this.value)\">")
        webserver.content_send("<div style='display:flex;justify-content:space-between;font-size:10px;color:#888;'><span>S1</span><span>S2</span><span>S3</span><span>S4</span><span>S5</span></div>")
        webserver.content_send("</div>")

        # --- AC SECTION ---
        webserver.content_send("<p style='color:#2ecc71;font-weight:bold;margin-top:20px;margin-bottom:10px;'>Daikin AC Control</p>")
        webserver.content_send("<div style='display:flex;justify-content:center;gap:10px;margin-bottom:10px;'>")
        webserver.content_send("<a href='cm?cmnd=ACMode%20cool' target='h' style='background:#2ecc71;color:white;padding:8px;text-decoration:none;border-radius:4px;font-size:14px;'>AC ON</a>")
        webserver.content_send("<a href='cm?cmnd=ACMode%20off' target='h' style='background:#95a5a6;color:white;padding:8px;text-decoration:none;border-radius:4px;font-size:14px;'>AC OFF</a>")
        webserver.content_send("</div>")

        # Temperature Slider (Updated Range 18-26)
        webserver.content_send("<div style='padding:0 15px;'>")
        webserver.content_send("<input type='range' min='18' max='26' value='22' step='1' style='width:100%;accent-color:#2ecc71;' oninput=\"this.nextElementSibling.innerText=this.value+'°C'\" onchange=\"fetch('cm?cmnd=ACTemp%20'+this.value)\">")
        webserver.content_send("<div style='text-align:center;font-size:16px;color:#2ecc71;font-weight:bold;margin-top:5px;'>22°C</div>")
        webserver.content_send("</div><br>")
    end
end

var ir_driver = IR_Controller_Driver()
tasmota.add_driver(ir_driver)
