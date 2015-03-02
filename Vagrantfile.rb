Vagrant.configure('2') do |c|

  ## Plugin
  if Vagrant.has_plugin?("vagrant-cachier")
    c.cache.scope = :box
  end

end
