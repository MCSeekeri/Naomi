{
  services.opengfw = {
    enable = true;
    rules = [
      {
        name = "去广告";
        action = "block";
        log = false;
        expr = "geosite(string(tls?.req?.sni), " category-ads ")";
      }
      {
        name = "封锁加密流量";
        action = "block";
        log = true;
        expr = "fet != nil && fet.yes || trojan != nil && trojan.yes";
      }
      {
        name = "丢包 WireGuard";
        action = "drop";
        log = true;
        expr = "wireguard?.handshake_initiation != nil";
      }
      {
        name = "阻断出错的 SNI";
        action = "block";
        log = true;
        expr = "tls?.req?.sni != nil && ip.dst not in concat(lookup(tls.req.sni), lookup(tls.req.sni, \"1.1.1.1:53\"), lookup(tls.req.sni, \"8.8.8.8:53\"))";
      }
      {
        name = "阻断 OpenVPN";
        action = "block";
        log = true;
        expr = "openvpn != nil && openvpn.rx_pkt_cnt + openvpn.tx_pkt_cnt > 50";
      }
      {
        name = "阻断 QUIC";
        action = "block";
        log = true;
        expr = "quic != nil && quic.req != nil";
      }
      {
        name = "非我族类……";
        action = "block";
        log = true;
        expr = "geoip(string(ip.dst), \"cn\") == \"\"";
      }
    ];
  };
}
