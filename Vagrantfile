# -*- mode: ruby -*-
# vim: set ft=ruby :
home = ENV['HOME']

MACHINES = {
  :otusraid => {
        :box_name => "centos/7",
#        :box_version => "1.0",
        :ip_addr => '192.168.56.1',
        :disks => {
            :sata1 => {
            :dfile => home + '/VirtualBox\ VMs/sata1.vdi',
            :size => 1024,
            :port => 1
            },
            :sata2 => {
            :dfile => home + '/VirtualBox\ VMs/sata2.vdi',
            :size => 1024, # Megabytes
            :port => 2
	    },
            :sata3 => {
            :dfile => home + '/VirtualBox\ VMs/sata3.vdi',
            :size => 1024,
            :port => 3
            },
            :sata4 => {
            :dfile => home + '/VirtualBox\ VMs/sata4.vdi',
            :size => 1024,
            :port => 4
            },
            :sata5 => {
            :dfile => home + '/VirtualBox\ VMs/sata5.vdi',
            :size => 1024,
            :port => 5
            },
        }
    }
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

      config.vm.define boxname do |box|

          box.vm.box = boxconfig[:box_name]
 #         box.vm.box_version = boxconfig[:box_version]
          box.vm.host_name = boxname.to_s

          box.vm.network "private_network", ip: boxconfig[:ip_addr]

          box.vm.provider :virtualbox do |vb|
                  vb.customize ["modifyvm", :id, "--memory", "256"]
          vb.customize ["storagectl", :id, "--name", "SATA", "--add", "sata" ]

          boxconfig[:disks].each do |dname, dconf|
              unless File.exist?(dconf[:dfile])
                vb.customize ['createhd', '--filename', dconf[:dfile], '--variant', 'Fixed', '--size', dconf[:size]]
              end
              vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', dconf[:port], '--device', 0, '--type', 'hdd', '--medium', dconf[:dfile]]
          end
          end

          box.vm.provision "shell", path: "GPT.sh"

    end
  end
end
