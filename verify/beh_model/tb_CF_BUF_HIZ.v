`timescale 1ns / 1ps

// Self-check for the ideal CF_BUF_HIZ behavioral core.
// Instantiates the customer wrap so the sim file list matches integration.

module tb_CF_BUF_HIZ;
    integer errors;

    reg vpwr;
    reg vgnd;
    reg e_pd;
    reg en_pd;
    reg e_n_boost;
    reg e_na_boost;
    reg tp;
    reg clk1_boostr;
    reg clk2_boost;
    reg ibias;
    reg vbpt;
    reg vbnt;
    reg vbpb;
    reg vbpc;
    reg vbpci;
    reg vbnci;
    reg vbpcid;
    reg vbptd;

    wire vout;
    wire vbpcis;
    wire vbncis;
    wire vbnc;
    wire ion;
    wire iop;
    wire vinp_p;
    wire vinn_p;
    wire vinp_n;
    wire vinn_n;
    wire vinp_na;
    wire vinn_na;

    CF_BUF_HIZ u_hiz (
        .tp(tp),
        .vgnd(vgnd),
        .clk2_boost(clk2_boost),
        .clk1_boostr(clk1_boostr),
        .vbpt(vbpt),
        .vbpcis(vbpcis),
        .vbncis(vbncis),
        .vpwr(vpwr),
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

    task expect_v;
        input real got;
        input real exp;
        input real tol;
        input [8*32-1:0] tag;
        begin
            if (got < exp - tol || got > exp + tol) begin
                $display("FAIL %s got=%g exp=%g", tag, got, exp);
                errors = errors + 1;
            end else begin
                $display("PASS %s %g", tag, got);
            end
        end
    endtask

    initial begin
        errors = 0;
        vpwr = 1'b1;
        vgnd = 1'b0;
        e_pd = 1'b0;
        en_pd = 1'b0;
        e_n_boost = 1'b0;
        e_na_boost = 1'b0;
        tp = 1'b0;
        clk1_boostr = 1'b0;
        clk2_boost = 1'b0;
        ibias = 1'b1;
        vbpt = 1'b1;
        vbnt = 1'b1;
        vbpb = 1'b1;
        vbpc = 1'b1;
        vbpci = 1'b1;
        vbnci = 1'b1;
        vbpcid = 1'b0;
        vbptd = 1'b0;

        u_hiz.u_core.vinp_p_v  = 1.2;
        u_hiz.u_core.vinn_p_v  = 0.2;
        u_hiz.u_core.vinp_n_v  = 0.8;
        u_hiz.u_core.vinn_n_v  = 0.1;
        u_hiz.u_core.vinp_na_v = 0.5;
        u_hiz.u_core.vinn_na_v = 0.4;
        #1;
        expect_v(u_hiz.u_core.vout_v, 1.0, 1e-9, "p path");
        if (vout !== 1'b1) begin
            $display("FAIL vout pin not driven on p path");
            errors = errors + 1;
        end

        e_n_boost = 1'b1;
        #1;
        expect_v(u_hiz.u_core.vout_v, 0.7, 1e-9, "n boost");

        e_na_boost = 1'b1;
        #1;
        expect_v(u_hiz.u_core.vout_v, 0.7, 1e-9, "n wins both boosts");

        e_n_boost = 1'b0;
        #1;
        expect_v(u_hiz.u_core.vout_v, 0.1, 1e-9, "na boost");

        e_na_boost = 1'b0;
        e_pd = 1'b1;
        #1;
        expect_v(u_hiz.u_core.vout_v, 0.0, 1e-12, "e_pd");
        if (vout !== 1'b0) begin
            $display("FAIL vout pin not low in e_pd");
            errors = errors + 1;
        end

        e_pd = 1'b0;
        en_pd = 1'b1;
        #1;
        expect_v(u_hiz.u_core.vout_v, 0.0, 1e-12, "en_pd");

        en_pd = 1'b0;
        u_hiz.u_core.vinp_p_v = 0.02;
        u_hiz.u_core.vinn_p_v = 0.0;
        #1;
        expect_v(u_hiz.u_core.vout_v, 0.02, 1e-12, "below V_PRESENT");
        if (vout !== 1'b0) begin
            $display("FAIL vout pin driven below V_PRESENT");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("CF_BUF_HIZ behavioral self-check passed");
        else
            $display("CF_BUF_HIZ behavioral self-check FAILED %0d", errors);
        $finish(errors != 0);
    end
endmodule
