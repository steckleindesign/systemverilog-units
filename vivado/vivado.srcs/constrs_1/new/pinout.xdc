# xc7k70t

# 100MHz write clock
set_property -dict { PACKAGE_PIN V20   IOSTANDARD LVCMOS33 } [get_ports { wr_clk }]; #IO_L11P_T1_SRCC_13
create_clock -add -name wr_clk_top -period 10 -waveform {0 5} [get_ports { wr_clk }];

# 100MHz read clock
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports { rd_clk }]; #IO_L12P_T1_SRCC_13
create_clock -add -name rd_clk_top -period 10 -waveform {0 5} [get_ports { rd_clk }];

## GPIO Pins
set_property -dict { PACKAGE_PIN T21   IOSTANDARD LVCMOS33 } [get_ports { wr_rst }]; #IO_L1P_T0_13
set_property -dict { PACKAGE_PIN U22   IOSTANDARD LVCMOS33 } [get_ports { rd_rst }]; #IO_L2P_T0_13


set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { wr_en }]; #IO_L3P_T0_DQS_13
set_property -dict { PACKAGE_PIN W21   IOSTANDARD LVCMOS33 } [get_ports { rd_en }]; #IO_L4P_T0_13

set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { full }]; #IO_L5P_T0_13
#set_property -dict { PACKAGE_PIN K3    IOSTANDARD LVCMOS33 } [get_ports { almost_full  }]; #
set_property -dict { PACKAGE_PIN T20   IOSTANDARD LVCMOS33 } [get_ports { empty }]; #IO_L6P_T0_13
#set_property -dict { PACKAGE_PIN B15   IOSTANDARD LVCMOS33 } [get_ports { almost_empty }]; #

set_property -dict { PACKAGE_PIN Y21   IOSTANDARD LVCMOS33 } [get_ports { din[0] }]; #IO_L7P_T1_13
set_property -dict { PACKAGE_PIN AA20  IOSTANDARD LVCMOS33 } [get_ports { din[1] }]; #IO_L8P_T1_13
set_property -dict { PACKAGE_PIN AA21  IOSTANDARD LVCMOS33 } [get_ports { din[2] }]; #IO_L9P_T1_DQS_13
set_property -dict { PACKAGE_PIN AA19  IOSTANDARD LVCMOS33 } [get_ports { din[3] }]; #IO_L10P_T1_13
set_property -dict { PACKAGE_PIN V20   IOSTANDARD LVCMOS33 } [get_ports { din[4] }]; #IO_L11P_T1_SRCC_13
set_property -dict { PACKAGE_PIN V19   IOSTANDARD LVCMOS33 } [get_ports { din[5] }]; #IO_L12P_T1_MRCC_13
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { din[6] }]; #IO_L13P_T2_MRCC_13
set_property -dict { PACKAGE_PIN W17   IOSTANDARD LVCMOS33 } [get_ports { din[7] }]; #IO_L14P_T2_SRCC_13

set_property -dict { PACKAGE_PIN AA18  IOSTANDARD LVCMOS33 } [get_ports { dout[0] }]; #IO_L15P_T2_DQS_13
set_property -dict { PACKAGE_PIN AB15  IOSTANDARD LVCMOS33 } [get_ports { dout[1] }]; #IO_L16P_T2_13
set_property -dict { PACKAGE_PIN AA16  IOSTANDARD LVCMOS33 } [get_ports { dout[2] }]; #IO_L17P_T2_13
set_property -dict { PACKAGE_PIN AA14  IOSTANDARD LVCMOS33 } [get_ports { dout[3] }]; #IO_L18P_T2_13
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { dout[4] }]; #IO_L19P_T3_13
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { dout[5] }]; #IO_L20P_T3_13
set_property -dict { PACKAGE_PIN W16   IOSTANDARD LVCMOS33 } [get_ports { dout[6] }]; #IO_L21P_T3_DQS_13
set_property -dict { PACKAGE_PIN W14   IOSTANDARD LVCMOS33 } [get_ports { dout[7] }]; #IO_L22P_T3_13
