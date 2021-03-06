{ config, lib, pkgs, ... }:
let
  cfg = config.services.haproxy;
  haproxyCfg = pkgs.writeText "haproxy.conf" cfg.config;
in
with lib;
{
  options = {
    services.haproxy = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable HAProxy, the reliable, high performance TCP/HTTP
          load balancer.
        '';
      };

      config = mkOption {
        type = types.lines;
        default =
          ''
          global
            log 127.0.0.1 local6
            maxconn  24000
            daemon
            nbproc 1

          defaults
            mode http
            option httpclose

            # Remove requests from the queue if people press stop button
            option abortonclose

            # Try to connect this many times on failure
            retries 3

            # If a client is bound to a particular backend but it goes down,
            # send them to a different one
            option redispatch

            monitor-uri /haproxy-ping

            timeout connect 7s
            timeout queue   300s
            timeout client  300s
            timeout server  300s

            # Enable status page at this URL, on the port HAProxy is bound to
            stats enable
            stats uri /haproxy-status
            stats refresh 5s
            stats realm Haproxy statistics
          '';
        description = ''
          Contents of the HAProxy configuration file,
          <filename>haproxy.conf</filename>.
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    systemd.services.haproxy = {
      description = "HAProxy";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "forking";
        PIDFile = "/run/haproxy.pid";
        ExecStartPre = "${pkgs.haproxy}/sbin/haproxy -c -q -f ${haproxyCfg}";
        ExecStart = "${pkgs.haproxy}/sbin/haproxy -D -f ${haproxyCfg} -p /run/haproxy.pid";
        ExecReload = "-${pkgs.bash}/bin/bash -c \"exec ${pkgs.haproxy}/sbin/haproxy -D -f ${haproxyCfg} -p /run/haproxy.pid -sf $MAINPID\"";
      };
    };

    environment.systemPackages = [ pkgs.haproxy ];

    users.extraUsers.haproxy = {
      group = "haproxy";
      uid = config.ids.uids.haproxy;
    };

    users.extraGroups.haproxy.gid = config.ids.uids.haproxy;
  };
}
