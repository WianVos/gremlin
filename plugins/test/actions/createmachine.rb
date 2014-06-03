require 'pp'
class CreateMachine < Dynflow::Action

  def plan(name, profile, config_options = {})
    prepare_disk = plan_action(PrepareDisk, 'name' => name)
    create_vm    = plan_action(CreateVM,
                               :name => name,
                               :disk => prepare_disk.output['path'])

    pp create_vm.methods
    pp create_vm.output.to_hash
    plan_action(AddIPtoHosts, :name => name, :ip => create_vm.output[:ip])
    plan_action(ConfigureMachine,
                :ip => create_vm.output[:ip],
                :profile => profile,
                :config_options => config_options)
    plan_self(:name => name)
  end

  def finalize

  end

end
