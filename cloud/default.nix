{ pkgs, config, lib, ... }:
let
  location = "hel1";
  nixos-infect = "#cloud-config\nruncmd:\n- curl https://raw.githubusercontent.com/elitak/nixos-infect/8a7527d7965430fdfb98aee208d1f67bdc0af79d/nixos-infect | PROVIDER=hetznercloud NIX_CHANNEL=nixos-unstable bash 2>&1 | tee /tmp/infect.log\n";
in {
  imports = [ ../secrets ];

  # helsinki1
  resource.hcloud_server.helsinki1 = {
    name        = "helsinki1";
    image       = "debian-9";
    server_type = "cpx31";
    location    = location;
    depends_on  = [ "hcloud_network_subnet.subnet" ];
    ssh_keys    = [ "main_key" ];
    # FIXME split to lines
    user_data   = nixos-infect;
  };

  resource.hcloud_rdns.master = {
    server_id  = "\${hcloud_server.helsinki1.id}";
    ip_address = "\${hcloud_server.helsinki1.ipv4_address}";
    dns_ptr    = "kozorezov.ru"; # FIXME
  };

  resource.hcloud_server_network.helsinki1-network = {
    server_id  = "\${hcloud_server.helsinki1.id}";
    network_id = "\${hcloud_network.network.id}";
    ip         = "192.168.3.1";
    alias_ips  = [ ];
  };

  resource.hcloud_network_subnet.subnet = {
    type         = "cloud";
    network_id   = "\${hcloud_network.network.id}";
    network_zone = "eu-central";
    ip_range     = "192.168.3.0/24";
  };

  # network
  resource.hcloud_network.network = {
    name     = "network";
    ip_range = "192.168.0.0/16";
  };

  # base
  terraform = {
    required_providers.hcloud = {
      # FIXME use usual hashicorp/hcloud
      source  = "hetznercloud/hcloud";
      version = "= 1.48.1";
    };
    # pin versions to prevent accidentally changes
    required_version = "= 1.9.8";
  };
  provider.hcloud.token = config.zoo.secrets.others.hetzner.apiToken;
  resource.hcloud_ssh_key.main_key = {
    name       = "main_key";
    public_key = config.zoo.secrets.users.petrkozorezov.authPublicKey;
  };
}
