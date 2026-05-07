// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Wed May  6 21:52:01 2026
// Host        : MTar-L16-W1 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/tomto/Documents/skola/CHILIRISK/RISK-V/project_1.gen/sources_1/ip/blk_mem_gen_0/blk_mem_gen_0_sim_netlist.v
// Design      : blk_mem_gen_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "blk_mem_gen_0,blk_mem_gen_v8_4_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_12,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module blk_mem_gen_0
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_mode = "slave BRAM_PORTA" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_ADDRESS_MODE BYTE_ADDRESS, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [11:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [7:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [7:0]douta;

  wire [11:0]addra;
  wire clka;
  wire [7:0]dina;
  wire [7:0]douta;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [7:0]NLW_U0_doutb_UNCONNECTED;
  wire [11:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [11:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "12" *) 
  (* C_ADDRB_WIDTH = "12" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     2.535699 mW" *) 
  (* C_FAMILY = "artix7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "blk_mem_gen_0.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "4096" *) 
  (* C_READ_DEPTH_B = "4096" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "8" *) 
  (* C_READ_WIDTH_B = "8" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "4096" *) 
  (* C_WRITE_DEPTH_B = "4096" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "8" *) 
  (* C_WRITE_WIDTH_B = "8" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  blk_mem_gen_0_blk_mem_gen_v8_4_12 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[7:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[11:0]),
        .regcea(1'b1),
        .regceb(1'b1),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[11:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[7:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2025.2"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
YqH9kwIC39+qbZg4PSfFsXuB9k9wnuxNryS/CfnEri6Ci9fSC6fsrQ/T/hnt3u/yolbJ8DJa1Qu6
Qnm24A9jLbA+fu3Nsmm6/rM6a4vU6OfVl/gTFd/CiWDutv6Dhn6Lim4uUNPahoOR/A2Yc4Zo2tdI
kMLO9gn9WlH2l3O2oXs=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XJYO2VHd/cnMxQd3i7/2qRhl57dl+doEKuhAunQyv3vpGRG/jlNxj8PqrgLoF0HMdqE3qJUVE/oq
kBSapqjVjLDMOrNGQ+Tc6VGsKMZH8FE/TXHQJ/IM5Iuiu2eozEwwVUomF+7cfqn+9OsVsqCONQ1M
g0oRlangiqasJDhhMfnlGGqwAwmgWRGQA6dmhTuua1s8zdvIv540zY6p5au8cAKVhqyyKK7wbxEE
SGuFqX+NYoyRV+rfWCcWM+hJEmnWS8LNAKkd13YE2+17sPYzUdZ23DmTxXK6KlAxKFW27CBySUfg
qdNXp2DSs2KAQYih27pBNMuHfGbM/ATFPWFvxg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
lYoEi/e8HsDTz6N11EDe/B/iitERmeYndlCklmCluwgb0N4W80JUGVlkd7NlRZHRNhxaNBJPkcjC
n61nO0tb17NwsMwjbY5TF8JWRYTNw1JXCFacvQYrdKv4/7QNQEtwVGiCLxFhOA8aHlWMZIrc2fri
VRMVWaEBcPwCGorlVIM=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
QEw9fEsWFbdX0OQLvYs/gl+zyEOW3ak9TdQVaq+0AXXOT3LIqF7wDxJ6ZBnlf9mNbdsUVH5tAz1o
H8u7ihJl1L3THEvugW+TS8hkvVbEA9rKO2vV15KAj4Lla7UdFT/xDfe79RFarlLI7yGrubjgdoRi
QWy//UKsffG7IWNwmoSuppWiWB4ZHJtkunNyIkm70JPGyZF62VxJg1MTT+5LUbZG5vZjjuHZud9w
xJaKv1tFP/x8RVqLU5gPOqGqTW7/nKO2S+450Vo4D9vAmBVVcXpaL1EbSmCvQ+qJmcQKtf9qYFRV
Zko08hbpHjPxstqvTDro01jRzB8592m4xU2TWA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
TC7q853CWBPPJgbRfgDV1lmjUwSAtliljShAyNFg8sfRfwDzchthzoSPH1UCHV++E2JXacEKq1lB
UWsNP92U4Xh0/Gu+6esOI0pJb8I+TRTxyBN1I4cRQEfQHcwfhbSdeH3yX9OV3opLEqYmT37hWU+J
zCawYnxVESI0FtRzEXve9gdEWlrKKckrT/hp4mvxxOjvOkOSQBvy0elgUOqh6mEOZl+JnUbsR+Wm
CoZLE1eefMZy3FnVmyDNPv3JPXi88aLXMyimal0MYFkTiS4XJiGT3eAIMIbksehXY+eYi/KFpZWQ
GHpX+lG3UmiWWLwyPakFwKEHbrBc70AlJ2eV9g==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2025.1-2029.x", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
j9nmCKgjPWNChPbpSW6EWLrMA6oCG2JGPoum8px09v0PEAh0DRXZi0J8HPzXUsZgOEMcKpA7X54u
YFcDDCLAQ+urha/eSPbQYHQh4yGCursxAQ1C6LEyNQ2wJ0eLlO2bJeAl/gof06zqsYVM2lLJVNv5
wao1k2bmgPdfpfY3c9vPD0fSMuZPS41EoRS0cQhO5GTZnKdjxm6tEUL3GnTjB8ynSCIbCJUsMtAX
4FRHNa52gudx5B5fagR+lXgFhE7e++rWTJELr7SYB+r5Es8qZLTpCH8TrQxEkV0rY/+e4sAjNE2D
gHw8GD7VcUtc15B8y1BbVmh29qc8Nd3V2i/miA==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UkCD6I/Vye4qNoNoa3hIexBXG3xyKUJPAHAjIo7UcNVCDXpMQiYEtPDqExZMfiPlJn2nswCYIfIJ
FYWqMCloKSQyyI/7yZ2EtbyWEklb/P5IyZyvGi6hhFUo/JFTb12b4bK0gZPr+bCDdlVQKTx5GVHz
wptdUJO2omSj8axVMPbLRRtVzlJIZ29dTJ2ATXVXAcBxPnFfHRAMnYYKLeeLExX61vQvpqrkLQHm
XG7hpVzJi56gYKAzxa2BLq072OCVpVS70bfWlhlSTVcSlCrUf+EcarEk4FD8+Ih2NCvrqremG6yn
TtcBn8Xr8M/6zhOYvLi6AD6eArDMKA8n+Ccv8A==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
A5y5QVZU8yjPexRVPioSiAGohCHD5DX5FVobuMyhcgQRExLUhPvnnS8HOtxTj/2IapEcz68gFMGG
Hpi+m725u85/om/Vze9pGIW9Mn328Kz2FIg3W5EvGstfGwY+48LiAGAmTR269JS4lJGVYWYOz7Xk
S8cEsFd2m7j8iyKtARJzD90+UdXq/cIIh725jC9i8nbgxB364zddvm1Z/DF3JRw1qFp6GGcuRai1
KNcJ1j8c9wtIgktpsteU3e5+bxHEw8NT3gWXUFYjm00NDq97Jals8Jjktmum2nQxoF7ivPacfEey
gnSF6jRMkTsZObzc30hAhs0CEtc33hZLhPLHSn8pQ0WyvKJLHdd5s2yckgTZtqxC1Sbwe7WEgNXe
ZMX3pIkz+aoXsAL7GBLyVBMVQcyMoF0w8QGAaTe8sqatABwPqXidYRqNROTf62IYcMpV89XYgaTv
EwIn/oni9KOFd2BFVxRZbFGGC4IjvigsTBUijI+Dk6kVnDh240clGcc4

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Omtp+lCaqUx7Z4qdFj2zrN8LpCkit2eX4hlMtig+ielGm/x4FSZkpjoFmiqdKFPi2eg0pg09MSai
XyGH68UzAR7Xrj8f1jlIoUmMKp4GcxfdqfTeuu7kWGOJEP6cvgTjSJFj2gawDv7f4yZcltnK2x0L
e4GW/rBTmGvZtKWb2ahjINLxPuh3dDaSaWdb+zVgbtyrI5FrjxBkq+aOxSjyNsqnCx1L0uWbxnkl
88NbXN3dTaECXHNm/fsleayM5hKis7kTv9BFajJMGy+BhQlmIYpE+F5zchnTTFUFJZCz1sX9Fc8e
HcY7irB8mR3ajdzjUZLBQEMktp096Nheq3U75A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hpeBLwN9x2ZFDwroYLlUe5GjjDepHik2l0c2s3/6S7JPCRkzQSyt2V1Ad/JewAs/QNp5SXSbYYB4
rQl0My1LDMF3xw43r0g2IbcyHVpPhGp0W5msuQdF67afnsRv90iJYWLMI3QkYGCTWAzl4HrLxFSg
3z8XZRK670IcxznOrlvgHmIKsvubZrBkuc1EynrVb9Nw16QnIx2rc4WgcEXeFf+4i1RoYLDd3gXK
NFCNMdtaRYUThunFP6Z4ViZ5UnDmKq+IMhd31jTaqIlWOBDxPI1+v5RJYxIyTbn4rxlKR2fNbl5/
z4OUjBTd+1GH3I2OXlqmAOvIhpe2Z2HH7nZu/A==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Mt2RhTSUwEIEWeNARbyL+EdfS1UF6nPaL/fKl/7oO2gina93egwCWDLl1fbBtkfaPco0cu4MJ9K3
OraAsyHRlY+MNShmJ1LzAIA1LjZx4y55lu9dlQqSUXR7AW7wVbkg1864mK+hM/1XygU0jvebKNW9
B7xSER+asLO6pxi0mt7uC2PHxLPAYEszFhmnap82TtbDGdQ2qtyekY+ngs+N2fAdsblxVwJruiMl
e6XJ127M8N1mYwhWU2HtRpBOSnnKoHgD9fG51XK/rhk8DxT66QnX9uLPB+H25eDupBJGi1Y5o6x8
hOwZiSUVlBLh7brfzevh7+eRn+7es6wBas0+3w==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 26496)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
