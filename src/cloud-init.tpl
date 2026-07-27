#cloud-config
packages:
%{ for pkg in packages ~}
  - ${pkg}
%{ endfor ~}
runcmd:
%{ for cmd in runcmd ~}
  - ${cmd}
%{ endfor ~}