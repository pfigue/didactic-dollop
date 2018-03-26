group 'ubuntu' do
  gid 1234
  action :create
end

user 'ubuntu' do
  comment 'Ubuntu'
  uid '1234'
  gid 'ubuntu'
  home '/home/ubuntu'
  shell '/bin/bash'
  action :lock
end

group 'ubuntu' do
  action :manage
  members 'ubuntu'
end

%w{multipleCopy1 multipleCopy2 multipleCopy3}.each do |dir|
        directory "/var/save/#{dir}" do
                action :delete
        end
        directory "/var/save/#{dir}" do
          owner 'ubuntu'
          group 'root'
          recursive true
          mode '0644'
          action :create
        end
        file "/var/save/#{dir}/secret.txt" do
           mode '0644'
           owner 'root'
           group 'root'
        end
end
