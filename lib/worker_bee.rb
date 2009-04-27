class WorkerBee
#  attr_reader :work_items
#  attr_reader :work_done

  @@work_items = Hash.new
  @@work_done = []

#  def initialize
    # Store the list of work to run
 #   @@work_items = []
    # Store the list of dependencies that have already been run
#    @@work_done = []
#  end
  
  def self.work_items
    @@work_items
  end

  def self.work_done
    @@work_done
  end

  def self.recipe &block
    # run the block!
    yield    
  end

  def self.work name, *dependencies, &block
    new_task = WorkerBee::Work.new(dependencies, block)
    @@work_items[name] = new_task 
  end

  def self.run item_name
    # run the work item
  end

  # subclass to hold work tasks
  class Work
    attr_reader :dependencies

    def initialize(dependencies, block)
      @dependencies = dependencies
      @block = block
    end

  end

end
