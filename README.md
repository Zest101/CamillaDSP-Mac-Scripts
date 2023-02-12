# CamillaDSP-Mac-Scripts

A set of bash utilites for operating with Camilla DSP (https://github.com/HEnquist/camilladsp) and Camilla GUI on Mac. Created for my personal use in my setup (Mac Mini + external USB DAC). 

Assumptions:

1.  Camilla DSP and Camilla GUI should be already installed (in my case they're both installed in ~/CamillaDSP)
2.  Camilla DSP is set up to output audio to external USB DAC

Initial steps:

1.  Create subfolder **control** in Camilla DSP folder (on the same level as config and coeffs folder).
2.  Download archive and unpack it into **control** folder
3.  Copy **common\_settings.txt.template** to **common\_settings.txt** and edit it to reflect your setup:

```
CAMILLA_USER=<your local mac username>
CAMILLA_OUT_DEVICE="<name of your USB DAC Device, use "system_profiler SPAudioDataType" to list available devices>"  
CAMILLA_HOME=<folder where camilladsp is installed>  
CAMILLA_PORT=<CamillaDSP port, default 1234>  
CAMILLA_DAEMON_NAME=<Any unique string literal>  
```
Example:  
```
CAMILLA_USER=Zest
CAMILLA_OUT_DEVICE="E30"  
CAMILLA_HOME=/Users/Zest/CamillaDSP  
CAMILLA_PORT=1234  
CAMILLA_DAEMON_NAME=com.zest101.dsp_on_dac_attach  
```

Scripts: 

1.  **start\_camilladsp.sh**  
	Accurately start Camilla DSP and Camilla GUI (optional -nowait flag leaves them running in background, so that you can close terminal after running this script)
2.  **stop\_camilladsp.sh**  
	Stop both Camilla DSP and Camilla GUI
3.  **enable\_autostart.sh**  
	Set up launchd daemon to automatically start Camilla DSP & GUI when your USB DAC is connected / turned on. Sudo required. DAC should be connected where this script is run. Uses external utility (https://github.com/snosrap/xpc_set_event_stream_handler) to correctly process system USB attach events.
4.  **disable\_autostart.sh**  
	Remove launchd daemon
5.  **set\_filter\_value.sh**  
	Set filter gain for selected filter. Uses jq and websocat.
