class WorkerBee
  attr_reader :work_list
  attr_reader :work_done

  def initialize
    # Store the list of work to run
    @work_list = []
    # Store the list of dependencies that have already been run
    @work_done = []
  end

  def self.recipe

  end

  def work name, *dependencies, &block
    new_task = WorkerBee::Work.new(name, dependencies, block)
    @work_list << new_task
  end

  def self.run

  end

  # subclass to hold work tasks
  class Work
    attr_reader :name
    attr_reader :dependencies

    def initialize(name, dependencies, block)
      @name = name
      @dependencies = dependencies
      @block = block
    end

  end

end
