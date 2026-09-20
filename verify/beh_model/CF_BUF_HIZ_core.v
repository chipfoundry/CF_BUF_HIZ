`timescale 1ns / 1ps

// Ideal functional model of analog leaf CF_BUF_HIZ_core.
// Drop this file in place of hdl/gl/CF_BUF_HIZ_core.v for simulation.
// Do not add it to OpenLane VERILOG_FILES.
//
// Analog voltages are Verilog real backdoors (1-bit pins stay digital):
//   vinp_p_v, vinn_p_v, vinp_n_v, vinn_n_v, vinp_na_v, vinn_na_v, vout_v
//
// Assumed protocol (ideal, not silicon-verified):
//   * e_pd or en_pd high → powered down, vout_v = 0
//   * default pair is vinp_p / vinn_p (AFE sensor path)
//   * e_n_boost high selects vinp_n / vinn_n
//   * e_na_boost high selects vinp_na / vinn_na
//   * if both boost enables are high, the n pair wins
//   * vout_v = selected_vinp - selected_vinn (unity differential)
// Boost clocks, test, bias, and analog accuracy are not modeled.

module CF_BUF_HIZ_core (
    tp,
    vpb_a,
    vnb,
    vgnd_a,
    clk2_boost,
    clk1_boostr,
    vbpt,
    vbpcis,
    vbncis,
    vpwr_a,
    vout,
    vbpci,
    vbnt,
    ibias,
    ion,
    iop,
    e_pd,
    vbnci,
    vbpcid,
    vbptd,
    vbnc,
    vbpc,
    en_pd,
    vbpb,
    vinp_n,
    vinn_n,
    vinp_na,
    vinn_na,
    vinn_p,
    vinp_p,
    e_na_boost,
    e_n_boost
);
    input tp;
    inout vpb_a;
    inout vnb;
    inout vgnd_a;
    input clk2_boost;
    input clk1_boostr;
    input vbpt;
    inout vbpcis;
    inout vbncis;
    inout vpwr_a;
    output vout;
    input vbpci;
    input vbnt;
    input ibias;
    inout ion;
    inout iop;
    input e_pd;
    input vbnci;
    input vbpcid;
    input vbptd;
    inout vbnc;
    input vbpc;
    input en_pd;
    input vbpb;
    inout vinp_n;
    inout vinn_n;
    inout vinp_na;
    inout vinn_na;
    inout vinn_p;
    inout vinp_p;
    input e_na_boost;
    input e_n_boost;

    localparam real V_PRESENT = 0.05;

    real vinp_p_v;
    real vinn_p_v;
    real vinp_n_v;
    real vinn_n_v;
    real vinp_na_v;
    real vinn_na_v;
    real vout_v;

    wire powered = ~e_pd & ~en_pd;

    initial begin
        vinp_p_v  = 0.0;
        vinn_p_v  = 0.0;
        vinp_n_v  = 0.0;
        vinn_n_v  = 0.0;
        vinp_na_v = 0.0;
        vinn_na_v = 0.0;
        vout_v    = 0.0;
    end

    always @(*) begin
        if (!powered)
            vout_v = 0.0;
        else if (e_n_boost)
            vout_v = vinp_n_v - vinn_n_v;
        else if (e_na_boost)
            vout_v = vinp_na_v - vinn_na_v;
        else
            vout_v = vinp_p_v - vinn_p_v;
    end

    assign vout = (powered && (vout_v > V_PRESENT)) ? 1'b1 : 1'b0;
    assign ion  = 1'bz;
    assign iop  = 1'bz;
endmodule
