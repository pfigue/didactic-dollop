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

directory "/var/save/creatingFiles" do
  recursive true
  action :delete
end
directory "/var/save/creatingFiles" do
  owner 'ubuntu'
  group 'root'
  mode '0644'
  action :create
end

for i in 1..25 do
        file "/var/save/creatingFiles/file_#{i}" do
          owner 'root'
          group 'root'
          mode '0644'
          content "/var/save/creatingFiles/file_#{i}"
        end
end
