class WorkerBee
  # subclass to hold work tasks
  class Work
    attr_reader :dependencies
    attr_reader :block

    def initialize(dependencies, block)
      @dependencies = dependencies
      @block = block
    end
  end

  @@work_items = Hash.new
  @@work_done = Hash.new
  @@indent = 0

  def self.work_items
    @@work_items
  end

  def self.work_done
    @@work_done
  end

  def self.recipe &block
    # run the block!
    instance_eval(&block)    
  end

  def self.work name, *dependencies, &block
    new_task = WorkerBee::Work.new(dependencies, block)
  
    @@work_items[name] = new_task 
  end

  def self.run item_name
    work_item = @@work_items[item_name]

    puts "running #{item_name}"
 
    # run the dependencies first, in order of definition
    unless work_item.dependencies.nil?
      
      work_item.dependencies.each do |dependency_name|
        
        # status reporting indenting
        @@indent += 1 
        (@@indent * 2).times do
          putc " "
        end

        # run the dependency if it hasn't been run before
        puts "dependency: #{dependency_name} = #{@@work_done[dependency_name].nil?}"
        if @@work_done[dependency_name].nil?
          run(dependency_name)
        else
          puts "not running #{dependency_name} - already met dependency"
        end

      end

    end

    # return the indent to what it was before the dependencies were run
    @@indent = @@indent - work_item.dependencies.length 

    # increment the number of times this work item has been run
    puts "work: #{item_name} = #{@@work_done[item_name].nil?}"
    if @@work_done[item_name].nil?
      puts "did #{item_name}!!!!!!"
      @@work_done[item_name] = 1
      puts "AAAAAAND...#{@@work_done[item_name].nil?}"
    else
      puts "re-did #{item_name}!!!!!"
      @@work_done[item_name] += 1 # increment the execution count for this item
    end

    # run the work item itself
    instance_eval(&work_item.block)
  end
end
