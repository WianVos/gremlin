class CreateMachine < Dynflow::Action

  def plan(name, profile, config_options = {})
    prepare_disk = plan_action(PrepareDisk, 'name' => name)
    create_vm    = plan_action(CreateVM,
                               :name => name,
                               :disk => prepare_disk.output['path'])
    plan_action(AddIPtoHosts, :name => name, :ip => create_vm.output[:ip])
    plan_action(ConfigureMachine,
                :ip => create_vm.output[:ip],
                :profile => profile,
                :config_options => config_options)
    plan_self(:name => name)
  end

  def finalize
    puts "We've create a machine #{input[:name]}"
  end

end
