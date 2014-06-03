class TestDSL

  attr_accessor :name, :content

  def initialize(name)
    @name = name
    @plan_string = ""
  end

  def step(name,*args)
    args_string = ""
    p args
    args.first.each { |k,v| args_string << ",#{k}: #{v}"} if args && args.first
    @plan_string << %Q{plan_action(#{name}#{args_string})\n}

  end



  def parse
    self.instance_eval <<-EOF

      #{content}

    EOF
    p @plan_string
  end

  def content
    %q{
    step 'name_a', :test => 'testing', :test1 => 'testing again' , :test3 => 'and again'
    step 'name_b', test: 'testing', :test2 => "\#{test}"
    step 'c'
    }
  end
end

testclass = TestDSL.new('test')