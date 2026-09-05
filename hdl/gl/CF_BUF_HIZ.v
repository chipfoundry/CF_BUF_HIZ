// Structural PG wrapper. Analog leaf is CF_BUF_HIZ_core.
// Customer rails are vpwr/vgnd; vendor east supplies and well taps are tied inside.
module CF_BUF_HIZ (
    tp,
    vpwr,
    vgnd,
    clk2_boost,
    clk1_boostr,
    vbpt,
    vbpcis,
    vbncis,
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
    input vpwr;
    input vgnd;
    input clk2_boost;
    input clk1_boostr;
    input vbpt;
    inout vbpcis;
    inout vbncis;
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
    CF_BUF_HIZ_core u_core (
        .tp(tp),
        .vpb_a(vpwr),
        .vnb(vgnd),
        .vgnd_a(vgnd),
        .clk2_boost(clk2_boost),
        .clk1_boostr(clk1_boostr),
        .vbpt(vbpt),
        .vbpcis(vbpcis),
        .vbncis(vbncis),
        .vpwr_a(vpwr),
        .vout(vout),
        .vbpci(vbpci),
        .vbnt(vbnt),
        .ibias(ibias),
        .ion(ion),
        .iop(iop),
        .e_pd(e_pd),
        .vbnci(vbnci),
        .vbpcid(vbpcid),
        .vbptd(vbptd),
        .vbnc(vbnc),
        .vbpc(vbpc),
        .en_pd(en_pd),
        .vbpb(vbpb),
        .vinp_n(vinp_n),
        .vinn_n(vinn_n),
        .vinp_na(vinp_na),
        .vinn_na(vinn_na),
        .vinn_p(vinn_p),
        .vinp_p(vinp_p),
        .e_na_boost(e_na_boost),
        .e_n_boost(e_n_boost)
    );
endmodule
