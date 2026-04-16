class Atomberg_Fan
  def init()
    tasmota.add_cmd('FanSpeed',/c,i,p->self.h_f(p))
  end
  def h_f(p)
    var v=int(p)
    var c=""
    if v==1||v==20 c="0xCFD12E"
    elif v==2||v==40 c="0xCF09F6"
    elif v==3||v==60 c="0xCF51AE"
    elif v==4||v==80 c="0xCFC936"
    elif v==5||v==100 c="0xCF11EE"
    elif p=="0"||p=="off" c="0xCF8976"
    end
    if c!="" tasmota.cmd("IRSend1 {\"Protocol\":\"NEC\",\"Bits\":32,\"Data\":"+c+"}") end
    tasmota.resp_cmnd_done()
  end
  def web_add_main_button()
    import webserver
    webserver.content_send("<iframe name='h' style='display:none;'></iframe><hr><p style='color:#1fa3ec;font-weight:bold;'>Atomberg Fan</p><div style='display:flex;flex-wrap:wrap;justify-content:center;gap:5px;'><a href='cm?cmnd=FanSpeed%200' target='h' style='background:#df4b4b;color:white;padding:8px;text-decoration:none;border-radius:4px;'>OFF</a>")
    for i:1..5
      webserver.content_send("<a href='cm?cmnd=FanSpeed%20"+str(i)+"' target='h' style='background:#1fa3ec;color:white;padding:8px;text-decoration:none;border-radius:4px;'>S"+str(i)+"</a>")
    end
    webserver.content_send("</div>")
  end
end
global.Atomberg_Fan = Atomberg_Fan
